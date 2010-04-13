Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533Ab0DMIzO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 04:55:14 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:36602 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab0DMIzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 04:55:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=ghmCak7Z7sALPMVM4GAUkfcHs1GE5/u3XlJxdUYfWgo82rslOsYYysshaJPIXNFYH2
         vzZhLn5sRa6I/XVCsfg3TxEYf8dFpSV7YIjNjSVHAnti2rafGZUNaO94q/e9CKS+kQaC
         K7OK7syNH/zG0hzjJbAaSE87+GnfyNhReSrH8=
MIME-Version: 1.0
Date: Tue, 13 Apr 2010 14:25:11 +0530
Message-ID: <g2h121039231004130155j70b61dedl6b07f149157fe48f@mail.gmail.com>
Subject: DMA Engine API usage
From: melwyn lobo <linux.melwyn@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-arm-kernel@lists.infradead.org\"
	<linux-arm-kernel@lists.infradead.org>, linux-kernel@vger.kernel.org\"" 
	<linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dan,
I have some doubts regarding DMA API usage on its clients for example
MMC, ALSA, USB etc.

I am going to take example of the ALSA framework. Audio data transfer
is initiated in soc_pcm_trigger(). This is called in an atomic
context,
with spinlock held and irqs disabled. Here most drivers enable data
transfer from the MSP peripheral to the audio codec via tx_submit
implementation
of the DMA engine driver. This enqueues the transaction in an active
list which calls for using spinlocks with bottom half disabled.
It is in this function when spin_unlock_bh() is called the kernel
detects irq's disabled and generates a warning.
So the workaround here for ALSA drivers would be to use tasklet or
workqueues to defer calling this in an interruptible context, which
would
cause performance problems (the same function soc_pcm_trigger is
called for stoppping the transfer) in cases where the stream has to be
repeatedly
stopped and started.

So the core issue is use of spin_unlock_bh in an atomic context.
Workaround for removing the warnings would be:
1. Use spin_lock with irqsave and corresponding unlock function which
does not generate a warning in a similar situation.
   But this could be futile in one case where the tasklet is scheduled
from ksoftirqd which could lead to corruption.
   Also this means the interrupts would be disabled (on the local cpu)
till the function executed which is not something
   desirable.
2. Use local_irq_enable() before calling the DMA APIs and disable once
done. This is a crude solution and understandably undesirable and
dangerous.

The DMA Engine framework assumes that the channel interrupt handling
is done in a tasklet (dma_run_dependencies), which I believe is the
reason for the issue.

Regards,
M.

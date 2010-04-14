Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab0DNGmm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 02:42:42 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:56688 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939Ab0DNGml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 02:42:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=b0vfFqgwFUtntEQ/DC1G8TkiKbYMoNjaL840zjhBeJ3L+ShYxgeA6pcLFnZov5ibYM
         XgFZFVd0Ihie/hnWVMCxKIjn4wzM/nMfAknwORTtgS/QIyKayvYmwz0sdBh0GrHcqtNK
         v9y1jB6wFXXm0pBCnRLHtPburnuEg8rwabhh4=
MIME-Version: 1.0
Date: Wed, 14 Apr 2010 12:12:40 +0530
Message-ID: <x2i121039231004132342sa230bfd4k832950fce534113f@mail.gmail.com>
Subject: DMA Engine API performance issues
From: melwyn lobo <linux.melwyn@gmail.com>
To: dan.j.williams@intel.com, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org
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

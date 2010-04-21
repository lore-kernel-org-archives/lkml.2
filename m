Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980Ab0DUQff (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 12:35:35 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:64168 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab0DUQfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 12:35:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=OewbtTNi25DXYzVX/KA74wUApT6c3uyIK7dqN+1xsvlCJtRM17tgAjiZOidLUDR7WZ
         WK0OkaO8XuTfQjpken78X70dnRWUPMRxtBA7E7TeuY4KoGvIbIo46LAzK2t575hEEn5P
         zgUSXgPwHccOj9kvG7IRbAPwuzRsE+NtE0aBk=
MIME-Version: 1.0
Date: Wed, 21 Apr 2010 17:35:32 +0100
Message-ID: <l2u87a5b0801004210935wf6ca2991ua777c39c737391f8@mail.gmail.com>
Subject: Threaded irq handler question
From: Will Newton <will.newton@gmail.com>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I have a threaded irq handler attached to a level-triggered gpio
interrupt line. The check handler checks the status of the gpio line
and disables the irq line amd returns WAKE_THREAD in that case:

static irqreturn_t isr_check(int irq, void *p)
{
        if (gpio_status()) {
                disable_irq_nosync(irq);
                return IRQ_WAKE_THREAD;
        }

        return IRQ_NONE;
}

The thread then does some i2c transactions that will eventually
deassert the gpio line:

static irqreturn_t isr(int irq, void *p)
{
        /* do some i2c transfers */
        enable_irq(irq);
        return IRQ_HANDLED;
}

My problem is that this structure does not work, because once I call
disable_irq_nosync() on the irq in the check handler the thread will
no longer run because the irq is disabled. However if I don't call
disable_irq_nosync() I will get endless irqs because the line is
level-triggered and will not be deasserted until the thread has run.

Could someone tell me what I'm doing wrong here?

Thanks,

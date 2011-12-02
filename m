Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450Ab1LBXVs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 18:21:48 -0500
Received: from www.linutronix.de ([62.245.132.108]:49614 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab1LBXVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 18:21:47 -0500
Date: Sat, 3 Dec 2011 00:21:46 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ido Yariv <ido@wizery.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] genirq: Flush the irq thread on synchronization
In-Reply-To: <1322843052-7166-1-git-send-email-ido@wizery.com>
Message-ID: <alpine.LFD.2.02.1112022345300.2735@ionos>
References: <1322843052-7166-1-git-send-email-ido@wizery.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Dec 2011, Ido Yariv wrote:

> The current implementation does not always flush the threaded handler
> when disabling the irq. In case the irq handler was called, but the
> threaded handler hasn't started running yet, the interrupt will be
> flagged as pending, and the handler will not run. This implementation
> has some issues:
> 
> First, if the interrupt is a wake source and flagged as pending, the
> system will not be able to suspend.
> 
> Second, when quickly disabling and re-enabling the irq, the threaded
> handler might continue to run after the irq is re-enabled without the
> irq handler being called first. This might be an unexpected behavior.

I'd wish people would stop calling disable/enable_irq() in loops and
circles for no reason.

> In addition, it might be counter-intuitive that the threaded handler
> will not be called even though the irq handler was called and returned
> IRQ_WAKE_THREAD.
> 
> Fix this by always waiting for the threaded handler to complete in
> synchronize_irq().

I can see your problem, but this might lead to threads_active leaks
under certain conditions. desc->threads_active was only meant to deal
with shared interrupts.

We explicitely allow a design where the primary handler can leave the
device interrupt enabled and allow further interrupts to occur while
the handler is running. We only have a single bit to note that the
thread should run, but your wakeup would up the threads_active count
in that scenario several times w/o a counterpart which decrements it.

The solution for this is to keep the current threads_active semantics
and make the wait function different. Instead of waiting for
threads_active to become 0 it should wait for threads_active == 0 and
the IRQTF_RUNTHREAD for all actions to be cleared. To avoid looping
over the actions, we can take a similar approach as we take with the
desc->threads_oneshot bitfield.

Thanks,

	tglx



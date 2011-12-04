Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab1LDTJl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 14:09:41 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55421 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754385Ab1LDTJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 14:09:39 -0500
Date: Sun, 4 Dec 2011 21:09:32 +0200
From: Ido Yariv <ido@wizery.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] genirq: Flush the irq thread on synchronization
Message-ID: <20111204190932.GO32400@WorkStation>
References: <1322843052-7166-1-git-send-email-ido@wizery.com>
 <alpine.LFD.2.02.1112022345300.2735@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1112022345300.2735@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Sat, Dec 03, 2011 at 12:21:46AM +0100, Thomas Gleixner wrote:
> I can see your problem, but this might lead to threads_active leaks
> under certain conditions. desc->threads_active was only meant to deal
> with shared interrupts.
> 
> We explicitely allow a design where the primary handler can leave the
> device interrupt enabled and allow further interrupts to occur while
> the handler is running. We only have a single bit to note that the
> thread should run, but your wakeup would up the threads_active count
> in that scenario several times w/o a counterpart which decrements it.
> 
> The solution for this is to keep the current threads_active semantics
> and make the wait function different. Instead of waiting for
> threads_active to become 0 it should wait for threads_active == 0 and
> the IRQTF_RUNTHREAD for all actions to be cleared. To avoid looping
> over the actions, we can take a similar approach as we take with the
> desc->threads_oneshot bitfield.

Thanks for reviewing this.

I might be missing something, but I don't see any potential
threads_active leaks in this approach. We wont increase threads_active
if IRQTF_RUNTHREAD was already set beforehand (as test_and_set_bit()
will return 1).

If irq_wake_thread is called multiple times before irq_thread has had a
chance to run, threads_active will only be increased once and decreased
back when IRQTF_RUNTHREAD is cleared.

Am I missing something? If not, do you see any other issues with this
implementation?

Thanks,
Ido.

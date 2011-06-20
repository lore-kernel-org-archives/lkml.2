Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917Ab1FTLOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 07:14:20 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41349 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab1FTLOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 07:14:17 -0400
Date: Mon, 20 Jun 2011 12:13:36 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH] ARM: smp: Fix the CPU hotplug race with scheduler.
Message-ID: <20110620111336.GG2082@n2100.arm.linux.org.uk>
References: <1308561839-18407-1-git-send-email-santosh.shilimkar@ti.com> <20110620095053.GA2082@n2100.arm.linux.org.uk> <20110620101438.GD2082@n2100.arm.linux.org.uk> <4DFF20B3.7010209@ti.com> <20110620104415.GF2082@n2100.arm.linux.org.uk> <4DFF255E.5030308@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DFF255E.5030308@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 04:17:58PM +0530, Santosh Shilimkar wrote:
> Yes. It's because of interrupt and the CPU active-online
> race.

I don't see that as a conclusion from this dump.

> Here is the chash log..
> [   21.025451] CPU1: Booted secondary processor
> [   21.025451] CPU1: Unknown IPI message 0x1
> [   21.029113] Switched to NOHz mode on CPU #1
> [   21.029174] BUG: spinlock lockup on CPU#1, swapper/0, c06220c4

That's the xtime seqlock.  We're trying to update the xtime from CPU1,
which is not yet online and not yet active.  That's fine, we're just
spinning on the spinlock here, waiting for the other CPUs to release
it.

But what this is saying is that the other CPUs aren't releasing it.
The cpu hotplug code doesn't hold the seqlock either.  So who else is
holding this lock, causing CPU1 to time out on it.

The other thing is that this is only supposed to trigger after about
one second:

        u64 loops = loops_per_jiffy * HZ;
                for (i = 0; i < loops; i++) {
                        if (arch_spin_trylock(&lock->raw_lock))
                                return;
                        __delay(1);
                }

which from the timings you have at the beginning of your printk lines
is clearly not the case - it's more like 61us.

Are you running with those h/w timer delay patches?

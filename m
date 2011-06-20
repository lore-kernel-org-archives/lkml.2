Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab1FTLv6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 07:51:58 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:56820 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751139Ab1FTLv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 07:51:56 -0400
Message-ID: <4DFF3454.30507@ti.com>
Date: Mon, 20 Jun 2011 17:21:48 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH] ARM: smp: Fix the CPU hotplug race with scheduler.
References: <1308561839-18407-1-git-send-email-santosh.shilimkar@ti.com> <20110620095053.GA2082@n2100.arm.linux.org.uk> <20110620101438.GD2082@n2100.arm.linux.org.uk> <4DFF20B3.7010209@ti.com> <20110620104415.GF2082@n2100.arm.linux.org.uk> <4DFF255E.5030308@ti.com> <20110620111336.GG2082@n2100.arm.linux.org.uk> <4DFF2E37.8030602@ti.com> <20110620114019.GH2082@n2100.arm.linux.org.uk>
In-Reply-To: <20110620114019.GH2082@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/20/2011 5:10 PM, Russell King - ARM Linux wrote:
> On Mon, Jun 20, 2011 at 04:55:43PM +0530, Santosh Shilimkar wrote:
>> On 6/20/2011 4:43 PM, Russell King - ARM Linux wrote:
>>> On Mon, Jun 20, 2011 at 04:17:58PM +0530, Santosh Shilimkar wrote:
>>>> Yes. It's because of interrupt and the CPU active-online
>>>> race.
>>>
>>> I don't see that as a conclusion from this dump.
>>>
>>>> Here is the chash log..
>>>> [   21.025451] CPU1: Booted secondary processor
>>>> [   21.025451] CPU1: Unknown IPI message 0x1
>>>> [   21.029113] Switched to NOHz mode on CPU #1
>>>> [   21.029174] BUG: spinlock lockup on CPU#1, swapper/0, c06220c4
>>>
>>> That's the xtime seqlock.  We're trying to update the xtime from CPU1,
>>> which is not yet online and not yet active.  That's fine, we're just
>>> spinning on the spinlock here, waiting for the other CPUs to release
>>> it.
>>>
>>> But what this is saying is that the other CPUs aren't releasing it.
>>> The cpu hotplug code doesn't hold the seqlock either.  So who else is
>>> holding this lock, causing CPU1 to time out on it.
>>>
>>> The other thing is that this is only supposed to trigger after about
>>> one second:
>>>
>>>           u64 loops = loops_per_jiffy * HZ;
>>>                   for (i = 0; i<   loops; i++) {
>>>                           if (arch_spin_trylock(&lock->raw_lock))
>>>                                   return;
>>>                           __delay(1);
>>>                   }
>>>
>>> which from the timings you have at the beginning of your printk lines
>>> is clearly not the case - it's more like 61us.
>>>
>>> Are you running with those h/w timer delay patches?
>> Nope.
>
> Ok.  So loops_per_jiffy must be too small.  My guess is you're using an
> older kernel without 71c696b1 (calibrate: extract fall-back calculation
> into own helper).
>
I am on V3.0-rc3+(latest mainline) and the above commit is already
part of it.

> The delay calibration code used to start out by setting:
>
> 	loops_per_jiffy = (1<<12);
>
> This will shorten the delay right down, and that's probably causing these
> false spinlock lockup bug dumps.
>
> Arranging for IRQs to be disabled across the delay calibration just avoids
> the issue by preventing any spinlock being taken.
>
> The reason that CPU#0 also complains about spinlock lockup is that for
> some reason CPU#1 never finishes its calibration, and so the loop also
> times out early on CPU#0.
>
I am not sure but what I think is happening is as soon as interrupts
start firing, as part of IRQ handling, scheduler will try to
enqueue softIRQ thread for newly booted CPU since it sees that
it's active and ready. But that's failing and both CPU's
eventually lock-up. But I may be wrong here.

> Of course, fiddling with this global variable in this way is _not_ a good
> idea while other CPUs are running and using that variable.
>
> We could also do with implementing trigger_all_cpu_backtrace() to get
> backtraces from the other CPUs when spinlock lockup happens...

Any pointers on the other question about "why we need to enable
interrupts before the CPU is ready?"

Regards
Santosh


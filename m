Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab1FTKfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 06:35:43 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35269 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692Ab1FTKfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 06:35:40 -0400
Date: Mon, 20 Jun 2011 11:35:21 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH] ARM: smp: Fix the CPU hotplug race with scheduler.
Message-ID: <20110620103521.GE2082@n2100.arm.linux.org.uk>
References: <1308561839-18407-1-git-send-email-santosh.shilimkar@ti.com> <20110620095053.GA2082@n2100.arm.linux.org.uk> <20110620101438.GD2082@n2100.arm.linux.org.uk> <4DFF20B3.7010209@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DFF20B3.7010209@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 03:58:03PM +0530, Santosh Shilimkar wrote:
> On 6/20/2011 3:44 PM, Russell King - ARM Linux wrote:
>> On Mon, Jun 20, 2011 at 10:50:53AM +0100, Russell King - ARM Linux wrote:
>>> On Mon, Jun 20, 2011 at 02:53:59PM +0530, Santosh Shilimkar wrote:
>>>> The current ARM CPU hotplug code suffers from couple of race conditions
>>>> in CPU online path with scheduler.
>>>> The ARM CPU hotplug code doesn't wait for hot-plugged CPU to be marked
>>>> active as part of cpu_notify() by the CPU which brought it up before
>>>> enabling interrupts.
>>>
>>> Hmm, why not just move the set_cpu_online() call before notify_cpu_starting()
>>> and add the wait after the set_cpu_online() ?
>>
>> Actually, the race is caused by the CPU being marked online (and therefore
>> available for the scheduler) but not yet active (the CPU asking this one
>> to boot hasn't run the online notifiers yet.)
>>
> Scheduler uses the active mask and not online mask. For schedules CPU
> is ready for migration as soon as it is marked as active and that's
> the reason, interrupts should never be enabled before CPU is marked
> as active in online path.
>
>> This, I feel, is a fault of generic code.  If the CPU is not ready to have
>> processes scheduled on it (because migration is not initialized) then we
>> shouldn't be scheduling processes on the new CPU yet.
>>
>> In any case, this should close the window by ensuring that we don't receive
>> an interrupt in the online-but-not-active case.  Can you please test?
>>
> No it doesn't work. I still get the crash. The important point
> here is not to enable interrupts before CPU is marked
> as online and active.

But we can't do that.

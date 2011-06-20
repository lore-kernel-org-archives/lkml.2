Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949Ab1FTKpp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 06:45:45 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:57120 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750758Ab1FTKpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 06:45:44 -0400
Message-ID: <4DFF24D0.202@ti.com>
Date: Mon, 20 Jun 2011 16:15:36 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH] ARM: smp: Fix the CPU hotplug race with scheduler.
References: <1308561839-18407-1-git-send-email-santosh.shilimkar@ti.com> <20110620095053.GA2082@n2100.arm.linux.org.uk> <20110620101438.GD2082@n2100.arm.linux.org.uk> <4DFF20B3.7010209@ti.com> <20110620103521.GE2082@n2100.arm.linux.org.uk>
In-Reply-To: <20110620103521.GE2082@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/20/2011 4:05 PM, Russell King - ARM Linux wrote:
> On Mon, Jun 20, 2011 at 03:58:03PM +0530, Santosh Shilimkar wrote:
>> On 6/20/2011 3:44 PM, Russell King - ARM Linux wrote:
>>> On Mon, Jun 20, 2011 at 10:50:53AM +0100, Russell King - ARM Linux wrote:
>>>> On Mon, Jun 20, 2011 at 02:53:59PM +0530, Santosh Shilimkar wrote:
>>>>> The current ARM CPU hotplug code suffers from couple of race conditions
>>>>> in CPU online path with scheduler.
>>>>> The ARM CPU hotplug code doesn't wait for hot-plugged CPU to be marked
>>>>> active as part of cpu_notify() by the CPU which brought it up before
>>>>> enabling interrupts.
>>>>
>>>> Hmm, why not just move the set_cpu_online() call before notify_cpu_starting()
>>>> and add the wait after the set_cpu_online() ?
>>>
>>> Actually, the race is caused by the CPU being marked online (and therefore
>>> available for the scheduler) but not yet active (the CPU asking this one
>>> to boot hasn't run the online notifiers yet.)
>>>
>> Scheduler uses the active mask and not online mask. For schedules CPU
>> is ready for migration as soon as it is marked as active and that's
>> the reason, interrupts should never be enabled before CPU is marked
>> as active in online path.
>>
>>> This, I feel, is a fault of generic code.  If the CPU is not ready to have
>>> processes scheduled on it (because migration is not initialized) then we
>>> shouldn't be scheduling processes on the new CPU yet.
>>>
>>> In any case, this should close the window by ensuring that we don't receive
>>> an interrupt in the online-but-not-active case.  Can you please test?
>>>
>> No it doesn't work. I still get the crash. The important point
>> here is not to enable interrupts before CPU is marked
>> as online and active.
>
> But we can't do that.
Why is that ?
Is it because of calibration or the hotplug start notifies needs to
be called with interrupts enabled ?

Regards
Santosh

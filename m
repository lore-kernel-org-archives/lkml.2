Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab1FTM1M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 08:27:12 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:37782 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752410Ab1FTM1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 08:27:09 -0400
Message-ID: <4DFF3C95.1080903@ti.com>
Date: Mon, 20 Jun 2011 17:57:01 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH] ARM: smp: Fix the CPU hotplug race with scheduler.
References: <1308561839-18407-1-git-send-email-santosh.shilimkar@ti.com> <20110620095053.GA2082@n2100.arm.linux.org.uk> <20110620101438.GD2082@n2100.arm.linux.org.uk> <4DFF20B3.7010209@ti.com> <20110620104415.GF2082@n2100.arm.linux.org.uk> <4DFF255E.5030308@ti.com> <20110620111336.GG2082@n2100.arm.linux.org.uk> <4DFF2E37.8030602@ti.com> <20110620114019.GH2082@n2100.arm.linux.org.uk> <4DFF3454.30507@ti.com> <20110620121939.GI2082@n2100.arm.linux.org.uk>
In-Reply-To: <20110620121939.GI2082@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/20/2011 5:49 PM, Russell King - ARM Linux wrote:
> On Mon, Jun 20, 2011 at 05:21:48PM +0530, Santosh Shilimkar wrote:
>> On 6/20/2011 5:10 PM, Russell King - ARM Linux wrote:

[...]

>>
>> Any pointers on the other question about "why we need to enable
>> interrupts before the CPU is ready?"
>
> To ensure that things like the delay loop calibration and twd calibration
> can run, though that looks like it'll run happily enough with the boot
> CPU updating jiffies.
>
I guessed it and had same point as above. Calibration will still
work.

> However, I'm still not taking your patch because I believe its just
> papering over the real issue, which is not as you describe.
>
> You first need to work out why the spinlock lockup detection is firing
> after just 61us rather than the full 1s and fix that.
>
This is possibly because of my script which doesn't wait for 1
second.

> You then need to work out whether you really do have spinlock lockup,
> and if so, why.  Implementing trigger_all_cpu_backtrace() may help to
> find out what CPU#0 is doing, though we can only do that with IRQs on,
> and so would be fragile.
>
> We can test whether CPU#0 is going off to do something else while CPU#1
> is being brought up, by adding a preempt_disable() / preempt_enable()
> in __cpu_up() to prevent the wait-for-cpu#1-online being preempted by
> other threads - I suspect you'll still see spinlock lockup on the
> xtime seqlock on CPU#1 though.  That would suggest a coherency issue.
>
> Finally, how are you provoking this - and what kernel configuration are
> you using?
Latest mainline kernel with omap2plus_defconfig and below simple script
to trigger the failure.

-------------
while true
do
echo 0 > /sys/devices/system/cpu/cpu1/online
echo 1 > /sys/devices/system/cpu/cpu1/online
done


Regards
Santosh

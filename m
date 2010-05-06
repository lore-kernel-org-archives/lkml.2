Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab0EFSnz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 14:43:55 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52177 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978Ab0EFSnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 14:43:53 -0400
MIME-Version: 1.0
In-Reply-To: <1273129281.5605.225.camel@twins>
References: <s2i8bb80c381005051935zd5334eeby28865e9fdb206e55@mail.gmail.com>
	 <1273129281.5605.225.camel@twins>
Date: Thu, 6 May 2010 11:43:52 -0700
Message-ID: <q2t8bb80c381005061143mecd78c28q10c09b476032f668@mail.gmail.com>
Subject: Re: sched: arch_scale_freq_power (and other cpu_power / sched related 
	questions)
From: Mike Chan <mike@android.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 6, 2010 at 12:01 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-05-05 at 19:35 -0700, Mike Chan wrote:
>> Before I end up duplicating a bunch of work in the scheduler / cpufreq
>> / power tracking. I wanted avoid such an figure out what exactly all
>> this existing code is doing. Right now I am just interested in how the
>> kernel is accounting for cpu power, and less on the actual load
>> balancing work. In particular, total power consumed over the lifetime
>> of the system, instead of what seems to be a diminished weighted scale
>> used for all the scheduler cpu_power calculations.
>>
>> kernel/sched.c
>>
>> First, the arch_scale_freq_power() hooks, what are the units that all
>> these calculations are based off of?
>> In update_cup_power() It seems "power" gets multiplied by
>> SCHED_LOAD_SCALE, then >> by SCHED_LOAD_SHIFT. (1024 *=1024) >> 10.
>>
>> For Android, at least with omap, msm, tegra platforms I am attempting
>> to get cpu power tracking (with cpufreq support) and it looks like
>> there is some half-way support with x86.
>>
>> It seems that for x86 the kernel returns the default value, which is
>> SCHED_LOAD_SCALE (1 << 10). Does anyone know how the magic number 1024
>> translates to cpu power consumption (with frequency scaling) in
>> relative or absolute power numbers.
>
> It doesn't.
>
> All the cpu_power stuff is for SMP load-balancing, and basically means
> work-capacity. We normalize the per cpu runqueue weights with the
> cpu_power to get an even (fair) distribution.
>
> Say one cpu only has half the capacity of another cpu, then its not fair
> to given them equal weight, because the tasks on the 'slow' cpu would
> only progress at half the speed of those on the other.
>

I see, I think I've misinterpreted "cpu_power" here. So cpu_power in
this context is the capability (speed / processing power) of the cpu,
not the actual power consumed.

> The cpufreq hooks are there if someone were to peg one cpu at a lower
> frequency than others. Ondemand like thing would still have the capacity
> of the highest frequency (since clearly it would increase the speed once
> there was demand).
>
> Now what exactly are you trying to do?
>

Track how much (cpu) power is consumed by a cpuacct cgroup.

> We have no way of actually accounting the actual power consumed, afaik
> (on x86) there simply is no means of actually measuring the cpu power
> consumption (with recent ACPI-4 there are (optional?) calls to measure
> system power consumption, but that's no good).
>

With cpufreq, we know how much time is spent at each cpu frequency.
With specific board files in mach-* (at least in the ARM world) we can
provide power measurements for frequency X. We can also currently
provide power numbers for cpu idle states.

This means we should be able to calculate the overall power consumed
by the cpu with proper frequency scaling.


I figured if I was doing the pluming for frequency / power scaling for
msm, omap, and tegra platforms on arm, I would at least make some of
the hooks usable for SMP power scaling work you had done. This doesn't
seem likely.

Thanks Peter for clarifying.

-- Mike
>
>

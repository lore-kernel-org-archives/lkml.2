Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab0EFHBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 03:01:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38311 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab0EFHB2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 03:01:28 -0400
Subject: Re: sched: arch_scale_freq_power (and other cpu_power / sched
 related  questions)
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Chan <mike@android.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <s2i8bb80c381005051935zd5334eeby28865e9fdb206e55@mail.gmail.com>
References: <s2i8bb80c381005051935zd5334eeby28865e9fdb206e55@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 06 May 2010 09:01:21 +0200
Message-ID: <1273129281.5605.225.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-05 at 19:35 -0700, Mike Chan wrote:
> Before I end up duplicating a bunch of work in the scheduler / cpufreq
> / power tracking. I wanted avoid such an figure out what exactly all
> this existing code is doing. Right now I am just interested in how the
> kernel is accounting for cpu power, and less on the actual load
> balancing work. In particular, total power consumed over the lifetime
> of the system, instead of what seems to be a diminished weighted scale
> used for all the scheduler cpu_power calculations.
> 
> kernel/sched.c
> 
> First, the arch_scale_freq_power() hooks, what are the units that all
> these calculations are based off of?
> In update_cup_power() It seems "power" gets multiplied by
> SCHED_LOAD_SCALE, then >> by SCHED_LOAD_SHIFT. (1024 *=1024) >> 10.
> 
> For Android, at least with omap, msm, tegra platforms I am attempting
> to get cpu power tracking (with cpufreq support) and it looks like
> there is some half-way support with x86.
> 
> It seems that for x86 the kernel returns the default value, which is
> SCHED_LOAD_SCALE (1 << 10). Does anyone know how the magic number 1024
> translates to cpu power consumption (with frequency scaling) in
> relative or absolute power numbers.

It doesn't.

All the cpu_power stuff is for SMP load-balancing, and basically means
work-capacity. We normalize the per cpu runqueue weights with the
cpu_power to get an even (fair) distribution.

Say one cpu only has half the capacity of another cpu, then its not fair
to given them equal weight, because the tasks on the 'slow' cpu would
only progress at half the speed of those on the other.

The cpufreq hooks are there if someone were to peg one cpu at a lower
frequency than others. Ondemand like thing would still have the capacity
of the highest frequency (since clearly it would increase the speed once
there was demand).

Now what exactly are you trying to do? 

We have no way of actually accounting the actual power consumed, afaik
(on x86) there simply is no means of actually measuring the cpu power
consumption (with recent ACPI-4 there are (optional?) calls to measure
system power consumption, but that's no good).



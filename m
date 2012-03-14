Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030433Ab2CNCVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 22:21:44 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50750 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030336Ab2CNCVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 22:21:34 -0400
MIME-Version: 1.0
In-Reply-To: <4F5FFCC1.2030702@linux.intel.com>
References: <1324426147-16735-1-git-send-email-ccross@android.com>
	<4F1929E9.7070707@linaro.org>
	<8762e8kqi6.fsf@ti.com>
	<4F5FFCC1.2030702@linux.intel.com>
Date: Tue, 13 Mar 2012 19:21:33 -0700
X-Google-Sender-Auth: Bpwo_MytoyuCwS6ttghs_OLQHh0
Message-ID: <CAMbhsRSrS-gwu20Ba5=n_LNUwDh3p+5bQPOymGJ9x5O2Fn28kA@mail.gmail.com>
Subject: Re: [PATCH 0/3] coupled cpuidle state support
From: Colin Cross <ccross@android.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Kevin Hilman <khilman@ti.com>, Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@lists.linux-foundation.org, Len Brown <len.brown@intel.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        linux-omap@vger.kernel.org, linux-tegra@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 7:04 PM, Arjan van de Ven <arjan@linux.intel.com> wrote:
> On 3/13/2012 4:52 PM, Kevin Hilman wrote:
>> Checking the ready_count seemed like an easy way to do this, but did you
>> have any other mechanisms in mind for CPUs to communicate that they've
>> exited/aborted?
>
> this indeed is the tricky part (which I warned about earlier);
> I've spent quite a lot of time (weeks) to get this provably working for
> an Intel system with similar requirements... and it's extremely unfunny,
> and needed firmware support to close some of the race conditions.

As long as you can tell from cpu0 that cpu1 has succesfully entered
the low power state, this should be easy, and the
coupled_cpuidle_parallel_barrier helper should make it even easier.
This series just allows the exact same sequence of transitions used by
hotplug cpufreq governors to happen from the idle thread:

1. cpu0 forces cpu1 offline.  From a wakeup perspective, this is
exactly like hotplug removing cpu1.  Unlike hotplug, the state of cpu1
has to be saved, and the scheduler is not told that the cpu is gone.
Instead of using the IPI signalling that hotplug uses, we call the
same function on both cpus, and one cpu runs the equivalent of
platform_cpu_kill, and the other the equivalent of platform_cpu_die.
Wakeup events that are only targeted at cpu1 will need to be
temporarily migrated to cpu0.
2. If the hotplug is successful, cpu0 goes to a low power state, the
same way it would when the hotplug cpufreq governor had removed cpu1.
3. cpu0 wakes up, because all wakeup events are pointed at it.
4. After restoring its own state, cpu0 brings cpu1 back online,
exactly like hotplug online would, except that the boot vector has to
point to a cpu_resume handler instead of secondary start.

> I sure hope that hardware with these requirements is on the way out...
> it's not very OS friendly.

Even hardware that was designed not not have these requirements
sometimes has bugs that require this kind of sequencing.  OMAP4430
should theoretically support idle without sequencing, but OMAP4460
introduced a ROM code bug that requires sequencing again (turning on
cpu1 corrupts the interrupt controller, so cpu0 has to be waiting with
interrupts off to run a workaround whenever cpu1 turns on).

Out of curiosity, what Intel hardware needs this?

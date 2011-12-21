Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab1LUAJX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 19:09:23 -0500
Received: from mail-ee0-f74.google.com ([74.125.83.74]:64810 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437Ab1LUAJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 19:09:15 -0500
From: Colin Cross <ccross@android.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@lists.linux-foundation.org
Cc: Len Brown <len.brown@intel.com>, Kevin Hilman <khilman@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        linux-omap@vger.kernel.org, linux-tegra@vger.kernel.org,
        Colin Cross <ccross@android.com>
Subject: [PATCH 0/3] coupled cpuidle state support
Date: Tue, 20 Dec 2011 16:09:04 -0800
Message-Id: <1324426147-16735-1-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some ARM SMP SoCs (OMAP4460, Tegra 2, and probably more), the
cpus cannot be independently powered down, either due to
sequencing restrictions (on Tegra 2, cpu 0 must be the last to
power down), or due to HW bugs (on OMAP4460, a cpu powering up
will corrupt the gic state unless the other cpu runs a work
around).  Each cpu has a power state that it can enter without
coordinating with the other cpu (usually Wait For Interrupt, or
WFI), and one or more "coupled" power states that affect blocks
shared between the cpus (L2 cache, interrupt controller, and
sometimes the whole SoC).  Entering a coupled power state must
be tightly controlled on both cpus.

The easiest solution to implementing coupled cpu power states is
to hotplug all but one cpu whenever possible, usually using a
cpufreq governor that looks at cpu load to determine when to
enable the secondary cpus.  This causes problems, as hotplug is an
expensive operation, so the number of hotplug transitions must be
minimized, leading to very slow response to loads, often on the
order of seconds.

This patch series implements an alternative solution, where each
cpu will wait in the WFI state until all cpus are ready to enter
a coupled state, at which point the coupled state function will
be called on all cpus at approximately the same time.

Once all cpus are ready to enter idle, they are woken by an smp
cross call.  At this point, there is a chance that one of the
cpus will find work to do, and choose not to enter suspend.  A
final pass is needed to guarantee that all cpus will call the
power state enter function at the same time.  During this pass,
each cpu will increment the ready counter, and continue once the
ready counter matches the number of online coupled cpus.  If any
cpu exits idle, the other cpus will decrement their counter and
retry.

To use coupled cpuidle states, a cpuidle driver must:

   Set struct cpuidle_device.coupled_cpus to the mask of all
   coupled cpus, usually the same as cpu_possible_mask if all cpus
   are part of the same cluster.  The coupled_cpus mask must be
   set in the struct cpuidle_device for each cpu.

   Set struct cpuidle_device.safe_state to a state that is not a
   coupled state.  This is usually WFI.

   Set CPUIDLE_FLAG_COUPLED in struct cpuidle_state.flags for each
   state that affects multiple cpus.

   Provide a struct cpuidle_state.enter function for each state
   that affects multiple cpus.  This function is guaranteed to be
   called on all cpus at approximately the same time.  The driver
   should ensure that the cpus all abort together if any cpu tries
   to abort once the function is called.

This series was functionally tested on v3.0, but has only been
compile-tested on v3.2 after the removal of per-cpu state fields.

This patch set has a few disadvantages over the hotplug governor,
but I think they are all fairly minor:
   * Worst-case interrupt latency can be increased.  If one cpu
     receives an interrupt while the other is spinning in the
     ready_count loop, the second cpu will be stuck with
     interrupts off until the first cpu finished processing
     its interrupt and exits idle.  This will increase the worst
     case interrupt latency by the worst-case interrupt processing
     time, but should be very rare.
   * Interrupts are processed while still inside pm_idle.
     Normally, interrupts are only processed at the very end of
     pm_idle, just before it returns to the idle loop.  Coupled
     states requires processing interrupts inside
     cpuidle_enter_state_coupled in order to distinguish between
     the smp_cross_call from another cpu that is now idle and an
     interrupt that should cause idle to exit.
     I don't see a way to fix this without either being able to
     read the next pending irq from the interrupt chip, or
     querying the irq core for which interrupts were processed.
   * Since interrupts are processed inside cpuidle, the next
     timer event could change.  The new timer event will be
     handled correctly, but the idle state decision made by
     the governor will be out of date, and will not be revisited.
     The governor select function could be called again every time,
     but this could lead to a lot of work being done by an idle
     cpu if the other cpu was mostly busy.
   * The spinlock that protects requested_state and ready_count is
     should probably be replaced with careful use of atomics and
     barriers.

None of the platforms I work with have an SMP idle implementation
upstream, so I can't easily show a patch that converts a platform
from hotplug governor to coupled cpuidle states.  Instead, I'll
give a quick example implementation assuming functions that handle
hotplug and single-cpu idle already exist.

static int mach_enter_idle_coupled(struct cpuidle_device *dev,
		struct cpuidle_driver *drv, int index)
{
	ktime_t enter, exit;
	s64 us;

	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu);

	enter = ktime_get();

	cpu_pm_enter();

        if (dev->cpu == 0) {
	        for_each_online_cpu(i)
        	        while (i != dev->cpu && !mach_cpu_is_reset(i))
                	        cpu_relax();

		mach_cpu_idle();

		for_each_online_cpu(i)
			if (i != cpu)
				mach_cpu_online(i);
	} else {
		mach_cpu_offline();
	}

	cpu_pm_exit();

	exit = ktime_sub(ktime_get(), enter);
	us = ktime_to_us(exit);

	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &dev->cpu);

	local_irq_enable();

	dev->last_residency = us;

	return index;
}

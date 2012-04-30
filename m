Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905Ab2D3VSJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 17:18:09 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56131 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652Ab2D3VSG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 17:18:06 -0400
MIME-Version: 1.0
In-Reply-To: <1335816551-27756-1-git-send-email-ccross@android.com>
References: <1335816551-27756-1-git-send-email-ccross@android.com>
Date: Mon, 30 Apr 2012 14:18:05 -0700
X-Google-Sender-Auth: Q5UihQyHxkGpZXBOGph7sfUXhPk
Message-ID: <CAMbhsRS+CAXoJvwdNN+iYLQUJR1BYkJD0kBLORyFwtHv7sCcuQ@mail.gmail.com>
Subject: Re: [PATCHv3 0/5] coupled cpuidle state support
From: Colin Cross <ccross@android.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-pm@lists.linux-foundation.org,
        Kevin Hilman <khilman@ti.com>, Len Brown <len.brown@intel.com>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Colin Cross <ccross@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 1:09 PM, Colin Cross <ccross@android.com> wrote:
> On some ARM SMP SoCs (OMAP4460, Tegra 2, and probably more), the
> cpus cannot be independently powered down, either due to
> sequencing restrictions (on Tegra 2, cpu 0 must be the last to
> power down), or due to HW bugs (on OMAP4460, a cpu powering up
> will corrupt the gic state unless the other cpu runs a work
> around).  Each cpu has a power state that it can enter without
> coordinating with the other cpu (usually Wait For Interrupt, or
> WFI), and one or more "coupled" power states that affect blocks
> shared between the cpus (L2 cache, interrupt controller, and
> sometimes the whole SoC).  Entering a coupled power state must
> be tightly controlled on both cpus.
>
> The easiest solution to implementing coupled cpu power states is
> to hotplug all but one cpu whenever possible, usually using a
> cpufreq governor that looks at cpu load to determine when to
> enable the secondary cpus.  This causes problems, as hotplug is an
> expensive operation, so the number of hotplug transitions must be
> minimized, leading to very slow response to loads, often on the
> order of seconds.
>
> This patch series implements an alternative solution, where each
> cpu will wait in the WFI state until all cpus are ready to enter
> a coupled state, at which point the coupled state function will
> be called on all cpus at approximately the same time.
>
> Once all cpus are ready to enter idle, they are woken by an smp
> cross call.  At this point, there is a chance that one of the
> cpus will find work to do, and choose not to enter suspend.  A
> final pass is needed to guarantee that all cpus will call the
> power state enter function at the same time.  During this pass,
> each cpu will increment the ready counter, and continue once the
> ready counter matches the number of online coupled cpus.  If any
> cpu exits idle, the other cpus will decrement their counter and
> retry.
>
> To use coupled cpuidle states, a cpuidle driver must:
>
>   Set struct cpuidle_device.coupled_cpus to the mask of all
>   coupled cpus, usually the same as cpu_possible_mask if all cpus
>   are part of the same cluster.  The coupled_cpus mask must be
>   set in the struct cpuidle_device for each cpu.
>
>   Set struct cpuidle_device.safe_state to a state that is not a
>   coupled state.  This is usually WFI.
>
>   Set CPUIDLE_FLAG_COUPLED in struct cpuidle_state.flags for each
>   state that affects multiple cpus.
>
>   Provide a struct cpuidle_state.enter function for each state
>   that affects multiple cpus.  This function is guaranteed to be
>   called on all cpus at approximately the same time.  The driver
>   should ensure that the cpus all abort together if any cpu tries
>   to abort once the function is called.
>
> This series has been tested by implementing a test cpuidle state
> that uses the parallel barrier helper function to verify that
> all cpus call the function at the same time.
>
> This patch set has a few disadvantages over the hotplug governor,
> but I think they are all fairly minor:
>   * Worst-case interrupt latency can be increased.  If one cpu
>     receives an interrupt while the other is spinning in the
>     ready_count loop, the second cpu will be stuck with
>     interrupts off until the first cpu finished processing
>     its interrupt and exits idle.  This will increase the worst
>     case interrupt latency by the worst-case interrupt processing
>     time, but should be very rare.
>   * Interrupts are processed while still inside pm_idle.
>     Normally, interrupts are only processed at the very end of
>     pm_idle, just before it returns to the idle loop.  Coupled
>     states requires processing interrupts inside
>     cpuidle_enter_state_coupled in order to distinguish between
>     the smp_cross_call from another cpu that is now idle and an
>     interrupt that should cause idle to exit.
>     I don't see a way to fix this without either being able to
>     read the next pending irq from the interrupt chip, or
>     querying the irq core for which interrupts were processed.
>   * Since interrupts are processed inside cpuidle, the next
>     timer event could change.  The new timer event will be
>     handled correctly, but the idle state decision made by
>     the governor will be out of date, and will not be revisited.
>     The governor select function could be called again every time,
>     but this could lead to a lot of work being done by an idle
>     cpu if the other cpu was mostly busy.
>
> v2:
>   * removed the coupled lock, replacing it with atomic counters
>   * added a check for outstanding pokes before beginning the
>     final transition to avoid extra wakeups
>   * made the cpuidle_coupled struct completely private
>   * fixed kerneldoc comment formatting
>   * added a patch with a helper function for resynchronizing
>     cpus after aborting idle
>   * added a patch (not for merging) to add trace events for
>     verification and performance testing
>
> v3:
>   * rebased on v3.4-rc4 by Santosh
>   * fixed decrement in cpuidle_coupled_cpu_set_alive
>   * updated tracing patch to remove unnecessary debugging so
>     it can be merged
>   * made tracing _rcuidle
>
> This series has been tested and reviewed by Santosh and Kevin
> for OMAP4, which has a cpuidle series ready for 3.5, and Tegra
> and Exynos5 patches are in progress.  I think this is ready to
> go in.  Lean, are you maintaining a cpuidle tree for linux-next?
Sorry, *Len.

> If not, I can publish a tree for linux-next, or this could go in
> through Arnd's tree.

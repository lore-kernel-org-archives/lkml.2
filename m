Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587Ab2ATIql (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 03:46:41 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33392 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab2ATIqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 03:46:39 -0500
Message-ID: <4F1929E9.7070707@linaro.org>
Date: Fri, 20 Jan 2012 09:46:33 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Colin Cross <ccross@android.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@lists.linux-foundation.org, Len Brown <len.brown@intel.com>,
        Kevin Hilman <khilman@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        linux-omap@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 0/3] coupled cpuidle state support
References: <1324426147-16735-1-git-send-email-ccross@android.com>
In-Reply-To: <1324426147-16735-1-git-send-email-ccross@android.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2011 01:09 AM, Colin Cross wrote:
> On some ARM SMP SoCs (OMAP4460, Tegra 2, and probably more), the
> cpus cannot be independently powered down, either due to
> sequencing restrictions (on Tegra 2, cpu 0 must be the last to
> power down), or due to HW bugs (on OMAP4460, a cpu powering up
> will corrupt the gic state unless the other cpu runs a work
> around).  Each cpu has a power state that it can enter without
> coordinating with the other cpu (usually Wait For Interrupt, or
> WFI), and one or more "coupled" power states that affect blocks
> shared between the cpus (L2 cache, interrupt controller, and
> sometimes the whole SoC).  Entering a coupled power state must
> be tightly controlled on both cpus.
>
> The easiest solution to implementing coupled cpu power states is
> to hotplug all but one cpu whenever possible, usually using a
> cpufreq governor that looks at cpu load to determine when to
> enable the secondary cpus.  This causes problems, as hotplug is an
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
> cross call.  At this point, there is a chance that one of the
> cpus will find work to do, and choose not to enter suspend.  A
> final pass is needed to guarantee that all cpus will call the
> power state enter function at the same time.  During this pass,
> each cpu will increment the ready counter, and continue once the
> ready counter matches the number of online coupled cpus.  If any
> cpu exits idle, the other cpus will decrement their counter and
> retry.
>
> To use coupled cpuidle states, a cpuidle driver must:
>
>     Set struct cpuidle_device.coupled_cpus to the mask of all
>     coupled cpus, usually the same as cpu_possible_mask if all cpus
>     are part of the same cluster.  The coupled_cpus mask must be
>     set in the struct cpuidle_device for each cpu.
>
>     Set struct cpuidle_device.safe_state to a state that is not a
>     coupled state.  This is usually WFI.
>
>     Set CPUIDLE_FLAG_COUPLED in struct cpuidle_state.flags for each
>     state that affects multiple cpus.
>
>     Provide a struct cpuidle_state.enter function for each state
>     that affects multiple cpus.  This function is guaranteed to be
>     called on all cpus at approximately the same time.  The driver
>     should ensure that the cpus all abort together if any cpu tries
>     to abort once the function is called.
>
> This series was functionally tested on v3.0, but has only been
> compile-tested on v3.2 after the removal of per-cpu state fields.

Hi Colin,

this patchset could be interesting to resolve in a generic way the cpu 
dependencies.
What is the status of this patchset ?

Did you have the opportunity to measure the power consumption with and 
without this patchset ?

Thanks
-- Daniel

-- 
  <http://www.linaro.org/>  Linaro.org │ Open source software for ARM SoCs

Follow Linaro:<http://www.facebook.com/pages/Linaro>  Facebook |
<http://twitter.com/#!/linaroorg>  Twitter |
<http://www.linaro.org/linaro-blog/>  Blog



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab2GRGgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 02:36:39 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:37603 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814Ab2GRGgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 02:36:15 -0400
Message-ID: <50065953.9040904@linux.vnet.ibm.com>
Date: Wed, 18 Jul 2012 12:06:03 +0530
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Carsten Emde <C.Emde@osadl.org>
CC: Len Brown <len.brown@intel.com>, Kevin Hilman <khilman@ti.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] Honor state disabling in the cpuidle ladder governor
References: <20120717185914.063547728@osadl.org> <20120717190330.700421963@osadl.org>
In-Reply-To: <20120717190330.700421963@osadl.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12071720-1618-0000-0000-00000215772D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2012 12:29 AM, Carsten Emde wrote:

> There are two cpuidle governors ladder and menu. While the ladder
> governor is always available, if CONFIG_CPU_IDLE is selected, the
> menu governor additionally requires CONFIG_NO_HZ.
> 
> A particular C state can be disabled by writing to the sysfs file
> /sys/devices/system/cpu/cpuN/cpuidle/stateN/disable, but this mechanism
> is only implemented in the menu governor. Thus, in a system where
> CONFIG_NO_HZ is not selected, the ladder governor becomes default and
> always will walk through all sleep states - irrespective of whether the
> C state was disabled via sysfs or not. The only way to select a specific
> C state was to write the related latency to /dev/cpu_dma_latency and
> keep the file open as long as this setting was required - not very
> practical and not suitable for setting a single core in an SMP system.
> 
> With this patch, the ladder governor only will promote to the next
> C state, if it has not been disabled, and it will demote, if the
> current C state was disabled.


Yes, I agree that currently that disabling a particular C-state
is not reflected in working of ladder governor. This patch is needed
to fix it on ladder too.

Also wanted to clarify on the intended implementation here,
if there are say 5 C-states on a system, disabling 2nd
state would also end by disabling all the remaining 3 deeper states too
as ladder governor enters the lightest state first, and will only move
on to the next deeper state if a idle period was long enough as
per the implementation.
If one is disabling only the deepest state, then it would
work as intended.

Cheers,
Deepthi

> 
> Signed-off-by: Carsten Emde <C.Emde@osadl.org>
> 
> ---
>  drivers/cpuidle/governors/ladder.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> Index: linux-3.4.4-rt14-rc2-64/drivers/cpuidle/governors/ladder.c
> ===================================================================
> --- linux-3.4.4-rt14-rc2-64.orig/drivers/cpuidle/governors/ladder.c
> +++ linux-3.4.4-rt14-rc2-64/drivers/cpuidle/governors/ladder.c
> @@ -88,6 +88,7 @@ static int ladder_select_state(struct cp
> 
>  	/* consider promotion */
>  	if (last_idx < drv->state_count - 1 &&
> +	    !drv->states[last_idx + 1].disable &&
>  	    last_residency > last_state->threshold.promotion_time &&
>  	    drv->states[last_idx + 1].exit_latency <= latency_req) {
>  		last_state->stats.promotion_count++;
> @@ -100,7 +101,8 @@ static int ladder_select_state(struct cp
> 
>  	/* consider demotion */
>  	if (last_idx > CPUIDLE_DRIVER_STATE_START &&
> -	    drv->states[last_idx].exit_latency > latency_req) {
> +	    (drv->states[last_idx].disable ||
> +	    drv->states[last_idx].exit_latency > latency_req)) {
>  		int i;
> 
>  		for (i = last_idx - 1; i > CPUIDLE_DRIVER_STATE_START; i--) {
> 



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab1JJMqt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 08:46:49 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:55254 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab1JJMqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 08:46:47 -0400
Message-ID: <4E92E8E0.4090004@linux.vnet.ibm.com>
Date: Mon, 10 Oct 2011 18:15:20 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: rjw@sisk.pl, bp@amd64.org, pavel@ucw.cz, len.brown@intel.com,
        tj@kernel.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, suresh.b.siddha@intel.com,
        lucas.demarchi@profusion.mobi, rusty@rustcorp.com.au,
        rdunlap@xenotime.net, vatsa@linux.vnet.ibm.com, ashok.raj@intel.com,
        tigran@aivazian.fsnet.co.uk, tglx@linutronix.de, hpa@zytor.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 2/3] Mutually exclude cpu online and suspend/hibernate
References: <20111010123102.15067.23128.stgit@srivatsabhat.in.ibm.com> <20111010123242.15067.48238.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20111010123242.15067.48238.stgit@srivatsabhat.in.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 11101003-3568-0000-0000-00000080200B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2011 06:03 PM, Srivatsa S. Bhat wrote:
> Don't allow cpu hotplug online operation and suspend/hibernate to run in
> parallel. If suspend/hibernate has already started, fail the cpu online
> operation.
> 
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---
> 
>  kernel/cpu.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index 12b7458..bc8c7d4 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -15,6 +15,7 @@
>  #include <linux/stop_machine.h>
>  #include <linux/mutex.h>
>  #include <linux/gfp.h>
> +#include <linux/suspend.h>
> 
>  #ifdef CONFIG_SMP
>  /* Serializes the updates to cpu_online_mask, cpu_present_mask */
> @@ -366,6 +367,14 @@ int __cpuinit cpu_up(unsigned int cpu)
>  	}
>  #endif
> 
> +	/*
> +	 * Prevent cpu online and suspend/hibernate (including freezer)
> +	 * operations from running in parallel. Fail cpu online if suspend or
> +	 * hibernate has already started.
> +	 */
> +	if (!trylock_pm_sleep())

Would it be better to hook into the suspend/hibernate notifiers and
use them to exclude cpu hotplug from suspend/hibernate, instead of
trying to take pm_mutex lock like this?
Peter, I remember you pointing out in another patch's review
(http://thread.gmane.org/gmane.linux.kernel/1198312/focus=1199087)
that introducing more locks in cpu hotplug would be a bad idea. Does that
comment hold here as well, or is this fine?

Anyways, I'll start working on that other implementation that hooks onto
the suspend/hibernate notifiers and see if that works out better.

> +		return -EBUSY;
> +
>  	cpu_maps_update_begin();
> 
>  	if (cpu_hotplug_disabled) {
> @@ -377,6 +386,7 @@ int __cpuinit cpu_up(unsigned int cpu)
> 
>  out:
>  	cpu_maps_update_done();
> +	unlock_pm_sleep();
>  	return err;
>  }
> 
> 


-- 
Regards,
Srivatsa S. Bhat  <srivatsa.bhat@linux.vnet.ibm.com>
Linux Technology Center,
IBM India Systems and Technology Lab


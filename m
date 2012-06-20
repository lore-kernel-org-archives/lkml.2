Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536Ab2FTFIt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 01:08:49 -0400
Received: from plane.gmane.org ([80.91.229.3]:48835 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342Ab2FTFIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 01:08:48 -0400
X-AuditID: 9c930179-b7bd3ae000000e80-66-4fe1201076a9
From: Namhyung Kim <namhyung@kernel.org>
To: Vincent Guittot 
	<public-vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@plane.gmane.org>
Cc: public-linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@plane.gmane.org,
        public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org,
        public-linaro-dev-cunTk1MwBs8s++Sfvej+rw@plane.gmane.org,
        public-devicetree-discuss-uLR06cmDAlY/bJ5BZ2RsiQ@plane.gmane.org,
        public-a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@plane.gmane.org,
        public-rob.herring-bsGFqQB8/DxBDgjK7y7TUQ@plane.gmane.org,
        public-linux-lFZ/pmaqli7XmaaqVzeoHQ@plane.gmane.org
Subject: Re: [PATCH v2 2/5] ARM: topology: factorize the update of sibling masks
References: <1340094536-20873-1-git-send-email-vincent.guittot@linaro.org>
	<1340094536-20873-3-git-send-email-vincent.guittot@linaro.org>
Date: Wed, 20 Jun 2012 09:54:31 +0900
In-Reply-To: <1340094536-20873-3-git-send-email-vincent.guittot@linaro.org>
	(Vincent Guittot's message of "Tue, 19 Jun 2012 10:28:53 +0200")
Message-ID: <87bokehkfs.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
X-TMDA-Confirmed: Wed, 20 Jun 2012 07:08:40 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Tue, 19 Jun 2012 10:28:53 +0200, Vincent Guittot wrote:
> This factorization has also been proposed in another patchset that has not been
> merged yet:
> http://lists.infradead.org/pipermail/linux-arm-kernel/2012-January/080873.html
> So, this patch could be dropped depending of the state of the other one.
>
> Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org>
> Signed-off-by: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/arm/kernel/topology.c |   47 ++++++++++++++++++++++++--------------------
>  1 file changed, 26 insertions(+), 21 deletions(-)
>
> diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
> index 37e2e57..92c2fb3 100644
> --- a/arch/arm/kernel/topology.c
> +++ b/arch/arm/kernel/topology.c
> @@ -82,6 +82,31 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
>  	return &cpu_topology[cpu].core_sibling;
>  }
>  
> +void update_siblings_masks(unsigned int cpuid)
> +{
> +	struct cputopo_arm *cpu_topo, *cpuid_topo = &cpu_topology[cpuid];
> +	int cpu;
> +	/* update core and thread sibling masks */
> +	for_each_possible_cpu(cpu) {
> +		cpu_topo = &cpu_topology[cpu];
> +
> +		if (cpuid_topo->socket_id == cpu_topo->socket_id) {

I think this will make the code a little bit cleaner:

                if (cpuid_topo->socket_id != cpu_topo->socket_id)
                	continue;

Thanks,
Namhyung


> +			cpumask_set_cpu(cpuid, &cpu_topo->core_sibling);
> +			if (cpu != cpuid)
> +				cpumask_set_cpu(cpu, &cpuid_topo->core_sibling);
> +
> +			if (cpuid_topo->core_id == cpu_topo->core_id) {
> +				cpumask_set_cpu(cpuid,
> +					&cpu_topo->thread_sibling);
> +				if (cpu != cpuid)
> +					cpumask_set_cpu(cpu,
> +						&cpuid_topo->thread_sibling);
> +			}
> +		}
> +	}
> +	smp_wmb();
> +}
> +



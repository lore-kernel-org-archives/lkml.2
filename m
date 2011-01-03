Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab1ACLCQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 06:02:16 -0500
Received: from casper.infradead.org ([85.118.1.10]:40084 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab1ACLCP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 06:02:15 -0500
Subject: Re: [PATCH 5/7] perf: Optimise topology iteration
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>, robert.richter@amd.com,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1293464287.2695.106.camel@localhost>
References: <1293464287.2695.106.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 03 Jan 2011 12:02:10 +0100
Message-ID: <1294052530.2016.52.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-27 at 23:38 +0800, Lin Ming wrote:
> Currently we iterate the full machine looking for a matching core_id/nb
> for the percore and the amd northbridge stuff , using a smaller topology
> mask makes sense. 

Does topology_thread_cpumask() include offline cpus? I tried looking at
it, but I cannot find any code clearing bits in that mask on offline.

> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event_amd.c   |    2 +-
>  arch/x86/kernel/cpu/perf_event_intel.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
> index 67e2202..5a3b7b8 100644
> --- a/arch/x86/kernel/cpu/perf_event_amd.c
> +++ b/arch/x86/kernel/cpu/perf_event_amd.c
> @@ -323,7 +323,7 @@ static void amd_pmu_cpu_starting(int cpu)
>  	nb_id = amd_get_nb_id(cpu);
>  	WARN_ON_ONCE(nb_id == BAD_APICID);
>  
> -	for_each_online_cpu(i) {
> +	for_each_cpu(i, topology_core_cpumask(cpu)) {
>  		nb = per_cpu(cpu_hw_events, i).amd_nb;
>  		if (WARN_ON_ONCE(!nb))
>  			continue;
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index 354d1de..ad70c2c 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -1111,7 +1111,7 @@ static void intel_pmu_cpu_starting(int cpu)
>  	if (!ht_enabled(cpu))
>  		return;
>  
> -	for_each_online_cpu(i) {
> +	for_each_cpu(i, topology_thread_cpumask(cpu)) {
>  		struct intel_percore *pc = per_cpu(cpu_hw_events, i).per_core;
>  
>  		if (pc && pc->core_id == core_id) {



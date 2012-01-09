Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323Ab2AIQfd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 11:35:33 -0500
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:46722 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932304Ab2AIQfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 11:35:32 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 5UdmmloVM1n3OuhOsHkJRnK4UyE3UnA8MDca8E7eMA.mzWC
 .A_4eBBYQKhwyduXkvTC64BdO1LCPCNDxCGgym_eu9ZYOFdPbrceRNdz.rRI
 7pK0XAo0wVaiETHRM5pSdxx4jVj3WPb9LS1nXDXJVY6ffJkZJdCu73Iwda_Y
 6KlkCUIcylzUejyhAzSSHmtgtbcTtr76M4r_oDgSnvk9DryyqxNEnHxafoOt
 mdWb1Y2Ggs29uIvehQnAauAzuriQ1zNRByGBw4TNfG8XFxEAo8OYpHfkiZrC
 M.zl12BXsRtTc2WrGO_6qu7cXuEiPkvGuILdDb5JD7Xk05uFPIkENL.NCL05
 L7kxCwljdQvbmuGE4yJEBC87cVyQLT2Hnl.X1etPzW7jQRFESjfx1_gjm5ve
 XaPh1VjgcQvjumIZVmCSOlQ--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 9 Jan 2012 10:35:26 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Gilad Ben-Yossef <gilad@benyossef.com>
cc: linux-kernel@vger.kernel.org, Chris Metcalf <cmetcalf@tilera.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Michal Nazarewicz <mina86@mina86.org>
Subject: Re: [PATCH v6 7/8] mm: only IPI CPUs to drain local pages if they
 exist
In-Reply-To: <1326040026-7285-8-git-send-email-gilad@benyossef.com>
Message-ID: <alpine.DEB.2.00.1201091034390.31395@router.home>
References: <y> <1326040026-7285-8-git-send-email-gilad@benyossef.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jan 2012, Gilad Ben-Yossef wrote:

> @@ -67,6 +67,14 @@ DEFINE_PER_CPU(int, numa_node);
>  EXPORT_PER_CPU_SYMBOL(numa_node);
>  #endif
>
> +/*
> + * A global cpumask of CPUs with per-cpu pages that gets
> + * recomputed on each drain. We use a global cpumask
> + * here to avoid allocation on direct reclaim code path
> + * for CONFIG_CPUMASK_OFFSTACK=y
> + */
> +static cpumask_var_t cpus_with_pcps;

Move the static definition into drain_all_pages()?

> +
>  #ifdef CONFIG_HAVE_MEMORYLESS_NODES
>  /*
>   * N.B., Do NOT reference the '_numa_mem_' per cpu variable directly.
> @@ -1097,7 +1105,19 @@ void drain_local_pages(void *arg)
>   */
>  void drain_all_pages(void)
>  {
> -	on_each_cpu(drain_local_pages, NULL, 1);
> +	int cpu;
> +	struct per_cpu_pageset *pcp;
> +	struct zone *zone;
> +
> +	for_each_online_cpu(cpu)
> +		for_each_populated_zone(zone) {
> +			pcp = per_cpu_ptr(zone->pageset, cpu);
> +			if (pcp->pcp.count)
> +				cpumask_set_cpu(cpu, cpus_with_pcps);
> +			else
> +				cpumask_clear_cpu(cpu, cpus_with_pcps);
> +		}
> +	on_each_cpu_mask(cpus_with_pcps, drain_local_pages, NULL, 1);
>  }
>
>  #ifdef CONFIG_HIBERNATION
> @@ -3601,6 +3621,10 @@ static void setup_zone_pageset(struct zone *zone)
>  void __init setup_per_cpu_pageset(void)
>  {
>  	struct zone *zone;
> +	int ret;
> +
> +	ret = zalloc_cpumask_var(&cpus_with_pcps, GFP_KERNEL);
> +	BUG_ON(!ret);
>
>  	for_each_populated_zone(zone)
>  		setup_zone_pageset(zone);
>

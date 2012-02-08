Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab2BHJdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 04:33:19 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42684 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab2BHJdR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 04:33:17 -0500
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: linux-kernel@vger.kernel.org, "Gilad Ben-Yossef" <gilad@benyossef.com>
Cc: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
        "Chris Metcalf" <cmetcalf@tilera.com>,
        "Frederic Weisbecker" <fweisbec@gmail.com>,
        "Russell King" <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        "Pekka Enberg" <penberg@kernel.org>, "Matt Mackall" <mpm@selenic.com>,
        "Sasha Levin" <levinsasha928@gmail.com>,
        "Rik van Riel" <riel@redhat.com>, "Andi Kleen" <andi@firstfloor.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Alexander Viro" <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, "Avi Kivity" <avi@redhat.com>,
        "Milton Miller" <miltonm@bga.com>
Subject: Re: [PATCH v8 7/8] mm: only IPI CPUs to drain local pages if they
 exist
References: <1328448800-15794-1-git-send-email-gilad@benyossef.com>
 <1328449722-15959-6-git-send-email-gilad@benyossef.com>
Date: Wed, 08 Feb 2012 10:33:13 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v9cstne43l0zgt@mpn-glaptop>
In-Reply-To: <1328449722-15959-6-git-send-email-gilad@benyossef.com>
User-Agent: Opera Mail/11.61 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 05 Feb 2012 14:48:41 +0100, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index d2186ec..3ff5aff 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1161,11 +1161,46 @@ void drain_local_pages(void *arg)
>  }
> /*
> - * Spill all the per-cpu pages from all CPUs back into the buddy allocator
> + * Spill all the per-cpu pages from all CPUs back into the buddy allocator.
> + *
> + * Note that this code is protected against sending an IPI to an offline
> + * CPU but does not guarantee sending an IPI to newly hotplugged CPUs:
> + * on_each_cpu_mask() blocks hotplug and won't talk to offlined CPUs but
> + * nothing keeps CPUs from showing up after we populated the cpumask and
> + * before the call to on_each_cpu_mask().
>   */
>  void drain_all_pages(void)
>  {
> -	on_each_cpu(drain_local_pages, NULL, 1);
> +	int cpu;
> +	struct per_cpu_pageset *pcp;
> +	struct zone *zone;
> +
> +	/* Allocate in the BSS so we wont require allocation in
> +	 * direct reclaim path for CONFIG_CPUMASK_OFFSTACK=y
> +	 */

If you are going to send next iteration, this comment should have
“/*” on its own line just like comment below.

> +	static cpumask_t cpus_with_pcps;
> +
> +	/*
> +	 * We don't care about racing with CPU hotplug event
> +	 * as offline notification will cause the notified
> +	 * cpu to drain that CPU pcps and on_each_cpu_mask
> +	 * disables preemption as part of its processing
> +	 */
> +	for_each_online_cpu(cpu) {
> +		bool has_pcps = false;
> +		for_each_populated_zone(zone) {
> +			pcp = per_cpu_ptr(zone->pageset, cpu);
> +			if (pcp->pcp.count) {
> +				has_pcps = true;
> +				break;
> +			}
> +		}
> +		if (has_pcps)
> +			cpumask_set_cpu(cpu, &cpus_with_pcps);
> +		else
> +			cpumask_clear_cpu(cpu, &cpus_with_pcps);
> +	}
> +	on_each_cpu_mask(&cpus_with_pcps, drain_local_pages, NULL, 1);
>  }
> #ifdef CONFIG_HIBERNATION


-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--

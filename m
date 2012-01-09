Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420Ab2AIQrj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 11:47:39 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57825 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932234Ab2AIQrh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 11:47:37 -0500
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Gilad Ben-Yossef" <gilad@benyossef.com>,
        "Christoph Lameter" <cl@linux.com>
Cc: linux-kernel@vger.kernel.org, "Chris Metcalf" <cmetcalf@tilera.com>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        "Frederic Weisbecker" <fweisbec@gmail.com>,
        "Russell King" <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        "Pekka Enberg" <penberg@kernel.org>, "Matt Mackall" <mpm@selenic.com>,
        "Sasha Levin" <levinsasha928@gmail.com>,
        "Rik van Riel" <riel@redhat.com>, "Andi Kleen" <andi@firstfloor.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Alexander Viro" <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, "Avi Kivity" <avi@redhat.com>,
        "Michal Nazarewicz" <mina86@mina86.org>
Subject: Re: [PATCH v6 7/8] mm: only IPI CPUs to drain local pages if they
 exist
References: <y> <1326040026-7285-8-git-send-email-gilad@benyossef.com>
 <alpine.DEB.2.00.1201091034390.31395@router.home>
Date: Mon, 09 Jan 2012 17:47:30 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v7tsxgu33l0zgt@mpn-glaptop>
In-Reply-To: <alpine.DEB.2.00.1201091034390.31395@router.home>
User-Agent: Opera Mail/11.60 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Jan 2012 17:35:26 +0100, Christoph Lameter <cl@linux.com> wrote:

> On Sun, 8 Jan 2012, Gilad Ben-Yossef wrote:
>
>> @@ -67,6 +67,14 @@ DEFINE_PER_CPU(int, numa_node);
>>  EXPORT_PER_CPU_SYMBOL(numa_node);
>>  #endif
>>
>> +/*
>> + * A global cpumask of CPUs with per-cpu pages that gets
>> + * recomputed on each drain. We use a global cpumask
>> + * here to avoid allocation on direct reclaim code path
>> + * for CONFIG_CPUMASK_OFFSTACK=y
>> + */
>> +static cpumask_var_t cpus_with_pcps;
>
> Move the static definition into drain_all_pages()?

This is initialised in setup_per_cpu_pageset() so it needs to be file scoped.

>> +
>>  #ifdef CONFIG_HAVE_MEMORYLESS_NODES
>>  /*
>>   * N.B., Do NOT reference the '_numa_mem_' per cpu variable directly.
>> @@ -1097,7 +1105,19 @@ void drain_local_pages(void *arg)
>>   */
>>  void drain_all_pages(void)
>>  {
>> -	on_each_cpu(drain_local_pages, NULL, 1);
>> +	int cpu;
>> +	struct per_cpu_pageset *pcp;
>> +	struct zone *zone;
>> +
>> +	for_each_online_cpu(cpu)
>> +		for_each_populated_zone(zone) {
>> +			pcp = per_cpu_ptr(zone->pageset, cpu);
>> +			if (pcp->pcp.count)
>> +				cpumask_set_cpu(cpu, cpus_with_pcps);
>> +			else
>> +				cpumask_clear_cpu(cpu, cpus_with_pcps);
>> +		}
>> +	on_each_cpu_mask(cpus_with_pcps, drain_local_pages, NULL, 1);
>>  }
>>
>>  #ifdef CONFIG_HIBERNATION
>> @@ -3601,6 +3621,10 @@ static void setup_zone_pageset(struct zone *zone)
>>  void __init setup_per_cpu_pageset(void)
>>  {
>>  	struct zone *zone;
>> +	int ret;
>> +
>> +	ret = zalloc_cpumask_var(&cpus_with_pcps, GFP_KERNEL);
>> +	BUG_ON(!ret);
>>
>>  	for_each_populated_zone(zone)
>>  		setup_zone_pageset(zone);
>>
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>


-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--

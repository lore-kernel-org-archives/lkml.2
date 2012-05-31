Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab2EaLZy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 07:25:54 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:46681 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145Ab2EaLZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 07:25:53 -0400
Message-ID: <4FC75525.8010508@gmail.com>
Date: Thu, 31 May 2012 07:25:25 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org, kosaki.motohiro@gmail.com
Subject: Re: [Patch] x86 : set numa_nodes_parsed at acpi_numa_memory_affinity_init
References: <4FC47E88.2000403@jp.fujitsu.com>
In-Reply-To: <4FC47E88.2000403@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ishimatsu-san,


(5/29/12 3:45 AM), Yasuaki Ishimatsu wrote:
> When hot-adding a CPU into my system, the system showed following message
> since node_to_cpumask_map[2] was not allocated memory.
> 
> Booting Node 2 Processor 32 APIC 0xc0
> node_to_cpumask_map[2] NULL
> Pid: 0, comm: swapper/32 Tainted: G       A     3.3.5-acd #21
> Call Trace:
>   [<ffffffff81048845>] debug_cpumask_set_cpu+0x155/0x160
>   [<ffffffff8105e28a>] ? add_timer_on+0xaa/0x120
>   [<ffffffff8150665f>] numa_add_cpu+0x1e/0x22
>   [<ffffffff815020bb>] identify_cpu+0x1df/0x1e4
>   [<ffffffff815020d6>] identify_econdary_cpu+0x16/0x1d
>   [<ffffffff81504614>] smp_store_cpu_info+0x3c/0x3e
>   [<ffffffff81505263>] smp_callin+0x139/0x1be
>   [<ffffffff815052fb>] start_secondary+0x13/0xeb
> 
> In my investigation, the root cause is that the bit of node 2 was not set at
> numa_nodes_parsed since hot-added cpu was not written in ACPI SRAT Table.
> But hot-added memory which is same PXM as the cpu is written in here.

I don't understand this explanation. If cpu is not written in srat table,
it is firmware bug. isn't it? srat table should describe all possible cpus.
Why doesn't your system describe cpu info in acpi table?

> 
> ACPI Spec Rev 5.0 says about ACPI SRAT talbe as follows:
> This optional table provides information that allows OSPM to associate
> processors and memory ranges, including ranges of memory provided by
> hot-added memory devices, with system localities / proximity domains
> and clock domains.
> 
> So I think the ACPI SRAT Table is not wrong. Thus numa_nodes_parsed should be set
> by not only acpi_numa_processor_affinity_init / acpi_numa_x2apic_affinity_init
> but also acpi_numa_memory_affinity_init for the case.
> 
> Signed-off-by: Yasuaki Ishimatsu<isimatu.yasuaki@jp.fujitsu.com>
> ---
>   arch/x86/mm/srat.c |    2 ++
>   1 file changed, 2 insertions(+)
> 
> Index: linux-3.4/arch/x86/mm/srat.c
> ===================================================================
> --- linux-3.4.orig/arch/x86/mm/srat.c	2012-05-21 07:29:13.000000000 +0900
> +++ linux-3.4/arch/x86/mm/srat.c	2012-05-29 05:28:27.353916902 +0900
> @@ -176,6 +176,8 @@  acpi_numa_memory_affinity_init(struct ac
>   		return;
>   	}
> 
> +	node_set(node, numa_nodes_parsed);
> +

But...
I think this patch itself is correct. If a system have cpuless memory node, 
acpi_numa_processor_affinity_init / acpi_numa_x2apic_affinity_init can't
find any cpu description. but we need memory node allocation.


>   	printk(KERN_INFO "SRAT: Node %u PXM %u %Lx-%Lx\n", node, pxm,
>   	       start, end);
>   }
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab1BRSBY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 13:01:24 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:47154 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982Ab1BRSBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 13:01:21 -0500
Message-ID: <4D5EB35D.3000305@kernel.org>
Date: Fri, 18 Feb 2011 09:58:53 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, David Rientjes <rientjes@google.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH 2/3 tip:x86/mm] x86-64, NUMA: Move NUMA emulation into
 numa_emulation.c
References: <20110218135836.GG21209@htj.dyndns.org> <20110218135939.GH21209@htj.dyndns.org>
In-Reply-To: <20110218135939.GH21209@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4D5EB3DB.0064,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2011 05:59 AM, Tejun Heo wrote:
> Create numa_emulation.c and move all NUMA emulation code there.  The
> definitions of struct numa_memblk and numa_meminfo are moved to
> numa_64.h.  Also, numa_remove_memblk_from(), numa_cleanup_meminfo(),
> numa_reset_distance() along with numa_emulation() are made global.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> ---
>  arch/x86/include/asm/numa_64.h |   29 ++
>  arch/x86/mm/Makefile           |    1 
>  arch/x86/mm/numa_64.c          |  479 -----------------------------------------
>  arch/x86/mm/numa_emulation.c   |  451 ++++++++++++++++++++++++++++++++++++++
>  4 files changed, 482 insertions(+), 478 deletions(-)
> 
> Index: work/arch/x86/include/asm/numa_64.h
> ===================================================================
> --- work.orig/arch/x86/include/asm/numa_64.h
> +++ work/arch/x86/include/asm/numa_64.h
> @@ -18,6 +18,21 @@ extern void setup_node_bootmem(int nodei
>  
>  #ifdef CONFIG_NUMA
>  /*
> + * Data structures to describe memory configuration during NUMA
> + * initialization.  Use only in NUMA init and emulation paths.
> + */

those internal struct and functions declaring could be in
arch/x86/mm/numa_internal.h ?

David, can you please check tip/x86/mm ?

Thanks

Yinghai



> +struct numa_memblk {
> +	u64			start;
> +	u64			end;
> +	int			nid;
> +};
> +
> +struct numa_meminfo {
> +	int			nr_blks;
> +	struct numa_memblk	blk[NR_NODE_MEMBLKS];
> +};
> +
> +/*
>   * Too small node sizes may confuse the VM badly. Usually they
>   * result from BIOS bugs. So dont recognize nodes as standalone
>   * NUMA entities that have less than this amount of RAM listed:
> @@ -28,15 +43,25 @@ extern nodemask_t numa_nodes_parsed __in
>  
>  extern int __cpuinit numa_cpu_node(int cpu);
>  extern int __init numa_add_memblk(int nodeid, u64 start, u64 end);
> +extern void __init numa_remove_memblk_from(int idx, struct numa_meminfo *mi);
> +extern int __init numa_cleanup_meminfo(struct numa_meminfo *mi);
> +extern void __init numa_reset_distance(void);
>  extern void __init numa_set_distance(int from, int to, int distance);
>  
>  #ifdef CONFIG_NUMA_EMU
>  #define FAKE_NODE_MIN_SIZE	((u64)32 << 20)
>  #define FAKE_NODE_MIN_HASH_MASK	(~(FAKE_NODE_MIN_SIZE - 1UL))
>  void numa_emu_cmdline(char *);
> +void __init numa_emulation(struct numa_meminfo *numa_meminfo,
> +			   int numa_dist_cnt);
> +#else  /* CONFIG_NUMA_EMU */
> +static inline void numa_emulation(struct numa_meminfo *numa_meminfo,
> +				  int numa_dist_cnt)
> +{ }
>  #endif /* CONFIG_NUMA_EMU */
> -#else
> +
> +#else  /* CONFIG_NUMA */
>  static inline int numa_cpu_node(int cpu)		{ return NUMA_NO_NODE; }
> -#endif
> +#endif /* CONFIG_NUMA */
>  
>  #endif /* _ASM_X86_NUMA_64_H */

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338Ab1CBSWt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 13:22:49 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61313 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924Ab1CBSWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 13:22:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hfSnJSyyCHc8BZcLlBdZeOsUMgocb/sAMoVTcS2ayspmwAoXxSCVif1J/YlF6yZlgb
         ykmYM5N7z06wqK2M48HPjryAd8Q+MBqQPT6sLSDo5c+9L/lG04NgWBb8bQprnB6t/c6F
         SocHzK/aTyMns8pRYZAVDZT13pArOSxhdWUaI=
Date: Wed, 2 Mar 2011 19:22:34 +0100
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] Reverting NUMA-affine page table allocation
Message-ID: <20110302182234.GA28266@mtj.dyndns.org>
References: <20110226143730.GA26864@htj.dyndns.org>
 <AANLkTinW-nQV4tL-_PicOb-N6imv3gtWuG-J69-6VUQd@mail.gmail.com>
 <20110302161900.GP3319@htj.dyndns.org>
 <AANLkTi=SYRK+iKT-Zwuyv=e6dLqmoL4cUts2Xoyq-M=1@mail.gmail.com>
 <20110302170702.GS3319@htj.dyndns.org>
 <20110302180827.GA13693@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110302180827.GA13693@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Mar 02, 2011 at 07:08:27PM +0100, Ingo Molnar wrote:
> > I tried to clean up the page table allocation code but the necessary
> > changes felt a bit too large at this stage, so IMO that's best left to
> > the next cycle.
> 
> Do you plan to implement it more cleanly?

Yeah, that's the plan.  I want the page table allocation code cleaned
up before doing this.

I also want to take a dumber/simpler approach at the expense of some
disadvantage to machines with interleaved NUMA nodes which can't do
1GiB mappings.  If this scenario is a real concern, which I'm doubtful
about but then again it could be, we can do the callback walking thing
but I'd at least want to know that that's an actual concern we need to
address.

> > To me, it seems complicated for not good enough reasons.  I'll defer
> > the decision to x86 maintainers.  Ingo, hpa, Thomas, what do you guys
> > think?
> 
> Would be nice to see an actual patch that does the revert.

Here it is.

Thanks.

diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
index 97e6007..bce688d 100644
--- a/arch/x86/include/asm/page_types.h
+++ b/arch/x86/include/asm/page_types.h
@@ -54,8 +54,6 @@ static inline phys_addr_t get_max_mapped(void)
 extern unsigned long init_memory_mapping(unsigned long start,
 					 unsigned long end);
 
-void init_memory_mapping_high(void);
-
 extern void initmem_init(void);
 extern void free_initmem(void);
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 46e684f..c3a606c 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -963,6 +963,14 @@ void __init setup_arch(char **cmdline_p)
 	max_low_pfn_mapped = init_memory_mapping(0, max_low_pfn<<PAGE_SHIFT);
 	max_pfn_mapped = max_low_pfn_mapped;
 
+#ifdef CONFIG_X86_64
+	if (max_pfn > max_low_pfn) {
+		max_pfn_mapped = init_memory_mapping(1UL<<32,
+						     max_pfn<<PAGE_SHIFT);
+		/* can we preseve max_low_pfn ?*/
+		max_low_pfn = max_pfn;
+	}
+#endif
 	memblock.current_limit = get_max_mapped();
 
 	/*
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 470cc47..c8813aa 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -606,63 +606,9 @@ kernel_physical_mapping_init(unsigned long start,
 void __init initmem_init(void)
 {
 	memblock_x86_register_active_regions(0, 0, max_pfn);
-	init_memory_mapping_high();
 }
 #endif
 
-struct mapping_work_data {
-	unsigned long start;
-	unsigned long end;
-	unsigned long pfn_mapped;
-};
-
-static int __init_refok
-mapping_work_fn(unsigned long start_pfn, unsigned long end_pfn, void *datax)
-{
-	struct mapping_work_data *data = datax;
-	unsigned long pfn_mapped;
-	unsigned long final_start, final_end;
-
-	final_start = max_t(unsigned long, start_pfn<<PAGE_SHIFT, data->start);
-	final_end = min_t(unsigned long, end_pfn<<PAGE_SHIFT, data->end);
-
-	if (final_end <= final_start)
-		return 0;
-
-	pfn_mapped = init_memory_mapping(final_start, final_end);
-
-	if (pfn_mapped > data->pfn_mapped)
-		data->pfn_mapped = pfn_mapped;
-
-	return 0;
-}
-
-static unsigned long __init_refok
-init_memory_mapping_active_regions(unsigned long start, unsigned long end)
-{
-	struct mapping_work_data data;
-
-	data.start = start;
-	data.end = end;
-	data.pfn_mapped = 0;
-
-	work_with_active_regions(MAX_NUMNODES, mapping_work_fn, &data);
-
-	return data.pfn_mapped;
-}
-
-void __init_refok init_memory_mapping_high(void)
-{
-	if (max_pfn > max_low_pfn) {
-		max_pfn_mapped = init_memory_mapping_active_regions(1UL<<32,
-							 max_pfn<<PAGE_SHIFT);
-		/* can we preserve max_low_pfn ? */
-		max_low_pfn = max_pfn;
-
-		memblock.current_limit = get_max_mapped();
-	}
-}
-
 void __init paging_init(void)
 {
 	unsigned long max_zone_pfns[MAX_NR_ZONES];
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 74064e8..86491ba 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -543,8 +543,6 @@ static int __init numa_register_memblks(struct numa_meminfo *mi)
 	if (!numa_meminfo_cover_memory(mi))
 		return -EINVAL;
 
-	init_memory_mapping_high();
-
 	/* Finally register nodes. */
 	for_each_node_mask(nid, node_possible_map) {
 		u64 start = (u64)max_pfn << PAGE_SHIFT;

-- 
tejun

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab0JVDgN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 23:36:13 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41315 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164Ab0JVDgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 23:36:12 -0400
Date: Fri, 22 Oct 2010 14:36:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
        Xen Devel <Xen-devel@lists.xensource.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gianluca Guida <gianluca.guida@citrix.com>,
        Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the xen tree with the tip tree
Message-Id: <20101022143607.132d381c.sfr@canb.auug.org.au>
In-Reply-To: <20101022140335.c4a3a48f.sfr@canb.auug.org.au>
References: <20101022140335.c4a3a48f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeremy,

On Fri, 22 Oct 2010 14:03:35 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Today's linux-next merge of the xen tree got a conflict in
> arch/x86/mm/init_32.c between commit
> 1d931264af0f10649b35afa8fbd2e169da51ac08 ("x86-32, memblock: Make
> add_highpages honor early reserved ranges") from the tip tree and commit
> 07147a06ac3b1b028124ea00ba44e69eb8ea7685 ("x86/32: honor reservations of
> high memory") from the xen tree.
> 
> I have no idea how to fix this up, sorry, so I have used the xen tree
> from next-20101021 for today.

It occurred to me that the conflicts might be useful to you, so here they
are:

diff --cc arch/x86/mm/init_32.c
index 5d0a671,573bc7f..0000000
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@@ -423,28 -422,71 +423,78 @@@ static void __init add_one_highpage_ini
  	totalhigh_pages++;
  }
  
 -struct add_highpages_data {
 -	unsigned long start_pfn;
 -	unsigned long end_pfn;
 -};
 -
 -static int __init add_highpages_work_fn(unsigned long start_pfn,
 -					 unsigned long end_pfn, void *datax)
 +void __init add_highpages_with_active_regions(int nid,
 +			 unsigned long start_pfn, unsigned long end_pfn)
  {
++<<<<<<< HEAD
 +	struct range *range;
 +	int nr_range;
 +	int i;
 +
 +	nr_range = __get_free_all_memory_range(&range, nid, start_pfn, end_pfn);
++=======
+ 	int node_pfn;
+ 	struct page *page;
+ 	phys_addr_t chunk_end, chunk_max;
+ 	unsigned long final_start_pfn, final_end_pfn;
+ 	struct add_highpages_data *data = (struct add_highpages_data *)datax;
++>>>>>>> xen
  
 -	final_start_pfn = max(start_pfn, data->start_pfn);
 -	final_end_pfn = min(end_pfn, data->end_pfn);
 -	if (final_start_pfn >= final_end_pfn)
 -		return 0;
 +	for (i = 0; i < nr_range; i++) {
 +		struct page *page;
 +		int node_pfn;
  
++<<<<<<< HEAD
 +		for (node_pfn = range[i].start; node_pfn < range[i].end;
 +		     node_pfn++) {
++=======
+ 	chunk_end = PFN_PHYS(final_start_pfn);
+ 	chunk_max = PFN_PHYS(final_end_pfn);
+ 
+ 	/*
+ 	 * Check for reserved areas.
+ 	 */
+ 	for (;;) {
+ 		phys_addr_t chunk_start;
+ 		chunk_start = early_res_next_free(chunk_end);
+ 		
+ 		/*
+ 		 * Reserved area. Just count high mem pages.
+ 		 */
+ 		for (node_pfn = PFN_DOWN(chunk_end);
+ 		     node_pfn < PFN_DOWN(chunk_start); node_pfn++) {
+ 			if (pfn_valid(node_pfn))
+ 				totalhigh_pages++;
+ 		}
+ 
+ 		if (chunk_start >= chunk_max)
+ 			break;
+ 
+ 		chunk_end = early_res_next_reserved(chunk_start, chunk_max);
+ 		for (node_pfn = PFN_DOWN(chunk_start);
+ 		     node_pfn < PFN_DOWN(chunk_end); node_pfn++) {
++>>>>>>> xen
  			if (!pfn_valid(node_pfn))
  				continue;
  			page = pfn_to_page(node_pfn);
  			add_one_highpage_init(page);
  		}
  	}
 -
 -	return 0;
 -
  }
++<<<<<<< HEAD
++=======
+ 
+ void __init add_highpages_with_active_regions(int nid, unsigned long start_pfn,
+ 					      unsigned long end_pfn)
+ {
+ 	struct add_highpages_data data;
+ 
+ 	data.start_pfn = start_pfn;
+ 	data.end_pfn = end_pfn;
+ 	work_with_active_regions(nid, add_highpages_work_fn, &data);
+ }
+ 
++>>>>>>> xen
  #else
  static inline void permanent_kmaps_init(pgd_t *pgd_base)
  {
diff --cc arch/x86/xen/mmu.c
index f72d18c,930986d..0000000
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@@ -56,7 -55,7 +56,11 @@@
  #include <asm/e820.h>
  #include <asm/linkage.h>
  #include <asm/page.h>
++<<<<<<< HEAD
 +#include <asm/init.h>
++=======
+ #include <asm/pat.h>
++>>>>>>> xen
  
  #include <asm/xen/hypercall.h>
  #include <asm/xen/hypervisor.h>
* Unmerged path include/linux/early_res.h
* Unmerged path kernel/early_res.c

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

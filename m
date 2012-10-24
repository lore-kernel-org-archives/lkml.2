Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933687Ab2JXTxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 15:53:24 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:40419 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932117Ab2JXTxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 15:53:22 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1202h1d1ah1d2ahzz8275bh8275dhz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh1155h)
X-WSS-ID: 0MCEXWN-02-67D-02
X-M-MSG: 
Date: Wed, 24 Oct 2012 14:53:11 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Tom Rini <trini@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: BUG: 1bbbbe7 (x86: Exclude E820_RESERVED regions...) PANIC on
 boot
Message-ID: <20121024195311.GB11779@jshin-Toonie>
References: <20121022144020.GA14425@jshin-Toonie>
 <CAE9FiQWvVNCK8Ka6rq+RMf3u4JFn8D18rGMy4Hpz7Rhnrn6VTA@mail.gmail.com>
 <20121022183858.GA31185@jshin-Toonie>
 <CAE9FiQWZmwa6EwsfZzz_e3A-tz2LUS2+i+zh4zpXpR_Jj_FQ1w@mail.gmail.com>
 <5085ABEF.3060502@linux.intelZNw@mail.gmail.com>
 <20121024164808.GA11779@jshin-Toonie>
 <5088391C.6080603@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5088391C.6080603@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 11:53:16AM -0700, H. Peter Anvin wrote:
> On 10/24/2012 09:48 AM, Jacob Shin wrote:
> > 
> > hpa, we need this patch: https://lkml.org/lkml/2012/8/24/469 and the above
> > 2 from Yinghai to handle corner case E820 layouts.
> > 
> 
> I can apply Yinghai's patches, but the above patch no longer applies.
> Could you refresh it on top of tip:x86/u, please?

Sorry about that, it applied to Linus's 3.7-rc2 so I just assumed .. :-(

>From 7d2a67f6b435ede202bdf5d1982f9b5af90cce34 Mon Sep 17 00:00:00 2001
From: Jacob Shin <jacob.shin@amd.com>
Date: Wed, 24 Oct 2012 14:24:44 -0500
Subject: [PATCH] x86/mm: find_early_table_space based on ranges that are
 actually being mapped

Current logic finds enough space for direct mapping page tables from 0
to end. Instead, we only need to find enough space to cover mr[0].start
to mr[nr_range].end -- the range that is actually being mapped by
init_memory_mapping()

This is needed after 1bbbbe779aabe1f0768c2bf8f8c0a5583679b54a, to address
the panic reported here:

  https://lkml.org/lkml/2012/10/20/160
  https://lkml.org/lkml/2012/10/21/157

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
Tested-by: Tom Rini <trini@ti.com>

---
 arch/x86/mm/init.c |   70 ++++++++++++++++++++++++++++++----------------------
 1 file changed, 41 insertions(+), 29 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 8653b3a..bc287d6 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -29,36 +29,54 @@ int direct_gbpages
 #endif
 ;
 
-static void __init find_early_table_space(unsigned long end, int use_pse,
-					  int use_gbpages)
+struct map_range {
+	unsigned long start;
+	unsigned long end;
+	unsigned page_size_mask;
+};
+
+/*
+ * First calculate space needed for kernel direct mapping page tables to cover
+ * mr[0].start to mr[nr_range - 1].end, while accounting for possible 2M and 1GB
+ * pages. Then find enough contiguous space for those page tables.
+ */
+static void __init find_early_table_space(struct map_range *mr, int nr_range)
 {
-	unsigned long puds, pmds, ptes, tables, start = 0, good_end = end;
+	int i;
+	unsigned long puds = 0, pmds = 0, ptes = 0, tables;
+	unsigned long start = 0, good_end;
 	phys_addr_t base;
 
-	puds = (end + PUD_SIZE - 1) >> PUD_SHIFT;
-	tables = roundup(puds * sizeof(pud_t), PAGE_SIZE);
+	for (i = 0; i < nr_range; i++) {
+		unsigned long range, extra;
 
-	if (use_gbpages) {
-		unsigned long extra;
+		range = mr[i].end - mr[i].start;
+		puds += (range + PUD_SIZE - 1) >> PUD_SHIFT;
 
-		extra = end - ((end>>PUD_SHIFT) << PUD_SHIFT);
-		pmds = (extra + PMD_SIZE - 1) >> PMD_SHIFT;
-	} else
-		pmds = (end + PMD_SIZE - 1) >> PMD_SHIFT;
-
-	tables += roundup(pmds * sizeof(pmd_t), PAGE_SIZE);
+		if (mr[i].page_size_mask & (1 << PG_LEVEL_1G)) {
+			extra = range - ((range >> PUD_SHIFT) << PUD_SHIFT);
+			pmds += (extra + PMD_SIZE - 1) >> PMD_SHIFT;
+		} else {
+			pmds += (range + PMD_SIZE - 1) >> PMD_SHIFT;
+		}
 
-	if (use_pse) {
-		unsigned long extra;
-
-		extra = end - ((end>>PMD_SHIFT) << PMD_SHIFT);
+		if (mr[i].page_size_mask & (1 << PG_LEVEL_2M)) {
+			extra = range - ((range >> PMD_SHIFT) << PMD_SHIFT);
 #ifdef CONFIG_X86_32
-		extra += PMD_SIZE;
+			extra += PMD_SIZE;
 #endif
-		ptes = (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	} else
-		ptes = (end + PAGE_SIZE - 1) >> PAGE_SHIFT;
+			/* The first 2/4M doesn't use large pages. */
+			if (mr[i].start < PMD_SIZE)
+				extra += range;
+
+			ptes += (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
+		} else {
+			ptes += (range + PAGE_SIZE - 1) >> PAGE_SHIFT;
+		}
+	}
 
+	tables = roundup(puds * sizeof(pud_t), PAGE_SIZE);
+	tables += roundup(pmds * sizeof(pmd_t), PAGE_SIZE);
 	tables += roundup(ptes * sizeof(pte_t), PAGE_SIZE);
 
 #ifdef CONFIG_X86_32
@@ -76,7 +94,7 @@ static void __init find_early_table_space(unsigned long end, int use_pse,
 	pgt_buf_top = pgt_buf_start + (tables >> PAGE_SHIFT);
 
 	printk(KERN_DEBUG "kernel direct mapping tables up to %#lx @ [mem %#010lx-%#010lx]\n",
-		end - 1, pgt_buf_start << PAGE_SHIFT,
+		mr[nr_range - 1].end - 1, pgt_buf_start << PAGE_SHIFT,
 		(pgt_buf_top << PAGE_SHIFT) - 1);
 }
 
@@ -85,12 +103,6 @@ void __init native_pagetable_reserve(u64 start, u64 end)
 	memblock_reserve(start, end - start);
 }
 
-struct map_range {
-	unsigned long start;
-	unsigned long end;
-	unsigned page_size_mask;
-};
-
 #ifdef CONFIG_X86_32
 #define NR_RANGE_MR 3
 #else /* CONFIG_X86_64 */
@@ -263,7 +275,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	 * nodes are discovered.
 	 */
 	if (!after_bootmem)
-		find_early_table_space(end, use_pse, use_gbpages);
+		find_early_table_space(mr, nr_range);
 
 	for (i = 0; i < nr_range; i++)
 		ret = kernel_physical_mapping_init(mr[i].start, mr[i].end,
-- 
1.7.9.5



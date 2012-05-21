Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570Ab2EUUav (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 16:30:51 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:43093 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758496Ab2EUUa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 16:30:29 -0400
Subject: [RFC][PATCH 2/2] sparsemem: fix boot when SECTIONS_PER_ROOT is not power-of-2
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Mon, 21 May 2012 13:30:24 -0700
References: <20120521203022.F7FCE507@kernel>
In-Reply-To: <20120521203022.F7FCE507@kernel>
Message-Id: <20120521203024.5526C347@kernel>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12052120-3270-0000-0000-00000685374E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I was getting some interesting oopses at boot after adding a
field to 'struct mem_section'.  I tracked it down to
__nr_to_section().  In my case, SECTIONS_PER_ROOT got set to
73, which leads to an interesting bitmask:

	#define SECTIONS_PER_ROOT       (PAGE_SIZE / sizeof (struct mem_section))
	...
	#define SECTION_ROOT_MASK      (SECTIONS_PER_ROOT - 1)

We only use SECTION_ROOT_MASK in one place.  If we replace it
with some modulo arithmetic, it compiles down to the same thing
for power-of-2 SECTIONS_PER_ROOT values, but it also actually
*works* instead of just failing to boot at some random point
for the other case.

This also adds some requisite comments in the structure for
future hapless kernel developers, plus a bonus WARN_ON_ONCE()
just in case they miss the big fat comment.

Granted, this patch is not fixing a bug that anyone will really
hit in practice, but it will surely save future developers a
headache or two, plus it removes a #define!

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/include/linux/mmzone.h |    9 +++++++--
 linux-2.6.git-dave/mm/sparse.c            |    5 +++++
 2 files changed, 12 insertions(+), 2 deletions(-)

diff -puN include/linux/mmzone.h~sparsemem-fix-boot-when-SECTIONS_PER_ROOT-is-not-power_of_2 include/linux/mmzone.h
--- linux-2.6.git/include/linux/mmzone.h~sparsemem-fix-boot-when-SECTIONS_PER_ROOT-is-not-power_of_2	2012-05-21 13:29:43.777274223 -0700
+++ linux-2.6.git-dave/include/linux/mmzone.h	2012-05-21 13:29:43.789274356 -0700
@@ -1018,6 +1018,12 @@ struct mem_section {
 	struct page_cgroup *page_cgroup;
 	unsigned long pad;
 #endif
+	/*
+	 * WARNING: Do not put any fields here that could cause
+	 * this structure to become a non-power-of-2 size.
+	 * Operations like pfn_to_page() will end up doing
+	 * division in hot paths for CONFIG_SPARSEMEM_EXTREME.
+	 */
 };
 
 #ifdef CONFIG_SPARSEMEM_EXTREME
@@ -1028,7 +1034,6 @@ struct mem_section {
 
 #define SECTION_NR_TO_ROOT(sec)	((sec) / SECTIONS_PER_ROOT)
 #define NR_SECTION_ROOTS	DIV_ROUND_UP(NR_MEM_SECTIONS, SECTIONS_PER_ROOT)
-#define SECTION_ROOT_MASK	(SECTIONS_PER_ROOT - 1)
 
 #ifdef CONFIG_SPARSEMEM_EXTREME
 extern struct mem_section *mem_section[NR_SECTION_ROOTS];
@@ -1040,7 +1045,7 @@ static inline struct mem_section *__nr_t
 {
 	if (!mem_section[SECTION_NR_TO_ROOT(nr)])
 		return NULL;
-	return &mem_section[SECTION_NR_TO_ROOT(nr)][nr & SECTION_ROOT_MASK];
+	return &mem_section[SECTION_NR_TO_ROOT(nr)][nr % SECTIONS_PER_ROOT];
 }
 extern int __section_nr(struct mem_section* ms);
 extern unsigned long usemap_size(void);
diff -puN mm/sparse.c~sparsemem-fix-boot-when-SECTIONS_PER_ROOT-is-not-power_of_2 mm/sparse.c
--- linux-2.6.git/mm/sparse.c~sparsemem-fix-boot-when-SECTIONS_PER_ROOT-is-not-power_of_2	2012-05-21 13:29:43.781274268 -0700
+++ linux-2.6.git-dave/mm/sparse.c	2012-05-21 13:29:43.789274356 -0700
@@ -63,6 +63,11 @@ static struct mem_section noinline __ini
 	unsigned long array_size = SECTIONS_PER_ROOT *
 				   sizeof(struct mem_section);
 
+	/*
+	 * See note in 'struct mem_section' definition
+	 */
+	WARN_ON_ONCE(!is_power_of_2(sizeof(struct mem_section)));
+
 	if (slab_is_available()) {
 		if (node_state(nid, N_HIGH_MEMORY))
 			section = kmalloc_node(array_size, GFP_KERNEL, nid);
_


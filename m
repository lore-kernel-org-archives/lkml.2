Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab2HMUjG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:39:06 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55329 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190Ab2HMUWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:22:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Xishi Qiu <qiuxishi@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        Tony Luck <tony.luck@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Keping Chen <chenkeping@huawei.com>
Subject: [ 31/82] mm: setup pageblock_order before its used by sparsemem
Date: Mon, 13 Aug 2012 13:19:07 -0700
Message-Id: <20120813201749.162047394@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813201746.448504360@linuxfoundation.org>
References: <20120813201746.448504360@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xishi Qiu <qiuxishi@huawei.com>

commit ca57df79d4f64e1a4886606af4289d40636189c5 upstream.

On architectures with CONFIG_HUGETLB_PAGE_SIZE_VARIABLE set, such as
Itanium, pageblock_order is a variable with default value of 0.  It's set
to the right value by set_pageblock_order() in function
free_area_init_core().

But pageblock_order may be used by sparse_init() before free_area_init_core()
is called along path:
sparse_init()
    ->sparse_early_usemaps_alloc_node()
	->usemap_size()
	    ->SECTION_BLOCKFLAGS_BITS
		->((1UL << (PFN_SECTION_SHIFT - pageblock_order)) *
NR_PAGEBLOCK_BITS)

The uninitialized pageblock_size will cause memory wasting because
usemap_size() returns a much bigger value then it's really needed.

For example, on an Itanium platform,
sparse_init() pageblock_order=0 usemap_size=24576
free_area_init_core() before pageblock_order=0, usemap_size=24576
free_area_init_core() after pageblock_order=12, usemap_size=8

That means 24K memory has been wasted for each section, so fix it by calling
set_pageblock_order() from sparse_init().

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Jiang Liu <liuj97@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Keping Chen <chenkeping@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/internal.h   |    2 ++
 mm/page_alloc.c |    4 ++--
 mm/sparse.c     |    3 +++
 3 files changed, 7 insertions(+), 2 deletions(-)

--- a/mm/internal.h
+++ b/mm/internal.h
@@ -347,3 +347,5 @@ extern u32 hwpoison_filter_enable;
 extern unsigned long vm_mmap_pgoff(struct file *, unsigned long,
         unsigned long, unsigned long,
         unsigned long, unsigned long);
+
+extern void set_pageblock_order(void);
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4301,7 +4301,7 @@ static inline void setup_usemap(struct p
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
 
 /* Initialise the number of pages represented by NR_PAGEBLOCK_BITS */
-static inline void __init set_pageblock_order(void)
+void __init set_pageblock_order(void)
 {
 	unsigned int order;
 
@@ -4329,7 +4329,7 @@ static inline void __init set_pageblock_
  * include/linux/pageblock-flags.h for the values of pageblock_order based on
  * the kernel config
  */
-static inline void set_pageblock_order(void)
+void __init set_pageblock_order(void)
 {
 }
 
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -493,6 +493,9 @@ void __init sparse_init(void)
 	struct page **map_map;
 #endif
 
+	/* Setup pageblock_order for HUGETLB_PAGE_SIZE_VARIABLE */
+	set_pageblock_order();
+
 	/*
 	 * map is using big page (aka 2M in x86 64 bit)
 	 * usemap is less one page (aka 24 bytes)



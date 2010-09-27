Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932717Ab0I0G43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 02:56:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:59772 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758818Ab0I0G41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 02:56:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,241,1283756400"; 
   d="scan'208";a="841188886"
Date: Mon, 27 Sep 2010 14:56:18 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andi Kleen <andi@firstfloor.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: Re: linux-next: build warning after merge of the final tree
 (hwpoison tree related)
Message-ID: <20100927065618.GA25631@localhost>
References: <20100927152804.57c2d66e.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100927152804.57c2d66e.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Mon, Sep 27, 2010 at 01:28:04PM +0800, Stephen Rothwell wrote:
> Hi Andi,
> 
> After merging the final tree, today's linux-next build (powerpc
> ppc64_defconfig) produced this warning:
> 
> mm/hugetlb.c:2950: warning: 'is_hugepage_on_freelist' defined but not used
> 
> Introduced by commit 19b31e29073e272e49a3d38972c132c49383d5d4 ("HWPOISON,
> hugetlb: add free check to dequeue_hwpoison_huge_page()").

Maybe ppc64_defconfig does not enable CONFIG_MEMORY_FAILURE.
Try this trivial patch :)

Thanks,
Fengguang
---
hugetlb: fix is_hugepage_on_freelist() build warning

mm/hugetlb.c:2950: warning: 'is_hugepage_on_freelist' defined but not used                                                         

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/hugetlb.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- linux-next.orig/mm/hugetlb.c	2010-09-27 14:51:19.000000000 +0800
+++ linux-next/mm/hugetlb.c	2010-09-27 14:52:56.000000000 +0800
@@ -2876,8 +2876,8 @@ void hugetlb_unreserve_pages(struct inod
 	hugetlb_acct_memory(h, -(chg - freed));
 }
 
-/* Should be called in hugetlb_lock */
-static int is_hugepage_on_freelist(struct page *hpage)
+#ifdef CONFIG_MEMORY_FAILURE
+static int __is_hugepage_on_freelist(struct page *hpage)
 {
 	struct page *page;
 	struct page *tmp;
@@ -2890,7 +2890,6 @@ static int is_hugepage_on_freelist(struc
 	return 0;
 }
 
-#ifdef CONFIG_MEMORY_FAILURE
 /*
  * This function is called from memory failure code.
  * Assume the caller holds page lock of the head page.
@@ -2902,7 +2901,7 @@ int dequeue_hwpoisoned_huge_page(struct 
 	int ret = -EBUSY;
 
 	spin_lock(&hugetlb_lock);
-	if (is_hugepage_on_freelist(hpage)) {
+	if (__is_hugepage_on_freelist(hpage)) {
 		list_del(&hpage->lru);
 		h->free_huge_pages--;
 		h->free_huge_pages_node[nid]--;

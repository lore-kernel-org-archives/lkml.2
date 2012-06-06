Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab2FFIPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 04:15:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:47172 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753661Ab2FFIPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 04:15:25 -0400
X-IronPort-AV: E=Sophos;i="4.75,722,1330876800"; 
   d="scan'208";a="5122731"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Tejun Heo <tj@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 6/7] highmem: remove ->virtual from struct page_address_map
Date: Wed, 6 Jun 2012 16:15:00 +0800
Message-Id: <1338970501-5098-6-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1338970501-5098-1-git-send-email-laijs@cn.fujitsu.com>
References: <1338970501-5098-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/06 16:15:57,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/06 16:16:05,
	Serialize complete at 2012/06/06 16:16:05
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The virtual address is (void *)PKMAP_ADDR(kmap_index),

But struct page_address_map is always allocated with the same index
(in page_address_maps) as kmap index.

So the virtual address is (void *)PKMAP_ADDR(pam - page_address_maps) here,
the ->virtual is not needed.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 mm/highmem.c |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/mm/highmem.c b/mm/highmem.c
index bd2b9d3..6f028cb 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -309,7 +309,6 @@ EXPORT_SYMBOL(kunmap_high);
  */
 struct page_address_map {
 	struct page *page;
-	void *virtual;
 	struct list_head list;
 };
 
@@ -339,6 +338,7 @@ void *page_address(const struct page *page)
 	unsigned long flags;
 	void *ret;
 	struct page_address_slot *pas;
+	struct page_address_map *pam;
 
 	if (!PageHighMem(page))
 		return lowmem_page_address(page);
@@ -346,18 +346,14 @@ void *page_address(const struct page *page)
 	pas = page_slot(page);
 	ret = NULL;
 	spin_lock_irqsave(&pas->lock, flags);
-	if (!list_empty(&pas->lh)) {
-		struct page_address_map *pam;
-
-		list_for_each_entry(pam, &pas->lh, list) {
-			if (pam->page == page) {
-				ret = pam->virtual;
-				goto done;
-			}
+	list_for_each_entry(pam, &pas->lh, list) {
+		if (pam->page == page) {
+			ret = (void *)PKMAP_ADDR(pam - page_address_maps);
+			break;
 		}
 	}
-done:
 	spin_unlock_irqrestore(&pas->lock, flags);
+
 	return ret;
 }
 
@@ -370,7 +366,6 @@ static void set_high_page_map(struct page *page, unsigned int nr)
 	struct page_address_map *pam = &page_address_maps[nr];
 
 	pam->page = page;
-	pam->virtual = (void *)PKMAP_ADDR(nr);
 
 	spin_lock_irqsave(&pas->lock, flags);
 	list_add_tail(&pam->list, &pas->lh);
-- 
1.7.7


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab2FFIQP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 04:16:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:5537 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752026Ab2FFIPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 04:15:25 -0400
X-IronPort-AV: E=Sophos;i="4.75,722,1330876800"; 
   d="scan'208";a="5122730"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Tejun Heo <tj@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 7/7] highmem: avoid page_address() in flush_all_zero_pkmaps()
Date: Wed, 6 Jun 2012 16:15:01 +0800
Message-Id: <1338970501-5098-7-git-send-email-laijs@cn.fujitsu.com>
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

We can get the virtual address from PKMAP_ADDR(i),
we don't need to call page_address() here.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 mm/highmem.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/mm/highmem.c b/mm/highmem.c
index 6f028cb..994fd68 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -103,8 +103,6 @@ static void flush_all_zero_pkmaps(void)
 	flush_cache_kmaps();
 
 	for (i = 0; i < LAST_PKMAP; i++) {
-		struct page *page;
-
 		/*
 		 * zero means we don't have anything to do,
 		 * >1 means that it is still in use. Only
@@ -125,9 +123,7 @@ static void flush_all_zero_pkmaps(void)
 		 * getting the kmap_lock (which is held here).
 		 * So no dangers, even with speculative execution.
 		 */
-		page = pte_page(pkmap_page_table[i]);
-		pte_clear(&init_mm, (unsigned long)page_address(page),
-			  &pkmap_page_table[i]);
+		pte_clear(&init_mm, PKMAP_ADDR(i), &pkmap_page_table[i]);
 
 		clear_high_page_map(i);
 		need_flush = 1;
-- 
1.7.7


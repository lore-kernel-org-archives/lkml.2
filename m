Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab1GMWZH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 18:25:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:49598 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523Ab1GMWZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 18:25:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,527,1304319600"; 
   d="scan'208";a="26940026"
Date: Wed, 13 Jul 2011 15:24:29 -0700
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Rubin <mrubin@google.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] mm: account NR_WRITTEN at IO completion time
Message-ID: <20110713222429.GA14098@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NR_WRITTEN is now accounted at block IO enqueue time, which is not
very accurate as to common understanding. This moves NR_WRITTEN
accounting to the IO completion time and makes it more consistent
with BDI_WRITTEN, which is used for bandwidth estimation.

CC: Michael Rubin <mrubin@google.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- linux-next.orig/mm/page-writeback.c	2011-04-18 17:28:44.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-04-18 17:30:33.000000000 +0800
@@ -1846,7 +1846,6 @@ EXPORT_SYMBOL(account_page_dirtied);
 void account_page_writeback(struct page *page)
 {
 	inc_zone_page_state(page, NR_WRITEBACK);
-	inc_zone_page_state(page, NR_WRITTEN);
 }
 EXPORT_SYMBOL(account_page_writeback);
 
@@ -2063,8 +2062,10 @@ int test_clear_page_writeback(struct pag
 	} else {
 		ret = TestClearPageWriteback(page);
 	}
-	if (ret)
+	if (ret) {
 		dec_zone_page_state(page, NR_WRITEBACK);
+		inc_zone_page_state(page, NR_WRITTEN);
+	}
 	return ret;
 }
 

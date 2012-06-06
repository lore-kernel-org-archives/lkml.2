Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab2FFKyk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 06:54:40 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45499 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492Ab2FFKyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 06:54:38 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: konrad.wilk@oracle.com, dan.magenheimer@oracle.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH 10/11] mm: frontswap: split out function to clear a page out
Date: Wed,  6 Jun 2012 12:55:14 +0200
Message-Id: <1338980115-2394-10-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1338980115-2394-1-git-send-email-levinsasha928@gmail.com>
References: <1338980115-2394-1-git-send-email-levinsasha928@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 mm/frontswap.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/mm/frontswap.c b/mm/frontswap.c
index c0cd8bc..92e2e7b 100644
--- a/mm/frontswap.c
+++ b/mm/frontswap.c
@@ -99,6 +99,12 @@ void __frontswap_init(unsigned type)
 }
 EXPORT_SYMBOL(__frontswap_init);
 
+static inline void __frontswap_clear(struct swap_info_struct *sis, pgoff_t offset)
+{
+	frontswap_clear(sis, offset);
+	atomic_dec(&sis->frontswap_pages);
+}
+
 /*
  * "Put" data from a page to frontswap and associate it with the page's
  * swaptype and offset.  Page must be locked and in the swap cache.
@@ -131,10 +137,8 @@ int __frontswap_put_page(struct page *page)
 		  the (older) page from frontswap
 		 */
 		frontswap_failed_puts++;
-		if (dup) {
-			frontswap_clear(sis, offset);
-			atomic_dec(&sis->frontswap_pages);
-		}
+		if (dup)
+			__frontswap_clear(sis, offset);
 	}
 	if (frontswap_writethrough_enabled)
 		/* report failure so swap also writes to swap device */
@@ -179,8 +183,7 @@ void __frontswap_invalidate_page(unsigned type, pgoff_t offset)
 	trace_frontswap_invalidate_page(type, offset, sis, frontswap_test(sis, offset));
 	if (frontswap_test(sis, offset)) {
 		frontswap_ops.invalidate_page(type, offset);
-		atomic_dec(&sis->frontswap_pages);
-		frontswap_clear(sis, offset);
+		__frontswap_clear(sis, offset);
 		frontswap_invalidates++;
 	}
 }
-- 
1.7.8.6


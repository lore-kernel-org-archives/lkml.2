Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390Ab0EZWvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 18:51:14 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:42291 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757314Ab0EZWvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 18:51:12 -0400
Date: Wed, 26 May 2010 15:51:12 -0700
From: Dmitry Torokhov <dtor@vmware.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, pv-drivers@vmware.com
Subject: [PATCH] VMware Balloon: clamp number of collected non-balloonable
 pages
Message-ID: <20100526225033.GA20733@dtor-ws.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From e672fc1756a1315b617638bfeb15734bd45208b2 Mon Sep 17 00:00:00 2001
From: Dmitry Torokhov <dtor@vmware.com>
Date: Tue, 18 May 2010 10:28:04 -0700
Subject: [PATCH] VMware Balloon: clamp number of collected non-balloonable pages

Limit number of accumulated non-balloonable pages during inflation
cycle, otherwise there is a chance we will be spinning and growing the
list forever.  This happens during torture tests when balloon target
changes while we are in the middle of inflation cycle and monitor starts
refusing to lock pages (since they are not needed anymore).

Cc: stable@kernel.org
Acked-by: Bhavesh Davda <bhavesh@vmware.com>
Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
---

Andrew,

Please consider forwarding this to Linus in your next batch of patches
for 2.6.35.

Thanks!

 drivers/misc/vmware_balloon.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/vmware_balloon.c b/drivers/misc/vmware_balloon.c
index e7161c4..ad8fb09 100644
--- a/drivers/misc/vmware_balloon.c
+++ b/drivers/misc/vmware_balloon.c
@@ -45,7 +45,7 @@
 
 MODULE_AUTHOR("VMware, Inc.");
 MODULE_DESCRIPTION("VMware Memory Control (Balloon) Driver");
-MODULE_VERSION("1.2.1.0-K");
+MODULE_VERSION("1.2.1.1-k");
 MODULE_ALIAS("dmi:*:svnVMware*:*");
 MODULE_ALIAS("vmware_vmmemctl");
 MODULE_LICENSE("GPL");
@@ -101,6 +101,8 @@ MODULE_LICENSE("GPL");
 /* Maximum number of page allocations without yielding processor */
 #define VMW_BALLOON_YIELD_THRESHOLD	1024
 
+/* Maximum number of refused pages we accumulate during inflation cycle */
+#define VMW_BALLOON_MAX_REFUSED		16
 
 /*
  * Hypervisor communication port definitions.
@@ -183,6 +185,7 @@ struct vmballoon {
 
 	/* transient list of non-balloonable pages */
 	struct list_head refused_pages;
+	unsigned int n_refused_pages;
 
 	/* balloon size in pages */
 	unsigned int size;
@@ -428,14 +431,21 @@ static int vmballoon_reserve_page(struct vmballoon *b, bool can_sleep)
 		/* inform monitor */
 		locked = vmballoon_send_lock_page(b, page_to_pfn(page));
 		if (!locked) {
+			STATS_INC(b->stats.refused_alloc);
+
 			if (b->reset_required) {
 				__free_page(page);
 				return -EIO;
 			}
 
-			/* place on list of non-balloonable pages, retry allocation */
+			/*
+			 * Place page on the list of non-balloonable pages
+			 * and retry allocation, unless we already accumulated
+			 * too many of them, in which case take a breather.
+			 */
 			list_add(&page->lru, &b->refused_pages);
-			STATS_INC(b->stats.refused_alloc);
+			if (++b->n_refused_pages >= VMW_BALLOON_MAX_REFUSED)
+				return -EIO;
 		}
 	} while (!locked);
 
@@ -483,6 +493,8 @@ static void vmballoon_release_refused_pages(struct vmballoon *b)
 		__free_page(page);
 		STATS_INC(b->stats.refused_free);
 	}
+
+	b->n_refused_pages = 0;
 }
 
 /*
-- 
1.6.6.1


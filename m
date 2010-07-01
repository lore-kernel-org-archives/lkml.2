Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932796Ab0GAVjs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:39:48 -0400
Received: from kroah.org ([198.145.64.141]:32983 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759200Ab0GAVOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:14:37 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:57 2010
Message-Id: <20100701174257.732521131@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:43:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dmitry Torokhov <dtor@vmware.com>, Bhavesh Davda <bhavesh@vmware.com>
Subject: [134/200] vmware balloon: clamp number of collected non-balloonable pages
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dtor@vmware.com>

commit 55adaa495edc429be84399f83df80dfb7f36598b upstream.

Limit number of accumulated non-balloonable pages during inflation cycle,
otherwise there is a chance we will be spinning and growing the list
forever.  This happens during torture tests when balloon target changes
while we are in the middle of inflation cycle and monitor starts refusing
to lock pages (since they are not needed anymore).

Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
Acked-by: Bhavesh Davda <bhavesh@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/misc/vmware_balloon.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

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
@@ -428,14 +431,21 @@ static int vmballoon_reserve_page(struct
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
 
@@ -483,6 +493,8 @@ static void vmballoon_release_refused_pa
 		__free_page(page);
 		STATS_INC(b->stats.refused_free);
 	}
+
+	b->n_refused_pages = 0;
 }
 
 /*



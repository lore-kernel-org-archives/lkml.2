Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776Ab0CWKiV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 06:38:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:35816 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008Ab0CWKiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 06:38:17 -0400
Message-ID: <4BA899C2.8020208@kernel.org>
Date: Tue, 23 Mar 2010 03:36:50 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [RFC PATCH -v3 1/2] lmb: seperate region array from lmb_region struct
References: <1269333587-1866-1-git-send-email-yinghai@kernel.org> <1269333587-1866-5-git-send-email-yinghai@kernel.org>
In-Reply-To: <1269333587-1866-5-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


lmb_init() connect them back.

also add region_array_size in lmb_region to tack the region array size.

-v3: seperate lmb core change to seperated patch

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 include/linux/lmb.h |    5 ++++-
 lib/lmb.c           |   11 ++++++++++-
 2 files changed, 14 insertions(+), 2 deletions(-)

Index: linux-2.6/include/linux/lmb.h
===================================================================
--- linux-2.6.orig/include/linux/lmb.h
+++ linux-2.6/include/linux/lmb.h
@@ -26,7 +26,8 @@ struct lmb_property {
 struct lmb_region {
 	unsigned long cnt;
 	u64 size;
-	struct lmb_property region[MAX_LMB_REGIONS+1];
+	struct lmb_property *region;
+	unsigned long region_array_size;
 };
 
 struct lmb {
@@ -37,6 +38,8 @@ struct lmb {
 };
 
 extern struct lmb lmb;
+extern struct lmb_property lmb_memory_region[MAX_LMB_REGIONS + 1];
+extern struct lmb_property lmb_reserved_region[MAX_LMB_REGIONS + 1];
 
 extern void __init lmb_init(void);
 extern void __init lmb_analyze(void);
Index: linux-2.6/lib/lmb.c
===================================================================
--- linux-2.6.orig/lib/lmb.c
+++ linux-2.6/lib/lmb.c
@@ -18,6 +18,8 @@
 #define LMB_ALLOC_ANYWHERE	0
 
 struct lmb lmb;
+struct lmb_property lmb_memory_region[MAX_LMB_REGIONS + 1];
+struct lmb_property lmb_reserved_region[MAX_LMB_REGIONS + 1];
 
 static int lmb_debug;
 
@@ -106,6 +108,11 @@ static void lmb_coalesce_regions(struct
 
 void __init lmb_init(void)
 {
+	lmb.memory.region   = lmb_memory_region;
+	lmb.memory.region_array_size   = ARRAY_SIZE(lmb_memory_region);
+	lmb.reserved.region = lmb_reserved_region;
+	lmb.reserved.region_array_size = ARRAY_SIZE(lmb_reserved_region);
+
 	/* Create a dummy zero size LMB which will get coalesced away later.
 	 * This simplifies the lmb_add() code below...
 	 */
@@ -169,7 +176,7 @@ static long lmb_add_region(struct lmb_re
 
 	if (coalesced)
 		return coalesced;
-	if (rgn->cnt >= MAX_LMB_REGIONS)
+	if (rgn->cnt >= (rgn->region_array_size - 1))
 		return -1;
 
 	/* Couldn't coalesce the LMB, so add it to the sorted table. */

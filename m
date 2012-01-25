Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750934Ab2AYV6Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 16:58:16 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:28419 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab2AYV6P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 16:58:15 -0500
MIME-Version: 1.0
Message-ID: <ea3b0850-dfe0-46db-9201-2bfef110848d@default>
Date: Wed, 25 Jan 2012 13:58:03 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Wilk <konrad.wilk@oracle.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Nebojsa Trpkovic <trx.lists@gmail.com>, minchan@kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, riel@redhat.com,
        Chris Mason <chris.mason@oracle.com>
Subject: [PATCH] mm: implement WasActive page flag (for improving cleancache)
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090207.4F207AE7.007B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Feedback welcome if there is a different/better way to do this
without using a page flag!)

Since about 2.6.27, the page replacement algorithm maintains
an "active" bit to help decide which pages are most eligible
to reclaim, see http://linux-mm.org/PageReplacementDesign 

This "active' information is also useful to cleancache but is lost
by the time that cleancache has the opportunity to preserve the
pageful of data.  This patch adds a new page flag "WasActive" to
retain the state.  The flag may possibly be useful elsewhere.

It is up to each cleancache backend to utilize the bit as
it desires.  The matching patch for zcache is included here
for clarification/discussion purposes, though it will need to
go through GregKH and the staging tree.

The patch resolves issues reported with cleancache which occur
especially during streaming workloads on older processors,
see https://lkml.org/lkml/2011/8/17/351 

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index e90a673..0f5e86a 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -51,6 +51,9 @@
  * PG_hwpoison indicates that a page got corrupted in hardware and contains
  * data with incorrect ECC bits that triggered a machine check. Accessing is
  * not safe since it may cause another machine check. Don't touch!
+ *
+ * PG_wasactive reflects that a page previously was promoted to active status.
+ * Such pages should be considered higher priority for cleancache backends.
  */
 
 /*
@@ -107,6 +110,9 @@ enum pageflags {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	PG_compound_lock,
 #endif
+#ifdef CONFIG_CLEANCACHE
+	PG_was_active,
+#endif
 	__NR_PAGEFLAGS,
 
 	/* Filesystems */
@@ -209,6 +215,10 @@ PAGEFLAG(SwapBacked, swapbacked) __CLEARPAGEFLAG(SwapBacked, swapbacked)
 
 __PAGEFLAG(SlobFree, slob_free)
 
+#ifdef CONFIG_CLEANCACHE
+PAGEFLAG(WasActive, was_active)
+#endif
+
 /*
  * Private page markings that may be used by the filesystem that owns the page
  * for its own purposes.
diff --git a/mm/vmscan.c b/mm/vmscan.c
index c52b235..fdd9e88 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -636,6 +636,8 @@ void putback_lru_page(struct page *page)
 	int was_unevictable = PageUnevictable(page);
 
 	VM_BUG_ON(PageLRU(page));
+	if (active)
+		SetPageWasActive(page);
 
 redo:
 	ClearPageUnevictable(page);
@@ -1429,6 +1431,7 @@ update_isolated_counts(struct mem_cgroup_zone *mz,
 		if (PageActive(page)) {
 			lru += LRU_ACTIVE;
 			ClearPageActive(page);
+			SetPageWasActive(page);
 			nr_active += numpages;
 		}
 		count[lru] += numpages;
@@ -1755,6 +1758,7 @@ static void shrink_active_list(unsigned long nr_to_scan,
 		}
 
 		ClearPageActive(page);	/* we are de-activating */
+		SetPageWasActive(page);
 		list_add(&page->lru, &l_inactive);
 	}
 
diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index 642840c..8c81ec2 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -1696,6 +1696,8 @@ static void zcache_cleancache_put_page(int pool_id,
 	u32 ind = (u32) index;
 	struct tmem_oid oid = *(struct tmem_oid *)&key;
 
+	if (!PageWasActive(page))
+		return;
 	if (likely(ind == index))
 		(void)zcache_put_page(LOCAL_CLIENT, pool_id, &oid, index, page);
 }
@@ -1710,6 +1712,8 @@ static int zcache_cleancache_get_page(int pool_id,
 
 	if (likely(ind == index))
 		ret = zcache_get_page(LOCAL_CLIENT, pool_id, &oid, index, page);
+	if (ret == 0)
+		SetPageWasActive(page);
 	return ret;
 }

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab1EIOuJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 10:50:09 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:41210 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab1EIOuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 10:50:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=pALRDev6WXcVneAX/+HnrB8y3IWRgTl+6r7lGSoqRDDiS81e4XaMpakeFX4nIvhwaG
         Kg12z7cnyUNA4TCtt949e2u4prrK84g5vfW/kfsowTFyFMo8j9d2eHQ/l71/mVqZq8/P
         qrt3Mh+RZwWiqtSyBZHIpG/ePFRwF7jHUU1DM=
MIME-Version: 1.0
Date: Mon, 9 May 2011 22:50:03 +0800
Message-ID: <BANLkTimU2X0p=wgFEbwg_J3z3rZXPAGntw@mail.gmail.com>
Subject: [PATCH] highmem: optimize searching for an empty entry in pkmap_count
From: jia zhang <jia.zhang2008@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>, a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does 2 things:

1. Always use entry zero in the first search round.
Entry zero of pkmap_count[] is not scanned for a searching empty entry during
the first search round before flush_all_zero_pkmaps() gets called. This causes
a leak in the utilization of empty entry. By moving last_pkmap_nr+1 to the end
of map_new_virtual(), entry zero of pkmap_count[] can be used in first time.

2. Optimize searching for an empty entry.
To find out an empty entry depends on a good result of a linear search for
pkmap_count[] with last_pkmap_nr as an index. By calling
flush_all_zero_pkmaps(), more empty entries *may* be freed. Also,
flush_all_zero_pkmaps() can give a hint of the lowest position of empty entry
and thus make the search faster. Without this optimization, the search have
to be continued, even though empty entry is not available at all. In addition,
this optimization can delay the next moment of calling
flush_all_zero_pkmaps(), unless no more empty entries are available. It is a
case of performance improvement.

Signed-off-by: Lans Zhang <jia.zhang@windriver.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: a.p.zijlstra@chello.nl
---
 mm/highmem.c |   80 +++++++++++++++++++++++++++++++++------------------------
 1 files changed, 46 insertions(+), 34 deletions(-)

diff --git a/mm/highmem.c b/mm/highmem.c
index 693394d..0961972 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -94,7 +94,10 @@ static DECLARE_WAIT_QUEUE_HEAD(pkmap_map_wait);
 		do { spin_unlock(&kmap_lock); (void)(flags); } while (0)
 #endif

-static void flush_all_zero_pkmaps(void)
+/*
+ * Return true if we have at least one usable entry.
+ */
+static int flush_all_zero_pkmaps(void)
 {
 	int i;
 	int need_flush = 0;
@@ -129,10 +132,19 @@ static void flush_all_zero_pkmaps(void)
 			  &pkmap_page_table[i]);

 		set_page_address(page, NULL);
-		need_flush = 1;
+		/*
+		 * Record the first or lowest usable entry to speed up
+		 * the searching for an usable entry in map_new_virtual().
+		 */
+		if (!need_flush) {
+			if (i < last_pkmap_nr || pkmap_count[last_pkmap_nr])
+				last_pkmap_nr = i;
+			need_flush = 1;
+		}
 	}
 	if (need_flush)
 		flush_tlb_kernel_range(PKMAP_ADDR(0), PKMAP_ADDR(LAST_PKMAP));
+	return need_flush;
 }

 /**
@@ -148,50 +160,50 @@ void kmap_flush_unused(void)
 static inline unsigned long map_new_virtual(struct page *page)
 {
 	unsigned long vaddr;
-	int count;
+	int nr;

 start:
-	count = LAST_PKMAP;
 	/* Find an empty entry */
-	for (;;) {
-		last_pkmap_nr = (last_pkmap_nr + 1) & LAST_PKMAP_MASK;
-		if (!last_pkmap_nr) {
-			flush_all_zero_pkmaps();
-			count = LAST_PKMAP;
-		}
-		if (!pkmap_count[last_pkmap_nr])
-			break;	/* Found a usable entry */
-		if (--count)
-			continue;
+	for (nr = last_pkmap_nr; nr < LAST_PKMAP; nr++) {
+		if (!pkmap_count[nr])
+			goto found;
+	}
+	last_pkmap_nr = nr;

+	/* Try to get an empty entry to avoid sleep */
+	if (!flush_all_zero_pkmaps()) {
 		/*
 		 * Sleep for somebody else to unmap their entries
 		 */
-		{
-			DECLARE_WAITQUEUE(wait, current);
-
-			__set_current_state(TASK_UNINTERRUPTIBLE);
-			add_wait_queue(&pkmap_map_wait, &wait);
-			unlock_kmap();
-			schedule();
-			remove_wait_queue(&pkmap_map_wait, &wait);
-			lock_kmap();
-
-			/* Somebody else might have mapped it while we slept */
-			if (page_address(page))
-				return (unsigned long)page_address(page);
-
-			/* Re-start */
-			goto start;
-		}
+		DECLARE_WAITQUEUE(wait, current);
+
+		__set_current_state(TASK_UNINTERRUPTIBLE);
+		add_wait_queue(&pkmap_map_wait, &wait);
+		unlock_kmap();
+		schedule();
+		remove_wait_queue(&pkmap_map_wait, &wait);
+		lock_kmap();
+
+		/* Somebody else might have mapped it while we slept */
+		if (!page_address(page))
+			return (unsigned long)page_address(page);
+
+		/* Re-start */
+		goto start;
 	}
-	vaddr = PKMAP_ADDR(last_pkmap_nr);
+	/* Really get it */
+	nr = last_pkmap_nr;
+
+found:
+	vaddr = PKMAP_ADDR(nr);
 	set_pte_at(&init_mm, vaddr,
-		   &(pkmap_page_table[last_pkmap_nr]), mk_pte(page, kmap_prot));
+		   &(pkmap_page_table[nr]), mk_pte(page, kmap_prot));

-	pkmap_count[last_pkmap_nr] = 1;
+	pkmap_count[nr] = 1;
 	set_page_address(page, (void *)vaddr);

+	last_pkmap_nr = (nr + 1) & LAST_PKMAP_MASK;
+
 	return vaddr;
 }

-- 
1.6.6

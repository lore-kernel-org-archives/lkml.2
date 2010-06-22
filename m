Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab0FVTqd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 15:46:33 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:51322 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755395Ab0FVTqb (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 22 Jun 2010 15:46:31 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       iommu@lists.linux-foundation.org, albert_herranz@yahoo.es,
       x86@kernel.org
Cc: Alex Nixon <alex.nixon@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 03/19] xen: Rename the balloon lock
Date: Tue, 22 Jun 2010 15:42:36 -0400
Message-Id: <1277235772-26757-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1277235772-26757-1-git-send-email-konrad.wilk@oracle.com>
References: <1277235772-26757-1-git-send-email-konrad.wilk@oracle.com>
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090209.4C2112AA.0060:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Nixon <alex.nixon@citrix.com>

* xen_create_contiguous_region needs access to the balloon lock to
  ensure memory doesn't change under its feet, so expose the balloon
  lock
* Change the name of the lock to xen_reservation_lock, to imply it's
  now less-specific usage.

[ Impact: cleanup ]

Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/mmu.c             |    7 +++++++
 drivers/xen/balloon.c          |   15 ++++-----------
 include/xen/interface/memory.h |    8 ++++++++
 3 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index a5577f5..9e0d82f 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -70,6 +70,13 @@
 
 #define MMU_UPDATE_HISTO	30
 
+/*
+ * Protects atomic reservation decrease/increase against concurrent increases.
+ * Also protects non-atomic updates of current_pages and driver_pages, and
+ * balloon lists.
+ */
+DEFINE_SPINLOCK(xen_reservation_lock);
+
 #ifdef CONFIG_XEN_DEBUG_FS
 
 static struct {
diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index 1a0d8c2..500290b 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -85,13 +85,6 @@ static struct sys_device balloon_sysdev;
 
 static int register_balloon(struct sys_device *sysdev);
 
-/*
- * Protects atomic reservation decrease/increase against concurrent increases.
- * Also protects non-atomic updates of current_pages and driver_pages, and
- * balloon lists.
- */
-static DEFINE_SPINLOCK(balloon_lock);
-
 static struct balloon_stats balloon_stats;
 
 /* We increase/decrease in batches which fit in a page */
@@ -210,7 +203,7 @@ static int increase_reservation(unsigned long nr_pages)
 	if (nr_pages > ARRAY_SIZE(frame_list))
 		nr_pages = ARRAY_SIZE(frame_list);
 
-	spin_lock_irqsave(&balloon_lock, flags);
+	spin_lock_irqsave(&xen_reservation_lock, flags);
 
 	page = balloon_first_page();
 	for (i = 0; i < nr_pages; i++) {
@@ -254,7 +247,7 @@ static int increase_reservation(unsigned long nr_pages)
 	balloon_stats.current_pages += rc;
 
  out:
-	spin_unlock_irqrestore(&balloon_lock, flags);
+	spin_unlock_irqrestore(&xen_reservation_lock, flags);
 
 	return rc < 0 ? rc : rc != nr_pages;
 }
@@ -299,7 +292,7 @@ static int decrease_reservation(unsigned long nr_pages)
 	kmap_flush_unused();
 	flush_tlb_all();
 
-	spin_lock_irqsave(&balloon_lock, flags);
+	spin_lock_irqsave(&xen_reservation_lock, flags);
 
 	/* No more mappings: invalidate P2M and add to balloon. */
 	for (i = 0; i < nr_pages; i++) {
@@ -315,7 +308,7 @@ static int decrease_reservation(unsigned long nr_pages)
 
 	balloon_stats.current_pages -= nr_pages;
 
-	spin_unlock_irqrestore(&balloon_lock, flags);
+	spin_unlock_irqrestore(&xen_reservation_lock, flags);
 
 	return need_sleep;
 }
diff --git a/include/xen/interface/memory.h b/include/xen/interface/memory.h
index af36ead..e6adce6 100644
--- a/include/xen/interface/memory.h
+++ b/include/xen/interface/memory.h
@@ -9,6 +9,8 @@
 #ifndef __XEN_PUBLIC_MEMORY_H__
 #define __XEN_PUBLIC_MEMORY_H__
 
+#include <linux/spinlock.h>
+
 /*
  * Increase or decrease the specified domain's memory reservation. Returns a
  * -ve errcode on failure, or the # extents successfully allocated or freed.
@@ -142,4 +144,10 @@ struct xen_translate_gpfn_list {
 };
 DEFINE_GUEST_HANDLE_STRUCT(xen_translate_gpfn_list);
 
+
+/*
+ * Prevent the balloon driver from changing the memory reservation
+ * during a driver critical region.
+ */
+extern spinlock_t xen_reservation_lock;
 #endif /* __XEN_PUBLIC_MEMORY_H__ */
-- 
1.7.0.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243Ab2DFMlC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 08:41:02 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51707 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757140Ab2DFMlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 08:41:00 -0400
From: Ido Yariv <ido@wizery.com>
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Shai Fultheim <shai@scalemp.com>, Ido Yariv <ido@wizery.com>
Subject: [PATCH] x86: Avoid contention on cpa_lock if possible
Date: Fri,  6 Apr 2012 15:40:49 +0300
Message-Id: <1333716049-26122-1-git-send-email-ido@wizery.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shai Fultheim <shai@scalemp.com>

Some architectures (e.g. vSMP) do not require to serialize cpa, for
instance, by guaranteeing that the most recent TLB entry will always be
used.

To avoid needless contention on cpa_lock, do not lock/unlock it on such
architectures.

Signed-off-by: Shai Fultheim <shai@scalemp.com>
[ido@wizery.com: added should_serialize_cpa, handled potential race, and
                 reworded the commit message]
Signed-off-by: Ido Yariv <ido@wizery.com>
---
 arch/x86/mm/pageattr.c |   36 ++++++++++++++++++++++++++++--------
 1 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index e1ebde3..4d606ee 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -501,7 +501,7 @@ out_unlock:
 	return do_split;
 }
 
-static int split_large_page(pte_t *kpte, unsigned long address)
+static int split_large_page(pte_t *kpte, unsigned long address, bool cpa_locked)
 {
 	unsigned long pfn, pfninc = 1;
 	unsigned int i, level;
@@ -509,10 +509,10 @@ static int split_large_page(pte_t *kpte, unsigned long address)
 	pgprot_t ref_prot;
 	struct page *base;
 
-	if (!debug_pagealloc)
+	if (cpa_locked)
 		spin_unlock(&cpa_lock);
 	base = alloc_pages(GFP_KERNEL | __GFP_NOTRACK, 0);
-	if (!debug_pagealloc)
+	if (cpa_locked)
 		spin_lock(&cpa_lock);
 	if (!base)
 		return -ENOMEM;
@@ -624,7 +624,8 @@ static int __cpa_process_fault(struct cpa_data *cpa, unsigned long vaddr,
 	}
 }
 
-static int __change_page_attr(struct cpa_data *cpa, int primary)
+static int __change_page_attr(struct cpa_data *cpa, int primary,
+			      bool cpa_locked)
 {
 	unsigned long address;
 	int do_split, err;
@@ -693,7 +694,7 @@ repeat:
 	/*
 	 * We have to split the large page:
 	 */
-	err = split_large_page(kpte, address);
+	err = split_large_page(kpte, address, cpa_locked);
 	if (!err) {
 		/*
 	 	 * Do a global flush tlb after splitting the large page
@@ -787,9 +788,20 @@ static int cpa_process_alias(struct cpa_data *cpa)
 	return 0;
 }
 
+static inline bool should_serialize_cpa(void)
+{
+	/*
+	 * Some architectures do not require cpa() to be serialized, for
+	 * instance, by guaranteeing that the most recent TLB entry will be
+	 * used.
+	 */
+	return !debug_pagealloc && !is_vsmp_box();
+}
+
 static int __change_page_attr_set_clr(struct cpa_data *cpa, int checkalias)
 {
 	int ret, numpages = cpa->numpages;
+	bool cpa_locked = false;
 
 	while (numpages) {
 		/*
@@ -801,10 +813,18 @@ static int __change_page_attr_set_clr(struct cpa_data *cpa, int checkalias)
 		if (cpa->flags & (CPA_ARRAY | CPA_PAGES_ARRAY))
 			cpa->numpages = 1;
 
-		if (!debug_pagealloc)
+		if (should_serialize_cpa()) {
 			spin_lock(&cpa_lock);
-		ret = __change_page_attr(cpa, checkalias);
-		if (!debug_pagealloc)
+			/*
+			 * In order to avoid any race conditions in which
+			 * should_serialize_cpa() returns a different value
+			 * after the lock was acquired, make sure locking is
+			 * consitent and don't ever leave the lock acquired.
+			 */
+			cpa_locked = true;
+		}
+		ret = __change_page_attr(cpa, checkalias, cpa_locked);
+		if (cpa_locked)
 			spin_unlock(&cpa_lock);
 		if (ret)
 			return ret;
-- 
1.7.7.6


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab1AJKfa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 05:35:30 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:24430 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351Ab1AJKf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 05:35:26 -0500
X-IronPort-AV: E=Sophos;i="4.60,299,1291611600"; 
   d="scan'208";a="130293742"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Jeremy.Fitzhardinge@citrix.com,
        konrad.wilk@oracle.com,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 05/12] xen: add m2p override mechanism
Date: Mon, 10 Jan 2011 10:36:34 +0000
Message-Id: <1294655801-16230-5-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1101101012190.2390@kaball-desktop>
References: <alpine.DEB.2.00.1101101012190.2390@kaball-desktop>
X-OriginalArrivalTime: 10 Jan 2011 10:35:25.0565 (UTC) FILETIME=[17880AD0:01CBB0B2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Add a simple hashtable based mechanism to override some portions of the
m2p, so that we can find out the pfn corresponding to an mfn of a
granted page. In fact entries corresponding to granted pages in the m2p
hold the original pfn value of the page in the source domain that
granted it.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/include/asm/xen/page.h |   16 ++++++-
 arch/x86/xen/p2m.c              |   80 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 93 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
index 8760cc6..50f0a0f 100644
--- a/arch/x86/include/asm/xen/page.h
+++ b/arch/x86/include/asm/xen/page.h
@@ -42,6 +42,11 @@ extern unsigned int   machine_to_phys_order;
 extern unsigned long get_phys_to_machine(unsigned long pfn);
 extern bool set_phys_to_machine(unsigned long pfn, unsigned long mfn);
 
+extern void m2p_add_override(unsigned long mfn, struct page *page);
+extern void m2p_remove_override(struct page *page);
+extern struct page *m2p_find_override(unsigned long mfn);
+extern unsigned long m2p_find_override_pfn(unsigned long mfn, unsigned long pfn);
+
 static inline unsigned long pfn_to_mfn(unsigned long pfn)
 {
 	unsigned long mfn;
@@ -72,9 +77,6 @@ static inline unsigned long mfn_to_pfn(unsigned long mfn)
 	if (xen_feature(XENFEAT_auto_translated_physmap))
 		return mfn;
 
-	if (unlikely((mfn >> machine_to_phys_order) != 0))
-		return ~0;
-
 	pfn = 0;
 	/*
 	 * The array access can fail (e.g., device space beyond end of RAM).
@@ -83,6 +85,14 @@ static inline unsigned long mfn_to_pfn(unsigned long mfn)
 	 */
 	__get_user(pfn, &machine_to_phys_mapping[mfn]);
 
+	/*
+	 * If this appears to be a foreign mfn (because the pfn
+	 * doesn't map back to the mfn), then check the local override
+	 * table to see if there's a better pfn to use.
+	 */
+	if (get_phys_to_machine(pfn) != mfn)
+		pfn = m2p_find_override_pfn(mfn, pfn);
+
 	return pfn;
 }
 
diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 259ec3b..8db19d5 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -27,6 +27,8 @@
 
 #include <linux/init.h>
 #include <linux/module.h>
+#include <linux/list.h>
+#include <linux/hash.h>
 
 #include <asm/cache.h>
 #include <asm/setup.h>
@@ -37,6 +39,8 @@
 
 #include "xen-ops.h"
 
+static void __init m2p_override_init(void);
+
 unsigned long xen_max_p2m_pfn __read_mostly;
 
 #define P2M_PER_PAGE		(PAGE_SIZE / sizeof(unsigned long))
@@ -234,6 +238,8 @@ void __init xen_build_dynamic_phys_to_machine(void)
 
 		p2m_top[topidx][mididx] = &mfn_list[pfn];
 	}
+
+	m2p_override_init();
 }
 
 unsigned long get_phys_to_machine(unsigned long pfn)
@@ -374,3 +380,77 @@ bool set_phys_to_machine(unsigned long pfn, unsigned long mfn)
 
 	return true;
 }
+
+#define M2P_OVERRIDE_HASH_SHIFT	10
+#define M2P_OVERRIDE_HASH	(1 << M2P_OVERRIDE_HASH_SHIFT)
+
+static RESERVE_BRK_ARRAY(struct list_head, m2p_overrides, M2P_OVERRIDE_HASH);
+static DEFINE_SPINLOCK(m2p_override_lock);
+
+static void __init m2p_override_init(void)
+{
+	unsigned i;
+
+	m2p_overrides = extend_brk(sizeof(*m2p_overrides) * M2P_OVERRIDE_HASH,
+				   sizeof(unsigned long));
+
+	for (i = 0; i < M2P_OVERRIDE_HASH; i++)
+		INIT_LIST_HEAD(&m2p_overrides[i]);
+}
+
+static unsigned long mfn_hash(unsigned long mfn)
+{
+	return hash_long(mfn, M2P_OVERRIDE_HASH_SHIFT);
+}
+
+/* Add an MFN override for a particular page */
+void m2p_add_override(unsigned long mfn, struct page *page)
+{
+	unsigned long flags;
+	page->private = mfn;
+
+	spin_lock_irqsave(&m2p_override_lock, flags);
+	list_add(&page->lru,  &m2p_overrides[mfn_hash(mfn)]);
+	spin_unlock_irqrestore(&m2p_override_lock, flags);
+}
+
+void m2p_remove_override(struct page *page)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&m2p_override_lock, flags);
+	list_del(&page->lru);
+	spin_unlock_irqrestore(&m2p_override_lock, flags);
+}
+
+struct page *m2p_find_override(unsigned long mfn)
+{
+	unsigned long flags;
+	struct list_head *bucket = &m2p_overrides[mfn_hash(mfn)];
+	struct page *p, *ret;
+
+	ret = NULL;
+
+	spin_lock_irqsave(&m2p_override_lock, flags);
+
+	list_for_each_entry(p, bucket, lru) {
+		if (p->private == mfn) {
+			ret = p;
+			break;
+		}
+	}
+
+	spin_unlock_irqrestore(&m2p_override_lock, flags);
+
+	return ret;
+}
+
+unsigned long m2p_find_override_pfn(unsigned long mfn, unsigned long pfn)
+{
+	struct page *p = m2p_find_override(mfn);
+	unsigned long ret = pfn;
+
+	if (p)
+		ret = page_to_pfn(p);
+
+	return ret;
+}
-- 
1.5.6.5


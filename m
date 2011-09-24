Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751733Ab1IXE46 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 00:56:58 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:25070 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab1IXE45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 00:56:57 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        jeremy@goop.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/3] xen/p2m: Make debug/xen/mmu/p2m visible again.
Date: Fri, 23 Sep 2011 22:28:18 -0400
Message-Id: <1316831299-4144-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316831299-4144-1-git-send-email-konrad.wilk@oracle.com>
References: <1316831299-4144-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090205.4E7D6315.014F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We dropped a lot of the MMU debugfs in favour of using
tracing API - but there is one which just provides
mostly static information that was made invisible by this change.

Bring it back.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/include/asm/xen/page.h |    3 ---
 arch/x86/xen/mmu.c              |   14 --------------
 arch/x86/xen/p2m.c              |   35 ++++++++++++++++++++++++++++++++---
 3 files changed, 32 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
index 64a619d..bc12c12 100644
--- a/arch/x86/include/asm/xen/page.h
+++ b/arch/x86/include/asm/xen/page.h
@@ -53,9 +53,6 @@ extern int m2p_remove_override(struct page *page, bool clear_pte);
 extern struct page *m2p_find_override(unsigned long mfn);
 extern unsigned long m2p_find_override_pfn(unsigned long mfn, unsigned long pfn);
 
-#ifdef CONFIG_XEN_DEBUG_FS
-extern int p2m_dump_show(struct seq_file *m, void *v);
-#endif
 static inline unsigned long pfn_to_mfn(unsigned long pfn)
 {
 	unsigned long mfn;
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 3c9aecd..4df0444 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -2362,17 +2362,3 @@ out:
 	return err;
 }
 EXPORT_SYMBOL_GPL(xen_remap_domain_mfn_range);
-
-#ifdef CONFIG_XEN_DEBUG_FS
-static int p2m_dump_open(struct inode *inode, struct file *filp)
-{
-	return single_open(filp, p2m_dump_show, NULL);
-}
-
-static const struct file_operations p2m_dump_fops = {
-	.open		= p2m_dump_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-#endif /* CONFIG_XEN_DEBUG_FS */
diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 58efeb9..cc2f8dc 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -782,8 +782,9 @@ unsigned long m2p_find_override_pfn(unsigned long mfn, unsigned long pfn)
 EXPORT_SYMBOL_GPL(m2p_find_override_pfn);
 
 #ifdef CONFIG_XEN_DEBUG_FS
-
-int p2m_dump_show(struct seq_file *m, void *v)
+#include <linux/debugfs.h>
+#include "debugfs.h"
+static int p2m_dump_show(struct seq_file *m, void *v)
 {
 	static const char * const level_name[] = { "top", "middle",
 						"entry", "abnormal" };
@@ -856,4 +857,32 @@ int p2m_dump_show(struct seq_file *m, void *v)
 #undef TYPE_PFN
 #undef TYPE_UNKNOWN
 }
-#endif
+
+static int p2m_dump_open(struct inode *inode, struct file *filp)
+{
+	return single_open(filp, p2m_dump_show, NULL);
+}
+
+static const struct file_operations p2m_dump_fops = {
+	.open		= p2m_dump_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static struct dentry *d_mmu_debug;
+
+static int __init xen_p2m_debugfs(void)
+{
+	struct dentry *d_xen = xen_init_debugfs();
+
+	if (d_xen == NULL)
+		return -ENOMEM;
+
+	d_mmu_debug = debugfs_create_dir("mmu", d_xen);
+
+	debugfs_create_file("p2m", 0600, d_mmu_debug, NULL, &p2m_dump_fops);
+	return 0;
+}
+fs_initcall(xen_p2m_debugfs);
+#endif /* CONFIG_XEN_DEBUG_FS */
-- 
1.7.4.1


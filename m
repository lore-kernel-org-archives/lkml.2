Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab1AaXK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 18:10:59 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:22809 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198Ab1AaXJR (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 31 Jan 2011 18:09:17 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, Xen-devel@lists.xensource.com,
        konrad@kernel.org, jeremy@goop.org
Cc: hpa@zytor.com, stefano.stabellini@eu.citrix.com,
        Ian.Campbell@eu.citrix.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 08/11] xen/debugfs: Add 'p2m' file for printing out the P2M layout.
Date: Mon, 31 Jan 2011 17:44:33 -0500
Message-Id: <1296513876-31415-9-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296513876-31415-1-git-send-email-konrad.wilk@oracle.com>
References: <1296513876-31415-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We walk over the whole P2M tree and construct a simplified view of
which PFN regions belong to what level and what type they are.

Only enabled if CONFIG_XEN_DEBUG_FS is set.

[v2: UNKN->UNKNOWN, use uninitialized_var]
[v3: Rebased on top of mmu->p2m code split]
[v4: Fixed the else if]
Reviewed-by: Ian Campbell <Ian.Campbell@eu.citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/include/asm/xen/page.h |    3 +
 arch/x86/xen/mmu.c              |   14 +++++++
 arch/x86/xen/p2m.c              |   78 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 95 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
index 47c1b59..7b17fc5 100644
--- a/arch/x86/include/asm/xen/page.h
+++ b/arch/x86/include/asm/xen/page.h
@@ -52,6 +52,9 @@ extern int m2p_remove_override(struct page *page);
 extern struct page *m2p_find_override(unsigned long mfn);
 extern unsigned long m2p_find_override_pfn(unsigned long mfn, unsigned long pfn);
 
+#ifdef CONFIG_XEN_DEBUG_FS
+extern int p2m_dump_show(struct seq_file *m, void *v);
+#endif
 static inline unsigned long pfn_to_mfn(unsigned long pfn)
 {
 	unsigned long mfn;
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 9c9e076..b13b6ca 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -46,6 +46,7 @@
 #include <linux/module.h>
 #include <linux/gfp.h>
 #include <linux/memblock.h>
+#include <linux/seq_file.h>
 
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
@@ -2367,6 +2368,18 @@ EXPORT_SYMBOL_GPL(xen_remap_domain_mfn_range);
 
 #ifdef CONFIG_XEN_DEBUG_FS
 
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
 static struct dentry *d_mmu_debug;
 
 static int __init xen_mmu_debugfs(void)
@@ -2422,6 +2435,7 @@ static int __init xen_mmu_debugfs(void)
 	debugfs_create_u32("prot_commit_batched", 0444, d_mmu_debug,
 			   &mmu_stats.prot_commit_batched);
 
+	debugfs_create_file("p2m", 0600, d_mmu_debug, NULL, &p2m_dump_fops);
 	return 0;
 }
 fs_initcall(xen_mmu_debugfs);
diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 70bd49b..38ae7fe 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -30,6 +30,7 @@
 #include <linux/list.h>
 #include <linux/hash.h>
 #include <linux/sched.h>
+#include <linux/seq_file.h>
 
 #include <asm/cache.h>
 #include <asm/setup.h>
@@ -636,3 +637,80 @@ unsigned long m2p_find_override_pfn(unsigned long mfn, unsigned long pfn)
 	return ret;
 }
 EXPORT_SYMBOL_GPL(m2p_find_override_pfn);
+
+#ifdef CONFIG_XEN_DEBUG_FS
+
+int p2m_dump_show(struct seq_file *m, void *v)
+{
+	static const char * const level_name[] = { "top", "middle",
+						"entry", "abnormal" };
+	static const char * const type_name[] = { "identity", "missing",
+						"pfn", "abnormal"};
+#define TYPE_IDENTITY 0
+#define TYPE_MISSING 1
+#define TYPE_PFN 2
+#define TYPE_UNKNOWN 3
+	unsigned long pfn, prev_pfn_type = 0, prev_pfn_level = 0;
+	unsigned int uninitialized_var(prev_level);
+	unsigned int uninitialized_var(prev_type);
+
+	if (!p2m_top)
+		return 0;
+
+	for (pfn = 0; pfn < MAX_DOMAIN_PAGES; pfn++) {
+		unsigned topidx = p2m_top_index(pfn);
+		unsigned mididx = p2m_mid_index(pfn);
+		unsigned idx = p2m_index(pfn);
+		unsigned lvl, type;
+
+		lvl = 4;
+		type = TYPE_UNKNOWN;
+		if (p2m_top[topidx] == p2m_mid_missing) {
+			lvl = 0; type = TYPE_MISSING;
+		} else if (p2m_top[topidx] == NULL) {
+			lvl = 0; type = TYPE_UNKNOWN;
+		} else if (p2m_top[topidx][mididx] == NULL) {
+			lvl = 1; type = TYPE_UNKNOWN;
+		} else if (p2m_top[topidx][mididx] == p2m_identity) {
+			lvl = 1; type = TYPE_IDENTITY;
+		} else if (p2m_top[topidx][mididx] == p2m_missing) {
+			lvl = 1; type = TYPE_MISSING;
+		} else if (p2m_top[topidx][mididx][idx] == 0) {
+			lvl = 2; type = TYPE_UNKNOWN;
+		} else if (p2m_top[topidx][mididx][idx] == IDENTITY_FRAME(pfn)) {
+			lvl = 2; type = TYPE_IDENTITY;
+		} else if (p2m_top[topidx][mididx][idx] == INVALID_P2M_ENTRY) {
+			lvl = 2; type = TYPE_MISSING;
+		} else if (p2m_top[topidx][mididx][idx] == pfn) {
+			lvl = 2; type = TYPE_PFN;
+		} else if (p2m_top[topidx][mididx][idx] != pfn) {
+			lvl = 2; type = TYPE_PFN;
+		}
+		if (pfn == 0) {
+			prev_level = lvl;
+			prev_type = type;
+		}
+		if (pfn == MAX_DOMAIN_PAGES-1) {
+			lvl = 3;
+			type = TYPE_UNKNOWN;
+		}
+		if (prev_type != type) {
+			seq_printf(m, " [0x%lx->0x%lx] %s\n",
+				prev_pfn_type, pfn, type_name[prev_type]);
+			prev_pfn_type = pfn;
+			prev_type = type;
+		}
+		if (prev_level != lvl) {
+			seq_printf(m, " [0x%lx->0x%lx] level %s\n",
+				prev_pfn_level, pfn, level_name[prev_level]);
+			prev_pfn_level = pfn;
+			prev_level = lvl;
+		}
+	}
+	return 0;
+#undef TYPE_IDENTITY
+#undef TYPE_MISSING
+#undef TYPE_PFN
+#undef TYPE_UNKNOWN
+}
+#endif
-- 
1.7.1


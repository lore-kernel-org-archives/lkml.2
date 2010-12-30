Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab0L3TtU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 14:49:20 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:37495 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041Ab0L3TtT (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 30 Dec 2010 14:49:19 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        <hpa@zytor.com>, Ian Campbell <Ian.Campbell@citrix.com>
Cc: Jan Beulich <JBeulich@novell.com>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 5/8] xen/debug: Print out all pages in the P2M.
Date: Thu, 30 Dec 2010 14:48:34 -0500
Message-Id: <1293738517-7287-6-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1293738517-7287-1-git-send-email-konrad.wilk@oracle.com>
References: <1293738517-7287-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We walk over the whole P2M and constructing a simplified view of which
regions belong to what level and what type they are.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/mmu.c |   84 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 84 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 36bdd2d..e9dfdd6 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -46,6 +46,7 @@
 #include <linux/module.h>
 #include <linux/gfp.h>
 #include <linux/memblock.h>
+#include <linux/seq_file.h>
 
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
@@ -2764,6 +2765,88 @@ EXPORT_SYMBOL_GPL(xen_remap_domain_mfn_range);
 
 #ifdef CONFIG_XEN_DEBUG_FS
 
+static int p2m_dump_show(struct seq_file *m, void *v)
+{
+	static const char * const level_name[] = { "top", "middle",
+						"entry", "abnormal" };
+	static const char * const type_name[] = { "identity", "missing",
+						"pfn", "abnormal"};
+#define TYPE_IDENTITY 0
+#define TYPE_MISSING 1
+#define TYPE_PFN 2
+#define TYPE_UNKN 3
+	unsigned long pfn, prev_pfn_type = 0, prev_pfn_level = 0;
+	unsigned int prev_level = 0;
+	unsigned int prev_type = TYPE_UNKN;
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
+		type = TYPE_UNKN;
+		if (p2m_top[topidx] == p2m_mid_missing) {
+			lvl = 0; type = TYPE_MISSING;
+		} else if (p2m_top[topidx] == p2m_mid_identity) {
+			lvl = 0; type = TYPE_IDENTITY;
+		} else if (p2m_top[topidx][mididx] == p2m_identity) {
+			lvl = 1; type = TYPE_IDENTITY;
+		} else if (p2m_top[topidx][mididx][idx] == pfn) {
+			lvl = 2; type = TYPE_IDENTITY;
+		} else if (p2m_top[topidx] == NULL) {
+			lvl = 0; type = TYPE_UNKN;
+		} else if (p2m_top[topidx][mididx] == NULL) {
+			lvl = 1; type = TYPE_UNKN;
+		} else if (p2m_top[topidx][mididx][idx] == 0) {
+			lvl = 2; type = TYPE_UNKN;
+		} else if (p2m_top[topidx][mididx] == p2m_missing) {
+			lvl = 1; type = TYPE_MISSING;
+		} else if (p2m_top[topidx][mididx][idx] == INVALID_P2M_ENTRY) {
+			lvl = 2; type = TYPE_MISSING;
+		} else if (p2m_top[topidx][mididx][idx] != pfn) {
+			lvl = 2; type = TYPE_PFN;
+		}
+		if (pfn == 0) {
+			prev_level = lvl;
+			prev_type = type;
+		}
+		if (pfn == MAX_DOMAIN_PAGES-1) {
+			lvl = 3;
+			type = TYPE_UNKN;
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
+}
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
 static struct dentry *d_mmu_debug;
 
 static int __init xen_mmu_debugfs(void)
@@ -2819,6 +2902,7 @@ static int __init xen_mmu_debugfs(void)
 	debugfs_create_u32("prot_commit_batched", 0444, d_mmu_debug,
 			   &mmu_stats.prot_commit_batched);
 
+	debugfs_create_file("p2m", 0600, d_mmu_debug, NULL, &p2m_dump_fops);
 	return 0;
 }
 fs_initcall(xen_mmu_debugfs);
-- 
1.7.1


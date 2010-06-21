Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156Ab0FUQYf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 12:24:35 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:23732 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758121Ab0FUQY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 12:24:29 -0400
X-IronPort-AV: E=Sophos;i="4.53,453,1272859200"; 
   d="scan'208";a="102450271"
From: stefano@stabellini.net
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Stefano.Stabellini@eu.citrix.com,
       sheng@linux.intel.com, ddutile@redhat.com, jeremy@goop.org,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 13/13] Call HVMOP_pagetable_dying on exit_mmap
Date: Mon, 21 Jun 2010 17:14:07 +0100
Message-Id: <1277136847-13266-13-git-send-email-stefano@stabellini.net>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1006211456360.18470@kaball-desktop>
References: <alpine.DEB.2.00.1006211456360.18470@kaball-desktop>
X-OriginalArrivalTime: 21 Jun 2010 16:15:00.0488 (UTC) FILETIME=[E6135080:01CB115C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

When a pagetable is about to be destroyed, we notify Xen so that the
hypervisor can clear the related shadow pagetable.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/xen/enlighten.c           |    1 +
 arch/x86/xen/mmu.c                 |   33 +++++++++++++++++++++++++++++++++
 arch/x86/xen/mmu.h                 |    1 +
 include/xen/interface/hvm/hvm_op.h |   11 +++++++++++
 4 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 5126b53..c8d9198 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1321,4 +1321,5 @@ void __init xen_hvm_guest_init(void)
 	have_vcpu_info_placement = 0;
 	x86_init.irqs.intr_init = xen_init_IRQ;
 	xen_hvm_init_time_ops();
+	xen_hvm_init_mmu_ops();
 }
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 914f046..726c5bd 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -58,6 +58,7 @@
 
 #include <xen/page.h>
 #include <xen/interface/xen.h>
+#include <xen/interface/hvm/hvm_op.h>
 #include <xen/interface/version.h>
 #include <xen/hvc-console.h>
 
@@ -1941,6 +1942,38 @@ void __init xen_init_mmu_ops(void)
 	pv_mmu_ops = xen_mmu_ops;
 }
 
+static void xen_hvm_exit_mmap(struct mm_struct *mm)
+{
+	struct xen_hvm_pagetable_dying a;
+	int rc;
+
+	a.domid = DOMID_SELF;
+	a.gpa = __pa(mm->pgd);
+	rc = HYPERVISOR_hvm_op(HVMOP_pagetable_dying, &a);
+	WARN_ON(rc < 0);
+}
+
+static int is_pagetable_dying_supported(void)
+{
+	struct xen_hvm_pagetable_dying a;
+	int rc = 0;
+
+	a.domid = DOMID_SELF;
+	a.gpa = 0x00;
+	rc = HYPERVISOR_hvm_op(HVMOP_pagetable_dying, &a);
+	if (rc == -EINVAL) {
+		printk(KERN_INFO "HVMOP_pagetable_dying not supported\n");
+		return 0;
+	}
+	return 1;
+}
+
+void __init xen_hvm_init_mmu_ops(void)
+{
+	if (is_pagetable_dying_supported())
+		pv_mmu_ops.exit_mmap = xen_hvm_exit_mmap;
+}
+
 #ifdef CONFIG_XEN_DEBUG_FS
 
 static struct dentry *d_mmu_debug;
diff --git a/arch/x86/xen/mmu.h b/arch/x86/xen/mmu.h
index 5fe6bc7..fa938c4 100644
--- a/arch/x86/xen/mmu.h
+++ b/arch/x86/xen/mmu.h
@@ -60,4 +60,5 @@ void  xen_ptep_modify_prot_commit(struct mm_struct *mm, unsigned long addr,
 unsigned long xen_read_cr2_direct(void);
 
 extern void xen_init_mmu_ops(void);
+extern void xen_hvm_init_mmu_ops(void);
 #endif	/* _XEN_MMU_H */
diff --git a/include/xen/interface/hvm/hvm_op.h b/include/xen/interface/hvm/hvm_op.h
index 73c8c7e..a4827f4 100644
--- a/include/xen/interface/hvm/hvm_op.h
+++ b/include/xen/interface/hvm/hvm_op.h
@@ -32,4 +32,15 @@ struct xen_hvm_param {
 };
 DEFINE_GUEST_HANDLE_STRUCT(xen_hvm_param);
 
+/* Hint from PV drivers for pagetable destruction. */
+#define HVMOP_pagetable_dying       9
+struct xen_hvm_pagetable_dying {
+    /* Domain with a pagetable about to be destroyed. */
+    domid_t  domid;
+    /* guest physical address of the toplevel pagetable dying */
+    aligned_u64 gpa;
+};
+typedef struct xen_hvm_pagetable_dying xen_hvm_pagetable_dying_t;
+DEFINE_GUEST_HANDLE_STRUCT(xen_hvm_pagetable_dying_t);
+ 
 #endif /* __XEN_PUBLIC_HVM_HVM_OP_H__ */
-- 
1.7.0.4


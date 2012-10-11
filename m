Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759478Ab2JKVxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 17:53:31 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:35520 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759432Ab2JKVxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 17:53:24 -0400
Date: Thu, 11 Oct 2012 14:53:17 -0700
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2 1/7]: PVH: basic and header changes, elfnote changes, ...
Message-ID: <20121011145317.51655302@mantra.us.oracle.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


PVH: is a PV linux guest that has extended capabilities. This patch allows it to be configured and enabled. Also, basic header file changes to add new subcalls to physmap hypercall. Lastly, mfn_to_local_pfn must return mfn for paging mode translate

Signed-off-by: Mukesh R <mukesh.rathor@oracle.com>
---
 arch/x86/include/asm/xen/page.h |    3 +++
 arch/x86/xen/Kconfig            |   10 ++++++++++
 arch/x86/xen/xen-head.S         |   11 ++++++++++-
 include/xen/interface/memory.h  |   30 +++++++++++++++++++++++++++---
 include/xen/interface/physdev.h |   10 ++++++++++
 5 files changed, 60 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
index 472b9b7..6af440d 100644
--- a/arch/x86/include/asm/xen/page.h
+++ b/arch/x86/include/asm/xen/page.h
@@ -159,6 +159,9 @@ static inline xpaddr_t machine_to_phys(xmaddr_t machine)
 static inline unsigned long mfn_to_local_pfn(unsigned long mfn)
 {
 	unsigned long pfn = mfn_to_pfn(mfn);
+
+	if (xen_feature(XENFEAT_auto_translated_physmap))
+		return mfn;
 	if (get_phys_to_machine(pfn) != mfn)
 		return -1; /* force !pfn_valid() */
 	return pfn;
diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
index fdce49c..9323b8c 100644
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -50,3 +50,13 @@ config XEN_DEBUG_FS
 	  Enable statistics output and various tuning options in debugfs.
 	  Enabling this option may incur a significant performance overhead.
 
+config XEN_X86_PVH
+	bool "Support for running as a PVH guest (EXPERIMENTAL)"
+	depends on X86_64 && XEN && INTEL_IOMMU && EXPERIMENTAL
+	default n
+	help
+	   This option enables support for running as a PVH guest (PV guest
+	   using hardware extensions) under a suitably capable hypervisor.
+	   This option is EXPERIMETNAL because the hypervisor interfaces
+	   which it uses are not yet considered stable therefore backwards and
+	   forwards compatibility is not yet guaranteed.  If unsure, say N.
diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
index 7faed58..3e65ece 100644
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -13,6 +13,15 @@
 #include <xen/interface/elfnote.h>
 #include <asm/xen/interface.h>
 
+#ifdef CONFIG_XEN_X86_PVH
+#define FEATURES_PVH "| writable_descriptor_tables" \
+		     "| auto_translated_physmap" \
+		     "| supervisor_mode_kernel" \
+		     "| hvm_callback_vector"
+#else
+#define FEATURES_PVH /* Not supported */
+#endif
+
 	__INIT
 ENTRY(startup_xen)
 	cld
@@ -95,7 +104,7 @@ NEXT_HYPERCALL(arch_6)
 #endif
 	ELFNOTE(Xen, XEN_ELFNOTE_ENTRY,          _ASM_PTR startup_xen)
 	ELFNOTE(Xen, XEN_ELFNOTE_HYPERCALL_PAGE, _ASM_PTR hypercall_page)
-	ELFNOTE(Xen, XEN_ELFNOTE_FEATURES,       .asciz "!writable_page_tables|pae_pgdir_above_4gb")
+	ELFNOTE(Xen, XEN_ELFNOTE_FEATURES,       .asciz "!writable_page_tables|pae_pgdir_above_4gb"FEATURES_PVH)
 	ELFNOTE(Xen, XEN_ELFNOTE_PAE_MODE,       .asciz "yes")
 	ELFNOTE(Xen, XEN_ELFNOTE_LOADER,         .asciz "generic")
 	ELFNOTE(Xen, XEN_ELFNOTE_L1_MFN_VALID,
diff --git a/include/xen/interface/memory.h b/include/xen/interface/memory.h
index d8e33a9..dbf4c6b 100644
--- a/include/xen/interface/memory.h
+++ b/include/xen/interface/memory.h
@@ -163,14 +163,22 @@ struct xen_add_to_physmap {
     /* Which domain to change the mapping for. */
     domid_t domid;
 
-    /* Number of pages to go through for gmfn_range */
-    uint16_t    size;
-
+    union {
+	/* Number of pages to go through for gmfn_range */
+	uint16_t    size;
+	/* IFF XENMAPSPACE_gmfn_foreign */
+	domid_t foreign_domid;
+    } u;
     /* Source mapping space. */
 #define XENMAPSPACE_shared_info 0 /* shared info page */
 #define XENMAPSPACE_grant_table 1 /* grant table page */
+#define XENMAPSPACE_gmfn        2 /* GMFN */
+#define XENMAPSPACE_gmfn_range  3 /* GMFN range */
+#define XENMAPSPACE_gmfn_foreign 4 /* GMFN from another guest */
     unsigned int space;
 
+#define XENMAPIDX_grant_table_status 0x80000000
+
     /* Index into source mapping space. */
     unsigned long idx;
 
@@ -237,4 +245,20 @@ DEFINE_GUEST_HANDLE_STRUCT(xen_memory_map);
  * during a driver critical region.
  */
 extern spinlock_t xen_reservation_lock;
+
+/*
+ * Unmaps the page appearing at a particular GPFN from the specified guest's
+ * pseudophysical address space.
+ * arg == addr of xen_remove_from_physmap_t.
+ */
+#define XENMEM_remove_from_physmap      15
+struct xen_remove_from_physmap {
+    /* Which domain to change the mapping for. */
+    domid_t domid;
+
+    /* GPFN of the current mapping of the page. */
+    xen_pfn_t gpfn;
+};
+DEFINE_GUEST_HANDLE_STRUCT(xen_remove_from_physmap);
+
 #endif /* __XEN_PUBLIC_MEMORY_H__ */
diff --git a/include/xen/interface/physdev.h b/include/xen/interface/physdev.h
index 9ce788d..3b9d5b6 100644
--- a/include/xen/interface/physdev.h
+++ b/include/xen/interface/physdev.h
@@ -258,6 +258,16 @@ struct physdev_pci_device {
     uint8_t devfn;
 };
 
+#define PHYSDEVOP_pvh_map_iomem        30
+struct physdev_map_iomem {
+    /* IN */
+    uint64_t first_gfn;
+    uint64_t first_mfn;
+    uint32_t nr_mfns;
+    uint32_t add_mapping;        /* 1 == add mapping;  0 == unmap */
+
+};
+
 /*
  * Notify that some PIRQ-bound event channels have been unmasked.
  * ** This command is obsolete since interface version 0x00030202 and is **
-- 
1.7.2.3


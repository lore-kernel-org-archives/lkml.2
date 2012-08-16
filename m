Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932862Ab2HPPhM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 11:37:12 -0400
Received: from smtp.citrix.com ([66.165.176.89]:38774 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932818Ab2HPPgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 11:36:47 -0400
X-IronPort-AV: E=Sophos;i="4.77,778,1336363200"; 
   d="scan'208";a="34869944"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: <xen-devel@lists.xensource.com>, <Stefano.Stabellini@eu.citrix.com>,
        <konrad.wilk@oracle.com>, <tim@xen.org>, <Ian.Campbell@citrix.com>,
        <linux-arm-kernel@lists.infradead.org>, <linaro-dev@lists.linaro.org>,
        <catalin.marinas@arm.com>, <arnd@arndb.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v3 08/25] xen/arm: Introduce xen_pfn_t for pfn and mfn types
Date: Thu, 16 Aug 2012 16:36:00 +0100
Message-ID: <1345131377-14713-8-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1208161618550.4850@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1208161618550.4850@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the original Xen headers have xen_pfn_t as mfn and pfn type, however
when they have been imported in Linux, xen_pfn_t has been replaced with
unsigned long. That might work for x86 and ia64 but it does not for arm.
Bring back xen_pfn_t and let each architecture define xen_pfn_t as they
see fit.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/arm/include/asm/xen/interface.h  |    4 ++++
 arch/ia64/include/asm/xen/interface.h |    5 ++++-
 arch/x86/include/asm/xen/interface.h  |    5 +++++
 include/xen/interface/grant_table.h   |    4 ++--
 include/xen/interface/memory.h        |    6 +++---
 include/xen/interface/platform.h      |    4 ++--
 include/xen/interface/xen.h           |    6 +++---
 include/xen/privcmd.h                 |    2 --
 8 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/arch/arm/include/asm/xen/interface.h b/arch/arm/include/asm/xen/interface.h
index 9e0ec5a..74c72b5 100644
--- a/arch/arm/include/asm/xen/interface.h
+++ b/arch/arm/include/asm/xen/interface.h
@@ -25,6 +25,9 @@
 	} while (0)
 
 #ifndef __ASSEMBLY__
+/* Explicitly size integers that represent pfns in the interface with
+ * Xen so that we can have one ABI that works for 32 and 64 bit guests. */
+typedef uint64_t xen_pfn_t;
 /* Guest handles for primitive C types. */
 __DEFINE_GUEST_HANDLE(uchar, unsigned char);
 __DEFINE_GUEST_HANDLE(uint,  unsigned int);
@@ -35,6 +38,7 @@ DEFINE_GUEST_HANDLE(long);
 DEFINE_GUEST_HANDLE(void);
 DEFINE_GUEST_HANDLE(uint64_t);
 DEFINE_GUEST_HANDLE(uint32_t);
+DEFINE_GUEST_HANDLE(xen_pfn_t);
 
 /* Maximum number of virtual CPUs in multi-processor guests. */
 #define MAX_VIRT_CPUS 1
diff --git a/arch/ia64/include/asm/xen/interface.h b/arch/ia64/include/asm/xen/interface.h
index 09d5f7f..686464e 100644
--- a/arch/ia64/include/asm/xen/interface.h
+++ b/arch/ia64/include/asm/xen/interface.h
@@ -67,6 +67,10 @@
 #define set_xen_guest_handle(hnd, val)	do { (hnd).p = val; } while (0)
 
 #ifndef __ASSEMBLY__
+/* Explicitly size integers that represent pfns in the public interface
+ * with Xen so that we could have one ABI that works for 32 and 64 bit
+ * guests. */
+typedef unsigned long xen_pfn_t;
 /* Guest handles for primitive C types. */
 __DEFINE_GUEST_HANDLE(uchar, unsigned char);
 __DEFINE_GUEST_HANDLE(uint, unsigned int);
@@ -79,7 +83,6 @@ DEFINE_GUEST_HANDLE(void);
 DEFINE_GUEST_HANDLE(uint64_t);
 DEFINE_GUEST_HANDLE(uint32_t);
 
-typedef unsigned long xen_pfn_t;
 DEFINE_GUEST_HANDLE(xen_pfn_t);
 #define PRI_xen_pfn	"lx"
 #endif
diff --git a/arch/x86/include/asm/xen/interface.h b/arch/x86/include/asm/xen/interface.h
index cbf0c9d..2289075 100644
--- a/arch/x86/include/asm/xen/interface.h
+++ b/arch/x86/include/asm/xen/interface.h
@@ -47,6 +47,10 @@
 #endif
 
 #ifndef __ASSEMBLY__
+/* Explicitly size integers that represent pfns in the public interface
+ * with Xen so that on ARM we can have one ABI that works for 32 and 64
+ * bit guests. */
+typedef unsigned long xen_pfn_t;
 /* Guest handles for primitive C types. */
 __DEFINE_GUEST_HANDLE(uchar, unsigned char);
 __DEFINE_GUEST_HANDLE(uint,  unsigned int);
@@ -57,6 +61,7 @@ DEFINE_GUEST_HANDLE(long);
 DEFINE_GUEST_HANDLE(void);
 DEFINE_GUEST_HANDLE(uint64_t);
 DEFINE_GUEST_HANDLE(uint32_t);
+DEFINE_GUEST_HANDLE(xen_pfn_t);
 #endif
 
 #ifndef HYPERVISOR_VIRT_START
diff --git a/include/xen/interface/grant_table.h b/include/xen/interface/grant_table.h
index a17d844..7da811b 100644
--- a/include/xen/interface/grant_table.h
+++ b/include/xen/interface/grant_table.h
@@ -338,7 +338,7 @@ DEFINE_GUEST_HANDLE_STRUCT(gnttab_dump_table);
 #define GNTTABOP_transfer                4
 struct gnttab_transfer {
     /* IN parameters. */
-    unsigned long mfn;
+    xen_pfn_t mfn;
     domid_t       domid;
     grant_ref_t   ref;
     /* OUT parameters. */
@@ -375,7 +375,7 @@ struct gnttab_copy {
 	struct {
 		union {
 			grant_ref_t ref;
-			unsigned long   gmfn;
+			xen_pfn_t   gmfn;
 		} u;
 		domid_t  domid;
 		uint16_t offset;
diff --git a/include/xen/interface/memory.h b/include/xen/interface/memory.h
index eac3ce1..abbbff0 100644
--- a/include/xen/interface/memory.h
+++ b/include/xen/interface/memory.h
@@ -31,7 +31,7 @@ struct xen_memory_reservation {
      *   OUT: GMFN bases of extents that were allocated
      *   (NB. This command also updates the mach_to_phys translation table)
      */
-    GUEST_HANDLE(ulong) extent_start;
+    GUEST_HANDLE(xen_pfn_t) extent_start;
 
     /* Number of extents, and size/alignment of each (2^extent_order pages). */
     unsigned long  nr_extents;
@@ -130,7 +130,7 @@ struct xen_machphys_mfn_list {
      * any large discontiguities in the machine address space, 2MB gaps in
      * the machphys table will be represented by an MFN base of zero.
      */
-    GUEST_HANDLE(ulong) extent_start;
+    GUEST_HANDLE(xen_pfn_t) extent_start;
 
     /*
      * Number of extents written to the above array. This will be smaller
@@ -172,7 +172,7 @@ struct xen_add_to_physmap {
     unsigned long idx;
 
     /* GPFN where the source mapping page should appear. */
-    unsigned long gpfn;
+    xen_pfn_t gpfn;
 };
 DEFINE_GUEST_HANDLE_STRUCT(xen_add_to_physmap);
 
diff --git a/include/xen/interface/platform.h b/include/xen/interface/platform.h
index 486653f..0bea470 100644
--- a/include/xen/interface/platform.h
+++ b/include/xen/interface/platform.h
@@ -54,7 +54,7 @@ DEFINE_GUEST_HANDLE_STRUCT(xenpf_settime_t);
 #define XENPF_add_memtype         31
 struct xenpf_add_memtype {
 	/* IN variables. */
-	unsigned long mfn;
+	xen_pfn_t mfn;
 	uint64_t nr_mfns;
 	uint32_t type;
 	/* OUT variables. */
@@ -84,7 +84,7 @@ struct xenpf_read_memtype {
 	/* IN variables. */
 	uint32_t reg;
 	/* OUT variables. */
-	unsigned long mfn;
+	xen_pfn_t mfn;
 	uint64_t nr_mfns;
 	uint32_t type;
 };
diff --git a/include/xen/interface/xen.h b/include/xen/interface/xen.h
index a890804..f6b8965 100644
--- a/include/xen/interface/xen.h
+++ b/include/xen/interface/xen.h
@@ -189,7 +189,7 @@ struct mmuext_op {
 	unsigned int cmd;
 	union {
 		/* [UN]PIN_TABLE, NEW_BASEPTR, NEW_USER_BASEPTR */
-		unsigned long mfn;
+		xen_pfn_t mfn;
 		/* INVLPG_LOCAL, INVLPG_ALL, SET_LDT */
 		unsigned long linear_addr;
 	} arg1;
@@ -429,11 +429,11 @@ struct start_info {
 	unsigned long nr_pages;     /* Total pages allocated to this domain.  */
 	unsigned long shared_info;  /* MACHINE address of shared info struct. */
 	uint32_t flags;             /* SIF_xxx flags.                         */
-	unsigned long store_mfn;    /* MACHINE page number of shared page.    */
+	xen_pfn_t store_mfn;        /* MACHINE page number of shared page.    */
 	uint32_t store_evtchn;      /* Event channel for store communication. */
 	union {
 		struct {
-			unsigned long mfn;  /* MACHINE page number of console page.   */
+			xen_pfn_t mfn;      /* MACHINE page number of console page.   */
 			uint32_t  evtchn;   /* Event channel for console page.        */
 		} domU;
 		struct {
diff --git a/include/xen/privcmd.h b/include/xen/privcmd.h
index 17857fb..59f1bd8 100644
--- a/include/xen/privcmd.h
+++ b/include/xen/privcmd.h
@@ -36,8 +36,6 @@
 #include <linux/types.h>
 #include <linux/compiler.h>
 
-typedef unsigned long xen_pfn_t;
-
 struct privcmd_hypercall {
 	__u64 op;
 	__u64 arg[5];
-- 
1.7.2.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320Ab2BWRte (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 12:49:34 -0500
Received: from smtp.citrix.com ([66.165.176.89]:12599 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755057Ab2BWRtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 12:49:32 -0500
X-IronPort-AV: E=Sophos;i="4.73,470,1325480400"; 
   d="scan'208";a="22387820"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: linux-kernel@vger.kernel.org
CC: xen-devel@lists.xensource.com, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
        linaro-dev@lists.linaro.org, david.vrabel@citrix.com,
        Ian.Campbell@citrix.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH-WIP 11/13] xen/arm: Introduce xen_pfn_t for pfn and mfn types
Date: Thu, 23 Feb 2012 17:48:32 +0000
Message-ID: <1330019314-20865-11-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1202231714590.23091@kaball-desktop>
References: <alpine.DEB.2.00.1202231714590.23091@kaball-desktop>
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
---
 arch/arm/include/asm/xen/interface.h  |    3 +++
 arch/ia64/include/asm/xen/interface.h |    3 ++-
 arch/x86/include/asm/xen/interface.h  |    3 +++
 include/xen/interface/grant_table.h   |    4 ++--
 include/xen/interface/memory.h        |    6 +++---
 include/xen/interface/platform.h      |    4 ++--
 include/xen/interface/xen.h           |    6 +++---
 include/xen/privcmd.h                 |    2 --
 8 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/arch/arm/include/asm/xen/interface.h b/arch/arm/include/asm/xen/interface.h
index 2ee39e8..65577de 100644
--- a/arch/arm/include/asm/xen/interface.h
+++ b/arch/arm/include/asm/xen/interface.h
@@ -24,6 +24,8 @@
 		(hnd) = val;				\
 	} while (0)
 
+typedef uint64_t xen_pfn_t;
+
 #ifndef __ASSEMBLY__
 /* Guest handles for primitive C types. */
 __DEFINE_GUEST_HANDLE(uchar, unsigned char);
@@ -33,6 +35,7 @@ DEFINE_GUEST_HANDLE(char);
 DEFINE_GUEST_HANDLE(int);
 DEFINE_GUEST_HANDLE(long);
 DEFINE_GUEST_HANDLE(void);
+DEFINE_GUEST_HANDLE(xen_pfn_t);
 #endif
 
 /* Maximum number of virtual CPUs in multi-processor guests. */
diff --git a/arch/ia64/include/asm/xen/interface.h b/arch/ia64/include/asm/xen/interface.h
index 1d2427d..18904ac 100644
--- a/arch/ia64/include/asm/xen/interface.h
+++ b/arch/ia64/include/asm/xen/interface.h
@@ -66,6 +66,8 @@
 #define GUEST_HANDLE_64(name)		GUEST_HANDLE(name)
 #define set_xen_guest_handle(hnd, val)	do { (hnd).p = val; } while (0)
 
+typedef unsigned long xen_pfn_t;
+
 #ifndef __ASSEMBLY__
 /* Guest handles for primitive C types. */
 __DEFINE_GUEST_HANDLE(uchar, unsigned char);
@@ -78,7 +80,6 @@ DEFINE_GUEST_HANDLE(long);
 DEFINE_GUEST_HANDLE(void);
 DEFINE_GUEST_HANDLE(uint64_t);
 
-typedef unsigned long xen_pfn_t;
 DEFINE_GUEST_HANDLE(xen_pfn_t);
 #define PRI_xen_pfn	"lx"
 #endif
diff --git a/arch/x86/include/asm/xen/interface.h b/arch/x86/include/asm/xen/interface.h
index a1f2db5..59a37ec 100644
--- a/arch/x86/include/asm/xen/interface.h
+++ b/arch/x86/include/asm/xen/interface.h
@@ -46,6 +46,8 @@
 #endif
 #endif
 
+typedef unsigned long xen_pfn_t;
+
 #ifndef __ASSEMBLY__
 /* Guest handles for primitive C types. */
 __DEFINE_GUEST_HANDLE(uchar, unsigned char);
@@ -56,6 +58,7 @@ DEFINE_GUEST_HANDLE(int);
 DEFINE_GUEST_HANDLE(long);
 DEFINE_GUEST_HANDLE(void);
 DEFINE_GUEST_HANDLE(uint64_t);
+DEFINE_GUEST_HANDLE(xen_pfn_t);
 #endif
 
 #ifndef HYPERVISOR_VIRT_START
diff --git a/include/xen/interface/grant_table.h b/include/xen/interface/grant_table.h
index 39e5717..1fd3a66 100644
--- a/include/xen/interface/grant_table.h
+++ b/include/xen/interface/grant_table.h
@@ -254,7 +254,7 @@ DEFINE_GUEST_HANDLE_STRUCT(gnttab_dump_table);
 #define GNTTABOP_transfer                4
 struct gnttab_transfer {
     /* IN parameters. */
-    unsigned long mfn;
+    xen_pfn_t mfn;
     domid_t       domid;
     grant_ref_t   ref;
     /* OUT parameters. */
@@ -291,7 +291,7 @@ struct gnttab_copy {
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
index c168468..1c172ce 100644
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
index 19354db..3edc110 100644
--- a/include/xen/interface/xen.h
+++ b/include/xen/interface/xen.h
@@ -192,7 +192,7 @@ struct mmuext_op {
 	unsigned int cmd;
 	union {
 		/* [UN]PIN_TABLE, NEW_BASEPTR, NEW_USER_BASEPTR */
-		unsigned long mfn;
+		xen_pfn_t mfn;
 		/* INVLPG_LOCAL, INVLPG_ALL, SET_LDT */
 		unsigned long linear_addr;
 	} arg1;
@@ -432,11 +432,11 @@ struct start_info {
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
index 4d58881..45c1aa1 100644
--- a/include/xen/privcmd.h
+++ b/include/xen/privcmd.h
@@ -37,8 +37,6 @@
 #include <linux/compiler.h>
 #include <xen/interface/xen.h>
 
-typedef unsigned long xen_pfn_t;
-
 struct privcmd_hypercall {
 	__u64 op;
 	__u64 arg[5];
-- 
1.7.2.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756994Ab2IQRkZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 13:40:25 -0400
Received: from smtp.citrix.com ([66.165.176.89]:52014 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756814Ab2IQRkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 13:40:20 -0400
X-IronPort-AV: E=Sophos;i="4.80,437,1344211200"; 
   d="scan'208";a="38105086"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <arnd@arndb.de>
CC: <linux@arm.linux.org.uk>, <linaro-dev@lists.linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <tim@xen.org>,
        <Ian.Campbell@citrix.com>, <konrad.wilk@oracle.com>,
        <Stefano.Stabellini@eu.citrix.com>, <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v5 08/17] xen/arm: Introduce xen_ulong_t for unsigned long
Date: Mon, 17 Sep 2012 18:38:54 +0100
Message-ID: <1347903543-2135-8-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1209171215490.29232@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1209171215490.29232@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the original Xen headers have xen_ulong_t as unsigned long type, however
when they have been imported in Linux, xen_ulong_t has been replaced with
unsigned long. That might work for x86 and ia64 but it does not for arm.
Bring back xen_ulong_t and let each architecture define xen_ulong_t as they
see fit.

Also explicitly size pointers (__DEFINE_GUEST_HANDLE) to 64 bit.


Changes in v3:

- remove the incorrect changes to multicall_entry;
- remove the change to apic_physbase.


Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/arm/include/asm/xen/interface.h  |    8 ++++++--
 arch/ia64/include/asm/xen/interface.h |    1 +
 arch/x86/include/asm/xen/interface.h  |    1 +
 include/xen/interface/memory.h        |   12 ++++++------
 include/xen/interface/physdev.h       |    2 +-
 include/xen/interface/version.h       |    2 +-
 6 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/arch/arm/include/asm/xen/interface.h b/arch/arm/include/asm/xen/interface.h
index 74c72b5..ae05e56 100644
--- a/arch/arm/include/asm/xen/interface.h
+++ b/arch/arm/include/asm/xen/interface.h
@@ -9,8 +9,11 @@
 
 #include <linux/types.h>
 
+#define uint64_aligned_t uint64_t __attribute__((aligned(8)))
+
 #define __DEFINE_GUEST_HANDLE(name, type) \
-	typedef type * __guest_handle_ ## name
+	typedef struct { union { type *p; uint64_aligned_t q; }; }  \
+        __guest_handle_ ## name
 
 #define DEFINE_GUEST_HANDLE_STRUCT(name) \
 	__DEFINE_GUEST_HANDLE(name, struct name)
@@ -21,13 +24,14 @@
 	do {						\
 		if (sizeof(hnd) == 8)			\
 			*(uint64_t *)&(hnd) = 0;	\
-		(hnd) = val;				\
+		(hnd).p = val;				\
 	} while (0)
 
 #ifndef __ASSEMBLY__
 /* Explicitly size integers that represent pfns in the interface with
  * Xen so that we can have one ABI that works for 32 and 64 bit guests. */
 typedef uint64_t xen_pfn_t;
+typedef uint64_t xen_ulong_t;
 /* Guest handles for primitive C types. */
 __DEFINE_GUEST_HANDLE(uchar, unsigned char);
 __DEFINE_GUEST_HANDLE(uint,  unsigned int);
diff --git a/arch/ia64/include/asm/xen/interface.h b/arch/ia64/include/asm/xen/interface.h
index 3d52a5b..e88c5de 100644
--- a/arch/ia64/include/asm/xen/interface.h
+++ b/arch/ia64/include/asm/xen/interface.h
@@ -71,6 +71,7 @@
  * with Xen so that we could have one ABI that works for 32 and 64 bit
  * guests. */
 typedef unsigned long xen_pfn_t;
+typedef unsigned long xen_ulong_t;
 /* Guest handles for primitive C types. */
 __DEFINE_GUEST_HANDLE(uchar, unsigned char);
 __DEFINE_GUEST_HANDLE(uint, unsigned int);
diff --git a/arch/x86/include/asm/xen/interface.h b/arch/x86/include/asm/xen/interface.h
index 555f94d..28fc621 100644
--- a/arch/x86/include/asm/xen/interface.h
+++ b/arch/x86/include/asm/xen/interface.h
@@ -51,6 +51,7 @@
  * with Xen so that on ARM we can have one ABI that works for 32 and 64
  * bit guests. */
 typedef unsigned long xen_pfn_t;
+typedef unsigned long xen_ulong_t;
 /* Guest handles for primitive C types. */
 __DEFINE_GUEST_HANDLE(uchar, unsigned char);
 __DEFINE_GUEST_HANDLE(uint,  unsigned int);
diff --git a/include/xen/interface/memory.h b/include/xen/interface/memory.h
index d8e33a9..b66d04c 100644
--- a/include/xen/interface/memory.h
+++ b/include/xen/interface/memory.h
@@ -34,7 +34,7 @@ struct xen_memory_reservation {
     GUEST_HANDLE(xen_pfn_t) extent_start;
 
     /* Number of extents, and size/alignment of each (2^extent_order pages). */
-    unsigned long  nr_extents;
+    xen_ulong_t  nr_extents;
     unsigned int   extent_order;
 
     /*
@@ -92,7 +92,7 @@ struct xen_memory_exchange {
      *     command will be non-zero.
      *  5. THIS FIELD MUST BE INITIALISED TO ZERO BY THE CALLER!
      */
-    unsigned long nr_exchanged;
+    xen_ulong_t nr_exchanged;
 };
 
 DEFINE_GUEST_HANDLE_STRUCT(xen_memory_exchange);
@@ -148,8 +148,8 @@ DEFINE_GUEST_HANDLE_STRUCT(xen_machphys_mfn_list);
  */
 #define XENMEM_machphys_mapping     12
 struct xen_machphys_mapping {
-    unsigned long v_start, v_end; /* Start and end virtual addresses.   */
-    unsigned long max_mfn;        /* Maximum MFN that can be looked up. */
+    xen_ulong_t v_start, v_end; /* Start and end virtual addresses.   */
+    xen_ulong_t max_mfn;        /* Maximum MFN that can be looked up. */
 };
 DEFINE_GUEST_HANDLE_STRUCT(xen_machphys_mapping_t);
 
@@ -172,7 +172,7 @@ struct xen_add_to_physmap {
     unsigned int space;
 
     /* Index into source mapping space. */
-    unsigned long idx;
+    xen_ulong_t idx;
 
     /* GPFN where the source mapping page should appear. */
     xen_pfn_t gpfn;
@@ -189,7 +189,7 @@ struct xen_translate_gpfn_list {
     domid_t domid;
 
     /* Length of list. */
-    unsigned long nr_gpfns;
+    xen_ulong_t nr_gpfns;
 
     /* List of GPFNs to translate. */
     GUEST_HANDLE(ulong) gpfn_list;
diff --git a/include/xen/interface/physdev.h b/include/xen/interface/physdev.h
index 9ce788d..f616514 100644
--- a/include/xen/interface/physdev.h
+++ b/include/xen/interface/physdev.h
@@ -56,7 +56,7 @@ struct physdev_eoi {
 #define PHYSDEVOP_pirq_eoi_gmfn_v2       28
 struct physdev_pirq_eoi_gmfn {
     /* IN */
-    unsigned long gmfn;
+    xen_ulong_t gmfn;
 };
 
 /*
diff --git a/include/xen/interface/version.h b/include/xen/interface/version.h
index dd58cf5..3030c81 100644
--- a/include/xen/interface/version.h
+++ b/include/xen/interface/version.h
@@ -45,7 +45,7 @@ struct xen_changeset_info {
 
 #define XENVER_platform_parameters 5
 struct xen_platform_parameters {
-    unsigned long virt_start;
+    xen_ulong_t virt_start;
 };
 
 #define XENVER_get_features 6
-- 
1.7.2.5


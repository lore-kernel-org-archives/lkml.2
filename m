Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab0I1MRj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 08:17:39 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:28611 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716Ab0I1MRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 08:17:35 -0400
X-IronPort-AV: E=Sophos;i="4.57,247,1283745600"; 
   d="scan'208";a="115729383"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Stephen Tweedie <sct@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 10/12] xen: add support for the platform_ops hypercall
Date: Tue, 28 Sep 2010 13:16:56 +0100
Message-Id: <1285676218-26218-10-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1009281217540.2864@kaball-desktop>
References: <alpine.DEB.2.00.1009281217540.2864@kaball-desktop>
X-OriginalArrivalTime: 28 Sep 2010 12:17:18.0573 (UTC) FILETIME=[183509D0:01CB5F07]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Tweedie <sct@redhat.com>

Minimal changes to get platform ops (renamed dom0_ops on pv_ops) working
on pv_ops builds.

[ Impact: add Xen hypercall definitions ]

Signed-off-by: Stephen Tweedie <sct@redhat.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/include/asm/xen/hypercall.h |    8 +++
 include/xen/interface/platform.h     |   96 ++++++++++++++++++++++++++++++++++
 2 files changed, 104 insertions(+), 0 deletions(-)
 create mode 100644 include/xen/interface/platform.h

diff --git a/arch/x86/include/asm/xen/hypercall.h b/arch/x86/include/asm/xen/hypercall.h
index 7fda040..186b13d 100644
--- a/arch/x86/include/asm/xen/hypercall.h
+++ b/arch/x86/include/asm/xen/hypercall.h
@@ -45,6 +45,7 @@
 #include <xen/interface/xen.h>
 #include <xen/interface/sched.h>
 #include <xen/interface/physdev.h>
+#include <xen/interface/platform.h>
 
 /*
  * The hypercall asms have to meet several constraints:
@@ -282,6 +283,13 @@ HYPERVISOR_set_timer_op(u64 timeout)
 }
 
 static inline int
+HYPERVISOR_dom0_op(struct xen_platform_op *platform_op)
+{
+	platform_op->interface_version = XENPF_INTERFACE_VERSION;
+	return _hypercall1(int, dom0_op, platform_op);
+}
+
+static inline int
 HYPERVISOR_set_debugreg(int reg, unsigned long value)
 {
 	return _hypercall2(int, set_debugreg, reg, value);
diff --git a/include/xen/interface/platform.h b/include/xen/interface/platform.h
new file mode 100644
index 0000000..3a8cc09
--- /dev/null
+++ b/include/xen/interface/platform.h
@@ -0,0 +1,96 @@
+/******************************************************************************
+ * platform.h
+ *
+ * Hardware platform operations. Intended for use by domain-0 kernel.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this software and associated documentation files (the "Software"), to
+ * deal in the Software without restriction, including without limitation the
+ * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
+ * sell copies of the Software, and to permit persons to whom the Software is
+ * furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ * Copyright (c) 2002-2006, K Fraser
+ */
+
+#ifndef __XEN_PUBLIC_PLATFORM_H__
+#define __XEN_PUBLIC_PLATFORM_H__
+
+#include "xen.h"
+
+#define XENPF_INTERFACE_VERSION 0x03000001
+
+/*
+ * Request memory range (@mfn, @mfn+@nr_mfns-1) to have type @type.
+ * On x86, @type is an architecture-defined MTRR memory type.
+ * On success, returns the MTRR that was used (@reg) and a handle that can
+ * be passed to XENPF_DEL_MEMTYPE to accurately tear down the new setting.
+ * (x86-specific).
+ */
+#define XENPF_add_memtype         31
+struct xenpf_add_memtype {
+    /* IN variables. */
+    unsigned long mfn;
+    uint64_t nr_mfns;
+    uint32_t type;
+    /* OUT variables. */
+    uint32_t handle;
+    uint32_t reg;
+};
+typedef struct xenpf_add_memtype xenpf_add_memtype_t;
+DEFINE_GUEST_HANDLE_STRUCT(xenpf_add_memtype_t);
+
+/*
+ * Tear down an existing memory-range type. If @handle is remembered then it
+ * should be passed in to accurately tear down the correct setting (in case
+ * of overlapping memory regions with differing types). If it is not known
+ * then @handle should be set to zero. In all cases @reg must be set.
+ * (x86-specific).
+ */
+#define XENPF_del_memtype         32
+struct xenpf_del_memtype {
+    /* IN variables. */
+    uint32_t handle;
+    uint32_t reg;
+};
+typedef struct xenpf_del_memtype xenpf_del_memtype_t;
+DEFINE_GUEST_HANDLE_STRUCT(xenpf_del_memtype_t);
+
+/* Read current type of an MTRR (x86-specific). */
+#define XENPF_read_memtype        33
+struct xenpf_read_memtype {
+    /* IN variables. */
+    uint32_t reg;
+    /* OUT variables. */
+    unsigned long mfn;
+    uint64_t nr_mfns;
+    uint32_t type;
+};
+typedef struct xenpf_read_memtype xenpf_read_memtype_t;
+DEFINE_GUEST_HANDLE_STRUCT(xenpf_read_memtype_t);
+
+struct xen_platform_op {
+	uint32_t cmd;
+	uint32_t interface_version; /* XENPF_INTERFACE_VERSION */
+	union {
+		struct xenpf_add_memtype       add_memtype;
+		struct xenpf_del_memtype       del_memtype;
+		struct xenpf_read_memtype      read_memtype;
+		uint8_t                        pad[128];
+	} u;
+};
+typedef struct xen_platform_op xen_platform_op_t;
+DEFINE_GUEST_HANDLE_STRUCT(xen_platform_op_t);
+
+#endif /* __XEN_PUBLIC_PLATFORM_H__ */
-- 
1.5.6.5


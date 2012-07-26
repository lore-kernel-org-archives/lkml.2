Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404Ab2GZPgp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 11:36:45 -0400
Received: from smtp.citrix.com ([66.165.176.89]:46239 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022Ab2GZPey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 11:34:54 -0400
X-IronPort-AV: E=Sophos;i="4.77,659,1336363200"; 
   d="scan'208";a="32688371"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: <xen-devel@lists.xensource.com>, <Stefano.Stabellini@eu.citrix.com>,
        <konrad.wilk@oracle.com>, <Ian.Campbell@citrix.com>, <tim@xen.org>,
        <linux-arm-kernel@lists.infradead.org>, <linaro-dev@lists.linaro.org>,
        <catalin.marinas@arm.com>, <arnd@arndb.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 02/24] xen/arm: hypercalls
Date: Thu, 26 Jul 2012 16:33:44 +0100
Message-ID: <1343316846-25860-2-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use r12 to pass the hypercall number to the hypervisor.

We need a register to pass the hypercall number because we might not
know it at compile time and HVC only takes an immediate argument.

Among the available registers r12 seems to be the best choice because it
is defined as "intra-procedure call scratch register".

Use the ISS to pass an hypervisor specific tag.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/include/asm/xen/hypercall.h |   50 ++++++++++++++++++++++++++
 arch/arm/xen/Makefile                |    2 +-
 arch/arm/xen/hypercall.S             |   65 ++++++++++++++++++++++++++++++++++
 3 files changed, 116 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/include/asm/xen/hypercall.h
 create mode 100644 arch/arm/xen/hypercall.S

diff --git a/arch/arm/include/asm/xen/hypercall.h b/arch/arm/include/asm/xen/hypercall.h
new file mode 100644
index 0000000..4ac0624
--- /dev/null
+++ b/arch/arm/include/asm/xen/hypercall.h
@@ -0,0 +1,50 @@
+/******************************************************************************
+ * hypercall.h
+ *
+ * Linux-specific hypervisor handling.
+ *
+ * Stefano Stabellini <stefano.stabellini@eu.citrix.com>, Citrix, 2012
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation; or, when distributed
+ * separately from the Linux kernel or incorporated into other
+ * software packages, subject to the following license:
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this source file (the "Software"), to deal in the Software without
+ * restriction, including without limitation the rights to use, copy, modify,
+ * merge, publish, distribute, sublicense, and/or sell copies of the Software,
+ * and to permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
+ * IN THE SOFTWARE.
+ */
+
+#ifndef _ASM_ARM_XEN_HYPERCALL_H
+#define _ASM_ARM_XEN_HYPERCALL_H
+
+#include <xen/interface/xen.h>
+
+long privcmd_call(unsigned call, unsigned long a1,
+		unsigned long a2, unsigned long a3,
+		unsigned long a4, unsigned long a5);
+int HYPERVISOR_xen_version(int cmd, void *arg);
+int HYPERVISOR_console_io(int cmd, int count, char *str);
+int HYPERVISOR_grant_table_op(unsigned int cmd, void *uop, unsigned int count);
+int HYPERVISOR_sched_op(int cmd, void *arg);
+int HYPERVISOR_event_channel_op(int cmd, void *arg);
+unsigned long HYPERVISOR_hvm_op(int op, void *arg);
+int HYPERVISOR_memory_op(unsigned int cmd, void *arg);
+int HYPERVISOR_physdev_op(int cmd, void *arg);
+
+#endif /* _ASM_ARM_XEN_HYPERCALL_H */
diff --git a/arch/arm/xen/Makefile b/arch/arm/xen/Makefile
index 0bad594..b9d6acc 100644
--- a/arch/arm/xen/Makefile
+++ b/arch/arm/xen/Makefile
@@ -1 +1 @@
-obj-y		:= enlighten.o
+obj-y		:= enlighten.o hypercall.o
diff --git a/arch/arm/xen/hypercall.S b/arch/arm/xen/hypercall.S
new file mode 100644
index 0000000..038cc5b
--- /dev/null
+++ b/arch/arm/xen/hypercall.S
@@ -0,0 +1,65 @@
+/******************************************************************************
+ * hypercall.S
+ *
+ * Xen hypercall wrappers
+ *
+ * The Xen hypercall calling convention is very similar to the ARM
+ * procedure calling convention: the first paramter is passed in r0, the
+ * second in r1, the third in r2 and the third in r3. Considering that
+ * Xen hypercalls have 5 arguments at most, the fifth paramter is passed
+ * in r4, differently from the procedure calling convention of using the
+ * stack for that case.
+ *
+ * The hypercall number is passed in r12.
+ *
+ * The return value is in r0.
+ *
+ * The hvc ISS is required to be 0xEA1, that is the Xen specific ARM
+ * hypercall tag.
+ *
+ * Stefano Stabellini <stefano.stabellini@eu.citrix.com>, Citrix, 2012
+ */
+
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+#include <xen/interface/xen.h>
+
+
+/* HVC 0xEA1 */
+#ifdef CONFIG_THUMB2_KERNEL
+#define xen_hvc .word 0xf7e08ea1
+#else
+#define xen_hvc .word 0xe140ea71
+#endif
+
+/* We need to save and restore r4, because Xen clobbers it. */
+#define HYPERCALL(hypercall)			\
+ENTRY(HYPERVISOR_##hypercall)			\
+	mov r12, #__HYPERVISOR_##hypercall;	\
+	xen_hvc;							\
+	mov pc, lr;							\
+ENDPROC(HYPERVISOR_##hypercall)
+
+                .text
+
+HYPERCALL(xen_version);
+HYPERCALL(console_io);
+HYPERCALL(grant_table_op);
+HYPERCALL(sched_op);
+HYPERCALL(event_channel_op);
+HYPERCALL(hvm_op);
+HYPERCALL(memory_op);
+HYPERCALL(physdev_op);
+
+ENTRY(privcmd_call)
+	stmdb	sp!, {r4}
+	mov r12, r0
+	mov r0, r1
+	mov r1, r2
+	mov r2, r3
+	ldr r3, [sp, #8]
+	ldr r4, [sp, #4]
+	xen_hvc
+	pop {r4}
+	mov pc, lr
+ENDPROC(privcmd_call);
-- 
1.7.2.5


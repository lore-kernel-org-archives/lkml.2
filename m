Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab2KLLuJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 06:50:09 -0500
Received: from alvesta.synopsys.com ([198.182.60.77]:51527 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab2KLLuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 06:50:04 -0500
From: <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <arnd@arndb.de>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [RFC Patch v1 34/55] ARC: futex
Date: Mon, 12 Nov 2012 17:18:52 +0530
Message-ID: <1352720953-24321-4-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1352720953-24321-1-git-send-email-vgupta@synopsys.com>
References: <1352720953-24321-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vineet Gupta <vgupta@synopsys.com>

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/include/asm/futex.h |  151 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 151 insertions(+), 0 deletions(-)
 create mode 100644 arch/arc/include/asm/futex.h

diff --git a/arch/arc/include/asm/futex.h b/arch/arc/include/asm/futex.h
new file mode 100644
index 0000000..4dc64dd
--- /dev/null
+++ b/arch/arc/include/asm/futex.h
@@ -0,0 +1,151 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Vineetg: August 2010: From Android kernel work
+ */
+
+#ifndef _ASM_FUTEX_H
+#define _ASM_FUTEX_H
+
+#include <linux/futex.h>
+#include <linux/preempt.h>
+#include <linux/uaccess.h>
+#include <asm/errno.h>
+
+#define __futex_atomic_op(insn, ret, oldval, uaddr, oparg)\
+							\
+	__asm__ __volatile__(				\
+	"1:	ld  %1, [%2]			\n"	\
+		insn				"\n"	\
+	"2:	st  %0, [%2]			\n"	\
+	"	mov %0, 0			\n"	\
+	"3:					\n"	\
+	"	.section .fixup,\"ax\"		\n"	\
+	"	.align  4			\n"	\
+	"4:	mov %0, %4			\n"	\
+	"	b   3b				\n"	\
+	"	.previous			\n"	\
+	"	.section __ex_table,\"a\"	\n"	\
+	"	.align  4			\n"	\
+	"	.word   1b, 4b			\n"	\
+	"	.word   2b, 4b			\n"	\
+	"	.previous			\n"	\
+							\
+	: "=&r" (ret), "=&r" (oldval)			\
+	: "r" (uaddr), "r" (oparg), "ir" (-EFAULT)	\
+	: "cc", "memory")
+
+static inline int futex_atomic_op_inuser(int encoded_op, u32 __user *uaddr)
+{
+	int op = (encoded_op >> 28) & 7;
+	int cmp = (encoded_op >> 24) & 15;
+	int oparg = (encoded_op << 8) >> 20;
+	int cmparg = (encoded_op << 20) >> 20;
+	int oldval = 0, ret;
+
+	if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28))
+		oparg = 1 << oparg;
+
+	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
+		return -EFAULT;
+
+	pagefault_disable();	/* implies preempt_disable() */
+
+	switch (op) {
+	case FUTEX_OP_SET:
+		__futex_atomic_op("mov %0, %3", ret, oldval, uaddr, oparg);
+		break;
+	case FUTEX_OP_ADD:
+		__futex_atomic_op("add %0, %1, %3", ret, oldval, uaddr, oparg);
+		break;
+	case FUTEX_OP_OR:
+		__futex_atomic_op("or  %0, %1, %3", ret, oldval, uaddr, oparg);
+		break;
+	case FUTEX_OP_ANDN:
+		__futex_atomic_op("bic %0, %1, %3", ret, oldval, uaddr, oparg);
+		break;
+	case FUTEX_OP_XOR:
+		__futex_atomic_op("xor %0, %1, %3", ret, oldval, uaddr, oparg);
+		break;
+	default:
+		ret = -ENOSYS;
+	}
+
+	pagefault_enable();	/* subsumes preempt_enable() */
+
+	if (!ret) {
+		switch (cmp) {
+		case FUTEX_OP_CMP_EQ:
+			ret = (oldval == cmparg);
+			break;
+		case FUTEX_OP_CMP_NE:
+			ret = (oldval != cmparg);
+			break;
+		case FUTEX_OP_CMP_LT:
+			ret = (oldval < cmparg);
+			break;
+		case FUTEX_OP_CMP_GE:
+			ret = (oldval >= cmparg);
+			break;
+		case FUTEX_OP_CMP_LE:
+			ret = (oldval <= cmparg);
+			break;
+		case FUTEX_OP_CMP_GT:
+			ret = (oldval > cmparg);
+			break;
+		default:
+			ret = -ENOSYS;
+		}
+	}
+	return ret;
+}
+
+/* Compare-xchg with preemption disabled.
+ *  Notes:
+ *      -Best-Effort: Exchg happens only if compare succeeds.
+ *          If compare fails, returns; leaving retry/looping to upper layers
+ *      -successful cmp-xchg: return orig value in @addr (same as cmp val)
+ *      -Compare fails: return orig value in @addr
+ *      -user access r/w fails: return -EFAULT
+ */
+static inline int
+futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr, u32 oldval,
+					u32 newval)
+{
+	u32 val;
+
+	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
+		return -EFAULT;
+
+	pagefault_disable();	/* implies preempt_disable() */
+
+	/* TBD : can use llock/scond */
+	__asm__ __volatile__(
+	"1:	ld    %0, [%3]	\n"
+	"	brne  %0, %1, 3f	\n"
+	"2:	st    %2, [%3]	\n"
+	"3:	\n"
+	"	.section .fixup,\"ax\"	\n"
+	"4:	mov %0, %4	\n"
+	"	b   3b	\n"
+	"	.previous	\n"
+	"	.section __ex_table,\"a\"	\n"
+	"	.align  4	\n"
+	"	.word   1b, 4b	\n"
+	"	.word   2b, 4b	\n"
+	"	.previous\n"
+	: "=&r"(val)
+	: "r"(oldval), "r"(newval), "r"(uaddr), "ir"(-EFAULT)
+	: "cc", "memory");
+
+	pagefault_enable();	/* subsumes preempt_enable() */
+
+	*uval = val;
+	return val;
+}
+
+#endif
-- 
1.7.4.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419Ab0LCQAD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 11:00:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473Ab0LCQAC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 11:00:02 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH] MN10300: Implement asm/syscall.h
To: torvalds@osdl.org, akpm@linux-foundation.org
From: David Howells <dhowells@redhat.com>
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org
Date: Fri, 03 Dec 2010 15:59:50 +0000
Message-ID: <20101203155950.26704.552.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.15-97-g9680-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement asm/syscall.h for the MN10300 arch.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/include/asm/syscall.h |  117 ++++++++++++++++++++++++++++++++++++
 1 files changed, 117 insertions(+), 0 deletions(-)
 create mode 100644 arch/mn10300/include/asm/syscall.h


diff --git a/arch/mn10300/include/asm/syscall.h b/arch/mn10300/include/asm/syscall.h
new file mode 100644
index 0000000..b44b0bb
--- /dev/null
+++ b/arch/mn10300/include/asm/syscall.h
@@ -0,0 +1,117 @@
+/* Access to user system call parameters and results
+ *
+ * See asm-generic/syscall.h for function descriptions.
+ *
+ * Copyright (C) 2010 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _ASM_SYSCALL_H
+#define _ASM_SYSCALL_H
+
+#include <linux/sched.h>
+#include <linux/err.h>
+
+extern const unsigned long sys_call_table[];
+
+static inline int syscall_get_nr(struct task_struct *task, struct pt_regs *regs)
+{
+	return regs->orig_d0;
+}
+
+static inline void syscall_rollback(struct task_struct *task,
+				    struct pt_regs *regs)
+{
+	regs->d0 = regs->orig_d0;
+}
+
+static inline long syscall_get_error(struct task_struct *task,
+				     struct pt_regs *regs)
+{
+	unsigned long error = regs->d0;
+	return IS_ERR_VALUE(error) ? error : 0;
+}
+
+static inline long syscall_get_return_value(struct task_struct *task,
+					    struct pt_regs *regs)
+{
+	return regs->d0;
+}
+
+static inline void syscall_set_return_value(struct task_struct *task,
+					    struct pt_regs *regs,
+					    int error, long val)
+{
+	regs->d0 = (long) error ?: val;
+}
+
+static inline void syscall_get_arguments(struct task_struct *task,
+					 struct pt_regs *regs,
+					 unsigned int i, unsigned int n,
+					 unsigned long *args)
+{
+	switch (i) {
+	case 0:
+		if (!n--) break;
+		*args++ = regs->a0;
+	case 1:
+		if (!n--) break;
+		*args++ = regs->d1;
+	case 2:
+		if (!n--) break;
+		*args++ = regs->a3;
+	case 3:
+		if (!n--) break;
+		*args++ = regs->a2;
+	case 4:
+		if (!n--) break;
+		*args++ = regs->d3;
+	case 5:
+		if (!n--) break;
+		*args++ = regs->d2;
+	case 6:
+		if (!n--) break;
+	default:
+		BUG();
+		break;
+	}
+}
+
+static inline void syscall_set_arguments(struct task_struct *task,
+					 struct pt_regs *regs,
+					 unsigned int i, unsigned int n,
+					 const unsigned long *args)
+{
+	switch (i) {
+	case 0:
+		if (!n--) break;
+		regs->a0 = *args++;
+	case 1:
+		if (!n--) break;
+		regs->d1 = *args++;
+	case 2:
+		if (!n--) break;
+		regs->a3 = *args++;
+	case 3:
+		if (!n--) break;
+		regs->a2 = *args++;
+	case 4:
+		if (!n--) break;
+		regs->d3 = *args++;
+	case 5:
+		if (!n--) break;
+		regs->d2 = *args++;
+	case 6:
+		if (!n--) break;
+	default:
+		BUG();
+		break;
+	}
+}
+
+#endif /* _ASM_SYSCALL_H */


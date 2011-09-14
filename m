Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab1IQAqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 20:46:19 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:7362 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755977Ab1IQAqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 20:46:16 -0400
Message-Id: <093448$3hstsr@wolverine01.qualcomm.com>
X-IronPort-AV: E=McAfee;i="5400,1158,6471"; a="119437211"
From: Richard Kuo <rkuo@codeaurora.org>
Date: Wed, 14 Sep 2011 13:18:48 -0500
Subject: [PATCH v4 04/36] Hexagon: Add atomic ops support
To: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/hexagon/include/asm/atomic.h |  164 +++++++++++++++++++++++++++++++++++++
 1 files changed, 164 insertions(+), 0 deletions(-)
 create mode 100644 arch/hexagon/include/asm/atomic.h

diff --git a/arch/hexagon/include/asm/atomic.h b/arch/hexagon/include/asm/atomic.h
new file mode 100644
index 0000000..e220f90
--- /dev/null
+++ b/arch/hexagon/include/asm/atomic.h
@@ -0,0 +1,164 @@
+/*
+ * Atomic operations for the Hexagon architecture
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef _ASM_ATOMIC_H
+#define _ASM_ATOMIC_H
+
+#include <linux/types.h>
+
+#define ATOMIC_INIT(i)		{ (i) }
+#define atomic_set(v, i)	((v)->counter = (i))
+
+/**
+ * atomic_read - reads a word, atomically
+ * @v: pointer to atomic value
+ *
+ * Assumes all word reads on our architecture are atomic.
+ */
+#define atomic_read(v)		((v)->counter)
+
+/**
+ * atomic_xchg - atomic
+ * @v: pointer to memory to change
+ * @new: new value (technically passed in a register -- see xchg)
+ */
+#define atomic_xchg(v, new)	(xchg(&((v)->counter), (new)))
+
+
+/**
+ * atomic_cmpxchg - atomic compare-and-exchange values
+ * @v: pointer to value to change
+ * @old:  desired old value to match
+ * @new:  new value to put in
+ *
+ * Parameters are then pointer, value-in-register, value-in-register,
+ * and the output is the old value.
+ *
+ * Apparently this is complicated for archs that don't support
+ * the memw_locked like we do (or it's broken or whatever).
+ *
+ * Kind of the lynchpin of the rest of the generically defined routines.
+ * Remember V2 had that bug with dotnew predicate set by memw_locked.
+ *
+ * "old" is "expected" old val, __oldval is actual old value
+ */
+static inline int atomic_cmpxchg(atomic_t *v, int old, int new)
+{
+	int __oldval;
+
+	asm volatile(
+		"1:	%0 = memw_locked(%1);\n"
+		"	{ P0 = cmp.eq(%0,%2);\n"
+		"	  if (!P0.new) jump:nt 2f; }\n"
+		"	memw_locked(%1,P0) = %3;\n"
+		"	if (!P0) jump 1b;\n"
+		"2:\n"
+		: "=&r" (__oldval)
+		: "r" (&v->counter), "r" (old), "r" (new)
+		: "memory", "p0"
+	);
+
+	return __oldval;
+}
+
+static inline int atomic_add_return(int i, atomic_t *v)
+{
+	int output;
+
+	__asm__ __volatile__ (
+		"1:	%0 = memw_locked(%1);\n"
+		"	%0 = add(%0,%2);\n"
+		"	memw_locked(%1,P3)=%0;\n"
+		"	if !P3 jump 1b;\n"
+		: "=&r" (output)
+		: "r" (&v->counter), "r" (i)
+		: "memory", "p3"
+	);
+	return output;
+
+}
+
+#define atomic_add(i, v) atomic_add_return(i, (v))
+
+static inline int atomic_sub_return(int i, atomic_t *v)
+{
+	int output;
+	__asm__ __volatile__ (
+		"1:	%0 = memw_locked(%1);\n"
+		"	%0 = sub(%0,%2);\n"
+		"	memw_locked(%1,P3)=%0\n"
+		"	if !P3 jump 1b;\n"
+		: "=&r" (output)
+		: "r" (&v->counter), "r" (i)
+		: "memory", "p3"
+	);
+	return output;
+}
+
+#define atomic_sub(i, v) atomic_sub_return(i, (v))
+
+/**
+ * atomic_add_unless - add unless the number is a given value
+ * @v: pointer to value
+ * @a: amount to add
+ * @u: unless value is equal to u
+ *
+ * Returns 1 if the add happened, 0 if it didn't.
+ */
+static inline int __atomic_add_unless(atomic_t *v, int a, int u)
+{
+	int output, __oldval;
+	asm volatile(
+		"1:	%0 = memw_locked(%2);"
+		"	{"
+		"		p3 = cmp.eq(%0, %4);"
+		"		if (p3.new) jump:nt 2f;"
+		"		%0 = add(%0, %3);"
+		"		%1 = #0;"
+		"	}"
+		"	memw_locked(%2, p3) = %0;"
+		"	{"
+		"		if !p3 jump 1b;"
+		"		%1 = #1;"
+		"	}"
+		"2:"
+		: "=&r" (__oldval), "=&r" (output)
+		: "r" (v), "r" (a), "r" (u)
+		: "memory", "p3"
+	);
+	return output;
+}
+
+#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
+
+#define atomic_inc(v) atomic_add(1, (v))
+#define atomic_dec(v) atomic_sub(1, (v))
+
+#define atomic_inc_and_test(v) (atomic_add_return(1, (v)) == 0)
+#define atomic_dec_and_test(v) (atomic_sub_return(1, (v)) == 0)
+#define atomic_sub_and_test(i, v) (atomic_sub_return(i, (v)) == 0)
+#define atomic_add_negative(i, v) (atomic_add_return(i, (v)) < 0)
+
+
+#define atomic_inc_return(v) (atomic_add_return(1, v))
+#define atomic_dec_return(v) (atomic_sub_return(1, v))
+
+#endif
-- 
1.7.1


--

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

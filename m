Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964939Ab2CLXjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 19:39:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22626 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964871Ab2CLXjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 19:39:16 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 18/35] Create asm-generic/barrier.h [ver #2]
To: paul.gortmaker@windriver.com, hpa@zytor.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, arnd@arndb.de,
        David Howells <dhowells@redhat.com>, Arnd Bergmann <arnd@arndb.de>
Date: Mon, 12 Mar 2012 23:39:07 +0000
Message-ID: <20120312233907.13888.85219.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120312233602.13888.27659.stgit@warthog.procyon.org.uk>
References: <20120312233602.13888.27659.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create asm-generic/barrier.h and move the barrier definitions from
asm-generic/system.h to it.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Arnd Bergmann <arnd@arndb.de>
---

 include/asm-generic/barrier.h |   50 +++++++++++++++++++++++++++++++++++++++++
 include/asm-generic/system.h  |   34 +---------------------------
 2 files changed, 51 insertions(+), 33 deletions(-)
 create mode 100644 include/asm-generic/barrier.h

diff --git a/include/asm-generic/barrier.h b/include/asm-generic/barrier.h
new file mode 100644
index 0000000..639d7a4
--- /dev/null
+++ b/include/asm-generic/barrier.h
@@ -0,0 +1,50 @@
+/* Generic barrier definitions, based on MN10300 definitions.
+ *
+ * It should be possible to use these on really simple architectures,
+ * but it serves more as a starting point for new ports.
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef __ASM_GENERIC_BARRIER_H
+#define __ASM_GENERIC_BARRIER_H
+
+#ifndef __ASSEMBLY__
+
+#define nop() asm volatile ("nop")
+
+/*
+ * Force strict CPU ordering.
+ * And yes, this is required on UP too when we're talking
+ * to devices.
+ *
+ * This implementation only contains a compiler barrier.
+ */
+
+#define mb()	asm volatile ("": : :"memory")
+#define rmb()	mb()
+#define wmb()	asm volatile ("": : :"memory")
+
+#ifdef CONFIG_SMP
+#define smp_mb()	mb()
+#define smp_rmb()	rmb()
+#define smp_wmb()	wmb()
+#else
+#define smp_mb()	barrier()
+#define smp_rmb()	barrier()
+#define smp_wmb()	barrier()
+#endif
+
+#define set_mb(var, value)  do { var = value;  mb(); } while (0)
+#define set_wmb(var, value) do { var = value; wmb(); } while (0)
+
+#define read_barrier_depends()		do {} while (0)
+#define smp_read_barrier_depends()	do {} while (0)
+
+#endif /* !__ASSEMBLY__ */
+#endif /* __ASM_GENERIC_BARRIER_H */
diff --git a/include/asm-generic/system.h b/include/asm-generic/system.h
index 82cb53a..f98f693 100644
--- a/include/asm-generic/system.h
+++ b/include/asm-generic/system.h
@@ -19,6 +19,7 @@
 #include <linux/types.h>
 #include <linux/irqflags.h>
 
+#include <asm/barrier.h>
 #include <asm/cmpxchg.h>
 
 struct task_struct;
@@ -33,42 +34,9 @@ extern struct task_struct *__switch_to(struct task_struct *,
 
 #define arch_align_stack(x) (x)
 
-#define nop() asm volatile ("nop")
-
-#endif /* !__ASSEMBLY__ */
-
-/*
- * Force strict CPU ordering.
- * And yes, this is required on UP too when we're talking
- * to devices.
- *
- * This implementation only contains a compiler barrier.
- */
-
-#define mb()	asm volatile ("": : :"memory")
-#define rmb()	mb()
-#define wmb()	asm volatile ("": : :"memory")
-
-#ifdef CONFIG_SMP
-#define smp_mb()	mb()
-#define smp_rmb()	rmb()
-#define smp_wmb()	wmb()
-#else
-#define smp_mb()	barrier()
-#define smp_rmb()	barrier()
-#define smp_wmb()	barrier()
-#endif
-
-#define set_mb(var, value)  do { var = value;  mb(); } while (0)
-#define set_wmb(var, value) do { var = value; wmb(); } while (0)
-
-#define read_barrier_depends()		do {} while (0)
-#define smp_read_barrier_depends()	do {} while (0)
-
 /*
  * we make sure local_irq_enable() doesn't cause priority inversion
  */
-#ifndef __ASSEMBLY__
 
 /* This function doesn't exist, so you'll get a linker error
  *    if something tries to do an invalid xchg().  */


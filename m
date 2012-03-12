Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285Ab2CLXjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 19:39:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932190Ab2CLXjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 19:39:35 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 20/35] Split the switch_to() wrapper out of
 asm-generic/system.h [ver #2]
To: paul.gortmaker@windriver.com, hpa@zytor.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, arnd@arndb.de,
        David Howells <dhowells@redhat.com>, Arnd Bergmann <arnd@arndb.de>
Date: Mon, 12 Mar 2012 23:39:27 +0000
Message-ID: <20120312233926.13888.93973.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120312233602.13888.27659.stgit@warthog.procyon.org.uk>
References: <20120312233602.13888.27659.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the switch_to() wrapper out of asm-generic/system.h into its own
asm-generic/system.h as part of the asm/system.h disintegration.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Arnd Bergmann <arnd@arndb.de>
---

 include/asm-generic/switch_to.h |   30 ++++++++++++++++++++++++++++++
 include/asm-generic/system.h    |   17 +----------------
 2 files changed, 31 insertions(+), 16 deletions(-)
 create mode 100644 include/asm-generic/switch_to.h

diff --git a/include/asm-generic/switch_to.h b/include/asm-generic/switch_to.h
new file mode 100644
index 0000000..052c4ac
--- /dev/null
+++ b/include/asm-generic/switch_to.h
@@ -0,0 +1,30 @@
+/* Generic task switch macro wrapper, based on MN10300 definitions.
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
+#ifndef __ASM_GENERIC_SWITCH_TO_H
+#define __ASM_GENERIC_SWITCH_TO_H
+
+#include <linux/thread_info.h>
+
+/*
+ * Context switching is now performed out-of-line in switch_to.S
+ */
+extern struct task_struct *__switch_to(struct task_struct *,
+				       struct task_struct *);
+
+#define switch_to(prev, next, last)					\
+	do {								\
+		((last) = __switch_to((prev), (next)));			\
+	} while (0)
+
+#endif /* __ASM_GENERIC_SWITCH_TO_H */
diff --git a/include/asm-generic/system.h b/include/asm-generic/system.h
index 54cd124..f2b8eb4 100644
--- a/include/asm-generic/system.h
+++ b/include/asm-generic/system.h
@@ -14,25 +14,10 @@
 #ifndef __ASM_GENERIC_SYSTEM_H
 #define __ASM_GENERIC_SYSTEM_H
 
-#ifndef __ASSEMBLY__
-
-#include <linux/types.h>
-
 #include <asm/barrier.h>
 #include <asm/cmpxchg.h>
-
-struct task_struct;
-
-/* context switching is now performed out-of-line in switch_to.S */
-extern struct task_struct *__switch_to(struct task_struct *,
-		struct task_struct *);
-#define switch_to(prev, next, last)					\
-	do {								\
-		((last) = __switch_to((prev), (next)));			\
-	} while (0)
+#include <asm/switch_to.h>
 
 #define arch_align_stack(x) (x)
 
-#endif /* !__ASSEMBLY__ */
-
 #endif /* __ASM_GENERIC_SYSTEM_H */


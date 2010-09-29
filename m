Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab0I2A5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 20:57:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754651Ab0I2A5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 20:57:17 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] MN10300: Handle missing sys_cacheflush() when caching
	disabled [ver #2]
To: torvalds@osdl.org, akpm@linux-foundation.org, msalter@redhat.com
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Wed, 29 Sep 2010 01:57:02 +0100
Message-ID: <20100929005702.24338.15662.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When caching is disabled on the MN10300 arch, the sys_cacheflush() function is
removed by conditional stuff in the makefiles, but is still referred to by the
syscall table.

Provide a null version that just returns 0 when caching is disabled (or -EINVAL
if the arguments are silly).

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/mm/Makefile         |   14 ++++++--------
 arch/mn10300/mm/cache-disabled.c |   21 +++++++++++++++++++++
 2 files changed, 27 insertions(+), 8 deletions(-)
 create mode 100644 arch/mn10300/mm/cache-disabled.c


diff --git a/arch/mn10300/mm/Makefile b/arch/mn10300/mm/Makefile
index 28b9d98..1557277 100644
--- a/arch/mn10300/mm/Makefile
+++ b/arch/mn10300/mm/Makefile
@@ -2,13 +2,11 @@
 # Makefile for the MN10300-specific memory management code
 #
 
+cacheflush-y	:= cache.o cache-mn10300.o
+cacheflush-$(CONFIG_MN10300_CACHE_WBACK) += cache-flush-mn10300.o
+
+cacheflush-$(CONFIG_MN10300_CACHE_DISABLED) := cache-disabled.o
+
 obj-y := \
 	init.o fault.o pgtable.o extable.o tlb-mn10300.o mmu-context.o \
-	misalignment.o dma-alloc.o
-
-ifneq ($(CONFIG_MN10300_CACHE_DISABLED),y)
-obj-y	+= cache.o cache-mn10300.o
-ifeq ($(CONFIG_MN10300_CACHE_WBACK),y)
-obj-y	+= cache-flush-mn10300.o
-endif
-endif
+	misalignment.o dma-alloc.o $(cacheflush-y)
diff --git a/arch/mn10300/mm/cache-disabled.c b/arch/mn10300/mm/cache-disabled.c
new file mode 100644
index 0000000..f669ea4
--- /dev/null
+++ b/arch/mn10300/mm/cache-disabled.c
@@ -0,0 +1,21 @@
+/* Handle the cache being disabled
+ *
+ * Copyright (C) 2010 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <linux/mm.h>
+
+/*
+ * allow userspace to flush the instruction cache
+ */
+asmlinkage long sys_cacheflush(unsigned long start, unsigned long end)
+{
+	if (end < start)
+		return -EINVAL;
+	return 0;
+}


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab0LFXnH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 18:43:07 -0500
Received: from ozlabs.org ([203.10.76.45]:32872 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753758Ab0LFXmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 18:42:55 -0500
Message-Id: <20101206234049.880246100@neuling.org>
User-Agent: quilt/0.48-1
Date: Tue, 07 Dec 2010 10:40:45 +1100
From: Michael Neuling <mikey@neuling.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kumar Gala <galak@kernel.crashing.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [RFC/PATCH 2/7] Rearrange include files to make struct call_single_data usable in more places
References: <20101206234043.083045003@neuling.org>
Content-Disposition: inline; filename=csd_thread_struct_prepare.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to put struct call_single_data in the powerpc thread_struct,
but can't without this.

The thread_struct is in processor.h.  To add a struct call_single_data
to the thread_struct asm/processor.h must include linux/smp.h.  When
linux/smp.h is added to processor.h this creates an include loop via
with list.h via:

  linux/list.h includes: 
    linux/prefetch.h includes:
      asm/processor.h (for powerpc) includes:
        linux/smp.h includes:
          linux/list.h

This loops results in an "incomplete list type" compile when using
struct list_head as used in struct call_single_data.

This patch rearanges some include files to avoid this loop.

Signed-off-by: Michael Neuling <mikey@neuling.org>
---
 include/linux/call_single_data.h |   14 ++++++++++++++
 include/linux/list.h             |    4 +++-
 include/linux/smp.h              |    8 +-------
 3 files changed, 18 insertions(+), 8 deletions(-)

Index: linux-lazy/include/linux/call_single_data.h
===================================================================
--- /dev/null
+++ linux-lazy/include/linux/call_single_data.h
@@ -0,0 +1,14 @@
+#ifndef __LINUX_CALL_SINGLE_DATA_H
+#define __LINUX_CALL_SINGLE_DATA_H
+
+#include <linux/list.h>
+
+struct call_single_data {
+	struct list_head list;
+	void (*func) (void *info);
+	void *info;
+	u16 flags;
+	u16 priv;
+};
+
+#endif /* __LINUX_CALL_SINGLE_DATA_H */
Index: linux-lazy/include/linux/list.h
===================================================================
--- linux-lazy.orig/include/linux/list.h
+++ linux-lazy/include/linux/list.h
@@ -4,7 +4,6 @@
 #include <linux/types.h>
 #include <linux/stddef.h>
 #include <linux/poison.h>
-#include <linux/prefetch.h>
 
 /*
  * Simple doubly linked list implementation.
@@ -16,6 +15,9 @@
  * using the generic single-entry routines.
  */
 
+#include <linux/prefetch.h>
+#include <asm/system.h>
+
 #define LIST_HEAD_INIT(name) { &(name), &(name) }
 
 #define LIST_HEAD(name) \
Index: linux-lazy/include/linux/smp.h
===================================================================
--- linux-lazy.orig/include/linux/smp.h
+++ linux-lazy/include/linux/smp.h
@@ -9,18 +9,12 @@
 #include <linux/errno.h>
 #include <linux/types.h>
 #include <linux/list.h>
+#include <linux/call_single_data.h>
 #include <linux/cpumask.h>
 
 extern void cpu_idle(void);
 
 typedef void (*smp_call_func_t)(void *info);
-struct call_single_data {
-	struct list_head list;
-	smp_call_func_t func;
-	void *info;
-	u16 flags;
-	u16 priv;
-};
 
 /* total number of cpus in this system (may exceed NR_CPUS) */
 extern unsigned int total_cpus;



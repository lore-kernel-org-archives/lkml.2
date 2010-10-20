Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120Ab0JTDHF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 23:07:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:36801 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926Ab0JTDHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 23:07:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,354,1283756400"; 
   d="scan'208";a="565636327"
Subject: [PATCH 1/2]percpu: introduce read mostly percpu API
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>, "Chen, Tim C" <tim.c.chen@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Oct 2010 11:07:02 +0800
Message-ID: <1287544022.4571.7.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new readmostly percpu section and api, next patch will use it.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 include/asm-generic/vmlinux.lds.h |    4 ++++
 include/linux/percpu-defs.h       |    9 +++++++++
 2 files changed, 13 insertions(+)

Index: linux/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux.orig/include/asm-generic/vmlinux.lds.h	2010-10-20 09:32:52.000000000 +0800
+++ linux/include/asm-generic/vmlinux.lds.h	2010-10-20 10:03:38.000000000 +0800
@@ -677,6 +677,8 @@
 				- LOAD_OFFSET) {			\
 		VMLINUX_SYMBOL(__per_cpu_start) = .;			\
 		*(.data..percpu..first)					\
+		. = ALIGN(PAGE_SIZE);					\
+		*(.data..percpu..readmostly)				\
 		*(.data..percpu..page_aligned)				\
 		*(.data..percpu)					\
 		*(.data..percpu..shared_aligned)			\
@@ -703,6 +705,8 @@
 		VMLINUX_SYMBOL(__per_cpu_load) = .;			\
 		VMLINUX_SYMBOL(__per_cpu_start) = .;			\
 		*(.data..percpu..first)					\
+		. = ALIGN(PAGE_SIZE);					\
+		*(.data..percpu..readmostly)				\
 		*(.data..percpu..page_aligned)				\
 		*(.data..percpu)					\
 		*(.data..percpu..shared_aligned)			\
Index: linux/include/linux/percpu-defs.h
===================================================================
--- linux.orig/include/linux/percpu-defs.h	2010-10-20 09:14:27.000000000 +0800
+++ linux/include/linux/percpu-defs.h	2010-10-20 09:17:08.000000000 +0800
@@ -139,6 +139,15 @@
 	__aligned(PAGE_SIZE)
 
 /*
+ * Declaration/definition used for per-CPU variables that must be read mostly.
+ */
+#define DECLARE_PER_CPU_READ_MOSTLY(type, name)			\
+	DECLARE_PER_CPU_SECTION(type, name, "..readmostly")
+
+#define DEFINE_PER_CPU_READ_MOSTLY(type, name)				\
+	DEFINE_PER_CPU_SECTION(type, name, "..readmostly")
+
+/*
  * Intermodule exports for per-CPU variables.  sparse forgets about
  * address space across EXPORT_SYMBOL(), change EXPORT_SYMBOL() to
  * noop if __CHECKER__.



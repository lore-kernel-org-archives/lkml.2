Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758758Ab1DAWPd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 18:15:33 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:58572 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757317Ab1DAWPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 18:15:32 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 1/2 v2] percpu: unify input section names
Date: Fri,  1 Apr 2011 18:15:34 -0400
Message-Id: <1301696134-31249-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301601122-25431-1-git-send-email-vapier@gentoo.org>
References: <1301601122-25431-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The two percpu helper macros have the section names duplicated.  So create
a new define to merge the two.  This also allows arches who need to link
things more directly themselves to avoid duplicating the input sections in
their linker script.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
v2
	- rebased onto latest mainline

 include/asm-generic/vmlinux.lds.h |   44 ++++++++++++++++++++----------------
 1 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 32c45e5..bf90fbc 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -688,6 +688,28 @@
 	}
 
 /**
+ * PERCPU_INPUT - the percpu input sections
+ * @cacheline: cacheline size
+ *
+ * The core percpu section names and core symbols which do not rely
+ * directly upon load addresses.
+ *
+ * @cacheline is used to align subsections to avoid false cacheline
+ * sharing between subsections for different purposes.
+ */
+#define PERCPU_INPUT(cacheline)						\
+	VMLINUX_SYMBOL(__per_cpu_start) = .;				\
+	*(.data..percpu..first)						\
+	. = ALIGN(PAGE_SIZE);						\
+	*(.data..percpu..page_aligned)					\
+	. = ALIGN(cacheline);						\
+	*(.data..percpu..readmostly)					\
+	. = ALIGN(cacheline);						\
+	*(.data..percpu)						\
+	*(.data..percpu..shared_aligned)				\
+	VMLINUX_SYMBOL(__per_cpu_end) = .;
+
+/**
  * PERCPU_VADDR - define output section for percpu area
  * @cacheline: cacheline size
  * @vaddr: explicit base address (optional)
@@ -715,16 +737,7 @@
 	VMLINUX_SYMBOL(__per_cpu_load) = .;				\
 	.data..percpu vaddr : AT(VMLINUX_SYMBOL(__per_cpu_load)		\
 				- LOAD_OFFSET) {			\
-		VMLINUX_SYMBOL(__per_cpu_start) = .;			\
-		*(.data..percpu..first)					\
-		. = ALIGN(PAGE_SIZE);					\
-		*(.data..percpu..page_aligned)				\
-		. = ALIGN(cacheline);					\
-		*(.data..percpu..readmostly)				\
-		. = ALIGN(cacheline);					\
-		*(.data..percpu)					\
-		*(.data..percpu..shared_aligned)			\
-		VMLINUX_SYMBOL(__per_cpu_end) = .;			\
+		PERCPU_INPUT(cacheline)					\
 	} phdr								\
 	. = VMLINUX_SYMBOL(__per_cpu_load) + SIZEOF(.data..percpu);
 
@@ -745,16 +758,7 @@
 	. = ALIGN(align);						\
 	.data..percpu	: AT(ADDR(.data..percpu) - LOAD_OFFSET) {	\
 		VMLINUX_SYMBOL(__per_cpu_load) = .;			\
-		VMLINUX_SYMBOL(__per_cpu_start) = .;			\
-		*(.data..percpu..first)					\
-		. = ALIGN(PAGE_SIZE);					\
-		*(.data..percpu..page_aligned)				\
-		. = ALIGN(cacheline);					\
-		*(.data..percpu..readmostly)				\
-		. = ALIGN(cacheline);					\
-		*(.data..percpu)					\
-		*(.data..percpu..shared_aligned)			\
-		VMLINUX_SYMBOL(__per_cpu_end) = .;			\
+		PERCPU_INPUT(cacheline)					\
 	}
 
 
-- 
1.7.4.1


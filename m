Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654Ab2C1Svp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 14:51:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:20450 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758483Ab2C1Svo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 14:51:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="147087102"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/2] Add CONFIG_READABLE_ASM
Date: Wed, 28 Mar 2012 11:51:18 -0700
Message-Id: <1332960678-11879-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1332960678-11879-1-git-send-email-andi@firstfloor.org>
References: <1332960678-11879-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add a config option to disable various gcc compiler optimizations that
make assembler listings much harder to read. This is everything that reorders
code significantly or creates partial functions.

This is mainly to keep kernel hackers sane.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 Makefile          |   10 ++++++++++
 lib/Kconfig.debug |    9 +++++++++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/Makefile b/Makefile
index 1932984..6f7328b 100644
--- a/Makefile
+++ b/Makefile
@@ -564,6 +564,16 @@ else
 KBUILD_CFLAGS	+= -O2
 endif
 
+ifdef CONFIG_READABLE_ASM
+# Disable optimizations that make assembler listings hard to read.
+# reorder blocks reorders the control in the function
+# ipa clone creates specialized cloned functions
+# partial inlining inlines only parts of functions
+KBUILD_CFLAGS += $(call cc-option,-fno-reorder-blocks,) \
+                 $(call cc-option,-fno-ipa-cp-clone,) \
+                 $(call cc-option,-fno-partial-inlining)
+endif
+
 include $(srctree)/arch/$(SRCARCH)/Makefile
 
 ifneq ($(CONFIG_FRAME_WARN),0)
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index f7af95d..d6102f3 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -70,6 +70,15 @@ config STRIP_ASM_SYMS
 	  that look like '.Lxxx') so they don't pollute the output of
 	  get_wchan() and suchlike.
 
+config READABLE_ASM
+        bool "Generate readable assembler code"
+        depends on DEBUG_KERNEL
+        help
+          Disable some compiler optimizations that tend to generate human unreadable
+          assembler output. This may make the kernel slightly slower, but it helps
+          to keep kernel developers who have to stare a lot at assembler listings
+          sane.
+
 config UNUSED_SYMBOLS
 	bool "Enable unused/obsolete exported symbols"
 	default y if X86
-- 
1.7.7.6


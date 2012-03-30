Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934610Ab2C3Rlf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 13:41:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47764 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab2C3Rl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 13:41:29 -0400
Date: Fri, 30 Mar 2012 10:41:19 -0700
From: tip-bot for Andi Kleen <ak@linux.intel.com>
Message-ID: <tip-1873e870fd63ee4b87dbe0125ca373e420fb4987@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1332960678-11879-2-git-send-email-andi@firstfloor.org>
References: <1332960678-11879-2-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] debug: Add CONFIG_READABLE_ASM
Git-Commit-ID: 1873e870fd63ee4b87dbe0125ca373e420fb4987
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 30 Mar 2012 10:41:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1873e870fd63ee4b87dbe0125ca373e420fb4987
Gitweb:     http://git.kernel.org/tip/1873e870fd63ee4b87dbe0125ca373e420fb4987
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Wed, 28 Mar 2012 11:51:18 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 30 Mar 2012 10:15:21 -0700

debug: Add CONFIG_READABLE_ASM

Add a config option to disable various gcc compiler optimizations that
make assembler listings much harder to read. This is everything that reorders
code significantly or creates partial functions.

This is mainly to keep kernel hackers sane.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1332960678-11879-2-git-send-email-andi@firstfloor.org
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
index 6777153..4d3cbbb 100644
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

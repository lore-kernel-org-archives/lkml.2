Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276Ab0LEKDp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 05:03:45 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52465 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882Ab0LEKDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 05:03:42 -0500
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Russell King <linux@arm.linux.org.uk>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [RFC] add BUG_ON_MAPPABLE_NULL macro
Date: Sun,  5 Dec 2010 12:06:03 +0200
Message-Id: <1291543563-5655-1-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce BUG_ON_MAPPABLE_NULL in order to eliminate redundant BUG_ON
code, checking for NULL addresses, on architectures where the zero
address can never be mapped.

Originally proposed by Russell King <linux@arm.linux.org.uk>

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
Compile tested on ARM and x86-64.

Relevant threads:
1. Original proposal by Russell - http://lkml.org/lkml/2010/1/21/238
2. Recent discussion - https://lkml.org/lkml/2010/11/26/78

Notes:
* Implementation still feels hacky, especially since we don't care about the len param of arch_mmap_check.
* Just like BUG_ON, this new macro is compiled out on !CONFIG_BUG. We might want to add a CONFIG_BUG commentary, so users will at least be aware of the security implications of compiling this out.
* To get an (extremely!) rough upper bound of the profit of this macro, I did:

1. find . -name '*.[ch]' | xargs sed -i 's/BUG_ON(!/BUG_ON_MAPPABLE_NULL(!/'
2. removed some obviously bogus sed hits

With omap2plus_defconfig, uImage shrank by ~4Kb (obviously this doesn't include the potential gain in modules)

 arch/arm/include/asm/mman.h |    2 +
 include/asm-generic/bug.h   |   46 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/arch/arm/include/asm/mman.h b/arch/arm/include/asm/mman.h
index 41f99c5..f0c5d58 100644
--- a/arch/arm/include/asm/mman.h
+++ b/arch/arm/include/asm/mman.h
@@ -1,4 +1,6 @@
 #include <asm-generic/mman.h>
+#include <asm/pgtable.h>
+#include <asm/errno.h>
 
 #define arch_mmap_check(addr, len, flags) \
 	(((flags) & MAP_FIXED && (addr) < FIRST_USER_ADDRESS) ? -EINVAL : 0)
diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index c2c9ba0..0171a30 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -2,6 +2,11 @@
 #define _ASM_GENERIC_BUG_H
 
 #include <linux/compiler.h>
+#include <asm/mman.h>
+
+#ifndef arch_mmap_check
+#define arch_mmap_check(addr, len, flags)	(0)
+#endif
 
 #ifdef CONFIG_BUG
 
@@ -53,6 +58,47 @@ struct bug_entry {
 #define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while(0)
 #endif
 
+/**
+ * BUG_ON_MAPPABLE_NULL() - BUG_ON(condition) only if address 0 is mappable
+ * @condition:	condition to check, should contain a NULL check
+ *
+ * In general, NULL dereference Oopses are not desirable, since they take down
+ * the system with them and make the user extremely unhappy. So as a general
+ * rule drivers should avoid dereferencing NULL pointers by doing a simple
+ * check (when appropriate), and just return an error rather than crash.
+ * This way the system, despite having reduced functionality, will just keep
+ * running rather than immediately reboot.
+ *
+ * _Critical_ kernel code, OTOH, that should not (/cannot) keep running when
+ * given an unexpected NULL pointer, should just crash. On some architectures,
+ * a NULL dereference will always reliably produce an Oops. On others, where
+ * the zero address can be mmapped, an Oops is not guaranteed. Relying on
+ * NULL dereference Oopses to happen on these architectures might lead to
+ * data corruptions (system will keep running despite a critical bug and
+ * the results will be horribly undefined). In addition, these situations
+ * can also have security implications - we have seen several privilege
+ * escalation exploits with which an attacker gained full control over the
+ * system due to NULL dereference bugs.
+ *
+ * This macro will BUG_ON if @condition is true on architectures where the zero
+ * address can be mapped. On other architectures, where the zero address
+ * can never be mapped, this macro is compiled out. It only makes sense to
+ * use this macro if @condition contains a NULL check, in order to optimize that
+ * check out on architectures where the zero address can never be mapped.
+ * On such architectures, those checks are not necessary, since the code
+ * itself will reliably reproduce an Oops as soon as the NULL address will
+ * be dereferenced.
+ *
+ * As with BUG_ON, use this macro only if @condition cannot be tolerated.
+ * If proceeding with degraded functionality is an option, it's much
+ * better to just simply check for @condition and return some error code rather
+ * than crash the system.
+ */
+#define BUG_ON_MAPPABLE_NULL(cond) do { \
+	if (arch_mmap_check(0, 1, MAP_FIXED) == 0) \
+		BUG_ON(cond); \
+} while (0)
+
 /*
  * WARN(), WARN_ON(), WARN_ON_ONCE, and so on can be used to report
  * significant issues that need prompt attention if they should ever
-- 
1.7.0.4


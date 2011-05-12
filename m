Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759006Ab1ELXwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 19:52:42 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:51853 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758917Ab1ELXuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 19:50:18 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6344"; a="90916801"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        x86@kernel.org, linux-parisc@vger.kernel.org,
        linux-s390@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>,
        Helge Deller <deller@gmx.de>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [PATCH 9/9] Consolidate CONFIG_DEBUG_STRICT_USER_COPY_CHECKS
Date: Thu, 12 May 2011 16:50:12 -0700
Message-Id: <1305244212-19183-10-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.5.1.217.g4e3aa
In-Reply-To: <1305244212-19183-1-git-send-email-sboyd@codeaurora.org>
References: <1305244212-19183-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The help text for this config is duplicated across the x86,
parisc, and s390 Kconfig.debug files. Arnd Bergman noted that the
help text was slightly misleading and should be fixed to state
that enabling this option isn't a problem when using pre 4.4 gcc.

To simplify the rewording, consolidate the text into
lib/Kconfig.debug and modify it there to be more explicit about
when you should say N to this config.

Also, make the text a bit more generic by stating that this
option enables compile time checks so we can cover architectures
which emit warnings vs. ones which emit errors. The details of
how an architecture decided to implement the checks isn't as
important as the concept of compile time checking of
copy_from_user() calls.

While we're doing this, remove all the copy_from_user_overflow()
code that's duplicated many times and place it into lib/ so that
any architecture supporting this option can get the function for
free.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: x86@kernel.org
Cc: linux-parisc@vger.kernel.org
Cc: linux-s390@vger.kernel.org
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/parisc/Kconfig             |    1 +
 arch/parisc/Kconfig.debug       |   14 --------------
 arch/s390/Kconfig               |    1 +
 arch/s390/Kconfig.debug         |   14 --------------
 arch/s390/lib/Makefile          |    1 -
 arch/s390/lib/usercopy.c        |    8 --------
 arch/sparc/lib/Makefile         |    1 -
 arch/sparc/lib/usercopy.c       |    8 --------
 arch/tile/Kconfig               |    8 +-------
 arch/tile/include/asm/uaccess.h |    7 ++++++-
 arch/tile/lib/uaccess.c         |    8 --------
 arch/x86/Kconfig                |    1 +
 arch/x86/Kconfig.debug          |   14 --------------
 arch/x86/lib/usercopy_32.c      |    6 ------
 arch/x86/lib/usercopy_64.c      |    6 ------
 lib/Kconfig.debug               |   18 ++++++++++++++++++
 lib/Makefile                    |    1 +
 lib/usercopy.c                  |    8 ++++++++
 18 files changed, 37 insertions(+), 88 deletions(-)
 delete mode 100644 arch/s390/lib/usercopy.c
 delete mode 100644 arch/sparc/lib/usercopy.c
 create mode 100644 lib/usercopy.c

diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 69ff049..4473f10 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -15,6 +15,7 @@ config PARISC
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_PROBE
 	select IRQ_PER_CPU
+	select ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
 
 	help
 	  The PA-RISC microprocessor is designed by Hewlett-Packard and used
diff --git a/arch/parisc/Kconfig.debug b/arch/parisc/Kconfig.debug
index 7305ac8..bc989e5 100644
--- a/arch/parisc/Kconfig.debug
+++ b/arch/parisc/Kconfig.debug
@@ -12,18 +12,4 @@ config DEBUG_RODATA
          portion of the kernel code won't be covered by a TLB anymore.
          If in doubt, say "N".
 
-config DEBUG_STRICT_USER_COPY_CHECKS
-	bool "Strict copy size checks"
-	depends on DEBUG_KERNEL && !TRACE_BRANCH_PROFILING
-	---help---
-	  Enabling this option turns a certain set of sanity checks for user
-	  copy operations into compile time failures.
-
-	  The copy_from_user() etc checks are there to help test if there
-	  are sufficient security checks on the length argument of
-	  the copy operation, by having gcc prove that the argument is
-	  within bounds.
-
-	  If unsure, or if you run an older (pre 4.4) gcc, say N.
-
 endmenu
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 2508a6f..196cdc9 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -116,6 +116,7 @@ config S390
 	select ARCH_INLINE_WRITE_UNLOCK_BH
 	select ARCH_INLINE_WRITE_UNLOCK_IRQ
 	select ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
+	select ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
 
 config SCHED_OMIT_FRAME_POINTER
 	def_bool y
diff --git a/arch/s390/Kconfig.debug b/arch/s390/Kconfig.debug
index d76cef3..aa1796c 100644
--- a/arch/s390/Kconfig.debug
+++ b/arch/s390/Kconfig.debug
@@ -17,20 +17,6 @@ config STRICT_DEVMEM
 
 	  If you are unsure, say Y.
 
-config DEBUG_STRICT_USER_COPY_CHECKS
-	def_bool n
-	prompt "Strict user copy size checks"
-	---help---
-	  Enabling this option turns a certain set of sanity checks for user
-	  copy operations into compile time warnings.
-
-	  The copy_from_user() etc checks are there to help test if there
-	  are sufficient security checks on the length argument of
-	  the copy operation, by having gcc prove that the argument is
-	  within bounds.
-
-	  If unsure, or if you run an older (pre 4.4) gcc, say N.
-
 config DEBUG_SET_MODULE_RONX
 	def_bool y
 	depends on MODULES
diff --git a/arch/s390/lib/Makefile b/arch/s390/lib/Makefile
index 761ab8b..97975ec 100644
--- a/arch/s390/lib/Makefile
+++ b/arch/s390/lib/Makefile
@@ -3,7 +3,6 @@
 #
 
 lib-y += delay.o string.o uaccess_std.o uaccess_pt.o
-obj-y += usercopy.o
 obj-$(CONFIG_32BIT) += div64.o qrnnd.o ucmpdi2.o
 lib-$(CONFIG_64BIT) += uaccess_mvcos.o
 lib-$(CONFIG_SMP) += spinlock.o
diff --git a/arch/s390/lib/usercopy.c b/arch/s390/lib/usercopy.c
deleted file mode 100644
index 14b363f..0000000
--- a/arch/s390/lib/usercopy.c
+++ /dev/null
@@ -1,8 +0,0 @@
-#include <linux/module.h>
-#include <linux/bug.h>
-
-void copy_from_user_overflow(void)
-{
-	WARN(1, "Buffer overflow detected!\n");
-}
-EXPORT_SYMBOL(copy_from_user_overflow);
diff --git a/arch/sparc/lib/Makefile b/arch/sparc/lib/Makefile
index 846d1c4..892e0a9 100644
--- a/arch/sparc/lib/Makefile
+++ b/arch/sparc/lib/Makefile
@@ -44,4 +44,3 @@ obj-y                 += iomap.o
 obj-$(CONFIG_SPARC32) += atomic32.o
 obj-y                 += ksyms.o
 obj-$(CONFIG_SPARC64) += PeeCeeI.o
-obj-y                 += usercopy.o
diff --git a/arch/sparc/lib/usercopy.c b/arch/sparc/lib/usercopy.c
deleted file mode 100644
index 14b363f..0000000
--- a/arch/sparc/lib/usercopy.c
+++ /dev/null
@@ -1,8 +0,0 @@
-#include <linux/module.h>
-#include <linux/bug.h>
-
-void copy_from_user_overflow(void)
-{
-	WARN(1, "Buffer overflow detected!\n");
-}
-EXPORT_SYMBOL(copy_from_user_overflow);
diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index e32b0c2..8961f43 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -12,6 +12,7 @@ config TILE
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
 	select GENERIC_IRQ_SHOW
+	select ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
 
 # FIXME: investigate whether we need/want these options.
 #	select HAVE_IOREMAP_PROT
@@ -96,13 +97,6 @@ config STRICT_DEVMEM
 config SMP
 	def_bool y
 
-# Allow checking for compile-time determined overflow errors in
-# copy_from_user().  There are still unprovable places in the
-# generic code as of 2.6.34, so this option is not really compatible
-# with -Werror, which is more useful in general.
-config DEBUG_COPY_FROM_USER
-	def_bool n
-
 config HVC_TILE
 	select HVC_DRIVER
 	def_bool y
diff --git a/arch/tile/include/asm/uaccess.h b/arch/tile/include/asm/uaccess.h
index ef34d2c..9a540be 100644
--- a/arch/tile/include/asm/uaccess.h
+++ b/arch/tile/include/asm/uaccess.h
@@ -353,7 +353,12 @@ _copy_from_user(void *to, const void __user *from, unsigned long n)
 	return n;
 }
 
-#ifdef CONFIG_DEBUG_COPY_FROM_USER
+#ifdef CONFIG_DEBUG_STRICT_USER_COPY_CHECKS
+/*
+ * There are still unprovable places in the generic code as of 2.6.34, so this
+ * option is not really compatible with -Werror, which is more useful in
+ * general.
+ */
 extern void copy_from_user_overflow(void)
 	__compiletime_warning("copy_from_user() size is not provably correct");
 
diff --git a/arch/tile/lib/uaccess.c b/arch/tile/lib/uaccess.c
index f8d398c..030abe3 100644
--- a/arch/tile/lib/uaccess.c
+++ b/arch/tile/lib/uaccess.c
@@ -22,11 +22,3 @@ int __range_ok(unsigned long addr, unsigned long size)
 		 is_arch_mappable_range(addr, size));
 }
 EXPORT_SYMBOL(__range_ok);
-
-#ifdef CONFIG_DEBUG_COPY_FROM_USER
-void copy_from_user_overflow(void)
-{
-       WARN(1, "Buffer overflow detected!\n");
-}
-EXPORT_SYMBOL(copy_from_user_overflow);
-#endif
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cc6c53a..be50c8e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -72,6 +72,7 @@ config X86
 	select IRQ_FORCED_THREADING
 	select USE_GENERIC_SMP_HELPERS if SMP
 	select ARCH_NO_SYSDEV_OPS
+	select ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS)
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 615e188..e3c58f3 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -290,18 +290,4 @@ config OPTIMIZE_INLINING
 
 	  If unsure, say N.
 
-config DEBUG_STRICT_USER_COPY_CHECKS
-	bool "Strict copy size checks"
-	depends on DEBUG_KERNEL && !TRACE_BRANCH_PROFILING
-	---help---
-	  Enabling this option turns a certain set of sanity checks for user
-	  copy operations into compile time failures.
-
-	  The copy_from_user() etc checks are there to help test if there
-	  are sufficient security checks on the length argument of
-	  the copy operation, by having gcc prove that the argument is
-	  within bounds.
-
-	  If unsure, or if you run an older (pre 4.4) gcc, say N.
-
 endmenu
diff --git a/arch/x86/lib/usercopy_32.c b/arch/x86/lib/usercopy_32.c
index e218d5d..8498684 100644
--- a/arch/x86/lib/usercopy_32.c
+++ b/arch/x86/lib/usercopy_32.c
@@ -883,9 +883,3 @@ _copy_from_user(void *to, const void __user *from, unsigned long n)
 	return n;
 }
 EXPORT_SYMBOL(_copy_from_user);
-
-void copy_from_user_overflow(void)
-{
-	WARN(1, "Buffer overflow detected!\n");
-}
-EXPORT_SYMBOL(copy_from_user_overflow);
diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
index d7a5d9a..b7c2849 100644
--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -181,9 +181,3 @@ copy_user_handle_tail(char *to, char *from, unsigned len, unsigned zerorest)
 			break;
 	return len;
 }
-
-void copy_from_user_overflow(void)
-{
-	WARN(1, "Buffer overflow detected!\n");
-}
-EXPORT_SYMBOL(copy_from_user_overflow);
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index c768bcd..3703778 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1096,6 +1096,24 @@ config SYSCTL_SYSCALL_CHECK
 	  to properly maintain and use. This enables checks that help
 	  you to keep things correct.
 
+config ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
+	bool
+
+config DEBUG_STRICT_USER_COPY_CHECKS
+	bool "Strict user copy size checks"
+	depends on ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
+	depends on DEBUG_KERNEL && !TRACE_BRANCH_PROFILING
+	help
+	  Enabling this option turns a certain set of sanity checks for user
+	  copy operations into compile time failures.
+
+	  The copy_from_user() etc checks are there to help test if there
+	  are sufficient security checks on the length argument of
+	  the copy operation, by having gcc prove that the argument is
+	  within bounds.
+
+	  If unsure, say N.
+
 source mm/Kconfig.debug
 source kernel/trace/Kconfig
 
diff --git a/lib/Makefile b/lib/Makefile
index ef0f285..4c1e445 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -14,6 +14,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 proportions.o prio_heap.o ratelimit.o show_mem.o \
 	 is_single_threaded.o plist.o decompress.o
 
+lib-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
 
diff --git a/lib/usercopy.c b/lib/usercopy.c
new file mode 100644
index 0000000..14b363f
--- /dev/null
+++ b/lib/usercopy.c
@@ -0,0 +1,8 @@
+#include <linux/module.h>
+#include <linux/bug.h>
+
+void copy_from_user_overflow(void)
+{
+	WARN(1, "Buffer overflow detected!\n");
+}
+EXPORT_SYMBOL(copy_from_user_overflow);
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


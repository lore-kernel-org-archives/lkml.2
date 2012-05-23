Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab2EWHZu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 03:25:50 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:59641 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab2EWHZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 03:25:48 -0400
Date: Wed, 23 May 2012 09:25:42 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/cleanups for v3.5
Message-ID: <20120523072542.GA8958@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-cleanups-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-cleanups-for-linus

   HEAD: 74bc491795420254f8b9c782ec654c9ba005d3ac x86/pci-calgary_64.c: Remove obsoleted simple_strtoul() usage

Small cleanups.

out-of-topic modifications in x86-cleanups-for-linus:
-----------------------------------------------------
Makefile                           # 1873e87: debug: Add CONFIG_READABLE_ASM

 Thanks,

	Ingo

------------------>
Andi Kleen (1):
      debug: Add CONFIG_READABLE_ASM

Peter Jones (1):
      x86: Don't continue booting if we can't load the specified initrd

Richard Weinberger (1):
      x86: spinlock.h: Remove REG_PTR_MODE

Shuah Khan (3):
      x86: kernel/check.c simple_strtoul cleanup
      x86: kernel/dumpstack.c simple_strtoul cleanup
      x86/pci-calgary_64.c: Remove obsoleted simple_strtoul() usage


 Makefile                         | 10 ++++++++++
 arch/x86/include/asm/spinlock.h  |  2 --
 arch/x86/kernel/check.c          | 20 ++++++++++++++------
 arch/x86/kernel/dumpstack.c      | 21 +++++++++++++++++++--
 arch/x86/kernel/pci-calgary_64.c |  8 +++++---
 arch/x86/kernel/setup.c          |  7 +++----
 lib/Kconfig.debug                |  9 +++++++++
 7 files changed, 60 insertions(+), 17 deletions(-)

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
diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 76bfa2c..b315a33 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -20,10 +20,8 @@
 
 #ifdef CONFIG_X86_32
 # define LOCK_PTR_REG "a"
-# define REG_PTR_MODE "k"
 #else
 # define LOCK_PTR_REG "D"
-# define REG_PTR_MODE "q"
 #endif
 
 #if defined(CONFIG_X86_32) && \
diff --git a/arch/x86/kernel/check.c b/arch/x86/kernel/check.c
index 5da1269..e2dbcb7 100644
--- a/arch/x86/kernel/check.c
+++ b/arch/x86/kernel/check.c
@@ -27,21 +27,29 @@ static int num_scan_areas;
 
 static __init int set_corruption_check(char *arg)
 {
-	char *end;
+	ssize_t ret;
+	unsigned long val;
 
-	memory_corruption_check = simple_strtol(arg, &end, 10);
+	ret = kstrtoul(arg, 10, &val);
+	if (ret)
+		return ret;
 
-	return (*end == 0) ? 0 : -EINVAL;
+	memory_corruption_check = val;
+	return 0;
 }
 early_param("memory_corruption_check", set_corruption_check);
 
 static __init int set_corruption_check_period(char *arg)
 {
-	char *end;
+	ssize_t ret;
+	unsigned long val;
 
-	corruption_check_period = simple_strtoul(arg, &end, 10);
+	ret = kstrtoul(arg, 10, &val);
+	if (ret)
+		return ret;
 
-	return (*end == 0) ? 0 : -EINVAL;
+	corruption_check_period = val;
+	return 0;
 }
 early_param("memory_corruption_check_period", set_corruption_check_period);
 
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 1b81839..b154f6d 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -311,16 +311,33 @@ void die(const char *str, struct pt_regs *regs, long err)
 
 static int __init kstack_setup(char *s)
 {
+	ssize_t ret;
+	unsigned long val;
+
 	if (!s)
 		return -EINVAL;
-	kstack_depth_to_print = simple_strtoul(s, NULL, 0);
+
+	ret = kstrtoul(s, 0, &val);
+	if (ret)
+		return ret;
+	kstack_depth_to_print = val;
 	return 0;
 }
 early_param("kstack", kstack_setup);
 
 static int __init code_bytes_setup(char *s)
 {
-	code_bytes = simple_strtoul(s, NULL, 0);
+	ssize_t ret;
+	unsigned long val;
+
+	if (!s)
+		return -EINVAL;
+
+	ret = kstrtoul(s, 0, &val);
+	if (ret)
+		return ret;
+
+	code_bytes = val;
 	if (code_bytes > 8192)
 		code_bytes = 8192;
 
diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index 6ac5782..dbbfb26 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -1479,8 +1479,9 @@ cleanup:
 static int __init calgary_parse_options(char *p)
 {
 	unsigned int bridge;
+	unsigned long val;
 	size_t len;
-	char* endp;
+	ssize_t ret;
 
 	while (*p) {
 		if (!strncmp(p, "64k", 3))
@@ -1511,10 +1512,11 @@ static int __init calgary_parse_options(char *p)
 				++p;
 			if (*p == '\0')
 				break;
-			bridge = simple_strtoul(p, &endp, 0);
-			if (p == endp)
+			ret = kstrtoul(p, 0, &val);
+			if (ret)
 				break;
 
+			bridge = val;
 			if (bridge < MAX_PHB_BUS_NUM) {
 				printk(KERN_INFO "Calgary: disabling "
 				       "translation for PHB %#x\n", bridge);
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 1a29015..37ef116 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -393,10 +393,9 @@ static void __init reserve_initrd(void)
 	initrd_start = 0;
 
 	if (ramdisk_size >= (end_of_lowmem>>1)) {
-		memblock_free(ramdisk_image, ramdisk_end - ramdisk_image);
-		printk(KERN_ERR "initrd too large to handle, "
-		       "disabling initrd\n");
-		return;
+		panic("initrd too large to handle, "
+		       "disabling initrd (%lld needed, %lld available)\n",
+		       ramdisk_size, end_of_lowmem>>1);
 	}
 
 	printk(KERN_INFO "RAMDISK: %08llx - %08llx\n", ramdisk_image,
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

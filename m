Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab0FSNWi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 09:22:38 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38123 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755844Ab0FSNWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 09:22:37 -0400
Date: Sat, 19 Jun 2010 15:22:35 +0200
From: Andi Kleen <andi@firstfloor.org>
To: ebiederm@xmission.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Export kexec.h
Message-ID: <20100619132235.GA24200@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export kexec.h
    
kexec_load is a system call and it needs a header
file with its input arguments.

Export the parts of kexec.h needed for this.

Cc: ebiederm@xmission.com

Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 2fc8e14..8fd5d09 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -389,3 +389,5 @@ unifdef-y += xfrm.h
 objhdr-y += version.h
 header-y += wimax.h
 header-y += wimax/
+
+unifdef-y += kexec.h
diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index 03e8e8d..f4c5a0e 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -1,8 +1,46 @@
 #ifndef LINUX_KEXEC_H
 #define LINUX_KEXEC_H
 
-#ifdef CONFIG_KEXEC
+/* Kexec: one kernel loading another */
+
+#ifdef __KERNEL__
+#include <linux/compiler.h>
 #include <linux/types.h>
+#endif
+
+#define KEXEC_ON_CRASH		0x00000001
+#define KEXEC_PRESERVE_CONTEXT	0x00000002
+#define KEXEC_ARCH_MASK		0xffff0000
+
+/* These values match the ELF architecture values.
+ * Unless there is a good reason that should continue to be the case.
+ */
+#define KEXEC_ARCH_DEFAULT ( 0 << 16)
+#define KEXEC_ARCH_386     ( 3 << 16)
+#define KEXEC_ARCH_X86_64  (62 << 16)
+#define KEXEC_ARCH_PPC     (20 << 16)
+#define KEXEC_ARCH_PPC64   (21 << 16)
+#define KEXEC_ARCH_IA_64   (50 << 16)
+#define KEXEC_ARCH_ARM     (40 << 16)
+#define KEXEC_ARCH_S390    (22 << 16)
+#define KEXEC_ARCH_SH      (42 << 16)
+#define KEXEC_ARCH_MIPS_LE (10 << 16)
+#define KEXEC_ARCH_MIPS    ( 8 << 16)
+
+#define KEXEC_SEGMENT_MAX 16
+struct kexec_segment {
+	void __user *buf;
+	size_t bufsz;
+#ifdef __KERNEL__
+	unsigned long mem;	/* User space sees this as a (void *) ... */
+#else
+	void *mem;
+#endif
+	size_t memsz;
+};
+
+#ifdef __KERNEL__
+#ifdef CONFIG_KEXEC
 #include <linux/list.h>
 #include <linux/linkage.h>
 #include <linux/compat.h>
@@ -57,14 +95,6 @@ typedef unsigned long kimage_entry_t;
 #define IND_DONE         0x4
 #define IND_SOURCE       0x8
 
-#define KEXEC_SEGMENT_MAX 16
-struct kexec_segment {
-	void __user *buf;
-	size_t bufsz;
-	unsigned long mem;	/* User space sees this as a (void *) ... */
-	size_t memsz;
-};
-
 #ifdef CONFIG_COMPAT
 struct compat_kexec_segment {
 	compat_uptr_t buf;
@@ -163,25 +193,6 @@ extern struct kimage *kexec_crash_image;
 #define kexec_flush_icache_page(page)
 #endif
 
-#define KEXEC_ON_CRASH		0x00000001
-#define KEXEC_PRESERVE_CONTEXT	0x00000002
-#define KEXEC_ARCH_MASK		0xffff0000
-
-/* These values match the ELF architecture values.
- * Unless there is a good reason that should continue to be the case.
- */
-#define KEXEC_ARCH_DEFAULT ( 0 << 16)
-#define KEXEC_ARCH_386     ( 3 << 16)
-#define KEXEC_ARCH_X86_64  (62 << 16)
-#define KEXEC_ARCH_PPC     (20 << 16)
-#define KEXEC_ARCH_PPC64   (21 << 16)
-#define KEXEC_ARCH_IA_64   (50 << 16)
-#define KEXEC_ARCH_ARM     (40 << 16)
-#define KEXEC_ARCH_S390    (22 << 16)
-#define KEXEC_ARCH_SH      (42 << 16)
-#define KEXEC_ARCH_MIPS_LE (10 << 16)
-#define KEXEC_ARCH_MIPS    ( 8 << 16)
-
 /* List of defined/legal kexec flags */
 #ifndef CONFIG_KEXEC_JUMP
 #define KEXEC_FLAGS    KEXEC_ON_CRASH
@@ -215,4 +226,5 @@ struct task_struct;
 static inline void crash_kexec(struct pt_regs *regs) { }
 static inline int kexec_should_crash(struct task_struct *p) { return 0; }
 #endif /* CONFIG_KEXEC */
+#endif
 #endif /* LINUX_KEXEC_H */

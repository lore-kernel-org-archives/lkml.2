Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab1DSBBu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 21:01:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:55132 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752884Ab1DSBBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 21:01:47 -0400
Date: Tue, 19 Apr 2011 01:01:33 GMT
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-dc326fca2b640fc41aed7c015d0f456935a66255@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, tj@kernel.org,
        tglx@linutronix.de, jbaron@redhat.com, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, rostedt@goodmis.org, tj@kernel.org,
        tglx@linutronix.de, jbaron@redhat.com, hpa@linux.intel.com
In-Reply-To: <1303166160-10315-3-git-send-email-hpa@linux.intel.com>
References: <1303166160-10315-3-git-send-email-hpa@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cpu: Clean up and unify the NOP selection infrastructure
Git-Commit-ID: dc326fca2b640fc41aed7c015d0f456935a66255
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 19 Apr 2011 01:01:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dc326fca2b640fc41aed7c015d0f456935a66255
Gitweb:     http://git.kernel.org/tip/dc326fca2b640fc41aed7c015d0f456935a66255
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Mon, 18 Apr 2011 15:19:51 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 18 Apr 2011 16:40:21 -0700

x86, cpu: Clean up and unify the NOP selection infrastructure

Clean up and unify the NOP selection infrastructure:

- Make the atomic 5-byte NOP a part of the selection system.
- Pick NOPs once during early boot and then be done with it.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>
Link: http://lkml.kernel.org/r/1303166160-10315-3-git-send-email-hpa@linux.intel.com
---
 arch/x86/include/asm/alternative.h |    8 --
 arch/x86/include/asm/nops.h        |  146 +++++++++++++++++------------
 arch/x86/kernel/alternative.c      |  182 ++++++++++++++++++++----------------
 arch/x86/kernel/ftrace.c           |    4 +-
 arch/x86/kernel/jump_label.c       |    5 +-
 arch/x86/kernel/setup.c            |    6 +-
 6 files changed, 190 insertions(+), 161 deletions(-)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 13009d1..7da1682 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -191,12 +191,4 @@ extern void *text_poke(void *addr, const void *opcode, size_t len);
 extern void *text_poke_smp(void *addr, const void *opcode, size_t len);
 extern void text_poke_smp_batch(struct text_poke_param *params, int n);
 
-#if defined(CONFIG_DYNAMIC_FTRACE) || defined(HAVE_JUMP_LABEL)
-#define IDEAL_NOP_SIZE_5 5
-extern unsigned char ideal_nop5[IDEAL_NOP_SIZE_5];
-extern void arch_init_ideal_nop5(void);
-#else
-static inline void arch_init_ideal_nop5(void) {}
-#endif
-
 #endif /* _ASM_X86_ALTERNATIVE_H */
diff --git a/arch/x86/include/asm/nops.h b/arch/x86/include/asm/nops.h
index af78849..405b403 100644
--- a/arch/x86/include/asm/nops.h
+++ b/arch/x86/include/asm/nops.h
@@ -1,7 +1,13 @@
 #ifndef _ASM_X86_NOPS_H
 #define _ASM_X86_NOPS_H
 
-/* Define nops for use with alternative() */
+/*
+ * Define nops for use with alternative() and for tracing.
+ *
+ * *_NOP5_ATOMIC must be a single instruction.
+ */
+
+#define NOP_DS_PREFIX 0x3e
 
 /* generic versions from gas
    1: nop
@@ -13,14 +19,15 @@
    6: leal 0x00000000(%esi),%esi
    7: leal 0x00000000(,%esi,1),%esi
 */
-#define GENERIC_NOP1 ".byte 0x90\n"
-#define GENERIC_NOP2 ".byte 0x89,0xf6\n"
-#define GENERIC_NOP3 ".byte 0x8d,0x76,0x00\n"
-#define GENERIC_NOP4 ".byte 0x8d,0x74,0x26,0x00\n"
-#define GENERIC_NOP5 GENERIC_NOP1 GENERIC_NOP4
-#define GENERIC_NOP6 ".byte 0x8d,0xb6,0x00,0x00,0x00,0x00\n"
-#define GENERIC_NOP7 ".byte 0x8d,0xb4,0x26,0x00,0x00,0x00,0x00\n"
-#define GENERIC_NOP8 GENERIC_NOP1 GENERIC_NOP7
+#define GENERIC_NOP1 0x90
+#define GENERIC_NOP2 0x89,0xf6
+#define GENERIC_NOP3 0x8d,0x76,0x00
+#define GENERIC_NOP4 0x8d,0x74,0x26,0x00
+#define GENERIC_NOP5 GENERIC_NOP1,GENERIC_NOP4
+#define GENERIC_NOP6 0x8d,0xb6,0x00,0x00,0x00,0x00
+#define GENERIC_NOP7 0x8d,0xb4,0x26,0x00,0x00,0x00,0x00
+#define GENERIC_NOP8 GENERIC_NOP1,GENERIC_NOP7
+#define GENERIC_NOP5_ATOMIC NOP_DS_PREFIX,GENERIC_NOP4
 
 /* Opteron 64bit nops
    1: nop
@@ -29,13 +36,14 @@
    4: osp osp osp nop
 */
 #define K8_NOP1 GENERIC_NOP1
-#define K8_NOP2	".byte 0x66,0x90\n"
-#define K8_NOP3	".byte 0x66,0x66,0x90\n"
-#define K8_NOP4	".byte 0x66,0x66,0x66,0x90\n"
-#define K8_NOP5	K8_NOP3 K8_NOP2
-#define K8_NOP6	K8_NOP3 K8_NOP3
-#define K8_NOP7	K8_NOP4 K8_NOP3
-#define K8_NOP8	K8_NOP4 K8_NOP4
+#define K8_NOP2	0x66,K8_NOP1
+#define K8_NOP3	0x66,K8_NOP2
+#define K8_NOP4	0x66,K8_NOP3
+#define K8_NOP5	K8_NOP3,K8_NOP2
+#define K8_NOP6	K8_NOP3,K8_NOP3
+#define K8_NOP7	K8_NOP4,K8_NOP3
+#define K8_NOP8	K8_NOP4,K8_NOP4
+#define K8_NOP5_ATOMIC 0x66,K8_NOP4
 
 /* K7 nops
    uses eax dependencies (arbitrary choice)
@@ -47,13 +55,14 @@
    7: leal 0x00000000(,%eax,1),%eax
 */
 #define K7_NOP1	GENERIC_NOP1
-#define K7_NOP2	".byte 0x8b,0xc0\n"
-#define K7_NOP3	".byte 0x8d,0x04,0x20\n"
-#define K7_NOP4	".byte 0x8d,0x44,0x20,0x00\n"
-#define K7_NOP5	K7_NOP4 ASM_NOP1
-#define K7_NOP6	".byte 0x8d,0x80,0,0,0,0\n"
-#define K7_NOP7	".byte 0x8D,0x04,0x05,0,0,0,0\n"
-#define K7_NOP8	K7_NOP7 ASM_NOP1
+#define K7_NOP2	0x8b,0xc0
+#define K7_NOP3	0x8d,0x04,0x20
+#define K7_NOP4	0x8d,0x44,0x20,0x00
+#define K7_NOP5	K7_NOP4,K7_NOP1
+#define K7_NOP6	0x8d,0x80,0,0,0,0
+#define K7_NOP7	0x8D,0x04,0x05,0,0,0,0
+#define K7_NOP8	K7_NOP7,K7_NOP1
+#define K7_NOP5_ATOMIC NOP_DS_PREFIX,K7_NOP4
 
 /* P6 nops
    uses eax dependencies (Intel-recommended choice)
@@ -69,52 +78,65 @@
 	There is kernel code that depends on this.
 */
 #define P6_NOP1	GENERIC_NOP1
-#define P6_NOP2	".byte 0x66,0x90\n"
-#define P6_NOP3	".byte 0x0f,0x1f,0x00\n"
-#define P6_NOP4	".byte 0x0f,0x1f,0x40,0\n"
-#define P6_NOP5	".byte 0x0f,0x1f,0x44,0x00,0\n"
-#define P6_NOP6	".byte 0x66,0x0f,0x1f,0x44,0x00,0\n"
-#define P6_NOP7	".byte 0x0f,0x1f,0x80,0,0,0,0\n"
-#define P6_NOP8	".byte 0x0f,0x1f,0x84,0x00,0,0,0,0\n"
+#define P6_NOP2	0x66,0x90
+#define P6_NOP3	0x0f,0x1f,0x00
+#define P6_NOP4	0x0f,0x1f,0x40,0
+#define P6_NOP5	0x0f,0x1f,0x44,0x00,0
+#define P6_NOP6	0x66,0x0f,0x1f,0x44,0x00,0
+#define P6_NOP7	0x0f,0x1f,0x80,0,0,0,0
+#define P6_NOP8	0x0f,0x1f,0x84,0x00,0,0,0,0
+#define P6_NOP5_ATOMIC P6_NOP5
+
+#define _ASM_MK_NOP(x) ".byte " __stringify(x) "\n"
 
 #if defined(CONFIG_MK7)
-#define ASM_NOP1 K7_NOP1
-#define ASM_NOP2 K7_NOP2
-#define ASM_NOP3 K7_NOP3
-#define ASM_NOP4 K7_NOP4
-#define ASM_NOP5 K7_NOP5
-#define ASM_NOP6 K7_NOP6
-#define ASM_NOP7 K7_NOP7
-#define ASM_NOP8 K7_NOP8
+#define ASM_NOP1 _ASM_MK_NOP(K7_NOP1)
+#define ASM_NOP2 _ASM_MK_NOP(K7_NOP2)
+#define ASM_NOP3 _ASM_MK_NOP(K7_NOP3)
+#define ASM_NOP4 _ASM_MK_NOP(K7_NOP4)
+#define ASM_NOP5 _ASM_MK_NOP(K7_NOP5)
+#define ASM_NOP6 _ASM_MK_NOP(K7_NOP6)
+#define ASM_NOP7 _ASM_MK_NOP(K7_NOP7)
+#define ASM_NOP8 _ASM_MK_NOP(K7_NOP8)
+#define ASM_NOP5_ATOMIC _ASM_MK_NOP(K7_NOP5_ATOMIC)
 #elif defined(CONFIG_X86_P6_NOP)
-#define ASM_NOP1 P6_NOP1
-#define ASM_NOP2 P6_NOP2
-#define ASM_NOP3 P6_NOP3
-#define ASM_NOP4 P6_NOP4
-#define ASM_NOP5 P6_NOP5
-#define ASM_NOP6 P6_NOP6
-#define ASM_NOP7 P6_NOP7
-#define ASM_NOP8 P6_NOP8
+#define ASM_NOP1 _ASM_MK_NOP(P6_NOP1)
+#define ASM_NOP2 _ASM_MK_NOP(P6_NOP2)
+#define ASM_NOP3 _ASM_MK_NOP(P6_NOP3)
+#define ASM_NOP4 _ASM_MK_NOP(P6_NOP4)
+#define ASM_NOP5 _ASM_MK_NOP(P6_NOP5)
+#define ASM_NOP6 _ASM_MK_NOP(P6_NOP6)
+#define ASM_NOP7 _ASM_MK_NOP(P6_NOP7)
+#define ASM_NOP8 _ASM_MK_NOP(P6_NOP8)
+#define ASM_NOP5_ATOMIC _ASM_MK_NOP(P6_NOP5_ATOMIC)
 #elif defined(CONFIG_X86_64)
-#define ASM_NOP1 K8_NOP1
-#define ASM_NOP2 K8_NOP2
-#define ASM_NOP3 K8_NOP3
-#define ASM_NOP4 K8_NOP4
-#define ASM_NOP5 K8_NOP5
-#define ASM_NOP6 K8_NOP6
-#define ASM_NOP7 K8_NOP7
-#define ASM_NOP8 K8_NOP8
+#define ASM_NOP1 _ASM_MK_NOP(K8_NOP1)
+#define ASM_NOP2 _ASM_MK_NOP(K8_NOP2)
+#define ASM_NOP3 _ASM_MK_NOP(K8_NOP3)
+#define ASM_NOP4 _ASM_MK_NOP(K8_NOP4)
+#define ASM_NOP5 _ASM_MK_NOP(K8_NOP5)
+#define ASM_NOP6 _ASM_MK_NOP(K8_NOP6)
+#define ASM_NOP7 _ASM_MK_NOP(K8_NOP7)
+#define ASM_NOP8 _ASM_MK_NOP(K8_NOP8)
+#define ASM_NOP5_ATOMIC _ASM_MK_NOP(K8_NOP5_ATOMIC)
 #else
-#define ASM_NOP1 GENERIC_NOP1
-#define ASM_NOP2 GENERIC_NOP2
-#define ASM_NOP3 GENERIC_NOP3
-#define ASM_NOP4 GENERIC_NOP4
-#define ASM_NOP5 GENERIC_NOP5
-#define ASM_NOP6 GENERIC_NOP6
-#define ASM_NOP7 GENERIC_NOP7
-#define ASM_NOP8 GENERIC_NOP8
+#define ASM_NOP1 _ASM_MK_NOP(GENERIC_NOP1)
+#define ASM_NOP2 _ASM_MK_NOP(GENERIC_NOP2)
+#define ASM_NOP3 _ASM_MK_NOP(GENERIC_NOP3)
+#define ASM_NOP4 _ASM_MK_NOP(GENERIC_NOP4)
+#define ASM_NOP5 _ASM_MK_NOP(GENERIC_NOP5)
+#define ASM_NOP6 _ASM_MK_NOP(GENERIC_NOP6)
+#define ASM_NOP7 _ASM_MK_NOP(GENERIC_NOP7)
+#define ASM_NOP8 _ASM_MK_NOP(GENERIC_NOP8)
+#define ASM_NOP5_ATOMIC _ASM_MK_NOP(GENERIC_NOP5_ATOMIC)
 #endif
 
 #define ASM_NOP_MAX 8
+#define NOP_ATOMIC5 (ASM_NOP_MAX+1)	/* Entry for the 5-byte atomic NOP */
+
+#ifndef __ASSEMBLY__
+extern const unsigned char * const *ideal_nops;
+extern void arch_init_ideal_nops(void);
+#endif
 
 #endif /* _ASM_X86_NOPS_H */
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 4a23467..846f61e 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -67,17 +67,30 @@ __setup("noreplace-paravirt", setup_noreplace_paravirt);
 #define DPRINTK(fmt, args...) if (debug_alternative) \
 	printk(KERN_DEBUG fmt, args)
 
+/*
+ * Each GENERIC_NOPX is of X bytes, and defined as an array of bytes
+ * that correspond to that nop. Getting from one nop to the next, we
+ * add to the array the offset that is equal to the sum of all sizes of
+ * nops preceding the one we are after.
+ *
+ * Note: The GENERIC_NOP5_ATOMIC is at the end, as it breaks the
+ * nice symmetry of sizes of the previous nops.
+ */
 #if defined(GENERIC_NOP1) && !defined(CONFIG_X86_64)
-/* Use inline assembly to define this because the nops are defined
-   as inline assembly strings in the include files and we cannot
-   get them easily into strings. */
-asm("\t" __stringify(__INITRODATA_OR_MODULE) "\nintelnops: "
-	GENERIC_NOP1 GENERIC_NOP2 GENERIC_NOP3 GENERIC_NOP4 GENERIC_NOP5 GENERIC_NOP6
-	GENERIC_NOP7 GENERIC_NOP8
-    "\t.previous");
-extern const unsigned char intelnops[];
-static const unsigned char *const __initconst_or_module
-intel_nops[ASM_NOP_MAX+1] = {
+static const unsigned char intelnops[] =
+{
+	GENERIC_NOP1,
+	GENERIC_NOP2,
+	GENERIC_NOP3,
+	GENERIC_NOP4,
+	GENERIC_NOP5,
+	GENERIC_NOP6,
+	GENERIC_NOP7,
+	GENERIC_NOP8,
+	GENERIC_NOP5_ATOMIC
+};
+static const unsigned char * const intel_nops[ASM_NOP_MAX+2] =
+{
 	NULL,
 	intelnops,
 	intelnops + 1,
@@ -87,17 +100,25 @@ intel_nops[ASM_NOP_MAX+1] = {
 	intelnops + 1 + 2 + 3 + 4 + 5,
 	intelnops + 1 + 2 + 3 + 4 + 5 + 6,
 	intelnops + 1 + 2 + 3 + 4 + 5 + 6 + 7,
+	intelnops + 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8,
 };
 #endif
 
 #ifdef K8_NOP1
-asm("\t" __stringify(__INITRODATA_OR_MODULE) "\nk8nops: "
-	K8_NOP1 K8_NOP2 K8_NOP3 K8_NOP4 K8_NOP5 K8_NOP6
-	K8_NOP7 K8_NOP8
-    "\t.previous");
-extern const unsigned char k8nops[];
-static const unsigned char *const __initconst_or_module
-k8_nops[ASM_NOP_MAX+1] = {
+static const unsigned char k8nops[] =
+{
+	K8_NOP1,
+	K8_NOP2,
+	K8_NOP3,
+	K8_NOP4,
+	K8_NOP5,
+	K8_NOP6,
+	K8_NOP7,
+	K8_NOP8,
+	K8_NOP5_ATOMIC
+};
+static const unsigned char * const k8_nops[ASM_NOP_MAX+2] =
+{
 	NULL,
 	k8nops,
 	k8nops + 1,
@@ -107,17 +128,25 @@ k8_nops[ASM_NOP_MAX+1] = {
 	k8nops + 1 + 2 + 3 + 4 + 5,
 	k8nops + 1 + 2 + 3 + 4 + 5 + 6,
 	k8nops + 1 + 2 + 3 + 4 + 5 + 6 + 7,
+	k8nops + 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8,
 };
 #endif
 
 #if defined(K7_NOP1) && !defined(CONFIG_X86_64)
-asm("\t" __stringify(__INITRODATA_OR_MODULE) "\nk7nops: "
-	K7_NOP1 K7_NOP2 K7_NOP3 K7_NOP4 K7_NOP5 K7_NOP6
-	K7_NOP7 K7_NOP8
-    "\t.previous");
-extern const unsigned char k7nops[];
-static const unsigned char *const __initconst_or_module
-k7_nops[ASM_NOP_MAX+1] = {
+static const unsigned char k7nops[] =
+{
+	K7_NOP1,
+	K7_NOP2,
+	K7_NOP3,
+	K7_NOP4,
+	K7_NOP5,
+	K7_NOP6,
+	K7_NOP7,
+	K7_NOP8,
+	K7_NOP5_ATOMIC
+};
+static const unsigned char * const k7_nops[ASM_NOP_MAX+2] =
+{
 	NULL,
 	k7nops,
 	k7nops + 1,
@@ -127,17 +156,25 @@ k7_nops[ASM_NOP_MAX+1] = {
 	k7nops + 1 + 2 + 3 + 4 + 5,
 	k7nops + 1 + 2 + 3 + 4 + 5 + 6,
 	k7nops + 1 + 2 + 3 + 4 + 5 + 6 + 7,
+	k7nops + 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8,
 };
 #endif
 
 #ifdef P6_NOP1
-asm("\t" __stringify(__INITRODATA_OR_MODULE) "\np6nops: "
-	P6_NOP1 P6_NOP2 P6_NOP3 P6_NOP4 P6_NOP5 P6_NOP6
-	P6_NOP7 P6_NOP8
-    "\t.previous");
-extern const unsigned char p6nops[];
-static const unsigned char *const __initconst_or_module
-p6_nops[ASM_NOP_MAX+1] = {
+static const unsigned char  __initconst_or_module p6nops[] =
+{
+	P6_NOP1,
+	P6_NOP2,
+	P6_NOP3,
+	P6_NOP4,
+	P6_NOP5,
+	P6_NOP6,
+	P6_NOP7,
+	P6_NOP8,
+	P6_NOP5_ATOMIC
+};
+static const unsigned char * const p6_nops[ASM_NOP_MAX+2] =
+{
 	NULL,
 	p6nops,
 	p6nops + 1,
@@ -147,47 +184,53 @@ p6_nops[ASM_NOP_MAX+1] = {
 	p6nops + 1 + 2 + 3 + 4 + 5,
 	p6nops + 1 + 2 + 3 + 4 + 5 + 6,
 	p6nops + 1 + 2 + 3 + 4 + 5 + 6 + 7,
+	p6nops + 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8,
 };
 #endif
 
+/* Initialize these to a safe default */
 #ifdef CONFIG_X86_64
+const unsigned char * const *ideal_nops = p6_nops;
+#else
+const unsigned char * const *ideal_nops = intel_nops;
+#endif
 
-extern char __vsyscall_0;
-static const unsigned char *const *__init_or_module find_nop_table(void)
+void __init arch_init_ideal_nops(void)
 {
-	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL &&
-	    boot_cpu_has(X86_FEATURE_NOPL))
-		return p6_nops;
-	else
-		return k8_nops;
-}
-
-#else /* CONFIG_X86_64 */
+	switch (boot_cpu_data.x86_vendor) {
+	case X86_VENDOR_INTEL:
+		if (boot_cpu_has(X86_FEATURE_NOPL)) {
+			   ideal_nops = p6_nops;
+		} else {
+#ifdef CONFIG_X86_64
+			ideal_nops = k8_nops;
+#else
+			ideal_nops = intel_nops;
+#endif
+		}
 
-static const unsigned char *const *__init_or_module find_nop_table(void)
-{
-	if (boot_cpu_has(X86_FEATURE_K8))
-		return k8_nops;
-	else if (boot_cpu_has(X86_FEATURE_K7))
-		return k7_nops;
-	else if (boot_cpu_has(X86_FEATURE_NOPL))
-		return p6_nops;
-	else
-		return intel_nops;
+	default:
+#ifdef CONFIG_X86_64
+		ideal_nops = k8_nops;
+#else
+		if (boot_cpu_has(X86_FEATURE_K8))
+			ideal_nops = k8_nops;
+		else if (boot_cpu_has(X86_FEATURE_K7))
+			ideal_nops = k7_nops;
+		else
+			ideal_nops = intel_nops;
+#endif
+	}
 }
 
-#endif /* CONFIG_X86_64 */
-
 /* Use this to add nops to a buffer, then text_poke the whole buffer. */
 static void __init_or_module add_nops(void *insns, unsigned int len)
 {
-	const unsigned char *const *noptable = find_nop_table();
-
 	while (len > 0) {
 		unsigned int noplen = len;
 		if (noplen > ASM_NOP_MAX)
 			noplen = ASM_NOP_MAX;
-		memcpy(insns, noptable[noplen], noplen);
+		memcpy(insns, ideal_nops[noplen], noplen);
 		insns += noplen;
 		len -= noplen;
 	}
@@ -195,6 +238,7 @@ static void __init_or_module add_nops(void *insns, unsigned int len)
 
 extern struct alt_instr __alt_instructions[], __alt_instructions_end[];
 extern s32 __smp_locks[], __smp_locks_end[];
+extern char __vsyscall_0;
 void *text_poke_early(void *addr, const void *opcode, size_t len);
 
 /* Replace instructions with better alternatives for this CPU type.
@@ -678,29 +722,3 @@ void __kprobes text_poke_smp_batch(struct text_poke_param *params, int n)
 	wrote_text = 0;
 	__stop_machine(stop_machine_text_poke, (void *)&tpp, NULL);
 }
-
-#if defined(CONFIG_DYNAMIC_FTRACE) || defined(HAVE_JUMP_LABEL)
-
-#ifdef CONFIG_X86_64
-unsigned char ideal_nop5[5] = { 0x66, 0x66, 0x66, 0x66, 0x90 };
-#else
-unsigned char ideal_nop5[5] = { 0x3e, 0x8d, 0x74, 0x26, 0x00 };
-#endif
-
-void __init arch_init_ideal_nop5(void)
-{
-	/*
-	 * There is no good nop for all x86 archs.  This selection
-	 * algorithm should be unified with the one in find_nop_table(),
-	 * but this should be good enough for now.
-	 *
-	 * For cases other than the ones below, use the safe (as in
-	 * always functional) defaults above.
-	 */
-#ifdef CONFIG_X86_64
-	/* Don't use these on 32 bits due to broken virtualizers */
-	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL)
-		memcpy(ideal_nop5, p6_nops[5], 5);
-#endif
-}
-#endif
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index a93742a..0ba15a6 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -260,9 +260,9 @@ do_ftrace_mod_code(unsigned long ip, void *new_code)
 	return mod_code_status;
 }
 
-static unsigned char *ftrace_nop_replace(void)
+static const unsigned char *ftrace_nop_replace(void)
 {
-	return ideal_nop5;
+	return ideal_nops[NOP_ATOMIC5];
 }
 
 static int
diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
index 961b6b3..3fee346 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -34,7 +34,7 @@ void arch_jump_label_transform(struct jump_entry *entry,
 		code.offset = entry->target -
 				(entry->code + JUMP_LABEL_NOP_SIZE);
 	} else
-		memcpy(&code, ideal_nop5, JUMP_LABEL_NOP_SIZE);
+		memcpy(&code, ideal_nops[NOP_ATOMIC5], JUMP_LABEL_NOP_SIZE);
 	get_online_cpus();
 	mutex_lock(&text_mutex);
 	text_poke_smp((void *)entry->code, &code, JUMP_LABEL_NOP_SIZE);
@@ -44,7 +44,8 @@ void arch_jump_label_transform(struct jump_entry *entry,
 
 void arch_jump_label_text_poke_early(jump_label_t addr)
 {
-	text_poke_early((void *)addr, ideal_nop5, JUMP_LABEL_NOP_SIZE);
+	text_poke_early((void *)addr, ideal_nops[NOP_ATOMIC5],
+			JUMP_LABEL_NOP_SIZE);
 }
 
 #endif
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 5a0484a..390a663 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -691,8 +691,6 @@ early_param("reservelow", parse_reservelow);
 
 void __init setup_arch(char **cmdline_p)
 {
-	unsigned long flags;
-
 #ifdef CONFIG_X86_32
 	memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
 	visws_early_detect();
@@ -1036,9 +1034,7 @@ void __init setup_arch(char **cmdline_p)
 
 	mcheck_init();
 
-	local_irq_save(flags);
-	arch_init_ideal_nop5();
-	local_irq_restore(flags);
+	arch_init_ideal_nops();
 }
 
 #ifdef CONFIG_X86_32

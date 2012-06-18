Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450Ab2FRT53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 15:57:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41676 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314Ab2FRT52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 15:57:28 -0400
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: baryluk@smp.if.uj.edu.pl, LKML <linux-kernel@vger.kernel.org>,
        JBeulich@suse.com, zhong@linux.vnet.ibm.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH v2] x86,nmi: Fix section mismatch warnings on 32-bit (cleaner)
Date: Mon, 18 Jun 2012 15:56:33 -0400
Message-Id: <1340049393-17771-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tried to fix the following section mismatch warnings in commit eeaaa96:

 VDSOSYM arch/x86/vdso/vdso32-syms.lds
  LD      arch/x86/vdso/built-in.o
  LD      arch/x86/built-in.o
WARNING: arch/x86/built-in.o(.data+0x5af0): Section mismatch in reference from the variable
test_nmi_ipi_callback_na.10451 to the function .init.text:test_nmi_ipi_callback()
The variable test_nmi_ipi_callback_na.10451 references
the function __init test_nmi_ipi_callback()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

WARNING: arch/x86/built-in.o(.data+0x5b04): Section mismatch in reference from the variable
nmi_unk_cb_na.10399 to the function .init.text:nmi_unk_cb()
The variable nmi_unk_cb_na.10399 references
the function __init nmi_unk_cb()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

However, Li Zhong found an easier and cleaner way to do this by using variable
arguments.  I like his way better.  It is easier to maintain.

Reported-by: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
Cc: Jan Beulich <JBeulich@suse.com>
Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/include/asm/nmi.h     |   20 +++-----------------
 arch/x86/kernel/nmi_selftest.c |    7 ++++---
 2 files changed, 7 insertions(+), 20 deletions(-)

---
Hi Ingo,

This combination patch doesn't look as ugly as I thought it did.  Sorry for the patch noise.

Cheers,
Don

diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index dc580c4..c0fa356 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -44,28 +44,14 @@ struct nmiaction {
 	const char		*name;
 };
 
-#define register_nmi_handler(t, fn, fg, n)		\
+#define register_nmi_handler(t, fn, fg, n, init...)	\
 ({							\
-	static struct nmiaction fn##_na = {		\
+	static struct nmiaction init fn##_na = {	\
 		.handler = (fn),			\
 		.name = (n),				\
 		.flags = (fg),				\
 	};						\
-	__register_nmi_handler((t), &fn##_na);	\
-})
-
-/*
- * For special handlers that register/unregister in the
- * init section only.  This should be considered rare.
- */
-#define register_nmi_handler_initonly(t, fn, fg, n)		\
-({							\
-	static struct nmiaction fn##_na __initdata = {		\
-		.handler = (fn),			\
-		.name = (n),				\
-		.flags = (fg),				\
-	};						\
-	__register_nmi_handler((t), &fn##_na);	\
+	__register_nmi_handler((t), &fn##_na);		\
 })
 
 int __register_nmi_handler(unsigned int, struct nmiaction *);
diff --git a/arch/x86/kernel/nmi_selftest.c b/arch/x86/kernel/nmi_selftest.c
index 149b8d9..6d9582e 100644
--- a/arch/x86/kernel/nmi_selftest.c
+++ b/arch/x86/kernel/nmi_selftest.c
@@ -42,7 +42,8 @@ static int __init nmi_unk_cb(unsigned int val, struct pt_regs *regs)
 static void __init init_nmi_testsuite(void)
 {
 	/* trap all the unknown NMIs we may generate */
-	register_nmi_handler_initonly(NMI_UNKNOWN, nmi_unk_cb, 0, "nmi_selftest_unk");
+	register_nmi_handler(NMI_UNKNOWN, nmi_unk_cb, 0, "nmi_selftest_unk",
+			__initdata);
 }
 
 static void __init cleanup_nmi_testsuite(void)
@@ -64,8 +65,8 @@ static void __init test_nmi_ipi(struct cpumask *mask)
 {
 	unsigned long timeout;
 
-	if (register_nmi_handler_initonly(NMI_LOCAL, test_nmi_ipi_callback,
-				 NMI_FLAG_FIRST, "nmi_selftest")) {
+	if (register_nmi_handler(NMI_LOCAL, test_nmi_ipi_callback,
+				 NMI_FLAG_FIRST, "nmi_selftest", __initdata)) {
 		nmi_fail = FAILURE;
 		return;
 	}
-- 
1.7.7.6


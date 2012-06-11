Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab2FKPeK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 11:34:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755347Ab2FKPeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 11:34:08 -0400
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: baryluk@smp.if.uj.edu.pl, LKML <linux-kernel@vger.kernel.org>,
        JBeulich@suse.com, zhong@linux.vnet.ibm.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 2/2] x86,nmi: Fix section mismatch warnings on 32-bit
Date: Mon, 11 Jun 2012 11:33:29 -0400
Message-Id: <1339428809-29360-3-git-send-email-dzickus@redhat.com>
In-Reply-To: <1339428809-29360-1-git-send-email-dzickus@redhat.com>
References: <1339428809-29360-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zhong <zhong@linux.vnet.ibm.com>

It was reported that compiling for 32-bit caused a bunch of section
mismatch warnings:

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

Both of these are attributed to the internal representation of the nmiaction
struct created during register_nmi_handler.  The reason for this is that those
structs are not defined in the init section whereas the rest of the code in
nmi_selftest.c is.

This is resolved by passing in another parameter that sets the structure as
initdata or not.

[ Big thanks to Jan Beulich for decoding this for me as I didn't have a clue
what was going on. ]

Reported-by: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
Cc: Jan Beulich <JBeulich@suse.com>
Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/include/asm/nmi.h     |    6 +++---
 arch/x86/kernel/nmi_selftest.c |    5 +++--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index 0e3793b..c0fa356 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -44,14 +44,14 @@ struct nmiaction {
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
+	__register_nmi_handler((t), &fn##_na);		\
 })
 
 int __register_nmi_handler(unsigned int, struct nmiaction *);
diff --git a/arch/x86/kernel/nmi_selftest.c b/arch/x86/kernel/nmi_selftest.c
index e31bf8d..6d9582e 100644
--- a/arch/x86/kernel/nmi_selftest.c
+++ b/arch/x86/kernel/nmi_selftest.c
@@ -42,7 +42,8 @@ static int __init nmi_unk_cb(unsigned int val, struct pt_regs *regs)
 static void __init init_nmi_testsuite(void)
 {
 	/* trap all the unknown NMIs we may generate */
-	register_nmi_handler(NMI_UNKNOWN, nmi_unk_cb, 0, "nmi_selftest_unk");
+	register_nmi_handler(NMI_UNKNOWN, nmi_unk_cb, 0, "nmi_selftest_unk",
+			__initdata);
 }
 
 static void __init cleanup_nmi_testsuite(void)
@@ -65,7 +66,7 @@ static void __init test_nmi_ipi(struct cpumask *mask)
 	unsigned long timeout;
 
 	if (register_nmi_handler(NMI_LOCAL, test_nmi_ipi_callback,
-				 NMI_FLAG_FIRST, "nmi_selftest")) {
+				 NMI_FLAG_FIRST, "nmi_selftest", __initdata)) {
 		nmi_fail = FAILURE;
 		return;
 	}
-- 
1.7.7.6


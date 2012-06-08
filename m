Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760989Ab2FHO5d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 10:57:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59699 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758239Ab2FHO5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 10:57:31 -0400
Date: Fri, 8 Jun 2012 07:57:10 -0700
From: tip-bot for Don Zickus <dzickus@redhat.com>
Message-ID: <tip-eeaaa96a3a2134a174100afd129bb0891d05f4b2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        JBeulich@suse.com, baryluk@smp.if.uj.edu.pl, tglx@linutronix.de,
        dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        JBeulich@suse.com, tglx@linutronix.de, baryluk@smp.if.uj.edu.pl,
        dzickus@redhat.com
In-Reply-To: <1338991542-23000-1-git-send-email-dzickus@redhat.com>
References: <1338991542-23000-1-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/nmi: Fix section mismatch warnings on 32-bit
Git-Commit-ID: eeaaa96a3a2134a174100afd129bb0891d05f4b2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 08 Jun 2012 07:57:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eeaaa96a3a2134a174100afd129bb0891d05f4b2
Gitweb:     http://git.kernel.org/tip/eeaaa96a3a2134a174100afd129bb0891d05f4b2
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Wed, 6 Jun 2012 10:05:42 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 8 Jun 2012 12:19:27 +0200

x86/nmi: Fix section mismatch warnings on 32-bit

It was reported that compiling for 32-bit caused a bunch of
section mismatch warnings:

 VDSOSYM arch/x86/vdso/vdso32-syms.lds
  LD      arch/x86/vdso/built-in.o
  LD      arch/x86/built-in.o

 WARNING: arch/x86/built-in.o(.data+0x5af0): Section mismatch in
 reference from the variable test_nmi_ipi_callback_na.10451 to
 the function .init.text:test_nmi_ipi_callback() [...]

 WARNING: arch/x86/built-in.o(.data+0x5b04): Section mismatch in
 reference from the variable nmi_unk_cb_na.10399 to the function
 .init.text:nmi_unk_cb() The variable nmi_unk_cb_na.10399
 references the function __init nmi_unk_cb() [...]

Both of these are attributed to the internal representation of
the nmiaction struct created during register_nmi_handler.  The
reason for this is that those structs are not defined in the
init section whereas the rest of the code in nmi_selftest.c is.

To resolve this, I created a new #define,
register_nmi_handler_initonly, that tags the struct as
__initdata to resolve the mismatch.  This #define should only be
used in rare situations where the register/unregister is called
during init of the kernel.

Big thanks to Jan Beulich for decoding this for me as I didn't
have a clue what was going on.

Reported-by: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
Tested-by: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
Cc: Jan Beulich <JBeulich@suse.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Link: http://lkml.kernel.org/r/1338991542-23000-1-git-send-email-dzickus@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/nmi.h     |   14 ++++++++++++++
 arch/x86/kernel/nmi_selftest.c |    4 ++--
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index 0e3793b..dc580c4 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -54,6 +54,20 @@ struct nmiaction {
 	__register_nmi_handler((t), &fn##_na);	\
 })
 
+/*
+ * For special handlers that register/unregister in the
+ * init section only.  This should be considered rare.
+ */
+#define register_nmi_handler_initonly(t, fn, fg, n)		\
+({							\
+	static struct nmiaction fn##_na __initdata = {		\
+		.handler = (fn),			\
+		.name = (n),				\
+		.flags = (fg),				\
+	};						\
+	__register_nmi_handler((t), &fn##_na);	\
+})
+
 int __register_nmi_handler(unsigned int, struct nmiaction *);
 
 void unregister_nmi_handler(unsigned int, const char *);
diff --git a/arch/x86/kernel/nmi_selftest.c b/arch/x86/kernel/nmi_selftest.c
index e31bf8d..149b8d9 100644
--- a/arch/x86/kernel/nmi_selftest.c
+++ b/arch/x86/kernel/nmi_selftest.c
@@ -42,7 +42,7 @@ static int __init nmi_unk_cb(unsigned int val, struct pt_regs *regs)
 static void __init init_nmi_testsuite(void)
 {
 	/* trap all the unknown NMIs we may generate */
-	register_nmi_handler(NMI_UNKNOWN, nmi_unk_cb, 0, "nmi_selftest_unk");
+	register_nmi_handler_initonly(NMI_UNKNOWN, nmi_unk_cb, 0, "nmi_selftest_unk");
 }
 
 static void __init cleanup_nmi_testsuite(void)
@@ -64,7 +64,7 @@ static void __init test_nmi_ipi(struct cpumask *mask)
 {
 	unsigned long timeout;
 
-	if (register_nmi_handler(NMI_LOCAL, test_nmi_ipi_callback,
+	if (register_nmi_handler_initonly(NMI_LOCAL, test_nmi_ipi_callback,
 				 NMI_FLAG_FIRST, "nmi_selftest")) {
 		nmi_fail = FAILURE;
 		return;

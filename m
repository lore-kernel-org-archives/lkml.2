Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab2FKPeI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 11:34:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753467Ab2FKPeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 11:34:06 -0400
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: baryluk@smp.if.uj.edu.pl, LKML <linux-kernel@vger.kernel.org>,
        JBeulich@suse.com, zhong@linux.vnet.ibm.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 1/2] Revert "x86/nmi: Fix section mismatch warnings on 32-bit"
Date: Mon, 11 Jun 2012 11:33:28 -0400
Message-Id: <1339428809-29360-2-git-send-email-dzickus@redhat.com>
In-Reply-To: <1339428809-29360-1-git-send-email-dzickus@redhat.com>
References: <1339428809-29360-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit eeaaa96a3a2134a174100afd129bb0891d05f4b2.

There is a cleaner/simpler way to achieve this.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/include/asm/nmi.h     |   14 --------------
 arch/x86/kernel/nmi_selftest.c |    4 ++--
 2 files changed, 2 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index dc580c4..0e3793b 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -54,20 +54,6 @@ struct nmiaction {
 	__register_nmi_handler((t), &fn##_na);	\
 })
 
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
-})
-
 int __register_nmi_handler(unsigned int, struct nmiaction *);
 
 void unregister_nmi_handler(unsigned int, const char *);
diff --git a/arch/x86/kernel/nmi_selftest.c b/arch/x86/kernel/nmi_selftest.c
index 149b8d9..e31bf8d 100644
--- a/arch/x86/kernel/nmi_selftest.c
+++ b/arch/x86/kernel/nmi_selftest.c
@@ -42,7 +42,7 @@ static int __init nmi_unk_cb(unsigned int val, struct pt_regs *regs)
 static void __init init_nmi_testsuite(void)
 {
 	/* trap all the unknown NMIs we may generate */
-	register_nmi_handler_initonly(NMI_UNKNOWN, nmi_unk_cb, 0, "nmi_selftest_unk");
+	register_nmi_handler(NMI_UNKNOWN, nmi_unk_cb, 0, "nmi_selftest_unk");
 }
 
 static void __init cleanup_nmi_testsuite(void)
@@ -64,7 +64,7 @@ static void __init test_nmi_ipi(struct cpumask *mask)
 {
 	unsigned long timeout;
 
-	if (register_nmi_handler_initonly(NMI_LOCAL, test_nmi_ipi_callback,
+	if (register_nmi_handler(NMI_LOCAL, test_nmi_ipi_callback,
 				 NMI_FLAG_FIRST, "nmi_selftest")) {
 		nmi_fail = FAILURE;
 		return;
-- 
1.7.7.6


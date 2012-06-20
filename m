Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403Ab2FTREv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 13:04:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38611 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131Ab2FTREt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 13:04:49 -0400
Date: Wed, 20 Jun 2012 10:04:29 -0700
From: tip-bot for Li Zhong <zhong@linux.vnet.ibm.com>
Message-ID: <tip-0718467c859f5571dc48d294596f841096f6a47a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, zhong@linux.vnet.ibm.com, hpa@zytor.com,
        mingo@kernel.org, JBeulich@suse.com, tglx@linutronix.de,
        dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, zhong@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, JBeulich@suse.com, tglx@linutronix.de,
        dzickus@redhat.com
In-Reply-To: <1340049393-17771-1-git-send-email-dzickus@redhat.com>
References: <1340049393-17771-1-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86/nmi: Clean up register_nmi_handler() usage
Git-Commit-ID: 0718467c859f5571dc48d294596f841096f6a47a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 20 Jun 2012 10:04:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0718467c859f5571dc48d294596f841096f6a47a
Gitweb:     http://git.kernel.org/tip/0718467c859f5571dc48d294596f841096f6a47a
Author:     Li Zhong <zhong@linux.vnet.ibm.com>
AuthorDate: Mon, 18 Jun 2012 15:56:33 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 20 Jun 2012 14:23:17 +0200

x86/nmi: Clean up register_nmi_handler() usage

Implement a cleaner and easier to maintain version for the section
warning fixes implemented in commit eeaaa96a3a21
("x86/nmi: Fix section mismatch warnings on 32-bit").

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Jan Beulich <JBeulich@suse.com>
Link: http://lkml.kernel.org/r/1340049393-17771-1-git-send-email-dzickus@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/nmi.h     |   20 +++-----------------
 arch/x86/kernel/nmi_selftest.c |    7 ++++---
 2 files changed, 7 insertions(+), 20 deletions(-)

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

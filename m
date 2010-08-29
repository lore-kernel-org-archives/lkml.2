Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab0H2Swo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 14:52:44 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35477 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753942Ab0H2Swk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 14:52:40 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Will Deacon <will.deacon@arm.com>,
        Robert Richter <robert.richter@amd.com>,
        Matt Fleming <matt@console-pimps.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 3/3] x86: oprofile: fix oprofile_arch_init behaviour on failure
Date: Sun, 29 Aug 2010 19:52:01 +0100
Message-Id: <1283107921-21464-4-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1283107921-21464-3-git-send-email-will.deacon@arm.com>
References: <1283107921-21464-1-git-send-email-will.deacon@arm.com>
 <1283107921-21464-2-git-send-email-will.deacon@arm.com>
 <1283107921-21464-3-git-send-email-will.deacon@arm.com>
X-OriginalArrivalTime: 29 Aug 2010 18:52:18.0595 (UTC) FILETIME=[4E20E730:01CB47AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The OProfile driver no longer calls oprofile_arch_exit when
oprofile_arch_init return failure.

This patch fixes the x86 implementation of oprofile_arch_init
to ensure that op_nmi_exit is called if necessary.

Cc: Robert Richter <robert.richter@amd.com>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 arch/x86/oprofile/init.c |   26 +++++++++++++++-----------
 1 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/arch/x86/oprofile/init.c b/arch/x86/oprofile/init.c
index cdfe4c5..886b2c4 100644
--- a/arch/x86/oprofile/init.c
+++ b/arch/x86/oprofile/init.c
@@ -16,34 +16,38 @@
  * with the NMI mode driver.
  */
 
+#ifdef CONFIG_X86_LOCAL_APIC
 extern int op_nmi_init(struct oprofile_operations *ops);
-extern int op_nmi_timer_init(struct oprofile_operations *ops);
 extern void op_nmi_exit(void);
-extern void x86_backtrace(struct pt_regs * const regs, unsigned int depth);
+#else
+static int op_nmi_init(struct oprofile_operations *ops) { return -ENODEV; }
+static void op_nmi_exit(void) {}
+#endif
 
+extern int op_nmi_timer_init(struct oprofile_operations *ops);
+extern void x86_backtrace(struct pt_regs * const regs, unsigned int depth);
 
 int __init oprofile_arch_init(struct oprofile_operations *ops)
 {
 	int ret;
 
-	ret = -ENODEV;
-
-#ifdef CONFIG_X86_LOCAL_APIC
 	ret = op_nmi_init(ops);
-#endif
-#ifdef CONFIG_X86_IO_APIC
 	if (ret < 0)
+#ifdef CONFIG_X86_IO_APIC
 		ret = op_nmi_timer_init(ops);
+#else
+		return ret;
 #endif
+
 	ops->backtrace = x86_backtrace;
 
+	if (ret < 0)
+		op_nmi_exit();
+
 	return ret;
 }
 
-
-void oprofile_arch_exit(void)
+void __exit oprofile_arch_exit(void)
 {
-#ifdef CONFIG_X86_LOCAL_APIC
 	op_nmi_exit();
-#endif
 }
-- 
1.6.3.3


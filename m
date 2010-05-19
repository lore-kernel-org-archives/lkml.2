Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757818Ab0ESBn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 21:43:26 -0400
Received: from mail.windriver.com ([147.11.1.11]:41208 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756887Ab0ESBkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 21:40:20 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 05/25] kgdb,sh: update superh kgdb exception handling
Date: Tue, 18 May 2010 20:39:15 -0500
Message-Id: <1274233175-3675-6-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1274233175-3675-1-git-send-email-jason.wessel@windriver.com>
References: <1274233175-3675-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 19 May 2010 01:39:45.0078 (UTC) FILETIME=[28D1ED60:01CAF6F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement kgdb_arch_pc() which adjusts the pc if it needs to be
adjusted after a software breakpoint trap.

Implement kgdb_arch_set_pc() which is a new required function in the
kgdb debug core.

When processing a single step return zero in the error exception field
so that the debug core can distinguish between a single step trap and
a breakpoint trap generically.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Acked-by: Paul Mundt <lethal@linux-sh.org>
---
 arch/sh/kernel/kgdb.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/arch/sh/kernel/kgdb.c b/arch/sh/kernel/kgdb.c
index 70c6965..efb6d39 100644
--- a/arch/sh/kernel/kgdb.c
+++ b/arch/sh/kernel/kgdb.c
@@ -237,6 +237,18 @@ int kgdb_arch_handle_exception(int e_vector, int signo, int err_code,
 	return -1;
 }
 
+unsigned long kgdb_arch_pc(int exception, struct pt_regs *regs)
+{
+	if (exception == 60)
+		return instruction_pointer(regs) - 2;
+	return instruction_pointer(regs);
+}
+
+void kgdb_arch_set_pc(struct pt_regs *regs, unsigned long ip)
+{
+	regs->pc = ip;
+}
+
 /*
  * The primary entry points for the kgdb debug trap table entries.
  */
@@ -247,7 +259,7 @@ BUILD_TRAP_HANDLER(singlestep)
 
 	local_irq_save(flags);
 	regs->pc -= instruction_size(__raw_readw(regs->pc - 4));
-	kgdb_handle_exception(vec >> 2, SIGTRAP, 0, regs);
+	kgdb_handle_exception(0, SIGTRAP, 0, regs);
 	local_irq_restore(flags);
 }
 
-- 
1.6.3.3


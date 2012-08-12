Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335Ab2HLMSS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 08:18:18 -0400
Received: from mail.windriver.com ([147.11.1.11]:47739 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab2HLMRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 08:17:21 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <kgdb-bugreport@lists.sourceforge.net>,
        Jason Wessel <jason.wessel@windriver.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 1/4] mips,kgdb: fix recursive page fault with CONFIG_KPROBES
Date: Sun, 12 Aug 2012 07:16:42 -0500
Message-ID: <1344773805-12844-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fault was detected using the kgdb test suite on boot and it
crashes recursively due to the fact that CONFIG_KPROBES on mips adds
an extra die notifier in the page fault handler.  The crash signature
looks like this:

kgdbts:RUN bad memory access test
KGDB: re-enter exception: ALL breakpoints killed
Call Trace:
[<807b7548>] dump_stack+0x20/0x54
[<807b7548>] dump_stack+0x20/0x54

The fix for now is to have kgdb return immediately if the fault type
is DIE_PAGE_FAULT and allow the kprobe code to decide what is supposed
to happen.

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/mips/kernel/kgdb.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/mips/kernel/kgdb.c b/arch/mips/kernel/kgdb.c
index f4546e9..23817a6 100644
--- a/arch/mips/kernel/kgdb.c
+++ b/arch/mips/kernel/kgdb.c
@@ -283,6 +283,15 @@ static int kgdb_mips_notify(struct notifier_block *self, unsigned long cmd,
 	struct pt_regs *regs = args->regs;
 	int trap = (regs->cp0_cause & 0x7c) >> 2;
 
+#ifdef CONFIG_KPROBES
+	/*
+	 * Return immediately if the kprobes fault notifier has set
+	 * DIE_PAGE_FAULT.
+	 */
+	if (cmd == DIE_PAGE_FAULT)
+		return NOTIFY_DONE;
+#endif /* CONFIG_KPROBES */
+
 	/* Userspace events, ignore. */
 	if (user_mode(regs))
 		return NOTIFY_DONE;
-- 
1.7.9.5


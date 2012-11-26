Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446Ab2KZSIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 13:08:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47360 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932337Ab2KZREL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:04:11 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Wessel <jason.wessel@windriver.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 070/270] mips,kgdb: fix recursive page fault with CONFIG_KPROBES
Date: Mon, 26 Nov 2012 14:56:00 -0200
Message-Id: <1353949160-26803-71-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wessel <jason.wessel@windriver.com>

commit f0a996eeeda214f4293e234df33b29bec003b536 upstream.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
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


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075Ab2J1X2i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:28:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42177 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756983Ab2J1X2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:28:24 -0400
Message-Id: <20121028231550.069142455@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:16:18 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jason Wessel <jason.wessel@windriver.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 042/105] mips,kgdb: fix recursive page fault with CONFIG_KPROBES
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/mips/kernel/kgdb.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/arch/mips/kernel/kgdb.c
+++ b/arch/mips/kernel/kgdb.c
@@ -283,6 +283,15 @@ static int kgdb_mips_notify(struct notif
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



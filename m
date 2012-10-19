Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab2JSCq6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 22:46:58 -0400
Received: from mail.kernel.org ([198.145.19.201]:51051 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752238Ab2JSCq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:46:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jason Wessel <jason.wessel@windriver.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 09/62] mips,kgdb: fix recursive page fault with CONFIG_KPROBES
Date: Thu, 18 Oct 2012 19:44:37 -0700
Message-Id: <20121019024257.445873324@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024255.944999470@linuxfoundation.org>
References: <20121019024255.944999470@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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



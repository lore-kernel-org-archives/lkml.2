Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336Ab2FFPN4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:13:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39813 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab2FFPNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:13:54 -0400
Date: Wed, 6 Jun 2012 08:12:40 -0700
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Message-ID: <tip-27e471e0846354376d180c2d2911ec9b94f1e28f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, ananth@in.ibm.com,
        anton@redhat.com, masami.hiramatsu.pt@hitachi.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, ananth@in.ibm.com,
        anton@redhat.com, masami.hiramatsu.pt@hitachi.com,
        srikar@linux.vnet.ibm.com, oleg@redhat.com, tglx@linutronix.de
In-Reply-To: <20120529192947.GF8057@redhat.com>
References: <20120529192947.GF8057@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] uprobes: Teach handle_swbp()
  to rely on %22is_swbp%22 rather than uprobes_srcu
Git-Commit-ID: 27e471e0846354376d180c2d2911ec9b94f1e28f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 08:12:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  27e471e0846354376d180c2d2911ec9b94f1e28f
Gitweb:     http://git.kernel.org/tip/27e471e0846354376d180c2d2911ec9b94f1e28f
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Tue, 29 May 2012 21:29:47 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Jun 2012 11:30:57 +0200

uprobes: Teach handle_swbp() to rely on %22is_swbp%22 rather than uprobes_srcu

Currently handle_swbp() assumes that it can't race with
unregister, so it roughly does:

	if (find_uprobe(vaddr))
		process_uprobe();
	else
		send_sig(SIGTRAP);

This relies on the not-really-working uprobes_srcu code we are
going to remove, see the next patch.

With this patch we rely on the result of
is_swbp_at_addr(bp_vaddr) if find_uprobe() fails.

If is_swbp == 1, then we hit the normal int3, we should send
SIGTRAP.

If is_swbp == 0, we raced with uprobe_unregister(), we simply
restart this insn again.

The "difficult" case is is_swbp == -EFAULT, when we can't read
this memory. In this case I think we should restart too, and
this is more correct compared to the current code which sends
SIGTRAP.

Ignoring ENOMEM/etc from get_user_pages(), this can only happen
if another thread unmaps this memory before find_active_uprobe()
takes mmap_sem. It would be better to pretend it was unmapped
before this insn was executed, restart, and get SIGSEGV.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anton Arapov <anton@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20120529192947.GF8057@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/uprobes.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index a2ed82b..1f02e3b 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1530,14 +1530,26 @@ static void handle_swbp(struct pt_regs *regs)
 	struct uprobe_task *utask;
 	struct uprobe *uprobe;
 	unsigned long bp_vaddr;
-	int is_swbp;
+	int uninitialized_var(is_swbp);
 
 	bp_vaddr = uprobe_get_swbp_addr(regs);
 	uprobe = find_active_uprobe(bp_vaddr, &is_swbp);
 
 	if (!uprobe) {
-		/* No matching uprobe; signal SIGTRAP. */
-		send_sig(SIGTRAP, current, 0);
+		if (is_swbp > 0) {
+			/* No matching uprobe; signal SIGTRAP. */
+			send_sig(SIGTRAP, current, 0);
+		} else {
+			/*
+			 * Either we raced with uprobe_unregister() or we can't
+			 * access this memory. The latter is only possible if
+			 * another thread plays with our ->mm. In both cases
+			 * we can simply restart. If this vma was unmapped we
+			 * can pretend this insn was not executed yet and get
+			 * the (correct) SIGSEGV after restart.
+			 */
+			instruction_pointer_set(regs, bp_vaddr);
+		}
 		return;
 	}
 

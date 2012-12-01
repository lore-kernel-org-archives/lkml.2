Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037Ab2LAL0i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 06:26:38 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56898 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab2LAL0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 06:26:37 -0500
Date: Sat, 1 Dec 2012 12:26:32 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] RCU fix
Message-ID: <20121201112632.GA18766@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-urgent-for-linus

   HEAD: 745040347d7e8e7b47e3790de76423d9eab474eb Merge branch 'rcu/urgent' of git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu into core/urgent

Fix leaking RCU extended quiescent state, which might trigger 
warnings and mess up the extended quiescent state tracking logic 
into thinking that we are in "RCU user mode" while we aren't.

 Thanks,

	Ingo

------------------>
Frederic Weisbecker (1):
      rcu: Fix unrecovered RCU user mode in syscall_trace_leave()


 arch/x86/kernel/ptrace.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index b00b33a..eff5b8c 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1511,6 +1511,13 @@ void syscall_trace_leave(struct pt_regs *regs)
 {
 	bool step;
 
+	/*
+	 * We may come here right after calling schedule_user()
+	 * or do_notify_resume(), in which case we can be in RCU
+	 * user mode.
+	 */
+	rcu_user_exit();
+
 	audit_syscall_exit(regs);
 
 	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))

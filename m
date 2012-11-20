Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab2KTRHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 12:07:00 -0500
Received: from www.linutronix.de ([62.245.132.108]:57448 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab2KTRG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 12:06:59 -0500
Date: Tue, 20 Nov 2012 18:06:55 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] core fixes for 3.7
Message-ID: <alpine.LFD.2.02.1211201805550.2701@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest core-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-urgent-for-linus

* One line fix, which plugs a rcu_user leak.

Thanks,

	tglx

------------------>
Frederic Weisbecker (1):
      rcu: Fix unrecovered RCU user mode in syscall_trace_leave()


 arch/x86/kernel/ptrace.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

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

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063Ab1DZUiL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 16:38:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754901Ab1DZUiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 16:38:09 -0400
Date: Tue, 26 Apr 2011 22:37:11 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Matt Fleming <matt@console-pimps.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@linux.intel.com>
Subject: [PATCH 1/1] tile: do_hardwall_trap: do not play with task->sighand
Message-ID: <20110426203711.GB10177@redhat.com>
References: <1302031310-1765-1-git-send-email-matt@console-pimps.org> <1302031310-1765-3-git-send-email-matt@console-pimps.org> <20110413194231.GA15330@redhat.com> <20110414113456.5182a582@mfleming-mobl1.ger.corp.intel.com> <20110414190012.GA23517@redhat.com> <20110416140813.5c90b1fc@mfleming-mobl1.ger.corp.intel.com> <20110418164513.GA25930@redhat.com> <20110421190332.GA2570@redhat.com> <4DB17CDE.3050603@tilera.com> <20110426203644.GA10177@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110426203644.GA10177@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. do_hardwall_trap() checks ->sighand != NULL and then takes ->siglock.

   This is unsafe even if the task can't run (I assume it is pinned to
   the same CPU), its parent can reap the task and set ->sighand = NULL
   right after this check. Even if the compiler dosn't read ->sighand
   twice and this memory can't to away __group_send_sig_info() is wrong
   after that. Use do_send_sig_info().

2. Send SIGILL to the thread, not to the whole process. Unless it has
   the handler or blocked this kills the whole thread-group as before.
   IIUC, different threads can be bound to different rect's.

3. Check PF_EXITING instead of ->sighand. A zombie thread can go away
   but its ->sighand can be !NULL.

Reported-by: Matt Fleming <matt@console-pimps.org>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 arch/tile/kernel/hardwall.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- sigprocmask/arch/tile/kernel/hardwall.c~1_sighand	2011-04-06 21:33:42.000000000 +0200
+++ sigprocmask/arch/tile/kernel/hardwall.c	2011-04-21 20:56:36.000000000 +0200
@@ -268,12 +268,10 @@ void __kprobes do_hardwall_trap(struct p
 	found_processes = 0;
 	list_for_each_entry(p, &rect->task_head, thread.hardwall_list) {
 		BUG_ON(p->thread.hardwall != rect);
-		if (p->sighand) {
+		if (!(p->flags & PF_EXITING)) {
 			found_processes = 1;
 			pr_notice("hardwall: killing %d\n", p->pid);
-			spin_lock(&p->sighand->siglock);
-			__group_send_sig_info(info.si_signo, &info, p);
-			spin_unlock(&p->sighand->siglock);
+			do_send_sig_info(info.si_signo, &info, p, false);
 		}
 	}
 	if (!found_processes)


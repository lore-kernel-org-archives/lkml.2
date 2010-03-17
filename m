Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992Ab0CQTau (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 15:30:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755702Ab0CQTaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 15:30:17 -0400
Date: Wed, 17 Mar 2010 20:28:54 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, Veaceslav Falico <vfalico@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] exit: change zap_other_threads() to count sub-threads
Message-ID: <20100317192854.GA2097@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change zap_other_threads() to return the number of other sub-threads
found on ->thread_group list.

Other changes are cosmetic:

	- change the code to use while_each_thread() helper

	- remove the obsolete comment about SIGKILL/SIGSTOP

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/sched.h |    2 +-
 kernel/signal.c       |   17 +++++++++--------
 2 files changed, 10 insertions(+), 9 deletions(-)

--- 34-rc1/include/linux/sched.h~2_ZAP_COUNT_THREADS	2010-03-17 19:10:28.000000000 +0100
+++ 34-rc1/include/linux/sched.h	2010-03-17 19:20:11.000000000 +0100
@@ -2035,7 +2035,7 @@ extern int do_notify_parent(struct task_
 extern void __wake_up_parent(struct task_struct *p, struct task_struct *parent);
 extern void force_sig(int, struct task_struct *);
 extern int send_sig(int, struct task_struct *, int);
-extern void zap_other_threads(struct task_struct *p);
+extern int zap_other_threads(struct task_struct *p);
 extern struct sigqueue *sigqueue_alloc(void);
 extern void sigqueue_free(struct sigqueue *);
 extern int send_sigqueue(struct sigqueue *,  struct task_struct *, int group);
--- 34-rc1/kernel/signal.c~2_ZAP_COUNT_THREADS	2010-03-17 19:10:28.000000000 +0100
+++ 34-rc1/kernel/signal.c	2010-03-17 19:20:11.000000000 +0100
@@ -1083,23 +1083,24 @@ force_sig_info(int sig, struct siginfo *
 /*
  * Nuke all other threads in the group.
  */
-void zap_other_threads(struct task_struct *p)
+int zap_other_threads(struct task_struct *p)
 {
-	struct task_struct *t;
+	struct task_struct *t = p;
+	int count = 0;
 
 	p->signal->group_stop_count = 0;
 
-	for (t = next_thread(p); t != p; t = next_thread(t)) {
-		/*
-		 * Don't bother with already dead threads
-		 */
+	while_each_thread(p, t) {
+		count++;
+
+		/* Don't bother with already dead threads */
 		if (t->exit_state)
 			continue;
-
-		/* SIGKILL will be handled before any pending SIGSTOP */
 		sigaddset(&t->pending.signal, SIGKILL);
 		signal_wake_up(t, 1);
 	}
+
+	return count;
 }
 
 struct sighand_struct *lock_task_sighand(struct task_struct *tsk, unsigned long *flags)


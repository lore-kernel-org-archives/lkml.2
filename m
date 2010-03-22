Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869Ab0CVSnE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 14:43:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755723Ab0CVSm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 14:42:58 -0400
Date: Mon, 22 Mar 2010 19:41:33 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm 2/3] proc: make collect_sigign_sigcatch() rcu-safe
Message-ID: <20100322184133.GA3964@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make collect_sigign_sigcatch() rcu-safe. The necessary changes are simple,
use rcu_dereference() to get ->sighand and check it is not NULL.

In theory, this ->sighand can be re-used under us (but it can't go away).
We could check task->sighand == sighand once again after the main loop
to prevent the race with exit/exec, but I don't think this is really
needed for fs/proc.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 fs/proc/array.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- 34-rc1/fs/proc/array.c~PROC_2_SIGCATCH_RCU	2010-03-22 17:04:44.000000000 +0100
+++ 34-rc1/fs/proc/array.c	2010-03-22 17:39:42.000000000 +0100
@@ -235,13 +235,18 @@ static void render_sigset_t(struct seq_f
 	seq_printf(m, "\n");
 }
 
+/* needs ->siglock or rcu_read_lock() */
 static void collect_sigign_sigcatch(struct task_struct *p, sigset_t *ign,
 				    sigset_t *catch)
 {
+	struct sighand_struct *sighand = rcu_dereference(p->sighand);
 	struct k_sigaction *k;
 	int i;
 
-	k = p->sighand->action;
+	if (unlikely(!sighand))
+		return;
+
+	k = sighand->action;
 	for (i = 1; i <= _NSIG; ++i, ++k) {
 		if (k->sa.sa_handler == SIG_IGN)
 			sigaddset(ign, i);


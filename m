Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128Ab2LXIPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 03:15:37 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:4586 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993Ab2LXIPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 03:15:33 -0500
From: Andrey Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: criu@openvz.org, linux-fsdevel@vger.kernel.org,
        Andrey Vagin <avagin@openvz.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [PATCH 2/4] signal: add a helper for dequeuing signals from a specified queue
Date: Mon, 24 Dec 2012 12:13:25 +0400
Message-Id: <1356336807-5517-3-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1356336807-5517-1-git-send-email-avagin@openvz.org>
References: <1356336807-5517-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Pavel Emelyanov <xemul@parallels.com>
CC: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 include/linux/sched.h |  9 ++++++++-
 kernel/signal.c       | 13 +++++++++----
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0dd42a0..de9a4bf 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2159,7 +2159,14 @@ extern void flush_signals(struct task_struct *);
 extern void __flush_signals(struct task_struct *);
 extern void ignore_signals(struct task_struct *);
 extern void flush_signal_handlers(struct task_struct *, int force_default);
-extern int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info);
+extern int do_dequeue_signal(struct task_struct *tsk,
+				sigset_t *mask, siginfo_t *info, int queue);
+
+static inline int dequeue_signal(struct task_struct *tsk,
+					sigset_t *mask, siginfo_t *info)
+{
+	return do_dequeue_signal(tsk, mask, info, 0);
+}
 
 static inline int dequeue_signal_lock(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
 {
diff --git a/kernel/signal.c b/kernel/signal.c
index 0af8868..91bb76f2 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -597,17 +597,22 @@ static int __dequeue_signal(struct sigpending *pending, sigset_t *mask,
  * Dequeue a signal and return the element to the caller, which is
  * expected to free it.
  *
+ * @queue: dequeue from a private queue, if a value is not positive
+ *	   dequeue from a shared queue, if a value if not negative
+ *
  * All callers have to hold the siglock.
  */
-int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
+int do_dequeue_signal(struct task_struct *tsk, sigset_t *mask,
+					siginfo_t *info, int queue)
 {
-	int signr;
+	int signr = 0;
 
 	/* We only dequeue private signals from ourselves, we don't let
 	 * signalfd steal them
 	 */
-	signr = __dequeue_signal(&tsk->pending, mask, info);
-	if (!signr) {
+	if (queue <= 0)
+		signr = __dequeue_signal(&tsk->pending, mask, info);
+	if (!signr && queue >= 0) {
 		signr = __dequeue_signal(&tsk->signal->shared_pending,
 					 mask, info);
 		/*
-- 
1.7.11.7


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957Ab0IYJVo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 05:21:44 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:40842 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448Ab0IYJVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 05:21:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=T07GNTJ6fVxP5gQwCgg36kaPFRpOYquhmgC7RR/XbKOd3qYQ0uPglKXV07eefxd5un
         +qWYTvIT/43rQk6wZvVHORqEYqsB4/KMo2cNPWsIsFVZyN14qvUx4oxpvlHal9YzOI8+
         k+HQ+XDkIK23fTIht0TKoucuwi8r0jbzv+d6s=
From: Namhyung Kim <namhyung@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] signal: annotate siglock acquisition
Date: Sat, 25 Sep 2010 18:21:35 +0900
Message-Id: <1285406495-20080-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lock_task_sighand() conditionally acquires sighand->siglock in case of
returning non-NULL but unlock_task_sighand() releases it unconditionally.
This leads sparse to complain about the lock context imbalance. Annotate it
to make sparse happier.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 kernel/signal.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index bded651..85c1efd 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1037,7 +1037,7 @@ int do_send_sig_info(int sig, struct siginfo *info, struct task_struct *p,
 	unsigned long flags;
 	int ret = -ESRCH;
 
-	if (lock_task_sighand(p, &flags)) {
+	if (__cond_lock(&p->sighand->siglock, lock_task_sighand(p, &flags))) {
 		ret = send_signal(sig, info, p, group);
 		unlock_task_sighand(p, &flags);
 	}
@@ -1226,7 +1226,8 @@ int kill_pid_info_as_uid(int sig, struct siginfo *info, struct pid *pid,
 		goto out_unlock;
 
 	if (sig) {
-		if (lock_task_sighand(p, &flags)) {
+		if (__cond_lock(&p->sighand->siglock,
+				lock_task_sighand(p, &flags))) {
 			ret = __send_signal(sig, info, p, 1, 0);
 			unlock_task_sighand(p, &flags);
 		} else
@@ -1403,7 +1404,9 @@ int send_sigqueue(struct sigqueue *q, struct task_struct *t, int group)
 	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
 
 	ret = -1;
-	if (!likely(lock_task_sighand(t, &flags)))
+	if (likely(lock_task_sighand(t, &flags)))
+		__acquire(&t->sighand->siglock);
+	else
 		goto ret;
 
 	ret = 1; /* the signal is ignored */
-- 
1.7.2.2


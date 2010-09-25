Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab0IYDVI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 23:21:08 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64638 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab0IYDVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 23:21:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=p4zaENyDdlmmySzpQtAV8hFq3p04CR2+2qbtOQGpdXdvCpzBL7kayD1NTNn0pSoSKg
         TaKdHebwn6gd86OUQqk/sm46UVdWSqThN9Jb6iLqCDwgHVY3ic9Cs/y3CgOV1fKj6gFA
         HI6fH45zjle2W5YAnKtwkIoSiKGD9dns5hTno=
From: Namhyung Kim <namhyung@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] signal: annotate siglock acquisition
Date: Sat, 25 Sep 2010 12:20:56 +0900
Message-Id: <1285384856-4310-1-git-send-email-namhyung@gmail.com>
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
 kernel/signal.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index bded651..766ae03 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1038,6 +1038,7 @@ int do_send_sig_info(int sig, struct siginfo *info, struct task_struct *p,
 	int ret = -ESRCH;
 
 	if (lock_task_sighand(p, &flags)) {
+		__acquire(&p->sighand->siglock);  /* make sparse happy */
 		ret = send_signal(sig, info, p, group);
 		unlock_task_sighand(p, &flags);
 	}
@@ -1227,6 +1228,7 @@ int kill_pid_info_as_uid(int sig, struct siginfo *info, struct pid *pid,
 
 	if (sig) {
 		if (lock_task_sighand(p, &flags)) {
+			__acquire(&p->sighand->siglock);
 			ret = __send_signal(sig, info, p, 1, 0);
 			unlock_task_sighand(p, &flags);
 		} else
@@ -1406,6 +1408,8 @@ int send_sigqueue(struct sigqueue *q, struct task_struct *t, int group)
 	if (!likely(lock_task_sighand(t, &flags)))
 		goto ret;
 
+	__acquire(&t->sighand->siglock); /* make sparse happy */
+
 	ret = 1; /* the signal is ignored */
 	if (!prepare_signal(sig, t, 0))
 		goto out;
-- 
1.7.2.2


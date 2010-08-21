Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218Ab0HUPRs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 11:17:48 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57299 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab0HUPRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 11:17:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=i4mtNdgK2S8mHLsUJB/XHEQsGotYgonDth7EHt0VjciPFJFaJqj3TNArAuuBHAdxOA
         Zkqehn3aG784USGilwu97BuPdKj+4MNdtRAzWAk/SfmClIgJlTsH6bfQ28VXxDnTBh7H
         feaojCGsU1o8bTB6KAdbfUNmtDTEVu0Qg+nQ4=
From: Namhyung Kim <namhyung@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] signals: annotate siglock acquirement
Date: Sun, 22 Aug 2010 00:17:38 +0900
Message-Id: <1282403858-17117-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lock_task_sighand() conditionally acquires sighand->siglock in case of
returning non-NULL but unlock_task_sighand() releases it unconditionally.
This leads sparse to complain about the lock context imbalance. Annotate it
to make sparse happier.

Impact: remove sparse warnings, no runtime overhead.
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 kernel/signal.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index bded651..c423fc5 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1038,6 +1038,7 @@ int do_send_sig_info(int sig, struct siginfo *info, struct task_struct *p,
 	int ret = -ESRCH;
 
 	if (lock_task_sighand(p, &flags)) {
+		__acquire(&p->sighand->siglock);
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
 
+	__acquire(&t->sighand->siglock);
+
 	ret = 1; /* the signal is ignored */
 	if (!prepare_signal(sig, t, 0))
 		goto out;
-- 
1.7.0.4


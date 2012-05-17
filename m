Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933474Ab2EQVag (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 17:30:36 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60914 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760532Ab2EQVaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 17:30:35 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: oleg@redhat.com, akpm@linux-foundation.org, ebiederm@xmission.com
Cc: linux-kernel@vger.kernel.org, davej@redhat.com,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH] cred: use correct cred accessor with regards to rcu read lock
Date: Thu, 17 May 2012 23:31:39 +0200
Message-Id: <1337290299-11057-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit "userns: Convert setting and getting uid and gid system calls to use
kuid and kgid has modified the accessors in wait_task_continued() and
wait_task_stopped() to use __task_cred() instead of task_uid().

__task_cred() assumes that we're inside a rcu read lock, which is untrue
for these two functions.

Modify it to use task_uid() instead.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 kernel/exit.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 6818cbb..7e54635 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1455,7 +1455,7 @@ static int wait_task_stopped(struct wait_opts *wo,
 	if (!unlikely(wo->wo_flags & WNOWAIT))
 		*p_code = 0;
 
-	uid = from_kuid_munged(current_user_ns(), __task_cred(p)->uid);
+	uid = from_kuid_munged(current_user_ns(), task_uid(p));
 unlock_sig:
 	spin_unlock_irq(&p->sighand->siglock);
 	if (!exit_code)
@@ -1528,7 +1528,7 @@ static int wait_task_continued(struct wait_opts *wo, struct task_struct *p)
 	}
 	if (!unlikely(wo->wo_flags & WNOWAIT))
 		p->signal->flags &= ~SIGNAL_STOP_CONTINUED;
-	uid = from_kuid_munged(current_user_ns(), __task_cred(p)->uid);
+	uid = from_kuid_munged(current_user_ns(), task_uid(p));
 	spin_unlock_irq(&p->sighand->siglock);
 
 	pid = task_pid_vnr(p);
-- 
1.7.8.6


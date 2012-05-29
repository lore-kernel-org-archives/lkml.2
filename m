Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742Ab2E2W73 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 18:59:29 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:56821 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab2E2W71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 18:59:27 -0400
From: Filipe Brandenburger <filbranden@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Filipe Brandenburger <filbranden@gmail.com>
Subject: [PATCH 1/1] prctl: pdeath_signal sent when parent thread (instead of parent process) dies
Date: Tue, 29 May 2012 18:59:08 -0400
Message-Id: <1338332348-3469-1-git-send-email-filbranden@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a case where a child process uses prctl(PR_SET_PDEATHSIG, signo) to
request that it is sent a signal when the parent process dies, if that
child process was forked by a thread of a multi-threaded process, then
it will receive the signal when the thread terminates, when in fact it
is interested on whether the parent process died instead.

When a process is forked, it is added to the children to the task_struct
that forked it, so that will be the thread that did it. When the thread
terminates, forget_original_parent() will reparent the children by
assigning them a new reaper. In the case of a multi-threaded process,
the new reaper will be another thread in the same thread group.

The patch just adds another check to the case where pdeath_signal is set
in forget_original_parent() to verify whether the tgid of the original
and new parent process are the same and to skip sending the signal in
that particular case.

For more discussion and test cases executed:
https://bugzilla.kernel.org/show_bug.cgi?id=43300

Signed-off-by: Filipe Brandenburger <filbranden@gmail.com>
---
 kernel/exit.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 910a071..ed439cd 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -806,7 +806,8 @@ static void forget_original_parent(struct task_struct *father)
 				BUG_ON(t->ptrace);
 				t->parent = t->real_parent;
 			}
-			if (t->pdeath_signal)
+			if (t->pdeath_signal &&
+			    !same_thread_group(father, reaper))
 				group_send_sig_info(t->pdeath_signal,
 						    SEND_SIG_NOINFO, t);
 		} while_each_thread(p, t);
-- 
1.7.7.6


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759458Ab1LOThD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 14:37:03 -0500
Received: from mail-gy0-f202.google.com ([209.85.160.202]:60978 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756537Ab1LOThA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 14:37:00 -0500
From: Mandeep Singh Baines <msb@chromium.org>
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org
Cc: Mandeep Singh Baines <msb@chromium.org>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, stable@kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>, Olof Johansson <olofj@chromium.org>
Subject: [PATCH] cgroups: fix a css_set not found bug in cgroup_attach_proc
Date: Thu, 15 Dec 2011 11:36:43 -0800
Message-Id: <1323977803-5385-1-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a BUG when migrating a PF_EXITING proc. Since css_set_prefetch()
is not called for the PF_EXITING case, find_existing_css_set() will return
NULL inside cgroup_task_migrate() causing a BUG.

This bug is easy to reproduce. Create a zombie and echo its pid to
cgroup.procs.

$ cat zombie.c
\#include <unistd.h>

int main()
{
  if (fork())
      pause();
  return 0;
}
$

We are hitting this bug pretty regularly on ChromeOS.

This bug is already fixed by Tejun Heo's cgroup patchset which is
targetted for the next merge window:

https://lkml.org/lkml/2011/11/1/356

I've create a smaller patch here which just fixes this bug so that a
fix can be merged into the current release and stable.

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Downstream-Bug-Report: http://crosbug.com/23953
Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: containers@lists.linux-foundation.org
Cc: cgroups@vger.kernel.org
Cc: stable@kernel.org
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Menage <paul@paulmenage.org>
Cc: Olof Johansson <olofj@chromium.org>
---
 kernel/cgroup.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index d9d5648..a184470 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2098,11 +2098,6 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 			continue;
 		/* get old css_set pointer */
 		task_lock(tsk);
-		if (tsk->flags & PF_EXITING) {
-			/* ignore this task if it's going away */
-			task_unlock(tsk);
-			continue;
-		}
 		oldcg = tsk->cgroups;
 		get_css_set(oldcg);
 		task_unlock(tsk);
-- 
1.7.3.1


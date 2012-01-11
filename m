Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933028Ab2AKKoc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 05:44:32 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:42618 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932584Ab2AKKo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 05:44:28 -0500
From: Xiaotian Feng <xtfeng@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Xiaotian Feng <xtfeng@gmail.com>, Xiaotian Feng <dannyfeng@tencent.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Stephen Wilson <wilsons@start.ca>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH] proc: fix null pointer deref in proc_pid_permission()
Date: Wed, 11 Jan 2012 13:47:05 -0500
Message-Id: <1326307625-11561-1-git-send-email-xtfeng@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_proc_task() can fail to search the task and return NULL, put_task_struct()
will then bomb the kernel with following oops:

[ 1870.574045] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
[ 1870.574065] IP: [<ffffffff81217d34>] proc_pid_permission+0x64/0xe0
[ 1870.574088] PGD 112075067 PUD 112814067 PMD 0
[ 1870.574106] Oops: 0002 [#1] PREEMPT SMP

This is a regression introduced by commit 0499680a, kernel should
return -ESRCH if get_proc_task() failed.

Signed-off-by: Xiaotian Feng <dannyfeng@tencent.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: Stephen Wilson <wilsons@start.ca>
Cc: David Rientjes <rientjes@google.com>
---
 fs/proc/base.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 8173dfd..5485a53 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -654,6 +654,8 @@ static int proc_pid_permission(struct inode *inode, int mask)
 	bool has_perms;
 
 	task = get_proc_task(inode);
+	if (!task)
+		return -ESRCH;
 	has_perms = has_pid_permissions(pid, task, 1);
 	put_task_struct(task);
 
-- 
1.7.5.4


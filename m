Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab1CEI25 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 03:28:57 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44326 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab1CEI24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 03:28:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=EvBa1fND5ZqzG6CfGjL7D50DMsV+zhk8K0XAtidIHgwk+kuttwyL0HdlOwT5qg9/K0
         XCaosplcrku4N400q1uzZh74Qb06u1xP3QQZlyX9ZKpVUZV9my6qHQCH4mGZL+6HC3Ab
         0UWr9oAdePkapmPrCmjli3XMtyVT0YUJ1yLMg=
From: bookjovi@gmail.com
To: bookjovi@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org> (commit_signer:17/41=41%),
        Al Viro <viro@zeniv.linux.org.uk> (commit_signer:7/41=17%),
        David Rientjes <rientjes@google.com> (commit_signer:7/41=17%),
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> (commit_signer:4/41=10%),
        Nick Piggin <npiggin@kernel.dk> (commit_signer:4/41=10%),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/2] proc: fix some wrong error code usage
Date: Wed,  2 Mar 2011 17:20:22 -0500
Message-Id: <1299104422-2620-1-git-send-email-bookjovi@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jovi Zhang <bookjovi@gmail.com>

[root@wei 1]# cat /proc/1/mem
cat: /proc/1/mem: No such process

error code -ESRCH is wrong in this situation

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
---
 fs/proc/base.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 9d096e8..9c23db0 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -775,7 +775,8 @@ static ssize_t mem_read(struct file * file, char __user * buf,
 	if (!task)
 		goto out_no_task;
 
-	if (check_mem_permission(task))
+	ret = check_mem_permission(task);
+	if (ret)
 		goto out;
 
 	ret = -ENOMEM;
@@ -845,7 +846,8 @@ static ssize_t mem_write(struct file * file, const char __user *buf,
 	if (!task)
 		goto out_no_task;
 
-	if (check_mem_permission(task))
+	copied = check_mem_permission(task);
+	if (copied)
 		goto out;
 
 	copied = -ENOMEM;
@@ -917,6 +919,7 @@ static ssize_t environ_read(struct file *file, char __user *buf,
 	if (!task)
 		goto out_no_task;
 
+	ret = -EPERM;
 	if (!ptrace_may_access(task, PTRACE_MODE_READ))
 		goto out;
 
-- 
1.7.2.3


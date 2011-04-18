Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521Ab1DXMBY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 08:01:24 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46792 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756605Ab1DXMBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 08:01:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=lzZritXQV8+fbN61V6ei7SDC2YvjgS+rt7pMK/Lr4+IVEFukfH02/WDgig4bj3+BHJ
         UFSbJ6tr6+/f0bmIeKGKR0O/guo+dPPKcHoMxlG63EyY8nu8lgT5SyIZhudNaNExetsJ
         UPzVT9pYC/xWyvREcDPvGn2JOcgrV/Tn3YfC8=
From: bookjovi@gmail.com
To: bookjovi@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org> (commit_signer:19/51=37%),
        Al Viro <viro@zeniv.linux.org.uk> (commit_signer:17/51=33%),
        David Rientjes <rientjes@google.com> (commit_signer:7/51=14%),
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> (commit_signer:5/51=10%),
        Stephen Wilson <wilsons@start.ca> (commit_signer:4/51=8%),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] proc: put check_mem_permission before __get_free_page in mem_read
Date: Sun, 17 Apr 2011 20:20:01 -0400
Message-Id: <1303086002-6961-1-git-send-email-bookjovi@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jovi Zhang <bookjovi@gmail.com>

It should be better if put check_mem_permission before __get_free_page
in mem_read, to be same as function mem_write.

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
---
 fs/proc/base.c |   24 ++++++++++--------------
 1 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index dfa5327..d66126d 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -831,23 +831,21 @@ static ssize_t mem_read(struct file * file, char __user * buf,
 	if (!task)
 		goto out_no_task;
 
-	ret = -ENOMEM;
-	page = (char *)__get_free_page(GFP_TEMPORARY);
-	if (!page)
-		goto out;
-
 	mm = check_mem_permission(task);
 	ret = PTR_ERR(mm);
 	if (IS_ERR(mm))
-		goto out_free;
+		goto out_task;
 
 	ret = -EIO;
- 
 	if (file->private_data != (void*)((long)current->self_exec_id))
-		goto out_put;
+		goto out_mm;
+
+	ret = -ENOMEM;
+	page = (char *)__get_free_page(GFP_TEMPORARY);
+	if (!page)
+		goto out_mm;
 
 	ret = 0;
- 
 	while (count > 0) {
 		int this_len, retval;
 
@@ -870,12 +868,10 @@ static ssize_t mem_read(struct file * file, char __user * buf,
 		count -= retval;
 	}
 	*ppos = src;
-
-out_put:
-	mmput(mm);
-out_free:
 	free_page((unsigned long) page);
-out:
+out_mm:
+	mmput(mm);
+out_task:
 	put_task_struct(task);
 out_no_task:
 	return ret;
-- 
1.7.2.3


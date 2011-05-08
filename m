Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab1EHPvU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 11:51:20 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53351 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775Ab1EHPtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 11:49:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=UH/TyJQ6SzgPSQ+eK0ehPlcm5aE17i1UZ9xGbkT4iQss+S2eRGgxXtJQWn7qsp9CUa
         v+15CxkL8PybTFyJ+0cotivZ+QYRopo4/Ntarsk/CZbH9Y1dhKeNYzjZdumdL37srOvQ
         2MCrGQzbaSvhGhqW6CrjajOVkZ3a/TgATzalE=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/11] ptrace: restructure ptrace_getsiginfo()
Date: Sun,  8 May 2011 17:48:59 +0200
Message-Id: <1304869745-1073-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1304869745-1073-1-git-send-email-tj@kernel.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Flatten ptrace_getsiginfo() to prepare for more logic in the success
path.  While at it, remove [un]likely() on child->last_siginfo check -
signal delivery and group stop traps can only be distinguished by NULL
siginfo and group stop isn't that unlikely.

This patch doesn't introduce any functional change.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/ptrace.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 1262a36..2a8e930 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -529,16 +529,19 @@ static int ptrace_setoptions(struct task_struct *child, unsigned long data)
 static int ptrace_getsiginfo(struct task_struct *child, siginfo_t *info)
 {
 	unsigned long flags;
-	int error = -ESRCH;
+	int error;
 
-	if (lock_task_sighand(child, &flags)) {
-		error = -EINVAL;
-		if (likely(child->last_siginfo != NULL)) {
-			*info = *child->last_siginfo;
-			error = 0;
-		}
-		unlock_task_sighand(child, &flags);
-	}
+	if (!lock_task_sighand(child, &flags))
+		return -ESRCH;
+
+	error = -EINVAL;
+	if (!child->last_siginfo)
+		goto out_unlock;
+
+	error = 0;
+	*info = *child->last_siginfo;
+out_unlock:
+	unlock_task_sighand(child, &flags);
 	return error;
 }
 
-- 
1.7.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933037Ab1EXSiQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 14:38:16 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60946 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933003Ab1EXSiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 14:38:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=vO+d5lUGw2TrNqKcK9Ks35NCzl/6f1xdM0GlBfsSQIvgaDMSWc3+g1R93wLoZX4Zqq
         yI6U5NIhrekxt264j20kmBBCgkys4h2K+CvSrhWLpi2beN2WLGq2bwbbKfEBJ5WZw+sH
         kHTKYnssRPQAK/D5BKDkDyGROTCOkAJKIc5es=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        pedro@codesourcery.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 14/19] ptrace: restructure ptrace_getsiginfo()
Date: Tue, 24 May 2011 20:37:34 +0200
Message-Id: <1306262259-7285-15-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1306262259-7285-1-git-send-email-tj@kernel.org>
References: <1306262259-7285-1-git-send-email-tj@kernel.org>
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
index 3911567..851870c 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -572,16 +572,19 @@ static int ptrace_setoptions(struct task_struct *child, unsigned long data)
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


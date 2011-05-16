Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094Ab1EPSSz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 14:18:55 -0400
Received: from mail-bw0-f52.google.com ([209.85.214.52]:60031 "EHLO
	mail-bw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548Ab1EPSRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 14:17:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=XoN4DQdGAK3rOs5sS3LLZB/OxpVj2bPrIUx+UFqWavBHs4GY3hDR8fD8kCC6kfaRjY
         bRj5yQNkCepGWh/y5rM9PXtz/WUA4vnEepkFx6clzPTRtJzefKAysq/uCbSnZ8+NTEgm
         NRKf0Fm1jSsuyHWUEVELgpCax27DSR3/Q8lk8=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/10] ptrace: restructure ptrace_getsiginfo()
Date: Mon, 16 May 2011 20:17:24 +0200
Message-Id: <1305569849-10448-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1305569849-10448-1-git-send-email-tj@kernel.org>
References: <1305569849-10448-1-git-send-email-tj@kernel.org>
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
index 351db7c..42037a4 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -574,16 +574,19 @@ static int ptrace_setoptions(struct task_struct *child, unsigned long data)
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


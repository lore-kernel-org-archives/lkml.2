Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379Ab1E2XNy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 19:13:54 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53557 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755581Ab1E2XNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 19:13:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=OeAsizXndPoF3S7gTEm9AgsTDx4X6ykK6pecTTGe16q6E5G9x0HihtdcicmjxICveW
         y/ffJyDTKcwKEGF5FbUZY9mD0axCe6pn9CjMFdKUOEsDzGtX94oNHNAjuxcQ76RC0m79
         WueR5c1xu1mV7SijfLyska4HVVlGSSzS/Jo4U=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        pedro@codesourcery.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 15/17] ptrace: don't let PTRACE_SETSIGINFO override __SI_TRAP siginfo
Date: Mon, 30 May 2011 01:12:38 +0200
Message-Id: <1306710760-16440-16-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <1306710760-16440-1-git-send-email-tj@kernel.org>
References: <1306710760-16440-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__SI_TRAP siginfo is special in the operation of ptrace.  It reports
group stop related information and will also interact with
notification retraps.  Don't let userland mess with it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/ptrace.c |   31 ++++++++++++++++++++++---------
 1 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index d5e38ac..f1efe07 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -545,16 +545,29 @@ static int ptrace_getsiginfo(struct task_struct *child, siginfo_t *info)
 static int ptrace_setsiginfo(struct task_struct *child, const siginfo_t *info)
 {
 	unsigned long flags;
-	int error = -ESRCH;
+	int error;
 
-	if (lock_task_sighand(child, &flags)) {
-		error = -EINVAL;
-		if (likely(child->last_siginfo != NULL)) {
-			*child->last_siginfo = *info;
-			error = 0;
-		}
-		unlock_task_sighand(child, &flags);
-	}
+	if (!lock_task_sighand(child, &flags))
+		return -ESRCH;
+
+	error = -EINVAL;
+	if (unlikely(!child->last_siginfo))
+		goto out_unlock;
+
+	/*
+	 * If seized, __SI_TRAP siginfo is used to communicate information
+	 * regarding traps and contains dynamic information generated on
+	 * GETSIGINFO.  Don't let userland override or fake it.
+	 */
+	if ((child->ptrace & PT_SEIZED) &&
+	    unlikely((child->last_siginfo->si_code & __SI_MASK) == __SI_TRAP ||
+		     (info->si_code & __SI_MASK) == __SI_TRAP))
+		goto out_unlock;
+
+	*child->last_siginfo = *info;
+	error = 0;
+out_unlock:
+	unlock_task_sighand(child, &flags);
 	return error;
 }
 
-- 
1.7.5.2


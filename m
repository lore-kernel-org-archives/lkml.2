Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab1EPSSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 14:18:17 -0400
Received: from mail-bw0-f52.google.com ([209.85.214.52]:37249 "EHLO
	mail-bw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912Ab1EPSRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 14:17:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=ayEATudbK4rDy+v15n8GFZVd10Eh9vG8G8qw00ylmJHDQVKrSkrSE7FPOgeyjBurnI
         m9oxkhfpi7IZKpUqounv388KVaxvzoTwPEMCwWBAdn3wv4HLVD82uQbEhzfrYanTcFlW
         pkaTuSTwIqQqn1Jou6rWSBng5mTzJWs11H2pk=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/10] ptrace: don't let PTRACE_SETSIGINFO override __SI_TRAP siginfo
Date: Mon, 16 May 2011 20:17:27 +0200
Message-Id: <1305569849-10448-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1305569849-10448-1-git-send-email-tj@kernel.org>
References: <1305569849-10448-1-git-send-email-tj@kernel.org>
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
index 30d2331..c12daec 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -612,16 +612,29 @@ out_unlock:
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
1.7.1


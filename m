Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab1E2XMz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 19:12:55 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53557 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab1E2XMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 19:12:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=BpLms0AxB7IceN3uPkBsW2qwoi1fwqlH0QrRkns+VNi+elULHQo5fMxfzpkJBzu02W
         Hlo5LRm4mJrecahjHXRCEi3ChTkBubyuoPRrUJuH1gAgUuJQ3S/QbRGFdNK/gYbCaJ1G
         75jARdsR0kO62dsDhZRvZk51SaS98G4fBGfhg=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        pedro@codesourcery.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/17] ptrace: remove silly wait_trap variable from ptrace_attach()
Date: Mon, 30 May 2011 01:12:24 +0200
Message-Id: <1306710760-16440-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <1306710760-16440-1-git-send-email-tj@kernel.org>
References: <1306710760-16440-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Local variable wait_trap is used to determine whether to call
wait_event() on TRAPPING or not, which doesn't change or optimize
anything.  Remove it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/ptrace.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 2df1157..389497b 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -184,7 +184,6 @@ bool ptrace_may_access(struct task_struct *task, unsigned int mode)
 
 static int ptrace_attach(struct task_struct *task)
 {
-	bool wait_trap = false;
 	int retval;
 
 	audit_ptrace(task);
@@ -246,7 +245,6 @@ static int ptrace_attach(struct task_struct *task)
 	if (task_is_stopped(task)) {
 		task->group_stop |= GROUP_STOP_PENDING | GROUP_STOP_TRAPPING;
 		signal_wake_up(task, 1);
-		wait_trap = true;
 	}
 
 	spin_unlock(&task->sighand->siglock);
@@ -257,9 +255,8 @@ unlock_tasklist:
 unlock_creds:
 	mutex_unlock(&task->signal->cred_guard_mutex);
 out:
-	if (wait_trap)
-		wait_event(current->signal->wait_chldexit,
-			   !(task->group_stop & GROUP_STOP_TRAPPING));
+	wait_event(current->signal->wait_chldexit,
+		   !(task->group_stop & GROUP_STOP_TRAPPING));
 	return retval;
 }
 
-- 
1.7.5.2


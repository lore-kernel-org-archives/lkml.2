Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933521Ab1FBLj7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 07:39:59 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49546 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756203Ab1FBLj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 07:39:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HULmJ14BcZ6aTatX2jFWbYde9Sxnvnst5pZihMT9afDKOjtxPHKLwTcg3bHrPAHGv4
         iYiYHareMsSts69okEFrM0DPbRaSYAXltYdwUAuiGwFp4VjOb353lcb11Mt6Y14mc7Vp
         5MVulWRSMU1W+gJBd/vwlMacjMr1JB6umOgSk=
Date: Thu, 2 Jun 2011 20:39:53 +0900
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        pedro@codesourcery.com
Subject: [PATCH UPDATED 01/17] ptrace: remove silly wait_trap variable from
 ptrace_attach()
Message-ID: <20110602113953.GA10410@mtj.dyndns.org>
References: <1306710760-16440-1-git-send-email-tj@kernel.org>
 <1306710760-16440-2-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306710760-16440-2-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ead8735f43a21993c78e6e4ed5627da6ec4911bd Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Thu, 2 Jun 2011 11:13:59 +0200

Remove local variable wait_trap which determines whether to wait for
!TRAPPING or not and simply wait for it if attach was successful.

-v2: Oleg pointed out wait should happen iff attach was successful.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 kernel/ptrace.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 2df1157..4f689cb 100644
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
@@ -257,7 +255,7 @@ unlock_tasklist:
 unlock_creds:
 	mutex_unlock(&task->signal->cred_guard_mutex);
 out:
-	if (wait_trap)
+	if (!retval)
 		wait_event(current->signal->wait_chldexit,
 			   !(task->group_stop & GROUP_STOP_TRAPPING));
 	return retval;
-- 
1.7.5.2


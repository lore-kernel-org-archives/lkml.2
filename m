Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933538Ab1FBLls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 07:41:48 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:43031 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab1FBLlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 07:41:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vIpMHxTcKrXJOZ6YsaKYD3b9qwgAhVBaFPNFB0Vsdv45kP5CjlX23O1lrlqUlYdb3Q
         kBxeXv98ZbaFyUlClPjJgJLjbLeQ5XMU1NRIKFBasbpQ8TUals/zwl2c76DCBFwomAve
         M6Vz0YCdhvKLVKAM03V4/T8n9O+4l4C0YS6z0=
Date: Thu, 2 Jun 2011 20:41:42 +0900
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        pedro@codesourcery.com
Subject: [PATCH UPDATED 08/17] ptrace: use bit_waitqueue for TRAPPING instead
 of wait_chldexit
Message-ID: <20110602114142.GB10410@mtj.dyndns.org>
References: <1306710760-16440-1-git-send-email-tj@kernel.org>
 <1306710760-16440-9-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306710760-16440-9-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From abf3702a74e4e9f6fe4250bc82b80f8421b1dee3 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Thu, 2 Jun 2011 11:14:00 +0200

ptracer->signal->wait_chldexit was used to wait for TRAPPING; however,
->wait_chldexit was already complicated with waker-side filtering
without adding TRAPPING wait on top of it.  Also, it unnecessarily
made TRAPPING clearing depend on the current ptrace relationship - if
the ptracee is detached, wakeup is lost.

There is no reason to use signal->wait_chldexit here.  We're just
waiting for JOBCTL_TRAPPING bit to clear and given the relatively
infrequent use of ptrace, bit_waitqueue can serve it perfectly.

This patch makes JOBCTL_TRAPPING wait use bit_waitqueue instead of
signal->wait_chldexit.

-v2: Use JOBCTL_*_BIT macros instead of ilog2() as suggested by Linus.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
Regenerated to apply on top of the updated first patch.  Other than
that, no change.

Thanks.

 kernel/ptrace.c |   10 ++++++++--
 kernel/signal.c |    3 +--
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 0c37d99..7f05f3a 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -25,6 +25,12 @@
 #include <linux/hw_breakpoint.h>
 
 
+static int ptrace_trapping_sleep_fn(void *flags)
+{
+	schedule();
+	return 0;
+}
+
 /*
  * ptrace a task: make the debugger its new parent and
  * move it to the ptrace list.
@@ -270,8 +276,8 @@ unlock_creds:
 	mutex_unlock(&task->signal->cred_guard_mutex);
 out:
 	if (!retval)
-		wait_event(current->signal->wait_chldexit,
-			   !(task->jobctl & JOBCTL_TRAPPING));
+		wait_on_bit(&task->jobctl, JOBCTL_TRAPPING_BIT,
+			    ptrace_trapping_sleep_fn, TASK_UNINTERRUPTIBLE);
 	return retval;
 }
 
diff --git a/kernel/signal.c b/kernel/signal.c
index 9ab91c5..172a4c7 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -272,8 +272,7 @@ static void task_clear_jobctl_trapping(struct task_struct *task)
 {
 	if (unlikely(task->jobctl & JOBCTL_TRAPPING)) {
 		task->jobctl &= ~JOBCTL_TRAPPING;
-		__wake_up_sync_key(&task->parent->signal->wait_chldexit,
-				   TASK_UNINTERRUPTIBLE, 1, task);
+		wake_up_bit(&task->jobctl, JOBCTL_TRAPPING_BIT);
 	}
 }
 
-- 
1.7.5.2


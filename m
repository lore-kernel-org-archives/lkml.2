Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364Ab2BNQys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 11:54:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48591 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757576Ab2BNQyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 11:54:47 -0500
Date: Tue, 14 Feb 2012 17:48:04 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: apw@canonical.com, arjan@linux.intel.com, fhrbata@redhat.com,
        john.johansen@canonical.com, penguin-kernel@I-love.SAKURA.ne.jp,
        rientjes@google.com, rusty@rustcorp.com.au, tj@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] usermodehelper: implement UMH_KILLABLE
Message-ID: <20120214164804.GB21185@redhat.com>
References: <20120214164709.GA21178@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120214164709.GA21178@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement UMH_KILLABLE, should be used along with UMH_WAIT_EXEC/PROC.
The caller must ensure that subprocess_info->path/etc can not go away
until call_usermodehelper_freeinfo().

call_usermodehelper_exec(UMH_KILLABLE) does wait_for_completion_killable.
If it fails, it uses xchg(&sub_info->complete, NULL) to serialize with
umh_complete() which does the same xhcg() to access sub_info->complete.

If call_usermodehelper_exec wins, it can safely return. umh_complete()
should get NULL and call call_usermodehelper_freeinfo().

Otherwise we know that umh_complete() was already called, in this case
call_usermodehelper_exec() falls back to wait_for_completion() which
should succeed "very soon".

Note: UMH_NO_WAIT == -1 but it obviously should not be used with
UMH_KILLABLE. We delay the neccessary cleanup to simplify the back
porting.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/kmod.h |    2 ++
 kernel/kmod.c        |   27 +++++++++++++++++++++++++--
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/include/linux/kmod.h b/include/linux/kmod.h
index 722f477..1b59858 100644
--- a/include/linux/kmod.h
+++ b/include/linux/kmod.h
@@ -54,6 +54,8 @@ enum umh_wait {
 	UMH_WAIT_PROC = 1,	/* wait for the process to complete */
 };
 
+#define UMH_KILLABLE	4	/* wait for EXEC/PROC killable */
+
 struct subprocess_info {
 	struct work_struct work;
 	struct completion *complete;
diff --git a/kernel/kmod.c b/kernel/kmod.c
index 8ea2594..f92f917 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -201,7 +201,15 @@ EXPORT_SYMBOL(call_usermodehelper_freeinfo);
 
 static void umh_complete(struct subprocess_info *sub_info)
 {
-	complete(sub_info->complete);
+	struct completion *comp = xchg(&sub_info->complete, NULL);
+	/*
+	 * See call_usermodehelper_exec(). If xchg() returns NULL
+	 * we own sub_info, the UMH_KILLABLE caller has gone away.
+	 */
+	if (comp)
+		complete(comp);
+	else
+		call_usermodehelper_freeinfo(sub_info);
 }
 
 /* Keventd can't block, but this (a child) can. */
@@ -252,6 +260,9 @@ static void __call_usermodehelper(struct work_struct *work)
 	enum umh_wait wait = sub_info->wait;
 	pid_t pid;
 
+	if (wait != UMH_NO_WAIT)
+		wait &= ~UMH_KILLABLE;
+
 	/* CLONE_VFORK: wait until the usermode helper has execve'd
 	 * successfully We need the data structures to stay around
 	 * until that is done.  */
@@ -461,9 +472,21 @@ int call_usermodehelper_exec(struct subprocess_info *sub_info,
 	queue_work(khelper_wq, &sub_info->work);
 	if (wait == UMH_NO_WAIT)	/* task has freed sub_info */
 		goto unlock;
+
+	if (wait & UMH_KILLABLE) {
+		retval = wait_for_completion_killable(&done);
+		if (!retval)
+			goto wait_done;
+
+		/* umh_complete() will see NULL and free sub_info */
+		if (xchg(&sub_info->complete, NULL))
+			goto unlock;
+		/* fallthrough, umh_complete() was already called */
+	}
+
 	wait_for_completion(&done);
+wait_done:
 	retval = sub_info->retval;
-
 out:
 	call_usermodehelper_freeinfo(sub_info);
 unlock:
-- 
1.5.5.1



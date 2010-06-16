Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758920Ab0FPMYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 08:24:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402Ab0FPMYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 08:24:05 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: dhowells@redhat.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] cred - synchronize rcu before releasing cred
Date: Wed, 16 Jun 2010 14:24:03 +0200
Message-Id: <1276691043-12694-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

BZ 591015 - kernel BUG at kernel/cred.c:168
https://bugzilla.redhat.com/show_bug.cgi?id=591015

Above bugzilla reported bug during the releasing of
old cred structure.

There is reproducer attached to the bugzilla.

The issue is caused by releasing old cred struct while other
kernel path might be still using it. This leads to cred->usage
inconsistency inside the __put_cred and triggering the bug.

Following kernel paths are affected:

The CPU1 path is setting the new groups creds.
The CPU2 path is cat /proc/PID/status


CPU 1                              CPU 2

sys_setgroups                      proc_pid_status      
  set_current_groups                 task_state
    commit_creds                       rcu_read_lock
      put_cred                         ...
        __put_cred                     get_cred
          BUG_ON(usage != 0)           ...
                                       rcu_read_unlock
                                       


If __put_cred got executed during the CPU2 holding the reference
the BUG_ON inside __put_cred is trigered.

I put synchronize_rcu before put_cred call, so we are sure
all the rcu_read_lock blocks are finished, and if needed, using
new creds.

Also I moved rcu_read_unlock below the put_cred for consistency.


wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 fs/proc/array.c |    3 ++-
 kernel/cred.c   |    6 ++++++
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 9b58d38..c0e60d1 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -199,7 +199,6 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 		"FDSize:\t%d\n"
 		"Groups:\t",
 		fdt ? fdt->max_fds : 0);
-	rcu_read_unlock();
 
 	group_info = cred->group_info;
 	task_unlock(p);
@@ -208,6 +207,8 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 		seq_printf(m, "%d ", GROUP_AT(group_info, g));
 	put_cred(cred);
 
+	rcu_read_unlock();
+
 	seq_printf(m, "\n");
 }
 
diff --git a/kernel/cred.c b/kernel/cred.c
index a2d5504..4872f12 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -510,6 +510,12 @@ int commit_creds(struct cred *new)
 	    new->fsgid != old->fsgid)
 		proc_id_connector(task, PROC_EVENT_GID);
 
+	/*
+	 * New cred is set already, now let the old one
+	 * chance to disappear on other CPUs.
+	 */
+	synchronize_rcu();
+
 	/* release the old obj and subj refs both */
 	put_cred(old);
 	put_cred(old);

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab0FYNdk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 09:33:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755913Ab0FYNdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 09:33:37 -0400
Date: Fri, 25 Jun 2010 09:33:33 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-security-module@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>, Eric Dumazet <eric.dumazet@gmail.com>,
       linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH] cred - synchronize rcu before releasing cred
Message-ID: <20100625133333.GA1918@jolsa.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

I think there's no need to get the cred refference as long as
the 'cred' handling stays inside the rcu_read_lock block.

And the condition of __task_cred 'make sure task doesn't go away',
is done by proc_single_show as this is the proc file.

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: David Howells <dhowells@redhat.com>
---
diff --git a/fs/proc/array.c b/fs/proc/array.c
index 9b58d38..ac3b3a4 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -176,7 +176,7 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 		if (tracer)
 			tpid = task_pid_nr_ns(tracer, ns);
 	}
-	cred = get_cred((struct cred *) __task_cred(p));
+	cred = __task_cred(p);
 	seq_printf(m,
 		"State:\t%s\n"
 		"Tgid:\t%d\n"
@@ -199,15 +199,14 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 		"FDSize:\t%d\n"
 		"Groups:\t",
 		fdt ? fdt->max_fds : 0);
-	rcu_read_unlock();
 
 	group_info = cred->group_info;
 	task_unlock(p);
 
 	for (g = 0; g < min(group_info->ngroups, NGROUPS_SMALL); g++)
 		seq_printf(m, "%d ", GROUP_AT(group_info, g));
-	put_cred(cred);
 
+	rcu_read_unlock();
 	seq_printf(m, "\n");
 }
 

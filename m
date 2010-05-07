Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab0EGI5N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 04:57:13 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:46481 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755116Ab0EGI4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 04:56:43 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: akpm@linux-foundation.org
Cc: torvalds@linux-foundation.org, adobriyan@gmail.com, nhorman@tuxdriver.com,
       oleg@redhat.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 02/11] rlimits: add task_struct to update_rlimit_cpu
Date: Fri,  7 May 2010 10:55:33 +0200
Message-Id: <1273222543-17083-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <alpine.LFD.2.00.1005060827520.901@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1005060827520.901@i5.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

Add task_struct as a parameter to update_rlimit_cpu to be able to set
rlimit_cpu of different task than current.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: James Morris <jmorris@namei.org>
---
 include/linux/posix-timers.h |    2 +-
 kernel/posix-cpu-timers.c    |    8 ++++----
 kernel/sys.c                 |    2 +-
 security/selinux/hooks.c     |    3 ++-
 4 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index 4f71bf4..3e23844 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -117,6 +117,6 @@ void set_process_cpu_timer(struct task_struct *task, unsigned int clock_idx,
 
 long clock_nanosleep_restart(struct restart_block *restart_block);
 
-void update_rlimit_cpu(unsigned long rlim_new);
+void update_rlimit_cpu(struct task_struct *task, unsigned long rlim_new);
 
 #endif
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 9829646..0513900 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -16,13 +16,13 @@
  * siglock protection since other code may update expiration cache as
  * well.
  */
-void update_rlimit_cpu(unsigned long rlim_new)
+void update_rlimit_cpu(struct task_struct *task, unsigned long rlim_new)
 {
 	cputime_t cputime = secs_to_cputime(rlim_new);
 
-	spin_lock_irq(&current->sighand->siglock);
-	set_process_cpu_timer(current, CPUCLOCK_PROF, &cputime, NULL);
-	spin_unlock_irq(&current->sighand->siglock);
+	spin_lock_irq(&task->sighand->siglock);
+	set_process_cpu_timer(task, CPUCLOCK_PROF, &cputime, NULL);
+	spin_unlock_irq(&task->sighand->siglock);
 }
 
 static int check_clock(const clockid_t which_clock)
diff --git a/kernel/sys.c b/kernel/sys.c
index 1ba4522..f5183b0 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1320,7 +1320,7 @@ SYSCALL_DEFINE2(setrlimit, unsigned int, resource, struct rlimit __user *, rlim)
 	if (new_rlim.rlim_cur == RLIM_INFINITY)
 		goto out;
 
-	update_rlimit_cpu(new_rlim.rlim_cur);
+	update_rlimit_cpu(current, new_rlim.rlim_cur);
 out:
 	return 0;
 }
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 674992f..740a71f 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2360,7 +2360,8 @@ static void selinux_bprm_committing_creds(struct linux_binprm *bprm)
 			initrlim = init_task.signal->rlim + i;
 			rlim->rlim_cur = min(rlim->rlim_max, initrlim->rlim_cur);
 		}
-		update_rlimit_cpu(current->signal->rlim[RLIMIT_CPU].rlim_cur);
+		update_rlimit_cpu(current,
+				current->signal->rlim[RLIMIT_CPU].rlim_cur);
 	}
 }
 
-- 
1.7.1



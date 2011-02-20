Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab1BTHI7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 02:08:59 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56590 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab1BTHI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 02:08:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YvVXHebtD6EFRaURZZZiEXezpMksnmF7+34T6VUBv7C4aPLMvWjP2dSVIAGLHR3Ury
         Lc5cK5VAsPE5LAgrcQUzM1KXa2m5oqKNKcxcuIpwBcKfHZuzt0LCnl8vP/kJKzQ7MEX+
         2N6RWRle+aAvQRvMuDW1fTL94d/atL01u4nnM=
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>
Subject: [PATCH 5/5] sched, autogroup: runtime enable/disable tuning fix
Date: Sun, 20 Feb 2011 15:08:16 +0800
Message-Id: <1298185696-4403-6-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1298185696-4403-1-git-send-email-yong.zhang0@gmail.com>
References: <1298185696-4403-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now enable/disable autogroup at runtime is just a flag,
it doesn't take effect on current process of the system.

when disable autogroup:

vanilla:
  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND            
 1046 test1     20   0 25544  844  276 R 50.0  0.0   0:23.30 bash               
 1044 test2     20   0 25544  860  280 R 25.2  0.0   0:20.55 bash               
 1045 test2     20   0 25544  864  284 R 24.8  0.0   0:17.48 bash

patched:
  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND            
  991 test1     20   0 25544  844  276 R 31.7  0.0   2:05.93 bash               
  992 test2     20   0 25544  848  276 R 31.7  0.0   1:16.84 bash               
  994 test2     20   0 25544  856  284 R 29.8  0.0   1:02.67 bash 

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
---
 include/linux/sched.h    |    3 +++
 kernel/sched_autogroup.c |   34 ++++++++++++++++++++++++++++++++++
 kernel/sysctl.c          |    2 +-
 3 files changed, 38 insertions(+), 1 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index d747f94..00791ce 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1949,6 +1949,9 @@ extern unsigned int sysctl_sched_compat_yield;
 
 #ifdef CONFIG_SCHED_AUTOGROUP
 extern unsigned int sysctl_sched_autogroup_enabled;
+extern int sysctl_sched_autogroup_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp,
+		loff_t *ppos);
 
 extern void sched_autogroup_create_attach(struct task_struct *p);
 extern void sched_autogroup_detach(struct task_struct *p);
diff --git a/kernel/sched_autogroup.c b/kernel/sched_autogroup.c
index 137a096..b1ad946 100644
--- a/kernel/sched_autogroup.c
+++ b/kernel/sched_autogroup.c
@@ -211,6 +211,40 @@ static int __init setup_autogroup(char *str)
 
 __setup("noautogroup", setup_autogroup);
 
+static DEFINE_MUTEX(autogroup_sysctl_mutex);
+
+int sysctl_sched_autogroup_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp,
+		loff_t *ppos)
+{
+	int old_value, ret;
+	struct task_struct *p, *n;
+
+	mutex_lock(&autogroup_sysctl_mutex);
+
+	old_value = sysctl_sched_autogroup_enabled;
+	ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+
+	if (ret || !write || (old_value == sysctl_sched_autogroup_enabled))
+		goto out_unlock;
+
+	read_lock_irq(&tasklist_lock);
+	rcu_read_lock();
+
+	do_each_thread(n, p) {
+		if (cgroup_task_group(p) == &root_task_group)
+			sched_move_task(p);
+	} while_each_thread(n, p);
+
+	rcu_read_unlock();
+	read_unlock_irq(&tasklist_lock);
+
+out_unlock:
+	mutex_unlock(&autogroup_sysctl_mutex);
+
+	return ret;
+}
+
 #ifdef CONFIG_PROC_FS
 
 int proc_sched_autogroup_set_nice(struct task_struct *p, int *nice)
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 22e07ee..2b12c65 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -374,7 +374,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_sched_autogroup_enabled,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= sysctl_sched_autogroup_handler,
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
-- 
1.7.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab2ITCM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 22:12:56 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:48431 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733Ab2ITCLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 22:11:35 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-security-module@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Eric Paris <eparis@redhat.com>, David Miller <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Balbir Singh <bsingharora@gmail.com>
Date: Wed, 19 Sep 2012 18:52:15 -0700
Message-Id: <1348105949-25454-13-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348105949-25454-1-git-send-email-ebiederm@xmission.com>
References: <871uhx1n71.fsf@xmission.com>
 <1348105949-25454-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1++SUm/dVRnuJiwPAEPBPCX6MBdb2nStSU=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3629]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 13/27] userns: Convert taskstats to handle the user and pid namespaces.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

- Explicitly limit exit task stat broadcast to the initial user and
  pid namespaces, as it is already limited to the initial network
  namespace.

- For broadcast task stats explicitly generate all of the idenitiers
  in terms of the initial user namespace and the initial pid
  namespace.

- For request stats report them in terms of the current user namespace
  and the current pid namespace.  Netlink messages are delivered
  syncrhonously to the kernel allowing us to get the user namespace
  and the pid namespace from the current task.

- Pass the namespaces for representing pids and uids and gids
  into bacct_add_task.

Cc: Balbir Singh <bsingharora@gmail.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 include/linux/tsacct_kern.h |    8 ++++++--
 init/Kconfig                |    1 -
 kernel/taskstats.c          |   23 +++++++++++++++++------
 kernel/tsacct.c             |   12 +++++++-----
 4 files changed, 30 insertions(+), 14 deletions(-)

diff --git a/include/linux/tsacct_kern.h b/include/linux/tsacct_kern.h
index 7e50ac7..44893e5 100644
--- a/include/linux/tsacct_kern.h
+++ b/include/linux/tsacct_kern.h
@@ -10,9 +10,13 @@
 #include <linux/taskstats.h>
 
 #ifdef CONFIG_TASKSTATS
-extern void bacct_add_tsk(struct taskstats *stats, struct task_struct *tsk);
+extern void bacct_add_tsk(struct user_namespace *user_ns,
+			  struct pid_namespace *pid_ns,
+			  struct taskstats *stats, struct task_struct *tsk);
 #else
-static inline void bacct_add_tsk(struct taskstats *stats, struct task_struct *tsk)
+static inline void bacct_add_tsk(struct user_namespace *user_ns,
+				 struct pid_namespace *pid_ns,
+				 struct taskstats *stats, struct task_struct *tsk)
 {}
 #endif /* CONFIG_TASKSTATS */
 
diff --git a/init/Kconfig b/init/Kconfig
index b5ecb4e..f0f636c 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -927,7 +927,6 @@ config UIDGID_CONVERTED
 	# Features
 	depends on IMA = n
 	depends on EVM = n
-	depends on TASKSTATS = n
 	depends on TRACING = n
 	depends on FS_POSIX_ACL = n
 	depends on QUOTA = n
diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index d0a3279..3880df2 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -27,6 +27,7 @@
 #include <linux/cgroup.h>
 #include <linux/fs.h>
 #include <linux/file.h>
+#include <linux/pid_namespace.h>
 #include <net/genetlink.h>
 #include <linux/atomic.h>
 
@@ -174,7 +175,9 @@ static void send_cpu_listeners(struct sk_buff *skb,
 	up_write(&listeners->sem);
 }
 
-static void fill_stats(struct task_struct *tsk, struct taskstats *stats)
+static void fill_stats(struct user_namespace *user_ns,
+		       struct pid_namespace *pid_ns,
+		       struct task_struct *tsk, struct taskstats *stats)
 {
 	memset(stats, 0, sizeof(*stats));
 	/*
@@ -190,7 +193,7 @@ static void fill_stats(struct task_struct *tsk, struct taskstats *stats)
 	stats->version = TASKSTATS_VERSION;
 	stats->nvcsw = tsk->nvcsw;
 	stats->nivcsw = tsk->nivcsw;
-	bacct_add_tsk(stats, tsk);
+	bacct_add_tsk(user_ns, pid_ns, stats, tsk);
 
 	/* fill in extended acct fields */
 	xacct_add_tsk(stats, tsk);
@@ -207,7 +210,7 @@ static int fill_stats_for_pid(pid_t pid, struct taskstats *stats)
 	rcu_read_unlock();
 	if (!tsk)
 		return -ESRCH;
-	fill_stats(tsk, stats);
+	fill_stats(current_user_ns(), task_active_pid_ns(current), tsk, stats);
 	put_task_struct(tsk);
 	return 0;
 }
@@ -291,6 +294,12 @@ static int add_del_listener(pid_t pid, const struct cpumask *mask, int isadd)
 	if (!cpumask_subset(mask, cpu_possible_mask))
 		return -EINVAL;
 
+	if (current_user_ns() != &init_user_ns)
+		return -EINVAL;
+
+	if (task_active_pid_ns(current) != &init_pid_ns)
+		return -EINVAL;
+
 	if (isadd == REGISTER) {
 		for_each_cpu(cpu, mask) {
 			s = kmalloc_node(sizeof(struct listener),
@@ -631,11 +640,12 @@ void taskstats_exit(struct task_struct *tsk, int group_dead)
 	if (rc < 0)
 		return;
 
-	stats = mk_reply(rep_skb, TASKSTATS_TYPE_PID, tsk->pid);
+	stats = mk_reply(rep_skb, TASKSTATS_TYPE_PID,
+			 task_pid_nr_ns(tsk, &init_pid_ns));
 	if (!stats)
 		goto err;
 
-	fill_stats(tsk, stats);
+	fill_stats(&init_user_ns, &init_pid_ns, tsk, stats);
 
 	/*
 	 * Doesn't matter if tsk is the leader or the last group member leaving
@@ -643,7 +653,8 @@ void taskstats_exit(struct task_struct *tsk, int group_dead)
 	if (!is_thread_group || !group_dead)
 		goto send;
 
-	stats = mk_reply(rep_skb, TASKSTATS_TYPE_TGID, tsk->tgid);
+	stats = mk_reply(rep_skb, TASKSTATS_TYPE_TGID,
+			 task_tgid_nr_ns(tsk, &init_pid_ns));
 	if (!stats)
 		goto err;
 
diff --git a/kernel/tsacct.c b/kernel/tsacct.c
index 23b4d78..625df0b 100644
--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -26,7 +26,9 @@
 /*
  * fill in basic accounting fields
  */
-void bacct_add_tsk(struct taskstats *stats, struct task_struct *tsk)
+void bacct_add_tsk(struct user_namespace *user_ns,
+		   struct pid_namespace *pid_ns,
+		   struct taskstats *stats, struct task_struct *tsk)
 {
 	const struct cred *tcred;
 	struct timespec uptime, ts;
@@ -55,13 +57,13 @@ void bacct_add_tsk(struct taskstats *stats, struct task_struct *tsk)
 		stats->ac_flag |= AXSIG;
 	stats->ac_nice	 = task_nice(tsk);
 	stats->ac_sched	 = tsk->policy;
-	stats->ac_pid	 = tsk->pid;
+	stats->ac_pid	 = task_pid_nr_ns(tsk, pid_ns);
 	rcu_read_lock();
 	tcred = __task_cred(tsk);
-	stats->ac_uid	 = tcred->uid;
-	stats->ac_gid	 = tcred->gid;
+	stats->ac_uid	 = from_kuid_munged(user_ns, tcred->uid);
+	stats->ac_gid	 = from_kgid_munged(user_ns, tcred->gid);
 	stats->ac_ppid	 = pid_alive(tsk) ?
-				rcu_dereference(tsk->real_parent)->tgid : 0;
+		task_tgid_nr_ns(rcu_dereference(tsk->real_parent), pid_ns) : 0;
 	rcu_read_unlock();
 	stats->ac_utime = cputime_to_usecs(tsk->utime);
 	stats->ac_stime = cputime_to_usecs(tsk->stime);
-- 
1.7.5.4


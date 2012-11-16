Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab2KPQhx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 11:37:53 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:50554 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab2KPQhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 11:37:16 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>,
        Serge Hallyn <serge@hallyn.com>, Gao feng <gaofeng@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Fri, 16 Nov 2012 08:35:48 -0800
Message-Id: <1353083750-3621-9-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1353083750-3621-1-git-send-email-ebiederm@xmission.com>
References: <8739097bkk.fsf@xmission.com>
 <1353083750-3621-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1+uJL1jHV0BJ9xQJuSqq53CDNdJDBvpW5Y=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0010]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linux Containers <containers@lists.linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [PATCH 09/11] pidns: Add setns support
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

- Pid namespaces are designed to be inescapable so verify that the
  passed in pid namespace is a child of the currently active
  pid namespace or the currently active pid namespace itself.

  Allowing the currently active pid namespace is important so
  the effects of an earlier setns can be cancelled.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/proc/namespaces.c    |    3 ++
 include/linux/proc_fs.h |    1 +
 kernel/pid_namespace.c  |   54 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 58 insertions(+), 0 deletions(-)

diff --git a/fs/proc/namespaces.c b/fs/proc/namespaces.c
index b178ed7..85ca047 100644
--- a/fs/proc/namespaces.c
+++ b/fs/proc/namespaces.c
@@ -24,6 +24,9 @@ static const struct proc_ns_operations *ns_entries[] = {
 #ifdef CONFIG_IPC_NS
 	&ipcns_operations,
 #endif
+#ifdef CONFIG_PID_NS
+	&pidns_operations,
+#endif
 };
 
 static const struct file_operations ns_file_operations = {
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 3fd2e87..acaafcd 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -251,6 +251,7 @@ struct proc_ns_operations {
 extern const struct proc_ns_operations netns_operations;
 extern const struct proc_ns_operations utsns_operations;
 extern const struct proc_ns_operations ipcns_operations;
+extern const struct proc_ns_operations pidns_operations;
 
 union proc_op {
 	int (*proc_get_link)(struct dentry *, struct path *);
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index 066c058..c6514f5 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -300,6 +300,60 @@ int reboot_pid_ns(struct pid_namespace *pid_ns, int cmd)
 	return 0;
 }
 
+static void *pidns_get(struct task_struct *task)
+{
+	struct pid_namespace *ns;
+
+	rcu_read_lock();
+	ns = get_pid_ns(task_active_pid_ns(task));
+	rcu_read_unlock();
+
+	return ns;
+}
+
+static void pidns_put(void *ns)
+{
+	put_pid_ns(ns);
+}
+
+static int pidns_install(struct nsproxy *nsproxy, void *ns)
+{
+	struct pid_namespace *active = task_active_pid_ns(current);
+	struct pid_namespace *ancestor, *new = ns;
+
+	if (!ns_capable(new->user_ns, CAP_SYS_ADMIN))
+		return -EPERM;
+
+	/*
+	 * Only allow entering the current active pid namespace
+	 * or a child of the current active pid namespace.
+	 *
+	 * This is required for fork to return a usable pid value and
+	 * this maintains the property that processes and their
+	 * children can not escape their current pid namespace.
+	 */
+	if (new->level < active->level)
+		return -EINVAL;
+
+	ancestor = new;
+	while (ancestor->level > active->level)
+		ancestor = ancestor->parent;
+	if (ancestor != active)
+		return -EINVAL;
+
+	put_pid_ns(nsproxy->pid_ns);
+	nsproxy->pid_ns = get_pid_ns(new);
+	return 0;
+}
+
+const struct proc_ns_operations pidns_operations = {
+	.name		= "pid",
+	.type		= CLONE_NEWPID,
+	.get		= pidns_get,
+	.put		= pidns_put,
+	.install	= pidns_install,
+};
+
 static __init int pid_namespaces_init(void)
 {
 	pid_ns_cachep = KMEM_CACHE(pid_namespace, SLAB_PANIC);
-- 
1.7.5.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab1K1PVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 10:21:48 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:18290 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189Ab1K1PVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 10:21:47 -0500
Message-ID: <4ED3A6F5.6070606@parallels.com>
Date: Mon, 28 Nov 2011 19:21:25 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [PATCH] sysctl: Add the kernel.ns_last_pid control
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sysctl works on the current task's pid namespace, getting and setting its
last_pid field.

Writing is allowed for CAP_SYS_ADMIN-capable tasks thus making it possible to
create a task with desired pid value. This ability is required badly for the
checkpoint/restore in userspace.

This approach suits all the parties for now.

Signed-off-by: Pavel Emelyanov <xemul@parallels.com>

---
 Documentation/sysctl/kernel.txt |    8 ++++++++
 kernel/pid.c                    |    4 +++-
 kernel/pid_namespace.c          |   31 +++++++++++++++++++++++++++++++
 3 files changed, 42 insertions(+), 1 deletions(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 1f24636..1e9cd67 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -401,6 +401,14 @@ PIDs of value pid_max or larger are not allocated.
 
 ==============================================================
 
+ns_last_pid:
+
+The last pid allocated in the current (the one task using this sysctl
+lives in) pid namespace. When selecting a pid for a next task on fork
+kernel tries to allocate a number starting from this one.
+
+==============================================================
+
 powersave-nap: (PPC only)
 
 If set, Linux-PPC will use the 'nap' mode of powersaving,
diff --git a/kernel/pid.c b/kernel/pid.c
index fa5f722..ce8e00d 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -137,7 +137,9 @@ static int pid_before(int base, int a, int b)
 }
 
 /*
- * We might be racing with someone else trying to set pid_ns->last_pid.
+ * We might be racing with someone else trying to set pid_ns->last_pid
+ * at the pid allocation time (there's also a sysctl for this, but racing
+ * with this one is OK, see comment in kernel/pid_namespace.c about it).
  * We want the winner to have the "later" value, because if the
  * "earlier" value prevails, then a pid may get reused immediately.
  *
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index e9c9adc..bcd3f16 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -191,9 +191,40 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
 	return;
 }
 
+static int pid_ns_ctl_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct ctl_table tmp = *table;
+
+	if (write && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	/*
+	 * Writing directly to ns' last_pid field is OK, since this field
+	 * is volatile in a living namespace anyway and a code writing to
+	 * it should synchronize its usage with external means.
+	 */
+
+	tmp.data = &current->nsproxy->pid_ns->last_pid;
+	return proc_dointvec(&tmp, write, buffer, lenp, ppos);
+}
+
+static struct ctl_table pid_ns_ctl_table[] = {
+	{
+		.procname = "ns_last_pid",
+		.maxlen = sizeof(int),
+		.mode = 0666, /* permissions are checked in the handler */
+		.proc_handler = pid_ns_ctl_handler,
+	},
+	{ }
+};
+
+static struct ctl_path kern_path[] = { { .procname = "kernel", }, { } };
+
 static __init int pid_namespaces_init(void)
 {
 	pid_ns_cachep = KMEM_CACHE(pid_namespace, SLAB_PANIC);
+	register_sysctl_paths(kern_path, pid_ns_ctl_table);
 	return 0;
 }
 
-- 
1.5.5.6

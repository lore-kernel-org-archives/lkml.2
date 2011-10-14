Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932684Ab1JNLF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 07:05:29 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59862 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236Ab1JNLF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 07:05:27 -0400
Message-Id: <20111014110511.416851818@openvz.org>
User-Agent: quilt/0.48-1
Date: Fri, 14 Oct 2011 15:04:19 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Vagin <avagin@parallels.com>, Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Tejun Heo <tj@kernel.org>, Dave Hansen <dave@linux.vnet.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 3/5] fs, proc: Add /proc/$pid/tls entry
References: <20111014110416.552685686@openvz.org>
Content-Disposition: inline; filename=fs-proc-add-tls
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be able to restart checkpointed tasks we need
to know TLS status at dumping time. Export this
information by /proc/$pid/tls entry.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 fs/proc/base.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

Index: linux-2.6.git/fs/proc/base.c
===================================================================
--- linux-2.6.git.orig/fs/proc/base.c
+++ linux-2.6.git/fs/proc/base.c
@@ -3150,6 +3150,23 @@ static int proc_pid_personality(struct s
 	return err;
 }
 
+#ifdef CONFIG_X86
+static int proc_pid_tls(struct seq_file *m, struct pid_namespace *ns,
+			struct pid *pid, struct task_struct *task)
+{
+	int err = lock_trace(task);
+	if (!err) {
+		int i;
+		for (i = 0; i < GDT_ENTRY_TLS_ENTRIES; i++)
+			seq_printf(m, "%x %x\n",
+				   task->thread.tls_array[i].a,
+				   task->thread.tls_array[i].b);
+		unlock_trace(task);
+	}
+	return err;
+}
+#endif
+
 /*
  * Thread groups
  */
@@ -3169,6 +3186,9 @@ static const struct pid_entry tgid_base_
 	INF("auxv",       S_IRUSR, proc_pid_auxv),
 	ONE("status",     S_IRUGO, proc_pid_status),
 	ONE("personality", S_IRUGO, proc_pid_personality),
+#ifdef CONFIG_X86
+	ONE("tls",        S_IRUGO, proc_pid_tls),
+#endif
 	INF("limits",	  S_IRUGO, proc_pid_limits),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",      S_IRUGO|S_IWUSR, proc_pid_sched_operations),


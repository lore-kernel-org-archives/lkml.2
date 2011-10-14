Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932741Ab1JNLFc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 07:05:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59862 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068Ab1JNLF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 07:05:29 -0400
Message-Id: <20111014110511.157239709@openvz.org>
User-Agent: quilt/0.48-1
Date: Fri, 14 Oct 2011 15:04:17 +0400
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
        Serge Hallyn <serge.hallyn@canonical.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 1/5] proc: Introduce the Children: line in /proc/<pid>/status
References: <20111014110416.552685686@openvz.org>
Content-Disposition: inline; filename=cr-proc-add-children
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Emelyanov <xemul@parallels.com>

Although we can get the pids of some task's issue, this is just 
more convenient to have them this way.

Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 fs/proc/array.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

Index: linux-2.6.git/fs/proc/array.c
===================================================================
--- linux-2.6.git.orig/fs/proc/array.c
+++ linux-2.6.git/fs/proc/array.c
@@ -158,6 +158,18 @@ static inline const char *get_task_state
 	return *p;
 }
 
+static void task_children(struct seq_file *m, struct task_struct *p, struct pid_namespace *ns)
+{
+	struct task_struct *c;
+
+	seq_printf(m, "Children:");
+	read_lock(&tasklist_lock);
+	list_for_each_entry(c, &p->children, sibling)
+		seq_printf(m, " %d", pid_nr_ns(task_pid(c), ns));
+	read_unlock(&tasklist_lock);
+	seq_putc(m, '\n');
+}
+
 static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 				struct pid *pid, struct task_struct *p)
 {
@@ -192,6 +204,8 @@ static inline void task_state(struct seq
 		cred->uid, cred->euid, cred->suid, cred->fsuid,
 		cred->gid, cred->egid, cred->sgid, cred->fsgid);
 
+	task_children(m, p, ns);
+
 	task_lock(p);
 	if (p->files)
 		fdt = files_fdtable(p->files);


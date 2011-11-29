Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809Ab1K2TRa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 14:17:30 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45721 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367Ab1K2TR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 14:17:28 -0500
Message-Id: <20111129191638.835932727@openvz.org>
User-Agent: quilt/0.48-1
Date: Tue, 29 Nov 2011 23:12:54 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [rfc 2/3] fs, proc: Introduce the Children: line in /proc/<pid>/status
References: <20111129191252.769160532@openvz.org>
Content-Disposition: inline; filename=fs-proc-Introduce-the-Children-line-in-proc-pid-stat
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Emelyanov <xemul@parallels.com>

There is no easy way to make a reverse parent->children chain
from the task status, in turn children->parent provided with "PPid"
field.

So instead of walking over all pids in system to figure out what
children the task have -- we add explicit "Children" member to
/proc/<pid>/status since kernel already knows this kind of information
but it was not yet exported.

Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 fs/proc/array.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -158,6 +158,18 @@ static inline const char *get_task_state(struct task_struct *tsk)
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
@@ -192,6 +204,8 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 		cred->uid, cred->euid, cred->suid, cred->fsuid,
 		cred->gid, cred->egid, cred->sgid, cred->fsgid);
 
+	task_children(m, p, ns);
+
 	task_lock(p);
 	if (p->files)
 		fdt = files_fdtable(p->files);
-- 
1.7.7.3



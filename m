Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab1LAJym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 04:54:42 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35047 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab1LAJyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 04:54:40 -0500
Date: Thu, 1 Dec 2011 13:54:34 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [rfc 2/3] fs, proc: Introduce the Children: line in
 /proc/<pid>/status
Message-ID: <20111201095434.GR14515@moon>
References: <20111129191252.769160532@openvz.org>
 <20111129191638.835932727@openvz.org>
 <20111130140009.1ccd5af0.kamezawa.hiroyu@jp.fujitsu.com>
 <20111130060537.GK1775@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111130060537.GK1775@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 10:05:37AM +0400, Cyrill Gorcunov wrote:
> On Wed, Nov 30, 2011 at 02:00:09PM +0900, KAMEZAWA Hiroyuki wrote:
> > On Tue, 29 Nov 2011 23:12:54 +0400
> > Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> > 
> > > From: Pavel Emelyanov <xemul@parallels.com>
> > > 
> > > There is no easy way to make a reverse parent->children chain
> > > from the task status, in turn children->parent provided with "PPid"
> > > field.
> > > 
> > > So instead of walking over all pids in system to figure out what
> > > children the task have -- we add explicit "Children" member to
> > > /proc/<pid>/status since kernel already knows this kind of information
> > > but it was not yet exported.
> > > 
> > > Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
> > > Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
> > > Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> > 
> > I may be too pessimistic but what amount of overhead will this add to
> > ps -elf/ top ? Assuming an environment 'ps -elf' is called once per a sec,
> > if there are 2000 processes, task_list lock is taken 2000 times by this patch.
> > 
> 
> Hi Kame, good point! Yes, it introduces latency on high loaded systems.
> I must admit I tested this patch on a regular system, where not that much
> processes were launched but technically I think more correct would be to
> switch to children file. I'll tune up the patch. Thanks!
> 
> > Isn't it better to add /proc/<pid>/children file or dir (as task)?
> > 
> > Thanks,
> > -Kame
> > 

What about this one?
---
fs, proc: Introduce the /proc/<pid>/children entry

There is no easy way to make a reverse parent->children chain
from the task status, in turn children->parent provided with "PPid"
field.

So instead of walking over all pids in system to figure out what
children the task have -- we add explicit /proc/<pid>/children entry,
since kernel already knows this kind of information but it was not
yet exported.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 fs/proc/array.c    |   14 ++++++++++++++
 fs/proc/base.c     |    1 +
 fs/proc/internal.h |    3 +++
 3 files changed, 18 insertions(+)

Index: linux-2.6.git/fs/proc/array.c
===================================================================
--- linux-2.6.git.orig/fs/proc/array.c
+++ linux-2.6.git/fs/proc/array.c
@@ -547,3 +547,17 @@ int proc_pid_statm(struct seq_file *m, s
 
 	return 0;
 }
+
+int proc_pid_children(struct seq_file *m, struct pid_namespace *ns,
+		      struct pid *pid, struct task_struct *task)
+{
+	struct task_struct *c;
+
+	read_lock(&tasklist_lock);
+	list_for_each_entry(c, &task->children, sibling)
+		seq_printf(m, " %d", pid_nr_ns(task_pid(c), ns));
+	read_unlock(&tasklist_lock);
+	seq_putc(m, '\n');
+
+	return 0;
+}
Index: linux-2.6.git/fs/proc/base.c
===================================================================
--- linux-2.6.git.orig/fs/proc/base.c
+++ linux-2.6.git/fs/proc/base.c
@@ -3204,6 +3204,7 @@ static const struct pid_entry tgid_base_
 	INF("cmdline",    S_IRUGO, proc_pid_cmdline),
 	ONE("stat",       S_IRUGO, proc_tgid_stat),
 	ONE("statm",      S_IRUGO, proc_pid_statm),
+	ONE("children",   S_IRUGO, proc_pid_children),
 	REG("maps",       S_IRUGO, proc_maps_operations),
 #ifdef CONFIG_NUMA
 	REG("numa_maps",  S_IRUGO, proc_numa_maps_operations),
Index: linux-2.6.git/fs/proc/internal.h
===================================================================
--- linux-2.6.git.orig/fs/proc/internal.h
+++ linux-2.6.git/fs/proc/internal.h
@@ -51,6 +51,9 @@ extern int proc_pid_status(struct seq_fi
 				struct pid *pid, struct task_struct *task);
 extern int proc_pid_statm(struct seq_file *m, struct pid_namespace *ns,
 				struct pid *pid, struct task_struct *task);
+extern int proc_pid_children(struct seq_file *m, struct pid_namespace *ns,
+			     struct pid *pid, struct task_struct *task);
+
 extern loff_t mem_lseek(struct file *file, loff_t offset, int orig);
 
 extern const struct file_operations proc_maps_operations;

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab2BOUZo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 15:25:44 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53402 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755022Ab2BOUZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 15:25:43 -0500
Date: Thu, 16 Feb 2012 00:25:38 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Vasiliy Kulikov <segoon@openwall.com>, Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Valdis.Kletnieks@vt.edu,
        Michal Marek <mmarek@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: + syscalls-x86-add-__nr_kcmp-syscall-v8.patch added to -mm tree
Message-ID: <20120215202538.GK4533@moon>
References: <20120215143606.GA14037@redhat.com>
 <20120215151008.GL1894@moon>
 <20120215153816.GA15988@redhat.com>
 <20120215161329.GM1894@moon>
 <20120215162222.GA18266@redhat.com>
 <20120215175319.GG4533@moon>
 <20120215184336.GA24182@redhat.com>
 <20120215195610.GJ4533@moon>
 <20120215195733.GA8021@albatros>
 <20120215200533.GQ1894@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120215200533.GQ1894@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 12:05:33AM +0400, Cyrill Gorcunov wrote:
> On Wed, Feb 15, 2012 at 11:57:33PM +0400, Vasiliy Kulikov wrote:
> > > 
> > > This makes me scratch the head ;) I think ptrace_may_access (or
> > > some other security test) should remain since it's somehow weird
> > > if non-root task will be able to find objects order from privileged
> > > task. Thus I need to find a way how to handle execve(setuid_app).
> > > Need to think...
> > 
> > Look at fs/proc/base.c:lock_trace() - it locks ->cred_guard_mutex
> > for the whole period of time when it uses a resource.
> 
> Yup, thanks Vasiliy! I've just found cred_guard_mutex in
> install_exec_creds. Now I'm thinking if this is what we
> need here ;)
> 

Something like below I think (not yet tested, overall update).

	Cyrill
---
diff -u linux-2.6.git/kernel/kcmp.c linux-2.6.git/kernel/kcmp.c
--- linux-2.6.git/kernel/kcmp.c
+++ linux-2.6.git/kernel/kcmp.c
@@ -44,20 +44,34 @@
 static struct file *
 get_file_raw_ptr(struct task_struct *task, unsigned int idx)
 {
-	struct fdtable *fdt;
-	struct file *file;
+	struct file *file = NULL;
 
-	spin_lock(&task->files->file_lock);
-	fdt = files_fdtable(task->files);
-	if (idx < fdt->max_fds)
-		file = fdt->fd[idx];
-	else
-		file = NULL;
-	spin_unlock(&task->files->file_lock);
+	task_lock(task);
+	rcu_read_lock();
+
+	if (task->files)
+		file = fcheck_files(task->files, idx);
+
+	rcu_read_unlock();
+	task_unlock(task);
 
 	return file;
 }
 
+static int may_access(struct task_struct *task)
+{
+	int err = mutex_lock_killable(&task->signal->cred_guard_mutex);
+	if (err)
+		return err;
+
+	if (!ptrace_may_access(task, PTRACE_MODE_READ)) {
+		mutex_unlock(&task->signal->cred_guard_mutex);
+		return -EPERM;
+	}
+
+	return 0;
+}
+
 SYSCALL_DEFINE5(kcmp, pid_t, pid1, pid_t, pid2, int, type,
 		unsigned long, idx1, unsigned long, idx2)
 {
@@ -82,11 +96,12 @@
 	/*
 	 * One should have enough rights to inspect task details.
 	 */
-	if (!ptrace_may_access(task1, PTRACE_MODE_READ) ||
-	    !ptrace_may_access(task2, PTRACE_MODE_READ)) {
-		ret = -EACCES;
+	ret = may_access(task1);
+	if (ret)
 		goto err;
-	}
+	ret = may_access(task2);
+	if (ret)
+		goto err_unlock;
 
 	switch (type) {
 	case KCMP_FILE: {
@@ -130,6 +145,9 @@
 		break;
 	}
 
+	mutex_unlock(&task2->signal->cred_guard_mutex);
+err_unlock:
+	mutex_unlock(&task1->signal->cred_guard_mutex);
 err:
 	put_task_struct(task1);
 	put_task_struct(task2);


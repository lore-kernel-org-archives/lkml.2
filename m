Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789Ab2BOV6N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 16:58:13 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40309 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304Ab2BOV6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 16:58:11 -0500
Date: Thu, 16 Feb 2012 01:58:07 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Vasiliy Kulikov <segoon@openwall.com>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
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
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: + syscalls-x86-add-__nr_kcmp-syscall-v8.patch added to -mm tree
Message-ID: <20120215215807.GM4533@moon>
References: <20120215153816.GA15988@redhat.com>
 <20120215161329.GM1894@moon>
 <20120215162222.GA18266@redhat.com>
 <20120215175319.GG4533@moon>
 <20120215184336.GA24182@redhat.com>
 <20120215195610.GJ4533@moon>
 <20120215195733.GA8021@albatros>
 <20120215200533.GQ1894@moon>
 <20120215202538.GK4533@moon>
 <20120215210934.GL4533@moon>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
In-Reply-To: <20120215210934.GL4533@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 16, 2012 at 01:09:34AM +0400, Cyrill Gorcunov wrote:
> On Thu, Feb 16, 2012 at 12:25:38AM +0400, Cyrill Gorcunov wrote:
> > 
> > Something like below I think (not yet tested, overall update).
> >
> 
> OK, this one I've just tested. Please review, so I won't miss
> something obvious (I'm fetching linux-next now, if the patch
> is already there I'll cook one on top).
> ---

Unfortunately I dont see this patch in linux-next, so I cooked
it as interdiff'ed. Please review.

Maybe (if this patch is fine) we could drop v8 and I would
squash this changed into v9 (together with update to self
test)?

	Cyrill

--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=sys-kcmp-interdiff

From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: syscalls, x86: Fix __NR_kcmp execve race and potential NULL dereference

Plain ptrace_may_access() check used in kcmp is not safe
against race with execve(setuid_app), so we need to grab
cred_guard_mutex and keep it until kcmp is finished.

Also task->files may be nil, better to use task_lock
and fcheck_files helpers instead of direct file_lock
usage.

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
diff -u linux-2.6.git/kernel/kcmp.c linux-2.6.git/kernel/kcmp.c
--- linux-2.6.git/kernel/kcmp.c
+++ linux-2.6.git/kernel/kcmp.c
@@ -44,20 +44,38 @@
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
 
+static void access_unlock(struct task_struct *task)
+{
+	mutex_unlock(&task->signal->cred_guard_mutex);
+}
+
+static int access_trylock(struct task_struct *task)
+{
+	if (!mutex_trylock(&task->signal->cred_guard_mutex))
+		return -EBUSY;
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
@@ -82,11 +100,12 @@
 	/*
 	 * One should have enough rights to inspect task details.
 	 */
-	if (!ptrace_may_access(task1, PTRACE_MODE_READ) ||
-	    !ptrace_may_access(task2, PTRACE_MODE_READ)) {
-		ret = -EACCES;
+	ret = access_trylock(task1);
+	if (ret)
 		goto err;
-	}
+	ret = access_trylock(task2);
+	if (ret)
+		goto err_unlock;
 
 	switch (type) {
 	case KCMP_FILE: {
@@ -130,6 +149,9 @@
 		break;
 	}
 
+	access_unlock(task2);
+err_unlock:
+	access_unlock(task1);
 err:
 	put_task_struct(task1);
 	put_task_struct(task2);

--HlL+5n6rz5pIUxbD--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396Ab2BPQtK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 11:49:10 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55808 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab2BPQtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 11:49:07 -0500
Date: Thu, 16 Feb 2012 20:49:01 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Oleg Nesterov <oleg@redhat.com>, Vasiliy Kulikov <segoon@openwall.com>,
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
Message-ID: <20120216164901.GD3849@moon>
References: <20120215175319.GG4533@moon>
 <20120215184336.GA24182@redhat.com>
 <20120215195610.GJ4533@moon>
 <20120215195733.GA8021@albatros>
 <20120215200533.GQ1894@moon>
 <20120215202538.GK4533@moon>
 <20120215210934.GL4533@moon>
 <20120215215807.GM4533@moon>
 <20120216144954.GA11953@redhat.com>
 <20120216151340.GI1905@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120216151340.GI1905@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 07:13:40PM +0400, Cyrill Gorcunov wrote:
...
> 
> > You could simply do
> > 	int mutex_double_lock_killable(struct mutex *m1, struct mutex *m2)
> > 	{
> > 		int err;
> > 
> > 		if (m2 > m1)
> > 			swap(m1, m2);
> > 
> > 		err = mutex_lock_killable(m1);
> > 
> > 		if (!err && likely(m1 != m2)) {
> > 			err = mutex_lock_killable_nested(m2);
> > 			if (err)
> > 				mutex_unlock(m1);
> > 		}
> > 
> > 		return err;
> > 	}
> > 
> > but I won't insist.
> 
> Initially I wanted kcmp would be brining minimum impact
> and if mutex is already taken by someone, we would not sleep
> but return immediately with -EBUSY and it would be up to caller
> to deside if to try again or make some delay first. I simply
> not sure what is better here.
> 
This one should do the trick.

	Cyrill
---
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: syscalls, x86: Make __NR_kcmp to work with equivalent pids

In case if pid1 is equal to pid2 the kcmp will return -EBUSY,
which makes no sence. Make it able to work with equivalent pids.
Selftest is extended as well.

Repored-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
diff -u linux-2.6.git/kernel/kcmp.c linux-2.6.git/kernel/kcmp.c
--- linux-2.6.git/kernel/kcmp.c
+++ linux-2.6.git/kernel/kcmp.c
@@ -58,22 +58,31 @@
 	return file;
 }
 
-static void access_unlock(struct task_struct *task)
+static void kcmp_unlock(struct mutex *m1, struct mutex *m2)
 {
-	mutex_unlock(&task->signal->cred_guard_mutex);
+	if (m2 > m1)
+		swap(m1, m2);
+
+	if (likely(m2 != m1))
+		mutex_unlock(m2);
+	mutex_unlock(m1);
 }
 
-static int access_trylock(struct task_struct *task)
+static int kcmp_lock(struct mutex *m1, struct mutex *m2)
 {
-	if (!mutex_trylock(&task->signal->cred_guard_mutex))
-		return -EBUSY;
+	int err;
+
+	if (m2 > m1)
+		swap(m1, m2);
 
-	if (!ptrace_may_access(task, PTRACE_MODE_READ)) {
-		mutex_unlock(&task->signal->cred_guard_mutex);
-		return -EPERM;
+	err = mutex_lock_killable(m1);
+	if (!err && likely(m1 != m2)) {
+		err = mutex_lock_killable_nested(m2, SINGLE_DEPTH_NESTING);
+		if (err)
+			mutex_unlock(m1);
 	}
 
-	return 0;
+	return err;
 }
 
 SYSCALL_DEFINE5(kcmp, pid_t, pid1, pid_t, pid2, int, type,
@@ -100,12 +109,15 @@
 	/*
 	 * One should have enough rights to inspect task details.
 	 */
-	ret = access_trylock(task1);
+	ret = kcmp_lock(&task1->signal->cred_guard_mutex,
+			&task2->signal->cred_guard_mutex);
 	if (ret)
 		goto err;
-	ret = access_trylock(task2);
-	if (ret)
+	if (!ptrace_may_access(task1, PTRACE_MODE_READ) ||
+	    !ptrace_may_access(task2, PTRACE_MODE_READ)) {
+		ret = -EPERM;
 		goto err_unlock;
+	}
 
 	switch (type) {
 	case KCMP_FILE: {
@@ -149,9 +161,9 @@
 		break;
 	}
 
-	access_unlock(task2);
 err_unlock:
-	access_unlock(task1);
+	kcmp_unlock(&task1->signal->cred_guard_mutex,
+		    &task2->signal->cred_guard_mutex);
 err:
 	put_task_struct(task1);
 	put_task_struct(task2);
diff -u linux-2.6.git/tools/testing/selftests/kcmp/kcmp_test.c linux-2.6.git/tools/testing/selftests/kcmp/kcmp_test.c
--- linux-2.6.git/tools/testing/selftests/kcmp/kcmp_test.c
+++ linux-2.6.git/tools/testing/selftests/kcmp/kcmp_test.c
@@ -74,6 +74,15 @@
 			ret = -1;
 		} else
 			printf("PASS: 0 returned as expected\n");
+
+		/* Compare with self */
+		ret = sys_kcmp(pid1, pid1, KCMP_VM, 0, 0);
+		if (ret) {
+			printf("FAIL: 0 expected but %li returned\n", ret);
+			ret = -1;
+		} else
+			printf("PASS: 0 returned as expected\n");
+
 		exit(ret);
 	}
 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444Ab1BELm5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 06:42:57 -0500
Received: from eru.sfritsch.de ([188.40.99.202]:46888 "EHLO eru.sfritsch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792Ab1BELm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 06:42:56 -0500
Date: Sat, 5 Feb 2011 12:42:45 +0100 (CET)
From: Stefan Fritsch <sf@sfritsch.de>
X-X-Sender: stf@eru.sfritsch.de
To: Eric Paris <eparis@redhat.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Eric Paris <eparis@parisplace.org>, linux-kernel@vger.kernel.org,
        agl@google.com, tzanussi@gmail.com, Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        2nddept-manager@sdl.hitachi.co.jp,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Using ftrace/perf as a basis for generic seccomp
In-Reply-To: <1296837393.3145.80.camel@localhost.localdomain>
Message-ID: <alpine.DEB.1.10.1102051226110.26628@eru.sfritsch.de>
References: <1294867725.3237.230.camel@localhost.localdomain>  <1296665124.3145.17.camel@localhost.localdomain>  <20110203190643.GC1769@nowhere> <201102032306.34251.sf@sfritsch.de> <1296837393.3145.80.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Feb 2011, Eric Paris wrote:
> On Thu, 2011-02-03 at 23:06 +0100, Stefan Fritsch wrote:
>> - only allow syscalls in the mode (non-compat/compat) that the prctl
>> call was made in
>
> This is what I was thinking.  If it was a compat task when it dropped
> things from the set of syscalls we should implicitly deny all non-compat
> syscalls, and vice versa.

I have attached my modified version of Adam's patch which alread does that 
below. It has a few other modification because I first tried to have two 
separate bitmasks for native and compat. But maybe it is still useful for 
you.

>> - deny exec of setuid/setgid binaries
>> - deny exec of binaries with filesystem capabilities
>
> I think both of these are wrong to try to address here.  The right way
> to handle these is to
>
> 1) set prctl(SECBIT_NOROOT)
> 2) drop all caps from the bset, pP, pE, and pI
> 3) make sure the setuid(2) syscall (not to be confused with SETUID
> filesystem bit) is not in the set of allowed syscalls.  Thus rendering
> suid and file with fcaps irrelevant.

I think that's a bad idea. Some programs may get confused if run as root 
but without capabilities (think sendmail). If a setuid root binary gets 
confused enough to write arbitrary files as root, you get all capabilities 
again by writing to /etc/crontab or /root/.ssh/authorized_keys. I admit 
that this is very unlikely if setuid(2)/setgid(2) lead to the process 
being killed, but better to be save and disallow the user change for 
SETUID binaries completely. And the simplest way to do that seemed to me 
to disallow exec'ing of SETUID binaries.

Cheers,
Stefan






diff --git a/fs/exec.c b/fs/exec.c
index c62efcb..be6e3c5 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1219,6 +1219,10 @@ int prepare_binprm(struct linux_binprm *bprm)
  	if (!(bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)) {
  		/* Set-uid? */
  		if (mode & S_ISUID) {
+#ifdef CONFIG_SECCOMP
+			if (unlikely(test_thread_flag(TIF_SECCOMP)))
+				return -EPERM; /* XXX: KILL instead? */
+#endif
  			bprm->per_clear |= PER_CLEAR_ON_SETID;
  			bprm->cred->euid = inode->i_uid;
  		}
@@ -1230,6 +1234,10 @@ int prepare_binprm(struct linux_binprm *bprm)
  		 * executable.
  		 */
  		if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP)) {
+#ifdef CONFIG_SECCOMP
+			if (unlikely(test_thread_flag(TIF_SECCOMP)))
+				return -EPERM; /* XXX: KILL instead? */
+#endif
  			bprm->per_clear |= PER_CLEAR_ON_SETID;
  			bprm->cred->egid = inode->i_gid;
  		}
diff --git a/fs/proc/array.c b/fs/proc/array.c
index fff6572..6d4f296 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -337,6 +337,30 @@ static void task_cpus_allowed(struct seq_file *m, struct task_struct *task)
  	seq_printf(m, "\n");
  }

+extern const char hex_asc[];
+
+static void task_show_seccomp(struct seq_file *m, struct task_struct *p) {
+#if defined(CONFIG_SECCOMP)
+	const int mode = p->seccomp.state ? p->seccomp.state->mode : 0;
+	unsigned i;
+
+	seq_printf(m, "Seccomp:\t%d\n", mode);
+	if (mode != 2)
+		return;
+	seq_printf(m, "Seccomp_mask:\t%d,", p->seccomp.state->bitlen);
+	for (i = 0; i < (p->seccomp.state->bitlen + 7) / 8; ++i) {
+		const uint8_t *mask = p->seccomp.state->bitmask;
+		seq_printf(m, "%c%c", hex_asc[mask[i] >> 4],
+		           hex_asc[mask[i] & 15]);
+	}
+#ifdef CONFIG_COMPAT
+	if (p->seccomp.state->is_compat)
+		seq_printf(m, ", compat");
+#endif
+	seq_printf(m, "\n");
+#endif
+}
+
  int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
  			struct pid *pid, struct task_struct *task)
  {
@@ -357,6 +381,7 @@ int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
  	task_show_regs(m, task);
  #endif
  	task_context_switch_counts(m, task);
+	task_show_seccomp(m, task);
  	return 0;
  }

diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
index 167c333..10ffe22 100644
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -7,7 +7,32 @@
  #include <linux/thread_info.h>
  #include <asm/seccomp.h>

-typedef struct { int mode; } seccomp_t;
+/**
+ * struct seccomp_state - the state of a seccomp'ed process
+ *
+ * @mode:
+ *     if this is 1, the process is under standard seccomp rules
+ *             is 2, the process is only allowed to make system calls where
+ *                   the corresponding bit is set in bitmask and the syscall
+ *                   is made in the compat/no-compat mode corresponding to
+ *                   the is_compat member.
+ * @bitlen: the length of bitmask, in bits.
+ * @bitmask: a mask of allowed system calls.
+ * @refs: reference count
+ * @flags: unused
+ */
+struct seccomp_state {
+	uint8_t *bitmask;
+	int bitlen;
+	int flags;
+#ifdef CONFIG_COMPAT
+	int is_compat;
+#endif
+	int mode;
+	atomic_t refs;
+};
+
+typedef struct { struct seccomp_state *state; } seccomp_t;

  extern void __secure_computing(int);
  static inline void secure_computing(int this_syscall)
@@ -16,8 +41,10 @@ static inline void secure_computing(int this_syscall)
  		__secure_computing(this_syscall);
  }

+extern struct seccomp_state* seccomp_state_get(struct seccomp_state *s);
+extern void seccomp_state_put(struct seccomp_state *s);
  extern long prctl_get_seccomp(void);
-extern long prctl_set_seccomp(unsigned long);
+extern long prctl_set_seccomp(unsigned long, unsigned long, unsigned long, unsigned long);

  #else /* CONFIG_SECCOMP */

@@ -32,7 +59,8 @@ static inline long prctl_get_seccomp(void)
  	return -EINVAL;
  }

-static inline long prctl_set_seccomp(unsigned long arg2)
+static inline long prctl_set_seccomp(unsigned long arg2, unsigned long arg3,
+				     unsigned long arg4, unsigned long arg5)
  {
  	return -EINVAL;
  }
diff --git a/kernel/fork.c b/kernel/fork.c
index 5447dc7..01f7210 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -34,6 +34,7 @@
  #include <linux/cgroup.h>
  #include <linux/security.h>
  #include <linux/hugetlb.h>
+#include <linux/seccomp.h>
  #include <linux/swap.h>
  #include <linux/syscalls.h>
  #include <linux/jiffies.h>
@@ -162,6 +163,10 @@ void free_task(struct task_struct *tsk)
  	free_thread_info(tsk->stack);
  	rt_mutex_debug_task_free(tsk);
  	ftrace_graph_exit_task(tsk);
+#ifdef CONFIG_SECCOMP
+	if (tsk->seccomp.state)
+		seccomp_state_put(tsk->seccomp.state);
+#endif
  	free_task_struct(tsk);
  }
  EXPORT_SYMBOL(free_task);
@@ -271,6 +276,11 @@ static struct task_struct *dup_task_struct(struct task_struct *orig)
  	if (err)
  		goto out;

+#ifdef CONFIG_SECCOMP
+	if (orig->seccomp.state)
+		tsk->seccomp.state = seccomp_state_get(orig->seccomp.state);
+#endif
+
  	setup_thread_stack(tsk, orig);
  	clear_user_return_notifier(tsk);
  	clear_tsk_need_resched(tsk);
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 57d4b13..d5920d0 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -9,9 +9,10 @@
  #include <linux/seccomp.h>
  #include <linux/sched.h>
  #include <linux/compat.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>

  /* #define SECCOMP_DEBUG 1 */
-#define NR_SECCOMP_MODES 1

  /*
   * Secure computing mode 1 allows only read/write/exit/sigreturn.
@@ -32,8 +33,8 @@ static int mode1_syscalls_32[] = {

  void __secure_computing(int this_syscall)
  {
-	int mode = current->seccomp.mode;
-	int * syscall;
+	int mode = current->seccomp.state->mode;
+	int *syscall;

  	switch (mode) {
  	case 1:
@@ -47,40 +48,175 @@ void __secure_computing(int this_syscall)
  				return;
  		} while (*++syscall);
  		break;
+	case 2:
+#ifdef CONFIG_COMPAT
+		if (unlikely(is_compat_task() !=
+			     current->seccomp.state->is_compat))
+			break;
+#endif
+		if (unlikely(this_syscall >= current->seccomp.state->bitlen))
+			break;
+	        if (likely(current->seccomp.state->bitmask[this_syscall / 8]
+				& (1 << (7 - (this_syscall % 8)))))
+			return;
+		break;
  	default:
  		BUG();
  	}

+#ifdef CONFIG_COMPAT
+	printk(KERN_WARNING "Killed by seccomp: syscall %d compat: %d/%d",
+		this_syscall, is_compat_task(),
+		current->seccomp.state->is_compat);
+#else
+	printk(KERN_WARNING "Killed by seccomp in syscall %d", this_syscall);
+#endif
+
  #ifdef SECCOMP_DEBUG
  	dump_stack();
  #endif
  	do_exit(SIGKILL);
  }

+void seccomp_state_put(struct seccomp_state *state)
+{
+	if (atomic_dec_and_test(&state->refs)) {
+		kfree(state->bitmask);
+		kfree(state);
+	}
+}
+
+struct seccomp_state *seccomp_state_get(struct seccomp_state *state)
+{
+	atomic_inc(&state->refs);
+	return state;
+}
+
+/* alloc mem for new bitmask and copy from user.
+ * Zero the unused bits int the last byte.
+ */
+static int new_bitmask_from_user(uint8_t **dst, unsigned long src,
+				 unsigned long bitlen)
+{
+	const int ubytes = (bitlen + 7) / 8;
+	const int ibits = bitlen % 8;
+	if (!bitlen)
+		*dst = NULL;
+	*dst = kmalloc(ubytes, GFP_KERNEL);
+	if (!*dst)
+		return -ENOMEM;
+	if (copy_from_user(*dst, (void __user *) src, ubytes)) {
+		kfree(*dst);
+		*dst = NULL;
+		return -EFAULT;
+	}
+	if (ibits)
+		(*dst)[ubytes-1] &= 0xff << (8 - (ibits));
+	return 0;
+}
+
+static int new_state_from_user(struct seccomp_state **state, unsigned long mask,
+			       unsigned long bitlen)
+{
+	int ret;
+	struct seccomp_state *new;
+	if (bitlen >= 1024)
+		return -EINVAL;
+	new = kmalloc(sizeof(struct seccomp_state), GFP_KERNEL);
+	if (!new)
+		return -ENOMEM;
+	atomic_set(&new->refs, 1);
+	new->mode = 2;
+	new->bitlen = bitlen;
+#ifdef CONFIG_COMPAT
+	new->is_compat = is_compat_task();
+#endif
+	ret = new_bitmask_from_user(&new->bitmask, mask, bitlen);
+	if (ret < 0)
+		goto error;
+	*state = new;
+	return 0;
+error:
+	kfree(new->bitmask);
+	kfree(new);
+	return ret;
+}
+
+
+static int mask_install(unsigned long mask, unsigned long bitlen)
+{
+	int ret = new_state_from_user(&current->seccomp.state, mask, bitlen);
+	if (ret < 0)
+		return ret;
+	set_thread_flag(TIF_SECCOMP);
+	return 0;
+}
+
+static int mask_replace(unsigned long mask, unsigned long bitlen)
+{
+	int ret, i;
+	struct seccomp_state *new;
+
+	if (bitlen > current->seccomp.state->bitlen)
+		bitlen = current->seccomp.state->bitlen;
+	ret = new_state_from_user(&new, mask, bitlen);
+	if (ret < 0)
+		return ret;
+
+	for (i = 0; i < (bitlen + 7)/8; ++i)
+		new->bitmask[i] &= current->seccomp.state->bitmask[i];
+
+	seccomp_state_put(current->seccomp.state);
+	current->seccomp.state = new;
+
+	return 0;
+}
+
  long prctl_get_seccomp(void)
  {
-	return current->seccomp.mode;
+	if (!current->seccomp.state)
+		return 0;
+	return current->seccomp.state->mode;
  }

-long prctl_set_seccomp(unsigned long seccomp_mode)
+long prctl_set_seccomp(unsigned long seccomp_mode,
+		       unsigned long seccomp_mask,
+		       unsigned long seccomp_bitlen,
+		       unsigned long seccomp_flags)
  {
-	long ret;
+	struct seccomp_state *new;

-	/* can set it only once to be even more secure */
-	ret = -EPERM;
-	if (unlikely(current->seccomp.mode))
-		goto out;
+	switch (seccomp_mode) {
+	case 0:
+		/* One cannot switch to mode 0 from any other mode */
+		if (current->seccomp.state)
+			return -EPERM;
+		return 0;

-	ret = -EINVAL;
-	if (seccomp_mode && seccomp_mode <= NR_SECCOMP_MODES) {
-		current->seccomp.mode = seccomp_mode;
+	case 1:
+		new = kmalloc(sizeof(struct seccomp_state), GFP_KERNEL);
+		if (!new)
+			return -ENOMEM;
+		memset(new, 0, sizeof(*new));
+		atomic_set(&new->refs, 1);
+		new->mode = 1;
+		if (current->seccomp.state)
+			seccomp_state_put(current->seccomp.state);
+		current->seccomp.state = new;
  		set_thread_flag(TIF_SECCOMP);
  #ifdef TIF_NOTSC
  		disable_TSC();
  #endif
-		ret = 0;
-	}
+		return 0;

- out:
-	return ret;
+	case 2:
+		/* System call bitmask */
+
+		if (current->seccomp.state)
+			return mask_replace(seccomp_mask, seccomp_bitlen);
+		return mask_install(seccomp_mask, seccomp_bitlen);
+
+	default:
+		return -EINVAL;
+	}
  }
diff --git a/kernel/sys.c b/kernel/sys.c
index 7f5a0cd..6cc1f91 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1667,7 +1667,7 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
  			error = prctl_get_seccomp();
  			break;
  		case PR_SET_SECCOMP:
-			error = prctl_set_seccomp(arg2);
+			error = prctl_set_seccomp(arg2, arg3, arg4, arg5);
  			break;
  		case PR_GET_TSC:
  			error = GET_TSC_CTL(arg2);

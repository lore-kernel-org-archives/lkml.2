Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535Ab2AXVW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 16:22:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37845 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756653Ab2AXVWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 16:22:24 -0500
Date: Tue, 24 Jan 2012 13:22:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Matt Helsley <matthltc@us.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [patch 2/4] [RFC] syscalls, x86: Add __NR_kcmp syscall v4
Message-Id: <20120124132222.d78bc0d4.akpm@linux-foundation.org>
In-Reply-To: <20120124205039.GB2278@moon>
References: <20120124064719.GA29735@moon>
	<4F1E57F3.6020607@zytor.com>
	<20120124071716.GC29735@moon>
	<20120124162031.a3956058.kamezawa.hiroyu@jp.fujitsu.com>
	<20120124073842.GE29735@moon>
	<20120124164008.aa1714bd.kamezawa.hiroyu@jp.fujitsu.com>
	<20120124084823.GF29735@moon>
	<CAHGf_=r=zwj4=yjCekYZVRsTwjohJ8F8cP4rnZx6UL9kKNTc+g@mail.gmail.com>
	<20120124202606.GC2546@moon>
	<m18vkwj0dw.fsf@fess.ebiederm.org>
	<20120124205039.GB2278@moon>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jan 2012 00:50:39 +0400
Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> This one should fit all requirements I guess.

[wakes up]

> While doing the checkpoint-restore in the userspace one need to determine
> whether various kernel objects (like mm_struct-s of file_struct-s) are shared
> between tasks and restore this state.
> 
> The 2nd step can be solved by using appropriate CLONE_ flags and the unshare
> syscall, while there's currently no ways for solving the 1st one.
> 
> One of the ways for checking whether two tasks share e.g. mm_struct is to
> provide some mm_struct ID of a task to its proc file, but showing such
> info considered to be not that good for security reasons.
> 
> Thus after some debates we end up in conclusion that using that named
> 'comparision' syscall might be the best candidate. So here is it --
> __NR_kcmp.
> 
> It takes up to 5 agruments - the pids of the two tasks (which
> characteristics should be compared), the comparision type and
> (in case of comparision of files) two file descriptors.

PIDs are not unique.  One wonders what happens in this syscall if the
same pid appears in two namespaces.

<reads the code>

Seems that it performs lookups only in the caller's PID namespace. 
Maybe this is appropriate but it should be described and justified in
the changelog and in code comments, please.  And in the forthcoming
manpage ;)

> At moment only x86 is supported.

Presumably you have a test app.  Please let's include that app in
tools/testing/selftests/ for arch maintainers and others to use and
maintain.

>
> ...
>
> --- /dev/null
> +++ linux-2.6.git/kernel/kcmp.c
> @@ -0,0 +1,163 @@
> +#include <linux/kernel.h>
> +#include <linux/syscalls.h>
> +#include <linux/fdtable.h>
> +#include <linux/string.h>
> +#include <linux/random.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/cache.h>
> +#include <linux/bug.h>
> +#include <linux/err.h>
> +#include <linux/kcmp.h>
> +
> +#include <asm/unistd.h>
> +
> +static unsigned long cookies[KCMP_TYPES][2] __read_mostly;

This reader of this code doesn't understand why all this cookie stuff
is in here.  Please include code comments which explain the reason for
the existence of this code.

> +static long kptr_obfuscate(long v, int type)
> +{
> +	return (v ^ cookies[type][0]) * cookies[type][1];
> +}
> +
> +/*
> + * 0 - equal
> + * 1 - less than
> + * 2 - greater than
> + * 3 - not equal but ordering unavailable

what the heck does case 3 mean?  Why is it here?

> + */
> +static int kcmp_ptr(long v1, long v2, int type)
> +{
> +	long ret;
> +
> +	ret = kptr_obfuscate(v1, type) - kptr_obfuscate(v2, type);
> +
> +	return (ret < 0) | ((ret > 0) << 1);
> +}
> +
> +#define KCMP_TASK_PTR(task1, task2, member, type)	\
> +	kcmp_ptr((long)(task1)->member,			\
> +		 (long)(task2)->member,			\
> +		 type)
> +
> +#define KCMP_PTR(ptr1, ptr2, type)			\
> +	kcmp_ptr((long)ptr1, (long)ptr2, type)

ugh.  This:

static long kptr_obfuscate(void *p, enum you_forgot_to_name_the_enum type)
{
	return ((long)p ^ cookies[type][0]) * cookies[type][1];
}

static int kcmp_task_pointers(void *task1, void *task2, size_t field_offset,
				enum you_forgot_to_name_the_enum type)
{
	void **field1 = t1 + field_offset;	/* points to a pointer in the task_struct */
	void **field2 = t1 + field_offset;
	long diff;

	diff = kptr_obfuscate(*field1, type) - kptr_obfuscate(*field2, type);
	return (diff < 0) | ((diff > 0) << 1);
}

	...
	ret = kcmp_task_pointers(task1, task2, offsetof(task_struct, mm),
				KCMP_VM);
	...

see?  No nasty macros, it's type-correct and it uses only a single
explicit typecast.

> +/* A caller must be sure the task is presented in memory */

"The caller must have pinned the task"

> +static struct file *
> +get_file_raw_ptr(struct task_struct *task, unsigned int idx)
> +{
> +	struct fdtable *fdt;
> +	struct file *file;
> +
> +	spin_lock(&task->files->file_lock);
> +	fdt = files_fdtable(task->files);
> +	if (idx < fdt->max_fds)
> +		file = fdt->fd[idx];
> +	else
> +		file = NULL;
> +	spin_unlock(&task->files->file_lock);
> +
> +	return file;
> +}
> +
> +SYSCALL_DEFINE5(kcmp, pid_t, pid1, pid_t, pid2, int, type,
> +		unsigned long, idx1, unsigned long, idx2)
> +{
> +	struct task_struct *task1;
> +	struct task_struct *task2;
> +	int ret = 0;
> +
> +	rcu_read_lock();
> +
> +	task1 = find_task_by_vpid(pid1);
> +	if (!task1) {
> +		rcu_read_unlock();
> +		return -ESRCH;
> +	}
> +
> +	task2 = find_task_by_vpid(pid2);
> +	if (!task2) {
> +		put_task_struct(task1);
> +		rcu_read_unlock();
> +		return -ESRCH;
> +	}
> +
> +	get_task_struct(task1);
> +	get_task_struct(task2);
> +
> +	rcu_read_unlock();
> +
> +	if (!ptrace_may_access(task1, PTRACE_MODE_READ) ||
> +	    !ptrace_may_access(task2, PTRACE_MODE_READ)) {

Add a comment explaining this decision.

> +		ret = -EACCES;
> +		goto err;
> +	}
> +
> +	/*
> +	 * Note for all cases but the KCMP_FILE we
> +	 * don't take any locks in a sake of speed.
> +	 */
> +
> +	switch (type) {
> +	case KCMP_FILE: {
> +		struct file *filp1, *filp2;
> +
> +		filp1 = get_file_raw_ptr(task1, idx1);
> +		filp2 = get_file_raw_ptr(task2, idx2);
> +
> +		if (filp1 && filp2)
> +			ret = KCMP_PTR(filp1, filp2, KCMP_FILE);
> +		else
> +			ret = -ENOENT;
> +		break;
> +	}
> +	case KCMP_VM:
> +		ret = KCMP_TASK_PTR(task1, task2, mm, KCMP_VM);
> +		break;
> +	case KCMP_FILES:
> +		ret = KCMP_TASK_PTR(task1, task2, files, KCMP_FILES);
> +		break;
> +	case KCMP_FS:
> +		ret = KCMP_TASK_PTR(task1, task2, fs, KCMP_FS);
> +		break;
> +	case KCMP_SIGHAND:
> +		ret = KCMP_TASK_PTR(task1, task2, sighand, KCMP_SIGHAND);
> +		break;
> +	case KCMP_IO:
> +		ret = KCMP_TASK_PTR(task1, task2, io_context, KCMP_IO);
> +		break;
> +	case KCMP_SYSVSEM:
> +#ifdef CONFIG_SYSVIPC
> +		ret = KCMP_TASK_PTR(task1, task2, sysvsem.undo_list, KCMP_SYSVSEM);
> +#else
> +		ret = -ENOENT;

ENOENT seems inappropriate here.

> +		goto err;
> +#endif
> +		break;
> +	default:
> +		ret = -EINVAL;
> +		goto err;
> +	}
> +
> +err:
> +	put_task_struct(task1);
> +	put_task_struct(task2);
> +
> +	return ret;
> +}
> +
> +static __init int kcmp_cookie_init(void)
> +{
> +	int i, j;
> +
> +	for (i = 0; i < KCMP_TYPES; i++) {
> +		for (j = 0; j < 2; j++) {
> +			get_random_bytes(&cookies[i][j],
> +					 sizeof(cookies[i][j]));
> +		}
> +		cookies[i][1] |= (~(~0UL >>  1) | 1);

hm, what's the point in writing a random number to cookies[i][1] and
then immediately overwriting that with a constant?

> +	}
> +
> +	return 0;
> +}
> +late_initcall(kcmp_cookie_init);

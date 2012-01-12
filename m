Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407Ab2ALQy2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 11:54:28 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41029 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293Ab2ALQyU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 11:54:20 -0500
MIME-Version: 1.0
In-Reply-To: <20120112085316.GB16518@peqn>
References: <1326302710-9427-1-git-send-email-wad@chromium.org>
	<1326302710-9427-2-git-send-email-wad@chromium.org>
	<20120112085316.GB16518@peqn>
Date: Thu, 12 Jan 2012 10:54:16 -0600
Message-ID: <CABqD9ha6aX+LQ7B3T1HA-5XB-Uc_UWhLPiCsGDS3BxCFc_Pkrg@mail.gmail.com>
Subject: Re: [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF
From: Will Drewry <wad@chromium.org>
To: Serge Hallyn <serge.hallyn@canonical.com>
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, scarybeasts@gmail.com,
        avi@redhat.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk,
        luto@mit.edu, mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, amwang@redhat.com, oleg@redhat.com,
        ak@linux.intel.com, eric.dumazet@gmail.com, gregkh@suse.de,
        dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 2:53 AM, Serge Hallyn
<serge.hallyn@canonical.com> wrote:
> Quoting Will Drewry (wad@chromium.org):
>> This patch adds support for seccomp mode 2.  This mode enables dynamic
>> enforcement of system call filtering policy in the kernel as specified
>> by a userland task.  The policy is expressed in terms of a BPF program,
>> as is used for userland-exposed socket filtering.  Instead of network
>> data, the BPF program is evaluated over struct user_regs_struct at the
>> time of the system call (as retrieved using regviews).
>>
>> A filter program may be installed by a userland task by calling
>>   prctl(PR_ATTACH_SECCOMP_FILTER, &fprog);
>> where fprog is of type struct sock_fprog.
>>
>> If the first filter program allows subsequent prctl(2) calls, then
>> additional filter programs may be attached.  All attached programs
>> must be evaluated before a system call will be allowed to proceed.
>>
>> To avoid CONFIG_COMPAT related landmines, once a filter program is
>> installed using specific is_compat_task() and current->personality, it
>> is not allowed to make system calls or attach additional filters which
>> use a different combination of is_compat_task() and
>> current->personality.
>>
>> Filter programs may _only_ cross the execve(2) barrier if last filter
>> program was attached by a task with CAP_SYS_ADMIN capabilities in its
>> user namespace.  Once a task-local filter program is attached from a
>> process without privileges, execve will fail.  This ensures that only
>> privileged parent task can affect its privileged children (e.g., setuid
>> binary).
>>
>> There are a number of benefits to this approach. A few of which are
>> as follows:
>> - BPF has been exposed to userland for a long time.
>> - Userland already knows its ABI: expected register layout and system
>>   call numbers.
>> - Full register information is provided which may be relevant for
>>   certain syscalls (fork, rt_sigreturn) or for other userland
>>   filtering tactics (checking the PC).
>> - No time-of-check-time-of-use vulnerable data accesses are possible.
>>
>> This patch includes its own BPF evaluator, but relies on the
>> net/core/filter.c BPF checking code.  It is possible to share
>> evaluators, but the performance sensitive nature of the network
>> filtering path makes it an iterative optimization which (I think :) can
>> be tackled separately via separate patchsets. (And at some point sharing
>> BPF JIT code!)
>>
>> Signed-off-by: Will Drewry <wad@chromium.org>
>
> Hey Will,
>
> A few comments below, but otherwise
>
> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

Thanks! Unimportant responses below.  Fixes will be incorporated in
the next round (along with Oleg's feedback).

cheers,
will

> thanks,
> -serge
>
>> ---
>>  fs/exec.c               |    5 +
>>  include/linux/prctl.h   |    3 +
>>  include/linux/seccomp.h |   70 +++++-
>>  kernel/Makefile         |    1 +
>>  kernel/fork.c           |    4 +
>>  kernel/seccomp.c        |    8 +
>>  kernel/seccomp_filter.c |  639 +++++++++++++++++++++++++++++++++++++++++++++++
>>  kernel/sys.c            |    4 +
>>  security/Kconfig        |   12 +
>>  9 files changed, 743 insertions(+), 3 deletions(-)
>>  create mode 100644 kernel/seccomp_filter.c
>>
>> diff --git a/fs/exec.c b/fs/exec.c
>> index 3625464..e9cc89c 100644
>> --- a/fs/exec.c
>> +++ b/fs/exec.c
>> @@ -44,6 +44,7 @@
>>  #include <linux/namei.h>
>>  #include <linux/mount.h>
>>  #include <linux/security.h>
>> +#include <linux/seccomp.h>
>>  #include <linux/syscalls.h>
>>  #include <linux/tsacct_kern.h>
>>  #include <linux/cn_proc.h>
>> @@ -1477,6 +1478,10 @@ static int do_execve_common(const char *filename,
>>       if (retval)
>>               goto out_ret;
>>
>> +     retval = seccomp_check_exec();
>> +     if (retval)
>> +             goto out_ret;
>> +
>>       retval = -ENOMEM;
>>       bprm = kzalloc(sizeof(*bprm), GFP_KERNEL);
>>       if (!bprm)
>> diff --git a/include/linux/prctl.h b/include/linux/prctl.h
>> index a3baeb2..15e2460 100644
>> --- a/include/linux/prctl.h
>> +++ b/include/linux/prctl.h
>> @@ -64,6 +64,9 @@
>>  #define PR_GET_SECCOMP       21
>>  #define PR_SET_SECCOMP       22
>>
>> +/* Set process seccomp filters */
>> +#define PR_ATTACH_SECCOMP_FILTER     36
>> +
>>  /* Get/set the capability bounding set (as per security/commoncap.c) */
>>  #define PR_CAPBSET_READ 23
>>  #define PR_CAPBSET_DROP 24
>> diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
>> index cc7a4e9..99d163e 100644
>> --- a/include/linux/seccomp.h
>> +++ b/include/linux/seccomp.h
>> @@ -5,9 +5,28 @@
>>  #ifdef CONFIG_SECCOMP
>>
>>  #include <linux/thread_info.h>
>> +#include <linux/types.h>
>>  #include <asm/seccomp.h>
>>
>> -typedef struct { int mode; } seccomp_t;
>> +struct seccomp_filter;
>> +/**
>> + * struct seccomp_struct - the state of a seccomp'ed process
>> + *
>> + * @mode:
>> + *     if this is 0, seccomp is not in use.
>> + *             is 1, the process is under standard seccomp rules.
>> + *             is 2, the process is only allowed to make system calls where
>> + *                   associated filters evaluate successfully.
>> + * @filter: Metadata for filter if using CONFIG_SECCOMP_FILTER.
>> + *          @filter must only be accessed from the context of current as there
>> + *          is no guard.
>> + */
>> +typedef struct seccomp_struct {
>> +     int mode;
>> +#ifdef CONFIG_SECCOMP_FILTER
>> +     struct seccomp_filter *filter;
>> +#endif
>> +} seccomp_t;
>>
>>  extern void __secure_computing(int);
>>  static inline void secure_computing(int this_syscall)
>> @@ -28,8 +47,7 @@ static inline int seccomp_mode(seccomp_t *s)
>>
>>  #include <linux/errno.h>
>>
>> -typedef struct { } seccomp_t;
>> -
>> +typedef struct seccomp_struct { } seccomp_t;
>>  #define secure_computing(x) do { } while (0)
>>
>>  static inline long prctl_get_seccomp(void)
>> @@ -49,4 +67,50 @@ static inline int seccomp_mode(seccomp_t *s)
>>
>>  #endif /* CONFIG_SECCOMP */
>>
>> +#ifdef CONFIG_SECCOMP_FILTER
>> +
>> +#define seccomp_filter_init_task(_tsk) do { \
>> +     (_tsk)->seccomp.filter = NULL; \
>> +} while (0);
>> +
>> +/* No locking is needed here because the task_struct will
>> + * have no parallel consumers.
>> + */
>> +#define seccomp_filter_free_task(_tsk) do { \
>> +     put_seccomp_filter((_tsk)->seccomp.filter); \
>> +} while (0);
>> +
>> +extern int seccomp_check_exec(void);
>> +
>> +extern long prctl_attach_seccomp_filter(char __user *);
>> +
>> +extern struct seccomp_filter *get_seccomp_filter(struct seccomp_filter *);
>> +extern void put_seccomp_filter(struct seccomp_filter *);
>> +
>> +extern int seccomp_test_filters(int);
>> +extern void seccomp_filter_log_failure(int);
>> +extern void seccomp_filter_fork(struct task_struct *child,
>> +                             struct task_struct *parent);
>> +
>> +#else  /* CONFIG_SECCOMP_FILTER */
>> +
>> +#include <linux/errno.h>
>> +
>> +struct seccomp_filter { };
>> +#define seccomp_filter_init_task(_tsk) do { } while (0);
>> +#define seccomp_filter_fork(_tsk, _orig) do { } while (0);
>> +#define seccomp_filter_free_task(_tsk) do { } while (0);
>> +
>> +static inline int seccomp_check_exec(void)
>> +{
>> +     return 0;
>> +}
>> +
>> +
>> +static inline long prctl_attach_seccomp_filter(char __user *a2)
>> +{
>> +     return -ENOSYS;
>> +}
>> +
>> +#endif  /* CONFIG_SECCOMP_FILTER */
>>  #endif /* _LINUX_SECCOMP_H */
>> diff --git a/kernel/Makefile b/kernel/Makefile
>> index e898c5b..0584090 100644
>> --- a/kernel/Makefile
>> +++ b/kernel/Makefile
>> @@ -79,6 +79,7 @@ obj-$(CONFIG_DETECT_HUNG_TASK) += hung_task.o
>>  obj-$(CONFIG_LOCKUP_DETECTOR) += watchdog.o
>>  obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
>>  obj-$(CONFIG_SECCOMP) += seccomp.o
>> +obj-$(CONFIG_SECCOMP_FILTER) += seccomp_filter.o
>>  obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
>>  obj-$(CONFIG_TREE_RCU) += rcutree.o
>>  obj-$(CONFIG_TREE_PREEMPT_RCU) += rcutree.o
>> diff --git a/kernel/fork.c b/kernel/fork.c
>> index da4a6a1..cc1d628 100644
>> --- a/kernel/fork.c
>> +++ b/kernel/fork.c
>> @@ -34,6 +34,7 @@
>>  #include <linux/cgroup.h>
>>  #include <linux/security.h>
>>  #include <linux/hugetlb.h>
>> +#include <linux/seccomp.h>
>>  #include <linux/swap.h>
>>  #include <linux/syscalls.h>
>>  #include <linux/jiffies.h>
>> @@ -166,6 +167,7 @@ void free_task(struct task_struct *tsk)
>>       free_thread_info(tsk->stack);
>>       rt_mutex_debug_task_free(tsk);
>>       ftrace_graph_exit_task(tsk);
>> +     seccomp_filter_free_task(tsk);
>>       free_task_struct(tsk);
>>  }
>>  EXPORT_SYMBOL(free_task);
>> @@ -1209,6 +1211,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>>       /* Perform scheduler related setup. Assign this task to a CPU. */
>>       sched_fork(p);
>>
>> +     seccomp_filter_init_task(p);
>>       retval = perf_event_init_task(p);
>>       if (retval)
>>               goto bad_fork_cleanup_policy;
>> @@ -1375,6 +1378,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>>       if (clone_flags & CLONE_THREAD)
>>               threadgroup_fork_read_unlock(current);
>>       perf_event_fork(p);
>> +     seccomp_filter_fork(p, current);
>>       return p;
>>
>>  bad_fork_free_pid:
>> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
>> index 57d4b13..78719be 100644
>> --- a/kernel/seccomp.c
>> +++ b/kernel/seccomp.c
>> @@ -47,6 +47,14 @@ void __secure_computing(int this_syscall)
>>                               return;
>>               } while (*++syscall);
>>               break;
>> +#ifdef CONFIG_SECCOMP_FILTER
>> +     case 2:
>> +             if (seccomp_test_filters(this_syscall) == 0)
>> +                     return;
>> +
>> +             seccomp_filter_log_failure(this_syscall);
>> +             break;
>> +#endif
>>       default:
>>               BUG();
>>       }
>> diff --git a/kernel/seccomp_filter.c b/kernel/seccomp_filter.c
>> new file mode 100644
>> index 0000000..4770847
>> --- /dev/null
>> +++ b/kernel/seccomp_filter.c
>> @@ -0,0 +1,639 @@
>> +/* bpf program-based system call filtering
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program; if not, write to the Free Software
>> + * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
>> + *
>> + * Copyright (C) 2011 The Chromium OS Authors <chromium-os-dev@chromium.org>
>> + */
>> +
>> +#include <linux/capability.h>
>> +#include <linux/compat.h>
>> +#include <linux/err.h>
>> +#include <linux/errno.h>
>> +#include <linux/rculist.h>
>> +#include <linux/filter.h>
>> +#include <linux/kallsyms.h>
>> +#include <linux/kref.h>
>> +#include <linux/module.h>
>> +#include <linux/pid.h>
>> +#include <linux/prctl.h>
>> +#include <linux/ptrace.h>
>> +#include <linux/ratelimit.h>
>> +#include <linux/reciprocal_div.h>
>> +#include <linux/regset.h>
>> +#include <linux/seccomp.h>
>> +#include <linux/security.h>
>> +#include <linux/sched.h>
>> +#include <linux/slab.h>
>> +#include <linux/uaccess.h>
>> +#include <linux/user.h>
>> +
>> +
>> +/**
>> + * struct seccomp_filter - container for seccomp BPF programs
>> + *
>> + * @usage: reference count to manage the object lifetime.
>> + *         get/put helpers should be used when accessing an instance
>> + *         outside of a lifetime-guarded section.  In general, this
>> + *         is only needed for handling filters shared across tasks.
>> + * @creator: pointer to the pid that created this filter
>> + * @parent: pointer to the ancestor which this filter will be composed with.
>> + * @flags: provide information about filter from creation time.
>> + * @personality: personality of the process at filter creation time.
>> + * @insns: the BPF program instructions to evaluate
>> + * @count: the number of instructions in the program.
>> + *
>> + * seccomp_filter objects should never be modified after being attached
>> + * to a task_struct (other than @usage).
>> + */
>> +struct seccomp_filter {
>> +     struct kref usage;
>> +     struct pid *creator;
>> +     struct seccomp_filter *parent;
>> +     struct {
>> +             uint32_t admin:1,  /* can allow execve */
>> +                      compat:1,  /* CONFIG_COMPAT */
>> +                      __reserved:30;
>> +     } flags;
>> +     int personality;
>> +     unsigned short count;  /* Instruction count */
>> +     struct sock_filter insns[0];
>> +};
>> +
>> +static unsigned int seccomp_run_filter(const u8 *buf,
>> +                                    const size_t buflen,
>> +                                    const struct sock_filter *);
>> +
>> +/**
>> + * seccomp_filter_alloc - allocates a new filter object
>> + * @padding: size of the insns[0] array in bytes
>> + *
>> + * The @padding should be a multiple of
>> + * sizeof(struct sock_filter).
>> + *
>> + * Returns ERR_PTR on error or an allocated object.
>> + */
>> +static struct seccomp_filter *seccomp_filter_alloc(unsigned long padding)
>> +{
>> +     struct seccomp_filter *f;
>> +     unsigned long bpf_blocks = padding / sizeof(struct sock_filter);
>> +
>> +     /* Drop oversized requests. */
>> +     if (bpf_blocks == 0 || bpf_blocks > BPF_MAXINSNS)
>> +             return ERR_PTR(-EINVAL);
>> +
>> +     /* Padding should always be in sock_filter increments. */
>> +     BUG_ON(padding % sizeof(struct sock_filter));
>
> I still think the BUG_ON here is harsh given that the progsize is passed
> in by userspace.  Was there a reason not to return -EINVAL here?

I've changed it in the next revision.  As is, I don't believe
userspace can control
the size of padding directly, just the increment since it specifies
its length in terms
of bpf blocks (sizeof(struct sock_filter)).  But EINVAL is certainly
less aggressive :)

>> +
>> +     f = kzalloc(sizeof(struct seccomp_filter) + padding, GFP_KERNEL);
>> +     if (!f)
>> +             return ERR_PTR(-ENOMEM);
>> +     kref_init(&f->usage);
>> +     f->creator = get_task_pid(current, PIDTYPE_PID);
>> +     f->count = bpf_blocks;
>> +     return f;
>> +}
>> +
>> +/**
>> + * seccomp_filter_free - frees the allocated filter.
>> + * @filter: NULL or live object to be completely destructed.
>> + */
>> +static void seccomp_filter_free(struct seccomp_filter *filter)
>> +{
>> +     if (!filter)
>> +             return;
>> +     put_seccomp_filter(filter->parent);
>> +     put_pid(filter->creator);
>> +     kfree(filter);
>> +}
>> +
>> +static void __put_seccomp_filter(struct kref *kref)
>> +{
>> +     struct seccomp_filter *orig =
>> +             container_of(kref, struct seccomp_filter, usage);
>> +     seccomp_filter_free(orig);
>> +}
>> +
>> +void seccomp_filter_log_failure(int syscall)
>> +{
>> +     pr_info("%s[%d]: system call %d blocked at 0x%lx\n",
>> +             current->comm, task_pid_nr(current), syscall,
>> +             KSTK_EIP(current));
>> +}
>> +
>> +/* put_seccomp_filter - decrements the ref count of @orig and may free. */
>> +void put_seccomp_filter(struct seccomp_filter *orig)
>> +{
>> +     if (!orig)
>> +             return;
>> +     kref_put(&orig->usage, __put_seccomp_filter);
>> +}
>> +
>> +/* get_seccomp_filter - increments the reference count of @orig. */
>> +struct seccomp_filter *get_seccomp_filter(struct seccomp_filter *orig)
>> +{
>> +     if (!orig)
>> +             return NULL;
>> +     kref_get(&orig->usage);
>> +     return orig;
>> +}
>> +
>> +static int seccomp_check_personality(struct seccomp_filter *filter)
>> +{
>> +     if (filter->personality != current->personality)
>> +             return -EACCES;
>> +#ifdef CONFIG_COMPAT
>> +     if (filter->flags.compat != (!!(is_compat_task())))
>> +             return -EACCES;
>> +#endif
>> +     return 0;
>> +}
>> +
>> +static const struct user_regset *
>> +find_prstatus(const struct user_regset_view *view)
>> +{
>> +     const struct user_regset *regset;
>> +     int n;
>> +
>> +     /* Skip 0. */
>> +     for (n = 1; n < view->n; ++n) {
>> +             regset = view->regsets + n;
>> +             if (regset->core_note_type == NT_PRSTATUS)
>> +                     return regset;
>> +     }
>> +
>> +     return NULL;
>> +}
>> +
>> +/**
>> + * seccomp_get_regs - returns a pointer to struct user_regs_struct
>> + * @scratch: preallocated storage of size @available
>> + * @available: pointer to the size of scratch.
>> + *
>> + * Returns NULL if the registers cannot be acquired or copied.
>> + * Returns a populated pointer to @scratch by default.
>> + * Otherwise, returns a pointer to a a u8 array containing the struct
>> + * user_regs_struct appropriate for the task personality.  The pointer
>> + * may be to the beginning of @scratch or to an externally managed data
>> + * structure.  On success, @available should be updated with the
>> + * valid region size of the returned pointer.
>> + *
>> + * If the architecture overrides the linkage, then the pointer may pointer to
>> + * another location.
>> + */
>> +__weak u8 *seccomp_get_regs(u8 *scratch, size_t *available)
>> +{
>> +     /* regset is usually returned based on task personality, not current
>> +      * system call convention.  This behavior makes it unsafe to execute
>> +      * BPF programs over regviews if is_compat_task or the personality
>> +      * have changed since the program was installed.
>> +      */
>> +     const struct user_regset_view *view = task_user_regset_view(current);
>> +     const struct user_regset *regset = &view->regsets[0];
>> +     size_t scratch_size = *available;
>> +     if (regset->core_note_type != NT_PRSTATUS) {
>> +             /* The architecture should override this method for speed. */
>> +             regset = find_prstatus(view);
>> +             if (!regset)
>> +                     return NULL;
>> +     }
>> +     *available = regset->n * regset->size;
>> +     /* Make sure the scratch space isn't exceeded. */
>> +     if (*available > scratch_size)
>> +             *available = scratch_size;
>> +     if (regset->get(current, regset, 0, *available, scratch, NULL))
>> +             return NULL;
>> +     return scratch;
>> +}
>> +
>> +/**
>> + * seccomp_test_filters - tests 'current' against the given syscall
>> + * @syscall: number of the system call to test
>> + *
>> + * Returns 0 on ok and non-zero on error/failure.
>> + */
>> +int seccomp_test_filters(int syscall)
>> +{
>> +     struct seccomp_filter *filter;
>> +     u8 regs_tmp[sizeof(struct user_regs_struct)], *regs;
>> +     size_t regs_size = sizeof(struct user_regs_struct);
>> +     int ret = -EACCES;
>> +
>> +     filter = current->seccomp.filter; /* uses task ref */
>> +     if (!filter)
>> +             goto out;
>> +
>> +     /* All filters in the list are required to share the same system call
>> +      * convention so only the first filter is ever checked.
>> +      */
>> +     if (seccomp_check_personality(filter))
>> +             goto out;
>> +
>> +     /* Grab the user_regs_struct.  Normally, regs == &regs_tmp, but
>> +      * that is not mandatory.  E.g., it may return a point to
>> +      * task_pt_regs(current).  NULL checking is mandatory.
>> +      */
>> +     regs = seccomp_get_regs(regs_tmp, &regs_size);
>> +     if (!regs)
>> +             goto out;
>> +
>> +     /* Only allow a system call if it is allowed in all ancestors. */
>> +     ret = 0;
>> +     for ( ; filter != NULL; filter = filter->parent) {
>> +             /* Allowed if return value is the size of the data supplied. */
>> +             if (seccomp_run_filter(regs, regs_size, filter->insns) !=
>> +                 regs_size)
>> +                     ret = -EACCES;
>> +     }
>> +out:
>> +     return ret;
>> +}
>> +
>> +/**
>> + * seccomp_attach_filter: Attaches a seccomp filter to current.
>> + * @fprog: BPF program to install
>> + *
>> + * Context: User context only. This function may sleep on allocation and
>> + *          operates on current. current must be attempting a system call
>> + *          when this is called (usually prctl).
>> + *
>> + * This function may be called repeatedly to install additional filters.
>> + * Every filter successfully installed will be evaluated (in reverse order)
>> + * for each system call the thread makes.
>> + *
>> + * Returns 0 on success or an errno on failure.
>> + */
>> +long seccomp_attach_filter(struct sock_fprog *fprog)
>> +{
>> +     struct seccomp_filter *filter = NULL;
>> +     /* Note, len is a short so overflow should be impossible. */
>> +     unsigned long fp_size = fprog->len * sizeof(struct sock_filter);
>> +     long ret = -EPERM;
>> +
>> +     /* Allocate a new seccomp_filter */
>> +     filter = seccomp_filter_alloc(fp_size);
>> +     if (IS_ERR(filter)) {
>> +             ret = PTR_ERR(filter);
>> +             goto out;
>> +     }
>> +
>> +     /* Lock the process personality and calling convention. */
>> +#ifdef CONFIG_COMPAT
>> +     if (is_compat_task())
>> +             filter->flags.compat = 1;
>> +#endif
>> +     filter->personality = current->personality;
>> +
>> +     /* Auditing is not needed since the capability wasn't requested */
>> +     if (security_real_capable_noaudit(current, current_user_ns(),
>> +                                       CAP_SYS_ADMIN) == 0)
>> +             filter->flags.admin = 1;
>> +
>> +     /* Copy the instructions from fprog. */
>> +     ret = -EFAULT;
>> +     if (copy_from_user(filter->insns, fprog->filter, fp_size))
>> +             goto out;
>> +
>> +     /* Check the fprog */
>> +     ret = sk_chk_filter(filter->insns, filter->count);
>> +     if (ret)
>> +             goto out;
>> +
>> +     /* If there is an existing filter, make it the parent
>> +      * and reuse the existing task-based ref.
>> +      */
>> +     filter->parent = current->seccomp.filter;
>> +
>> +     /* Force all filters to use one system call convention. */
>> +     ret = -EINVAL;
>> +     if (filter->parent) {
>> +             if (filter->parent->flags.compat != filter->flags.compat)
>> +                     goto out;
>> +             if (filter->parent->personality != filter->personality)
>> +                     goto out;
>> +     }
>> +
>> +     /* Double claim the new filter so we can release it below simplifying
>> +      * the error paths earlier.
>> +      */
>> +     ret = 0;
>> +     get_seccomp_filter(filter);
>> +     current->seccomp.filter = filter;
>> +     /* Engage seccomp if it wasn't. This doesn't use PR_SET_SECCOMP. */
>> +     if (!current->seccomp.mode) {
>> +             current->seccomp.mode = 2;
>> +             set_thread_flag(TIF_SECCOMP);
>> +     }
>> +
>> +out:
>> +     put_seccomp_filter(filter);  /* for get or task, on err */
>> +     return ret;
>> +}
>> +
>> +long prctl_attach_seccomp_filter(char __user *user_filter)
>> +{
>> +     struct sock_fprog fprog;
>> +     long ret = -EINVAL;
>> +
>> +     ret = -EFAULT;
>> +     if (!user_filter)
>> +             goto out;
>> +
>> +     if (copy_from_user(&fprog, user_filter, sizeof(fprog)))
>> +             goto out;
>> +
>> +     ret = seccomp_attach_filter(&fprog);
>> +out:
>> +     return ret;
>> +}
>> +
>> +/**
>> + * seccomp_check_exec: determines if exec is allowed for current
>> + * Returns 0 if allowed.
>> + */
>> +int seccomp_check_exec(void)
>> +{
>> +     if (current->seccomp.mode != 2)
>> +             return 0;
>> +     /* We can rely on the task refcount for the filter. */
>> +     if (!current->seccomp.filter)
>> +             return -EPERM;
>> +     /* The last attached filter set for the process is checked. It must
>> +      * have been installed with CAP_SYS_ADMIN capabilities.
>
> This comment is confusing.  By 'It must' you mean that if not, it's
> denied.  But if I didn't know better I would read that as "we can't
> get to this code unless".  Can you change it to something like
> "Exec is refused unless the filter was installed with CAP_SYS_ADMIN
> privilege"?

Sounds good!

>> +      */
>> +     if (current->seccomp.filter->flags.admin)
>> +             return 0;
>> +     return -EPERM;
>> +}
>> +
>> +/* seccomp_filter_fork: manages inheritance on fork
>> + * @child: forkee
>> + * @parent: forker
>> + * Ensures that @child inherit a seccomp_filter iff seccomp is enabled
>> + * and the set of filters is marked as 'enabled'.
>> + */
>> +void seccomp_filter_fork(struct task_struct *child,
>> +                      struct task_struct *parent)
>> +{
>> +     if (!parent->seccomp.mode)
>> +             return;
>> +     child->seccomp.mode = parent->seccomp.mode;
>> +     child->seccomp.filter = get_seccomp_filter(parent->seccomp.filter);
>> +}
>> +
>> +/* Returns a pointer to the BPF evaluator after checking the offset and size
>> + * boundaries.  The signature almost matches the signature from
>> + * net/core/filter.c with the hopes of sharing code in the future.
>> + */
>> +static const void *load_pointer(const u8 *buf, size_t buflen,
>> +                             int offset, size_t size,
>> +                             void *unused)
>> +{
>> +     if (offset >= buflen)
>> +             goto fail;
>> +     if (offset < 0)
>> +             goto fail;
>> +     if (size > buflen - offset)
>> +             goto fail;
>> +     return buf + offset;
>> +fail:
>> +     return NULL;
>> +}
>> +
>> +/**
>> + * seccomp_run_filter - evaluate BPF (over user_regs_struct)
>> + *   @buf: buffer to execute the filter over
>> + *   @buflen: length of the buffer
>> + *   @fentry: filter to apply
>> + *
>> + * Decode and apply filter instructions to the buffer.
>> + * Return length to keep, 0 for none. @buf is a regset we are
>> + * filtering, @filter is the array of filter instructions.
>> + * Because all jumps are guaranteed to be before last instruction,
>> + * and last instruction guaranteed to be a RET, we dont need to check
>> + * flen.
>> + *
>> + * See core/net/filter.c as this is nearly an exact copy.
>> + * At some point, it would be nice to merge them to take advantage of
>> + * optimizations (like JIT).
>> + *
>> + * A successful filter must return the full length of the data. Anything less
>> + * will currently result in a seccomp failure.  In the future, it may be
>> + * possible to use that for hard filtering registers on the fly so it is
>> + * ideal for consumers to return 0 on intended failure.
>> + */
>> +static unsigned int seccomp_run_filter(const u8 *buf,
>> +                                    const size_t buflen,
>> +                                    const struct sock_filter *fentry)
>> +{
>> +     const void *ptr;
>> +     u32 A = 0;                      /* Accumulator */
>> +     u32 X = 0;                      /* Index Register */
>> +     u32 mem[BPF_MEMWORDS];          /* Scratch Memory Store */
>> +     u32 tmp;
>> +     int k;
>> +
>> +     /*
>> +      * Process array of filter instructions.
>> +      */
>> +     for (;; fentry++) {
>> +#if defined(CONFIG_X86_32)
>> +#define      K (fentry->k)
>> +#else
>> +             const u32 K = fentry->k;
>> +#endif
>> +
>> +             switch (fentry->code) {
>> +             case BPF_S_ALU_ADD_X:
>> +                     A += X;
>> +                     continue;
>> +             case BPF_S_ALU_ADD_K:
>> +                     A += K;
>> +                     continue;
>> +             case BPF_S_ALU_SUB_X:
>> +                     A -= X;
>> +                     continue;
>> +             case BPF_S_ALU_SUB_K:
>> +                     A -= K;
>> +                     continue;
>> +             case BPF_S_ALU_MUL_X:
>> +                     A *= X;
>> +                     continue;
>> +             case BPF_S_ALU_MUL_K:
>> +                     A *= K;
>> +                     continue;
>> +             case BPF_S_ALU_DIV_X:
>> +                     if (X == 0)
>> +                             return 0;
>> +                     A /= X;
>> +                     continue;
>> +             case BPF_S_ALU_DIV_K:
>> +                     A = reciprocal_divide(A, K);
>> +                     continue;
>> +             case BPF_S_ALU_AND_X:
>> +                     A &= X;
>> +                     continue;
>> +             case BPF_S_ALU_AND_K:
>> +                     A &= K;
>> +                     continue;
>> +             case BPF_S_ALU_OR_X:
>> +                     A |= X;
>> +                     continue;
>> +             case BPF_S_ALU_OR_K:
>> +                     A |= K;
>> +                     continue;
>> +             case BPF_S_ALU_LSH_X:
>> +                     A <<= X;
>> +                     continue;
>> +             case BPF_S_ALU_LSH_K:
>> +                     A <<= K;
>> +                     continue;
>> +             case BPF_S_ALU_RSH_X:
>> +                     A >>= X;
>> +                     continue;
>> +             case BPF_S_ALU_RSH_K:
>> +                     A >>= K;
>> +                     continue;
>> +             case BPF_S_ALU_NEG:
>> +                     A = -A;
>> +                     continue;
>> +             case BPF_S_JMP_JA:
>> +                     fentry += K;
>> +                     continue;
>> +             case BPF_S_JMP_JGT_K:
>> +                     fentry += (A > K) ? fentry->jt : fentry->jf;
>> +                     continue;
>> +             case BPF_S_JMP_JGE_K:
>> +                     fentry += (A >= K) ? fentry->jt : fentry->jf;
>> +                     continue;
>> +             case BPF_S_JMP_JEQ_K:
>> +                     fentry += (A == K) ? fentry->jt : fentry->jf;
>> +                     continue;
>> +             case BPF_S_JMP_JSET_K:
>> +                     fentry += (A & K) ? fentry->jt : fentry->jf;
>> +                     continue;
>> +             case BPF_S_JMP_JGT_X:
>> +                     fentry += (A > X) ? fentry->jt : fentry->jf;
>> +                     continue;
>> +             case BPF_S_JMP_JGE_X:
>> +                     fentry += (A >= X) ? fentry->jt : fentry->jf;
>> +                     continue;
>> +             case BPF_S_JMP_JEQ_X:
>> +                     fentry += (A == X) ? fentry->jt : fentry->jf;
>> +                     continue;
>> +             case BPF_S_JMP_JSET_X:
>> +                     fentry += (A & X) ? fentry->jt : fentry->jf;
>> +                     continue;
>> +             case BPF_S_LD_W_ABS:
>> +                     k = K;
>> +load_w:
>> +                     ptr = load_pointer(buf, buflen, k, 4, &tmp);
>> +                     if (ptr != NULL) {
>> +                             /* Note, unlike on network data, values are not
>> +                              * byte swapped.
>> +                              */
>> +                             A = *(const u32 *)ptr;
>> +                             continue;
>> +                     }
>> +                     return 0;
>> +             case BPF_S_LD_H_ABS:
>> +                     k = K;
>> +load_h:
>> +                     ptr = load_pointer(buf, buflen, k, 2, &tmp);
>> +                     if (ptr != NULL) {
>> +                             A = *(const u16 *)ptr;
>> +                             continue;
>> +                     }
>> +                     return 0;
>> +             case BPF_S_LD_B_ABS:
>> +                     k = K;
>> +load_b:
>> +                     ptr = load_pointer(buf, buflen, k, 1, &tmp);
>> +                     if (ptr != NULL) {
>> +                             A = *(const u8 *)ptr;
>> +                             continue;
>> +                     }
>> +                     return 0;
>> +             case BPF_S_LD_W_LEN:
>> +                     A = buflen;
>> +                     continue;
>> +             case BPF_S_LDX_W_LEN:
>> +                     X = buflen;
>> +                     continue;
>> +             case BPF_S_LD_W_IND:
>> +                     k = X + K;
>> +                     goto load_w;
>> +             case BPF_S_LD_H_IND:
>> +                     k = X + K;
>> +                     goto load_h;
>> +             case BPF_S_LD_B_IND:
>> +                     k = X + K;
>> +                     goto load_b;
>> +             case BPF_S_LDX_B_MSH:
>> +                     ptr = load_pointer(buf, buflen, K, 1, &tmp);
>> +                     if (ptr != NULL) {
>> +                             X = (*(u8 *)ptr & 0xf) << 2;
>> +                             continue;
>> +                     }
>> +                     return 0;
>> +             case BPF_S_LD_IMM:
>> +                     A = K;
>> +                     continue;
>> +             case BPF_S_LDX_IMM:
>> +                     X = K;
>> +                     continue;
>> +             case BPF_S_LD_MEM:
>> +                     A = mem[K];
>> +                     continue;
>> +             case BPF_S_LDX_MEM:
>> +                     X = mem[K];
>> +                     continue;
>> +             case BPF_S_MISC_TAX:
>> +                     X = A;
>> +                     continue;
>> +             case BPF_S_MISC_TXA:
>> +                     A = X;
>> +                     continue;
>> +             case BPF_S_RET_K:
>> +                     return K;
>> +             case BPF_S_RET_A:
>> +                     return A;
>> +             case BPF_S_ST:
>> +                     mem[K] = A;
>> +                     continue;
>> +             case BPF_S_STX:
>> +                     mem[K] = X;
>> +                     continue;
>> +             case BPF_S_ANC_PROTOCOL:
>> +             case BPF_S_ANC_PKTTYPE:
>> +             case BPF_S_ANC_IFINDEX:
>> +             case BPF_S_ANC_MARK:
>> +             case BPF_S_ANC_QUEUE:
>> +             case BPF_S_ANC_HATYPE:
>> +             case BPF_S_ANC_RXHASH:
>> +             case BPF_S_ANC_CPU:
>> +             case BPF_S_ANC_NLATTR:
>> +             case BPF_S_ANC_NLATTR_NEST:
>> +                     /* ignored */
>> +                     continue;
>> +             default:
>> +                     WARN_RATELIMIT(1, "Unknown code:%u jt:%u tf:%u k:%u\n",
>> +                                    fentry->code, fentry->jt,
>> +                                    fentry->jf, fentry->k);
>> +                     return 0;
>> +             }
>> +     }
>> +
>> +     return 0;
>> +}
>> diff --git a/kernel/sys.c b/kernel/sys.c
>> index 481611f..77f2eda 100644
>> --- a/kernel/sys.c
>> +++ b/kernel/sys.c
>> @@ -1783,6 +1783,10 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
>>               case PR_SET_SECCOMP:
>>                       error = prctl_set_seccomp(arg2);
>>                       break;
>> +             case PR_ATTACH_SECCOMP_FILTER:
>> +                     error = prctl_attach_seccomp_filter((char __user *)
>> +                                                             arg2);
>> +                     break;
>>               case PR_GET_TSC:
>>                       error = GET_TSC_CTL(arg2);
>>                       break;
>> diff --git a/security/Kconfig b/security/Kconfig
>> index 51bd5a0..77b1106 100644
>> --- a/security/Kconfig
>> +++ b/security/Kconfig
>> @@ -84,6 +84,18 @@ config SECURITY_DMESG_RESTRICT
>>
>>         If you are unsure how to answer this question, answer N.
>>
>> +config SECCOMP_FILTER
>> +     bool "Enable seccomp-based system call filtering"
>> +     select SECCOMP
>> +     depends on EXPERIMENTAL
>> +     help
>> +       This kernel feature expands CONFIG_SECCOMP to allow computing
>> +       in environments with reduced kernel access dictated by a system
>> +       call filter, expressed in BPF, installed by the application itself
>> +       through prctl(2).
>> +
>> +       See Documentation/prctl/seccomp_filter.txt for more detail.
>> +
>>  config SECURITY
>>       bool "Enable different security models"
>>       depends on SYSFS
>> --
>> 1.7.5.4
>>

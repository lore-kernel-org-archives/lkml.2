Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab2A2U1U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 15:27:20 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55718 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab2A2U1R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 15:27:17 -0500
MIME-Version: 1.0
In-Reply-To: <c211732dcacbff72c70127ccab36122a.squirrel@webmail.greenhost.nl>
References: <1327706681-11959-1-git-send-email-wad@chromium.org>
	<1327706681-11959-2-git-send-email-wad@chromium.org>
	<c211732dcacbff72c70127ccab36122a.squirrel@webmail.greenhost.nl>
Date: Sun, 29 Jan 2012 14:27:15 -0600
Message-ID: <CABqD9hatfCSSqUt-FYUa6-LcCeDEht8gLMAY7cnWKe6gp-9upg@mail.gmail.com>
Subject: Re: [PATCH v5 2/3] seccomp_filters: system call filtering using BPF
From: Will Drewry <wad@chromium.org>
To: Indan Zupancic <indan@nul.nu>
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, scarybeasts@gmail.com,
        avi@redhat.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk,
        luto@mit.edu, mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, amwang@redhat.com, oleg@redhat.com,
        ak@linux.intel.com, eric.dumazet@gmail.com, gregkh@suse.de,
        dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        corbet@lwn.net, alan@lxorguk.ukuu.org.uk, mcgrathr@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 28, 2012 at 10:39 PM, Indan Zupancic <indan@nul.nu> wrote:
> Hello,
>
> Feedback below. I know you send out v6, but I'm not going to play
> eternal catch-up, so here it is.

The change is minimal - so thanks for the comments on any version!

> On Sat, January 28, 2012 00:24, Will Drewry wrote:
>> [This patch depends on luto@mit.edu's no_new_privs patch:
>>  https://lkml.org/lkml/2012/1/12/446
>> ]
>>
>> This patch adds support for seccomp mode 2.  This mode enables dynamic
>> enforcement of system call filtering policy in the kernel as specified
>> by a userland task.  The policy is expressed in terms of a Berkeley
>> Packet Filter program, as is used for userland-exposed socket filtering.
>> Instead of network data, the BPF program is evaluated over struct
>> seccomp_filter_data at the time of the system call.
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
>> installed using specific is_compat_task() value, it is not allowed to
>> make system calls using the alternate entry point.
>>
>> Filter programs will be inherited across fork/clone and execve.
>> However, if the task attaching the filter is unprivileged
>> (!CAP_SYS_ADMIN) the no_new_privs bit will be set on the task.  This
>> ensures that unprivileged tasks cannot attach filters that affect
>> privileged tasks (e.g., setuid binary).
>>
>> There are a number of benefits to this approach. A few of which are
>> as follows:
>> - BPF has been exposed to userland for a long time.
>> - Userland already knows its ABI: system call numbers and desired
>>   arguments
>> - No time-of-check-time-of-use vulnerable data accesses are possible.
>> - system call arguments are loaded on demand only to minimize copying
>>   required for system call number-only policy decisions.
>>
>> This patch includes its own BPF evaluator, but relies on the
>> net/core/filter.c BPF checking code.  It is possible to share
>> evaluators, but the performance sensitive nature of the network
>> filtering path makes it an iterative optimization which (I think :) can
>> be tackled separately via separate patchsets. (And at some point sharing
>> BPF JIT code!)
>>
>>  v5: - uses syscall_get_arguments
>>        (indan@nul.nu,oleg@redhat.com, mcgrathr@chromium.org)
>>      - uses union-based arg storage with hi/lo struct to
>>        handle endianness.  Compromises between the two alternate
>>        proposals to minimize extra arg shuffling and account for
>>        endianness assuming userspace uses offsetof().
>
> Why would user space use offsetof()? Do you mean when assembling the BPF
> code? So this basically means 32-bit and 64-bit filters are different,
> even when they could be the same. Hm.

Not at all.  Take a peek at the union seccomp_filter_data.  What it
does is allows reference by hi32/lo32 be endian-accurate, but they are
union'd with u64.  So if you want portable definitions, you use
offsetof(), but if you know your endiannness and don't care about
cross-compiling, then you can just reference by the offset of the u64
and index into it as your endianness allows.

This avoids a pointless extra copy to split u32 and u64 without
leaving endianness pain entirely for userspace. I think it's a pretty
sane compromise.  32-bit programs will only ever care about lo32.
64-bit will need to check both hi32 and lo32 or manually index into
the u64 member.

>
>>        (mcgrathr@chromium.org, indan@nul.nu)
>>      - update Kconfig description
>>      - add include/seccomp_filter.h and add its installation
>>      - (naive) on-demand syscall argument loading
>>      - drop seccomp_t (eparis@redhat.com)
>>      - adds proper compat prctl call copying
>>  v4: - adjusted prctl to make room for PR_[SG]ET_NO_NEW_PRIVS
>>      - now uses current->no_new_privs
>>          (luto@mit.edu,torvalds@linux-foundation.com)
>>      - assign names to seccomp modes (rdunlap@xenotime.net)
>>      - fix style issues (rdunlap@xenotime.net)
>>      - reworded Kconfig entry (rdunlap@xenotime.net)
>>  v3: - macros to inline (oleg@redhat.com)
>>      - init_task behavior fixed (oleg@redhat.com)
>>      - drop creator entry and extra NULL check (oleg@redhat.com)
>>      - alloc returns -EINVAL on bad sizing (serge.hallyn@canonical.com)
>>      - adds tentative use of "always_unprivileged" as per
>>        torvalds@linux-foundation.org and luto@mit.edu
>>  v2: - (patch 2 only)
>>
>> Signed-off-by: Will Drewry <wad@chromium.org>
>> ---
>>  include/linux/Kbuild           |    1 +
>>  include/linux/prctl.h          |    3 +
>>  include/linux/seccomp.h        |   63 ++++
>>  include/linux/seccomp_filter.h |   79 +++++
>
> Just stuff it into seccomp.h?

Most of it is in there, but by defining a special data set for running
filters over, I needed to export the definition to userspace.
seccomp_filter.h contains only ABI relevant declarations.  The rest of
the in-kernel stuff is in seccomp.h (which is not copied during a
header installation).

> If this is added, then this will be seccomp,
> and the old mode can be seen as a standard, very restrictive filter.

This is totally true.  I originally did not pursue this because I
would have needed 1 hardcoded BPF filter per arch.  With the new
syntax, I believe it will be possible to define a 32-bit filter and a
64-bit filter (and a compat filter) in one central place. I will start
on that for v7.  I hope it is doable now, because it is nice to keep
it all locked to one path.

The only consideration is that it might make sense to do that after
seccomp_filter has been merged (in my dreams :) and given time to
bake.  But it'll be a good exercise to do upfront, so I'll go ahead.
If it seems too hasty, I can always respin it without the merging.

>>  kernel/Makefile                |    1 +
>>  kernel/fork.c                  |    4 +
>>  kernel/seccomp.c               |   10 +-
>>  kernel/seccomp_filter.c        |  620 ++++++++++++++++++++++++++++++++++++++++
>
> Same here. There isn't much to seccomp.c, why not add the filter code there?
>
> If you insist on keeping it separate, then why call it seccomp at all?
> Just call it syscall_filter or something.

Works for me.

>>  kernel/sys.c                   |    4 +
>>  security/Kconfig               |   20 ++
>>  10 files changed, 804 insertions(+), 1 deletions(-)
>
> What is the difference in kernel binary size with and without this?
> If it's too big I think the BPF filtering code should be shared with
> the networking version from the start.

The network filtering code adds one function that is a switch
statement over the possible valid values.  This doesn't duplicate the
checking code.

> Actually, that is something that is wanted anyway, so why not use the
> networking code from the start? That should reduce the code amount a
> lot. So I think if this gets merged the consolidated version should be
> merged. Only downside would be that networking support is needed for
> this feature, but without networking there shouldn't be much need for
> this feature anyway.

The reason that I am not merging upfront is because the load_pointer
and byte swapping behavior is hard-coded in the current versions.  I
believe it will be possible to add a layer of abstraction that doesn't
induce additional overhead, but I didn't want to force that first.  If
that will really be a blocker, then I will go ahead and do that first.
 I was just worried that the potential performance impact discussions
could lead this patch to a dead end before it got a chance.


>>  create mode 100644 include/linux/seccomp_filter.h
>>  create mode 100644 kernel/seccomp_filter.c
>>
>> diff --git a/include/linux/Kbuild b/include/linux/Kbuild
>> index c94e717..5659454 100644
>> --- a/include/linux/Kbuild
>> +++ b/include/linux/Kbuild
>> @@ -330,6 +330,7 @@ header-y += scc.h
>>  header-y += sched.h
>>  header-y += screen_info.h
>>  header-y += sdla.h
>> +header-y += seccomp_filter.h
>>  header-y += securebits.h
>>  header-y += selinux_netlink.h
>>  header-y += sem.h
>> diff --git a/include/linux/prctl.h b/include/linux/prctl.h
>> index 7ddc7f1..b8c4beb 100644
>> --- a/include/linux/prctl.h
>> +++ b/include/linux/prctl.h
>> @@ -114,4 +114,7 @@
>>  # define PR_SET_MM_START_BRK         6
>>  # define PR_SET_MM_BRK                       7
>>
>> +/* Set process seccomp filters */
>> +#define PR_ATTACH_SECCOMP_FILTER     37
>> +
>>  #endif /* _LINUX_PRCTL_H */
>> diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
>> index 171ab66..3992bb6 100644
>> --- a/include/linux/seccomp.h
>> +++ b/include/linux/seccomp.h
>> @@ -5,10 +5,29 @@
>>  #ifdef CONFIG_SECCOMP
>>
>>  #include <linux/thread_info.h>
>> +#include <linux/types.h>
>>  #include <asm/seccomp.h>
>>
>> +/* Valid values of seccomp_struct.mode */
>> +#define SECCOMP_MODE_DISABLED        0 /* seccomp is not in use. */
>> +#define SECCOMP_MODE_STRICT  1 /* uses hard-coded seccomp.c rules. */
>> +#define SECCOMP_MODE_FILTER  2 /* system call access determined by filter. */
>> +
>> +struct seccomp_filter;
>> +/**
>> + * struct seccomp_struct - the state of a seccomp'ed process
>> + *
>> + * @mode:  indicates one of the valid values above for controlled
>> + *         system calls available to a process.
>> + * @filter: Metadata for filter if using CONFIG_SECCOMP_FILTER.
>> + *          @filter must only be accessed from the context of current as there
>> + *          is no guard.
>> + */
>>  struct seccomp_struct {
>>       int mode;
>> +#ifdef CONFIG_SECCOMP_FILTER
>> +     struct seccomp_filter *filter;
>> +#endif
>
> Why a separate config option for this? Just depend on SECCOMP and networking?

Right now it requires asm/syscall.h which CONFIG_SECCOMP doesn't.
Some arches still haven't implemented that file so I thought it would
make sense to keep it separate.

Would it make sense to start with a config option then merge later or
should it be done upfront?

>>  };
>>
>>  extern void __secure_computing(int);
>> @@ -51,4 +70,48 @@ static inline int seccomp_mode(struct seccomp_struct *s)
>>
>>  #endif /* CONFIG_SECCOMP */
>>
>> +#ifdef CONFIG_SECCOMP_FILTER
>> +
>> +
>> +extern long prctl_attach_seccomp_filter(char __user *);
>> +
>> +extern struct seccomp_filter *get_seccomp_filter(struct seccomp_filter *);
>> +extern void put_seccomp_filter(struct seccomp_filter *);
>> +
>> +extern int seccomp_test_filters(int);
>> +extern void seccomp_filter_log_failure(int);
>> +extern void seccomp_struct_fork(struct seccomp_struct *child,
>> +                             const struct seccomp_struct *parent);
>
> Lousy function name, what is it doing?

Now it is called seccomp_fork() and it is called by fork when a task
fork()s :)  Naming suggestions welcome!


>> +
>> +static inline void seccomp_struct_init_task(struct seccomp_struct *seccomp)
>> +{
>> +     seccomp->mode = SECCOMP_MODE_DISABLED;
>> +     seccomp->filter = NULL;
>> +}
>
> This doesn't actually do anything, just get rid of it and/or adapt seccomp_struct_fork()?
>
> And it seems wrong to do this at fork time considering that the mode is supposed
> to keep the mode across forks, so it seems safer to update it to the correct
> values immediately.

True - mode and filter should already be zeroed.  I'll remove it. It
persists from when I had a mutex in the older patch series.

>> +
>> +/* No locking is needed here because the task_struct will
>> + * have no parallel consumers.
>> + */
>> +static inline void seccomp_struct_free_task(struct seccomp_struct *seccomp)
>> +{
>> +     put_seccomp_filter(seccomp->filter);
>> +     seccomp->filter = NULL;
>> +}
>
> How many functions do you need to free one object?

At least three :)

> I'm sure you can get rid of a couple, starting with this one. Just use
> put_seccomp_filter() directly, the NULL is useless as task_struct is
> going away.

Cool - I'll do that.

>> +
>> +#else  /* CONFIG_SECCOMP_FILTER */
>> +
>> +#include <linux/errno.h>
>> +
>> +struct seccomp_filter { };
>> +/* Macros consume the unused dereference by the caller. */
>> +#define seccomp_struct_init_task(_seccomp) do { } while (0);
>> +#define seccomp_struct_fork(_tsk, _orig) do { } while (0);
>> +#define seccomp_struct_free_task(_seccomp) do { } while (0);
>> +
>> +static inline long prctl_attach_seccomp_filter(char __user *a2)
>> +{
>> +     return -ENOSYS;
>> +}
>> +
>> +#endif  /* CONFIG_SECCOMP_FILTER */
>>  #endif /* _LINUX_SECCOMP_H */
>> diff --git a/include/linux/seccomp_filter.h b/include/linux/seccomp_filter.h
>> new file mode 100644
>> index 0000000..3ecd641
>> --- /dev/null
>> +++ b/include/linux/seccomp_filter.h
>> @@ -0,0 +1,79 @@
>> +/*
>> + * Secomp-based system call filtering data structures and definitions.
>> + *
>> + * Copyright (C) 2012 The Chromium OS Authors <chromium-os-dev@chromium.org>
>
> (Not my expertise, but I'm not sure if that makes legal sense.)

Weird, eh :)  That's what my work falls under when I do it on paid
time. If it'd be helpful, I can add an Author: line.  If it's too
weird still, I believe I can use Google Inc. instead. But, IANAL, etc.

>> + *
>> + * This copyrighted material is made available to anyone wishing to use,
>> + * modify, copy, or redistribute it subject to the terms and conditions
>> + * of the GNU General Public License v.2.
>> + *
>> + */
>> +
>> +#ifndef __LINUX_SECCOMP_FILTER_H__
>> +#define __LINUX_SECCOMP_FILTER_H__
>> +
>> +#include <asm/byteorder.h>
>> +#include <linux/compiler.h>
>> +#include <linux/types.h>
>> +
>> +/*
>> + *   Keep the contents of this file similar to linux/filter.h:
>> + *     struct sock_filter and sock_fprog and versions.
>> + *   Custom naming exists solely if divergence is ever needed.
>> + */
>> +
>> +/*
>> + * Current version of the filter code architecture.
>> + */
>> +#define SECCOMP_BPF_MAJOR_VERSION 1
>> +#define SECCOMP_BPF_MINOR_VERSION 1
>
> If it's a fork of the current networking code it should follow their version
> numbering too. But these defines aren't used anywhere..?

Neither are the networking code defines :)  They are exported to
userspace but I don't believe they've ever changed.

>> +
>> +struct seccomp_filter_block {        /* Filter block */
>> +     __u16   code;   /* Actual filter code */
>> +     __u8    jt;     /* Jump true */
>> +     __u8    jf;     /* Jump false */
>> +     __u32   k;      /* Generic multiuse field */
>> +};
>> +
>> +struct seccomp_fprog {       /* Required for SO_ATTACH_FILTER. */
>> +     unsigned short          len;    /* Number of filter blocks */
>> +     struct seccomp_filter_block __user *filter;
>> +};
>> +
>> +/* Ensure the u32 ordering is consistent with platform byte order. */
>> +#if defined(__LITTLE_ENDIAN)
>> +#define SECCOMP_ENDIAN_SWAP(x, y) x, y
>> +#elif defined(__BIG_ENDIAN)
>> +#define SECCOMP_ENDIAN_SWAP(x, y) y, x
>> +#else
>> +#error edit for your odd arch byteorder.
>> +#endif
>> +
>> +/* System call argument layout for the filter data. */
>> +union seccomp_filter_arg {
>> +     struct {
>> +             __u32 SECCOMP_ENDIAN_SWAP(lo32, hi32);
>> +     };
>> +     __u64 u64;
>> +};
>
> Ugh. What was the advantage of doing this again? This looks like optimising
> at the wrong level to me.

I was optimizing for competing opinions it actually working.  If doing
it your way will make people happy, then that's fine with me:

struct {
  __u32 lo32[6];
  __u32 hi32[6];
}

It just means two copies for every system call argument instead of
one, but who knows, maybe the compiler will magic it away.
Regardless, any argument access will always be slightly slower than
just syscall number, so it doesn't hurt if the extra copy doesn't go
away.

> it doesn't make your code nicer, and I really doubt it makes it run
> anything faster either. It's just obfuscating the code.

It makes the filters marginally easier, but eh. You can write a 32-bit
filter that checks lo32 and you know it will index into the u64 at the
correct location regardless of endianness.  However, since it is all
being done in the header anyway, it's really just being done in
userspace.  In the 32-bit kernel code path, I just ensure that hi32 is
zeroed out.

I just want an abi that is functional across platforms that people are
happy enough to merge.  The one I posted is fine with me and so is
your proposal.  So if no one else has strong opinions, I'll just use
yours :)


> If you don't want to hide endianness then don't provide those lo32 and hi32
> structure members and just make it a u64. That's at least very clear. But
> swapping them around depending on endianness is not good, because it's only
> confusing things.
>
> But if you have to do it, then at least do:
>
> #if defined(__LITTLE_ENDIAN)
> union seccomp_filter_arg {
>        struct {
>                __u32 lo32;
>                __u32 hi32;
>        };
>        __u64 u64;
> };
> #else
> union seccomp_filter_arg {
>        struct {
>                __u32 hi32;
>                __u32 lo32;
>        };
>        __u64 u64;
> };
> #endif
>
> Instead of hiding what you're doing.

I copied the aio_abi.h file. I'm happy to do it more explicitly, but
since no one appears to have a strong opinion and your proposal would
allow for seamless addition of a mythical 128-bit argument someday, it
seems like its the way to go.

>> +
>> +/*
>> + *   Expected data the BPF program will execute over.
>> + *   Endianness will be arch specific, but the values will be
>> + *   swapped, as above, to allow for consistent BPF programs.
>
> So now what? You need platform dependent BPF programs depending on
> the arch's endianness? Just because you want to stuff one 64-bit
> longs directly into two 32-bit ints? That saves how much, two
> instructions?

I was also attempting to compromise between aesthetics, but unless I
hear any continued dissent against your proposal, I'll just go with
it.

>> + */
>> +struct seccomp_filter_data {
>> +     int syscall_nr;
>> +     __u32 __reserved;
>> +     union seccomp_filter_arg args[6];
>> +};
>> +
>> +#undef SECCOMP_ENDIAN_SWAP
>> +
>> +/*
>> + * Defined valid return values for the BPF program.
>> + */
>> +#define SECCOMP_BPF_ALLOW    0xFFFFFFFF
>> +#define SECCOMP_BPF_DENY     0
>
> This doesn't make sense. Please be consistent with C and swap it around.

Nope.  The bpf engine returns non-zero for success and 0 for failure.
If I plan to share code with the networking stack, then 0 will always
be the failure mode.  It indicates the amount of the packet to accept.
 If swapping it around becomes mandatory, then sharing code with the
network implementation will be even harder.

>> +
>> +#endif /* __LINUX_SECCOMP_FILTER_H__ */
>> diff --git a/kernel/Makefile b/kernel/Makefile
>> index 2d9de86..fd81bac 100644
>> --- a/kernel/Makefile
>> +++ b/kernel/Makefile
>> @@ -78,6 +78,7 @@ obj-$(CONFIG_DETECT_HUNG_TASK) += hung_task.o
>>  obj-$(CONFIG_LOCKUP_DETECTOR) += watchdog.o
>>  obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
>>  obj-$(CONFIG_SECCOMP) += seccomp.o
>> +obj-$(CONFIG_SECCOMP_FILTER) += seccomp_filter.o
>>  obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
>>  obj-$(CONFIG_TREE_RCU) += rcutree.o
>>  obj-$(CONFIG_TREE_PREEMPT_RCU) += rcutree.o
>> diff --git a/kernel/fork.c b/kernel/fork.c
>> index 051f090..f312edb 100644
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
>> @@ -169,6 +170,7 @@ void free_task(struct task_struct *tsk)
>>       free_thread_info(tsk->stack);
>>       rt_mutex_debug_task_free(tsk);
>>       ftrace_graph_exit_task(tsk);
>> +     seccomp_struct_free_task(&tsk->seccomp);
>>       free_task_struct(tsk);
>>  }
>>  EXPORT_SYMBOL(free_task);
>> @@ -1093,6 +1095,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>>               goto fork_out;
>>
>>       ftrace_graph_init_task(p);
>> +     seccomp_struct_init_task(&p->seccomp);
>
> If you just do a get on the filter's krefs here then cleanup is done correctly
> by free_task(). So just call seccomp_struct_fork() or get_seccomp_filter() here.

Since init_task just NULLs it all out, then later seccomp_fork() does
the get from the parent, I'm not sure I need this function at all any
more.  Am I misreading?

>>
>>       rt_mutex_init_task(p);
>>
>> @@ -1376,6 +1379,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>>       if (clone_flags & CLONE_THREAD)
>>               threadgroup_change_end(current);
>>       perf_event_fork(p);
>> +     seccomp_struct_fork(&p->seccomp, &current->seccomp);
>
> This can be moved above, before the first error goto.

As in where seccomp_struct_init_task is or somewhere else?  (Where
seccomp_init_task is would make sense.)

>>
>>       trace_task_newtask(p, clone_flags);
>>
>> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
>> index e8d76c5..a045dd4 100644
>> --- a/kernel/seccomp.c
>> +++ b/kernel/seccomp.c
>> @@ -37,7 +37,7 @@ void __secure_computing(int this_syscall)
>>       int * syscall;
>>
>>       switch (mode) {
>> -     case 1:
>> +     case SECCOMP_MODE_STRICT:
>>               syscall = mode1_syscalls;
>>  #ifdef CONFIG_COMPAT
>>               if (is_compat_task())
>> @@ -48,6 +48,14 @@ void __secure_computing(int this_syscall)
>>                               return;
>>               } while (*++syscall);
>>               break;
>> +#ifdef CONFIG_SECCOMP_FILTER
>> +     case SECCOMP_MODE_FILTER:
>> +             if (seccomp_test_filters(this_syscall) == 0)
>
> Get rid of the '== 0' and have proper return values instead.

0 is success/allow as normal here.  I can change it to

  if (!seccomp_test_filters(this_syscall))
    return;

if that'd read better?

>> +                     return;
>> +
>
> No need for an empty line here.

I'll drop it.

>> +             seccomp_filter_log_failure(this_syscall);
>> +             break;
>> +#endif
>>       default:
>>               BUG();
>>       }
>> diff --git a/kernel/seccomp_filter.c b/kernel/seccomp_filter.c
>> new file mode 100644
>> index 0000000..e57219e
>> --- /dev/null
>> +++ b/kernel/seccomp_filter.c
>> @@ -0,0 +1,620 @@
>> +/*
>> + * linux/kernel/seccomp_filter.c
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
>> + * Copyright (C) 2012 The Chromium OS Authors <chromium-os-dev@chromium.org>
>> + *
>> + * Extends linux/kernel/seccomp.c to allow tasks to install system call
>> + * filters using a Berkeley Packet Filter program which is executed over
>> + * struct seccomp_filter_data.
>> + */
>> +
>> +#include <asm/syscall.h>
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
>> +#include <linux/seccomp_filter.h>
>> +#include <linux/security.h>
>> +#include <linux/seccomp.h>
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
>> + * @parent: pointer to the ancestor which this filter will be composed with.
>
> I guess the code will be clearer than the comment. Parent task or filter?
> Is it a reverse linked list or something? I'm confused.

I'll try to rewrite it.  The parent filter is whatever filter was
installed on the task at the time the current filter was installed.
It may have been inherited or be part of a sequence of filters
installed by the same task.

>> + * @insns: the BPF program instructions to evaluate
>> + * @count: the number of instructions in the program.
>> + *
>> + * seccomp_filter objects should never be modified after being attached
>> + * to a task_struct (other than @usage).
>> + */
>> +struct seccomp_filter {
>> +     struct kref usage;
>> +     struct seccomp_filter *parent;
>> +     struct {
>> +             uint32_t compat:1;
>> +     } flags;
>
> This flag isn't documented above.

Oops dropped it for a rev - I'll re-add it. Thanks!

>> +     unsigned short count;  /* Instruction count */
>
> Why a short?

Matches sock_fprog - I can go larger if that make sense.

>> +     struct sock_filter insns[0];
>
> Newer gcc supports insns[], but I don't know what the kernel convention is.

Yeah - I just lifted what I saw. I can recheck to see if the
conventions are more clearly spelled out for this. (checkpatch is
happy.)

>> +};
>> +
>> +/*
>> + * struct seccomp_filter_metadata - BPF data wrapper
>> + * @data: data accessible to the BPF program.
>> + * @has_args: indicates that the args have been lazily populated.
>> + *
>> + * Used by seccomp_load_pointer.
>> + */
>> +struct seccomp_filter_metadata {
>> +     struct seccomp_filter_data data;
>> +     bool has_args;
>> +};
>
> Why use 'bool' instead of a nifty struct { uint32_t : 1 }?
>
> It seems that has_args is something that should be stored elsewhere,
> it doesn't seem to warrant its own structure.

Well it would naturally live inside the BPF evaluator since the
loading is done in load_pointer.  This struct is just used to marshal
the state around.

>> +
>> +static unsigned int seccomp_run_filter(void *, uint32_t,
>> +                                    const struct sock_filter *);
>
> It almosts fits, just put it on one line.

I'm just doing what checkpatch suggests :)  Would it read better if I
bumped all the args down a line?

>> +
>> +/**
>> + * seccomp_filter_alloc - allocates a new filter object
>> + * @padding: size of the insns[0] array in bytes
>> + *
>> + * The @padding should be a multiple of
>> + * sizeof(struct sock_filter).
>
> It's not padding, why call it such? Why not 'count' or 'bpf_blocks'?
> That would reduce the sizeof(struct sock_filter)s to one.

Either work - I'll change it.

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
>> +     if (padding % sizeof(struct sock_filter))
>> +             return ERR_PTR(-EINVAL);
>
> ...then this isn't needed.
>
>> +
>> +     f = kzalloc(sizeof(struct seccomp_filter) + padding, GFP_KERNEL);
>> +     if (!f)
>> +             return ERR_PTR(-ENOMEM);
>> +     kref_init(&f->usage);
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
>
> Why do put on the parent here?

filters may be shared across tasks and there may be multiple filters
per-task.  The references keep them alive beyond the life of the
originating task_struct or if they are not hanging off of the
task_struct directly.  In order for them to ever die, the reference to
them needs to be dropped and that's done here.

> This function is only called once below by __put_seccomp_filter, perhaps merge them?

Cool I'll do that.

>> +     kfree(filter);
>> +}
>> +
>> +static void __put_seccomp_filter(struct kref *kref)
>> +{
>> +     struct seccomp_filter *orig =
>> +             container_of(kref, struct seccomp_filter, usage);
>> +     seccomp_filter_free(orig);
>
> I find it unexpected that __put_seccomp_filter() calls put_seccomp_filter(),
> why have two versions then? I have the feeling all this can be streamlined
> more.

So I can either make all callers use kref_put(&filter->usage,
__put_seccomp_filter) or I can have one extra layer of indirection:
put_seccomp_filter.  I can definitely ditch the extra free wrapper
though.  I can also make put_seccomp_filter into a static inline if
that'd be preferable -- or just use kref everywhere.

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
>
> This function should be merged with seccomp_struct_fork(), it's pretty much only
> called there.

It's used primarily during filter attach, but if these wrappers are
bothersome, I can just use kref_* directly everywhere.

>> +
>> +#if BITS_PER_LONG == 32
>> +static inline unsigned long *seccomp_filter_data_arg(
>> +                             struct seccomp_filter_data *data, int index)
>> +{
>> +     /* Avoid inconsistent hi contents. */
>> +     data->args[index].hi32 = 0;
>> +     return (unsigned long *) &(data->args[index].lo32);
>> +}
>> +#elif BITS_PER_LONG == 64
>> +static inline unsigned long *seccomp_filter_data_arg(
>> +                             struct seccomp_filter_data *data, int index)
>> +{
>> +     return (unsigned long *) &(data->args[index].u64);
>
> No need for any casts, is there? And this looks a bit untidy.

Yup - gcc isn't a fan even if the size matches.  Won't matter with the
new change though.

>
>> +}
>> +#else
>> +#error Unknown BITS_PER_LONG.
>> +#endif
>> +
>> +/**
>> + * seccomp_load_pointer: checks and returns a pointer to the requested offset
>> + * @buf: u8 array to index into
>> + * @buflen: length of the @buf array
>> + * @offset: offset to return data from
>> + * @size: size of the data to retrieve at offset
>> + * @unused: placeholder which net/core/filter.c uses for for temporary
>> + *          storage.  Ideally, the two code paths can be merged.
>
> The documentation doesn't matches the actual code?

Thanks - sorry.  Last minute changes that I failed to fix the comment for.

>> + *
>> + * Returns a pointer to the BPF evaluator after checking the offset and size
>> + * boundaries.
>> + */
>> +static inline void *seccomp_load_pointer(void *data, int offset, size_t size,
>> +                                      void *buffer)
>> +{
>> +     struct seccomp_filter_metadata *metadata = data;
>> +     int arg;
>> +     if (offset >= sizeof(metadata->data))
>> +             goto fail;
>> +     if (offset < 0)
>> +             goto fail;
>
> Perhaps use unsigned offset?

I'm using what the bpf code specifies already.  Otherwise I would use
an unsigned int. I guess I could cast.

>> +     if (size > sizeof(metadata->data) - offset)
>> +             goto fail;
>> +     if (metadata->has_args)
>> +             goto pass;
>> +     /* No argument data touched. */
>> +     if (offset + size - 1 < offsetof(struct seccomp_filter_data, args))
>> +             goto pass;
>> +     for (arg = 0; arg < ARRAY_SIZE(metadata->data.args); ++arg)
>> +             syscall_get_arguments(current, task_pt_regs(current), arg, 1,
>> +                     seccomp_filter_data_arg(&metadata->data, arg));
>> +     metadata->has_args = true;
>
> Wasn't the idea that arguments would be loaded on demand?

Yes and they are and then cached.

> And as arguments are usually only checked once and not twice, caching the
> values isn't really needed. So perhaps get rid of the (meta)data structure
> and just have a switch that returns the right data directly depending on
> the offset? It seems the over all code would be simpler that way.

Not really. You can make a case statement per range of offsets that
overlap with an argument, but that doesn't account for size.  You
could load a long across two arguments.  We're not enforcing alignment
as the networking code doesn't either.  I could have it fail if the
request is not 32-bit aligned.  I don't prefer that, but it would
simplify the code.  It's certainly easier to change the ABI later to
provide unaligned access then it is to make it aligned later, so I can
change to aligned requests only that return the appropriate 32-bit
slice of the data.

>> +pass:
>> +     return ((__u8 *)(&metadata->data)) + offset;
>> +fail:
>> +     return NULL;
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
>> +     int ret = -EACCES;
>> +     struct seccomp_filter *filter;
>> +     struct seccomp_filter_metadata metadata;
>> +
>> +     filter = current->seccomp.filter; /* uses task ref */
>> +     if (!filter)
>> +             goto out;
>
> Actually, shouldn't having no filter with SECCOMP_MODE_FILTER set be impossible?

Yeah.

> It seems better to assure that instead of needlessly testing for it every time.

I guess so. I personally prefer this style of defensive checking, but
I realize that's at odds with the kernel style. I'll drop it.

>> +
>> +     metadata.data.syscall_nr = syscall;
>> +     metadata.has_args = false;
>> +
>> +#ifdef CONFIG_COMPAT
>> +     if (filter->flags.compat != !!(is_compat_task()))
>> +             goto out;
>> +#endif
>> +
>> +     /* Only allow a system call if it is allowed in all ancestors. */
>> +     ret = 0;
>> +     for ( ; filter != NULL; filter = filter->parent) {
>> +             /* Allowed if return value is SECCOMP_BPF_ALLOW */
>> +             if (seccomp_run_filter(&metadata, sizeof(metadata.data),
>> +                                     filter->insns) != SECCOMP_BPF_ALLOW)
>> +                     ret = -EACCES;
>
> Why keep checking filters if one of them fails? Just return -EACCES?

Why optimize for a failure mode?  Since fails are terminal, I don't
see any reason to rush :) That said, this was more relevant when I had
ptrace integration that depended on knowing which filter the failure
occurred in. I'll change it.

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
>
> That's a crude way of doing it. The max is BPF_MAXINSNS and that is checked a
> bit late by sk_chk_filter(). But perhaps while you're consolidating the code
> with the networking filter code, you could change their code to check that
> first before trying to allocate the given amount.

Sure - I can send those patches independently and see if they are
accepted.  It doesn't change the fact that it can't overflow because
fprog->len is a short and the sizeof struct sock_filter is less than
65535.

>> +     long ret = -EPERM;
>> +
>> +     /* Allocate a new seccomp_filter */
>> +     filter = seccomp_filter_alloc(fp_size);
>
> Actually, your seccomp_filter_alloc() checks for BPF_MAXINSNS already, and if
> you change that one as I recommended and you pass on fprog->len directly, no
> overflow can happen.

Works for me!

>> +     if (IS_ERR(filter)) {
>> +             ret = PTR_ERR(filter);
>> +             goto out;
>> +     }
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
>> +     /*
>> +      * If a process lacks CAP_SYS_ADMIN in its namespace, force
>> +      * this process and all descendents to run with no_new_privs.
>> +      * A privileged process will need to set this bit independently,
>> +      * if desired.
>> +      */
>> +     if (security_capable_noaudit(current_cred(), current_user_ns(),
>> +                                  CAP_SYS_ADMIN) != 0)
>> +             current->no_new_privs = 1;
>> +
>> +     /*
>> +      * If there is an existing filter, make it the parent
>> +      * and reuse the existing task-based ref.
>
> You're not reusing the existing task-based ref, are you?
>
> You can't reuse it anyway. Perhaps and old leftover comment?

I am reusing it.  When current->seccomp.filter is installed -- via
fork or attach -- a get_ is done.  That is for the task.  Here, we are
bumping current->seccomp.filter to filter->parent without calling
put_.  This reuses the task ref for the older filter.  The new filter
has a ref already from during alloc and that is transferred for use by
the task.

>> +      */
>> +     filter->parent = current->seccomp.filter;
>
> I think this needs a more verbose comment, here or elsewhere explaining how
> important it is that new filters are added to the start and old filters are
> never removed, or else list corruption can happen. This way assures that
> forward pointers are always valid, and that's the reason to use a singly
> linked list instead of a standard doubly linked list.

Cool - I can do that.

>> +#ifdef CONFIG_COMPAT
>> +     /* Disallow changing system calling conventions after the fact. */
>> +     filter->flags.compat = !!(is_compat_task());
>> +
>> +     if (filter->parent &&
>> +         filter->parent->flags.compat != filter->flags.compat)
>> +             return -EACCES;
>
> This shouldn't be possible and checking it here is too late if it somehow
> happened anyway.

Yeah you're right. Since mismatched-compat syscalls are blocked, we'd
never hit this point.  Thanks!

> (And you're leaking memory because current->seccomp.filter
> isn't updated yet.)

Fixed in v6 :)

>> +#endif
>> +
>> +     /*
>> +      * Double claim the new filter so we can release it below simplifying
>> +      * the error paths earlier.
>> +      */
>
> No it doesn't.

True enough. It did when I was doing ftrace setup. :/

>> +     ret = 0;
>> +     get_seccomp_filter(filter);
>> +     current->seccomp.filter = filter;
>> +     /* Engage seccomp if it wasn't. This doesn't use PR_SET_SECCOMP. */
>> +     if (current->seccomp.mode == SECCOMP_MODE_DISABLED) {
>> +             current->seccomp.mode = SECCOMP_MODE_FILTER;
>> +             set_thread_flag(TIF_SECCOMP);
>> +     }
>> +
>
> Just add a return 0; here, much simpler and removes 6 lines.
>
>> +out:
>> +     put_seccomp_filter(filter);  /* for get or task, on err */
>> +     return ret;
>> +}
>> +
>> +#ifdef CONFIG_COMPAT
>> +/* This should be kept in sync with net/compat.c which changes infrequently. */
>> +struct compat_sock_fprog {
>> +     u16 len;
>> +     compat_uptr_t filter;   /* struct sock_filter */
>> +};
>> +
>> +static long compat_attach_seccomp_filter(char __user *optval)
>> +{
>> +     struct compat_sock_fprog __user *fprog32 =
>> +             (struct compat_sock_fprog __user *)optval;
>> +     struct sock_fprog __user *kfprog =
>> +             compat_alloc_user_space(sizeof(struct sock_fprog));
>> +     compat_uptr_t ptr;
>> +     u16 len;
>> +
>> +     if (!access_ok(VERIFY_READ, fprog32, sizeof(*fprog32)) ||
>> +         !access_ok(VERIFY_WRITE, kfprog, sizeof(struct sock_fprog)) ||
>> +         __get_user(len, &fprog32->len) ||
>> +         __get_user(ptr, &fprog32->filter) ||
>> +         __put_user(len, &kfprog->len) ||
>> +         __put_user(compat_ptr(ptr), &kfprog->filter))
>> +             return -EFAULT;
>> +
>> +     return seccomp_attach_filter(kfprog);
>> +}
>> +#endif
>> +
>> +long prctl_attach_seccomp_filter(char __user *user_filter)
>> +{
>> +     struct sock_fprog fprog;
>> +     long ret = -EINVAL;
>> +     ret = -EFAULT;
>
> Why not set it to -EFAULT directly?

No reason. Looks like I cut out some code and didn't fix it.

>> +     if (!user_filter)
>> +             goto out;
>> +
>> +#ifdef CONFIG_COMPAT
>> +     if (is_compat_task())
>> +             return compat_attach_seccomp_filter(user_filter);
>> +#endif
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
>> + * seccomp_struct_fork: manages inheritance on fork
>> + * @child: forkee's seccomp_struct
>> + * @parent: forker's seccomp_struct
>> + *
>> + * Ensures that @child inherits seccomp mode and state iff
>
> 'if'

I guess they are equivalent for this purpose.

>> + * seccomp filtering is in use.
>> + */
>> +void seccomp_struct_fork(struct seccomp_struct *child,
>> +                      const struct seccomp_struct *parent)
>> +{
>> +     child->mode = parent->mode;
>> +     if (parent->mode != SECCOMP_MODE_FILTER)
>> +             return;
>> +     child->filter = get_seccomp_filter(parent->filter);
>
> I think how you manage the life times of the filters is very clever and that it
> needs some commenting because it is more subtle than it seems at first glance.
> The rules seem to be:
>
> - The list is sorted from new to old.
>
> - Never remove old filters.
>
> - The life-time of a group of filters (all filters set by one process between
>  fork calls) is managed by the one at the head of the group.
>
> This forms a tree with the head filters at forking points with the filters
> freed from the leave direction.

Exactly - sorry for it being poorly documented.  I will attempt to
document it more clearly in the next revision (probably using some of
your text above).

>> +}
>> +
>> +/**
>> + * seccomp_run_filter - evaluate BPF
>> + *   @buf: opaque buffer to execute the filter over
>> + *   @buflen: length of the buffer
>
> Out of date.

Doh. Thanks.

>> + *   @fentry: filter to apply
>> + *
>> + * Decode and apply filter instructions to the buffer.  Return length to
>> + * keep, 0 for none.
>
> This doesn't make sense in the context of system calls. Just return 0 for
> allowing the system call and -1 to deny it.

I know but all the shared error paths in the evaluator will return 0.
So on merge with the networking evaluator the return value for errors
needs to be abstracted too.  It'd be nice to not require more changes,
but it might be doable, I don't know.

>> @buf is a seccomp_filter_metadata we are filtering,
>> + * @filter is the array of filter instructions.  Because all jumps are
>> + * guaranteed to be before last instruction, and last instruction
>> + * guaranteed to be a RET, we dont need to check flen.
>> + *
>> + * See core/net/filter.c as this is nearly an exact copy.
>> + * At some point, it would be nice to merge them to take advantage of
>> + * optimizations (like JIT).
>> + */
>> +static unsigned int seccomp_run_filter(void *data, uint32_t datalen,
>> +                       const struct sock_filter *fentry)
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
>> +                     ptr = seccomp_load_pointer(data, k, 4, &tmp);
>> +                     if (ptr != NULL) {
>> +                             /*
>> +                              * Assume load_pointer did any byte swapping.
>> +                              */
>> +                             A = *(const u32 *)ptr;
>> +                             continue;
>> +                     }
>> +                     return 0;
>> +             case BPF_S_LD_H_ABS:
>> +                     k = K;
>> +load_h:
>> +                     ptr = seccomp_load_pointer(data, k, 2, &tmp);
>> +                     if (ptr != NULL) {
>> +                             A = *(const u16 *)ptr;
>> +                             continue;
>> +                     }
>> +                     return 0;
>> +             case BPF_S_LD_B_ABS:
>> +                     k = K;
>> +load_b:
>> +                     ptr = seccomp_load_pointer(data, k, 1, &tmp);
>> +                     if (ptr != NULL) {
>> +                             A = *(const u8 *)ptr;
>> +                             continue;
>> +                     }
>> +                     return 0;
>> +             case BPF_S_LD_W_LEN:
>> +                     A = datalen;
>> +                     continue;
>> +             case BPF_S_LDX_W_LEN:
>> +                     X = datalen;
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
>> +                     ptr = seccomp_load_pointer(data, K, 1, &tmp);
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
>
> All in all it seems fairly easy to consolidate this with the networking code.
> The only big change would be that the load_pointer() function pointer needs to
> be passed, that way the same code can be used for both versions. The filter
> checking code needs be expanded to check for network-only ops and reject the
> filter if it's a seccomp one.

Also byteswapping.  I think this can be done by adding pointer to the
accumulator to load_pointer, then let that do the byteswapping too.  I
guess I'll go ahead and try my hand at a merged patch and add it to
the end of the next series.  I wasn't planning on also attempting JIT
integration yet though ;)

>> diff --git a/kernel/sys.c b/kernel/sys.c
>> index 4070153..8e43f70 100644
>> --- a/kernel/sys.c
>> +++ b/kernel/sys.c
>> @@ -1901,6 +1901,10 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned
>> long, arg3,
>>               case PR_SET_SECCOMP:
>>                       error = prctl_set_seccomp(arg2);
>>                       break;
>> +             case PR_ATTACH_SECCOMP_FILTER:
>> +                     error = prctl_attach_seccomp_filter((char __user *)
>> +                                                             arg2);
>
> Please one line.

checkpatch was unhappy :)

> Actually, wouldn't it make more sense to use PR_SET_SECCOMP and check arg2 to
> see if it's filtering, and then get the filter itself from arg3 or something?

This is definitely preferable. Maybe something as simple as:
  prctl(PR_SET_SECCOMP, 2, fprog);
I'll make the changes - thanks!

> Or just stop calling it seccomp of course. PR_ATTACH_SYSCALL_FILTER?

Fine with me too, but it seems to make logical sense to keep it paired
with seccomp.  Especially if mode=1 just becomes a hardcoded bpf.

>> +                     break;
>>               case PR_GET_TSC:
>>                       error = GET_TSC_CTL(arg2);
>>                       break;
>> diff --git a/security/Kconfig b/security/Kconfig
>> index 51bd5a0..e1ffed8 100644
>> --- a/security/Kconfig
>> +++ b/security/Kconfig
>> @@ -84,6 +84,26 @@ config SECURITY_DMESG_RESTRICT
>>
>>         If you are unsure how to answer this question, answer N.
>>
>> +config SECCOMP_FILTER
>> +     bool "Enable seccomp-based system call filtering"
>> +     select SECCOMP
>> +     help
>> +       This option provide support for limiting the accessibility of
>> +       systems calls at a task-level using a dynamically defined policy.
>> +
>> +       System call filtering policy is expressed by the user using
>> +       a Berkeley Packet Filter program.  The program is attached using
>> +       prctl(2).  For every system call the task makes, its number,
>> +       arguments, and other metadata will be evaluated by the attached
>> +       filter program.  The result determines if the system call may
>> +       may proceed or if the task should be terminated.
>> +
>> +       This behavior is meant to aid security-conscious software in
>> +       its ability to minimize the risk of running potentially
>> +       risky code.
>> +
>> +       See Documentation/prctl/seccomp_filter.txt for more detail.
>> +
>>  config SECURITY
>>       bool "Enable different security models"
>>       depends on SYSFS
>> --
>> 1.7.5.4
>>
>>
>
> Greetings,

Thanks for the comprehensive review and feedback!
will

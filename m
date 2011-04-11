Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab1DKF7F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 01:59:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65172 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751096Ab1DKF7A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 01:59:00 -0400
Message-ID: <4DA29927.40401@cn.fujitsu.com>
Date: Mon, 11 Apr 2011 14:01:11 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Michal Marek <mmarek@suse.cz>,
        Jan Beulich <JBeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>, David Howells <dhowells@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH 4/5] RCU: Add TASK_RCU_OFFSET
References: <20110406201350.GA9378@linux.vnet.ibm.com> <1302123970.2207.4.camel@laptop> <4D9CDACB.9050705@linux.intel.com> <20110407003041.GD2265@linux.vnet.ibm.com> <4D9D507F.2040006@cn.fujitsu.com> <20110407154737.GF2262@linux.vnet.ibm.com> <20110407162600.GA24227@linux.vnet.ibm.com> <4D9E6438.5030206@cn.fujitsu.com> <20110408051359.GA2318@linux.vnet.ibm.com> <4DA2709E.50902@cn.fujitsu.com> <20110411051241.GB18415@linux.vnet.ibm.com>
In-Reply-To: <20110411051241.GB18415@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-11 13:59:38,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-11 13:59:39
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2011 01:12 PM, Paul E. McKenney wrote:
> On Mon, Apr 11, 2011 at 11:08:14AM +0800, Lai Jiangshan wrote:
>> On 04/08/2011 01:13 PM, Paul E. McKenney wrote:
>>> On Fri, Apr 08, 2011 at 09:26:16AM +0800, Lai Jiangshan wrote:
>>>> On 04/08/2011 12:26 AM, Paul E. McKenney wrote:
>>>>> On Thu, Apr 07, 2011 at 08:47:37AM -0700, Paul E. McKenney wrote:
>>>>>> On Thu, Apr 07, 2011 at 01:49:51PM +0800, Lai Jiangshan wrote:
>>>>>>> On 04/07/2011 08:30 AM, Paul E. McKenney wrote:
>>>>>>>> On Wed, Apr 06, 2011 at 02:27:39PM -0700, H. Peter Anvin wrote:
>>>>>>>>> On 04/06/2011 02:06 PM, Peter Zijlstra wrote:
>>>>>>>>>> On Wed, 2011-04-06 at 13:13 -0700, Paul E. McKenney wrote:
>>>>>>>>>>> And the following patch builds correctly for defconfig x86 builds,
>>>>>>>>>>> while allowing rcupdate.h to see the sched.h definitions as needed
>>>>>>>>>>> to inline rcu_read_lock() and rcu_read_unlock().
>>>>>>>>>>>
>>>>>>>>>> Looks like an entirely reasonable patch to me ;-)
>>>>>>>>>>
>>>>>>>>>
>>>>>>>>> Quite... a lot better than the original proposal!
>>>>>>>>
>>>>>>>> Glad you both like it!
>>>>>>>>
>>>>>>>> When I do an allyesconfig build, I do get errors during the "CHECK"
>>>>>>>> phase, when it is putting things into the usr/include in the build tree.
>>>>>>>> I believe that this is because I am exposing different header files to
>>>>>>>> the library-export scripts.  The following patch silences some of them,
>>>>>>>> but I am really out of my depth here.
>>>>>>>>
>>>>>>>> Sam, Jan, Michal, help?
>>>>>>>>
>>>>>>>> 							Thanx, Paul
>>>>>>>>
>>>>>>>> ------------------------------------------------------------------------
>>>>>>>>
>>>>>>>
>>>>>>> Easy to split rcupdate.h, hard to resolve the dependence problem.
>>>>>>>
>>>>>>> You can apply the next additional patch when you test:
>>>>>>
>>>>>> I am sure that you are quite correct.  ;-)
>>>>>>
>>>>>> I am moving _rcu_read_lock() and _rcu_read_unlock() into
>>>>>> include/linux/rcutree.h and include/linux/rcutiny.h, and I am sure that
>>>>>> more pain will ensue.
>>>>>>
>>>>>> One thing I don't understand...  How does is it helping to group the
>>>>>> task_struct RCU-related fields into a structure?  Is that generating
>>>>>> better code on your platform due to smaller offsets or something?
>>>>
>>>> You don't like task_rcu_struct patch? I think it can make code clearer,
>>>> and it can also check the code even when CONFIG_PREEMPT_RCU=n.
>>>>
>>>> For rcu_read_[un]lock(), it generates the same code, no better, no worse.
>>>>
>>>> It is just a cleanup patch, it is helpless for making rcu_read_[un]lock() inline,
>>>> if you don't like it, I will give up it.
>>>
>>> I don't know that I feel strongly either way about it.  It was necessary
>>> with the integer-offset approach, but optional now.
>>>
>>>>>> Also, does your patchset address the CHECK warnings?
>>>>>
>>>>> I take it back...  I applied the following patch on top of my earlier
>>>>> one, and a defconfig x86 build completed without error.  (Though I have
>>>>> not tested the results of the build.)
>>>>>
>>>>> One possible difference -- I did this work on top of a recent Linus
>>>>> git commit (b2a8b4b81966) rather than on top of my -rcu tree.  Also,
>>>>> I have not yet tried an allyesconfig build, which will no doubt locate
>>>>> some more problems.
>>>>>
>>>>> 							Thanx, Paul
>>>>>
>>>>
>>>> when defconfig or allyesconfig, CONFIG_PREEMPT=n and CONFIG_TREE_PREEMPT_RCU=n
>>>> when you make them "y":
>>>>
>>>> In file included from include/linux/rcupdate.h:764:0,
>>>>                  from include/linux/tracepoint.h:19,
>>>>                  from include/linux/module.h:18,
>>>>                  from include/linux/crypto.h:21,
>>>>                  from arch/x86/kernel/asm-offsets.c:8:
>>>> include/linux/rcutree.h:50:20: error: static declaration of ‘__rcu_read_lock’ follows non-static declaration
>>>> include/linux/rcupdate.h:76:13: note: previous declaration of ‘__rcu_read_lock’ was here
>>>> include/linux/rcutree.h:63:20: error: static declaration of ‘__rcu_read_unlock’ follows non-static declaration
>>>> include/linux/rcupdate.h:77:13: note: previous declaration of ‘__rcu_read_unlock’ was here
>>>> make[1]: *** [arch/x86/kernel/asm-offsets.s] Error 1
>>>> make: *** [prepare0] Error 2
>>>
>>> Yep.  I need to move the rcu_read_lock() APIs to follow the inclusion
>>> of rcutree.h and rcutiny.h.  Also add include of sched.h to rcutiny.h.
>>> The code movement does bloat the patch a bit.  But rcu_assign_pointer()
>>> must precede the inclusion of rcutree.h and rcutiny.h, so it is not
>>> possible to simply move the inclusions.  See below.
>>>
>>> 							Thanx, Paul
>>>
>>
>> sched.h still contains rcupdate.h after applied this patch.
> 
> Then we are not in sync -- sched.h does not include rcupdate.h in my tree.
> It instead gets the struct rcu_head definition from include/linux/types.h.
> See below for a consolidated patch.
> 
> 							Thanx, Paul
> 
>> See my [PATCH 2/4] for more info.
>>
>>
>> # make lib/is_single_threaded.o
>>   CHK     include/linux/version.h
>>   CHK     include/generated/utsrelease.h
>>   CALL    scripts/checksyscalls.sh
>>   CC      lib/is_single_threaded.o
>> In file included from include/linux/rcupdate.h:639:0,
>>                  from include/linux/rculist.h:10,
>>                  from include/linux/sched.h:82,
>>                  from lib/is_single_threaded.c:13:
>> include/linux/rcutree.h: In function ‘__rcu_read_lock’:
>> include/linux/rcutree.h:52:15: error: dereferencing pointer to incomplete type
>> In file included from include/linux/rcupdate.h:639:0,
>>                  from include/linux/rculist.h:10,
>>                  from include/linux/sched.h:82,
>>                  from lib/is_single_threaded.c:13:
>> include/linux/rcutree.h: In function ‘__rcu_read_unlock’:
>> include/linux/rcutree.h:68:5: error: dereferencing pointer to incomplete type
>> include/linux/rcutree.h:70:7: error: dereferencing pointer to incomplete type
>> include/linux/rcutree.h:71:46: error: dereferencing pointer to incomplete type
>> include/linux/rcutree.h:71:78: error: dereferencing pointer to incomplete type
>> include/linux/rcutree.h:71:6: warning: type defaults to ‘int’ in type name
>> make[1]: *** [lib/is_single_threaded.o] Error 1
>> make: *** [lib/is_single_threaded.o] Error 2


sched.h still contains rcupdate.h after applied this patch.
so it still fails.


Is your .config with CONFIG_TREE_PREEMPT_RCU=y ?

> 
>  drivers/scsi/scsi_sysctl.c |    1 +
>  fs/proc/proc_sysctl.c      |    1 +
>  include/linux/kernel.h     |    3 +++
>  include/linux/pid.h        |    2 +-
>  include/linux/rcupdate.h   |   29 +++++++++--------------------
>  include/linux/rcutiny.h    |   35 +++++++++++++++++++++++++++++++++++
>  include/linux/rcutree.h    |   37 +++++++++++++++++++++++++++++++++++++
>  include/linux/sched.h      |   10 ++++------
>  include/linux/sem.h        |    2 +-
>  include/linux/soundcard.h  |    2 ++
>  include/linux/sysctl.h     |    5 +++--
>  include/linux/types.h      |   10 ++++++++++
>  kernel/pid_namespace.c     |    2 ++
>  kernel/rcutiny_plugin.h    |   38 ++------------------------------------
>  kernel/rcutree_plugin.h    |   38 ++------------------------------------
>  kernel/sysctl_binary.c     |    1 +
>  kernel/sysctl_check.c      |    1 +
>  net/core/sysctl_net_core.c |    1 +
>  net/dccp/sysctl.c          |    1 +
>  net/ipv6/sysctl_net_ipv6.c |    1 +
>  net/irda/irsysctl.c        |    1 +
>  net/phonet/sysctl.c        |    1 +
>  net/rds/ib_sysctl.c        |    1 +
>  net/rds/iw_sysctl.c        |    1 +
>  net/rds/sysctl.c           |    1 +
>  net/sctp/sysctl.c          |    1 +
>  net/sunrpc/sysctl.c        |    1 +
>  net/unix/sysctl_net_unix.c |    1 +
>  net/xfrm/xfrm_sysctl.c     |    1 +
>  29 files changed, 127 insertions(+), 102 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_sysctl.c b/drivers/scsi/scsi_sysctl.c
> index 2b6b93f..ecce1c6 100644
> --- a/drivers/scsi/scsi_sysctl.c
> +++ b/drivers/scsi/scsi_sysctl.c
> @@ -6,6 +6,7 @@
>  #include <linux/errno.h>
>  #include <linux/init.h>
>  #include <linux/kernel.h>
> +#include <linux/key.h>
>  #include <linux/sysctl.h>
>  
>  #include "scsi_logging.h"
> diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
> index f50133c..180bf3e 100644
> --- a/fs/proc/proc_sysctl.c
> +++ b/fs/proc/proc_sysctl.c
> @@ -2,6 +2,7 @@
>   * /proc/sys support
>   */
>  #include <linux/init.h>
> +#include <linux/key.h>
>  #include <linux/sysctl.h>
>  #include <linux/proc_fs.h>
>  #include <linux/security.h>
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 00cec4d..a243c13 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -648,6 +648,8 @@ struct sysinfo {
>  #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
>  #define BUILD_BUG_ON_NULL(e) ((void *)sizeof(struct { int:-!!(e); }))
>  
> +#ifdef __KERNEL__
> +
>  /**
>   * BUILD_BUG_ON - break compile if a condition is true.
>   * @condition: the condition which the compiler should know is false.
> @@ -673,6 +675,7 @@ extern int __build_bug_on_failed;
>  		if (condition) __build_bug_on_failed = 1;	\
>  	} while(0)
>  #endif
> +#endif /* __KERNEL__ */
>  
>  /* Trap pasters of __FUNCTION__ at compile-time */
>  #define __FUNCTION__ (__func__)
> diff --git a/include/linux/pid.h b/include/linux/pid.h
> index efceda0..3c5719b 100644
> --- a/include/linux/pid.h
> +++ b/include/linux/pid.h
> @@ -1,7 +1,7 @@
>  #ifndef _LINUX_PID_H
>  #define _LINUX_PID_H
>  
> -#include <linux/rcupdate.h>
> +#include <linux/types.h>
>  
>  enum pid_type
>  {
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index ff422d2..d009ebf 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -33,6 +33,7 @@
>  #ifndef __LINUX_RCUPDATE_H
>  #define __LINUX_RCUPDATE_H
>  
> +#include <linux/types.h>
>  #include <linux/cache.h>
>  #include <linux/spinlock.h>
>  #include <linux/threads.h>
> @@ -52,16 +53,6 @@ extern int rcutorture_runnable; /* for sysctl */
>  #define ULONG_CMP_GE(a, b)	(ULONG_MAX / 2 >= (a) - (b))
>  #define ULONG_CMP_LT(a, b)	(ULONG_MAX / 2 < (a) - (b))
>  
> -/**
> - * struct rcu_head - callback structure for use with RCU
> - * @next: next update requests in a list
> - * @func: actual update function to call after the grace period.
> - */
> -struct rcu_head {
> -	struct rcu_head *next;
> -	void (*func)(struct rcu_head *head);
> -};
> -
>  /* Exported common interfaces */
>  extern void call_rcu_sched(struct rcu_head *head,
>  			   void (*func)(struct rcu_head *rcu));
> @@ -82,8 +73,6 @@ static inline void __rcu_read_unlock_bh(void)
>  
>  #ifdef CONFIG_PREEMPT_RCU
>  
> -extern void __rcu_read_lock(void);
> -extern void __rcu_read_unlock(void);
>  void synchronize_rcu(void);
>  
>  /*
> @@ -141,14 +130,6 @@ static inline void rcu_exit_nohz(void)
>  
>  #endif /* #else #ifdef CONFIG_NO_HZ */
>  
> -#if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
> -#include <linux/rcutree.h>
> -#elif defined(CONFIG_TINY_RCU) || defined(CONFIG_TINY_PREEMPT_RCU)
> -#include <linux/rcutiny.h>
> -#else
> -#error "Unknown RCU implementation specified to kernel configuration"
> -#endif
> -
>  /*
>   * init_rcu_head_on_stack()/destroy_rcu_head_on_stack() are needed for dynamic
>   * initialization and destruction of rcu_head on the stack. rcu_head structures
> @@ -797,4 +778,12 @@ static inline void debug_rcu_head_unqueue(struct rcu_head *head)
>  }
>  #endif	/* #else !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
>  
> +#if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
> +#include <linux/rcutree.h>
> +#elif defined(CONFIG_TINY_RCU) || defined(CONFIG_TINY_PREEMPT_RCU)
> +#include <linux/rcutiny.h>
> +#else
> +#error "Unknown RCU implementation specified to kernel configuration"
> +#endif
> +
>  #endif /* __LINUX_RCUPDATE_H */
> diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
> index 30ebd7c..167fb19 100644
> --- a/include/linux/rcutiny.h
> +++ b/include/linux/rcutiny.h
> @@ -26,6 +26,7 @@
>  #define __LINUX_TINY_H
>  
>  #include <linux/cache.h>
> +#include <linux/sched.h>
>  
>  static inline void rcu_init(void)
>  {
> @@ -47,6 +48,40 @@ static inline void rcu_barrier(void)
>  
>  void rcu_barrier(void);
>  void synchronize_rcu_expedited(void);
> +void rcu_read_unlock_special(struct task_struct *t);
> +
> +/*
> + * Tiny-preemptible RCU implementation for rcu_read_lock().
> + * Just increment ->rcu_read_lock_nesting, shared state will be updated
> + * if we block.
> + */
> +static inline void __rcu_read_lock(void)
> +{
> +	current->rcu_read_lock_nesting++;
> +	barrier();
> +}
> +
> +/*
> + * Tiny-preemptible RCU implementation for rcu_read_unlock().
> + * Decrement ->rcu_read_lock_nesting.  If the result is zero (outermost
> + * rcu_read_unlock()) and ->rcu_read_unlock_special is non-zero, then
> + * invoke rcu_read_unlock_special() to clean up after a context switch
> + * in an RCU read-side critical section and other special cases.
> + */
> +static inline void __rcu_read_unlock(void)
> +{
> +	struct task_struct *t = current;
> +
> +	barrier();
> +	--t->rcu_read_lock_nesting;
> +	barrier();  /* decrement before load of ->rcu_read_unlock_special */
> +	if (t->rcu_read_lock_nesting == 0 &&
> +	    unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
> +		rcu_read_unlock_special(t);
> +#ifdef CONFIG_PROVE_LOCKING
> +	WARN_ON_ONCE(t->rcu_read_lock_nesting < 0);
> +#endif /* #ifdef CONFIG_PROVE_LOCKING */
> +}
>  
>  #endif /* #else #ifdef CONFIG_TINY_RCU */
>  
> diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
> index 3a93348..012cc1c 100644
> --- a/include/linux/rcutree.h
> +++ b/include/linux/rcutree.h
> @@ -30,6 +30,8 @@
>  #ifndef __LINUX_RCUTREE_H
>  #define __LINUX_RCUTREE_H
>  
> +#include <linux/sched.h>
> +
>  extern void rcu_init(void);
>  extern void rcu_note_context_switch(int cpu);
>  extern int rcu_needs_cpu(int cpu);
> @@ -37,6 +39,41 @@ extern void rcu_cpu_stall_reset(void);
>  
>  #ifdef CONFIG_TREE_PREEMPT_RCU
>  
> +extern void rcu_read_unlock_special(struct task_struct *t);
> +
> +/*
> + * Tree-preemptable RCU implementation for rcu_read_lock().
> + * Just increment ->rcu_read_lock_nesting, shared state will be updated
> + * if we block.
> + */
> +static inline void __rcu_read_lock(void)
> +{
> +	current->rcu_read_lock_nesting++;
> +	barrier();
> +}
> +
> +/*
> + * Tree-preemptable RCU implementation for rcu_read_unlock().
> + * Decrement ->rcu_read_lock_nesting.  If the result is zero (outermost
> + * rcu_read_unlock()) and ->rcu_read_unlock_special is non-zero, then
> + * invoke rcu_read_unlock_special() to clean up after a context switch
> + * in an RCU read-side critical section and other special cases.
> + */
> +static inline void __rcu_read_unlock(void)
> +{
> +	struct task_struct *t = current;
> +
> +	barrier();
> +	--t->rcu_read_lock_nesting;
> +	barrier();  /* decrement before load of ->rcu_read_unlock_special */
> +	if (t->rcu_read_lock_nesting == 0 &&
> +	    unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
> +		rcu_read_unlock_special(t);
> +#ifdef CONFIG_PROVE_LOCKING
> +	WARN_ON_ONCE(ACCESS_ONCE(t->rcu_read_lock_nesting) < 0);
> +#endif /* #ifdef CONFIG_PROVE_LOCKING */
> +}
> +
>  extern void exit_rcu(void);
>  
>  #else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 83bd2e2..30a4444 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -78,7 +78,7 @@ struct sched_param {
>  #include <linux/topology.h>
>  #include <linux/proportions.h>
>  #include <linux/seccomp.h>
> -#include <linux/rcupdate.h>
> +#include <linux/types.h>
>  #include <linux/rculist.h>
>  #include <linux/rtmutex.h>
>  
> @@ -2241,11 +2241,9 @@ int same_thread_group(struct task_struct *p1, struct task_struct *p2)
>  	return p1->tgid == p2->tgid;
>  }
>  
> -static inline struct task_struct *next_thread(const struct task_struct *p)
> -{
> -	return list_entry_rcu(p->thread_group.next,
> -			      struct task_struct, thread_group);
> -}
> +/* Avoid #include hell for inlining rcu_read_lock(). */
> +#define next_thread(p) \
> +	list_entry_rcu((p)->thread_group.next, struct task_struct, thread_group)
>  
>  static inline int thread_group_empty(struct task_struct *p)
>  {
> diff --git a/include/linux/sem.h b/include/linux/sem.h
> index f2961af..8489a1f 100644
> --- a/include/linux/sem.h
> +++ b/include/linux/sem.h
> @@ -78,7 +78,7 @@ struct  seminfo {
>  
>  #ifdef __KERNEL__
>  #include <asm/atomic.h>
> -#include <linux/rcupdate.h>
> +#include <linux/types.h>
>  #include <linux/cache.h>
>  
>  struct task_struct;
> diff --git a/include/linux/soundcard.h b/include/linux/soundcard.h
> index 1904afe..f99c32f 100644
> --- a/include/linux/soundcard.h
> +++ b/include/linux/soundcard.h
> @@ -1064,7 +1064,9 @@ typedef struct mixer_vol_table {
>   */
>  #define SEQ_DECLAREBUF()		SEQ_USE_EXTBUF()
>  
> +#ifdef __KERNEL__
>  void seqbuf_dump(void);	/* This function must be provided by programs */
> +#endif
>  
>  #define SEQ_PM_DEFINES int __foo_bar___
>  
> diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
> index 11684d9..be80a59 100644
> --- a/include/linux/sysctl.h
> +++ b/include/linux/sysctl.h
> @@ -19,6 +19,8 @@
>   ****************************************************************
>   */
>  
> +#include <linux/key.h>
> +
>  #ifndef _LINUX_SYSCTL_H
>  #define _LINUX_SYSCTL_H
>  
> @@ -1012,8 +1014,7 @@ extern int proc_do_large_bitmap(struct ctl_table *, int,
>   */
>  
>  /* A sysctl table is an array of struct ctl_table: */
> -struct ctl_table 
> -{
> +struct ctl_table {
>  	const char *procname;		/* Text ID for /proc/sys, or zero */
>  	void *data;
>  	int maxlen;
> diff --git a/include/linux/types.h b/include/linux/types.h
> index 176da8c..868ef8b 100644
> --- a/include/linux/types.h
> +++ b/include/linux/types.h
> @@ -231,6 +231,16 @@ struct hlist_node {
>  	struct hlist_node *next, **pprev;
>  };
>  
> +/**
> + * struct rcu_head - callback structure for use with RCU
> + * @next: next update requests in a list
> + * @func: actual update function to call after the grace period.
> + */
> +struct rcu_head {
> +	struct rcu_head *next;
> +	void (*func)(struct rcu_head *head);
> +};
> +
>  struct ustat {
>  	__kernel_daddr_t	f_tfree;
>  	__kernel_ino_t		f_tinode;
> diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
> index e9c9adc..bfa75df 100644
> --- a/kernel/pid_namespace.c
> +++ b/kernel/pid_namespace.c
> @@ -8,6 +8,8 @@
>   *
>   */
>  
> +#include <linux/types.h>
> +#include <asm/atomic.h>
>  #include <linux/pid.h>
>  #include <linux/pid_namespace.h>
>  #include <linux/syscalls.h>
> diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
> index 3cb8e36..d0e1ac3 100644
> --- a/kernel/rcutiny_plugin.h
> +++ b/kernel/rcutiny_plugin.h
> @@ -520,23 +520,11 @@ void rcu_preempt_note_context_switch(void)
>  }
>  
>  /*
> - * Tiny-preemptible RCU implementation for rcu_read_lock().
> - * Just increment ->rcu_read_lock_nesting, shared state will be updated
> - * if we block.
> - */
> -void __rcu_read_lock(void)
> -{
> -	current->rcu_read_lock_nesting++;
> -	barrier();  /* needed if we ever invoke rcu_read_lock in rcutiny.c */
> -}
> -EXPORT_SYMBOL_GPL(__rcu_read_lock);
> -
> -/*
>   * Handle special cases during rcu_read_unlock(), such as needing to
>   * notify RCU core processing or task having blocked during the RCU
>   * read-side critical section.
>   */
> -static void rcu_read_unlock_special(struct task_struct *t)
> +void rcu_read_unlock_special(struct task_struct *t)
>  {
>  	int empty;
>  	int empty_exp;
> @@ -616,29 +604,7 @@ static void rcu_read_unlock_special(struct task_struct *t)
>  #endif /* #ifdef CONFIG_RCU_BOOST */
>  	local_irq_restore(flags);
>  }
> -
> -/*
> - * Tiny-preemptible RCU implementation for rcu_read_unlock().
> - * Decrement ->rcu_read_lock_nesting.  If the result is zero (outermost
> - * rcu_read_unlock()) and ->rcu_read_unlock_special is non-zero, then
> - * invoke rcu_read_unlock_special() to clean up after a context switch
> - * in an RCU read-side critical section and other special cases.
> - */
> -void __rcu_read_unlock(void)
> -{
> -	struct task_struct *t = current;
> -
> -	barrier();  /* needed if we ever invoke rcu_read_unlock in rcutiny.c */
> -	--t->rcu_read_lock_nesting;
> -	barrier();  /* decrement before load of ->rcu_read_unlock_special */
> -	if (t->rcu_read_lock_nesting == 0 &&
> -	    unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
> -		rcu_read_unlock_special(t);
> -#ifdef CONFIG_PROVE_LOCKING
> -	WARN_ON_ONCE(t->rcu_read_lock_nesting < 0);
> -#endif /* #ifdef CONFIG_PROVE_LOCKING */
> -}
> -EXPORT_SYMBOL_GPL(__rcu_read_unlock);
> +EXPORT_SYMBOL_GPL(rcu_read_unlock_special);
>  
>  /*
>   * Check for a quiescent state from the current CPU.  When a task blocks,
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index a363871..4b27afd 100644
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -196,18 +196,6 @@ static void rcu_preempt_note_context_switch(int cpu)
>  }
>  
>  /*
> - * Tree-preemptable RCU implementation for rcu_read_lock().
> - * Just increment ->rcu_read_lock_nesting, shared state will be updated
> - * if we block.
> - */
> -void __rcu_read_lock(void)
> -{
> -	current->rcu_read_lock_nesting++;
> -	barrier();  /* needed if we ever invoke rcu_read_lock in rcutree.c */
> -}
> -EXPORT_SYMBOL_GPL(__rcu_read_lock);
> -
> -/*
>   * Check for preempted RCU readers blocking the current grace period
>   * for the specified rcu_node structure.  If the caller needs a reliable
>   * answer, it must hold the rcu_node's ->lock.
> @@ -261,7 +249,7 @@ static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp, unsigned long flags)
>   * notify RCU core processing or task having blocked during the RCU
>   * read-side critical section.
>   */
> -static void rcu_read_unlock_special(struct task_struct *t)
> +void rcu_read_unlock_special(struct task_struct *t)
>  {
>  	int empty;
>  	int empty_exp;
> @@ -332,29 +320,7 @@ static void rcu_read_unlock_special(struct task_struct *t)
>  		local_irq_restore(flags);
>  	}
>  }
> -
> -/*
> - * Tree-preemptable RCU implementation for rcu_read_unlock().
> - * Decrement ->rcu_read_lock_nesting.  If the result is zero (outermost
> - * rcu_read_unlock()) and ->rcu_read_unlock_special is non-zero, then
> - * invoke rcu_read_unlock_special() to clean up after a context switch
> - * in an RCU read-side critical section and other special cases.
> - */
> -void __rcu_read_unlock(void)
> -{
> -	struct task_struct *t = current;
> -
> -	barrier();  /* needed if we ever invoke rcu_read_unlock in rcutree.c */
> -	--t->rcu_read_lock_nesting;
> -	barrier();  /* decrement before load of ->rcu_read_unlock_special */
> -	if (t->rcu_read_lock_nesting == 0 &&
> -	    unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
> -		rcu_read_unlock_special(t);
> -#ifdef CONFIG_PROVE_LOCKING
> -	WARN_ON_ONCE(ACCESS_ONCE(t->rcu_read_lock_nesting) < 0);
> -#endif /* #ifdef CONFIG_PROVE_LOCKING */
> -}
> -EXPORT_SYMBOL_GPL(__rcu_read_unlock);
> +EXPORT_SYMBOL_GPL(rcu_read_unlock_special);
>  
>  #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
>  
> diff --git a/kernel/sysctl_binary.c b/kernel/sysctl_binary.c
> index 3b8e028..58097b7 100644
> --- a/kernel/sysctl_binary.c
> +++ b/kernel/sysctl_binary.c
> @@ -1,4 +1,5 @@
>  #include <linux/stat.h>
> +#include <linux/key.h>
>  #include <linux/sysctl.h>
>  #include "../fs/xfs/linux-2.6/xfs_sysctl.h"
>  #include <linux/sunrpc/debug.h>
> diff --git a/kernel/sysctl_check.c b/kernel/sysctl_check.c
> index 4e4932a..a8a0df5 100644
> --- a/kernel/sysctl_check.c
> +++ b/kernel/sysctl_check.c
> @@ -1,4 +1,5 @@
>  #include <linux/stat.h>
> +#include <linux/key.h>
>  #include <linux/sysctl.h>
>  #include "../fs/xfs/linux-2.6/xfs_sysctl.h"
>  #include <linux/sunrpc/debug.h>
> diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
> index 385b609..528b975 100644
> --- a/net/core/sysctl_net_core.c
> +++ b/net/core/sysctl_net_core.c
> @@ -6,6 +6,7 @@
>   */
>  
>  #include <linux/mm.h>
> +#include <linux/key.h>
>  #include <linux/sysctl.h>
>  #include <linux/module.h>
>  #include <linux/socket.h>
> diff --git a/net/dccp/sysctl.c b/net/dccp/sysctl.c
> index 4234882..bf609bc 100644
> --- a/net/dccp/sysctl.c
> +++ b/net/dccp/sysctl.c
> @@ -10,6 +10,7 @@
>   */
>  
>  #include <linux/mm.h>
> +#include <linux/key.h>
>  #include <linux/sysctl.h>
>  #include "dccp.h"
>  #include "feat.h"
> diff --git a/net/ipv6/sysctl_net_ipv6.c b/net/ipv6/sysctl_net_ipv6.c
> index 6dcf5e7..97a3ce0 100644
> --- a/net/ipv6/sysctl_net_ipv6.c
> +++ b/net/ipv6/sysctl_net_ipv6.c
> @@ -6,6 +6,7 @@
>   */
>  
>  #include <linux/mm.h>
> +#include <linux/key.h>
>  #include <linux/sysctl.h>
>  #include <linux/in6.h>
>  #include <linux/ipv6.h>
> diff --git a/net/irda/irsysctl.c b/net/irda/irsysctl.c
> index d0b70da..11aaf12 100644
> --- a/net/irda/irsysctl.c
> +++ b/net/irda/irsysctl.c
> @@ -25,6 +25,7 @@
>  
>  #include <linux/mm.h>
>  #include <linux/ctype.h>
> +#include <linux/key.h>
>  #include <linux/sysctl.h>
>  #include <linux/init.h>
>  
> diff --git a/net/phonet/sysctl.c b/net/phonet/sysctl.c
> index cea1c7d..2c2d479 100644
> --- a/net/phonet/sysctl.c
> +++ b/net/phonet/sysctl.c
> @@ -23,6 +23,7 @@
>   */
>  
>  #include <linux/seqlock.h>
> +#include <linux/key.h>
>  #include <linux/sysctl.h>
>  #include <linux/errno.h>
>  #include <linux/init.h>
> diff --git a/net/rds/ib_sysctl.c b/net/rds/ib_sysctl.c
> index 1253b00..2f9a1a7 100644
> --- a/net/rds/ib_sysctl.c
> +++ b/net/rds/ib_sysctl.c
> @@ -31,6 +31,7 @@
>   *
>   */
>  #include <linux/kernel.h>
> +#include <linux/key.h>
>  #include <linux/sysctl.h>
>  #include <linux/proc_fs.h>
>  
> diff --git a/net/rds/iw_sysctl.c b/net/rds/iw_sysctl.c
> index e2e4717..8c4051b 100644
> --- a/net/rds/iw_sysctl.c
> +++ b/net/rds/iw_sysctl.c
> @@ -31,6 +31,7 @@
>   *
>   */
>  #include <linux/kernel.h>
> +#include <linux/key.h>
>  #include <linux/sysctl.h>
>  #include <linux/proc_fs.h>
>  
> diff --git a/net/rds/sysctl.c b/net/rds/sysctl.c
> index 25ad0c7..46d2d1d 100644
> --- a/net/rds/sysctl.c
> +++ b/net/rds/sysctl.c
> @@ -31,6 +31,7 @@
>   *
>   */
>  #include <linux/kernel.h>
> +#include <linux/key.h>
>  #include <linux/sysctl.h>
>  #include <linux/proc_fs.h>
>  
> diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
> index 50cb57f..c2903ce 100644
> --- a/net/sctp/sysctl.c
> +++ b/net/sctp/sysctl.c
> @@ -43,6 +43,7 @@
>  
>  #include <net/sctp/structs.h>
>  #include <net/sctp/sctp.h>
> +#include <linux/key.h>
>  #include <linux/sysctl.h>
>  
>  static int zero = 0;
> diff --git a/net/sunrpc/sysctl.c b/net/sunrpc/sysctl.c
> index e65dcc6..1429601 100644
> --- a/net/sunrpc/sysctl.c
> +++ b/net/sunrpc/sysctl.c
> @@ -11,6 +11,7 @@
>  #include <linux/linkage.h>
>  #include <linux/ctype.h>
>  #include <linux/fs.h>
> +#include <linux/key.h>
>  #include <linux/sysctl.h>
>  #include <linux/module.h>
>  
> diff --git a/net/unix/sysctl_net_unix.c b/net/unix/sysctl_net_unix.c
> index 397cffe..6d2766e 100644
> --- a/net/unix/sysctl_net_unix.c
> +++ b/net/unix/sysctl_net_unix.c
> @@ -11,6 +11,7 @@
>  
>  #include <linux/mm.h>
>  #include <linux/slab.h>
> +#include <linux/key.h>
>  #include <linux/sysctl.h>
>  
>  #include <net/af_unix.h>
> diff --git a/net/xfrm/xfrm_sysctl.c b/net/xfrm/xfrm_sysctl.c
> index 05640bc..a50e4bf 100644
> --- a/net/xfrm/xfrm_sysctl.c
> +++ b/net/xfrm/xfrm_sysctl.c
> @@ -1,3 +1,4 @@
> +#include <linux/key.h>
>  #include <linux/sysctl.h>
>  #include <linux/slab.h>
>  #include <net/net_namespace.h>
> 


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967Ab1BNQMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 11:12:24 -0500
Received: from blu0-omc1-s4.blu0.hotmail.com ([65.55.116.15]:60128 "EHLO
	blu0-omc1-s4.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755953Ab1BNQMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 11:12:22 -0500
X-Originating-IP: [174.91.193.52]
X-Originating-Email: [pdumas9@sympatico.ca]
Message-ID: <BLU0-SMTP98BCAC0F7C86423BF0BE0996D00@phx.gbl>
Date: Mon, 14 Feb 2011 11:11:42 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
CC: Jason Baron <jbaron@redhat.com>, hpa@zytor.com, rostedt@goodmis.org,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
References: <cover.1294239591.git.jbaron@redhat.com> <1297452328.5226.89.camel@laptop> <BLU0-SMTP101B686C32E10BA346B15F896EF0@phx.gbl> <1297460297.5226.99.camel@laptop> <1297536465.5226.108.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1297536465.5226.108.camel@laptop>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 11:09:59 up 313 days,  1:59,  7 users,  load average: 1.58, 1.63,
	1.63
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 14 Feb 2011 16:12:02.0603 (UTC) FILETIME=[EA5CB7B0:01CBCC61]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Fri, 2011-02-11 at 22:38 +0100, Peter Zijlstra wrote:
> > 
> > So why can't we make that jump_label_entry::refcount and
> > jump_label_key::state an atomic_t and be done with it? 
> 
> So I had a bit of a poke at this because I didn't quite understand why
> all that stuff was as it was. I applied both Jason's patches and then
> basically rewrote kernel/jump_label.c just for kicks ;-)
> 
> I haven't tried compiling this, let alone running it, but provided I
> didn't actually forget anything the storage per key is now 16 bytes when
> modules are disabled and 24 * (1 + mods) bytes for when they are
> enabled. The old code had 64 + 40 * mods bytes.
> 
> I still need to clean up the static_branch_else bits and look at !x86
> aside from the already mentioned bits.. but what do people think?

Hi Peter,

It looks like a huge step in the right direction. I'm sure that once
Jason and you finish ironing out the details, this will be a huge
improvement in terms of shrinking code and API complexity.

Thanks,

Mathieu

> 
> ---
>  arch/sparc/include/asm/jump_label.h |   25 +-
>  arch/x86/include/asm/jump_label.h   |   22 +-
>  arch/x86/kernel/jump_label.c        |    2 +-
>  arch/x86/kernel/module.c            |    3 -
>  include/linux/dynamic_debug.h       |   10 +-
>  include/linux/jump_label.h          |   71 +++---
>  include/linux/jump_label_ref.h      |   36 +--
>  include/linux/module.h              |    1 +
>  include/linux/perf_event.h          |   28 +-
>  include/linux/tracepoint.h          |    8 +-
>  kernel/jump_label.c                 |  516 +++++++++++++----------------------
>  kernel/module.c                     |    7 +
>  kernel/perf_event.c                 |   30 ++-
>  kernel/timer.c                      |    8 +-
>  kernel/tracepoint.c                 |   22 +-
>  15 files changed, 333 insertions(+), 456 deletions(-)
> 
> diff --git a/arch/sparc/include/asm/jump_label.h b/arch/sparc/include/asm/jump_label.h
> index 427d468..e4ca085 100644
> --- a/arch/sparc/include/asm/jump_label.h
> +++ b/arch/sparc/include/asm/jump_label.h
> @@ -7,17 +7,20 @@
>  
>  #define JUMP_LABEL_NOP_SIZE 4
>  
> -#define JUMP_LABEL(key, label)					\
> -	do {							\
> -		asm goto("1:\n\t"				\
> -			 "nop\n\t"				\
> -			 "nop\n\t"				\
> -			 ".pushsection __jump_table,  \"a\"\n\t"\
> -			 ".align 4\n\t"				\
> -			 ".word 1b, %l[" #label "], %c0\n\t"	\
> -			 ".popsection \n\t"			\
> -			 : :  "i" (key) :  : label);\
> -	} while (0)
> +static __always_inline bool __static_branch(struct jump_label_key *key)
> +{
> +		asm goto("1:\n\t"
> +			 "nop\n\t"
> +			 "nop\n\t"
> +			 ".pushsection __jump_table,  \"a\"\n\t"
> +			 ".align 4\n\t"
> +			 ".word 1b, %l[l_yes], %c0\n\t"
> +			 ".popsection \n\t"
> +			 : :  "i" (key) :  : l_yes);
> +	return false;
> +l_yes:
> +	return true;
> +}
>  
>  #endif /* __KERNEL__ */
>  
> diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
> index 574dbc2..3d44a7c 100644
> --- a/arch/x86/include/asm/jump_label.h
> +++ b/arch/x86/include/asm/jump_label.h
> @@ -5,20 +5,24 @@
>  
>  #include <linux/types.h>
>  #include <asm/nops.h>
> +#include <asm/asm.h>
>  
>  #define JUMP_LABEL_NOP_SIZE 5
>  
>  # define JUMP_LABEL_INITIAL_NOP ".byte 0xe9 \n\t .long 0\n\t"
>  
> -# define JUMP_LABEL(key, label)					\
> -	do {							\
> -		asm goto("1:"					\
> -			JUMP_LABEL_INITIAL_NOP			\
> -			".pushsection __jump_table,  \"aw\" \n\t"\
> -			_ASM_PTR "1b, %l[" #label "], %c0 \n\t" \
> -			".popsection \n\t"			\
> -			: :  "i" (key) :  : label);		\
> -	} while (0)
> +static __always_inline bool __static_branch(struct jump_label_key *key)
> +{
> +	asm goto("1:"
> +		JUMP_LABEL_INITIAL_NOP
> +		".pushsection __jump_table,  \"a\" \n\t"
> +		_ASM_PTR "1b, %l[l_yes], %c0 \n\t"
> +		".popsection \n\t"
> +		: :  "i" (key) : : l_yes );
> +	return false;
> +l_yes:
> +	return true;
> +}
>  
>  #endif /* __KERNEL__ */
>  
> diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
> index 961b6b3..dfa4c3c 100644
> --- a/arch/x86/kernel/jump_label.c
> +++ b/arch/x86/kernel/jump_label.c
> @@ -4,13 +4,13 @@
>   * Copyright (C) 2009 Jason Baron <jbaron@redhat.com>
>   *
>   */
> -#include <linux/jump_label.h>
>  #include <linux/memory.h>
>  #include <linux/uaccess.h>
>  #include <linux/module.h>
>  #include <linux/list.h>
>  #include <linux/jhash.h>
>  #include <linux/cpu.h>
> +#include <linux/jump_label.h>
>  #include <asm/kprobes.h>
>  #include <asm/alternative.h>
>  
> diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
> index ab23f1a..0e6b823 100644
> --- a/arch/x86/kernel/module.c
> +++ b/arch/x86/kernel/module.c
> @@ -230,9 +230,6 @@ int module_finalize(const Elf_Ehdr *hdr,
>  		apply_paravirt(pseg, pseg + para->sh_size);
>  	}
>  
> -	/* make jump label nops */
> -	jump_label_apply_nops(me);
> -
>  	return 0;
>  }
>  
> diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
> index 1c70028..2ade291 100644
> --- a/include/linux/dynamic_debug.h
> +++ b/include/linux/dynamic_debug.h
> @@ -33,7 +33,7 @@ struct _ddebug {
>  #define _DPRINTK_FLAGS_PRINT   (1<<0)  /* printk() a message using the format */
>  #define _DPRINTK_FLAGS_DEFAULT 0
>  	unsigned int flags:8;
> -	char enabled;
> +	struct jump_label_key enabled;
>  } __attribute__((aligned(8)));
>  
>  
> @@ -48,8 +48,8 @@ extern int ddebug_remove_module(const char *mod_name);
>  	__used								\
>  	__attribute__((section("__verbose"), aligned(8))) =		\
>  	{ KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,		\
> -		_DPRINTK_FLAGS_DEFAULT };				\
> -	if (unlikely(descriptor.enabled))				\
> +		_DPRINTK_FLAGS_DEFAULT, JUMP_LABEL_INIT };		\
> +	if (static_branch(&descriptor.enabled))				\
>  		printk(KERN_DEBUG pr_fmt(fmt),	##__VA_ARGS__);		\
>  	} while (0)
>  
> @@ -59,8 +59,8 @@ extern int ddebug_remove_module(const char *mod_name);
>  	__used								\
>  	__attribute__((section("__verbose"), aligned(8))) =		\
>  	{ KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,		\
> -		_DPRINTK_FLAGS_DEFAULT };				\
> -	if (unlikely(descriptor.enabled))				\
> +		_DPRINTK_FLAGS_DEFAULT, JUMP_LABEL_INIT };		\
> +	if (static_branch(&descriptor.enabled))				\
>  		dev_printk(KERN_DEBUG, dev, fmt, ##__VA_ARGS__);	\
>  	} while (0)
>  
> diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
> index 7880f18..a1cec0a 100644
> --- a/include/linux/jump_label.h
> +++ b/include/linux/jump_label.h
> @@ -2,19 +2,35 @@
>  #define _LINUX_JUMP_LABEL_H
>  
>  #if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
> +
> +struct jump_label_key {
> +	atomic_t enabled;
> +	struct jump_entry *entries;
> +#ifdef CONFIG_MODULES
> +	struct jump_module *next;
> +#endif
> +};
> +
>  # include <asm/jump_label.h>
>  # define HAVE_JUMP_LABEL
>  #endif
>  
>  enum jump_label_type {
> +	JUMP_LABEL_DISABLE = 0,
>  	JUMP_LABEL_ENABLE,
> -	JUMP_LABEL_DISABLE
>  };
>  
>  struct module;
>  
> +#define JUMP_LABEL_INIT { 0 }
> +
>  #ifdef HAVE_JUMP_LABEL
>  
> +static __always_inline bool static_branch(struct jump_label_key *key)
> +{
> +	return __static_branch(key);
> +}
> +
>  extern struct jump_entry __start___jump_table[];
>  extern struct jump_entry __stop___jump_table[];
>  
> @@ -23,37 +39,31 @@ extern void jump_label_unlock(void);
>  extern void arch_jump_label_transform(struct jump_entry *entry,
>  				 enum jump_label_type type);
>  extern void arch_jump_label_text_poke_early(jump_label_t addr);
> -extern void jump_label_update(unsigned long key, enum jump_label_type type);
> -extern void jump_label_apply_nops(struct module *mod);
>  extern int jump_label_text_reserved(void *start, void *end);
> -
> -#define jump_label_enable(key) \
> -	jump_label_update((unsigned long)key, JUMP_LABEL_ENABLE);
> -
> -#define jump_label_disable(key) \
> -	jump_label_update((unsigned long)key, JUMP_LABEL_DISABLE);
> +extern void jump_label_enable(struct jump_label_key *key);
> +extern void jump_label_disable(struct jump_label_key *key);
>  
>  #else
>  
> -#define JUMP_LABEL(key, label)			\
> -do {						\
> -	if (unlikely(*key))			\
> -		goto label;			\
> -} while (0)
> +struct jump_label_key {
> +	atomic_t enabled;
> +};
>  
> -#define jump_label_enable(cond_var)	\
> -do {					\
> -       *(cond_var) = 1;			\
> -} while (0)
> +static __always_inline bool static_branch(struct jump_label_key *key)
> +{
> +	if (unlikely(atomic_read(&key->state)))
> +		return true;
> +	return false;
> +}
>  
> -#define jump_label_disable(cond_var)	\
> -do {					\
> -       *(cond_var) = 0;			\
> -} while (0)
> +static inline void jump_label_enable(struct jump_label_key *key)
> +{
> +	atomic_inc(&key->state);
> +}
>  
> -static inline int jump_label_apply_nops(struct module *mod)
> +static inline void jump_label_disable(struct jump_label_key *key)
>  {
> -	return 0;
> +	atomic_dec(&key->state);
>  }
>  
>  static inline int jump_label_text_reserved(void *start, void *end)
> @@ -66,14 +76,9 @@ static inline void jump_label_unlock(void) {}
>  
>  #endif
>  
> -#define COND_STMT(key, stmt)					\
> -do {								\
> -	__label__ jl_enabled;					\
> -	JUMP_LABEL(key, jl_enabled);				\
> -	if (0) {						\
> -jl_enabled:							\
> -		stmt;						\
> -	}							\
> -} while (0)
> +static inline bool jump_label_enabled(struct jump_label_key *key)
> +{
> +	return !!atomic_read(&key->state);
> +}
>  
>  #endif
> diff --git a/include/linux/jump_label_ref.h b/include/linux/jump_label_ref.h
> index e5d012a..5178696 100644
> --- a/include/linux/jump_label_ref.h
> +++ b/include/linux/jump_label_ref.h
> @@ -4,41 +4,27 @@
>  #include <linux/jump_label.h>
>  #include <asm/atomic.h>
>  
> -#ifdef HAVE_JUMP_LABEL
> +struct jump_label_key_counter {
> +	atomic_t ref;
> +	struct jump_label_key key;
> +};
>  
> -static inline void jump_label_inc(atomic_t *key)
> -{
> -	if (atomic_add_return(1, key) == 1)
> -		jump_label_enable(key);
> -}
> +#ifdef HAVE_JUMP_LABEL
>  
> -static inline void jump_label_dec(atomic_t *key)
> +static __always_inline bool static_branch_else_atomic_read(struct jump_label_key *key, atomic_t *count)
>  {
> -	if (atomic_dec_and_test(key))
> -		jump_label_disable(key);
> +	return __static_branch(key);
>  }
>  
>  #else /* !HAVE_JUMP_LABEL */
>  
> -static inline void jump_label_inc(atomic_t *key)
> +static __always_inline bool static_branch_else_atomic_read(struct jump_label_key *key, atomic_t *count)
>  {
> -	atomic_inc(key);
> +	if (unlikely(atomic_read(count)))
> +		return true;
> +	return false;
>  }
>  
> -static inline void jump_label_dec(atomic_t *key)
> -{
> -	atomic_dec(key);
> -}
> -
> -#undef JUMP_LABEL
> -#define JUMP_LABEL(key, label)						\
> -do {									\
> -	if (unlikely(__builtin_choose_expr(				\
> -	      __builtin_types_compatible_p(typeof(key), atomic_t *),	\
> -	      atomic_read((atomic_t *)(key)), *(key))))			\
> -		goto label;						\
> -} while (0)
> -
>  #endif /* HAVE_JUMP_LABEL */
>  
>  #endif /* _LINUX_JUMP_LABEL_REF_H */
> diff --git a/include/linux/module.h b/include/linux/module.h
> index 9bdf27c..eeb3e99 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -266,6 +266,7 @@ enum module_state
>  	MODULE_STATE_LIVE,
>  	MODULE_STATE_COMING,
>  	MODULE_STATE_GOING,
> +	MODULE_STATE_POST_RELOCATE,
>  };
>  
>  struct module
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index dda5b0a..26fe115 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -1000,7 +1000,7 @@ static inline int is_software_event(struct perf_event *event)
>  	return event->pmu->task_ctx_nr == perf_sw_context;
>  }
>  
> -extern atomic_t perf_swevent_enabled[PERF_COUNT_SW_MAX];
> +extern struct jump_label_key_counter perf_swevent_enabled[PERF_COUNT_SW_MAX];
>  
>  extern void __perf_sw_event(u32, u64, int, struct pt_regs *, u64);
>  
> @@ -1029,30 +1029,32 @@ perf_sw_event(u32 event_id, u64 nr, int nmi, struct pt_regs *regs, u64 addr)
>  {
>  	struct pt_regs hot_regs;
>  
> -	JUMP_LABEL(&perf_swevent_enabled[event_id], have_event);
> -	return;
> -
> -have_event:
> -	if (!regs) {
> -		perf_fetch_caller_regs(&hot_regs);
> -		regs = &hot_regs;
> +	if (static_branch_else_atomic_read(&perf_swevent_enabled[event_id].key,
> +					 &perf_swevent_enabled[event_id].ref)) {
> +		if (!regs) {
> +			perf_fetch_caller_regs(&hot_regs);
> +			regs = &hot_regs;
> +		}
> +		__perf_sw_event(event_id, nr, nmi, regs, addr);
>  	}
> -	__perf_sw_event(event_id, nr, nmi, regs, addr);
>  }
>  
> -extern atomic_t perf_task_events;
> +extern struct jump_label_key_counter perf_task_events;
>  
>  static inline void perf_event_task_sched_in(struct task_struct *task)
>  {
> -	COND_STMT(&perf_task_events, __perf_event_task_sched_in(task));
> +	if (static_branch_else_atomic_read(&perf_task_events.key,
> +					   &perf_task_events.ref))
> +		__perf_event_task_sched_in(task);
>  }
>  
>  static inline
>  void perf_event_task_sched_out(struct task_struct *task, struct task_struct *next)
>  {
>  	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, 1, NULL, 0);
> -
> -	COND_STMT(&perf_task_events, __perf_event_task_sched_out(task, next));
> +	if (static_branch_else_atomic_read(&perf_task_events.key,
> +					   &perf_task_events.ref))
> +		__perf_event_task_sched_out(task, next);
>  }
>  
>  extern void perf_event_mmap(struct vm_area_struct *vma);
> diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> index 97c84a5..6c8c747 100644
> --- a/include/linux/tracepoint.h
> +++ b/include/linux/tracepoint.h
> @@ -29,7 +29,7 @@ struct tracepoint_func {
>  
>  struct tracepoint {
>  	const char *name;		/* Tracepoint name */
> -	int state;			/* State. */
> +	struct jump_label_key key;
>  	void (*regfunc)(void);
>  	void (*unregfunc)(void);
>  	struct tracepoint_func __rcu *funcs;
> @@ -146,9 +146,7 @@ void tracepoint_update_probe_range(struct tracepoint * const *begin,
>  	extern struct tracepoint __tracepoint_##name;			\
>  	static inline void trace_##name(proto)				\
>  	{								\
> -		JUMP_LABEL(&__tracepoint_##name.state, do_trace);	\
> -		return;							\
> -do_trace:								\
> +		if (static_branch(&__tracepoint_##name.key))		\
>  			__DO_TRACE(&__tracepoint_##name,		\
>  				TP_PROTO(data_proto),			\
>  				TP_ARGS(data_args),			\
> @@ -181,7 +179,7 @@ do_trace:								\
>  	__attribute__((section("__tracepoints_strings"))) = #name;	\
>  	struct tracepoint __tracepoint_##name				\
>  	__attribute__((section("__tracepoints"))) =			\
> -		{ __tpstrtab_##name, 0, reg, unreg, NULL };		\
> +		{ __tpstrtab_##name, JUMP_LABEL_INIT, reg, unreg, NULL };\
>  	static struct tracepoint * const __tracepoint_ptr_##name __used	\
>  	__attribute__((section("__tracepoints_ptrs"))) =		\
>  		&__tracepoint_##name;
> diff --git a/kernel/jump_label.c b/kernel/jump_label.c
> index 3b79bd9..29b34be 100644
> --- a/kernel/jump_label.c
> +++ b/kernel/jump_label.c
> @@ -2,9 +2,9 @@
>   * jump label support
>   *
>   * Copyright (C) 2009 Jason Baron <jbaron@redhat.com>
> + * Copyright (C) 2011 Peter Zijlstra <pzijlstr@redhat.com>
>   *
>   */
> -#include <linux/jump_label.h>
>  #include <linux/memory.h>
>  #include <linux/uaccess.h>
>  #include <linux/module.h>
> @@ -13,32 +13,13 @@
>  #include <linux/slab.h>
>  #include <linux/sort.h>
>  #include <linux/err.h>
> +#include <linux/jump_label.h>
>  
>  #ifdef HAVE_JUMP_LABEL
>  
> -#define JUMP_LABEL_HASH_BITS 6
> -#define JUMP_LABEL_TABLE_SIZE (1 << JUMP_LABEL_HASH_BITS)
> -static struct hlist_head jump_label_table[JUMP_LABEL_TABLE_SIZE];
> -
>  /* mutex to protect coming/going of the the jump_label table */
>  static DEFINE_MUTEX(jump_label_mutex);
>  
> -struct jump_label_entry {
> -	struct hlist_node hlist;
> -	struct jump_entry *table;
> -	int nr_entries;
> -	/* hang modules off here */
> -	struct hlist_head modules;
> -	unsigned long key;
> -};
> -
> -struct jump_label_module_entry {
> -	struct hlist_node hlist;
> -	struct jump_entry *table;
> -	int nr_entries;
> -	struct module *mod;
> -};
> -
>  void jump_label_lock(void)
>  {
>  	mutex_lock(&jump_label_mutex);
> @@ -64,7 +45,7 @@ static int jump_label_cmp(const void *a, const void *b)
>  }
>  
>  static void
> -sort_jump_label_entries(struct jump_entry *start, struct jump_entry *stop)
> +jump_label_sort_entries(struct jump_entry *start, struct jump_entry *stop)
>  {
>  	unsigned long size;
>  
> @@ -73,118 +54,25 @@ sort_jump_label_entries(struct jump_entry *start, struct jump_entry *stop)
>  	sort(start, size, sizeof(struct jump_entry), jump_label_cmp, NULL);
>  }
>  
> -static struct jump_label_entry *get_jump_label_entry(jump_label_t key)
> -{
> -	struct hlist_head *head;
> -	struct hlist_node *node;
> -	struct jump_label_entry *e;
> -	u32 hash = jhash((void *)&key, sizeof(jump_label_t), 0);
> -
> -	head = &jump_label_table[hash & (JUMP_LABEL_TABLE_SIZE - 1)];
> -	hlist_for_each_entry(e, node, head, hlist) {
> -		if (key == e->key)
> -			return e;
> -	}
> -	return NULL;
> -}
> +static void jump_label_update(struct jump_label_key *key, int enable);
>  
> -static struct jump_label_entry *
> -add_jump_label_entry(jump_label_t key, int nr_entries, struct jump_entry *table)
> +void jump_label_enable(struct jump_label_key *key)
>  {
> -	struct hlist_head *head;
> -	struct jump_label_entry *e;
> -	u32 hash;
> -
> -	e = get_jump_label_entry(key);
> -	if (e)
> -		return ERR_PTR(-EEXIST);
> -
> -	e = kmalloc(sizeof(struct jump_label_entry), GFP_KERNEL);
> -	if (!e)
> -		return ERR_PTR(-ENOMEM);
> -
> -	hash = jhash((void *)&key, sizeof(jump_label_t), 0);
> -	head = &jump_label_table[hash & (JUMP_LABEL_TABLE_SIZE - 1)];
> -	e->key = key;
> -	e->table = table;
> -	e->nr_entries = nr_entries;
> -	INIT_HLIST_HEAD(&(e->modules));
> -	hlist_add_head(&e->hlist, head);
> -	return e;
> -}
> +	if (atomic_inc_not_zero(&key->enabled))
> +		return;
>  
> -static int
> -build_jump_label_hashtable(struct jump_entry *start, struct jump_entry *stop)
> -{
> -	struct jump_entry *iter, *iter_begin;
> -	struct jump_label_entry *entry;
> -	int count;
> -
> -	sort_jump_label_entries(start, stop);
> -	iter = start;
> -	while (iter < stop) {
> -		entry = get_jump_label_entry(iter->key);
> -		if (!entry) {
> -			iter_begin = iter;
> -			count = 0;
> -			while ((iter < stop) &&
> -				(iter->key == iter_begin->key)) {
> -				iter++;
> -				count++;
> -			}
> -			entry = add_jump_label_entry(iter_begin->key,
> -							count, iter_begin);
> -			if (IS_ERR(entry))
> -				return PTR_ERR(entry);
> -		 } else {
> -			WARN_ONCE(1, KERN_ERR "build_jump_hashtable: unexpected entry!\n");
> -			return -1;
> -		}
> -	}
> -	return 0;
> +	jump_label_lock();
> +	if (atomic_add_return(&key->enabled) == 1)
> +		jump_label_update(key, JUMP_LABEL_ENABLE);
> +	jump_label_unlock();
>  }
>  
> -/***
> - * jump_label_update - update jump label text
> - * @key -  key value associated with a a jump label
> - * @type - enum set to JUMP_LABEL_ENABLE or JUMP_LABEL_DISABLE
> - *
> - * Will enable/disable the jump for jump label @key, depending on the
> - * value of @type.
> - *
> - */
> -
> -void jump_label_update(unsigned long key, enum jump_label_type type)
> +void jump_label_disable(struct jump_label_key *key)
>  {
> -	struct jump_entry *iter;
> -	struct jump_label_entry *entry;
> -	struct hlist_node *module_node;
> -	struct jump_label_module_entry *e_module;
> -	int count;
> +	if (!atomic_dec_and_mutex_lock(&key->enabled, &jump_label_mutex))
> +		return;
>  
> -	jump_label_lock();
> -	entry = get_jump_label_entry((jump_label_t)key);
> -	if (entry) {
> -		count = entry->nr_entries;
> -		iter = entry->table;
> -		while (count--) {
> -			if (kernel_text_address(iter->code))
> -				arch_jump_label_transform(iter, type);
> -			iter++;
> -		}
> -		/* eanble/disable jump labels in modules */
> -		hlist_for_each_entry(e_module, module_node, &(entry->modules),
> -							hlist) {
> -			count = e_module->nr_entries;
> -			iter = e_module->table;
> -			while (count--) {
> -				if (iter->key &&
> -						kernel_text_address(iter->code))
> -					arch_jump_label_transform(iter, type);
> -				iter++;
> -			}
> -		}
> -	}
> +	jump_label_update(key, JUMP_LABEL_DISABLE);
>  	jump_label_unlock();
>  }
>  
> @@ -197,77 +85,30 @@ static int addr_conflict(struct jump_entry *entry, void *start, void *end)
>  	return 0;
>  }
>  
> -#ifdef CONFIG_MODULES
> -
> -static int module_conflict(void *start, void *end)
> -{
> -	struct hlist_head *head;
> -	struct hlist_node *node, *node_next, *module_node, *module_node_next;
> -	struct jump_label_entry *e;
> -	struct jump_label_module_entry *e_module;
> -	struct jump_entry *iter;
> -	int i, count;
> -	int conflict = 0;
> -
> -	for (i = 0; i < JUMP_LABEL_TABLE_SIZE; i++) {
> -		head = &jump_label_table[i];
> -		hlist_for_each_entry_safe(e, node, node_next, head, hlist) {
> -			hlist_for_each_entry_safe(e_module, module_node,
> -							module_node_next,
> -							&(e->modules), hlist) {
> -				count = e_module->nr_entries;
> -				iter = e_module->table;
> -				while (count--) {
> -					if (addr_conflict(iter, start, end)) {
> -						conflict = 1;
> -						goto out;
> -					}
> -					iter++;
> -				}
> -			}
> -		}
> -	}
> -out:
> -	return conflict;
> -}
> -
> -#endif
> -
> -/***
> - * jump_label_text_reserved - check if addr range is reserved
> - * @start: start text addr
> - * @end: end text addr
> - *
> - * checks if the text addr located between @start and @end
> - * overlaps with any of the jump label patch addresses. Code
> - * that wants to modify kernel text should first verify that
> - * it does not overlap with any of the jump label addresses.
> - * Caller must hold jump_label_mutex.
> - *
> - * returns 1 if there is an overlap, 0 otherwise
> - */
> -int jump_label_text_reserved(void *start, void *end)
> +static int __jump_label_text_reserved(struct jump_entry *iter_start,
> +		struct jump_entry *iter_stop, void *start, void *end)
>  {
>  	struct jump_entry *iter;
> -	struct jump_entry *iter_start = __start___jump_table;
> -	struct jump_entry *iter_stop = __start___jump_table;
> -	int conflict = 0;
>  
>  	iter = iter_start;
>  	while (iter < iter_stop) {
> -		if (addr_conflict(iter, start, end)) {
> -			conflict = 1;
> -			goto out;
> -		}
> +		if (addr_conflict(iter, start, end))
> +			return 1;
>  		iter++;
>  	}
>  
> -	/* now check modules */
> -#ifdef CONFIG_MODULES
> -	conflict = module_conflict(start, end);
> -#endif
> -out:
> -	return conflict;
> +	return 0;
> +}
> +
> +static void __jump_label_update(struct jump_label_key *key, 
> +		struct jump_entry *entry, int enable)
> +{
> +	for (; entry->key == (jump_label_t)key; entry++) {
> +		if (WARN_ON_ONCE(!kernel_text_address(iter->code)))
> +			continue;
> +
> +		arch_jump_label_transform(iter, enable);
> +	}
>  }
>  
>  /*
> @@ -277,141 +118,155 @@ void __weak arch_jump_label_text_poke_early(jump_label_t addr)
>  {
>  }
>  
> -static __init int init_jump_label(void)
> +static __init int jump_label_init(void)
>  {
> -	int ret;
>  	struct jump_entry *iter_start = __start___jump_table;
>  	struct jump_entry *iter_stop = __stop___jump_table;
> +	struct jump_label_key *key = NULL;
>  	struct jump_entry *iter;
>  
>  	jump_label_lock();
> -	ret = build_jump_label_hashtable(__start___jump_table,
> -					 __stop___jump_table);
> -	iter = iter_start;
> -	while (iter < iter_stop) {
> +	jump_label_sort_entries(iter_start, iter_stop);
> +
> +	for (iter = iter_start; iter < iter_stop; iter++) {
>  		arch_jump_label_text_poke_early(iter->code);
> -		iter++;
> +		if (iter->key == (jump_label_t)key)
> +			continue;
> +
> +		key = (struct jump_label_key *)iter->key;
> +		atomic_set(&key->enabled, 0);
> +		key->entries = iter;
> +#ifdef CONFIG_MODULES
> +		key->next = NULL;
> +#endif
>  	}
>  	jump_label_unlock();
> -	return ret;
> +
> +	return 0;
>  }
> -early_initcall(init_jump_label);
> +early_initcall(jump_label_init);
>  
>  #ifdef CONFIG_MODULES
>  
> -static struct jump_label_module_entry *
> -add_jump_label_module_entry(struct jump_label_entry *entry,
> -			    struct jump_entry *iter_begin,
> -			    int count, struct module *mod)
> -{
> -	struct jump_label_module_entry *e;
> -
> -	e = kmalloc(sizeof(struct jump_label_module_entry), GFP_KERNEL);
> -	if (!e)
> -		return ERR_PTR(-ENOMEM);
> -	e->mod = mod;
> -	e->nr_entries = count;
> -	e->table = iter_begin;
> -	hlist_add_head(&e->hlist, &entry->modules);
> -	return e;
> -}
> +struct jump_label_mod {
> +	struct jump_label_mod *next;
> +	struct jump_entry *entries;
> +	struct module *mod;
> +};
>  
> -static int add_jump_label_module(struct module *mod)
> +static int __jump_label_mod_text_reserved(void *start, void *end)
>  {
> -	struct jump_entry *iter, *iter_begin;
> -	struct jump_label_entry *entry;
> -	struct jump_label_module_entry *module_entry;
> -	int count;
> +	struct module *mod;
>  
> -	/* if the module doesn't have jump label entries, just return */
> -	if (!mod->num_jump_entries)
> +	mod = __module_text_address(start);
> +	if (!mod)
>  		return 0;
>  
> -	sort_jump_label_entries(mod->jump_entries,
> +	WARN_ON_ONCE(__module_text_address(end) != mod);
> +
> +	return __jump_label_text_reserved(mod->jump_entries,
>  				mod->jump_entries + mod->num_jump_entries);
> -	iter = mod->jump_entries;
> -	while (iter < mod->jump_entries + mod->num_jump_entries) {
> -		entry = get_jump_label_entry(iter->key);
> -		iter_begin = iter;
> -		count = 0;
> -		while ((iter < mod->jump_entries + mod->num_jump_entries) &&
> -			(iter->key == iter_begin->key)) {
> -				iter++;
> -				count++;
> -		}
> -		if (!entry) {
> -			entry = add_jump_label_entry(iter_begin->key, 0, NULL);
> -			if (IS_ERR(entry))
> -				return PTR_ERR(entry);
> -		}
> -		module_entry = add_jump_label_module_entry(entry, iter_begin,
> -							   count, mod);
> -		if (IS_ERR(module_entry))
> -			return PTR_ERR(module_entry);
> +}
> +
> +static void __jump_label_mod_update(struct jump_label_key *key, int enable)
> +{
> +	struct jump_label_mod *mod = key->next;
> +
> +	while (mod) {
> +		__jump_label_update(key, mod->entries, enable);
> +		mod = mod->next;
>  	}
> -	return 0;
>  }
>  
> -static void remove_jump_label_module(struct module *mod)
> +/***
> + * apply_jump_label_nops - patch module jump labels with arch_get_jump_label_nop()
> + * @mod: module to patch
> + *
> + * Allow for run-time selection of the optimal nops. Before the module
> + * loads patch these with arch_get_jump_label_nop(), which is specified by
> + * the arch specific jump label code.
> + */
> +static void jump_label_apply_nops(struct module *mod)
>  {
> -	struct hlist_head *head;
> -	struct hlist_node *node, *node_next, *module_node, *module_node_next;
> -	struct jump_label_entry *e;
> -	struct jump_label_module_entry *e_module;
> -	int i;
> +	struct jump_entry *iter_start = mod->jump_entries;
> +	struct jump_entry *iter_stop = mod->jump_entries + mod->num_jump_entries;
> +	struct jump_entry *iter;
>  
>  	/* if the module doesn't have jump label entries, just return */
> -	if (!mod->num_jump_entries)
> +	if (iter_start == iter_stop)
>  		return;
>  
> -	for (i = 0; i < JUMP_LABEL_TABLE_SIZE; i++) {
> -		head = &jump_label_table[i];
> -		hlist_for_each_entry_safe(e, node, node_next, head, hlist) {
> -			hlist_for_each_entry_safe(e_module, module_node,
> -						  module_node_next,
> -						  &(e->modules), hlist) {
> -				if (e_module->mod == mod) {
> -					hlist_del(&e_module->hlist);
> -					kfree(e_module);
> -				}
> -			}
> -			if (hlist_empty(&e->modules) && (e->nr_entries == 0)) {
> -				hlist_del(&e->hlist);
> -				kfree(e);
> -			}
> +	jump_label_sort_entries(iter_start, iter_stop);
> +
> +	for (iter = iter_start; iter < iter_stop; iter++)
> +		arch_jump_label_text_poke_early(iter->code);
> +}
> +
> +static int jump_label_add_module(struct module *mod)
> +{
> +	struct jump_entry *iter_start = mod->jump_entries;
> +	struct jump_entry *iter_stop = mod->jump_entries + mod->num_jump_entries;
> +	struct jump_entry *iter;
> +	struct jump_label_key *key = NULL;
> +	struct jump_label_mod *jlm;
> +
> +	for (iter = iter_start; iter < iter_stop; iter++) {
> +		if (iter->key == (jump_label_t)key)
> +			continue;
> +
> +		key = (struct jump_label_key)iter->key;
> +
> +		if (__module_address(iter->key) == mod) {
> +			atomic_set(&key->enabled, 0);
> +			key->entries = iter;
> +			key->next = NULL;
> +			continue;
>  		}
> +
> +		jlm = kzalloc(sizeof(struct jump_label_mod), GFP_KERNEL);
> +		if (!jlm)
> +			return -ENOMEM;
> +
> +		jlm->mod = mod;
> +		jlm->entries = iter;
> +		jlm->next = key->next;
> +		key->next = jlm;
> +
> +		if (jump_label_enabled(key))
> +			__jump_label_update(key, iter, JUMP_LABEL_ENABLE);
>  	}
> +
> +	return 0;
>  }
>  
> -static void remove_jump_label_module_init(struct module *mod)
> +static void jump_label_del_module(struct module *mod)
>  {
> -	struct hlist_head *head;
> -	struct hlist_node *node, *node_next, *module_node, *module_node_next;
> -	struct jump_label_entry *e;
> -	struct jump_label_module_entry *e_module;
> +	struct jump_entry *iter_start = mod->jump_entries;
> +	struct jump_entry *iter_stop = mod->jump_entries + mod->num_jump_entries;
>  	struct jump_entry *iter;
> -	int i, count;
> +	struct jump_label_key *key = NULL;
> +	struct jump_label_mod *jlm, **prev;
>  
> -	/* if the module doesn't have jump label entries, just return */
> -	if (!mod->num_jump_entries)
> -		return;
> +	for (iter = iter_start; iter < iter_stop; iter++) {
> +		if (iter->key == (jump_label_t)key)
> +			continue;
> +
> +		key = (struct jump_label_key)iter->key;
> +
> +		if (__module_address(iter->key) == mod)
> +			continue;
> +
> +		prev = &key->next;
> +		jlm = key->next;
> +
> +		while (jlm && jlm->mod != mod) {
> +			prev = &jlm->next;
> +			jlm = jlm->next;
> +		}
>  
> -	for (i = 0; i < JUMP_LABEL_TABLE_SIZE; i++) {
> -		head = &jump_label_table[i];
> -		hlist_for_each_entry_safe(e, node, node_next, head, hlist) {
> -			hlist_for_each_entry_safe(e_module, module_node,
> -						  module_node_next,
> -						  &(e->modules), hlist) {
> -				if (e_module->mod != mod)
> -					continue;
> -				count = e_module->nr_entries;
> -				iter = e_module->table;
> -				while (count--) {
> -					if (within_module_init(iter->code, mod))
> -						iter->key = 0;
> -					iter++;
> -				}
> -			}
> +		if (jlm) {
> +			*prev = jlm->next;
> +			kfree(jlm);
>  		}
>  	}
>  }
> @@ -424,61 +279,76 @@ jump_label_module_notify(struct notifier_block *self, unsigned long val,
>  	int ret = 0;
>  
>  	switch (val) {
> -	case MODULE_STATE_COMING:
> +	case MODULE_STATE_POST_RELOCATE:
>  		jump_label_lock();
> -		ret = add_jump_label_module(mod);
> -		if (ret)
> -			remove_jump_label_module(mod);
> +		jump_label_apply_nops(mod);
>  		jump_label_unlock();
>  		break;
> -	case MODULE_STATE_GOING:
> +	case MODULE_STATE_COMING:
>  		jump_label_lock();
> -		remove_jump_label_module(mod);
> +		ret = jump_label_add_module(mod);
> +		if (ret)
> +			jump_label_del_module(mod);
>  		jump_label_unlock();
>  		break;
> -	case MODULE_STATE_LIVE:
> +	case MODULE_STATE_GOING:
>  		jump_label_lock();
> -		remove_jump_label_module_init(mod);
> +		jump_label_del_module(mod);
>  		jump_label_unlock();
>  		break;
>  	}
>  	return ret;
>  }
>  
> +struct notifier_block jump_label_module_nb = {
> +	.notifier_call = jump_label_module_notify,
> +	.priority = 1, /* higher than tracepoints */
> +};
> +
> +static __init int jump_label_init_module(void)
> +{
> +	return register_module_notifier(&jump_label_module_nb);
> +}
> +early_initcall(jump_label_init_module);
> +
> +#endif /* CONFIG_MODULES */
> +
>  /***
> - * apply_jump_label_nops - patch module jump labels with arch_get_jump_label_nop()
> - * @mod: module to patch
> + * jump_label_text_reserved - check if addr range is reserved
> + * @start: start text addr
> + * @end: end text addr
>   *
> - * Allow for run-time selection of the optimal nops. Before the module
> - * loads patch these with arch_get_jump_label_nop(), which is specified by
> - * the arch specific jump label code.
> + * checks if the text addr located between @start and @end
> + * overlaps with any of the jump label patch addresses. Code
> + * that wants to modify kernel text should first verify that
> + * it does not overlap with any of the jump label addresses.
> + * Caller must hold jump_label_mutex.
> + *
> + * returns 1 if there is an overlap, 0 otherwise
>   */
> -void jump_label_apply_nops(struct module *mod)
> +int jump_label_text_reserved(void *start, void *end)
>  {
> -	struct jump_entry *iter;
> +	int ret = __jump_label_text_reserved(__start___jump_table,
> +			__stop___jump_table, start, end);
>  
> -	/* if the module doesn't have jump label entries, just return */
> -	if (!mod->num_jump_entries)
> -		return;
> +	if (ret)
> +		return ret;
>  
> -	iter = mod->jump_entries;
> -	while (iter < mod->jump_entries + mod->num_jump_entries) {
> -		arch_jump_label_text_poke_early(iter->code);
> -		iter++;
> -	}
> +#ifdef CONFIG_MODULES
> +	ret = __jump_label_mod_text_reserved(start, end);
> +#endif
> +	return ret;
>  }
>  
> -struct notifier_block jump_label_module_nb = {
> -	.notifier_call = jump_label_module_notify,
> -	.priority = 0,
> -};
> -
> -static __init int init_jump_label_module(void)
> +static void jump_label_update(struct jump_label_key *key, int enable)
>  {
> -	return register_module_notifier(&jump_label_module_nb);
> -}
> -early_initcall(init_jump_label_module);
> +	struct jump_entry *entry = key->entries;
>  
> -#endif /* CONFIG_MODULES */
> +	__jump_label_update(key, entry, enable);
> +
> +#ifdef CONFIG_MODULES
> +	__jump_label_mod_update(key, enable);
> +#endif
> +}
>  
>  #endif
> diff --git a/kernel/module.c b/kernel/module.c
> index efa290e..890cadf 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2789,6 +2789,13 @@ static struct module *load_module(void __user *umod,
>  		goto unlock;
>  	}
>  
> +	err = blocking_notifier_call_chain(&module_notify_list,
> +			MODULE_STATE_POST_RELOCATE, mod);
> +	if (err != NOTIFY_DONE) {
> +		err = notifier_to_errno(err);
> +		goto unlock;
> +	}
> +
>  	/* This has to be done once we're sure module name is unique. */
>  	if (!mod->taints)
>  		dynamic_debug_setup(info.debug, info.num_debug);
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index a353a4d..7bacdd3 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -117,7 +117,7 @@ enum event_type_t {
>  	EVENT_ALL = EVENT_FLEXIBLE | EVENT_PINNED,
>  };
>  
> -atomic_t perf_task_events __read_mostly;
> +struct jump_label_key_counter perf_task_events __read_mostly;
>  static atomic_t nr_mmap_events __read_mostly;
>  static atomic_t nr_comm_events __read_mostly;
>  static atomic_t nr_task_events __read_mostly;
> @@ -2383,8 +2383,10 @@ static void free_event(struct perf_event *event)
>  	irq_work_sync(&event->pending);
>  
>  	if (!event->parent) {
> -		if (event->attach_state & PERF_ATTACH_TASK)
> -			jump_label_dec(&perf_task_events);
> +		if (event->attach_state & PERF_ATTACH_TASK) {
> +			if (atomic_dec_and_test(&perf_task_events.ref))
> +				jump_label_disable(&perf_task_events.key);
> +		}
>  		if (event->attr.mmap || event->attr.mmap_data)
>  			atomic_dec(&nr_mmap_events);
>  		if (event->attr.comm)
> @@ -4912,7 +4914,7 @@ fail:
>  	return err;
>  }
>  
> -atomic_t perf_swevent_enabled[PERF_COUNT_SW_MAX];
> +struct jump_label_key_counter perf_swevent_enabled[PERF_COUNT_SW_MAX];
>  
>  static void sw_perf_event_destroy(struct perf_event *event)
>  {
> @@ -4920,7 +4922,8 @@ static void sw_perf_event_destroy(struct perf_event *event)
>  
>  	WARN_ON(event->parent);
>  
> -	jump_label_dec(&perf_swevent_enabled[event_id]);
> +	if (atomic_dec_and_test(&perf_swevent_enabled[event_id].ref))
> +		jump_label_disable(&perf_swevent_enabled[event_id].key);
>  	swevent_hlist_put(event);
>  }
>  
> @@ -4945,12 +4948,15 @@ static int perf_swevent_init(struct perf_event *event)
>  
>  	if (!event->parent) {
>  		int err;
> +		atomic_t *ref;
>  
>  		err = swevent_hlist_get(event);
>  		if (err)
>  			return err;
>  
> -		jump_label_inc(&perf_swevent_enabled[event_id]);
> +		ref = &perf_swevent_enabled[event_id].ref;
> +		if (atomic_add_return(1, ref) == 1)
> +			jump_label_enable(&perf_swevent_enabled[event_id].key);
>  		event->destroy = sw_perf_event_destroy;
>  	}
>  
> @@ -5123,6 +5129,10 @@ static enum hrtimer_restart perf_swevent_hrtimer(struct hrtimer *hrtimer)
>  	u64 period;
>  
>  	event = container_of(hrtimer, struct perf_event, hw.hrtimer);
> +
> +	if (event->state < PERF_EVENT_STATE_ACTIVE)
> +		return HRTIMER_NORESTART;
> +
>  	event->pmu->read(event);
>  
>  	perf_sample_data_init(&data, 0);
> @@ -5174,7 +5184,7 @@ static void perf_swevent_cancel_hrtimer(struct perf_event *event)
>  		ktime_t remaining = hrtimer_get_remaining(&hwc->hrtimer);
>  		local64_set(&hwc->period_left, ktime_to_ns(remaining));
>  
> -		hrtimer_cancel(&hwc->hrtimer);
> +		hrtimer_try_to_cancel(&hwc->hrtimer);
>  	}
>  }
>  
> @@ -5713,8 +5723,10 @@ done:
>  	event->pmu = pmu;
>  
>  	if (!event->parent) {
> -		if (event->attach_state & PERF_ATTACH_TASK)
> -			jump_label_inc(&perf_task_events);
> +		if (event->attach_state & PERF_ATTACH_TASK) {
> +			if (atomic_add_return(1, &perf_task_events.ref) == 1)
> +				jump_label_enable(&perf_task_events.key);
> +		}
>  		if (event->attr.mmap || event->attr.mmap_data)
>  			atomic_inc(&nr_mmap_events);
>  		if (event->attr.comm)
> diff --git a/kernel/timer.c b/kernel/timer.c
> index 343ff27..c848cd8 100644
> --- a/kernel/timer.c
> +++ b/kernel/timer.c
> @@ -959,7 +959,7 @@ EXPORT_SYMBOL(try_to_del_timer_sync);
>   *
>   * Synchronization rules: Callers must prevent restarting of the timer,
>   * otherwise this function is meaningless. It must not be called from
> - * hardirq contexts. The caller must not hold locks which would prevent
> + * interrupt contexts. The caller must not hold locks which would prevent
>   * completion of the timer's handler. The timer's handler must not call
>   * add_timer_on(). Upon exit the timer is not queued and the handler is
>   * not running on any CPU.
> @@ -971,12 +971,10 @@ int del_timer_sync(struct timer_list *timer)
>  #ifdef CONFIG_LOCKDEP
>  	unsigned long flags;
>  
> -	raw_local_irq_save(flags);
> -	local_bh_disable();
> +	local_irq_save(flags);
>  	lock_map_acquire(&timer->lockdep_map);
>  	lock_map_release(&timer->lockdep_map);
> -	_local_bh_enable();
> -	raw_local_irq_restore(flags);
> +	local_irq_restore(flags);
>  #endif
>  	/*
>  	 * don't use it in hardirq context, because it
> diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> index 68187af..13066e8 100644
> --- a/kernel/tracepoint.c
> +++ b/kernel/tracepoint.c
> @@ -251,9 +251,9 @@ static void set_tracepoint(struct tracepoint_entry **entry,
>  {
>  	WARN_ON(strcmp((*entry)->name, elem->name) != 0);
>  
> -	if (elem->regfunc && !elem->state && active)
> +	if (elem->regfunc && !jump_label_enabled(&elem->key) && active)
>  		elem->regfunc();
> -	else if (elem->unregfunc && elem->state && !active)
> +	else if (elem->unregfunc && jump_label_enabled(&elem->key) && !active)
>  		elem->unregfunc();
>  
>  	/*
> @@ -264,13 +264,10 @@ static void set_tracepoint(struct tracepoint_entry **entry,
>  	 * is used.
>  	 */
>  	rcu_assign_pointer(elem->funcs, (*entry)->funcs);
> -	if (!elem->state && active) {
> -		jump_label_enable(&elem->state);
> -		elem->state = active;
> -	} else if (elem->state && !active) {
> -		jump_label_disable(&elem->state);
> -		elem->state = active;
> -	}
> +	if (active)
> +		jump_label_enable(&elem->key);
> +	else if (!active)
> +		jump_label_disable(&elem->key);
>  }
>  
>  /*
> @@ -281,13 +278,10 @@ static void set_tracepoint(struct tracepoint_entry **entry,
>   */
>  static void disable_tracepoint(struct tracepoint *elem)
>  {
> -	if (elem->unregfunc && elem->state)
> +	if (elem->unregfunc && jump_label_enabled(&elem->key))
>  		elem->unregfunc();
>  
> -	if (elem->state) {
> -		jump_label_disable(&elem->state);
> -		elem->state = 0;
> -	}
> +	jump_label_disable(&elem->key);
>  	rcu_assign_pointer(elem->funcs, NULL);
>  }
>  
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab0K3WVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 17:21:33 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:51510 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab0K3WVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 17:21:32 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=V21i1CRr5CYA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=M34VWUyRBGCRqF9rCf0A:9 a=SjTXWTIPkEvfigpe4UEA:7 a=KGcRZBIb96DOjpH4gdxFgxnNKjsA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=JAqFP7pVcabDeEnY:21 a=fAKiHNELpnraiErb:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH/RFC] jump label: make enable/disable o(1)
From: Steven Rostedt <rostedt@goodmis.org>
To: Jason Baron <jbaron@redhat.com>
Cc: peterz@infradead.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
        hpa@zytor.com, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
In-Reply-To: <201011302036.oAUKaASw011265@int-mx11.intmail.prod.int.phx2.redhat.com>
References: <201011302036.oAUKaASw011265@int-mx11.intmail.prod.int.phx2.redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 30 Nov 2010 17:21:26 -0500
Message-ID: <1291155686.4881.19.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-30 at 15:36 -0500, Jason Baron wrote:
> Previously, I allowed any variable type to be used as the 'key' for
> the jump label. However, by enforcing a type, we can make use of the
> contents of the 'key'. This patch thus introduces:
> 
> +struct jump_label_state {
> +       void *ptr;
> +       int state;
> +};
> +typedef struct jump_label_state jump_label_key_t;

I do not like typedef'ing structures. It should stay a struct. Also,
shouldn't we have that state be a refcount?

> 
> The 'ptr' is used a pointer into the jump label table of the
> corresponding addresses that need to be updated. Thus, when jump labels
> are enabled/disabled we have a constant time algorithm. There is no
> longer any hashing. The 'state' variable is used to keep track
> of whether or not we have enabled the jump label.
> 
> When jump lables are disabled we simply have:
> 
> typedef int jump_label_key_t;

We can have this be:

struct jump_label_key {
	int		key;
};

> 
> I've also defined an analogous structure for ref counted jump labels as
> per a request from Peter.
> 
> +struct jump_label_ref {
> +       void *ptr;
> +       atomic_t refcount;
> +};
> +
> +typedef struct jump_label_ref jump_label_refkey_t;

Why the two? Just have the refcount one.


> 
> I tested enable/disable times on x86 on a quad core via:
> 
>  time echo 1 > /sys/kernel/debug/tracing/events/enable
> 
> With this patch, runs average .03s. Prior to the jump label infrastructure
> this command averaged around .01s.
> 
> We can speed this up further via batching the enable/disables, if need be.
> 
> thanks,
> 
> -Jason
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> ---
>  include/linux/dynamic_debug.h  |    6 +-
>  include/linux/jump_label.h     |   56 +++++++++++++++++++++------
>  include/linux/jump_label_ref.h |   29 +++++++++-----
>  include/linux/perf_event.h     |    4 +-
>  include/linux/tracepoint.h     |    6 +-
>  kernel/jump_label.c            |   82 +++++++++++++++++++++++++++------------
>  kernel/perf_event.c            |    4 +-
>  kernel/tracepoint.c            |   22 ++++-------
>  8 files changed, 137 insertions(+), 72 deletions(-)
> 
> diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
> index a90b389..64e9fdb 100644
> --- a/include/linux/dynamic_debug.h
> +++ b/include/linux/dynamic_debug.h
> @@ -33,7 +33,7 @@ struct _ddebug {
>  #define _DPRINTK_FLAGS_PRINT   (1<<0)  /* printk() a message using the format */
>  #define _DPRINTK_FLAGS_DEFAULT 0
>  	unsigned int flags:8;
> -	char enabled;
> +	jump_label_key_t enabled;
>  } __attribute__((aligned(8)));
>  
> 
> @@ -50,7 +50,7 @@ extern int ddebug_remove_module(const char *mod_name);
>  	__used								\
>  	__attribute__((section("__verbose"), aligned(8))) =		\
>  	{ KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,		\
> -		_DPRINTK_FLAGS_DEFAULT };				\
> +		_DPRINTK_FLAGS_DEFAULT, JUMP_LABEL_INIT };		\
>  	JUMP_LABEL(&descriptor.enabled, do_printk);			\
>  	goto out;							\
>  do_printk:								\
> @@ -66,7 +66,7 @@ out:	;								\
>  	__used								\
>  	__attribute__((section("__verbose"), aligned(8))) =		\
>  	{ KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,		\
> -		_DPRINTK_FLAGS_DEFAULT };				\
> +		_DPRINTK_FLAGS_DEFAULT, JUMP_LABEL_INIT };		\
>  	JUMP_LABEL(&descriptor.enabled, do_printk);			\
>  	goto out;							\
>  do_printk:								\
> diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
> index 7880f18..72c6de7 100644
> --- a/include/linux/jump_label.h
> +++ b/include/linux/jump_label.h
> @@ -15,6 +15,13 @@ struct module;
>  
>  #ifdef HAVE_JUMP_LABEL
>  
> +struct jump_label_state {
> +	void *ptr;
> +	int state;
> +};
> +typedef struct jump_label_state jump_label_key_t;
> +#define JUMP_LABEL_INIT { NULL, 0 }
> +
>  extern struct jump_entry __start___jump_table[];
>  extern struct jump_entry __stop___jump_table[];
>  
> @@ -23,33 +30,56 @@ extern void jump_label_unlock(void);
>  extern void arch_jump_label_transform(struct jump_entry *entry,
>  				 enum jump_label_type type);
>  extern void arch_jump_label_text_poke_early(jump_label_t addr);
> -extern void jump_label_update(unsigned long key, enum jump_label_type type);
> +extern void jump_label_update(jump_label_key_t *key, enum jump_label_type type);
>  extern void jump_label_apply_nops(struct module *mod);
>  extern int jump_label_text_reserved(void *start, void *end);
>  
> -#define jump_label_enable(key) \
> -	jump_label_update((unsigned long)key, JUMP_LABEL_ENABLE);
> +static inline int jump_label_enabled(jump_label_key_t *key)
> +{
> +	return key->state;
> +}
> +
> +static inline void jump_label_enable(jump_label_key_t *key)
> +{
> +	if (!key->state) {
> +		key->state = 1;
> +		jump_label_update(key, JUMP_LABEL_ENABLE);
> +	}
> +}
>  
> -#define jump_label_disable(key) \
> -	jump_label_update((unsigned long)key, JUMP_LABEL_DISABLE);
> +static inline void jump_label_disable(jump_label_key_t *key)
> +{
> +	if (key->state) {
> +		key->state = 0;
> +		jump_label_update(key, JUMP_LABEL_DISABLE);
> +	}
> +}

I'm assuming the above must be under some sort of lock, otherwise it is
very racy. If it is under a lock, than it should be commented.

>  
>  #else
>  
> +typedef int jump_label_key_t;
> +#define JUMP_LABEL_INIT 0
> +
>  #define JUMP_LABEL(key, label)			\
>  do {						\
>  	if (unlikely(*key))			\
>  		goto label;			\
>  } while (0)
>  
> -#define jump_label_enable(cond_var)	\
> -do {					\
> -       *(cond_var) = 1;			\
> -} while (0)
> +static inline int jump_label_enabled(jump_label_key_t *key)
> +{
> +	return *key;
> +}
>  
> -#define jump_label_disable(cond_var)	\
> -do {					\
> -       *(cond_var) = 0;			\
> -} while (0)
> +static inline void jump_label_enable(jump_label_key_t *key)
> +{
> +	*key = 1;
> +}
> +
> +static inline void jump_label_disable(jump_label_key_t *key)
> +{
> +	*key = 0;
> +}
>  
>  static inline int jump_label_apply_nops(struct module *mod)
>  {
> diff --git a/include/linux/jump_label_ref.h b/include/linux/jump_label_ref.h
> index e5d012a..a8454ba 100644
> --- a/include/linux/jump_label_ref.h
> +++ b/include/linux/jump_label_ref.h
> @@ -6,28 +6,37 @@
>  
>  #ifdef HAVE_JUMP_LABEL
>  
> -static inline void jump_label_inc(atomic_t *key)
> +struct jump_label_ref {
> +	void *ptr;
> +	atomic_t refcount;
> +};
> +
> +typedef struct jump_label_ref jump_label_refkey_t;
> +
> +static inline void jump_label_inc(jump_label_refkey_t *key)
>  {
> -	if (atomic_add_return(1, key) == 1)
> -		jump_label_enable(key);
> +	if (atomic_add_return(1, &key->refcount) == 1)
> +		jump_label_update((jump_label_key_t *)key, JUMP_LABEL_ENABLE);
>  }
>  
> -static inline void jump_label_dec(atomic_t *key)
> +static inline void jump_label_dec(jump_label_refkey_t *key)
>  {
> -	if (atomic_dec_and_test(key))
> -		jump_label_disable(key);
> +	if (atomic_dec_and_test(&key->refcount))
> +		jump_label_update((jump_label_key_t *)key, JUMP_LABEL_DISABLE);
>  }


If the above is not under lock, then it is racy. The atomics don't help.
Of course if this is racy, it was racy before this patch.

>  
>  #else /* !HAVE_JUMP_LABEL */
>  
> -static inline void jump_label_inc(atomic_t *key)
> +typedef atomic_t jump_label_refkey_t;
> +
> +static inline void jump_label_inc(jump_label_refkey_t *key)
>  {
> -	atomic_inc(key);
> +	atomic_inc((atomic_t *)key);
>  }
>  
> -static inline void jump_label_dec(atomic_t *key)
> +static inline void jump_label_dec(jump_label_refkey_t *key)
>  {
> -	atomic_dec(key);
> +	atomic_dec((atomic_t *)key);
>  }
>  
>  #undef JUMP_LABEL
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 40150f3..87c30c5 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -909,7 +909,7 @@ extern const char *perf_pmu_name(void);
>  extern void __perf_event_task_sched_in(struct task_struct *task);
>  extern void __perf_event_task_sched_out(struct task_struct *task, struct task_struct *next);
>  
> -extern atomic_t perf_task_events;
> +extern jump_label_refkey_t perf_task_events;
>  
>  static inline void perf_event_task_sched_in(struct task_struct *task)
>  {
> @@ -990,7 +990,7 @@ static inline int is_software_event(struct perf_event *event)
>  	return event->pmu->task_ctx_nr == perf_sw_context;
>  }
>  
> -extern atomic_t perf_swevent_enabled[PERF_COUNT_SW_MAX];
> +extern jump_label_refkey_t perf_swevent_enabled[PERF_COUNT_SW_MAX];
>  
>  extern void __perf_sw_event(u32, u64, int, struct pt_regs *, u64);
>  
> diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> index 5a6074f..e720382 100644
> --- a/include/linux/tracepoint.h
> +++ b/include/linux/tracepoint.h
> @@ -29,7 +29,7 @@ struct tracepoint_func {
>  
>  struct tracepoint {
>  	const char *name;		/* Tracepoint name */
> -	int state;			/* State. */
> +	jump_label_key_t key;
>  	void (*regfunc)(void);
>  	void (*unregfunc)(void);
>  	struct tracepoint_func *funcs;
> @@ -146,7 +146,7 @@ static inline void tracepoint_update_probe_range(struct tracepoint *begin,
>  	extern struct tracepoint __tracepoint_##name;			\
>  	static inline void trace_##name(proto)				\
>  	{								\
> -		JUMP_LABEL(&__tracepoint_##name.state, do_trace);	\
> +		JUMP_LABEL(&__tracepoint_##name.key, do_trace);	\
>  		return;							\
>  do_trace:								\
>  			__DO_TRACE(&__tracepoint_##name,		\
> @@ -175,7 +175,7 @@ do_trace:								\
>  	__attribute__((section("__tracepoints_strings"))) = #name;	\
>  	struct tracepoint __tracepoint_##name				\
>  	__attribute__((section("__tracepoints"), aligned(32))) =	\
> -		{ __tpstrtab_##name, 0, reg, unreg, NULL }
> +		{ __tpstrtab_##name, JUMP_LABEL_INIT, reg, unreg, NULL }
>  
>  #define DEFINE_TRACE(name)						\
>  	DEFINE_TRACE_FN(name, NULL, NULL);
> diff --git a/kernel/jump_label.c b/kernel/jump_label.c
> index 3b79bd9..e36ef8e 100644
> --- a/kernel/jump_label.c
> +++ b/kernel/jump_label.c
> @@ -26,10 +26,11 @@ static DEFINE_MUTEX(jump_label_mutex);
>  struct jump_label_entry {
>  	struct hlist_node hlist;
>  	struct jump_entry *table;
> -	int nr_entries;
>  	/* hang modules off here */
>  	struct hlist_head modules;
>  	unsigned long key;
> +	u32 nr_entries;
> +	int enabled;
>  };
>  
>  struct jump_label_module_entry {
> @@ -105,11 +106,16 @@ add_jump_label_entry(jump_label_t key, int nr_entries, struct jump_entry *table)

Not sure which kernel this is against (I'm looking at the latest
mainline), but where's the removal of the get_jump_label_entry() here?

Or is the hash still there for this part, and we just remove it for the
enable/disable parts?

>  
>  	hash = jhash((void *)&key, sizeof(jump_label_t), 0);
>  	head = &jump_label_table[hash & (JUMP_LABEL_TABLE_SIZE - 1)];
> -	e->key = key;
> +	e->key = (unsigned long)key;
>  	e->table = table;
>  	e->nr_entries = nr_entries;
> +	e->enabled = 0;
>  	INIT_HLIST_HEAD(&(e->modules));
>  	hlist_add_head(&e->hlist, head);
> +
> +	/*point jump_label_key_t here */
> +	((jump_label_key_t *)key)->ptr = e;
> +
>  	return e;
>  }
>  
> @@ -154,7 +160,7 @@ build_jump_label_hashtable(struct jump_entry *start, struct jump_entry *stop)
>   *
>   */
>  
> -void jump_label_update(unsigned long key, enum jump_label_type type)
> +void jump_label_update(jump_label_key_t *key, enum jump_label_type type)
>  {
>  	struct jump_entry *iter;
>  	struct jump_label_entry *entry;
> @@ -163,28 +169,39 @@ void jump_label_update(unsigned long key, enum jump_label_type type)
>  	int count;
>  
>  	jump_label_lock();
> -	entry = get_jump_label_entry((jump_label_t)key);
> -	if (entry) {
> -		count = entry->nr_entries;
> -		iter = entry->table;
> +	entry = (struct jump_label_entry *)key->ptr;

key->ptr should be of type struct jump_label_entry *, what else can it
point to?

-- Steve

> +	if (!entry) {
> +		if (type == JUMP_LABEL_ENABLE) {
> +			entry = add_jump_label_entry((jump_label_t)key, 0,
> +							NULL);
> +			if (IS_ERR(entry))
> +				goto out;
> +		} else
> +			goto out;
> +	}
> +	if (type == JUMP_LABEL_ENABLE)
> +		entry->enabled = 1;
> +	else
> +		entry->enabled = 0;
> +	count = entry->nr_entries;
> +	iter = entry->table;
> +	while (count--) {
> +		if (kernel_text_address(iter->code))
> +			arch_jump_label_transform(iter, type);
> +		iter++;
> +	}
> +	/* enable/disable jump labels in modules */
> +	hlist_for_each_entry(e_module, module_node, &(entry->modules),
> +						hlist) {
> +		count = e_module->nr_entries;
> +		iter = e_module->table;
>  		while (count--) {
> -			if (kernel_text_address(iter->code))
> +			if (iter->key && kernel_text_address(iter->code))
>  				arch_jump_label_transform(iter, type);
>  			iter++;
>  		}
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
>  	}
> +out:
>  	jump_label_unlock();
>  }
>  
> @@ -305,6 +322,7 @@ add_jump_label_module_entry(struct jump_label_entry *entry,
>  			    int count, struct module *mod)
>  {
>  	struct jump_label_module_entry *e;
> +	struct jump_entry *iter;
>  
>  	e = kmalloc(sizeof(struct jump_label_module_entry), GFP_KERNEL);
>  	if (!e)
> @@ -313,6 +331,13 @@ add_jump_label_module_entry(struct jump_label_entry *entry,
>  	e->nr_entries = count;
>  	e->table = iter_begin;
>  	hlist_add_head(&e->hlist, &entry->modules);
> +	if (entry->enabled) {
> +		iter = iter_begin;
> +		while (count--) {
> +			arch_jump_label_transform(iter, JUMP_LABEL_ENABLE);
> +			iter++;
> +		}
> +	}
>  	return e;
>  }
>  
> @@ -360,10 +385,6 @@ static void remove_jump_label_module(struct module *mod)
>  	struct jump_label_module_entry *e_module;
>  	int i;
>  
> -	/* if the module doesn't have jump label entries, just return */
> -	if (!mod->num_jump_entries)
> -		return;
> -
>  	for (i = 0; i < JUMP_LABEL_TABLE_SIZE; i++) {
>  		head = &jump_label_table[i];
>  		hlist_for_each_entry_safe(e, node, node_next, head, hlist) {
> @@ -375,10 +396,21 @@ static void remove_jump_label_module(struct module *mod)
>  					kfree(e_module);
>  				}
>  			}
> +		}
> +	}
> +	/* now check if any keys can be removed */
> +	for (i = 0; i < JUMP_LABEL_TABLE_SIZE; i++) {
> +		head = &jump_label_table[i];
> +		hlist_for_each_entry_safe(e, node, node_next, head, hlist) {
> +			if (!within_module_core(e->key, mod))
> +				continue;
>  			if (hlist_empty(&e->modules) && (e->nr_entries == 0)) {
>  				hlist_del(&e->hlist);
>  				kfree(e);
> +				continue;
>  			}
> +			WARN(1, KERN_ERR "jump label: "
> +				"tyring to remove used key: %lu !\n", e->key);
>  		}
>  	}
>  }
> @@ -470,7 +502,7 @@ void jump_label_apply_nops(struct module *mod)
>  
>  struct notifier_block jump_label_module_nb = {
>  	.notifier_call = jump_label_module_notify,
> -	.priority = 0,
> +	.priority = 1, /* higher than tracepoints */
>  };
>  
>  static __init int init_jump_label_module(void)
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index 8d099f3..503700c 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -35,7 +35,7 @@
>  
>  #include <asm/irq_regs.h>
>  
> -atomic_t perf_task_events __read_mostly;
> +jump_label_refkey_t perf_task_events __read_mostly;
>  static atomic_t nr_mmap_events __read_mostly;
>  static atomic_t nr_comm_events __read_mostly;
>  static atomic_t nr_task_events __read_mostly;
> @@ -4683,7 +4683,7 @@ fail:
>  	return err;
>  }
>  
> -atomic_t perf_swevent_enabled[PERF_COUNT_SW_MAX];
> +jump_label_refkey_t perf_swevent_enabled[PERF_COUNT_SW_MAX];
>  
>  static void sw_perf_event_destroy(struct perf_event *event)
>  {
> diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> index e95ee7f..d54b434 100644
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



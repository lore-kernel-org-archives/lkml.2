Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab0CVUEg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 16:04:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:59907 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961Ab0CVUEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 16:04:34 -0400
X-Authority-Analysis: v=1.0 c=1 a=hb4TZSJ86zAA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=20KFwNOVAAAA:8 a=VUfPwFXDnpjtt5SEjHQA:9 a=41OwBlPWiV1Pnce5uHwA:7 a=JHWA_iEBTtHgo01VVTn3XFiElMEA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=f7p99Ug5XU4UODxQ:21 a=qIE_3CPEelkv0MIP:21
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 2/5] jump label: base patch
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
       hpa@zytor.com, tglx@linutronix.de, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
       fweisbec@gmail.com
In-Reply-To: <79304b525d61cb0e7516cdee1ddcdb5ac3f2579a.1269272444.git.jbaron@redhat.com>
References: <cover.1269272444.git.jbaron@redhat.com>
	 <79304b525d61cb0e7516cdee1ddcdb5ac3f2579a.1269272444.git.jbaron@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 22 Mar 2010 16:04:25 -0400
Message-ID: <1269288265.2957.67.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-22 at 12:07 -0400, Jason Baron wrote:
> base patch to implement 'jump labeling'. Based on a new 'asm goto' inline
> assembly gcc mechanism, we can now branch to labels from an 'asm goto'
> statment. This allows us to create a 'no-op' fastpath, which can subsequently
> be patched with a jump to the slowpath code. This is useful for code which
> might be rarely used, but which we'd like to be able to call, if needed.
> Tracepoints are the current usecase that these are being implemented for.
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> ---
>  include/asm-generic/vmlinux.lds.h |   10 ++-
>  include/linux/jump_label.h        |   57 +++++++++++++
>  kernel/Makefile                   |    2 +-
>  kernel/jump_label.c               |  165 +++++++++++++++++++++++++++++++++++++
>  4 files changed, 232 insertions(+), 2 deletions(-)
>  create mode 100644 include/linux/jump_label.h
>  create mode 100644 kernel/jump_label.c
> 
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index 67e6520..83a469d 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -167,7 +167,8 @@
>  	BRANCH_PROFILE()						\
>  	TRACE_PRINTKS()							\
>  	FTRACE_EVENTS()							\
> -	TRACE_SYSCALLS()
> +	TRACE_SYSCALLS()						\
> +	JUMP_TABLE()							\
>  
>  /*
>   * Data section helpers
> @@ -206,6 +207,7 @@
>  		*(__vermagic)		/* Kernel version magic */	\
>  		*(__markers_strings)	/* Markers: strings */		\
>  		*(__tracepoints_strings)/* Tracepoints: strings */	\
> +		*(__jump_strings)/* Jump: strings */	\
>  	}								\
>  									\
>  	.rodata1          : AT(ADDR(.rodata1) - LOAD_OFFSET) {		\
> @@ -557,6 +559,12 @@
>  #define BUG_TABLE
>  #endif
>  
> +#define JUMP_TABLE()							\
> +	. = ALIGN(64);							\
> +		VMLINUX_SYMBOL(__start___jump_table) = .;		\
> +		*(__jump_table)						\
> +		VMLINUX_SYMBOL(__stop___jump_table) = .;		\
> +
>  #ifdef CONFIG_PM_TRACE
>  #define TRACEDATA							\
>  	. = ALIGN(4);							\
> diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
> new file mode 100644
> index 0000000..3d42e8c
> --- /dev/null
> +++ b/include/linux/jump_label.h
> @@ -0,0 +1,57 @@
> +#ifndef _LINUX_JUMP_LABEL_H
> +#define _LINUX_JUMP_LABEL_H
> +
> +#include <asm/jump_label.h>
> +
> +struct jump_entry {
> +	unsigned long code;
> +	unsigned long target;
> +	char *name;
> +};
> +
> +enum jump_label_type {
> +	JUMP_LABEL_ENABLE,
> +	JUMP_LABEL_DISABLE
> +};
> +
> +#ifdef __HAVE_ARCH_JUMP_LABEL
> +
> +extern struct jump_entry __start___jump_table[];
> +extern struct jump_entry __stop___jump_table[];
> +
> +#define DEFINE_JUMP_LABEL(name)						\
> +	const char __jlstrtab_##name[]					\
> +	__used __attribute__((section("__jump_strings")))  = #name;
> +
> +extern void arch_jump_label_transform(struct jump_entry *entry,
> +				 enum jump_label_type type);
> +
> +extern int jump_label_update(const char *name, enum jump_label_type type);
> +
> +#define enable_jump_label(name) \
> +	jump_label_update(name, JUMP_LABEL_ENABLE);
> +
> +#define disable_jump_label(name) \
> +	jump_label_update(name, JUMP_LABEL_DISABLE);
> +
> +#else
> +
> +#define DEFINE_JUMP_LABEL(name)
> +
> +#define JUMP_LABEL(tag, label, cond)		\
> +	if (unlikely(cond))			\
> +		goto label;
> +
> +static inline int enable_jump_label(const char *name)
> +{
> +	return 0;
> +}
> +
> +static inline int disable_jump_label(const char *name)
> +{
> +	return 0;
> +}
> +
> +#endif
> +
> +#endif
> diff --git a/kernel/Makefile b/kernel/Makefile
> index d5c3006..59ff12e 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -10,7 +10,7 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o \
>  	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
>  	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
>  	    notifier.o ksysfs.o pm_qos_params.o sched_clock.o cred.o \
> -	    async.o range.o
> +	    async.o range.o jump_label.o
>  obj-$(CONFIG_HAVE_EARLY_RES) += early_res.o
>  obj-y += groups.o
>  
> diff --git a/kernel/jump_label.c b/kernel/jump_label.c
> new file mode 100644
> index 0000000..671fcbb
> --- /dev/null
> +++ b/kernel/jump_label.c
> @@ -0,0 +1,165 @@
> +/*
> + * jump label support
> + *
> + * Copyright (C) 2009 Jason Baron <jbaron@redhat.com>
> + *
> + */
> +#include <linux/jump_label.h>
> +#include <linux/memory.h>
> +#include <linux/uaccess.h>
> +#include <linux/module.h>
> +#include <asm/alternative.h>
> +#include <linux/list.h>
> +#include <linux/jhash.h>
> +
> +#ifdef __HAVE_ARCH_JUMP_LABEL
> +
> +#define JUMP_LABEL_HASH_BITS 6
> +#define JUMP_LABEL_TABLE_SIZE (1 << JUMP_LABEL_HASH_BITS)
> +static struct hlist_head jump_label_table[JUMP_LABEL_TABLE_SIZE];
> +
> +/* mutex to protect coming/going of the the jump_label table */
> +static DEFINE_MUTEX(jump_label_mutex);
> +
> +struct jump_label_entry {
> +	struct hlist_node hlist;
> +	struct jump_entry *table;
> +	int nr_entries;
> +	/* hang modules off here */
> +	struct hlist_head modules;
> +	char name[0];
> +};
> +
> +static void swap_jump_label_entries(struct jump_entry *previous, struct jump_entry *next)
> +{
> +	struct jump_entry tmp;
> +
> +	tmp = *next;
> +	*next = *previous;
> +	*previous = tmp;
> +}
> +
> +static void sort_jump_label_entries(struct jump_entry *start, struct jump_entry *stop)
> +{
> +	int swapped = 0;
> +	struct jump_entry *iter;
> +	struct jump_entry *iter_next;
> +
> +	do {
> +		swapped = 0;
> +		iter = start;
> +		iter_next = start;
> +		iter_next++;
> +		for (; iter_next < stop; iter++, iter_next++) {
> +			if (strcmp(iter->name, iter_next->name) > 0) {
> +				swap_jump_label_entries(iter, iter_next);
> +				swapped = 1;
> +			}
> +		}
> +	} while (swapped == 1);

I'm curious to how long this takes with a few hundred trace points
(which we currently have). Perhaps this could be sorted at compile time?

> +}
> +
> +static struct jump_label_entry *get_jump_label_entry(const char *name)
> +{
> +	struct hlist_head *head;
> +	struct hlist_node *node;
> +	struct jump_label_entry *e;
> +	u32 hash = jhash(name, strlen(name), 0);
> +
> +	head = &jump_label_table[hash & (JUMP_LABEL_TABLE_SIZE - 1)];
> +	hlist_for_each_entry(e, node, head, hlist) {
> +		if (!strcmp(name, e->name))
> +			return e;
> +	}
> +	return NULL;
> +}
> +
> +static struct jump_label_entry *add_jump_label_entry(const char *name, int nr_entries, struct jump_entry *table)
> +{
> +	struct hlist_head *head;
> +	struct hlist_node *node;
> +	struct jump_label_entry *e;
> +	size_t name_len = strlen(name) + 1;
> +	u32 hash = jhash(name, name_len-1, 0);
> +
> +	head = &jump_label_table[hash & (JUMP_LABEL_TABLE_SIZE - 1)];
> +	hlist_for_each_entry(e, node, head, hlist) {
> +		if (!strcmp(name, e->name))
> +			return ERR_PTR(-EEXIST);
> +	}

I see duplicate code here for hashing.

Why not:

	e = get_jump_label_entry(name);
	if (e)
		return ERR_PTR(-EEXIST);

?

> +	e = kmalloc(sizeof(struct jump_label_entry) + name_len, GFP_KERNEL);
> +	if (!e)
> +		return ERR_PTR(-ENOMEM);
> +	memcpy(&e->name[0], name, name_len);
> +	e->table = table;
> +	e->nr_entries = nr_entries;
> +	INIT_HLIST_HEAD(&(e->modules));
> +	hlist_add_head(&e->hlist, head);
> +	return e;
> +}
> +
> +static int build_jump_label_hashtable(struct jump_entry *start, struct jump_entry *stop)
> +{
> +	struct jump_entry *iter, *iter_begin;
> +	struct jump_label_entry *entry;
> +	int count;
> +
> +	sort_jump_label_entries(start, stop);
> +	iter = start;
> +	while (iter < stop) {
> +		entry = get_jump_label_entry(iter->name);
> +		if (!entry) {
> +			iter_begin = iter;
> +			count = 0;
> +			while ((iter < stop) &&
> +				(strcmp(iter->name, iter_begin->name) == 0)) {
> +				iter++;
> +				count++;
> +			}
> +			entry = add_jump_label_entry(iter_begin->name, count,
> +						     iter_begin);
> +			if (IS_ERR(entry))
> +				return PTR_ERR(entry);
> +			continue;
> +		}
> +		WARN(1, KERN_ERR "build_jump_hashtable: unexpected entry!\n");
> +	}
> +	return 0;
> +}
> +
> +int jump_label_update(const char *name, enum jump_label_type type)

Non static function without kernel documentation. 

-- Steve


> +{
> +	struct jump_entry *iter;
> +	struct jump_label_entry *entry;
> +	struct hlist_node *module_node;
> +	struct jump_label_module_entry *e_module;
> +	int count;
> +
> +	mutex_lock(&jump_label_mutex);
> +	entry = get_jump_label_entry(name);
> +	if (entry) {
> +		count = entry->nr_entries;
> +		iter = entry->table;
> +		while (count--) {
> +			if (kernel_text_address(iter->code))
> +				arch_jump_label_transform(iter, type);
> +			iter++;
> +		}
> +	}
> +	mutex_unlock(&jump_label_mutex);
> +	return 0;
> +}
> +
> +static int init_jump_label(void)
> +{
> +	int ret;
> +
> +	mutex_lock(&jump_label_mutex);
> +	ret = build_jump_label_hashtable(__start___jump_table,
> +					 __stop___jump_table);
> +	mutex_unlock(&jump_label_mutex);
> +	return ret;
> +}
> +early_initcall(init_jump_label);
> +
> +#endif



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142Ab0IUChW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 22:37:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41492 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab0IUChU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 22:37:20 -0400
X-Authority-Analysis: v=1.1 cv=QPMnOuvfoRK4nyqTv0NRvva4Xk0fUUuJArrqv1I9dZo= c=1 sm=0 a=EgsJD7j8BzoA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=4j9qpO-8i26bf_s75hoA:9 a=yj78IRi5m1e6e3SGO-kA:7 a=Nq-dwrbYoQe3h7ZRWAgx9sv6hmMA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=PKQ2bNHYyaM01ioh:21 a=YXE_HR420jHrW3lW:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 03/10] jump label v11: base patch
From: Steven Rostedt <rostedt@goodmis.org>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
        hpa@zytor.com, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        vgoyal@redhat.com, sam@ravnborg.org, tony@bakeyournoodle.com
In-Reply-To: <ee8b3595967989fdaf84e698dc7447d315ce972a.1284733808.git.jbaron@redhat.com>
References: <cover.1284733808.git.jbaron@redhat.com>
	 <ee8b3595967989fdaf84e698dc7447d315ce972a.1284733808.git.jbaron@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 20 Sep 2010 22:37:18 -0400
Message-ID: <1285036638.23122.1125.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-17 at 11:09 -0400, Jason Baron wrote:
> base patch to implement 'jump labeling'. Based on a new 'asm goto' inline
> assembly gcc mechanism, we can now branch to labels from an 'asm goto'
> statment. This allows us to create a 'no-op' fastpath, which can subsequently
> be patched with a jump to the slowpath code. This is useful for code which
> might be rarely used, but which we'd like to be able to call, if needed.
> Tracepoints are the current usecase that these are being implemented for.
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> ---

> +static struct jump_label_entry *add_jump_label_entry(jump_label_t key, int nr_entries, struct jump_entry *table)
> +{
> +	struct hlist_head *head;
> +	struct jump_label_entry *e;
> +	u32 hash;
> +
> +	e = get_jump_label_entry(key);
> +	if (e)
> +		return ERR_PTR(-EEXIST);
> +
> +	e = kmalloc(sizeof(struct jump_label_entry), GFP_KERNEL);
> +	if (!e)
> +		return ERR_PTR(-ENOMEM);
> +
> +	hash = jhash((void *)&key, sizeof(jump_label_t), 0);
> +	head = &jump_label_table[hash & (JUMP_LABEL_TABLE_SIZE - 1)];
> +	e->key = key;
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
> +		entry = get_jump_label_entry(iter->key);
> +		if (!entry) {
> +			iter_begin = iter;
> +			count = 0;
> +			while ((iter < stop) &&
> +				(iter->key == iter_begin->key)) {
> +				iter++;
> +				count++;
> +			}
> +			entry = add_jump_label_entry(iter_begin->key,
> +							count, iter_begin);
> +			if (IS_ERR(entry))
> +				return PTR_ERR(entry);
> +		 } else {
> +			WARN_ONCE(1, KERN_ERR "build_jump_hashtable: unexpected entry!\n");
> +			return -1;
> +		}
> +	}
> +	return 0;
> +}
> +
> +/***
> + * jump_label_update - update jump label text
> + * @key -  key value associated with a a jump label
> + * @type - enum set to JUMP_LABEL_ENABLE or JUMP_LABEL_DISABLE
> + *
> + * Will enable/disable the jump for jump label @key, depending on the
> + * value of @type.
> + *
> + */
> +
> +void jump_label_update(unsigned long key, enum jump_label_type type)
> +{
> +	struct jump_entry *iter;
> +	struct jump_label_entry *entry;
> +	struct hlist_node *module_node;
> +	struct jump_label_module_entry *e_module;
> +	int count;
> +
> +	mutex_lock(&jump_label_mutex);
> +	entry = get_jump_label_entry((jump_label_t)key);
> +	if (entry) {
> +		count = entry->nr_entries;
> +		iter = entry->table;
> +		while (count--) {
> +			if (kernel_text_address(iter->code))
> +				arch_jump_label_transform(iter, type);
> +			iter++;
> +		}
> +		/* eanble/disable jump labels in modules */
> +		hlist_for_each_entry(e_module, module_node, &(entry->modules),
> +							hlist) {
> +			count = e_module->nr_entries;
> +			iter = e_module->table;
> +			while (count--) {
> +				if (kernel_text_address(iter->code))
> +					arch_jump_label_transform(iter, type);
> +				iter++;
> +			}
> +		}
> +	}
> +	mutex_unlock(&jump_label_mutex);
> +}
> +
> +static __init int init_jump_label(void)
> +{
> +	int ret;
> +	struct jump_entry *iter_start = __start___jump_table;
> +	struct jump_entry *iter_stop = __stop___jump_table;
> +	struct jump_entry *iter;
> +
> +	mutex_lock(&jump_label_mutex);
> +	ret = build_jump_label_hashtable(__start___jump_table,
> +					 __stop___jump_table);
> +	iter = iter_start;
> +	while (iter < iter_stop) {
> +		arch_jump_label_text_poke_early(iter->code);
> +		iter++;
> +	}
> +	mutex_unlock(&jump_label_mutex);
> +	return ret;
> +}
> +early_initcall(init_jump_label);
> +
> +#ifdef CONFIG_MODULES
> +
> +static struct jump_label_module_entry *add_jump_label_module_entry(struct jump_label_entry *entry, struct jump_entry *iter_begin, int count, struct module *mod)


Eek!!

I'm not that strict on the 80 character limit, but the above can wrap it
twice!!!

I'll fix these extended lines myself.

-- Steve

> +{
> +	struct jump_label_module_entry *e;
> +
> +	e = kmalloc(sizeof(struct jump_label_module_entry), GFP_KERNEL);
> +	if (!e)
> +		return ERR_PTR(-ENOMEM);
> +	e->mod = mod;
> +	e->nr_entries = count;
> +	e->table = iter_begin;
> +	hlist_add_head(&e->hlist, &entry->modules);
> +	return e;
> +}
> +
> +static int add_jump_label_module(struct module *mod)
> +{
> +	struct jump_entry *iter, *iter_begin;
> +	struct jump_label_entry *entry;
> +	struct jump_label_module_entry *module_entry;
> +	int count;
> +
> +	/* if the module doesn't have jump label entries, just return */
> +	if (!mod->num_jump_entries)
> +		return 0;
> +
> +	sort_jump_label_entries(mod->jump_entries,
> +				mod->jump_entries + mod->num_jump_entries);
> +	iter = mod->jump_entries;
> +	while (iter < mod->jump_entries + mod->num_jump_entries) {
> +		entry = get_jump_label_entry(iter->key);
> +		iter_begin = iter;
> +		count = 0;
> +		while ((iter < mod->jump_entries + mod->num_jump_entries) &&
> +			(iter->key == iter_begin->key)) {
> +				iter++;
> +				count++;
> +		}
> +		if (!entry) {
> +			entry = add_jump_label_entry(iter_begin->key, 0, NULL);
> +			if (IS_ERR(entry))
> +				return PTR_ERR(entry);
> +		}
> +		module_entry = add_jump_label_module_entry(entry, iter_begin,
> +							   count, mod);
> +		if (IS_ERR(module_entry))
> +			return PTR_ERR(module_entry);
> +	}
> +	return 0;
> +}
> +
> +static void remove_jump_label_module(struct module *mod)
> +{
> +	struct hlist_head *head;
> +	struct hlist_node *node, *node_next, *module_node, *module_node_next;
> +	struct jump_label_entry *e;
> +	struct jump_label_module_entry *e_module;
> +	int i;
> +
> +	/* if the module doesn't have jump label entries, just return */
> +	if (!mod->num_jump_entries)
> +		return;
> +
> +	for (i = 0; i < JUMP_LABEL_TABLE_SIZE; i++) {
> +		head = &jump_label_table[i];
> +		hlist_for_each_entry_safe(e, node, node_next, head, hlist) {
> +			hlist_for_each_entry_safe(e_module, module_node,
> +						  module_node_next,
> +						  &(e->modules), hlist) {
> +				if (e_module->mod == mod) {
> +					hlist_del(&e_module->hlist);
> +					kfree(e_module);
> +				}
> +			}
> +			if (hlist_empty(&e->modules) && (e->nr_entries == 0)) {
> +				hlist_del(&e->hlist);
> +				kfree(e);
> +			}
> +		}
> +	}
> +}
> +
> +static int jump_label_module_notify(struct notifier_block *self, unsigned long val, void *data)
> +{
> +	struct module *mod = data;
> +	int ret = 0;
> +
> +	switch (val) {
> +	case MODULE_STATE_COMING:
> +		mutex_lock(&jump_label_mutex);
> +		ret = add_jump_label_module(mod);
> +		if (ret)
> +			remove_jump_label_module(mod);
> +		mutex_unlock(&jump_label_mutex);
> +		break;
> +	case MODULE_STATE_GOING:
> +		mutex_lock(&jump_label_mutex);
> +		remove_jump_label_module(mod);
> +		mutex_unlock(&jump_label_mutex);
> +		break;
> +	}
> +	return ret;
> +}
> +
> +/***
> + * apply_jump_label_nops - patch module jump labels with arch_get_jump_label_nop()
> + * @mod: module to patch
> + *
> + * Allow for run-time selection of the optimal nops. Before the module
> + * loads patch these with arch_get_jump_label_nop(), which is specified by
> + * the arch specific jump label code.
> + */
> +void jump_label_apply_nops(struct module *mod)
> +{
> +	struct jump_entry *iter;
> +
> +	/* if the module doesn't have jump label entries, just return */
> +	if (!mod->num_jump_entries)
> +		return;
> +
> +	iter = mod->jump_entries;
> +	while (iter < mod->jump_entries + mod->num_jump_entries) {
> +		arch_jump_label_text_poke_early(iter->code);
> +		iter++;
> +	}
> +}
> +
> +struct notifier_block jump_label_module_nb = {
> +	.notifier_call = jump_label_module_notify,
> +	.priority = 0,
> +};
> +
> +static __init int init_jump_label_module(void)
> +{
> +	return register_module_notifier(&jump_label_module_nb);
> +}
> +early_initcall(init_jump_label_module);
> +
> +#endif /* CONFIG_MODULES */
> +
> +#endif
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index 282035f..798adfa 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -47,6 +47,7 @@
>  #include <linux/memory.h>
>  #include <linux/ftrace.h>
>  #include <linux/cpu.h>
> +#include <linux/jump_label.h>
>  
>  #include <asm-generic/sections.h>
>  #include <asm/cacheflush.h>
> diff --git a/kernel/module.c b/kernel/module.c
> index d0b5f8d..eba1341 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -55,6 +55,7 @@
>  #include <linux/async.h>
>  #include <linux/percpu.h>
>  #include <linux/kmemleak.h>
> +#include <linux/jump_label.h>
>  
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/module.h>
> @@ -2308,6 +2309,11 @@ static void find_module_sections(struct module *mod, struct load_info *info)
>  					sizeof(*mod->tracepoints),
>  					&mod->num_tracepoints);
>  #endif
> +#ifdef HAVE_JUMP_LABEL
> +	mod->jump_entries = section_objs(info, "__jump_table",
> +					sizeof(*mod->jump_entries),
> +					&mod->num_jump_entries);
> +#endif
>  #ifdef CONFIG_EVENT_TRACING
>  	mod->trace_events = section_objs(info, "_ftrace_events",
>  					 sizeof(*mod->trace_events),
> diff --git a/scripts/gcc-goto.sh b/scripts/gcc-goto.sh
> new file mode 100644
> index 0000000..8e82424
> --- /dev/null
> +++ b/scripts/gcc-goto.sh
> @@ -0,0 +1,5 @@
> +#!/bin/sh
> +# Test for gcc 'asm goto' suport
> +# Copyright (C) 2010, Jason Baron <jbaron@redhat.com>
> +
> +echo "int main(void) { entry: asm goto (\"\"::::entry); return 0; }" | $1 -x c - -c -o /dev/null >/dev/null 2>&1 && echo "y"



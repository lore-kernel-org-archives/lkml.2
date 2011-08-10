Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab1HJTQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 15:16:59 -0400
Received: from mail.openrapids.net ([64.15.138.104]:50942 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754766Ab1HJTQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 15:16:58 -0400
Date: Wed, 10 Aug 2011 15:16:56 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, tglx@linutronix.de,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [RFC PATCH][3.0] Tracepoint: dissociate from module mutex
Message-ID: <20110810191655.GB8525@Krystal>
References: <20110810174101.GA6523@Krystal> <1313002814.18583.260.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313002814.18583.260.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 15:16:32 up 260 days, 19 min,  4 users,  load average: 0.08,
	0.03, 0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Wed, 2011-08-10 at 13:41 -0400, Mathieu Desnoyers wrote:
[...]
> >  void tracepoint_update_probe_range(struct tracepoint * const *begin,
> >  				   struct tracepoint * const *end)
> 
> Can we make this static?

will do, thanks!

Mathieu

> 
> Otherwise, looks good.
> 
> -- Steve
> 
> > @@ -302,7 +308,6 @@ void tracepoint_update_probe_range(struc
> >  	if (!begin)
> >  		return;
> >  
> > -	mutex_lock(&tracepoints_mutex);
> >  	for (iter = begin; iter < end; iter++) {
> >  		mark_entry = get_tracepoint((*iter)->name);
> >  		if (mark_entry) {
> > @@ -312,11 +317,27 @@ void tracepoint_update_probe_range(struc
> >  			disable_tracepoint(*iter);
> >  		}
> >  	}
> > -	mutex_unlock(&tracepoints_mutex);
> >  }
> >  
> > +#ifdef CONFIG_MODULES
> > +void module_update_tracepoints(void)
> > +{
> > +	struct tp_module *tp_mod;
> > +
> > +	list_for_each_entry(tp_mod, &tracepoint_module_list, list)
> > +		tracepoint_update_probe_range(tp_mod->tracepoints_ptrs,
> > +			tp_mod->tracepoints_ptrs + tp_mod->num_tracepoints);
> > +}
> > +#else /* CONFIG_MODULES */
> > +void module_update_tracepoints(void)
> > +{
> > +}
> > +#endif /* CONFIG_MODULES */
> > +
> > +
> >  /*
> >   * Update probes, removing the faulty probes.
> > + * Called with tracepoints_mutex held.
> >   */
> >  static void tracepoint_update_probes(void)
> >  {
> > @@ -359,11 +380,12 @@ int tracepoint_probe_register(const char
> >  
> >  	mutex_lock(&tracepoints_mutex);
> >  	old = tracepoint_add_probe(name, probe, data);
> > -	mutex_unlock(&tracepoints_mutex);
> > -	if (IS_ERR(old))
> > +	if (IS_ERR(old)) {
> > +		mutex_unlock(&tracepoints_mutex);
> >  		return PTR_ERR(old);
> > -
> > +	}
> >  	tracepoint_update_probes();		/* may update entry */
> > +	mutex_unlock(&tracepoints_mutex);
> >  	release_probes(old);
> >  	return 0;
> >  }
> > @@ -402,11 +424,12 @@ int tracepoint_probe_unregister(const ch
> >  
> >  	mutex_lock(&tracepoints_mutex);
> >  	old = tracepoint_remove_probe(name, probe, data);
> > -	mutex_unlock(&tracepoints_mutex);
> > -	if (IS_ERR(old))
> > +	if (IS_ERR(old)) {
> > +		mutex_unlock(&tracepoints_mutex);
> >  		return PTR_ERR(old);
> > -
> > +	}
> >  	tracepoint_update_probes();		/* may update entry */
> > +	mutex_unlock(&tracepoints_mutex);
> >  	release_probes(old);
> >  	return 0;
> >  }
> > @@ -489,9 +512,8 @@ void tracepoint_probe_update_all(void)
> >  	if (!list_empty(&old_probes))
> >  		list_replace_init(&old_probes, &release_probes);
> >  	need_update = 0;
> > -	mutex_unlock(&tracepoints_mutex);
> > -
> >  	tracepoint_update_probes();
> > +	mutex_unlock(&tracepoints_mutex);
> >  	list_for_each_entry_safe(pos, next, &release_probes, u.list) {
> >  		list_del(&pos->u.list);
> >  		call_rcu_sched(&pos->u.rcu, rcu_free_old_probes);
> > @@ -509,7 +531,7 @@ EXPORT_SYMBOL_GPL(tracepoint_probe_updat
> >   * Will return the first tracepoint in the range if the input tracepoint is
> >   * NULL.
> >   */
> > -int tracepoint_get_iter_range(struct tracepoint * const **tracepoint,
> > +static int tracepoint_get_iter_range(struct tracepoint * const **tracepoint,
> >  	struct tracepoint * const *begin, struct tracepoint * const *end)
> >  {
> >  	if (!*tracepoint && begin != end) {
> > @@ -520,11 +542,12 @@ int tracepoint_get_iter_range(struct tra
> >  		return 1;
> >  	return 0;
> >  }
> > -EXPORT_SYMBOL_GPL(tracepoint_get_iter_range);
> >  
> > +#ifdef CONFIG_MODULES
> >  static void tracepoint_get_iter(struct tracepoint_iter *iter)
> >  {
> >  	int found = 0;
> > +	struct tp_module *iter_mod;
> >  
> >  	/* Core kernel tracepoints */
> >  	if (!iter->module) {
> > @@ -534,12 +557,43 @@ static void tracepoint_get_iter(struct t
> >  		if (found)
> >  			goto end;
> >  	}
> > -	/* tracepoints in modules. */
> > -	found = module_get_iter_tracepoints(iter);
> > +	/* Tracepoints in modules */
> > +	mutex_lock(&tracepoints_mutex);
> > +	list_for_each_entry(iter_mod, &tracepoint_module_list, list) {
> > +		/*
> > +		 * Sorted module list
> > +		 */
> > +		if (iter_mod < iter->module)
> > +			continue;
> > +		else if (iter_mod > iter->module)
> > +			iter->tracepoint = NULL;
> > +		found = tracepoint_get_iter_range(&iter->tracepoint,
> > +			iter_mod->tracepoints_ptrs,
> > +			iter_mod->tracepoints_ptrs
> > +				+ iter_mod->num_tracepoints);
> > +		if (found) {
> > +			iter->module = iter_mod;
> > +			break;
> > +		}
> > +	}
> > +	mutex_unlock(&tracepoints_mutex);
> >  end:
> >  	if (!found)
> >  		tracepoint_iter_reset(iter);
> >  }
> > +#else /* CONFIG_MODULES */
> > +static void tracepoint_get_iter(struct tracepoint_iter *iter)
> > +{
> > +	int found = 0;
> > +
> > +	/* Core kernel tracepoints */
> > +	found = tracepoint_get_iter_range(&iter->tracepoint,
> > +			__start___tracepoints_ptrs,
> > +			__stop___tracepoints_ptrs);
> > +	if (!found)
> > +		tracepoint_iter_reset(iter);
> > +}
> > +#endif /* CONFIG_MODULES */
> >  
> >  void tracepoint_iter_start(struct tracepoint_iter *iter)
> >  {
> > @@ -566,26 +620,98 @@ EXPORT_SYMBOL_GPL(tracepoint_iter_stop);
> >  
> >  void tracepoint_iter_reset(struct tracepoint_iter *iter)
> >  {
> > +#ifdef CONFIG_MODULES
> >  	iter->module = NULL;
> > +#endif /* CONFIG_MODULES */
> >  	iter->tracepoint = NULL;
> >  }
> >  EXPORT_SYMBOL_GPL(tracepoint_iter_reset);
> >  
> >  #ifdef CONFIG_MODULES
> > +static int tracepoint_module_coming(struct module *mod)
> > +{
> > +	struct tp_module *tp_mod, *iter;
> > +	int ret = 0;
> > +
> > +	/*
> > +	 * We skip modules that tain the kernel, especially those with different
> > +	 * module header (for forced load), to make sure we don't cause a crash.
> > +	 */
> > +	if (mod->taints)
> > +		return 0;
> > +	mutex_lock(&tracepoints_mutex);
> > +	tp_mod = kmalloc(sizeof(struct tp_module), GFP_KERNEL);
> > +	if (!tp_mod) {
> > +		ret = -ENOMEM;
> > +		goto end;
> > +	}
> > +	tp_mod->num_tracepoints = mod->num_tracepoints;
> > +	tp_mod->tracepoints_ptrs = mod->tracepoints_ptrs;
> > +
> > +	/*
> > +	 * tracepoint_module_list is kept sorted by struct module pointer
> > +	 * address for iteration on tracepoints from a seq_file that can release
> > +	 * the mutex between calls.
> > +	 */
> > +	list_for_each_entry_reverse(iter, &tracepoint_module_list, list) {
> > +		BUG_ON(iter == tp_mod);	/* Should never be in the list twice */
> > +		if (iter < tp_mod) {
> > +			/* We belong to the location right after iter. */
> > +			list_add(&tp_mod->list, &iter->list);
> > +			goto module_added;
> > +		}
> > +	}
> > +	/* We belong to the beginning of the list */
> > +	list_add(&tp_mod->list, &tracepoint_module_list);
> > +module_added:
> > +	tracepoint_update_probe_range(mod->tracepoints_ptrs,
> > +		mod->tracepoints_ptrs + mod->num_tracepoints);
> > +end:
> > +	mutex_unlock(&tracepoints_mutex);
> > +	return ret;
> > +}
> > +
> > +static int tracepoint_module_going(struct module *mod)
> > +{
> > +	struct tp_module *pos;
> > +
> > +	mutex_lock(&tracepoints_mutex);
> > +	tracepoint_update_probe_range(mod->tracepoints_ptrs,
> > +		mod->tracepoints_ptrs + mod->num_tracepoints);
> > +	list_for_each_entry(pos, &tracepoint_module_list, list) {
> > +		if (pos->tracepoints_ptrs == mod->tracepoints_ptrs) {
> > +			list_del(&pos->list);
> > +			kfree(pos);
> > +			break;
> > +		}
> > +	}
> > +	/*
> > +	 * In the case of modules that were tainted at "coming", we'll simply
> > +	 * walk through the list without finding it. We cannot use the "tainted"
> > +	 * flag on "going", in case a module taints the kernel only after being
> > +	 * loaded.
> > +	 */
> > +	mutex_unlock(&tracepoints_mutex);
> > +	return 0;
> > +}
> >  
> >  int tracepoint_module_notify(struct notifier_block *self,
> >  			     unsigned long val, void *data)
> >  {
> >  	struct module *mod = data;
> > +	int ret = 0;
> >  
> >  	switch (val) {
> >  	case MODULE_STATE_COMING:
> > +		ret = tracepoint_module_coming(mod);
> > +		break;
> > +	case MODULE_STATE_LIVE:
> > +		break;
> >  	case MODULE_STATE_GOING:
> > -		tracepoint_update_probe_range(mod->tracepoints_ptrs,
> > -			mod->tracepoints_ptrs + mod->num_tracepoints);
> > +		ret = tracepoint_module_going(mod);
> >  		break;
> >  	}
> > -	return 0;
> > +	return ret;
> >  }
> >  
> >  struct notifier_block tracepoint_module_nb = {
> > @@ -598,7 +724,6 @@ static int init_tracepoints(void)
> >  	return register_module_notifier(&tracepoint_module_nb);
> >  }
> >  __initcall(init_tracepoints);
> > -
> >  #endif /* CONFIG_MODULES */
> >  
> >  #ifdef CONFIG_HAVE_SYSCALL_TRACEPOINTS
> > Index: linux-2.6-lttng/include/linux/module.h
> > ===================================================================
> > --- linux-2.6-lttng.orig/include/linux/module.h
> > +++ linux-2.6-lttng/include/linux/module.h
> > @@ -578,9 +578,6 @@ int unregister_module_notifier(struct no
> >  
> >  extern void print_modules(void);
> >  
> > -extern void module_update_tracepoints(void);
> > -extern int module_get_iter_tracepoints(struct tracepoint_iter *iter);
> > -
> >  #else /* !CONFIG_MODULES... */
> >  #define EXPORT_SYMBOL(sym)
> >  #define EXPORT_SYMBOL_GPL(sym)
> > @@ -696,15 +693,6 @@ static inline int unregister_module_noti
> >  static inline void print_modules(void)
> >  {
> >  }
> > -
> > -static inline void module_update_tracepoints(void)
> > -{
> > -}
> > -
> > -static inline int module_get_iter_tracepoints(struct tracepoint_iter *iter)
> > -{
> > -	return 0;
> > -}
> >  #endif /* CONFIG_MODULES */
> >  
> >  #ifdef CONFIG_SYSFS
> > 
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com

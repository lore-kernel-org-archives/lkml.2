Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859Ab0IWRCg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 13:02:36 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:56149 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755837Ab0IWRCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 13:02:34 -0400
Date: Thu, 23 Sep 2010 10:02:26 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        rusty@rustcorp.com.au, tglx@linutronix.de
Subject: Re: [PATCH] Convert preempt_disabled in module.c to rcu read lock
Message-ID: <20100923170226.GC2406@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1285160840-16506-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285160840-16506-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 22, 2010 at 03:07:20PM +0200, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Thomas Gleixner pointed out that the list_for_each_rcu()
> in module really need to use RCU read lock, not preempt disable.
> This is especially needed for the preemptive RCU code.
> >From what I understand the only reason for the preemption
> disabling is to protect against rcu, so using rcu_read_lock()
> is correct.
> 
> Open: this will do rcu_read_lock() asynchronously in oopses. That's ok
> with all RCU implementations without deadlocks?

The rcu_read_unlock() slowpath has some locking in the preemptible RCU
implementations (TINY_PREEMPT_RCU and TREE_PREEMPT_RCU).  These locks
are acquired only when exiting an RCU read-side critical section that
was preempted.

But given that Rusty noted that you need preempt_disable(), how about
using synchronize_sched() instead of synchronize_rcu() on the update side?
Then rcu_read_unlock_sched() just does a preempt_enable().

							Thanx, Paul

> Cc: paulmck@linux.vnet.ibm.com
> Cc: rusty@rustcorp.com.au
> Cc: tglx@linutronix.de
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  kernel/module.c |   78 ++++++++++++++++++++++++++----------------------------
>  1 files changed, 38 insertions(+), 40 deletions(-)
> 
> diff --git a/kernel/module.c b/kernel/module.c
> index d0b5f8d..ea99f4c 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -74,7 +74,7 @@
> 
>  /*
>   * Mutex protects:
> - * 1) List of modules (also safely readable with preempt_disable),
> + * 1) List of modules (also safely readable with rcu_read_lock),
>   * 2) module_use links,
>   * 3) module_addr_min/module_addr_max.
>   * (delete uses stop_machine/add uses RCU list operations). */
> @@ -344,7 +344,7 @@ static bool find_symbol_in_section(const struct symsearch *syms,
>  }
> 
>  /* Find a symbol and return it, along with, (optional) crc and
> - * (optional) module which owns it.  Needs preempt disabled or module_mutex. */
> + * (optional) module which owns it.  Needs rcu_read_lock or module_mutex. */
>  const struct kernel_symbol *find_symbol(const char *name,
>  					struct module **owner,
>  					const unsigned long **crc,
> @@ -443,8 +443,7 @@ bool is_module_percpu_address(unsigned long addr)
>  	struct module *mod;
>  	unsigned int cpu;
> 
> -	preempt_disable();
> -
> +	rcu_read_lock();
>  	list_for_each_entry_rcu(mod, &modules, list) {
>  		if (!mod->percpu_size)
>  			continue;
> @@ -453,13 +452,13 @@ bool is_module_percpu_address(unsigned long addr)
> 
>  			if ((void *)addr >= start &&
>  			    (void *)addr < start + mod->percpu_size) {
> -				preempt_enable();
> +				rcu_read_unlock();
>  				return true;
>  			}
>  		}
>  	}
> 
> -	preempt_enable();
> +	rcu_read_unlock();
>  	return false;
>  }
> 
> @@ -831,11 +830,11 @@ void __symbol_put(const char *symbol)
>  {
>  	struct module *owner;
> 
> -	preempt_disable();
> +	rcu_read_lock();
>  	if (!find_symbol(symbol, &owner, NULL, true, false))
>  		BUG();
>  	module_put(owner);
> -	preempt_enable();
> +	rcu_read_unlock();
>  }
>  EXPORT_SYMBOL(__symbol_put);
> 
> @@ -870,7 +869,7 @@ static struct module_attribute refcnt = {
>  void module_put(struct module *module)
>  {
>  	if (module) {
> -		preempt_disable();
> +		rcu_read_lock();
>  		smp_wmb(); /* see comment in module_refcount */
>  		__this_cpu_inc(module->refptr->decs);
> 
> @@ -878,7 +877,7 @@ void module_put(struct module *module)
>  		/* Maybe they're waiting for us to drop reference? */
>  		if (unlikely(!module_is_live(module)))
>  			wake_up_process(module->waiter);
> -		preempt_enable();
> +		rcu_read_unlock();
>  	}
>  }
>  EXPORT_SYMBOL(module_put);
> @@ -1584,11 +1583,11 @@ void *__symbol_get(const char *symbol)
>  	struct module *owner;
>  	const struct kernel_symbol *sym;
> 
> -	preempt_disable();
> +	rcu_read_lock();
>  	sym = find_symbol(symbol, &owner, NULL, true, true);
>  	if (sym && strong_try_module_get(owner))
>  		sym = NULL;
> -	preempt_enable();
> +	rcu_read_unlock();
> 
>  	return sym ? (void *)sym->value : NULL;
>  }
> @@ -2813,7 +2812,7 @@ static const char *get_ksymbol(struct module *mod,
>  }
> 
>  /* For kallsyms to ask for address resolution.  NULL means not found.  Careful
> - * not to lock to avoid deadlock on oopses, simply disable preemption. */
> + * not to lock to avoid deadlock on oopses, simply use rcu read lock. */
>  const char *module_address_lookup(unsigned long addr,
>  			    unsigned long *size,
>  			    unsigned long *offset,
> @@ -2823,7 +2822,7 @@ const char *module_address_lookup(unsigned long addr,
>  	struct module *mod;
>  	const char *ret = NULL;
> 
> -	preempt_disable();
> +	rcu_read_lock();
>  	list_for_each_entry_rcu(mod, &modules, list) {
>  		if (within_module_init(addr, mod) ||
>  		    within_module_core(addr, mod)) {
> @@ -2834,11 +2833,12 @@ const char *module_address_lookup(unsigned long addr,
>  		}
>  	}
>  	/* Make a copy in here where it's safe */
> +	/* AK: The string copy is likely racy. */
>  	if (ret) {
>  		strncpy(namebuf, ret, KSYM_NAME_LEN - 1);
>  		ret = namebuf;
>  	}
> -	preempt_enable();
> +	rcu_read_unlock();
>  	return ret;
>  }
> 
> @@ -2846,7 +2846,7 @@ int lookup_module_symbol_name(unsigned long addr, char *symname)
>  {
>  	struct module *mod;
> 
> -	preempt_disable();
> +	rcu_read_lock();
>  	list_for_each_entry_rcu(mod, &modules, list) {
>  		if (within_module_init(addr, mod) ||
>  		    within_module_core(addr, mod)) {
> @@ -2854,14 +2854,13 @@ int lookup_module_symbol_name(unsigned long addr, char *symname)
> 
>  			sym = get_ksymbol(mod, addr, NULL, NULL);
>  			if (!sym)
> -				goto out;
> +				break;
>  			strlcpy(symname, sym, KSYM_NAME_LEN);
> -			preempt_enable();
> +			rcu_read_unlock();
>  			return 0;
>  		}
>  	}
> -out:
> -	preempt_enable();
> +	rcu_read_unlock();
>  	return -ERANGE;
>  }
> 
> @@ -2870,7 +2869,7 @@ int lookup_module_symbol_attrs(unsigned long addr, unsigned long *size,
>  {
>  	struct module *mod;
> 
> -	preempt_disable();
> +	rcu_read_lock();
>  	list_for_each_entry_rcu(mod, &modules, list) {
>  		if (within_module_init(addr, mod) ||
>  		    within_module_core(addr, mod)) {
> @@ -2878,17 +2877,16 @@ int lookup_module_symbol_attrs(unsigned long addr, unsigned long *size,
> 
>  			sym = get_ksymbol(mod, addr, size, offset);
>  			if (!sym)
> -				goto out;
> +				break;
>  			if (modname)
>  				strlcpy(modname, mod->name, MODULE_NAME_LEN);
>  			if (name)
>  				strlcpy(name, sym, KSYM_NAME_LEN);
> -			preempt_enable();
> +			rcu_read_unlock();
>  			return 0;
>  		}
>  	}
> -out:
> -	preempt_enable();
> +	rcu_read_unlock();
>  	return -ERANGE;
>  }
> 
> @@ -2897,7 +2895,7 @@ int module_get_kallsym(unsigned int symnum, unsigned long *value, char *type,
>  {
>  	struct module *mod;
> 
> -	preempt_disable();
> +	rcu_read_lock();
>  	list_for_each_entry_rcu(mod, &modules, list) {
>  		if (symnum < mod->num_symtab) {
>  			*value = mod->symtab[symnum].st_value;
> @@ -2906,12 +2904,12 @@ int module_get_kallsym(unsigned int symnum, unsigned long *value, char *type,
>  				KSYM_NAME_LEN);
>  			strlcpy(module_name, mod->name, MODULE_NAME_LEN);
>  			*exported = is_exported(name, *value, mod);
> -			preempt_enable();
> +			rcu_read_unlock();
>  			return 0;
>  		}
>  		symnum -= mod->num_symtab;
>  	}
> -	preempt_enable();
> +	rcu_read_unlock();
>  	return -ERANGE;
>  }
> 
> @@ -2934,7 +2932,7 @@ unsigned long module_kallsyms_lookup_name(const char *name)
>  	unsigned long ret = 0;
> 
>  	/* Don't lock: we're in enough trouble already. */
> -	preempt_disable();
> +	rcu_read_lock();
>  	if ((colon = strchr(name, ':')) != NULL) {
>  		*colon = '\0';
>  		if ((mod = find_module(name)) != NULL)
> @@ -2945,7 +2943,7 @@ unsigned long module_kallsyms_lookup_name(const char *name)
>  			if ((ret = mod_find_symname(mod, name)) != 0)
>  				break;
>  	}
> -	preempt_enable();
> +	rcu_read_unlock();
>  	return ret;
>  }
> 
> @@ -3083,7 +3081,7 @@ const struct exception_table_entry *search_module_extables(unsigned long addr)
>  	const struct exception_table_entry *e = NULL;
>  	struct module *mod;
> 
> -	preempt_disable();
> +	rcu_read_lock();
>  	list_for_each_entry_rcu(mod, &modules, list) {
>  		if (mod->num_exentries == 0)
>  			continue;
> @@ -3094,7 +3092,7 @@ const struct exception_table_entry *search_module_extables(unsigned long addr)
>  		if (e)
>  			break;
>  	}
> -	preempt_enable();
> +	rcu_read_unlock();
> 
>  	/* Now, if we found one, we are running inside it now, hence
>  	   we cannot unload the module, hence no refcnt needed. */
> @@ -3112,9 +3110,9 @@ bool is_module_address(unsigned long addr)
>  {
>  	bool ret;
> 
> -	preempt_disable();
> +	rcu_read_lock();
>  	ret = __module_address(addr) != NULL;
> -	preempt_enable();
> +	rcu_read_unlock();
> 
>  	return ret;
>  }
> @@ -3153,9 +3151,9 @@ bool is_module_text_address(unsigned long addr)
>  {
>  	bool ret;
> 
> -	preempt_disable();
> +	rcu_read_lock();
>  	ret = __module_text_address(addr) != NULL;
> -	preempt_enable();
> +	rcu_read_unlock();
> 
>  	return ret;
>  }
> @@ -3164,7 +3162,7 @@ bool is_module_text_address(unsigned long addr)
>   * __module_text_address - get the module whose code contains an address.
>   * @addr: the address.
>   *
> - * Must be called with preempt disabled or module mutex held so that
> + * Must be called with rcu read lock or module mutex held so that
>   * module doesn't get freed during this.
>   */
>  struct module *__module_text_address(unsigned long addr)
> @@ -3187,11 +3185,11 @@ void print_modules(void)
>  	char buf[8];
> 
>  	printk(KERN_DEFAULT "Modules linked in:");
> -	/* Most callers should already have preempt disabled, but make sure */
> -	preempt_disable();
> +	/* Most callers should already have rcu read lock but make sure */
> +	rcu_read_lock();
>  	list_for_each_entry_rcu(mod, &modules, list)
>  		printk(" %s%s", mod->name, module_flags(mod, buf));
> -	preempt_enable();
> +	rcu_read_unlock();
>  	if (last_unloaded_module[0])
>  		printk(" [last unloaded: %s]", last_unloaded_module);
>  	printk("\n");
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

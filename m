Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab0IWTAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 15:00:46 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:59678 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754699Ab0IWTAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 15:00:44 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAFY8m0xGGN6i/2dsb2JhbACiM3LIEoVCBA
Date: Thu, 23 Sep 2010 14:55:40 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Jason Baron <jbaron@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH 03/11] jump label: Base patch for jump label
Message-ID: <20100923185540.GA30262@Krystal>
References: <20100923034910.867858597@goodmis.org> <20100923035608.228041459@goodmis.org> <20100923143758.GA4022@Krystal> <20100923153902.GD2825@redhat.com> <20100923154852.GA12648@Krystal> <20100923184006.GE2825@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20100923184006.GE2825@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 14:48:07 up 169 days,  4:38,  3 users,  load average: 0.42, 0.30,
	0.25
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jason Baron (jbaron@redhat.com) wrote:
> On Thu, Sep 23, 2010 at 11:48:52AM -0400, Mathieu Desnoyers wrote:
> > * Jason Baron (jbaron@redhat.com) wrote:
> > > On Thu, Sep 23, 2010 at 10:37:58AM -0400, Mathieu Desnoyers wrote:
> > > > * Steven Rostedt (rostedt@goodmis.org) wrote:
> > > > > From: Jason Baron <jbaron@redhat.com>
> > > > > 
> > > > > base patch to implement 'jump labeling'. Based on a new 'asm goto' inline
> > > > > assembly gcc mechanism, we can now branch to labels from an 'asm goto'
> > > > > statment. This allows us to create a 'no-op' fastpath, which can subsequently
> > > > > be patched with a jump to the slowpath code. This is useful for code which
> > > > > might be rarely used, but which we'd like to be able to call, if needed.
> > > > > Tracepoints are the current usecase that these are being implemented for.
> > > > > 
> > > > [...]
> > > > > +/***
> > > > > + * jump_label_update - update jump label text
> > > > > + * @key -  key value associated with a a jump label
> > > > > + * @type - enum set to JUMP_LABEL_ENABLE or JUMP_LABEL_DISABLE
> > > > > + *
> > > > > + * Will enable/disable the jump for jump label @key, depending on the
> > > > > + * value of @type.
> > > > > + *
> > > > > + */
> > > > > +
> > > > > +void jump_label_update(unsigned long key, enum jump_label_type type)
> > > > > +{
> > > > > +	struct jump_entry *iter;
> > > > > +	struct jump_label_entry *entry;
> > > > > +	struct hlist_node *module_node;
> > > > > +	struct jump_label_module_entry *e_module;
> > > > > +	int count;
> > > > > +
> > > > > +	mutex_lock(&jump_label_mutex);
> > > > > +	entry = get_jump_label_entry((jump_label_t)key);
> > > > > +	if (entry) {
> > > > > +		count = entry->nr_entries;
> > > > > +		iter = entry->table;
> > > > > +		while (count--) {
> > > > > +			if (kernel_text_address(iter->code))
> > > > 
> > > > As I pointed out in another thread, I'm concerned about the use of
> > > > kernel_text_address without module mutex here. kernel_text_address calls
> > > > is_module_text_address(), which calls __module_text_address() with
> > > > preemption off.
> > > > 
> > > > __module_text_address() looks like:
> > > > 
> > > > struct module *__module_address(unsigned long addr)
> > > > {
> > > >         struct module *mod;
> > > > 
> > > >         if (addr < module_addr_min || addr > module_addr_max)
> > > >                 return NULL;
> > > > 
> > > >         list_for_each_entry_rcu(mod, &modules, list)
> > > >                 if (within_module_core(addr, mod)
> > > >                     || within_module_init(addr, mod))
> > > >                         return mod;
> > > >         return NULL;
> > > > }
> > > > 
> > > > struct module *__module_text_address(unsigned long addr)
> > > > {
> > > >         struct module *mod = __module_address(addr);
> > > >         if (mod) {
> > > >                 /* Make sure it's within the text section. */
> > > >                 if (!within(addr, mod->module_init, mod->init_text_size)
> > > >                     && !within(addr, mod->module_core, mod->core_text_size))
> > > >                         mod = NULL;
> > > >         }
> > > >         return mod;
> > > > }
> > > > 
> > > > So the test for the address being in the module core is already
> > > > problematic, since we hold preempt off only within
> > > > is_module_text_address(). The is_module_text_address() caller is then
> > > > free to write to this address even after the module has been unloaded
> > > > and the module unload grace period ended.
> > > > 
> > > > Even worse, such grace period is not waited for at module load time
> > > > within:
> > > > 
> > > > init_module()
> > > >        module_free(mod, mod->module_init);
> > > >        mod->module_init = NULL;
> > > >        mod->init_size = 0;
> > > >        mod->init_text_size = 0;
> > > >   (done with module_mutex held, while the module is already in the
> > > >    module list)
> > > > 
> > > > We'd probably have to hold the module mutex around the
> > > > is_module_text_address() call and address use (which can be a pain), or
> > > > to correctly address this part of init_module() with RCU and require
> > > > that preempt off is held across both __module_text_address() call site
> > > > and the actual use of that pointer (which does not fit with jump label,
> > > > which need to sleep, so we'd have to move module.c to a preemptable
> > > > rcu_read_lock/synchronize_rcu() C.S.).
> > > > 
> > > > Thoughts ?
> > > > 
> > > 
> > > I was thinking about the rcu_read_lock/synchronize_rcu() for this race.
> > > We can hold the rcu_read_lock() across the is_module_text_address()
> > > check in the jump label code, and then we can do in module.c:
> > > 
> > > mod->module_init = NULL;
> > > synchronize_rcu();
> > > module_free(mod, mod->module_init);
> > 
> > Beware that you need to copy the module_init address. Also make sure you
> > audit the "module_free" (per-architecture) to make sure they don't use
> > "mod" in ways you did not foresee.
> > 
> > > .
> > > .
> > > .
> > > 
> > > or we could push the rcu_read_lock() further down into
> > > is_module_address()?
> > 
> > We need to pull rcu_read_lock further _up_. It needs to be held across
> > both is_module_address() and the actual use of the address, otherwise
> > the memory mapping can be removed underneath us.
> > 
> > You can see the rcu read lock as keeping the memory mapping alive for as
> > long as the rcu read lock is held.
> > 
> > We'd also need to add a synchronize_rcu() in module removal.
> > 
> 
> I agree that we this synchronization for the module __init section.
> 
> However, I believe we are ok for module removal case. free_module() is
> called *after* blocking_notifier_call_chain() call. The
> blocking_notifier_call_chain() is going to call back into the jump label
> code, grab the jump_label_mutex and remove the reference to the module that
> is about to freed. Thus, the jump label code can no longer reference it.

Ah, yes, this makes sense.

> 
> So I think the following patch is all that is required here (lightly
> tested).

Some comments below,

> 
> Steve, I'll re-post as a separate patch, if we agree on this fix.
> 
> thanks,
> 
> -Jason
> 
> 
> 
> 
> jump label: fix __init module section race
> 
> Jump label uses is_module_text_address() to ensure that the module
> __init sections are valid before updating them. However, between the
> check for a valid module __init section and the subsequent jump
> label update, the module's __init section could be free out from under
> us.
> 
> We fix this potential race putting the address check *and* the jump
> label update under a rcu_read_lock(), and making sure a grace period
> has completed before we free the __init section.
> 
> Thanks to Mathieu Desnoyers for pointing out this race condition.
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>

You can put my
Reported-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

> ---
>  kernel/jump_label.c |    2 ++
>  kernel/module.c     |    5 ++++-
>  2 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/jump_label.c b/kernel/jump_label.c
> index f82878b..7830bfb 100644
> --- a/kernel/jump_label.c
> +++ b/kernel/jump_label.c
> @@ -160,6 +160,7 @@ void jump_label_update(unsigned long key, enum jump_label_type type)
>  			iter++;
>  		}
>  		/* eanble/disable jump labels in modules */

Separate patch for typo: eanble -> enable would be appropriate.

> +		rcu_read_lock();
>  		hlist_for_each_entry(e_module, module_node, &(entry->modules),
>  							hlist) {
>  			count = e_module->nr_entries;
> @@ -170,6 +171,7 @@ void jump_label_update(unsigned long key, enum jump_label_type type)
>  				iter++;
>  			}
>  		}
> +		rcu_read_unlock();

Please note that the impact of this read lock is that synchronize_rcu()
cannot be called from text_poke anymore (because text_poke is called
within a RCU read-side C.S.). So hopefully Masami did not plan to call
synchronize_rcu() from the upcoming breakpoint-based text_poke.

>  	}
>  	mutex_unlock(&jump_label_mutex);
>  }
> diff --git a/kernel/module.c b/kernel/module.c
> index eba1341..09f7e9e 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2692,6 +2692,7 @@ SYSCALL_DEFINE3(init_module, void __user *, umod,
>  		unsigned long, len, const char __user *, uargs)
>  {
>  	struct module *mod;
> +	void *init_code;
>  	int ret = 0;
>  
>  	/* Must have permission */
> @@ -2749,8 +2750,10 @@ SYSCALL_DEFINE3(init_module, void __user *, umod,
>  	mod->symtab = mod->core_symtab;
>  	mod->strtab = mod->core_strtab;
>  #endif
> -	module_free(mod, mod->module_init);
> +	init_code = mod->module_init;
>  	mod->module_init = NULL;
> +	synchronize_rcu();
> +	module_free(mod, init_code);

I'm a bit concerned about the fact that "mod" is passed as parameter to
module_free(). It does not seem to be used on x86, but have you reviewed
all other architectures ? I would feel more comfortable if we removed
this parameter from module_free() if it is indeed unused everywhere.

Thanks,

Mathieu

>  	mod->init_size = 0;
>  	mod->init_text_size = 0;
>  	mutex_unlock(&module_mutex);
> -- 
> 1.7.1
> 
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com

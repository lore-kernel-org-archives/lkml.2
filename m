Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933105Ab0E0V4I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 17:56:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50109 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932994Ab0E0V4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 17:56:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [Regression] Crash in load_module() while freeing args
Date: Thu, 27 May 2010 23:57:28 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Brandon Philips <brandon@ifup.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
References: <201005252300.07739.rjw@sisk.pl> <201005270056.25748.rjw@sisk.pl> <201005271456.20003.rusty@rustcorp.com.au>
In-Reply-To: <201005271456.20003.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005272357.28141.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 May 2010, Rusty Russell wrote:
> On Thu, 27 May 2010 08:26:25 am Rafael J. Wysocki wrote:
> > On Wednesday 26 May 2010, Rusty Russell wrote:
> > > I suspect that the increased parallelism enabled by this patch uncovered this
> > > bug.  Does this fix it?
> > 
> > Since the commit has been reverted, do you still want me to test this patch?
> > Quite frankly I'd prefer to test a complete replacement for that commit on top
> > of current -git.
> 
> OK, combo meal deal below, against Linus' latest.  I'd really appreciate
> a report, since AFAIK you're the only one hitting it, and only when that
> other (now reverted) patch was applied.

I cannot reproduce the crash with the patch below.

Thanks,
Rafael


> As an side to Brandon: I can see how my patch fixed an explicit request_module
> inside module_init (that's how I tested it).  I can't see how we have a
> problem with an implicit dependency such as bne2x->crc32.  Modules go into
> the live state without retaking the lock.  If you can still reproduce that
> now Linus has reverted, I'm afraid we need to dig deeper...
> 
> Thanks,
> Rusty.
> 
> diff --git a/kernel/module.c b/kernel/module.c
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -563,33 +563,26 @@ int use_module(struct module *a, struct 
>  	struct module_use *use;
>  	int no_warn, err;
>  
> -	if (b == NULL || already_uses(a, b)) return 1;
> +	if (b == NULL || already_uses(a, b))
> +		return 0;
>  
>  	/* If we're interrupted or time out, we fail. */
> -	if (wait_event_interruptible_timeout(
> -		    module_wq, (err = strong_try_module_get(b)) != -EBUSY,
> -		    30 * HZ) <= 0) {
> -		printk("%s: gave up waiting for init of module %s.\n",
> -		       a->name, b->name);
> -		return 0;
> -	}
> -
> -	/* If strong_try_module_get() returned a different error, we fail. */
> +	err = strong_try_module_get(b);
>  	if (err)
> -		return 0;
> +		return err;
>  
>  	DEBUGP("Allocating new usage for %s.\n", a->name);
>  	use = kmalloc(sizeof(*use), GFP_ATOMIC);
>  	if (!use) {
>  		printk("%s: out of memory loading\n", a->name);
>  		module_put(b);
> -		return 0;
> +		return -ENOMEM;
>  	}
>  
>  	use->module_which_uses = a;
>  	list_add(&use->list, &b->modules_which_use_me);
>  	no_warn = sysfs_create_link(b->holders_dir, &a->mkobj.kobj, a->name);
> -	return 1;
> +	return 0;
>  }
>  EXPORT_SYMBOL_GPL(use_module);
>  
> @@ -882,7 +875,7 @@ static inline void module_unload_free(st
>  
>  int use_module(struct module *a, struct module *b)
>  {
> -	return strong_try_module_get(b) == 0;
> +	return strong_try_module_get(b);
>  }
>  EXPORT_SYMBOL_GPL(use_module);
>  
> @@ -1053,17 +1046,39 @@ static const struct kernel_symbol *resol
>  	struct module *owner;
>  	const struct kernel_symbol *sym;
>  	const unsigned long *crc;
> -
> +	DEFINE_WAIT(wait);
> +	int err;
> +	long timeleft = 30 * HZ;
> +
> +again:
>  	sym = find_symbol(name, &owner, &crc,
>  			  !(mod->taints & (1 << TAINT_PROPRIETARY_MODULE)), true);
> -	/* use_module can fail due to OOM,
> -	   or module initialization or unloading */
> -	if (sym) {
> -		if (!check_version(sechdrs, versindex, name, mod, crc, owner)
> -		    || !use_module(mod, owner))
> -			sym = NULL;
> +	if (!sym)
> +		return NULL;
> +
> +	if (!check_version(sechdrs, versindex, name, mod, crc, owner))
> +		return NULL;
> +
> +	prepare_to_wait(&module_wq, &wait, TASK_INTERRUPTIBLE);
> +	err = use_module(mod, owner);
> +	if (likely(!err) || err != -EBUSY || signal_pending(current)) {
> +		finish_wait(&module_wq, &wait);
> +		return err ? NULL : sym;
>  	}
> -	return sym;
> +
> +	/* Module is still loading.  Drop lock and wait. */
> +	mutex_unlock(&module_mutex);
> +	timeleft = schedule_timeout(timeleft);
> +	mutex_lock(&module_mutex);
> +	finish_wait(&module_wq, &wait);
> +
> +	/* Module might be gone entirely, or replaced.  Re-lookup. */
> +	if (timeleft)
> +		goto again;
> +
> +	printk(KERN_WARNING "%s: gave up waiting for init of module %s.\n",
> +	       mod->name, owner->name);
> +	return NULL;
>  }
>  
>  /*
> @@ -2014,6 +2029,7 @@ static noinline struct module *load_modu
>  	long err = 0;
>  	void *ptr = NULL; /* Stops spurious gcc warning */
>  	unsigned long symoffs, stroffs, *strmap;
> +	void __percpu *percpu;
>  
>  	mm_segment_t old_fs;
>  
> @@ -2158,6 +2174,8 @@ static noinline struct module *load_modu
>  			goto free_mod;
>  		sechdrs[pcpuindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
>  	}
> +	/* Keep this around for failure path. */
> +	percpu = mod_percpu(mod);
>  
>  	/* Determine total sizes, and put offsets in sh_entsize.  For now
>  	   this is done generically; there doesn't appear to be any
> @@ -2463,7 +2481,7 @@ static noinline struct module *load_modu
>  	module_free(mod, mod->module_core);
>  	/* mod will be freed with core. Don't access it beyond this line! */
>   free_percpu:
> -	percpu_modfree(mod);
> +	free_percpu(percpu);
>   free_mod:
>  	kfree(args);
>  	kfree(strmap);
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074Ab1BUNSW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 08:18:22 -0500
Received: from www.tglx.de ([62.245.132.106]:49838 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755910Ab1BUNSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 08:18:22 -0500
Date: Mon, 21 Feb 2011 14:18:04 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stanislaw Gruszka <sgruszka@redhat.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] debugobjects: print more data
In-Reply-To: <20110221112440.GA5140@redhat.com>
Message-ID: <alpine.LFD.2.00.1102211409480.2701@localhost6.localdomain6>
References: <20110221112440.GA5140@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Feb 2011, Stanislaw Gruszka wrote:
> diff --git a/include/linux/debugobjects.h b/include/linux/debugobjects.h
> index 597692f..c22eebf 100644
> --- a/include/linux/debugobjects.h
> +++ b/include/linux/debugobjects.h
> @@ -31,10 +31,11 @@ struct debug_obj {
>  	void			*object;
>  	struct debug_obj_descr	*descr;
>  };
> -

Stray whitespace change

>  /**
>   * struct debug_obj_descr - object type specific debug description structure
> + *
>   * @name:		name of the object typee
> + * @print:		function printing extra debug data
>   * @fixup_init:		fixup function, which is called when the init check
>   *			fails
>   * @fixup_activate:	fixup function, which is called when the activate check
> @@ -46,7 +47,7 @@ struct debug_obj {
>   */
>  struct debug_obj_descr {
>  	const char		*name;
> -
> +	void (*print)		(struct debug_obj *obj);
>  	int (*fixup_init)	(void *addr, enum debug_obj_state state);
>  	int (*fixup_activate)	(void *addr, enum debug_obj_state state);
>  	int (*fixup_destroy)	(void *addr, enum debug_obj_state state);
> @@ -73,6 +74,8 @@ debug_object_active_state(void *addr, struct debug_obj_descr *descr,
>  
>  extern void debug_objects_early_init(void);
>  extern void debug_objects_mem_init(void);
> +
> +extern char *debug_func_str(void *func_addr);

Uuurgh.

> +void hrtimer_debug_print(struct debug_obj *obj)
> +{
> +	struct hrtimer *hrtimer = obj->object;
> +
> +	if (hrtimer == NULL)
> +		return;

Why should obj->object be NULL. Also why not having the same calling
convention as all other functions (void *addr) ?

> +
> +	printk(KERN_ERR "ODEBUG hrtimer: %p function: [<%p>] %s\n",
> +	       hrtimer, hrtimer->function, debug_func_str(hrtimer->function));

Why do you want to invent a new function for printing the symbol? %ps perhaps?

> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 2b97418..1e901b0 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -276,6 +276,7 @@ config TIMER_STATS
>  config DEBUG_OBJECTS
>  	bool "Debug object operations"
>  	depends on DEBUG_KERNEL
> +	select KALLSYMS

No, we don't want to have DEBUG_OBJECTS tied to KALLSYMS.

> +char *debug_func_str(void *func_addr)
> +{
> +	static char func_str[KSYM_SYMBOL_LEN];
> +	sprint_symbol(func_str, (unsigned long) func_addr);
> +	
> +	return func_str;
> +}

See above.

Thanks,

	tglx

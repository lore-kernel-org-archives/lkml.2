Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab1LAOsy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 09:48:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:53771 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588Ab1LAOsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 09:48:53 -0500
X-Authority-Analysis: v=2.0 cv=dOUkaZlb c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=5UQAro16S0QA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=omOdbC7AAAAA:8 a=Aw3Vt4b4KHGWRB3R9_YA:9 a=3QpCQ5cWROKUWY-IG0kA:7 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH] jump_label: jump_label for boot options.
From: Steven Rostedt <rostedt@goodmis.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>
In-Reply-To: <20111201115353.563f79fc.kamezawa.hiroyu@jp.fujitsu.com>
References: <20111201115353.563f79fc.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Dec 2011 09:48:47 -0500
Message-ID: <1322750927.30977.25.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-01 at 11:53 +0900, KAMEZAWA Hiroyuki wrote:
> I tried to use jump_label for handling memcg's boot options which sets
> global variable true/false and never changes after boot. And found jump_table
> is larger than expected. This patch is a trial to allow to place jump_table
> in .init section. How do you think ?
> 
> This patch is based on linux-next.
> 
> ==
> >From ed8996892c21d4fec642e4fc80bd3ebdd8a48836 Mon Sep 17 00:00:00 2001
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Date: Thu, 1 Dec 2011 11:08:23 +0900
> Subject: [PATCH] jump_label for boot options.
> 
> Some boot options exists for enable/disable a functionality which cannot be modified
> after boot. Using jump_label for such behavior seems atractive but if caller
> of statch_branch() is too much, jump_table can be unexpectedly big.

s/statch/static/

> 
> This patch adds static_branch_init_once(), which places its jump_table
> in init section and never be updated after boot.

I don't like the name static_branch_init_once(). Although I suck at
picking names myself :-p  Maybe just remove the 'init'.
static_branch_once(), or remove the 'once'. static_branch_init()

Your name may be the best, but I'm hoping another name will come up.
static_branch_init_once() just doesn't seem right.


> For MODULES, using usual static_branch().

Why not for modules? It can be forced at module load time, and then
removed.


I also wonder if this could be used for other things not just init.
Maybe at boot up you can determine what hardware is being used, and then
decided which path to take. Things that depend on cpuid and such might
be able to do such a thing.


> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  arch/mips/include/asm/jump_label.h    |   14 ++++++++++
>  arch/powerpc/include/asm/jump_label.h |   15 +++++++++++
>  arch/x86/include/asm/jump_label.h     |   15 +++++++++++
>  include/asm-generic/vmlinux.lds.h     |    6 ++++
>  include/linux/jump_label.h            |   39 +++++++++++++++++++++++++++++
>  kernel/jump_label.c                   |   43 ++++++++++++++++++++++++++------
>  6 files changed, 124 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/mips/include/asm/jump_label.h b/arch/mips/include/asm/jump_label.h
> index 1881b31..dd0b8f0 100644
> --- a/arch/mips/include/asm/jump_label.h
> +++ b/arch/mips/include/asm/jump_label.h
> @@ -33,6 +33,20 @@ l_yes:
>  	return true;
>  }
>  
> +static __always_inline bool
> +arch_static_branch_init_once(struct jump_lable_key *key)
> +{
> +	asm goto("1:\tnop\n\t"
> +		"nop\n\t"
> +		".pushsection __jump_table.init, \"aw\"\n\t"
> +		WORD_INSN " 1b, %l[l_yes], %0\n\t"
> +		".popsection\n\t"
> +		: : "i" (key) : : l_yes);
> +	return false;
> +l_yes:
> +	return true;
> +}
> +
>  #endif /* __KERNEL__ */
>  
>  #ifdef CONFIG_64BIT
> diff --git a/arch/powerpc/include/asm/jump_label.h b/arch/powerpc/include/asm/jump_label.h
> index 938986e..8557f8a 100644
> --- a/arch/powerpc/include/asm/jump_label.h
> +++ b/arch/powerpc/include/asm/jump_label.h
> @@ -30,6 +30,21 @@ l_yes:
>  	return true;
>  }
>  
> +static __always_inline bool
> +arch_static_branch_init_once(struct jump_label_key *key)
> +{
> +	asm goto("1:\n\t"
> +		 "nop\n\t"
> +		 ".pushsection __jump_table.init,  \"aw\"\n\t"
> +		 JUMP_ENTRY_TYPE "1b, %l[l_yes], %c0\n\t"
> +		 ".popsection \n\t"
> +		 : :  "i" (key) : : l_yes);
> +	return false;
> +l_yes:
> +	return true;
> +}
> +
> +
>  #ifdef CONFIG_PPC64
>  typedef u64 jump_label_t;
>  #else
> diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
> index a32b18c..a85ad63 100644
> --- a/arch/x86/include/asm/jump_label.h
> +++ b/arch/x86/include/asm/jump_label.h
> @@ -25,6 +25,21 @@ l_yes:
>  	return true;
>  }
>  
> +static __always_inline
> +bool arch_static_branch_init_once(struct jump_label_key *key)
> +{
> +	asm goto("1:"
> +		JUMP_LABEL_INITIAL_NOP
> +		".pushsection __jump_table.init, \"aw\" \n\t"
> +		_ASM_ALIGN "\n\t"
> +		_ASM_PTR "1b, %l[l_yes], %c0 \n\t"
> +		".popsection \n\t"
> +		: : "i" (key) : : l_yes);
> +	return false;
> +l_yes:
> +	return true;
> +}
> +
>  #endif /* __KERNEL__ */
>  
>  #ifdef CONFIG_X86_64
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index b5e2e4c..1635f38 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -651,6 +651,11 @@
>  		*(.security_initcall.init)				\
>  		VMLINUX_SYMBOL(__security_initcall_end) = .;
>  
> +#define JUMP_LABEL_FOR_INIT						\
> +		VMLINUX_SYMBOL(__start___jump_table_at_init) = .;	\
> +		*(__jump_table.init)					\
> +		VMLINUX_SYMBOL(__stop___jump_table_at_init) = .;
> +
>  #ifdef CONFIG_BLK_DEV_INITRD
>  #define INIT_RAM_FS							\
>  	. = ALIGN(4);							\
> @@ -799,6 +804,7 @@
>  		INIT_CALLS						\
>  		CON_INITCALL						\
>  		SECURITY_INITCALL					\
> +		JUMP_LABEL_FOR_INIT					\
>  		INIT_RAM_FS						\
>  	}
>  
> diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
> index 388b0d4..b0f37f3 100644
> --- a/include/linux/jump_label.h
> +++ b/include/linux/jump_label.h
> @@ -38,8 +38,31 @@ static __always_inline bool static_branch(struct jump_label_key *key)
>  	return arch_static_branch(key);
>  }
>  
> +/*
> + * Use this when you call static_branch() in __init function or
> + * jump_label is only modified by initcalls. jump_label information
> + * will be discarded after boot. But please be careful. jump_label_key
> + * definition itself should *not* be in __init section because a MODULE
> + * may call static_branch_init_once().
> + *
> + * Useful for changing behavior by boot option.
> + */
> +#ifndef MODULE
> +static __always_inline bool static_branch_init_once(struct jump_label_key *key)
> +{
> +	return arch_static_branch_init_once(key);
> +}
> +#else
> +static __always_inline bool static_branch_init_once(struct jump_label_key *key)
> +{
> +	return static_branch(key);
> +}
> +#endif

I still think modules should be able to do this, and then just remove it
later.

> +
>  extern struct jump_entry __start___jump_table[];
>  extern struct jump_entry __stop___jump_table[];
> +extern struct jump_entry __start___jump_table_at_init[];
> +extern struct jump_entry __stop___jump_table_at_init[];
>  
>  extern void jump_label_init(void);
>  extern void jump_label_lock(void);
> @@ -54,6 +77,12 @@ extern void jump_label_dec(struct jump_label_key *key);
>  extern bool jump_label_enabled(struct jump_label_key *key);
>  extern void jump_label_apply_nops(struct module *mod);
>  
> +/*
> + * For jump_label in init section.
> + * This will call jump_label_inc() for usual section, too.
> + */
> +extern void jump_label_inc_once(struct jump_label_key *key);
> +
>  #else  /* !HAVE_JUMP_LABEL */
>  
>  #include <linux/atomic.h>
> @@ -75,6 +104,11 @@ static __always_inline bool static_branch(struct jump_label_key *key)
>  	return false;
>  }
>  
> +static __always_inline bool static_branch_init_once(struct jump_label_key *key)
> +{
> +	return static_branch(key);
> +}
> +
>  static inline void jump_label_inc(struct jump_label_key *key)
>  {
>  	atomic_inc(&key->enabled);
> @@ -102,6 +136,11 @@ static inline int jump_label_apply_nops(struct module *mod)
>  {
>  	return 0;
>  }
> +
> +static inline void jump_label_inc_once(struct jump_label_key *key)
> +{
> +	jump_label_inc(key);
> +}
>  #endif	/* HAVE_JUMP_LABEL */
>  
>  #endif	/* _LINUX_JUMP_LABEL_H */
> diff --git a/kernel/jump_label.c b/kernel/jump_label.c
> index 66ff710..f0e8231 100644
> --- a/kernel/jump_label.c
> +++ b/kernel/jump_label.c
> @@ -134,15 +134,11 @@ static void __jump_label_update(struct jump_label_key *key,
>  	}
>  }
>  
> -void __init jump_label_init(void)
> +void __init jump_label_transform_all(struct jump_entry *iter_start,
> +				     struct jump_entry *iter_stop)
>  {
> -	struct jump_entry *iter_start = __start___jump_table;
> -	struct jump_entry *iter_stop = __stop___jump_table;
> -	struct jump_label_key *key = NULL;
>  	struct jump_entry *iter;
> -
> -	jump_label_lock();
> -	jump_label_sort_entries(iter_start, iter_stop);
> +	struct jump_label_key *key = NULL;
>  
>  	for (iter = iter_start; iter < iter_stop; iter++) {
>  		struct jump_label_key *iterk;
> @@ -159,6 +155,24 @@ void __init jump_label_init(void)
>  		key->next = NULL;
>  #endif
>  	}
> +
> +}
> +
> +
> +void __init jump_label_init(void)
> +{
> +	struct jump_entry *iter_start = __start___jump_table;
> +	struct jump_entry *iter_stop = __stop___jump_table;
> +
> +
> +	jump_label_lock();
> +	jump_label_sort_entries(iter_start, iter_stop);
> +	jump_label_transform_all(iter_start, iter_stop);

Nit, I'd add a space here.

-- Steve

> +	/* update jump_table in .init section */
> +	iter_start = __start___jump_table_at_init;
> +	iter_stop = __stop___jump_table_at_init;
> +	jump_label_sort_entries(iter_start, iter_stop);
> +	jump_label_transform_all(iter_start, iter_stop);
>  	jump_label_unlock();
>  }
>  
> @@ -381,7 +395,8 @@ int jump_label_text_reserved(void *start, void *end)
>  
>  static void jump_label_update(struct jump_label_key *key, int enable)
>  {
> -	struct jump_entry *entry = key->entries, *stop = __stop___jump_table;
> +	struct jump_entry *entry = key->entries;
> +	struct jump_entry *stop = __stop___jump_table;
>  
>  #ifdef CONFIG_MODULES
>  	struct module *mod = __module_address((jump_label_t)key);
> @@ -396,4 +411,16 @@ static void jump_label_update(struct jump_label_key *key, int enable)
>  		__jump_label_update(key, entry, stop, enable);
>  }
>  
> +/* for boot options */
> +void __init jump_label_init_once(struct jump_label_key *key)
> +{
> +	struct jump_entry *entry = key->entries;
> +	struct jump_entry *stop = __stop___jump_table_at_init;
> +
> +	if (entry)
> +		__jump_label_update(key, entry, stop, JUMP_LABEL_ENABLE);
> +
> +	jump_label_inc(key);
> +}
> +
>  #endif



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab1CNTqa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 15:46:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:26021 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753961Ab1CNTq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 15:46:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,317,1297065600"; 
   d="scan'208";a="897165612"
From: Andi Kleen <andi@firstfloor.org>
To: Cliff Frey <cliff@meraki.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] profile: add support for modules and make output human readable
References: <1299910632-9970-1-git-send-email-cliff@meraki.com>
Date: Mon, 14 Mar 2011 12:45:25 -0700
In-Reply-To: <1299910632-9970-1-git-send-email-cliff@meraki.com> (Cliff Frey's
	message of "Fri, 11 Mar 2011 22:17:12 -0800")
Message-ID: <m2oc5dzdt6.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cliff Frey <cliff@meraki.com> writes:

> This changes /proc/profile to include kernel modules and also print out data in
> human readable form (it does symbol lookups of all kernel addresses).  It also
> adds /proc/profile_m which gives a high level summary of samples in
> userspace/kernel/each module.

I like the idea of extending this profiler to modules.

But the symbol lookup will make existing readprofile much slower than it
used to be.  Please make it a new file.

In general it seems to still need quite a lot of work though:

>  - Make this a separate kernel config option.

This means it'll be off when you need it. The cool thing about
it was always that it was always there.

>  #endif
> -
> +#ifdef CONFIG_PROFILING
> +	{
> +		extern unsigned prof_shift;

This should be in a header.

>  	return 1;
> @@ -105,6 +116,11 @@ __setup("profile=", profile_setup);
>  int __ref profile_init(void)
>  {
>  	int buffer_bytes;
> +
> +	// XXX turn on profiling
> +	prof_shift = 4;
> +	prof_on = CPU_PROFILING;

Was this supposed to be a submission ready patch?

> +
>  	if (!prof_on)
>  		return 0;
>  
> @@ -225,8 +241,13 @@ void unregister_timer_hook(int (*hook)(struct pt_regs *))
>  }
>  EXPORT_SYMBOL_GPL(unregister_timer_hook);
>  
> +static inline int within(unsigned long addr, void *start, unsigned long size)
> +{
> +	return ((void *)addr >= start && (void *)addr < start + size);
> +}
>  

I'm pretty sure we already have that in kernel.h

>  #ifdef CONFIG_SMP
> +#error "Meraki has not added SMP profiling support yet"

Ok that explains the missing locking. Obviously that's not usable
for a lot of people.

>  /*
>   * Each cpu has a pair of open-addressed hashtables for pending
>   * profile hits. read_profile() IPI's all cpus to request them
> @@ -420,23 +441,53 @@ out_free:
>  void profile_hits(int type, void *__pc, unsigned int nr_hits)
>  {
>  	unsigned long pc;
> +	unsigned long pc_kernel_offset;
> +	struct module *mod = NULL;
>  
> +	pc = (unsigned long) __pc;
>  	if (prof_on != type || !prof_buffer)
>  		return;
> -	pc = ((unsigned long)__pc - (unsigned long)_stext) >> prof_shift;
> -	atomic_add(nr_hits, &prof_buffer[min(pc, prof_len - 1)]);
> +	pc_kernel_offset = (pc - (unsigned long)_stext) >> prof_shift;
> +	if (pc_kernel_offset < prof_len) {
> +		atomic_add(nr_hits, &prof_buffer[pc_kernel_offset]);
> +		atomic_add(nr_hits, &known_kernel_hits);
> +		return;
> +	}
> +
> +	list_for_each_entry(mod, &modules, list)

You cannot just walk this list without any protection. Modules
can be unloaded any time. Or maybe make it depend 
on the !MODULE_UNLOAD

> +				if (lastcount > 5)
> +					seq_printf(m, "%08lx % 6d %s\n",
> lastpc, lastcount, lastname);

Weird magic number


-Andi
-- 
ak@linux.intel.com -- Speaking for myself only

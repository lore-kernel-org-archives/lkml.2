Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384Ab1JCPDH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 11:03:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756260Ab1JCPC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 11:02:58 -0400
Date: Mon, 3 Oct 2011 11:02:06 -0400
From: Jason Baron <jbaron@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        peterz@infradead.org
Subject: Re: [PATCH RFC V2 3/5] jump_label: if a key has already been
 initialized, don't nop it out
Message-ID: <20111003150205.GB2462@redhat.com>
References: <cover.1317506051.git.jeremy.fitzhardinge@citrix.com>
 <477dead9647029012f93c651f2892ed0e86b89e7.1317506051.git.jeremy.fitzhardinge@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <477dead9647029012f93c651f2892ed0e86b89e7.1317506051.git.jeremy.fitzhardinge@citrix.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(Sorry for the late reply - I was away for a few days).

The early enable is really nice - it means there are not restrictions on
when jump_label_inc()/dec() can be called which is nice.

comments below.


On Sat, Oct 01, 2011 at 02:55:35PM -0700, Jeremy Fitzhardinge wrote:
> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> If a key has been enabled before jump_label_init() is called, don't
> nop it out.
> 
> This removes arch_jump_label_text_poke_early() (which can only nop
> out a site) and uses arch_jump_label_transform() instead.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
>  include/linux/jump_label.h |    3 ++-
>  kernel/jump_label.c        |   20 ++++++++------------
>  2 files changed, 10 insertions(+), 13 deletions(-)
> 
> diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
> index 1213e9d..c8fb1b3 100644
> --- a/include/linux/jump_label.h
> +++ b/include/linux/jump_label.h
> @@ -45,7 +45,8 @@ extern void jump_label_lock(void);
>  extern void jump_label_unlock(void);
>  extern void arch_jump_label_transform(struct jump_entry *entry,
>  				 enum jump_label_type type);
> -extern void arch_jump_label_text_poke_early(jump_label_t addr);
> +extern void arch_jump_label_transform_early(struct jump_entry *entry,
> +				 enum jump_label_type type);
>  extern int jump_label_text_reserved(void *start, void *end);
>  extern void jump_label_inc(struct jump_label_key *key);
>  extern void jump_label_dec(struct jump_label_key *key);
> diff --git a/kernel/jump_label.c b/kernel/jump_label.c
> index a8ce450..059202d5 100644
> --- a/kernel/jump_label.c
> +++ b/kernel/jump_label.c
> @@ -121,13 +121,6 @@ static void __jump_label_update(struct jump_label_key *key,
>  	}
>  }
>  
> -/*
> - * Not all archs need this.
> - */
> -void __weak arch_jump_label_text_poke_early(jump_label_t addr)
> -{
> -}
> -
>  static __init int jump_label_init(void)
>  {
>  	struct jump_entry *iter_start = __start___jump_table;
> @@ -139,12 +132,15 @@ static __init int jump_label_init(void)
>  	jump_label_sort_entries(iter_start, iter_stop);
>  
>  	for (iter = iter_start; iter < iter_stop; iter++) {
> -		arch_jump_label_text_poke_early(iter->code);
> -		if (iter->key == (jump_label_t)(unsigned long)key)
> +		struct jump_label_key *iterk;
> +
> +		iterk = (struct jump_label_key *)(unsigned long)iter->key;
> +		arch_jump_label_transform(iter, jump_label_enabled(iterk) ?
> +					  JUMP_LABEL_ENABLE : JUMP_LABEL_DISABLE);

The only reason I called this at boot-time was that the 'ideal' x86
no-op isn't known until boot time. Thus, in the enabled case we could
skip the the arch_jump_label_transform() call. ie:

if (!enabled)
	arch_jump_label_transform(iter, JUMP_LABEL_DISABLE);


> +		if (iterk == key)
>  			continue;
>  
> -		key = (struct jump_label_key *)(unsigned long)iter->key;
> -		atomic_set(&key->enabled, 0);
> +		key = iterk;
>  		key->entries = iter;
>  #ifdef CONFIG_MODULES
>  		key->next = NULL;
> @@ -212,7 +208,7 @@ void jump_label_apply_nops(struct module *mod)
>  		return;
>  
>  	for (iter = iter_start; iter < iter_stop; iter++)
> -		arch_jump_label_text_poke_early(iter->code);
> +		arch_jump_label_transform(iter, JUMP_LABEL_DISABLE);
>  }
>  
>  static int jump_label_add_module(struct module *mod)
> -- 
> 1.7.6.2
> 

hmmm...this is used on module load in smp - so this would introduce a number of
calls to stop_machine() where we didn't have them before. Yes, module
load is a very slow path to begin with, but I think its at least worth
pointing out...

thanks,

-Jason

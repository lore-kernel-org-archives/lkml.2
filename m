Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536Ab0JBJAu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 05:00:50 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:59992 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab0JBJAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 05:00:48 -0400
X-AuditID: b753bd60-a7533ba000000226-23-4ca6f4bc5c5e
Message-ID: <4CA6F4B2.4060804@hitachi.com>
Date: Sat, 02 Oct 2010 18:00:34 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
Cc: rostedt@goodmis.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
        hpa@zytor.com, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org,
        tony@bakeyournoodle.com, ddaney@caviumnetworks.com,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH 2/5] jump label: Fix deadlock b/w jump_label_mutex vs.
 text_mutex
References: <cover.1285965957.git.jbaron@redhat.com> <759032c48d5e30c27f0bba003d09bffa8e9f28bb.1285965957.git.jbaron@redhat.com>
In-Reply-To: <759032c48d5e30c27f0bba003d09bffa8e9f28bb.1285965957.git.jbaron@redhat.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/10/02 6:23), Jason Baron wrote:
> register_kprobe() downs the 'text_mutex' and then calls
> jump_label_text_reserved(), which downs the 'jump_label_mutex'.
> However, the jump label code takes those mutexes in the reverse
> order.
> 
> Fix by requiring the caller of jump_label_text_reserved() to do
> the jump label locking via the newly added: jump_label_lock(),
> jump_label_unlock(). Currently, kprobes is the only user
> of jump_label_text_reserved().
> 

Looks good for me;)

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Thank you,

> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> Reported-by: Ingo Molnar <mingo@elte.hu>
> ---
>  include/linux/jump_label.h |    5 +++++
>  kernel/jump_label.c        |   33 +++++++++++++++++++++------------
>  kernel/kprobes.c           |    6 ++++++
>  3 files changed, 32 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
> index b72cd9f..cf213d1 100644
> --- a/include/linux/jump_label.h
> +++ b/include/linux/jump_label.h
> @@ -18,6 +18,8 @@ struct module;
>  extern struct jump_entry __start___jump_table[];
>  extern struct jump_entry __stop___jump_table[];
>  
> +extern void jump_label_lock(void);
> +extern void jump_label_unlock(void);
>  extern void arch_jump_label_transform(struct jump_entry *entry,
>  				 enum jump_label_type type);
>  extern void arch_jump_label_text_poke_early(jump_label_t addr);
> @@ -59,6 +61,9 @@ static inline int jump_label_text_reserved(void *start, void *end)
>  	return 0;
>  }
>  
> +static inline void jump_label_lock(void) {}
> +static inline void jump_label_unlock(void) {}
> +
>  #endif
>  
>  #endif
> diff --git a/kernel/jump_label.c b/kernel/jump_label.c
> index e2fad92..2add1a7 100644
> --- a/kernel/jump_label.c
> +++ b/kernel/jump_label.c
> @@ -39,6 +39,16 @@ struct jump_label_module_entry {
>  	struct module *mod;
>  };
>  
> +void jump_label_lock(void)
> +{
> +	mutex_lock(&jump_label_mutex);
> +}
> +
> +void jump_label_unlock(void)
> +{
> +	mutex_unlock(&jump_label_mutex);
> +}
> +
>  static int jump_label_cmp(const void *a, const void *b)
>  {
>  	const struct jump_entry *jea = a;
> @@ -152,7 +162,7 @@ void jump_label_update(unsigned long key, enum jump_label_type type)
>  	struct jump_label_module_entry *e_module;
>  	int count;
>  
> -	mutex_lock(&jump_label_mutex);
> +	jump_label_lock();
>  	entry = get_jump_label_entry((jump_label_t)key);
>  	if (entry) {
>  		count = entry->nr_entries;
> @@ -175,7 +185,7 @@ void jump_label_update(unsigned long key, enum jump_label_type type)
>  			}
>  		}
>  	}
> -	mutex_unlock(&jump_label_mutex);
> +	jump_label_unlock();
>  }
>  
>  static int addr_conflict(struct jump_entry *entry, void *start, void *end)
> @@ -232,6 +242,7 @@ out:
>   * overlaps with any of the jump label patch addresses. Code
>   * that wants to modify kernel text should first verify that
>   * it does not overlap with any of the jump label addresses.
> + * Caller must hold jump_label_mutex.
>   *
>   * returns 1 if there is an overlap, 0 otherwise
>   */
> @@ -242,7 +253,6 @@ int jump_label_text_reserved(void *start, void *end)
>  	struct jump_entry *iter_stop = __start___jump_table;
>  	int conflict = 0;
>  
> -	mutex_lock(&jump_label_mutex);
>  	iter = iter_start;
>  	while (iter < iter_stop) {
>  		if (addr_conflict(iter, start, end)) {
> @@ -257,7 +267,6 @@ int jump_label_text_reserved(void *start, void *end)
>  	conflict = module_conflict(start, end);
>  #endif
>  out:
> -	mutex_unlock(&jump_label_mutex);
>  	return conflict;
>  }
>  
> @@ -268,7 +277,7 @@ static __init int init_jump_label(void)
>  	struct jump_entry *iter_stop = __stop___jump_table;
>  	struct jump_entry *iter;
>  
> -	mutex_lock(&jump_label_mutex);
> +	jump_label_lock();
>  	ret = build_jump_label_hashtable(__start___jump_table,
>  					 __stop___jump_table);
>  	iter = iter_start;
> @@ -276,7 +285,7 @@ static __init int init_jump_label(void)
>  		arch_jump_label_text_poke_early(iter->code);
>  		iter++;
>  	}
> -	mutex_unlock(&jump_label_mutex);
> +	jump_label_unlock();
>  	return ret;
>  }
>  early_initcall(init_jump_label);
> @@ -409,21 +418,21 @@ jump_label_module_notify(struct notifier_block *self, unsigned long val,
>  
>  	switch (val) {
>  	case MODULE_STATE_COMING:
> -		mutex_lock(&jump_label_mutex);
> +		jump_label_lock();
>  		ret = add_jump_label_module(mod);
>  		if (ret)
>  			remove_jump_label_module(mod);
> -		mutex_unlock(&jump_label_mutex);
> +		jump_label_unlock();
>  		break;
>  	case MODULE_STATE_GOING:
> -		mutex_lock(&jump_label_mutex);
> +		jump_label_lock();
>  		remove_jump_label_module(mod);
> -		mutex_unlock(&jump_label_mutex);
> +		jump_label_unlock();
>  		break;
>  	case MODULE_STATE_LIVE:
> -		mutex_lock(&jump_label_mutex);
> +		jump_label_lock();
>  		remove_module_init(mod);
> -		mutex_unlock(&jump_label_mutex);
> +		jump_label_unlock();
>  		break;
>  	}
>  	return ret;
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index ec4210c..d45d72e 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -1145,13 +1145,16 @@ int __kprobes register_kprobe(struct kprobe *p)
>  		return ret;
>  
>  	preempt_disable();
> +	jump_label_lock();
>  	if (!kernel_text_address((unsigned long) p->addr) ||
>  	    in_kprobes_functions((unsigned long) p->addr) ||
>  	    ftrace_text_reserved(p->addr, p->addr) ||
>  	    jump_label_text_reserved(p->addr, p->addr)) {
>  		preempt_enable();
> +		jump_label_unlock();
>  		return -EINVAL;
>  	}
> +	jump_label_unlock();
>  
>  	/* User can pass only KPROBE_FLAG_DISABLED to register_kprobe */
>  	p->flags &= KPROBE_FLAG_DISABLED;
> @@ -1186,6 +1189,8 @@ int __kprobes register_kprobe(struct kprobe *p)
>  	INIT_LIST_HEAD(&p->list);
>  	mutex_lock(&kprobe_mutex);
>  
> +	jump_label_lock(); /* needed to call jump_label_text_reserved() */
> +
>  	get_online_cpus();	/* For avoiding text_mutex deadlock. */
>  	mutex_lock(&text_mutex);
>  
> @@ -1213,6 +1218,7 @@ int __kprobes register_kprobe(struct kprobe *p)
>  out:
>  	mutex_unlock(&text_mutex);
>  	put_online_cpus();
> +	jump_label_unlock();
>  	mutex_unlock(&kprobe_mutex);
>  
>  	if (probed_mod)


-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com

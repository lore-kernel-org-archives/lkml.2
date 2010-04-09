Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186Ab0DIVKL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 17:10:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755249Ab0DIVKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 17:10:06 -0400
Message-ID: <4BBF978C.8040606@redhat.com>
Date: Fri, 09 Apr 2010 17:09:32 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
       hpa@zytor.com, tglx@linutronix.de, rostedt@goodmis.org,
       andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
       fweisbec@gmail.com, avi@redhat.com
Subject: Re: [PATCH 9/9] jump label: jump_label_text_reserved() to reserve
 our jump points
References: <cover.1270839564.git.jbaron@redhat.com> <ddd6aca6c907d81569a191bae6534bb89ec9abe8.1270839564.git.jbaron@redhat.com>
In-Reply-To: <ddd6aca6c907d81569a191bae6534bb89ec9abe8.1270839564.git.jbaron@redhat.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Baron wrote:
> Add a jump_label_text_reserved(void *start, void *end), so that other
> pieces of code that want to modify kernel text, can first verify that
> jump label has not reserved the instruction.
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

At least kprobes parts. :)

Thank you,

> ---
>  arch/x86/kernel/kprobes.c  |    3 +-
>  include/linux/jump_label.h |    6 +++
>  kernel/jump_label.c        |   83 ++++++++++++++++++++++++++++++++++++++++++++
>  kernel/kprobes.c           |    3 +-
>  4 files changed, 93 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
> index b43bbae..87bcf63 100644
> --- a/arch/x86/kernel/kprobes.c
> +++ b/arch/x86/kernel/kprobes.c
> @@ -1194,7 +1194,8 @@ static int __kprobes copy_optimized_instructions(u8 *dest, u8 *src)
>  	}
>  	/* Check whether the address range is reserved */
>  	if (ftrace_text_reserved(src, src + len - 1) ||
> -	    alternatives_text_reserved(src, src + len - 1))
> +	    alternatives_text_reserved(src, src + len - 1) ||
> +	    jump_label_text_reserved(src, src + len - 1))
>  		return -EBUSY;
>  
>  	return len;
> diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
> index 7238805..90ca4b6 100644
> --- a/include/linux/jump_label.h
> +++ b/include/linux/jump_label.h
> @@ -31,6 +31,7 @@ extern void arch_jump_label_transform(struct jump_entry *entry,
>  				 enum jump_label_type type);
>  
>  extern void jump_label_update(const char *name, enum jump_label_type type);
> +extern int jump_label_text_reserved(void *start, void *end);
>  
>  extern void apply_jump_label_nops(struct module *mod);
>  
> @@ -65,6 +66,11 @@ static inline int apply_jump_label_nops(struct module *mod)
>  	return 0;
>  }
>  
> +static inline int jump_label_text_reserved(void *start, void *end)
> +{
> +	return 0;
> +}
> +
>  #endif
>  
>  #endif
> diff --git a/kernel/jump_label.c b/kernel/jump_label.c
> index 7e7458b..24bba61 100644
> --- a/kernel/jump_label.c
> +++ b/kernel/jump_label.c
> @@ -179,6 +179,89 @@ void jump_label_update(const char *name, enum jump_label_type type)
>  	mutex_unlock(&jump_label_mutex);
>  }
>  
> +static int addr_conflict(struct jump_entry *entry, void *start, void *end)
> +{
> +	if (entry->code <= (unsigned long)end &&
> +		entry->code + IDEAL_NOP_SIZE_5 > (unsigned long)start)
> +		return 1;
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_MODULES
> +
> +static int module_conflict(void *start, void *end)
> +{
> +	struct hlist_head *head;
> +	struct hlist_node *node, *node_next, *module_node, *module_node_next;
> +	struct jump_label_entry *e;
> +	struct jump_label_module_entry *e_module;
> +	struct jump_entry *iter;
> +	int i, count;
> +	int conflict = 0;
> +
> +	for (i = 0; i < JUMP_LABEL_TABLE_SIZE; i++) {
> +		head = &jump_label_table[i];
> +		hlist_for_each_entry_safe(e, node, node_next, head, hlist) {
> +			hlist_for_each_entry_safe(e_module, module_node,
> +							module_node_next,
> +							&(e->modules), hlist) {
> +				count = e_module->nr_entries;
> +				iter = e_module->table;
> +				while (count--) {
> +					if (addr_conflict(iter, start, end)) {
> +						conflict = 1;
> +						goto out;
> +					}
> +					iter++;
> +				}
> +			}
> +		}
> +	}
> +out:
> +	return conflict;
> +}
> +
> +#endif
> +
> +/***
> + * jump_label_text_reserved - check if addr range is reserved
> + * @start: start text addr
> + * @end: end text addr
> + *
> + * checks if the text addr located between @start and @end
> + * overlaps with any of the jump label patch addresses. Code
> + * that wants to modify kernel text should first verify that
> + * it does not overlap with any of the jump label addresses.
> + *
> + * returns 1 if there is an overlap, 0 otherwise
> + */
> +int jump_label_text_reserved(void *start, void *end)
> +{
> +	struct jump_entry *iter;
> +	struct jump_entry *iter_start = __start___jump_table;
> +	struct jump_entry *iter_stop = __start___jump_table;
> +	int conflict = 0;
> +
> +	mutex_lock(&jump_label_mutex);
> +	iter = iter_start;
> +	while (iter < iter_stop) {
> +		if (addr_conflict(iter, start, end)) {
> +			conflict = 1;
> +			goto out;
> +		}
> +		iter++;
> +	}
> +
> +	/* now check modules */
> +#ifdef CONFIG_MODULES
> +	conflict = module_conflict(start, end);
> +#endif
> +out:
> +	mutex_unlock(&jump_label_mutex);
> +	return conflict;
> +}
> +
>  static int init_jump_label(void)
>  {
>  	int ret;
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index fa034d2..a57755f 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -1140,7 +1140,8 @@ int __kprobes register_kprobe(struct kprobe *p)
>  	preempt_disable();
>  	if (!kernel_text_address((unsigned long) p->addr) ||
>  	    in_kprobes_functions((unsigned long) p->addr) ||
> -	    ftrace_text_reserved(p->addr, p->addr)) {
> +	    ftrace_text_reserved(p->addr, p->addr) ||
> +	    jump_label_text_reserved(p->addr, p->addr)) {
>  		preempt_enable();
>  		return -EINVAL;
>  	}

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com

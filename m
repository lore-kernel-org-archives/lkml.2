Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619Ab0IWOiC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 10:38:02 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:54296 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753178Ab0IWOiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 10:38:01 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEADcCm0xGGN6i/2dsb2JhbACiL3LGLoVBBA
Date: Thu, 23 Sep 2010 10:37:58 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Jason Baron <jbaron@redhat.com>,
        David Miller <davem@davemloft.net>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 03/11] jump label: Base patch for jump label
Message-ID: <20100923143758.GA4022@Krystal>
References: <20100923034910.867858597@goodmis.org> <20100923035608.228041459@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20100923035608.228041459@goodmis.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 10:17:15 up 169 days, 8 min,  2 users,  load average: 0.29, 0.19,
	0.14
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> From: Jason Baron <jbaron@redhat.com>
> 
> base patch to implement 'jump labeling'. Based on a new 'asm goto' inline
> assembly gcc mechanism, we can now branch to labels from an 'asm goto'
> statment. This allows us to create a 'no-op' fastpath, which can subsequently
> be patched with a jump to the slowpath code. This is useful for code which
> might be rarely used, but which we'd like to be able to call, if needed.
> Tracepoints are the current usecase that these are being implemented for.
> 
[...]
> +/***
> + * jump_label_update - update jump label text
> + * @key -  key value associated with a a jump label
> + * @type - enum set to JUMP_LABEL_ENABLE or JUMP_LABEL_DISABLE
> + *
> + * Will enable/disable the jump for jump label @key, depending on the
> + * value of @type.
> + *
> + */
> +
> +void jump_label_update(unsigned long key, enum jump_label_type type)
> +{
> +	struct jump_entry *iter;
> +	struct jump_label_entry *entry;
> +	struct hlist_node *module_node;
> +	struct jump_label_module_entry *e_module;
> +	int count;
> +
> +	mutex_lock(&jump_label_mutex);
> +	entry = get_jump_label_entry((jump_label_t)key);
> +	if (entry) {
> +		count = entry->nr_entries;
> +		iter = entry->table;
> +		while (count--) {
> +			if (kernel_text_address(iter->code))

As I pointed out in another thread, I'm concerned about the use of
kernel_text_address without module mutex here. kernel_text_address calls
is_module_text_address(), which calls __module_text_address() with
preemption off.

__module_text_address() looks like:

struct module *__module_address(unsigned long addr)
{
        struct module *mod;

        if (addr < module_addr_min || addr > module_addr_max)
                return NULL;

        list_for_each_entry_rcu(mod, &modules, list)
                if (within_module_core(addr, mod)
                    || within_module_init(addr, mod))
                        return mod;
        return NULL;
}

struct module *__module_text_address(unsigned long addr)
{
        struct module *mod = __module_address(addr);
        if (mod) {
                /* Make sure it's within the text section. */
                if (!within(addr, mod->module_init, mod->init_text_size)
                    && !within(addr, mod->module_core, mod->core_text_size))
                        mod = NULL;
        }
        return mod;
}

So the test for the address being in the module core is already
problematic, since we hold preempt off only within
is_module_text_address(). The is_module_text_address() caller is then
free to write to this address even after the module has been unloaded
and the module unload grace period ended.

Even worse, such grace period is not waited for at module load time
within:

init_module()
       module_free(mod, mod->module_init);
       mod->module_init = NULL;
       mod->init_size = 0;
       mod->init_text_size = 0;
  (done with module_mutex held, while the module is already in the
   module list)

We'd probably have to hold the module mutex around the
is_module_text_address() call and address use (which can be a pain), or
to correctly address this part of init_module() with RCU and require
that preempt off is held across both __module_text_address() call site
and the actual use of that pointer (which does not fit with jump label,
which need to sleep, so we'd have to move module.c to a preemptable
rcu_read_lock/synchronize_rcu() C.S.).

Thoughts ?

Mathieu


> +				arch_jump_label_transform(iter, type);
> +			iter++;
> +		}
> +		/* eanble/disable jump labels in modules */
> +		hlist_for_each_entry(e_module, module_node, &(entry->modules),
> +							hlist) {
> +			count = e_module->nr_entries;
> +			iter = e_module->table;
> +			while (count--) {
> +				if (kernel_text_address(iter->code))
> +					arch_jump_label_transform(iter, type);
> +				iter++;
> +			}
> +		}
> +	}
> +	mutex_unlock(&jump_label_mutex);
-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com

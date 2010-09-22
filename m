Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab0IVOOf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 10:14:35 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:55979 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753205Ab0IVOOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 10:14:34 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAI6rmUxGGN6i/2dsb2JhbACiLnLDTYVBBI8w
Date: Wed, 22 Sep 2010 10:14:32 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andi Kleen <andi@firstfloor.org>
Cc: jbaron@redhat.com, rostedt@goodmis.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, roland@redhat.com,
        rth@redhat.com, mhiramat@redhat.com, fweisbec@gmail.com,
        avi@redhat.com, davem@davemloft.net, vgoyal@redhat.com,
        sam@ravnborg.org, tony@bakeyournoodle.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] Add for_each_module iterator function v2
Message-ID: <20100922141432.GB30730@Krystal>
References: <1285162001-9556-1-git-send-email-andi@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1285162001-9556-1-git-send-email-andi@firstfloor.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 10:03:58 up 167 days, 23:54,  2 users,  load average: 0.09, 0.12,
	0.05
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (andi@firstfloor.org) wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> This is a generic function to iterate over all modules.
> To be used in the next patch.
> 
> v2: Use module_mutex instead of preempt disabling
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  include/linux/module.h |    1 +
>  kernel/module.c        |   10 ++++++++++
>  2 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/module.h b/include/linux/module.h
> index 403ac26..809b6db 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -410,6 +410,7 @@ struct module *__module_address(unsigned long addr);
>  bool is_module_address(unsigned long addr);
>  bool is_module_percpu_address(unsigned long addr);
>  bool is_module_text_address(unsigned long addr);
> +void for_each_module(void (*op)(struct module *, void *arg), void *arg);
>  
>  static inline int within_module_core(unsigned long addr, struct module *mod)
>  {
> diff --git a/kernel/module.c b/kernel/module.c
> index eba1341..9e2a561 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -384,6 +384,16 @@ struct module *find_module(const char *name)
>  }
>  EXPORT_SYMBOL_GPL(find_module);
>  
> +void for_each_module(void (*op)(struct module *, void *arg), void *arg)
> +{
> +	struct module *mod;
> +
> +	mutex_lock(&module_mutex);

I'm concerned about the following mutex dependency chain:

module_mutex -> jump_label_mutex (on module load)
jump_label_mutex -> module_mutex (on jump_label_update)

Actually, I think your module notifier is missing in your version. This
is why you don't see this dependency problem.

Mathieu

> +	list_for_each_entry_rcu(mod, &modules, list)
> +		op(mod, arg);
> +	mutex_unlock(&module_mutex);
> +}
> +
>  #ifdef CONFIG_SMP
>  
>  static inline void __percpu *mod_percpu(struct module *mod)
> -- 
> 1.7.1
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com

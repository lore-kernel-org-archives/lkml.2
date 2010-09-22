Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab0IVM0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 08:26:54 -0400
Received: from www.tglx.de ([62.245.132.106]:35965 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689Ab0IVM0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 08:26:53 -0400
Date: Wed, 22 Sep 2010 14:25:51 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: jbaron@redhat.com, rostedt@goodmis.com, linux-kernel@vger.kernel.org,
        mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
        roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        vgoyal@redhat.com, sam@ravnborg.org, tony@bakeyournoodle.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] Add for_each_module iterator function
In-Reply-To: <1285150102-5506-1-git-send-email-andi@firstfloor.org>
Message-ID: <alpine.LFD.2.00.1009221424590.2416@localhost6.localdomain6>
References: <1285150102-5506-1-git-send-email-andi@firstfloor.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 22 Sep 2010, Andi Kleen wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> This is a generic function to iterate over all modules.
> To be used in the next patch.
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
> index eba1341..b8fb3e6 100644
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
> +	preempt_disable();

  That wants rcu_read_lock()

> +	list_for_each_entry_rcu(mod, &modules, list)
> +		op(mod, arg);
> +	preempt_enable();

Thanks,

	tglx

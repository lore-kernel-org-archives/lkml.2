Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031754Ab2COQ3L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 12:29:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62115 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031681Ab2COQ3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 12:29:08 -0400
Subject: Re: [PATCH 3/7] module: take rcu_read_lock_sched for find_module
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Dennis1.Chen@amd.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <1331822941-19938-3-git-send-email-xiyou.wangcong@gmail.com>
References: <1331822941-19938-1-git-send-email-xiyou.wangcong@gmail.com>
	 <1331822941-19938-3-git-send-email-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Mar 2012 09:29:04 -0700
Message-ID: <1331828944.4874.17.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-15 at 22:48 +0800, Cong Wang wrote:
> Similar to find_symbol(), find_module() also iterates module list,
> should use list_for_each_entry_rcu() too, thus its callers should
> hold rcu_read_lock_sched before calling it.
> 
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> ---
>  kernel/module.c |   42 +++++++++++++++++++++++-------------------
>  1 files changed, 23 insertions(+), 19 deletions(-)
> 
> diff --git a/kernel/module.c b/kernel/module.c
> index b31b23f..f210d74 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -413,7 +413,7 @@ struct module *find_module(const char *name)
>  {
>  	struct module *mod;
>  
> -	list_for_each_entry(mod, &modules, list) {
> +	list_for_each_entry_rcu(mod, &modules, list) {
>  		if (strcmp(mod->name, name) == 0)
>  			return mod;
>  	}
> @@ -778,14 +778,16 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
>  		return -EFAULT;
>  	name[MODULE_NAME_LEN-1] = '\0';
>  
> -	if (mutex_lock_interruptible(&module_mutex) != 0)
> -		return -EINTR;
> -
> +	rcu_read_lock_sched();
>  	mod = find_module(name);
>  	if (!mod) {
> -		ret = -ENOENT;
> -		goto out;
> +		rcu_read_unlock_sched();
> +		return -ENOENT;
>  	}
> +	rcu_read_unlock_sched();
> +

Thats a bug.

> +	if (mutex_lock_interruptible(&module_mutex) != 0)
> +		return -EINTR;

mod might already had disappear.

>  
>  	if (!list_empty(&mod->source_list)) {
>  		/* Other modules depend on us: get rid of them first. */



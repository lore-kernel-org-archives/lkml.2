Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759369Ab2CMCu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 22:50:27 -0400
Received: from ozlabs.org ([203.10.76.45]:56285 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753486Ab2CMCuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 22:50:25 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Cong Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] module: use rcu to protect module list read
In-Reply-To: <1331389203-3309-1-git-send-email-xiyou.wangcong@gmail.com>
References: <1331389203-3309-1-git-send-email-xiyou.wangcong@gmail.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 13 Mar 2012 11:02:44 +1030
Message-ID: <87mx7lz6fn.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Mar 2012 22:20:02 +0800, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> Now the read of module list is protected by preempt disable + *_rcu
> list operations, this is odd, as RCU read lock should be able to
> protect it directly. This patch makes the read of module list
> protected by RCU read lock and the write still protected by
> module_mutex.

OK, please split these patches further.  Locking is subtle, so it's
great to be able to bisect more finely if we catch a problem.

eg.  First replace all the preempt_disable()/enable with
rcu_read_lock()/unlock.  Then replace lock in set_all_modules_text.
And so on...
 
> @@ -1810,11 +1810,11 @@ void *__symbol_get(const char *symbol)
> 	struct module *owner;
> 	const struct kernel_symbol *sym;
> 
> -	preempt_disable();
> +	rcu_read_lock();
> 	sym = find_symbol(symbol, &owner, NULL, true, true);
> +	rcu_read_unlock();
> 	if (sym && strong_try_module_get(owner))
> 		sym = NULL;
> -	preempt_enable();
> 
> 	return sym ? (void *)sym->value : NULL;
>  }

This is wrong: the symbol can vanish between find_symbol() and
strong_try_module_get().  We need protection around the whole thing.

> @@ -3302,7 +3309,7 @@ static char *module_flags(struct module *mod, char *buf)
>  /* Called by the /proc file system to return a list of modules. */
>  static void *m_start(struct seq_file *m, loff_t *pos)
>  {
> -	mutex_lock(&module_mutex);
> +	rcu_read_lock();
>  	return seq_list_start(&modules, *pos);
>  }
>  
> @@ -3313,7 +3320,7 @@ static void *m_next(struct seq_file *m, void *p, loff_t *pos)
>  
>  static void m_stop(struct seq_file *m, void *p)
>  {
> -	mutex_unlock(&module_mutex);
> +	rcu_read_unlock();
>  }
>  
>  static int m_show(struct seq_file *m, void *p)

Interesting.  I assume that these functions needed to sleep.  But it
looks like I was wrong.

But the rest looks fine,
Rusty.
-- 
  How could I marry someone with more hair than me?  http://baldalex.org

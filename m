Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611Ab1FHTeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 15:34:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43528 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755120Ab1FHTel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:34:41 -0400
Date: Wed, 8 Jun 2011 21:34:31 +0200
From: Jan Kara <jack@suse.cz>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH tip/core/rcu 18/28] jbd2,rcu: Convert
 call_rcu(free_devcache) to kfree_rcu()
Message-ID: <20110608193431.GI5361@quack.suse.cz>
References: <20110608192943.GA13211@linux.vnet.ibm.com>
 <1307561407-13809-18-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307561407-13809-18-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 08-06-11 12:29:57, Paul E. McKenney wrote:
> From: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> The rcu callback free_devcache() just calls a kfree(),
> so we use kfree_rcu() instead of the call_rcu(free_devcache).
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Jan Kara <jack@suse.cz>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
  Acked-by: Jan Kara <jack@suse.cz>

								Honza
> ---
>  fs/jbd2/journal.c |    7 +------
>  1 files changed, 1 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index e0ec3db..13fb464 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -2390,11 +2390,6 @@ struct devname_cache {
>  static struct devname_cache *devcache[1 << CACHE_SIZE_BITS];
>  static DEFINE_SPINLOCK(devname_cache_lock);
>  
> -static void free_devcache(struct rcu_head *rcu)
> -{
> -	kfree(rcu);
> -}
> -
>  const char *jbd2_dev_to_name(dev_t device)
>  {
>  	int	i = hash_32(device, CACHE_SIZE_BITS);
> @@ -2423,7 +2418,7 @@ const char *jbd2_dev_to_name(dev_t device)
>  			spin_unlock(&devname_cache_lock);
>  			return ret;
>  		}
> -		call_rcu(&devcache[i]->rcu, free_devcache);
> +		kfree_rcu(devcache[i], rcu);
>  	}
>  	devcache[i] = new_dev;
>  	devcache[i]->device = device;
> -- 
> 1.7.3.2
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

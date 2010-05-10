Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab0EJP4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 11:56:18 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48286 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016Ab0EJP4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 11:56:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=JGF3g46+ZzAJJ+OVkTB5w5nbf/N9GunoE6UNCjIE34+Di4Hg/luHzB6iWkn2ETM3hv
         zDRtz1tamZfRdHvlTcSuX8yGrZx52TbVbC1vWoYib/hJzMcsTTJtEHLSeKxn2WCAXOlf
         WyEu0+N1DFxoyBh5be1fraZejTN1Ff960+S1Y=
Subject: Re: mmotm 2010-04-28 - RCU whinges
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Patrick McHardy <kaber@trash.net>
Cc: David Miller <davem@davemloft.net>, Valdis.Kletnieks@vt.edu,
       akpm@linux-foundation.org, peterz@infradead.org,
       linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
       netdev@vger.kernel.org, paulmck@linux.vnet.ibm.com
In-Reply-To: <4BE8290A.2080707@trash.net>
References: <1272865137.2173.179.camel@edumazet-laptop>
	 <1272865267.2173.180.camel@edumazet-laptop>
	 <1272865436.2173.182.camel@edumazet-laptop>
	 <20100502.225509.233880079.davem@davemloft.net>
	 <4BE8290A.2080707@trash.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 May 2010 17:56:08 +0200
Message-ID: <1273506968.2221.19.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 10 mai 2010 à 17:40 +0200, Patrick McHardy a écrit :
> David Miller wrote:
> > From: Eric Dumazet <eric.dumazet@gmail.com>
> > Date: Mon, 03 May 2010 07:43:56 +0200
> > 
> >> Le lundi 03 mai 2010 à 07:41 +0200, Eric Dumazet a écrit :
> >>
> >>> Oops scratch that, I'll resend a correct version.
> >>>
> >>>
> >> Sorry, patch _is_ fine, I had one brain collapse when re-reading it, I
> >> thought a different mutex was in use in one of the functions.
> > 
> > Ok, Patrick please review, thanks.
> 
> Actually we don't need the rcu_dereference() calls at all since
> registration and unregistration are protected by the mutexes.
> 
> I queued this patch in nf-next, the only reason why I haven't
> submitted it yet is that I was unable to get git to cleanly export
> only the proper set of patches meant for -next due to a few merges,
> it insists on including 5 patches already merged upstream. If you
> don't mind ignoring the first 5 patches in the series, I'll send a
> pull request tonight.
> 


This will clash with upcoming RCU patches, where rcu protected pointer
cannot be directly accessed without lockdep splats.

We will need one day or another a rcu_...(nf_conntrack_event_cb)

> 
> pièce jointe document texte brut (x)
> commit ed86308f6179d8fa6151c2d0f652aad0091548e2
> Author: Patrick McHardy <kaber@trash.net>
> Date:   Fri Apr 9 16:42:15 2010 +0200
> 
>     netfilter: remove invalid rcu_dereference() calls
>     
>     The CONFIG_PROVE_RCU option discovered a few invalid uses of
>     rcu_dereference() in netfilter. In all these cases, the code code
>     intends to check whether a pointer is already assigned when
>     performing registration or whether the assigned pointer matches
>     when performing unregistration. The entire registration/
>     unregistration is protected by a mutex, so we don't need the
>     rcu_dereference() calls.
>     
>     Reported-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
>     Tested-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
>     Signed-off-by: Patrick McHardy <kaber@trash.net>
> 
> diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
> index d5a9bcd..849614a 100644
> --- a/net/netfilter/nf_conntrack_ecache.c
> +++ b/net/netfilter/nf_conntrack_ecache.c
> @@ -81,11 +81,9 @@ EXPORT_SYMBOL_GPL(nf_ct_deliver_cached_events);
>  int nf_conntrack_register_notifier(struct nf_ct_event_notifier *new)
>  {
>  	int ret = 0;
> -	struct nf_ct_event_notifier *notify;
>  
>  	mutex_lock(&nf_ct_ecache_mutex);
> -	notify = rcu_dereference(nf_conntrack_event_cb);
> -	if (notify != NULL) {
> +	if (nf_conntrack_event_cb != NULL) {
>  		ret = -EBUSY;
>  		goto out_unlock;
>  	}
> @@ -101,11 +99,8 @@ EXPORT_SYMBOL_GPL(nf_conntrack_register_notifier);
>  
>  void nf_conntrack_unregister_notifier(struct nf_ct_event_notifier *new)
>  {
> -	struct nf_ct_event_notifier *notify;
> -
>  	mutex_lock(&nf_ct_ecache_mutex);
> -	notify = rcu_dereference(nf_conntrack_event_cb);
> -	BUG_ON(notify != new);
> +	BUG_ON(nf_conntrack_event_cb != new);
>  	rcu_assign_pointer(nf_conntrack_event_cb, NULL);
>  	mutex_unlock(&nf_ct_ecache_mutex);
>  }
> @@ -114,11 +109,9 @@ EXPORT_SYMBOL_GPL(nf_conntrack_unregister_notifier);
>  int nf_ct_expect_register_notifier(struct nf_exp_event_notifier *new)
>  {
>  	int ret = 0;
> -	struct nf_exp_event_notifier *notify;
>  
>  	mutex_lock(&nf_ct_ecache_mutex);
> -	notify = rcu_dereference(nf_expect_event_cb);
> -	if (notify != NULL) {
> +	if (nf_expect_event_cb != NULL) {
>  		ret = -EBUSY;
>  		goto out_unlock;
>  	}
> @@ -134,11 +127,8 @@ EXPORT_SYMBOL_GPL(nf_ct_expect_register_notifier);
>  
>  void nf_ct_expect_unregister_notifier(struct nf_exp_event_notifier *new)
>  {
> -	struct nf_exp_event_notifier *notify;
> -
>  	mutex_lock(&nf_ct_ecache_mutex);
> -	notify = rcu_dereference(nf_expect_event_cb);
> -	BUG_ON(notify != new);
> +	BUG_ON(nf_expect_event_cb != new);
>  	rcu_assign_pointer(nf_expect_event_cb, NULL);
>  	mutex_unlock(&nf_ct_ecache_mutex);
>  }
> diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
> index 015725a..908f599 100644
> --- a/net/netfilter/nf_log.c
> +++ b/net/netfilter/nf_log.c
> @@ -35,7 +35,6 @@ static struct nf_logger *__find_logger(int pf, const char *str_logger)
>  /* return EEXIST if the same logger is registred, 0 on success. */
>  int nf_log_register(u_int8_t pf, struct nf_logger *logger)
>  {
> -	const struct nf_logger *llog;
>  	int i;
>  
>  	if (pf >= ARRAY_SIZE(nf_loggers))
> @@ -52,8 +51,7 @@ int nf_log_register(u_int8_t pf, struct nf_logger *logger)
>  	} else {
>  		/* register at end of list to honor first register win */
>  		list_add_tail(&logger->list[pf], &nf_loggers_l[pf]);
> -		llog = rcu_dereference(nf_loggers[pf]);
> -		if (llog == NULL)
> +		if (nf_loggers[pf] == NULL)
>  			rcu_assign_pointer(nf_loggers[pf], logger);
>  	}
>  
> @@ -65,13 +63,11 @@ EXPORT_SYMBOL(nf_log_register);
>  
>  void nf_log_unregister(struct nf_logger *logger)
>  {
> -	const struct nf_logger *c_logger;
>  	int i;
>  
>  	mutex_lock(&nf_log_mutex);
>  	for (i = 0; i < ARRAY_SIZE(nf_loggers); i++) {
> -		c_logger = rcu_dereference(nf_loggers[i]);
> -		if (c_logger == logger)
> +		if (nf_loggers[i] == logger)
>  			rcu_assign_pointer(nf_loggers[i], NULL);
>  		list_del(&logger->list[i]);
>  	}



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752378Ab2AZKpG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 05:45:06 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:3635 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000Ab2AZKpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 05:45:04 -0500
Message-ID: <4F212E7E.2040801@parallels.com>
Date: Thu, 26 Jan 2012 14:44:14 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: =?UTF-8?B?U2p1ciBCcsOmbmRlbGFuZA==?= 
	<sjur.brandeland@stericsson.com>,
        "levinsasha928@gmail.com" <levinsasha928@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davej@redhat.com" <davej@redhat.com>,
        "sjurbren@gmail.com" <sjurbren@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] netns: fix net_alloc_generic()
References: <CA+1xoqe+Qa1OByj7z7XzAPG_g9+BmNj9NPZR=_5b_MTEmc9Chw@mail.gmail.com>	 <1327523631-3480-1-git-send-email-sjur.brandeland@stericsson.com> <1327574498.2500.22.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
In-Reply-To: <1327574498.2500.22.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I believe the problem is in net_namespace infrastructure, not in CAIF.
> 
> Could you test following patch instead ?
> 
> [PATCH] netns: fix net_alloc_generic()
> 
> When a new net namespace is created, we should attach to it a "struct
> net_generic" with enough slots (even empty), or we can hit the following
> BUG_ON() :
> 
> [  200.752016] kernel BUG at include/net/netns/generic.h:40!
> ...
> [  200.752016]  [<ffffffff825c3cea>] ? get_cfcnfg+0x3a/0x180
> [  200.752016]  [<ffffffff821cf0b0>] ? lockdep_rtnl_is_held+0x10/0x20
> [  200.752016]  [<ffffffff825c41be>] caif_device_notify+0x2e/0x530
> [  200.752016]  [<ffffffff810d61b7>] notifier_call_chain+0x67/0x110
> [  200.752016]  [<ffffffff810d67c1>] raw_notifier_call_chain+0x11/0x20
> [  200.752016]  [<ffffffff821bae82>] call_netdevice_notifiers+0x32/0x60
> [  200.752016]  [<ffffffff821c2b26>] register_netdevice+0x196/0x300
> [  200.752016]  [<ffffffff821c2ca9>] register_netdev+0x19/0x30
> [  200.752016]  [<ffffffff81c1c67a>] loopback_net_init+0x4a/0xa0
> [  200.752016]  [<ffffffff821b5e62>] ops_init+0x42/0x180
> [  200.752016]  [<ffffffff821b600b>] setup_net+0x6b/0x100
> [  200.752016]  [<ffffffff821b6466>] copy_net_ns+0x86/0x110
> [  200.752016]  [<ffffffff810d5789>] create_new_namespaces+0xd9/0x190
> 
> net_alloc_generic() should take into account the maximum index into the
> ptr array, as a subsystem might use net_generic() anytime.

I'm not sure I understand it correctly, but subsystem can only use the
net_generic() only (!) after the net_assign_generic() is performed.

> This also reduces number of reallocations in net_assign_generic()
> 
> Reported-by: Sasha Levin <levinsasha928@gmail.com>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: Sjur Brændeland <sjur.brandeland@stericsson.com>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Pavel Emelyanov <xemul@openvz.org>
> ---
>  net/core/net_namespace.c |   31 ++++++++++++++++---------------
>  1 file changed, 16 insertions(+), 15 deletions(-)
> 
> diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
> index aefcd7a..0e950fd 100644
> --- a/net/core/net_namespace.c
> +++ b/net/core/net_namespace.c
> @@ -30,6 +30,20 @@ EXPORT_SYMBOL(init_net);
>  
>  #define INITIAL_NET_GEN_PTRS	13 /* +1 for len +2 for rcu_head */
>  
> +static unsigned int max_gen_ptrs = INITIAL_NET_GEN_PTRS;
> +
> +static struct net_generic *net_alloc_generic(void)
> +{
> +	struct net_generic *ng;
> +	size_t generic_size = offsetof(struct net_generic, ptr[max_gen_ptrs]);
> +
> +	ng = kzalloc(generic_size, GFP_KERNEL);
> +	if (ng)
> +		ng->len = max_gen_ptrs;
> +
> +	return ng;
> +}
> +
>  static int net_assign_generic(struct net *net, int id, void *data)
>  {
>  	struct net_generic *ng, *old_ng;
> @@ -43,8 +57,7 @@ static int net_assign_generic(struct net *net, int id, void *data)
>  	if (old_ng->len >= id)
>  		goto assign;
>  
> -	ng = kzalloc(sizeof(struct net_generic) +
> -			id * sizeof(void *), GFP_KERNEL);
> +	ng = net_alloc_generic();
>  	if (ng == NULL)
>  		return -ENOMEM;
>  
> @@ -59,7 +72,6 @@ static int net_assign_generic(struct net *net, int id, void *data)
>  	 * the old copy for kfree after a grace period.
>  	 */
>  
> -	ng->len = id;
>  	memcpy(&ng->ptr, &old_ng->ptr, old_ng->len * sizeof(void*));
>  
>  	rcu_assign_pointer(net->gen, ng);
> @@ -161,18 +173,6 @@ out_undo:
>  	goto out;
>  }
>  
> -static struct net_generic *net_alloc_generic(void)
> -{
> -	struct net_generic *ng;
> -	size_t generic_size = sizeof(struct net_generic) +
> -		INITIAL_NET_GEN_PTRS * sizeof(void *);
> -
> -	ng = kzalloc(generic_size, GFP_KERNEL);
> -	if (ng)
> -		ng->len = INITIAL_NET_GEN_PTRS;
> -
> -	return ng;
> -}
>  
>  #ifdef CONFIG_NET_NS
>  static struct kmem_cache *net_cachep;
> @@ -483,6 +483,7 @@ again:
>  			}
>  			return error;
>  		}
> +		max_gen_ptrs = max_t(unsigned int, max_gen_ptrs, *ops->id);
>  	}
>  	error = __register_pernet_operations(list, ops);
>  	if (error) {
> 
> 


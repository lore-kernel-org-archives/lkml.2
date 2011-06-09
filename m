Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab1FIRMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 13:12:17 -0400
Received: from mx2.netapp.com ([216.240.18.37]:16268 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695Ab1FIRMQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 13:12:16 -0400
X-IronPort-AV: E=Sophos;i="4.65,342,1304319600"; 
   d="scan'208";a="554339003"
Subject: Re: [PATCH tip/core/rcu 13/28] nfs,rcu: Convert
 call_rcu(nfs_free_delegation_callback) to kfree_rcu()
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org
Date: Thu, 09 Jun 2011 13:12:23 -0400
In-Reply-To: <1307561407-13809-13-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20110608192943.GA13211@linux.vnet.ibm.com>
	 <1307561407-13809-13-git-send-email-paulmck@linux.vnet.ibm.com>
Organization: NetApp Inc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2 (3.0.2-1.fc15) 
Message-ID: <1307639543.20245.19.camel@lade.trondhjem.org>
Mime-Version: 1.0
X-OriginalArrivalTime: 09 Jun 2011 17:12:14.0367 (UTC) FILETIME=[60A56AF0:01CC26C8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-08 at 12:29 -0700, Paul E. McKenney wrote: 
> From: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> The rcu callback nfs_free_delegation_callback() just calls a kfree(),
> so we use kfree_rcu() instead of the call_rcu(nfs_free_delegation_callback).
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>

> ---
>  fs/nfs/delegation.c |   14 +-------------
>  1 files changed, 1 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
> index bbbc6bf..dd25c2a 100644
> --- a/fs/nfs/delegation.c
> +++ b/fs/nfs/delegation.c
> @@ -21,25 +21,13 @@
>  #include "delegation.h"
>  #include "internal.h"
>  
> -static void nfs_do_free_delegation(struct nfs_delegation *delegation)
> -{
> -	kfree(delegation);
> -}
> -
> -static void nfs_free_delegation_callback(struct rcu_head *head)
> -{
> -	struct nfs_delegation *delegation = container_of(head, struct nfs_delegation, rcu);
> -
> -	nfs_do_free_delegation(delegation);
> -}
> -
>  static void nfs_free_delegation(struct nfs_delegation *delegation)
>  {
>  	if (delegation->cred) {
>  		put_rpccred(delegation->cred);
>  		delegation->cred = NULL;
>  	}
> -	call_rcu(&delegation->rcu, nfs_free_delegation_callback);
> +	kfree_rcu(delegation, rcu);
>  }
>  
>  /**

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com


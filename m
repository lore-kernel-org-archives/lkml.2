Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390Ab1CRJgA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 05:36:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37798 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932097Ab1CRJfy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 05:35:54 -0400
Subject: Re: [PATCH 27/36] perf,rcu: convert
 call_rcu(swevent_hlist_release_rcu) to kfree_rcu()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
In-Reply-To: <4D82DABD.7050208@cn.fujitsu.com>
References: <4D82DABD.7050208@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 18 Mar 2011 10:35:35 +0100
Message-ID: <1300440935.21794.30.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-18 at 12:08 +0800, Lai Jiangshan wrote:
> 
> The rcu callback swevent_hlist_release_rcu() just calls a kfree(),
> so we use kfree_rcu() instead of the call_rcu(swevent_hlist_release_rcu).
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> ---
>  kernel/perf_event.c |   10 +---------
>  1 files changed, 1 insertions(+), 9 deletions(-)
> 
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index b0581bd..43b0410 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -5300,14 +5300,6 @@ swevent_hlist_deref(struct swevent_htable *swhash)
>  					 lockdep_is_held(&swhash->hlist_mutex));
>  }
>  
> -static void swevent_hlist_release_rcu(struct rcu_head *rcu_head)
> -{
> -	struct swevent_hlist *hlist;
> -
> -	hlist = container_of(rcu_head, struct swevent_hlist, rcu_head);
> -	kfree(hlist);
> -}
> -
>  static void swevent_hlist_release(struct swevent_htable *swhash)
>  {
>  	struct swevent_hlist *hlist = swevent_hlist_deref(swhash);
> @@ -5316,7 +5308,7 @@ static void swevent_hlist_release(struct swevent_htable *swhash)
>  		return;
>  
>  	rcu_assign_pointer(swhash->swevent_hlist, NULL);
> -	call_rcu(&hlist->rcu_head, swevent_hlist_release_rcu);
> +	kfree_rcu(hlist, rcu_head);
>  }
>  
>  static void swevent_hlist_put_cpu(struct perf_event *event, int cpu)


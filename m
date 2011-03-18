Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936Ab1CRPZ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 11:25:59 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41835 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756919Ab1CRPZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 11:25:53 -0400
Date: Fri, 18 Mar 2011 11:24:52 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Jens Axboe <axboe@kernel.dk>,
        Robert Love <robert.w.love@intel.com>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Stephen Hemminger <shemminger@vyatta.com>, Tejun Heo <tj@kernel.org>,
        Jarek Poplawski <jarkao2@gmail.com>, linux-kernel@vger.kernel.org,
        devel@open-fcoe.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 01/36] net,rcu: convert call_rcu(free_dm_hw_stat) to
 kfree_rcu()
Message-ID: <20110318152452.GA12980@hmsreliant.think-freely.org>
References: <4D82D071.5020703@cn.fujitsu.com>
 <4D82D3FF.2080303@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D82D3FF.2080303@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.6 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 11:39:43AM +0800, Lai Jiangshan wrote:
> 
> 
> The rcu callback free_dm_hw_stat() just calls a kfree(),
> so we use kfree_rcu() instead of the call_rcu(free_dm_hw_stat).
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>

> ---
>  net/core/drop_monitor.c |   12 ++----------
>  1 files changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
> index 36e603c..32365e7 100644
> --- a/net/core/drop_monitor.c
> +++ b/net/core/drop_monitor.c
> @@ -207,14 +207,6 @@ static void trace_napi_poll_hit(void *ignore, struct napi_struct *napi)
>  	rcu_read_unlock();
>  }
>  
> -
> -static void free_dm_hw_stat(struct rcu_head *head)
> -{
> -	struct dm_hw_stat_delta *n;
> -	n = container_of(head, struct dm_hw_stat_delta, rcu);
> -	kfree(n);
> -}
> -
>  static int set_all_monitor_traces(int state)
>  {
>  	int rc = 0;
> @@ -245,7 +237,7 @@ static int set_all_monitor_traces(int state)
>  		list_for_each_entry_safe(new_stat, temp, &hw_stats_list, list) {
>  			if (new_stat->dev == NULL) {
>  				list_del_rcu(&new_stat->list);
> -				call_rcu(&new_stat->rcu, free_dm_hw_stat);
> +				kfree_rcu(new_stat, rcu);
>  			}
>  		}
>  		break;
> @@ -314,7 +306,7 @@ static int dropmon_net_event(struct notifier_block *ev_block,
>  				new_stat->dev = NULL;
>  				if (trace_state == TRACE_OFF) {
>  					list_del_rcu(&new_stat->list);
> -					call_rcu(&new_stat->rcu, free_dm_hw_stat);
> +					kfree_rcu(new_stat, rcu);
>  					break;
>  				}
>  			}
> -- 
> 1.7.4
> 

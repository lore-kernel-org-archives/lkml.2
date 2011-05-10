Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab1EJI3K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:29:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:60132 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451Ab1EJI3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:29:07 -0400
Subject: Re: [PATCH] sched: fix constructing the span cpu mask of sched
 domain
From: Peter Zijlstra <peterz@infradead.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Yong Zhang <yong.zhang0@gmail.com>
In-Reply-To: <BANLkTi=qPWxRAa6+dT3ohEP6Z=0v+e4EXA@mail.gmail.com>
References: <BANLkTi=qPWxRAa6+dT3ohEP6Z=0v+e4EXA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 May 2011 10:32:09 +0200
Message-ID: <1305016329.2914.22.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-05 at 20:53 +0800, Hillf Danton wrote:
> For a given node, when constructing the cpumask for its sched_domain
> to span, if there is no best node available after searching, further
> efforts could be saved, based on small change in the return value of
> find_next_best_node().
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> --- a/kernel/sched.c	2011-04-27 11:48:50.000000000 +0800
> +++ b/kernel/sched.c	2011-05-05 20:44:52.000000000 +0800
> @@ -6787,7 +6787,7 @@ init_sched_build_groups(const struct cpu
>   */
>  static int find_next_best_node(int node, nodemask_t *used_nodes)
>  {
> -	int i, n, val, min_val, best_node = 0;
> +	int i, n, val, min_val, best_node = -1;
> 
>  	min_val = INT_MAX;
> 
> @@ -6811,7 +6811,8 @@ static int find_next_best_node(int node,
>  		}
>  	}
> 
> -	node_set(best_node, *used_nodes);
> +	if (best_node != -1)
> +		node_set(best_node, *used_nodes);
>  	return best_node;
>  }
> 
> @@ -6837,7 +6838,8 @@ static void sched_domain_node_span(int n
> 
>  	for (i = 1; i < SD_NODES_PER_DOMAIN; i++) {
>  		int next_node = find_next_best_node(node, &used_nodes);
> -
> +		if (next_node < 0)
> +			break;
>  		cpumask_or(span, span, cpumask_of_node(next_node));
>  	}
>  }


If you're interested in this area of the scheduler, you might want to
have a poke at:

http://marc.info/?l=linux-kernel&m=130218515520540

That tries to rewrite the CONFIG_NUMA support for the sched_domain stuff
to create domains based on the node_distance() to better reflect the
actual machine topology.

As stated, that patch is currently very broken, mostly because the
topologies encountered don't map to non-overlapping trees. I've not yet
come up with how to deal with that, but we sure need to do something
like that, the current group 16 nodes and a group of all simply doesn't
work well for today's machines now that NUMA is both common and the
inter-node latencies are more relevant.


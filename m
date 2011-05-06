Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab1EFHMi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 03:12:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55565 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152Ab1EFHMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 03:12:37 -0400
Date: Fri, 6 May 2011 09:12:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>, Yong Zhang <yong.zhang0@gmail.com>
Subject: Re: [PATCH] sched: fix constructing the span cpu mask of sched domain
Message-ID: <20110506071233.GC23166@elte.hu>
References: <BANLkTi=qPWxRAa6+dT3ohEP6Z=0v+e4EXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=qPWxRAa6+dT3ohEP6Z=0v+e4EXA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hillf Danton <dhillf@gmail.com> wrote:

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

Looks good. I changed the title from:

  sched: fix constructing the span cpu mask of sched domain

to:

  sched: Shorten the constructing of the span cpu mask of sched domain

Because unless i missed some side effect it really does not 'fix' anything, it 
avoids repetitive (and ultimately fruitless) extra work, right?

Thanks,

	Ingo

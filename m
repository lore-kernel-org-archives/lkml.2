Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab1DUNld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 09:41:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:44822 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab1DUNlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 09:41:32 -0400
Subject: Re: [PATCH] sched: try to fix mm leak when freeing sched groups
From: Peter Zijlstra <peterz@infradead.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <BANLkTin_m2Ygnr8csKo6fJZ4sB6YYvYDGw@mail.gmail.com>
References: <BANLkTin_m2Ygnr8csKo6fJZ4sB6YYvYDGw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Apr 2011 15:44:10 +0200
Message-ID: <1303393450.2035.142.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-21 at 21:37 +0800, Hillf Danton wrote:
> When freeing sched groups, there is a sg (== sched_group_nodes[i]) not
> got freed.
> The relevant code is reshuffled to be clearer, and correct.

The code doesn't even appear to exist, what kernel are you patching?

> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> --- a/kernel/sched.c	2011-03-30 03:09:48.000000000 +0800
> +++ b/kernel/sched.c	2011-04-21 21:09:00.000000000 +0800
> @@ -7106,7 +7106,7 @@ static void free_sched_groups(const stru
>  			continue;
> 
>  		for (i = 0; i < nr_node_ids; i++) {
> -			struct sched_group *oldsg, *sg = sched_group_nodes[i];
> +			struct sched_group *sg = sched_group_nodes[i];
> 
>  			cpumask_and(nodemask, cpumask_of_node(i), cpu_map);
>  			if (cpumask_empty(nodemask))
> @@ -7114,13 +7114,11 @@ static void free_sched_groups(const stru
> 
>  			if (sg == NULL)
>  				continue;
> -			sg = sg->next;
> -next_sg:
> -			oldsg = sg;
> -			sg = sg->next;
> -			kfree(oldsg);
> -			if (oldsg != sched_group_nodes[i])
> -				goto next_sg;
> +			do {
> +				struct sched_group *next = sg->next;
> +				kfree(sg);
> +				sg = next;
> +			} while (sg != sched_group_nodes[i]);
>  		}
>  		kfree(sched_group_nodes);
>  		sched_group_nodes_bycpu[cpu] = NULL;




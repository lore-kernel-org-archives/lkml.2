Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760211Ab1LPRKx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 12:10:53 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50136 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955Ab1LPRKq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 12:10:46 -0500
Message-ID: <1324055385.18942.109.camel@twins>
Subject: Re: [PATCH] sched: allow preempt notifiers to self-unregister.
From: Peter Zijlstra <peterz@infradead.org>
To: Pierre Habouzit <pierre.habouzit@intersec.com>
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>,
        Ingo Molnar <mingo@elte.hu>
Date: Fri, 16 Dec 2011 18:09:45 +0100
In-Reply-To: <1324052151-3714-1-git-send-email-pierre.habouzit@intersec.com>
References: <1324052151-3714-1-git-send-email-pierre.habouzit@intersec.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-16 at 17:15 +0100, Pierre Habouzit wrote:

>   As a background, this need is because I have some kind of module code
>   that uses this facility to evaluate how many of a group of threads are
>   concurrently running (to regulate a pool of threads).

Typically such stuff is only merged along with whomever uses it.

>   Hence I install those callbacks for the thread registering themselves
>   and want to keep them until the thread dies. Sadly I have no way to
>   unregister those callbacks right now, but for horrible hacks (involving
>   private delayed queues processed regularly walked to kfree() the
>   structures referencing pids that are dead, urgh).

kfree_rcu() is the 'normal' way to cheat your way out of this.

> diff --git a/kernel/sched.c b/kernel/sched.c
> index d6b149c..2653169 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -3106,7 +3106,7 @@ static void fire_sched_in_preempt_notifiers(struct task_struct *curr)
>  	struct preempt_notifier *notifier;
>  	struct hlist_node *node;
>  
> -	hlist_for_each_entry(notifier, node, &curr->preempt_notifiers, link)
> +	hlist_for_each_entry_safe(notifier, node, &curr->preempt_notifiers, link)
>  		notifier->ops->sched_in(notifier, raw_smp_processor_id());
>  }
>  
> @@ -3117,7 +3117,7 @@ fire_sched_out_preempt_notifiers(struct task_struct *curr,
>  	struct preempt_notifier *notifier;
>  	struct hlist_node *node;
>  
> -	hlist_for_each_entry(notifier, node, &curr->preempt_notifiers, link)
> +	hlist_for_each_entry_safe(notifier, node, &curr->preempt_notifiers, link)
>  		notifier->ops->sched_out(notifier, next);
>  }

This adds to scheduler hot paths, it needs very good justification.


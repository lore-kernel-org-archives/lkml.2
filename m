Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab0LVQYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 11:24:33 -0500
Received: from mga03.intel.com ([143.182.124.21]:26358 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753391Ab0LVQYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 11:24:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,214,1291622400"; 
   d="scan'208";a="365328823"
Message-ID: <4D122636.5070203@linux.intel.com>
Date: Wed, 22 Dec 2010 08:24:22 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Peter Zijlstra <peterz@infradead.org>, John Kacur <jkacur@redhat.com>,
        James Bottomley <James.Bottomley@suse.de>, Ingo Molnar <mingo@elte.hu>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Namhyung Kim <namhyung@gmail.com>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/4] futex,plist: remove debug lock assignment for plist_node
References: <4D10797E.7040803@cn.fujitsu.com>
In-Reply-To: <4D10797E.7040803@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2010 01:55 AM, Lai Jiangshan wrote:
> original code use&plist_node->plist as the faked head of
> the priority list for plist_del(), these debug locks in
> the faked head are needed for CONFIG_DEBUG_PI_LIST.
>
> But now we always pass the real head to plist_del(), the debug locks
> in plist_node will not be used, so we remove these assignments.
>
> Signed-off-by:  Lai Jiangshan<laijs@cn.fujitsu.com>

Acked-by: Darren Hart <dvhart@linux.intel.com>

> ---
> diff --git a/kernel/futex.c b/kernel/futex.c
> index 6c4f67a..725834e 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -1032,9 +1032,6 @@ void requeue_futex(struct futex_q *q, struct futex_hash_bucket *hb1,
>   		plist_del(&q->list,&hb1->chain);
>   		plist_add(&q->list,&hb2->chain);
>   		q->lock_ptr =&hb2->lock;
> -#ifdef CONFIG_DEBUG_PI_LIST
> -		q->list.plist.spinlock =&hb2->lock;
> -#endif
>   	}
>   	get_futex_key_refs(key2);
>   	q->key = *key2;
> @@ -1068,9 +1065,6 @@ void requeue_pi_wake_futex(struct futex_q *q, union futex_key *key,
>   	q->rt_waiter = NULL;
>
>   	q->lock_ptr =&hb->lock;
> -#ifdef CONFIG_DEBUG_PI_LIST
> -	q->list.plist.spinlock =&hb->lock;
> -#endif
>
>   	wake_up_state(q->task, TASK_NORMAL);
>   }
> @@ -1418,9 +1412,6 @@ static inline void queue_me(struct futex_q *q, struct futex_hash_bucket *hb)
>   	prio = min(current->normal_prio, MAX_RT_PRIO);
>
>   	plist_node_init(&q->list, prio);
> -#ifdef CONFIG_DEBUG_PI_LIST
> -	q->list.plist.spinlock =&hb->lock;
> -#endif
>   	plist_add(&q->list,&hb->chain);
>   	q->task = current;
>   	spin_unlock(&hb->lock);


-- 
Darren Hart
Yocto Linux Kernel

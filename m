Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab1CQUAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 16:00:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:14776 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755154Ab1CQUAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 16:00:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,201,1299484800"; 
   d="scan'208";a="721315966"
Message-ID: <4D826863.2040406@linux.intel.com>
Date: Thu, 17 Mar 2011 13:00:35 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH 2/2] futex: Fix WARN_ON() test for UP
References: <20110317192105.308382309@goodmis.org> <20110317192208.682654502@goodmis.org>
In-Reply-To: <20110317192208.682654502@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2011 12:21 PM, Steven Rostedt wrote:
> From: Steven Rostedt<srostedt@redhat.com>
>
> An update of the futex code had a
>
> 	WARN_ON(!spin_is_locked(q->lock_ptr))
>
> But on UP, spin_is_locked() is always false, and will
> trigger this warning, and even worse, it will exit the function
> without doing the necessary work.
>
> Converting this to a WARN_ON_SMP() fixes the problem.
>
> Reported-by: Richard Weinberger<richard@nod.at>
> Tested-by: Richard Weinberger<richard@nod.at>
> Signed-off-by: Steven Rostedt<rostedt@goodmis.org>

Acked-by: Darren Hart <dvhart@linux.intel.com>


> ---
>   kernel/futex.c |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/futex.c b/kernel/futex.c
> index 9fe9131..850d00b 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -785,8 +785,8 @@ static void __unqueue_futex(struct futex_q *q)
>   {
>   	struct futex_hash_bucket *hb;
>
> -	if (WARN_ON(!q->lock_ptr || !spin_is_locked(q->lock_ptr)
> -			|| plist_node_empty(&q->list)))
> +	if (WARN_ON_SMP(!q->lock_ptr || !spin_is_locked(q->lock_ptr))
> +	    || WARN_ON(plist_node_empty(&q->list)))
>   		return;
>
>   	hb = container_of(q->lock_ptr, struct futex_hash_bucket, lock);
> -- 1.7.2.3 -- To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in the body of a message to majordomo@vger.kernel.org More
> majordomo info at http://vger.kernel.org/majordomo-info.html Please read
> the FAQ at http://www.tux.org/lkml/

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel

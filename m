Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab1EPI3q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 04:29:46 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34105 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab1EPI3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 04:29:43 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 16 May 2011 17:22:58 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, minchan.kim@gmail.com, riel@redhat.com
Subject: Re: [PATCH 3/3] vmscan: implement swap token priority decay
Message-Id: <20110516172258.c7dcd982.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4DCD1913.2090200@jp.fujitsu.com>
References: <4DCD1824.1060801@jp.fujitsu.com>
	<4DCD1913.2090200@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 May 2011 20:42:11 +0900
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> While testing for memcg aware swap token, I observed a swap token
> was often grabbed an intermittent running process (eg init, auditd)
> and they never release a token.
> 
> Why? Currently, swap toke priority is only decreased at page fault
> path. Then, if the process sleep immediately after to grab swap
> token, their swap token priority never be decreased. That makes
> obviously undesired result.
> 
> This patch implement very poor (and lightweight) priority decay
> mechanism. It only be affect to the above corner case and doesn't
> change swap tendency workload performance (eg multi process qsbench
> load)
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

But...

> ---
>  include/trace/events/vmscan.h |   12 ++++++++----
>  mm/thrash.c                   |    5 ++++-
>  2 files changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
> index 1798e0c..ba18137 100644
> --- a/include/trace/events/vmscan.h
> +++ b/include/trace/events/vmscan.h
> @@ -366,9 +366,10 @@ DEFINE_EVENT_CONDITION(put_swap_token_template, disable_swap_token,
> 
>  TRACE_EVENT_CONDITION(update_swap_token_priority,
>  	TP_PROTO(struct mm_struct *mm,
> -		 unsigned int old_prio),
> +		 unsigned int old_prio,
> +		 struct mm_struct *swap_token_mm),
> 
> -	TP_ARGS(mm, old_prio),
> +	TP_ARGS(mm, old_prio, swap_token_mm),
> 
>  	TP_CONDITION(mm->token_priority != old_prio),
> 
> @@ -376,16 +377,19 @@ TRACE_EVENT_CONDITION(update_swap_token_priority,
>  		__field(struct mm_struct*, mm)
>  		__field(unsigned int, old_prio)
>  		__field(unsigned int, new_prio)
> +		__field(unsigned int, token_prio)
>  	),
> 
>  	TP_fast_assign(
>  		__entry->mm = mm;
>  		__entry->old_prio = old_prio;
>  		__entry->new_prio = mm->token_priority;
> +		__entry->token_prio = swap_token_mm ? swap_token_mm->token_priority : 0;
>  	),
> 
> -	TP_printk("mm=%p old_prio=%u new_prio=%u",
> -		  __entry->mm, __entry->old_prio, __entry->new_prio)
> +	TP_printk("mm=%p old_prio=%u new_prio=%u token_prio=%u",
> +		  __entry->mm, __entry->old_prio, __entry->new_prio,
> +		  __entry->token_prio)
>  );
> 
>  #endif /* _TRACE_VMSCAN_H */
> diff --git a/mm/thrash.c b/mm/thrash.c
> index 14c6c9f..0c4f0a8 100644
> --- a/mm/thrash.c
> +++ b/mm/thrash.c
> @@ -47,6 +47,9 @@ void grab_swap_token(struct mm_struct *mm)
>  	if (!swap_token_mm)
>  		goto replace_token;
> 
> +	if (!(global_faults & 0xff))
> +		mm->token_priority /= 2;
> +

I personally don't like this kind of checking counter with mask.
Hmm. How about this ?

==
	#define TOKEN_AGE_MASK	~(0xff)
	/*
	 * If current global_fault is in different age from previous global_fault,
	 * Aging priority and starts new era.
	 */
	if ((mm->faultstamp & TOKEN_AGE_MASK) != (global_faults & MM_TOKEN_MASK))
		mm->token_priority /= 2;
==

But I'm not sure 0xff is a proper value or not...

Thanks,
-Kame


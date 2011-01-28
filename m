Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592Ab1A1FhR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 00:37:17 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:60062 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab1A1FhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 00:37:16 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=mqxvRrgu12IA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=viPnuUhvq8mc9a2Po1IA:9 a=kFjuDuR1DJDOYXuwFdR6um2TwFAA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 08/12] tracing/filter: Optimize short ciruit check
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <20110128043345.224997318@goodmis.org>
References: <20110128042118.561146147@goodmis.org>
	 <20110128043345.224997318@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 28 Jan 2011 00:37:13 -0500
Message-ID: <1296193033.10144.98.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-27 at 23:21 -0500, Steven Rostedt wrote:

> diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
> index 2677924..afe59ab 100644
> --- a/kernel/trace/trace_events_filter.c
> +++ b/kernel/trace/trace_events_filter.c
> @@ -426,9 +426,15 @@ int filter_match_preds(struct event_filter *filter, void *rec)
>  					       pred->parent, &move);
>  			continue;
>  		case MOVE_UP_FROM_LEFT:
> -			/* Check for short circuits */
> -			if ((match && pred->op == OP_OR) ||
> -			    (!match && pred->op == OP_AND)) {
> +			/*
> +			 * Check for short circuits.
> +			 *
> +			 * Optimization: !!match == (pred->op == OP_OR)
> +			 *   is the same as:
> +			 * if ((match && pred->op == OP_OR) ||
> +			 *     (!match && pred->op == OP_AND))
> +			 */
> +			if (!!match == (pred->op == OP_OR))

+                                                             {

Bah! I tested these in quilt and when I pulled them into git, I must
have accidentally deleted the '{' in the patch :-p

Thanks goodness this was only a RFC ;)

/me goes to rebase

-- Steve

>  				if (pred == root)
>  					break;
>  				pred = get_pred_parent(pred, preds,



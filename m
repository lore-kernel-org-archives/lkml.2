Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab1HJVOc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 17:14:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:53777 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941Ab1HJVOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 17:14:31 -0400
X-Authority-Analysis: v=1.1 cv=sbbt6Wn8j+VvNVI1Ftt/uHhinWyuFt+R57MN9Ty2Tys= c=1 sm=0 a=l9gFkNDSZusA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=W4PfQ-7MLw6kV6gEiV8A:9 a=pln2nVSROM2cTgEqBBEA:7 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 09/10] tracing/filter: Change filter_match_preds
 function to use walk_pred_tree
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <1312452506-5100-10-git-send-email-jolsa@redhat.com>
References: <1312452506-5100-1-git-send-email-jolsa@redhat.com>
	 <1312452506-5100-10-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 10 Aug 2011 17:14:29 -0400
Message-ID: <1313010869.18583.274.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-04 at 12:08 +0200, Jiri Olsa wrote:
> Changing filter_match_preds function to use unified predicates tree
> processing.
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  kernel/trace/trace_events_filter.c |  119 +++++++++++++++++-------------------
>  1 files changed, 55 insertions(+), 64 deletions(-)
> 
> diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
> index d4e0c09..55b13b9 100644
> --- a/kernel/trace/trace_events_filter.c
> +++ b/kernel/trace/trace_events_filter.c
> @@ -467,6 +467,7 @@ static int process_ops(struct filter_pred *preds,
>  
>  	for (i = 0; i < op->val; i++) {
>  		pred = &preds[op->ops[i]];
> +		BUG_ON(!pred->fn);

Why the added BUG_ON()s? Do we really need to crash the kernel on error
here?

-- Steve

>  		match = pred->fn(pred, rec);
>  		if (!!match == type)
>  			return match;
> @@ -474,92 +475,82 @@ static int process_ops(struct filter_pred *preds,
>  	return match;
>  }
>  
> +struct filter_match_preds_data {
> +	struct filter_pred *preds;
> +	int match;
> +	void *rec;
> +};
> +
> +static int filter_match_preds_cb(enum move_type move, struct filter_pred *pred,
> +				 int *err, void *data)
> +{
> +	struct filter_match_preds_data *d = data;
> +
> +	*err = 0;
> +	switch (move) {
> +	case MOVE_DOWN:
> +		/* only AND and OR have children */
> +		if (pred->left != FILTER_PRED_INVALID) {
> +			/* If ops is set, then it was folded. */
> +			if (!pred->ops)
> +				return WALK_PRED_DEFAULT;
> +			/* We can treat folded ops as a leaf node */
> +			d->match = process_ops(d->preds, pred, d->rec);
> +		} else {
> +			BUG_ON(!pred->fn);
> +			d->match = pred->fn(pred, d->rec);
> +		}



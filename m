Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976Ab1HJVGC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 17:06:02 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:43016 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963Ab1HJVGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 17:06:00 -0400
X-Authority-Analysis: v=1.1 cv=YhhhcVvq/Bf3xBNEvzTEV9JHGW2mXul7kEbaqsyQnMQ= c=1 sm=0 a=PKQHljGB0YUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=7Lq4m09SG7u2NAY-s-IA:9 a=2FA0Y1kJdl0KZBOh2E8A:7 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 06/10] tracing/filter: Change count_leafs function to
 use walk_pred_tree
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <1312452506-5100-7-git-send-email-jolsa@redhat.com>
References: <1312452506-5100-1-git-send-email-jolsa@redhat.com>
	 <1312452506-5100-7-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 10 Aug 2011 17:05:58 -0400
Message-ID: <1313010358.18583.273.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I really like these two patches (5 and 6) as I hated the duplicate code
of the two tree walks. But... see below.


On Thu, 2011-08-04 at 12:08 +0200, Jiri Olsa wrote:
> Changing count_leafs function to use unified predicates tree
> processing.
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  kernel/trace/trace_events_filter.c |   45 +++++++++--------------------------
>  1 files changed, 12 insertions(+), 33 deletions(-)
> 
> diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
> index 5b889d4..14a9dad 100644
> --- a/kernel/trace/trace_events_filter.c
> +++ b/kernel/trace/trace_events_filter.c
> @@ -1418,43 +1418,22 @@ static int check_pred_tree(struct event_filter *filter,
>  			      check_pred_tree_cb, &data);
>  }
>  
> -static int count_leafs(struct filter_pred *preds, struct filter_pred *root)
> +static int count_leafs_cb(enum move_type move, struct filter_pred *pred,
> +			  int *err, void *data)
>  {
> -	struct filter_pred *pred;
> -	enum move_type move = MOVE_DOWN;
> -	int count = 0;
> -	int done = 0;
> +	int *count = data;
>  
> -	pred = root;
> +	if ((move == MOVE_DOWN) &&
> +	    (pred->left == FILTER_PRED_INVALID))
> +		(*count)++;
>  
> -	do {
> -		switch (move) {
> -		case MOVE_DOWN:
> -			if (pred->left != FILTER_PRED_INVALID) {
> -				pred = &preds[pred->left];
> -				continue;
> -			}
> -			/* A leaf at the root is just a leaf in the tree */
> -			if (pred == root)
> -				return 1;
> -			count++;
> -			pred = get_pred_parent(pred, preds,
> -					       pred->parent, &move);
> -			continue;
> -		case MOVE_UP_FROM_LEFT:
> -			pred = &preds[pred->right];
> -			move = MOVE_DOWN;
> -			continue;
> -		case MOVE_UP_FROM_RIGHT:
> -			if (pred == root)
> -				break;
> -			pred = get_pred_parent(pred, preds,
> -					       pred->parent, &move);
> -			continue;
> -		}
> -		done = 1;
> -	} while (!done);
> +	return WALK_PRED_DEFAULT;
> +}
>  
> +static int count_leafs(struct filter_pred *preds, struct filter_pred *root)
> +{
> +	int count = 0;
> +	WARN_ON(walk_pred_tree(preds, root, count_leafs_cb, &count));

Please do not put functionality in a WARN_ON(). Some people have
WARN_ON() turn into nops.

Make this a:

	ret = walk_pred_tree(preds, root, count_leafs_cb, &count);
	WARN_ON(ret);

-- Steve

>  	return count;
>  }
>  



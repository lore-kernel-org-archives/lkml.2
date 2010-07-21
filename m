Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182Ab0GUTlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 15:41:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59262 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758869Ab0GUTk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 15:40:59 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, nauman@google.com,
        dpshah@google.com, guijianfeng@cn.fujitsu.com, czoccolo@gmail.com
Subject: Re: [PATCH 2/3] cfq-iosched: Implement a tunable group_idle
References: <1279739181-24482-1-git-send-email-vgoyal@redhat.com>
	<1279739181-24482-3-git-send-email-vgoyal@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 21 Jul 2010 15:40:44 -0400
In-Reply-To: <1279739181-24482-3-git-send-email-vgoyal@redhat.com> (Vivek
	Goyal's message of "Wed, 21 Jul 2010 15:06:20 -0400")
Message-ID: <x49bpa0d3nn.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> o Implement a new tunable group_idle, which allows idling on the group
>   instead of a cfq queue. Hence one can set slice_idle = 0 and not idle
>   on the individual queues but idle on the group. This way on fast storage
>   we can get fairness between groups at the same time overall throughput
>   improves.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
[snip]
> @@ -1929,13 +1941,21 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
>  		return;
>  	}
>  
> +	/* There are other queues in the group, don't do group idle */
> +	if (group_idle && cfqq->cfqg->nr_cfqq > 1)
> +		return;
> +
>  	cfq_mark_cfqq_wait_request(cfqq);
>  
> -	sl = cfqd->cfq_slice_idle;
> +	if (group_idle)
> +		sl = cfqd->cfq_group_idle;
> +	else
> +		sl = cfqd->cfq_slice_idle;

What happens when both group_idle and slice_idle are set?  Is that a
sane thing to do from a user's perspective?  If not, please protect
against it in the configuration code.  If so, then explain why we prefer
group_idle here, but slice_idle in completed request for the extend_sl:

> @@ -3425,7 +3458,10 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
>  		 * the queue.
>  		 */
>  		if (cfq_should_wait_busy(cfqd, cfqq)) {
> -			cfqq->slice_end = jiffies + cfqd->cfq_slice_idle;
> +			unsigned long extend_sl = cfqd->cfq_slice_idle;
> +			if (!cfqd->cfq_slice_idle)
> +				extend_sl = cfqd->cfq_group_idle;
> +			cfqq->slice_end = jiffies + extend_sl;

Also, you'll need to add documentation for this new tunable.

Cheers,
Jeff

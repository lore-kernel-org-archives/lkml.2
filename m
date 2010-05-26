Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934Ab0EZTnH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 15:43:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61455 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755994Ab0EZTnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 15:43:03 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [PATCH]cfq-iosched: fix an oops caused by slab leak
References: <20100525011849.GA29820@sli10-desk.sh.intel.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 26 May 2010 15:42:57 -0400
In-Reply-To: <20100525011849.GA29820@sli10-desk.sh.intel.com> (Shaohua Li's
	message of "Tue, 25 May 2010 09:18:49 +0800")
Message-ID: <x49fx1ea1q6.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shaohua Li <shaohua.li@intel.com> writes:

> I got below oops when unloading cfq-iosched. Considering scenario:
> queue A merge to B, C merge to D and B will be merged to D. Before B is merged
> to D, we do split B. We should put B's reference for D.
[...]
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
>
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index ed897b5..855fd5f 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -2537,15 +2537,10 @@ static void cfq_free_io_context(struct io_context *ioc)
>  	__call_for_each_cic(ioc, cic_free_func);
>  }
>  
> -static void cfq_exit_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq)
> +static void cfq_put_cooperator(struct cfq_queue *cfqq)
>  {
>  	struct cfq_queue *__cfqq, *next;
>  
> -	if (unlikely(cfqq == cfqd->active_queue)) {
> -		__cfq_slice_expired(cfqd, cfqq, 0);
> -		cfq_schedule_dispatch(cfqd);
> -	}
> -
>  	/*
>  	 * If this queue was scheduled to merge with another queue, be
>  	 * sure to drop the reference taken on that queue (and others in
> @@ -2561,6 +2556,16 @@ static void cfq_exit_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>  		cfq_put_queue(__cfqq);
>  		__cfqq = next;
>  	}
> +}
> +
> +static void cfq_exit_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq)
> +{
> +	if (unlikely(cfqq == cfqd->active_queue)) {
> +		__cfq_slice_expired(cfqd, cfqq, 0);
> +		cfq_schedule_dispatch(cfqd);
> +	}
> +
> +	cfq_put_cooperator(cfqq);
>  
>  	cfq_put_queue(cfqq);
>  }
> @@ -3516,6 +3521,9 @@ split_cfqq(struct cfq_io_context *cic, struct cfq_queue *cfqq)
>  	}
>  
>  	cic_set_cfqq(cic, NULL, 1);
> +
> +	cfq_put_cooperator(cfqq);
> +
>  	cfq_put_queue(cfqq);
>  	return NULL;
>  }

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

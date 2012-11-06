Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767Ab2KFMFn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 07:05:43 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46418 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab2KFMFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 07:05:41 -0500
Date: Tue, 6 Nov 2012 07:05:23 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Jarod Wilson <jarod@redhat.com>
Cc: linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Matt Mackall <mpm@selenic.com>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] random: prime last_data value per fips requirements
Message-ID: <20121106120523.GA2805@hmsreliant.think-freely.org>
References: <1352149210-4790-1-git-send-email-jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352149210-4790-1-git-send-email-jarod@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2012 at 04:00:10PM -0500, Jarod Wilson wrote:
> The value stored in last_data must be primed for FIPS 140-2 purposes. Upon
> first use, either on system startup or after an RNDCLEARPOOL ioctl, we
> need to take an initial random sample, store it internally in last_data,
> then pass along the value after that to the requester, so that consistency
> checks aren't being run against stale and possibly known data.
> 
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: "David S. Miller" <davem@davemloft.net>
> CC: Neil Horman <nhorman@tuxdriver.com>
> CC: Matt Mackall <mpm@selenic.com>
> CC: linux-crypto@vger.kernel.org
> Signed-off-by: Jarod Wilson <jarod@redhat.com>
> ---
>  drivers/char/random.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index b86eae9..24d17b8 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -437,6 +437,7 @@ struct entropy_store {
>  	int entropy_count;
>  	int entropy_total;
>  	unsigned int initialized:1;
> +	bool last_data_init;
>  	__u8 last_data[EXTRACT_SIZE];
>  };
>  
> @@ -967,6 +968,15 @@ static ssize_t extract_entropy(struct entropy_store *r, void *buf,
>  		if (fips_enabled) {
>  			unsigned long flags;
>  
> +			/* prime last_data value if need be, per fips 140-2 */
> +			if (!r->last_data_init) {
> +				spin_lock_irqsave(&r->lock, flags);
> +				memcpy(r->last_data, tmp, EXTRACT_SIZE);
> +				r->last_data_init = true;
> +				spin_unlock_irqrestore(&r->lock, flags);
> +				continue;
Continue?  Is that left over from earlier work?  Or did you have some other
purpose in mind for it?

Also, not that its in a hot path or anything, but it might be nice to
consolodate this code such that you only lock and unlock r->flags once instead
of twice here.

Best
Neil

> +			}
> +
>  			spin_lock_irqsave(&r->lock, flags);
>  			if (!memcmp(tmp, r->last_data, EXTRACT_SIZE))
>  				panic("Hardware RNG duplicated output!\n");
> @@ -1086,6 +1096,7 @@ static void init_std_data(struct entropy_store *r)
>  
>  	r->entropy_count = 0;
>  	r->entropy_total = 0;
> +	r->last_data_init = false;
>  	mix_pool_bytes(r, &now, sizeof(now), NULL);
>  	for (i = r->poolinfo->POOLBYTES; i > 0; i -= sizeof(rv)) {
>  		if (!arch_get_random_long(&rv))
> -- 
> 1.7.1
> 
> 

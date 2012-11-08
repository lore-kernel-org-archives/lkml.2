Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab2KHLK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 06:10:27 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:44107 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab2KHLK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 06:10:26 -0500
Date: Thu, 8 Nov 2012 11:15:26 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Neil Brown <neilb@suse.de>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] raid5: panic() on dma_wait_for_async_tx() error
Message-ID: <20121108111526.40c705a0@pyramind.ukuu.org.uk>
In-Reply-To: <201211081106.29980.b.zolnierkie@samsung.com>
References: <201211081106.29980.b.zolnierkie@samsung.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Nov 2012 11:06:29 +0100
Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com> wrote:

> From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Subject: [PATCH] raid5: panic() on dma_wait_for_async_tx() error
> 
> There is not much we can do on dma_wait_for_async_tx() error
> so just panic() for now.
> 
> Cc: Neil Brown <neilb@suse.de>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Tomasz Figa <t.figa@samsung.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/md/raid5.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> Index: b/drivers/md/raid5.c
> ===================================================================
> --- a/drivers/md/raid5.c	2012-11-07 16:25:19.480876012 +0100
> +++ b/drivers/md/raid5.c	2012-11-07 16:27:46.244875992 +0100
> @@ -3223,7 +3223,9 @@ static void handle_stripe_expansion(stru
>  	/* done submitting copies, wait for them to complete */
>  	if (tx) {
>  		async_tx_ack(tx);
> -		dma_wait_for_async_tx(tx);
> +		if (dma_wait_for_async_tx(tx) != DMA_SUCCESS)
> +			panic("%s: DMA error waiting for transaction\n",
> +			      __func__);

Thats a really horrible place to panic.

Alan

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab2KHLXa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 06:23:30 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:21977 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348Ab2KHLX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 06:23:27 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-80-509b962e5569
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] raid5: panic() on dma_wait_for_async_tx() error
Date: Thu, 08 Nov 2012 12:20:55 +0100
User-Agent: KMail/1.13.2 (Linux/3.5.0-rc2+; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Neil Brown <neilb@suse.de>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
References: <201211081106.29980.b.zolnierkie@samsung.com>
 <20121108111526.40c705a0@pyramind.ukuu.org.uk>
In-reply-to: <20121108111526.40c705a0@pyramind.ukuu.org.uk>
MIME-version: 1.0
Content-type: Text/Plain; charset=us-ascii
Content-transfer-encoding: 7bit
Message-id: <201211081220.55281.b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsVy+t9jQV29abMDDNYs5LS4vGsOm0X7/F2M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGV8fr2BueAsb8Xap2tYGhj7uLsYOTkkBEwk/rU+Y4Ow
	xSQu3FsPZHNxCAlMZ5Q4duU4K4TTwiRxdOUfVpAqNgEriYntqxhBbBEBdYmpK6aDdQsLuEg8
	v/MErIZFQFVi/rx7YHFRAQeJzqkTwKYyC7xilJh65ABQMwfQ1CyJy6viQGo4Bawl1l38wwxi
	8woISvyYfI8FxGYW0JJofrOJEcKWl9i85i1UjaXE6l1HGCcwCsxC0jILScssJC0LGJlXMYqm
	FiQXFCel5xrqFSfmFpfmpesl5+duYgQH4zOpHYwrGywOMQpwMCrx8GpIzg4QYk0sK67MPcQo
	wcGsJMLLMQEoxJuSWFmVWpQfX1Sak1p8iFGag0VJnLfZIyVASCA9sSQ1OzW1ILUIJsvEwSnV
	wGjW+XmLxg2d64t5s8RCVkdtebf81EfF2jOL5ZX2q03bekAoc8Xj0/cKjpeyJIa/Xs2w7Ob8
	q78snq3IOLj2ctXu/n83Vn39+J7PYKFR2aOZl7PEfYrPX+7d5n/r12fP1cGRsYmTbpZNf3qi
	VXXvD4kUdV652IS9K6dKbecMvXnC4qJuZ+bOB93RSizFGYmGWsxFxYkA0VAmo0ICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 November 2012 12:15:26 Alan Cox wrote:
> On Thu, 08 Nov 2012 11:06:29 +0100
> Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com> wrote:
> 
> > From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > Subject: [PATCH] raid5: panic() on dma_wait_for_async_tx() error
> > 
> > There is not much we can do on dma_wait_for_async_tx() error
> > so just panic() for now.
> > 
> > Cc: Neil Brown <neilb@suse.de>
> > Cc: Vinod Koul <vinod.koul@intel.com>
> > Cc: Dan Williams <djbw@fb.com>
> > Cc: Tomasz Figa <t.figa@samsung.com>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  drivers/md/raid5.c |    4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > Index: b/drivers/md/raid5.c
> > ===================================================================
> > --- a/drivers/md/raid5.c	2012-11-07 16:25:19.480876012 +0100
> > +++ b/drivers/md/raid5.c	2012-11-07 16:27:46.244875992 +0100
> > @@ -3223,7 +3223,9 @@ static void handle_stripe_expansion(stru
> >  	/* done submitting copies, wait for them to complete */
> >  	if (tx) {
> >  		async_tx_ack(tx);
> > -		dma_wait_for_async_tx(tx);
> > +		if (dma_wait_for_async_tx(tx) != DMA_SUCCESS)
> > +			panic("%s: DMA error waiting for transaction\n",
> > +			      __func__);
> 
> Thats a really horrible place to panic.

Still it seems better thing to do than silently ignoring errors
and trying to continue operations with inconsistent data.

Unfortunately higher-layers don't support error conditions and
fixing them seems to be non-trivial task.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung Poland R&D Center

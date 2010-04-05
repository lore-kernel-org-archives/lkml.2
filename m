Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab0DEKzj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 06:55:39 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:42289 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751735Ab0DEKzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 06:55:33 -0400
X-Greylist: delayed 2532 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Apr 2010 06:55:33 EDT
Date: Mon, 5 Apr 2010 18:13:13 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
       lkml <linux-kernel@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH ide#master] ide: clean up timed out request handling
Message-ID: <20100405101313.GA17322@gondor.apana.org.au>
References: <4BB9AAB7.3020209@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BB9AAB7.3020209@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 05, 2010 at 06:17:43PM +0900, Tejun Heo wrote:
> 8f6205cd572fece673da0255d74843680f67f879 introduced a bug where a
> timed out DMA request is never requeued and lost.
> 6072f7491f5ef391a575e18a1165e72a3eef1601 fixed this by making
> ide_dma_timeout_retry() requeue the request itself.  While the fix is
> correct, it makes DMA and non-DMA paths asymmetric regarding how the
> in flight request is requeued.
> 
> As long as hwif->rq is set, the IDE driver is assuming ownership of
> the request and the request should either be completed or requeued
> when clearing hwif->rq.  In the timeout path, the ide driver holds
> onto the request as long as the recovery action (ie. reset) is in
> progress and clears it after the state machine is stopped (ide_stopped
> return), so the existing requeueing logic is correct.  The bug
> occurred because ide_dma_timeout_retry() explicitly clears hwif->rq
> without requeueing it.
> 
> ide_dma_timeout_retry() is called only by ide_timer_expiry() and
> returns ide_started only when ide_error() would return it - ie. after
> reset state machine has started in which case the state machine will
> eventually end up executing the ide_stopped path in ide_timer_expiry()
> after reset protocol is complete.  So, there is no need to clear
> hwif->rq from ide_dma_timeout_retry().  ide_timer_expiry() will handle
> it the same way as PIO timeout path.
> 
> Kill hwif->rq clearing and requeueing from ide_dma_timeout_retry() and
> let ide_timer_expiry() deal with it.  The end result should remain the
> same.
> 
> grepping shows ide_dma_timeout_retry() is the only site which clears
> hwif->rq without taking care of the request, so there shouldn't be
> similar fallouts.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
> Herbert, can you please test this survives your test case?

I'll put it on my test machine.

However, as this bug triggers rarely (it's a race condition between
qemu and ide), I don't expect a negative result any time soon.

In any case, your patch looks good to me.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989Ab2K1EWN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 23:22:13 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:45421 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab2K1EWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 23:22:13 -0500
X-AuditID: 9c930197-b7bd3ae000003f1c-1e-50b59173bb66
Date: Wed, 28 Nov 2012 13:22:11 +0900
From: Minchan Kim <minchan@kernel.org>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Jerome Marchand <jmarchan@redhat.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 2/2] zram: allocate metadata when disksize is set up
Message-ID: <20121128042211.GB23136@blaptop>
References: <1353638567-3981-1-git-send-email-minchan@kernel.org>
 <1353638567-3981-2-git-send-email-minchan@kernel.org>
 <50B44BF4.30803@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50B44BF4.30803@vflare.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 09:13:24PM -0800, Nitin Gupta wrote:
> On 11/22/2012 06:42 PM, Minchan Kim wrote:
> >Lockdep complains about recursive deadlock of zram->init_lock.
> >Because zram_init_device could be called in reclaim context and
> >it requires a page with GFP_KERNEL.
> >
> >We can fix it via replacing GFP_KERNEL with GFP_NOIO.
> >But more big problem is vzalloc in zram_init_device which calls GFP_KERNEL.
> >We can change it with __vmalloc which can receive gfp_t.
> >But still we have a problem. Although __vmalloc can handle gfp_t, it calls
> >allocation of GFP_KERNEL. That's why I sent the patch.
> >https://lkml.org/lkml/2012/4/23/77
> >
> >Yes. Fundamental problem is utter crap API vmalloc.
> >If we can fix it, everyone would be happy. But life isn't simple
> >like seeing my thread of the patch.
> >
> >So next option is to give up lazy initialization and initialize it at the
> >very disksize setting time. But it makes unnecessary metadata waste until
> >zram is really used. But let's think about it.
> >
> >1) User of zram normally do mkfs.xxx or mkswap before using
> >    the zram block device(ex, normally, do it at booting time)
> >    It ends up allocating such metadata of zram before real usage so
> >    benefit of lazy initialzation would be mitigated.
> >
> >2) Some user want to use zram when memory pressure is high.(ie, load zram
> >    dynamically, NOT booting time). It does make sense because people don't
> >    want to waste memory until memory pressure is high(ie, where zram is really
> >    helpful time). In this case, lazy initialzation could be failed easily
> >    because we will use GFP_NOIO instead of GFP_KERNEL for avoiding deadlock.
> >    So the benefit of lazy initialzation would be mitigated, too.
> >
> >3) Metadata overhead is not critical and Nitin has a plan to diet it.
> >    4K : 12 byte(64bit machine) -> 64G : 192M so 0.3% isn't big overhead
> >    If insane user use such big zram device up to 20, it could consume 6% of ram
> >    but efficieny of zram will cover the waste.
> >
> >So this patch gives up lazy initialization and instead we initialize metadata
> >at disksize setting time.
> >
> >Signed-off-by: Minchan Kim <minchan@kernel.org>
> >---
> >  drivers/staging/zram/zram_drv.c   |   21 ++++-----------------
> >  drivers/staging/zram/zram_sysfs.c |    1 +
> >  2 files changed, 5 insertions(+), 17 deletions(-)
> >
> >diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
> >index 9ef1eca..f364fb5 100644
> >--- a/drivers/staging/zram/zram_drv.c
> >+++ b/drivers/staging/zram/zram_drv.c
> >@@ -441,16 +441,13 @@ static void zram_make_request(struct request_queue *queue, struct bio *bio)
> >  {
> >  	struct zram *zram = queue->queuedata;
> >
> >-	if (unlikely(!zram->init_done) && zram_init_device(zram))
> >-		goto error;
> >-
> >  	down_read(&zram->init_lock);
> >  	if (unlikely(!zram->init_done))
> >-		goto error_unlock;
> >+		goto error;
> >
> >  	if (!valid_io_request(zram, bio)) {
> >  		zram_stat64_inc(zram, &zram->stats.invalid_io);
> >-		goto error_unlock;
> >+		goto error;
> >  	}
> >
> >  	__zram_make_request(zram, bio, bio_data_dir(bio));
> >@@ -458,9 +455,8 @@ static void zram_make_request(struct request_queue *queue, struct bio *bio)
> >
> >  	return;
> >
> >-error_unlock:
> >-	up_read(&zram->init_lock);
> >  error:
> >+	up_read(&zram->init_lock);
> >  	bio_io_error(bio);
> >  }
> >
> >@@ -509,19 +505,12 @@ void zram_reset_device(struct zram *zram)
> >  	up_write(&zram->init_lock);
> >  }
> >
> >+/* zram->init_lock should be hold */
> 
> s/hold/held

Done.

> 
> btw, shouldn't we also change GFP_KERNEL to GFP_NOIO in
> is_partial_io() case in both read/write handlers?

Absolutely. The previous patch isn't complete but sent by mistake.
Sorry for the noise.
I just sent new patch.

Thanks.

-- 
Kind regards,
Minchan Kim

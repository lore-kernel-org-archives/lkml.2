Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab1FCHJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 03:09:51 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:54214 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135Ab1FCHJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 03:09:50 -0400
Message-ID: <4DE888BB.8000008@msgid.corpit.ru>
Date: Fri, 03 Jun 2011 11:09:47 +0400
From: lists+linux-kernel@corpit.ru
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.16) Gecko/20110506 Icedove/3.0.11
MIME-Version: 1.0
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
CC: James.Bottomley@HansenPartnership.com, Jens Axboe <axboe@kernel.dk>,
        greg@kroah.com, jslaby@suse.cz, stable@kernel.org,
        jejb@parisc-linux.org, linux-kernel@vger.kernel.org
Subject: Re: [stable] apparent regression (crash) - 2.6.38.6
References: <20110511193451.GC26010@kroah.com>	<20110519002505.GB8697@kroah.com>	<1305776367.2576.0.camel@mulgrave.site> <20110601.213424.80025869.anemo@mba.ocn.ne.jp> <4DE886D1.8090807@msgid.tls.msk.ru>
In-Reply-To: <4DE886D1.8090807@msgid.tls.msk.ru>
X-Enigmail-Version: 1.0.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

03.06.2011 11:01, Michael Tokarev wrote:
> commit 2e8532e0a9ee1d25b279ac78ee8ce31701e2aa15
> Author: Michael Tokarev <mjt@tls.msk.ru>
> Date:   Fri Jun 3 10:50:49 2011 +0400
> 
>     block: add proper state guards to elv_queue_empty()
> 
>     Like in 0a58e077eb600d1efd7e54ad9926a75a39d7f8ae (backported to
>     stable 2.6.38 as 0a58e077eb600d1efd7e54ad9926a75a39d7f8ae) which
>     fixes this for __elv_next_request(), as reported by Atsushi Nemoto,
>     elv_queue_empty() also needs to check for dead queue condition
>     before touchin elevator.
> 
>     elv_queue_empty() has been removed upstream so this is only applicable
>     for versions prior to 2.6.39, including 2.6.32-longterm.

Um, i'm not sure about this one -- 2.6.32 does not have
other pieces of this puzzle (and 2.6.38.8 was the last
in the 2.6.38.y series).

/mjt

>     Signed-Off-By: Michael Tokarev <mjt@tls.msk.ru>
> 
> diff --git a/block/elevator.c b/block/elevator.c
> index 236e93c..30cec25 100644
> --- a/block/elevator.c
> +++ b/block/elevator.c
> @@ -727,7 +727,8 @@ int elv_queue_empty(struct request_queue *q)
>  	if (!list_empty(&q->queue_head))
>  		return 0;
> 
> -	if (e->ops->elevator_queue_empty_fn)
> +	if (!test_bit(QUEUE_FLAG_DEAD, &q->queue_flags) &&
> +	    e->ops->elevator_queue_empty_fn)
>  		return e->ops->elevator_queue_empty_fn(q);
> 
>  	return 1;

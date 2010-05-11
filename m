Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083Ab0EKOMY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 10:12:24 -0400
Received: from mx1.emlix.com ([193.175.82.87]:56745 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449Ab0EKOMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 10:12:22 -0400
From: "Oskar Schirmer" <os@emlix.com>
Date: Tue, 11 May 2010 16:12:11 +0200
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oskar Schirmer <os@emlix.com>,
       Michael Hennerich <Michael.Hennerich@analog.com>,
       Mike Frysinger <vapier@gentoo.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Daniel =?utf-8?B?R2zDtmNrbmVy?= <dg@emlix.com>,
       Oliver Schneidewind <osw@emlix.com>, Johannes Weiner <jw@emlix.com>
Subject: Re: [PATCH v3] ad7877: keep dma rx buffers in seperate cache lines
Message-ID: <20100511141210.GA28765@emlix.com>
References: <1273487642-2169-1-git-send-email-os@emlix.com>
 <1273488154-2993-1-git-send-email-os@emlix.com>
 <20100510142225.4bf215ef.akpm@linux-foundation.org>
 <20100511060547.GA9644@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100511060547.GA9644@core.coreip.homeip.net>
Organization: emlix GmbH
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 10, 2010 at 23:05:47 -0700, Dmitry Torokhov wrote:
> OK, then I have the following which I will apply unless someone shouts.

Looks good, we tested it on G45, works fine.

  Oskar


> -- 
> Dmitry
> 
> Input: ad7877 - keep dma rx buffers in seperate cache lines
> 
> From: Oskar Schirmer <os@emlix.com>
> 
> With dma based spi transmission, data corruption is observed
> occasionally. With dma buffers located right next to msg and
> xfer fields, cache lines correctly flushed in preparation for
> dma usage may be polluted again when writing to fields in the
> same cache line.
> 
> Make sure cache fields used with dma do not share cache lines
> with fields changed during dma handling. As both fields are part
> of a struct that is allocated via kzalloc, thus cache aligned,
> moving the fields to the 1st position and insert padding for
> alignment does the job.
> 
> Signed-off-by: Oskar Schirmer <os@emlix.com>
> Signed-off-by: Daniel Glöckner <dg@emlix.com>
> Signed-off-by: Oliver Schneidewind <osw@emlix.com>
> Signed-off-by: Johannes Weiner <jw@emlix.com>
> Acked-by: Mike Frysinger <vapier@gentoo.org>
> [dtor@mail.ru - changed to use ___cacheline_aligned at suggestion
>  of akpm]
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> ---
> 
>  drivers/input/touchscreen/ad7877.c |   15 ++++++++++++---
>  1 files changed, 12 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/drivers/input/touchscreen/ad7877.c b/drivers/input/touchscreen/ad7877.c
> index e019d53..0d2d7e5 100644
> --- a/drivers/input/touchscreen/ad7877.c
> +++ b/drivers/input/touchscreen/ad7877.c
> @@ -156,9 +156,14 @@ struct ser_req {
>  	u16			reset;
>  	u16			ref_on;
>  	u16			command;
> -	u16			sample;
>  	struct spi_message	msg;
>  	struct spi_transfer	xfer[6];
> +
> +	/*
> +	 * DMA (thus cache coherency maintenance) requires the
> +	 * transfer buffers to live in their own cache lines.
> +	 */
> +	u16 sample ____cacheline_aligned;
>  };
>  
>  struct ad7877 {
> @@ -182,8 +187,6 @@ struct ad7877 {
>  	u8			averaging;
>  	u8			pen_down_acc_interval;
>  
> -	u16			conversion_data[AD7877_NR_SENSE];
> -
>  	struct spi_transfer	xfer[AD7877_NR_SENSE + 2];
>  	struct spi_message	msg;
>  
> @@ -195,6 +198,12 @@ struct ad7877 {
>  	spinlock_t		lock;
>  	struct timer_list	timer;		/* P: lock */
>  	unsigned		pending:1;	/* P: lock */
> +
> +	/*
> +	 * DMA (thus cache coherency maintenance) requires the
> +	 * transfer buffers to live in their own cache lines.
> +	 */
> +	u16 conversion_data[AD7877_NR_SENSE] ____cacheline_aligned;
>  };
>  
>  static int gpio3;
> 
> 

-- 
oskar schirmer, emlix gmbh, http://www.emlix.com
fon +49 551 30664-0, fax -11, bahnhofsallee 1b, 37081 göttingen, germany
sitz der gesellschaft: göttingen, amtsgericht göttingen hr b 3160
geschäftsführer: dr. uwe kracke, ust-idnr.: de 205 198 055

emlix - your embedded linux partner

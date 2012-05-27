Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab2E0Lvb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 07:51:31 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:18757 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab2E0Lv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 07:51:28 -0400
Message-ID: <4FC21527.7050705@atmel.com>
Date: Sun, 27 May 2012 13:51:03 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Korsgaard <jacmet@sunsite.dk>, <herbert@gondor.hengli.com.au>
CC: <jamie@jamieiles.com>, <linux-kernel@vger.kernel.org>, <GPontis@z9.com>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] hw_random: atmel-rng: fix race condition leading to repeated
 bits
References: <1337937158-9710-1-git-send-email-jacmet@sunsite.dk>
In-Reply-To: <1337937158-9710-1-git-send-email-jacmet@sunsite.dk>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.24.48.186]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2012 11:12 AM, Peter Korsgaard :
> Data valid gets cleared by reading the ISR (status register) and NOT from
> reading ODATA (data register). A new data word can become available between
> checking ISR and reading ODATA, causing us to reuse the same data word next
> time atmel_trng_read() gets called, if that happens before the following
> data word is ready.
> 
> With this fixed, rngtest no longer complains of 'Continous run' errors.
> Before:
> 
> rngtest -c 1000 < /dev/hwrng
> rngtest 3
> Copyright (c) 2004 by Henrique de Moraes Holschuh
> This is free software; see the source for copying conditions.  There is NO warr.
> 
> rngtest: starting FIPS tests...
> rngtest: bits received from input: 20000032
> rngtest: FIPS 140-2 successes: 923
> rngtest: FIPS 140-2 failures: 77
> rngtest: FIPS 140-2(2001-10-10) Monobit: 0
> rngtest: FIPS 140-2(2001-10-10) Poker: 0
> rngtest: FIPS 140-2(2001-10-10) Runs: 1
> rngtest: FIPS 140-2(2001-10-10) Long run: 0
> rngtest: FIPS 140-2(2001-10-10) Continuous run: 76
> rngtest: input channel speed: (min=721.402; avg=46003.510; max=49321.338)Kibitss
> rngtest: FIPS tests speed: (min=11.442; avg=12.714; max=12.801)Mibits/s
> rngtest: Program run time: 1931860 microseconds
> 
> After:
> 
> rngtest -c 1000 < /dev/hwrng
> rngtest 3
> Copyright (c) 2004 by Henrique de Moraes Holschuh
> This is free software; see the source for copying conditions.  There is NO warr.
> 
> rngtest: starting FIPS tests...
> rngtest: bits received from input: 20000032
> rngtest: FIPS 140-2 successes: 1000
> rngtest: FIPS 140-2 failures: 0
> rngtest: FIPS 140-2(2001-10-10) Monobit: 0
> rngtest: FIPS 140-2(2001-10-10) Poker: 0
> rngtest: FIPS 140-2(2001-10-10) Runs: 0
> rngtest: FIPS 140-2(2001-10-10) Long run: 0
> rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
> rngtest: input channel speed: (min=777.518; avg=36988.482; max=43115.342)Kibitss
> rngtest: FIPS tests speed: (min=11.951; avg=12.715; max=12.887)Mibits/s
> rngtest: Program run time: 2035543 microseconds
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
> Reported-by: George Pontis <GPontis@z9.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Thanks!

> ---
>  drivers/char/hw_random/atmel-rng.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/char/hw_random/atmel-rng.c b/drivers/char/hw_random/atmel-rng.c
> index d7ab920..731c904 100644
> --- a/drivers/char/hw_random/atmel-rng.c
> +++ b/drivers/char/hw_random/atmel-rng.c
> @@ -36,6 +36,13 @@ static int atmel_trng_read(struct hwrng *rng, void *buf, size_t max,
>  	/* data ready? */
>  	if (readl(trng->base + TRNG_ISR) & 1) {
>  		*data = readl(trng->base + TRNG_ODATA);
> +		/*
> +		  ensure data ready is only set again AFTER the next data
> +		  word is ready in case it got set between checking ISR
> +		  and reading ODATA, so we don't risk re-reading the
> +		  same word
> +		*/
> +		readl(trng->base + TRNG_ISR);
>  		return 4;
>  	} else
>  		return 0;


-- 
Nicolas Ferre

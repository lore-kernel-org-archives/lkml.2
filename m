Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab2FKQQB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 12:16:01 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:52893 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049Ab2FKQP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 12:15:59 -0400
Message-ID: <4FD619B9.9070802@atmel.com>
Date: Mon, 11 Jun 2012 18:15:53 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Korsgaard <jacmet@sunsite.dk>, <herbert@gondor.hengli.com.au>
CC: <jamie@jamieiles.com>, <linux-kernel@vger.kernel.org>, <GPontis@z9.com>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] hw_random: atmel-rng: fix data valid check
References: <1337776317-25679-1-git-send-email-jacmet@sunsite.dk> <4FBCDF85.5030707@atmel.com>
In-Reply-To: <4FBCDF85.5030707@atmel.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.159.245.112]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2012 03:00 PM, Nicolas Ferre :
> On 05/23/2012 02:31 PM, Peter Korsgaard :
>> Brown paper bag: Data valid is LSB of the ISR (status register), and NOT
>> of ODATA (current random data word)!
>>
>> With this, rngtest is a lot happier. Before:
>>
>> rngtest 3
>> Copyright (c) 2004 by Henrique de Moraes Holschuh
>> This is free software; see the source for copying conditions.  There is NO warr.
>>
>> rngtest: starting FIPS tests...
>> rngtest: bits received from input: 20000032
>> rngtest: FIPS 140-2 successes: 3
>> rngtest: FIPS 140-2 failures: 997
>> rngtest: FIPS 140-2(2001-10-10) Monobit: 604
>> rngtest: FIPS 140-2(2001-10-10) Poker: 996
>> rngtest: FIPS 140-2(2001-10-10) Runs: 36
>> rngtest: FIPS 140-2(2001-10-10) Long run: 0
>> rngtest: FIPS 140-2(2001-10-10) Continuous run: 117
>> rngtest: input channel speed: (min=622.371; avg=23682.481; max=28224.350)Kibitss
>> rngtest: FIPS tests speed: (min=12.361; avg=12.718; max=12.861)Mibits/s
>> rngtest: Program run time: 2331696 microsecondsx
>>
>> After:
>> rngtest 3
>> Copyright (c) 2004 by Henrique de Moraes Holschuh
>> This is free software; see the source for copying conditions.  There is NO warr.
>>
>> rngtest: starting FIPS tests...
>> rngtest: bits received from input: 20000032
>> rngtest: FIPS 140-2 successes: 999
>> rngtest: FIPS 140-2 failures: 1
>> rngtest: FIPS 140-2(2001-10-10) Monobit: 0
>> rngtest: FIPS 140-2(2001-10-10) Poker: 0
>> rngtest: FIPS 140-2(2001-10-10) Runs: 1
>> rngtest: FIPS 140-2(2001-10-10) Long run: 0
>> rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
>> rngtest: input channel speed: (min=777.363; avg=43588.270; max=47870.711)Kibitss
>> rngtest: FIPS tests speed: (min=11.943; avg=12.716; max=12.844)Mibits/s
>> rngtest: Program run time: 1955282 microseconds
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
>> Reported-by: George Pontis <GPontis@z9.com>
> 
> Indeed, yes ;-)
> 
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Hi Herbert,

It seems that this patch did not make it in your tree before the "other
one" from Peter: in linus' tree: 121daad (hwrng: atmel-rng - fix race
condition leading to repeated bits).

So, do you want me to rebase this patch because it will not apply anymore?

Thanks for your help, best regards,

>> ---
>>  drivers/char/hw_random/atmel-rng.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/char/hw_random/atmel-rng.c b/drivers/char/hw_random/atmel-rng.c
>> index f518b99..d7ab920 100644
>> --- a/drivers/char/hw_random/atmel-rng.c
>> +++ b/drivers/char/hw_random/atmel-rng.c
>> @@ -34,7 +34,7 @@ static int atmel_trng_read(struct hwrng *rng, void *buf, size_t max,
>>  	u32 *data = buf;
>>  
>>  	/* data ready? */
>> -	if (readl(trng->base + TRNG_ODATA) & 1) {
>> +	if (readl(trng->base + TRNG_ISR) & 1) {
>>  		*data = readl(trng->base + TRNG_ODATA);
>>  		return 4;
>>  	} else
> 
> 


-- 
Nicolas Ferre

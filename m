Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932566Ab2FTSdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:33:09 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52480 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932355Ab2FTSXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:23:22 -0400
Message-Id: <20120620173025.042781669@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Date: Wed, 20 Jun 2012 10:31:08 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Peter Korsgaard <jacmet@sunsite.dk>,
        George Pontis <GPontis@z9.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: [ 48/61] hwrng: atmel-rng - fix data valid check
In-Reply-To: <20120620173033.GA5634@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Korsgaard <jacmet@sunsite.dk>

commit c475c06f4bb689d6ad87d7512e036d6dface3160 upstream.

Brown paper bag: Data valid is LSB of the ISR (status register), and NOT
of ODATA (current random data word)!

With this, rngtest is a lot happier. Before:

rngtest 3
Copyright (c) 2004 by Henrique de Moraes Holschuh
This is free software; see the source for copying conditions.  There is NO warr.

rngtest: starting FIPS tests...
rngtest: bits received from input: 20000032
rngtest: FIPS 140-2 successes: 3
rngtest: FIPS 140-2 failures: 997
rngtest: FIPS 140-2(2001-10-10) Monobit: 604
rngtest: FIPS 140-2(2001-10-10) Poker: 996
rngtest: FIPS 140-2(2001-10-10) Runs: 36
rngtest: FIPS 140-2(2001-10-10) Long run: 0
rngtest: FIPS 140-2(2001-10-10) Continuous run: 117
rngtest: input channel speed: (min=622.371; avg=23682.481; max=28224.350)Kibitss
rngtest: FIPS tests speed: (min=12.361; avg=12.718; max=12.861)Mibits/s
rngtest: Program run time: 2331696 microsecondsx

After:
rngtest 3
Copyright (c) 2004 by Henrique de Moraes Holschuh
This is free software; see the source for copying conditions.  There is NO warr.

rngtest: starting FIPS tests...
rngtest: bits received from input: 20000032
rngtest: FIPS 140-2 successes: 999
rngtest: FIPS 140-2 failures: 1
rngtest: FIPS 140-2(2001-10-10) Monobit: 0
rngtest: FIPS 140-2(2001-10-10) Poker: 0
rngtest: FIPS 140-2(2001-10-10) Runs: 1
rngtest: FIPS 140-2(2001-10-10) Long run: 0
rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
rngtest: input channel speed: (min=777.363; avg=43588.270; max=47870.711)Kibitss
rngtest: FIPS tests speed: (min=11.943; avg=12.716; max=12.844)Mibits/s
rngtest: Program run time: 1955282 microseconds

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
Reported-by: George Pontis <GPontis@z9.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/hw_random/atmel-rng.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/hw_random/atmel-rng.c
+++ b/drivers/char/hw_random/atmel-rng.c
@@ -34,7 +34,7 @@ static int atmel_trng_read(struct hwrng
 	u32 *data = buf;
 
 	/* data ready? */
-	if (readl(trng->base + TRNG_ODATA) & 1) {
+	if (readl(trng->base + TRNG_ISR) & 1) {
 		*data = readl(trng->base + TRNG_ODATA);
 		/*
 		  ensure data ready is only set again AFTER the next data



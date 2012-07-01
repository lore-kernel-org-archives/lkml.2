Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932580Ab2GASWZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 14:22:25 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46988 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932347Ab2GASQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:16:39 -0400
Message-Id: <20120701172007.281758582@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 01 Jul 2012 18:20:10 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Peter Korsgaard <jacmet@sunsite.dk>,
        George Pontis <GPontis@z9.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: [ 04/48] hwrng: atmel-rng - fix data valid check
In-Reply-To: <20120701172006.535271340@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/char/hw_random/atmel-rng.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/atmel-rng.c b/drivers/char/hw_random/atmel-rng.c
index 6289f0e..731c904 100644
--- a/drivers/char/hw_random/atmel-rng.c
+++ b/drivers/char/hw_random/atmel-rng.c
@@ -34,7 +34,7 @@ static int atmel_trng_read(struct hwrng *rng, void *buf, size_t max,
 	u32 *data = buf;
 
 	/* data ready? */
-	if (readl(trng->base + TRNG_ODATA) & 1) {
+	if (readl(trng->base + TRNG_ISR) & 1) {
 		*data = readl(trng->base + TRNG_ODATA);
 		/*
 		  ensure data ready is only set again AFTER the next data



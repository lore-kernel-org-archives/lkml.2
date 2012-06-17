Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949Ab2FQSXA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:23:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50152 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757969Ab2FQSWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:22:18 -0400
Message-Id: <20120617175943.772309361@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Jun 2012 18:59:58 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Peter Korsgaard <jacmet@sunsite.dk>,
        George Pontis <GPontis@z9.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: [ 17/69] hwrng: atmel-rng - fix race condition leading to repeated bits
In-Reply-To: <20120617175941.281333656@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Korsgaard <jacmet@sunsite.dk>

commit 121daad8fd1dce63076fa55aaedd5dc3f981b334 upstream.

Data valid gets cleared by reading the ISR (status register) and NOT from
reading ODATA (data register). A new data word can become available between
checking ISR and reading ODATA, causing us to reuse the same data word next
time atmel_trng_read() gets called, if that happens before the following
data word is ready.

With this fixed, rngtest no longer complains of 'Continous run' errors.
Before:

rngtest -c 1000 < /dev/hwrng
rngtest 3
Copyright (c) 2004 by Henrique de Moraes Holschuh
This is free software; see the source for copying conditions.  There is NO warr.

rngtest: starting FIPS tests...
rngtest: bits received from input: 20000032
rngtest: FIPS 140-2 successes: 923
rngtest: FIPS 140-2 failures: 77
rngtest: FIPS 140-2(2001-10-10) Monobit: 0
rngtest: FIPS 140-2(2001-10-10) Poker: 0
rngtest: FIPS 140-2(2001-10-10) Runs: 1
rngtest: FIPS 140-2(2001-10-10) Long run: 0
rngtest: FIPS 140-2(2001-10-10) Continuous run: 76
rngtest: input channel speed: (min=721.402; avg=46003.510; max=49321.338)Kibitss
rngtest: FIPS tests speed: (min=11.442; avg=12.714; max=12.801)Mibits/s
rngtest: Program run time: 1931860 microseconds

After:

rngtest -c 1000 < /dev/hwrng
rngtest 3
Copyright (c) 2004 by Henrique de Moraes Holschuh
This is free software; see the source for copying conditions.  There is NO warr.

rngtest: starting FIPS tests...
rngtest: bits received from input: 20000032
rngtest: FIPS 140-2 successes: 1000
rngtest: FIPS 140-2 failures: 0
rngtest: FIPS 140-2(2001-10-10) Monobit: 0
rngtest: FIPS 140-2(2001-10-10) Poker: 0
rngtest: FIPS 140-2(2001-10-10) Runs: 0
rngtest: FIPS 140-2(2001-10-10) Long run: 0
rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
rngtest: input channel speed: (min=777.518; avg=36988.482; max=43115.342)Kibitss
rngtest: FIPS tests speed: (min=11.951; avg=12.715; max=12.887)Mibits/s
rngtest: Program run time: 2035543 microseconds

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
Reported-by: George Pontis <GPontis@z9.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/char/hw_random/atmel-rng.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/char/hw_random/atmel-rng.c b/drivers/char/hw_random/atmel-rng.c
index f518b99..6289f0e 100644
--- a/drivers/char/hw_random/atmel-rng.c
+++ b/drivers/char/hw_random/atmel-rng.c
@@ -36,6 +36,13 @@ static int atmel_trng_read(struct hwrng *rng, void *buf, size_t max,
 	/* data ready? */
 	if (readl(trng->base + TRNG_ODATA) & 1) {
 		*data = readl(trng->base + TRNG_ODATA);
+		/*
+		  ensure data ready is only set again AFTER the next data
+		  word is ready in case it got set between checking ISR
+		  and reading ODATA, so we don't risk re-reading the
+		  same word
+		*/
+		readl(trng->base + TRNG_ISR);
 		return 4;
 	} else
 		return 0;



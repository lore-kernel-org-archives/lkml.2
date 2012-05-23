Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab2EWMcO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 08:32:14 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:44873 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab2EWMcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 08:32:12 -0400
From: Peter Korsgaard <jacmet@sunsite.dk>
To: herbert@gondor.hengli.com.au, nicolas.ferre@atmel.com, jamie@jamieiles.com,
        linux-kernel@vger.kernel.org, GPontis@z9.com
Cc: Peter Korsgaard <jacmet@sunsite.dk>, stable@vger.kernel.org
Subject: [PATCH] hw_random: atmel-rng: fix data valid check
Date: Wed, 23 May 2012 14:31:57 +0200
Message-Id: <1337776317-25679-1-git-send-email-jacmet@sunsite.dk>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Cc: stable@vger.kernel.org
Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
Reported-by: George Pontis <GPontis@z9.com>
---
 drivers/char/hw_random/atmel-rng.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/atmel-rng.c b/drivers/char/hw_random/atmel-rng.c
index f518b99..d7ab920 100644
--- a/drivers/char/hw_random/atmel-rng.c
+++ b/drivers/char/hw_random/atmel-rng.c
@@ -34,7 +34,7 @@ static int atmel_trng_read(struct hwrng *rng, void *buf, size_t max,
 	u32 *data = buf;
 
 	/* data ready? */
-	if (readl(trng->base + TRNG_ODATA) & 1) {
+	if (readl(trng->base + TRNG_ISR) & 1) {
 		*data = readl(trng->base + TRNG_ODATA);
 		return 4;
 	} else
-- 
1.7.10


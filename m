Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933161Ab2KEVBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 16:01:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932926Ab2KEVBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 16:01:50 -0500
From: Jarod Wilson <jarod@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>, Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Neil Horman <nhorman@tuxdriver.com>, Matt Mackall <mpm@selenic.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH] random: prime last_data value per fips requirements
Date: Mon,  5 Nov 2012 16:00:10 -0500
Message-Id: <1352149210-4790-1-git-send-email-jarod@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The value stored in last_data must be primed for FIPS 140-2 purposes. Upon
first use, either on system startup or after an RNDCLEARPOOL ioctl, we
need to take an initial random sample, store it internally in last_data,
then pass along the value after that to the requester, so that consistency
checks aren't being run against stale and possibly known data.

CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>
CC: Neil Horman <nhorman@tuxdriver.com>
CC: Matt Mackall <mpm@selenic.com>
CC: linux-crypto@vger.kernel.org
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/char/random.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index b86eae9..24d17b8 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -437,6 +437,7 @@ struct entropy_store {
 	int entropy_count;
 	int entropy_total;
 	unsigned int initialized:1;
+	bool last_data_init;
 	__u8 last_data[EXTRACT_SIZE];
 };
 
@@ -967,6 +968,15 @@ static ssize_t extract_entropy(struct entropy_store *r, void *buf,
 		if (fips_enabled) {
 			unsigned long flags;
 
+			/* prime last_data value if need be, per fips 140-2 */
+			if (!r->last_data_init) {
+				spin_lock_irqsave(&r->lock, flags);
+				memcpy(r->last_data, tmp, EXTRACT_SIZE);
+				r->last_data_init = true;
+				spin_unlock_irqrestore(&r->lock, flags);
+				continue;
+			}
+
 			spin_lock_irqsave(&r->lock, flags);
 			if (!memcmp(tmp, r->last_data, EXTRACT_SIZE))
 				panic("Hardware RNG duplicated output!\n");
@@ -1086,6 +1096,7 @@ static void init_std_data(struct entropy_store *r)
 
 	r->entropy_count = 0;
 	r->entropy_total = 0;
+	r->last_data_init = false;
 	mix_pool_bytes(r, &now, sizeof(now), NULL);
 	for (i = r->poolinfo->POOLBYTES; i > 0; i -= sizeof(rv)) {
 		if (!arch_get_random_long(&rv))
-- 
1.7.1


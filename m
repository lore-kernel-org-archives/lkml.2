Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab2KFPnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 10:43:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154Ab2KFPm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 10:42:59 -0500
From: Jarod Wilson <jarod@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>, Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Neil Horman <nhorman@tuxdriver.com>, Matt Mackall <mpm@selenic.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v3] random: prime last_data value per fips requirements
Date: Tue,  6 Nov 2012 10:42:42 -0500
Message-Id: <1352216562-25659-1-git-send-email-jarod@redhat.com>
In-Reply-To: <1352216153-25359-1-git-send-email-jarod@redhat.com>
References: <1352216153-25359-1-git-send-email-jarod@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The value stored in last_data must be primed for FIPS 140-2 purposes. Upon
first use, either on system startup or after an RNDCLEARPOOL ioctl, we
need to take an initial random sample, store it internally in last_data,
then pass along the value after that to the requester, so that consistency
checks aren't being run against stale and possibly known data.

v2: streamline code flow a bit, eliminating extra loop and spinlock in the
case where we need to prime, and account for the extra primer bits.

v3: extract_buf() can't be called with spinlock already held, so bring
back some extra lock/unlock calls.

CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>
CC: Neil Horman <nhorman@tuxdriver.com>
CC: Matt Mackall <mpm@selenic.com>
CC: linux-crypto@vger.kernel.org
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/char/random.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index b86eae9..d0139df 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -437,6 +437,7 @@ struct entropy_store {
 	int entropy_count;
 	int entropy_total;
 	unsigned int initialized:1;
+	bool last_data_init;
 	__u8 last_data[EXTRACT_SIZE];
 };
 
@@ -957,6 +958,10 @@ static ssize_t extract_entropy(struct entropy_store *r, void *buf,
 	ssize_t ret = 0, i;
 	__u8 tmp[EXTRACT_SIZE];
 
+	/* if last_data isn't primed, we need EXTRACT_SIZE extra bytes */
+	if (fips_enabled && !r->last_data_init)
+		nbytes += EXTRACT_SIZE;
+
 	trace_extract_entropy(r->name, nbytes, r->entropy_count, _RET_IP_);
 	xfer_secondary_pool(r, nbytes);
 	nbytes = account(r, nbytes, min, reserved);
@@ -967,6 +972,17 @@ static ssize_t extract_entropy(struct entropy_store *r, void *buf,
 		if (fips_enabled) {
 			unsigned long flags;
 
+
+			/* prime last_data value if need be, per fips 140-2 */
+			if (!r->last_data_init) {
+				spin_lock_irqsave(&r->lock, flags);
+				memcpy(r->last_data, tmp, EXTRACT_SIZE);
+				r->last_data_init = true;
+				nbytes -= EXTRACT_SIZE;
+				spin_unlock_irqrestore(&r->lock, flags);
+				extract_buf(r, tmp);
+			}
+
 			spin_lock_irqsave(&r->lock, flags);
 			if (!memcmp(tmp, r->last_data, EXTRACT_SIZE))
 				panic("Hardware RNG duplicated output!\n");
@@ -1086,6 +1102,7 @@ static void init_std_data(struct entropy_store *r)
 
 	r->entropy_count = 0;
 	r->entropy_total = 0;
+	r->last_data_init = false;
 	mix_pool_bytes(r, &now, sizeof(now), NULL);
 	for (i = r->poolinfo->POOLBYTES; i > 0; i -= sizeof(rv)) {
 		if (!arch_get_random_long(&rv))
-- 
1.7.1


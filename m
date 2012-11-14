Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523Ab2KNFvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 00:51:32 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55342 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932450Ab2KNFvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:51:19 -0500
Message-Id: <20121114053936.947604243@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:39:55 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        Gurucharan Shetty <gurucharan.shetty@gmail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: [ 22/82] crypto: cryptd - disable softirqs in cryptd_queue_worker to prevent
 data corruption
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

commit 9efade1b3e981f5064f9db9ca971b4dc7557ae42 upstream.

cryptd_queue_worker attempts to prevent simultaneous accesses to crypto
workqueue by cryptd_enqueue_request using preempt_disable/preempt_enable.
However cryptd_enqueue_request might be called from softirq context,
so add local_bh_disable/local_bh_enable to prevent data corruption and
panics.

Bug report at http://marc.info/?l=linux-crypto-vger&m=134858649616319&w=2

v2:
 - Disable software interrupts instead of hardware interrupts

Reported-by: Gurucharan Shetty <gurucharan.shetty@gmail.com>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 crypto/cryptd.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 671d4d6..7bdd61b 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -137,13 +137,18 @@ static void cryptd_queue_worker(struct work_struct *work)
 	struct crypto_async_request *req, *backlog;
 
 	cpu_queue = container_of(work, struct cryptd_cpu_queue, work);
-	/* Only handle one request at a time to avoid hogging crypto
-	 * workqueue. preempt_disable/enable is used to prevent
-	 * being preempted by cryptd_enqueue_request() */
+	/*
+	 * Only handle one request at a time to avoid hogging crypto workqueue.
+	 * preempt_disable/enable is used to prevent being preempted by
+	 * cryptd_enqueue_request(). local_bh_disable/enable is used to prevent
+	 * cryptd_enqueue_request() being accessed from software interrupts.
+	 */
+	local_bh_disable();
 	preempt_disable();
 	backlog = crypto_get_backlog(&cpu_queue->queue);
 	req = crypto_dequeue_request(&cpu_queue->queue);
 	preempt_enable();
+	local_bh_enable();
 
 	if (!req)
 		return;



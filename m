Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030213Ab2KVV4A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:56:00 -0500
Received: from mail.kernel.org ([198.145.19.201]:49632 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754928Ab2KVSkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Gurucharan Shetty <gurucharan.shetty@gmail.com>,
        Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: [ 04/38] crypto: cryptd - disable softirqs in cryptd_queue_worker to prevent data corruption
Date: Wed, 21 Nov 2012 16:39:47 -0800
Message-Id: <20121122003904.738096435@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122003904.262382971@linuxfoundation.org>
References: <20121122003904.262382971@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/cryptd.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -137,13 +137,18 @@ static void cryptd_queue_worker(struct w
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



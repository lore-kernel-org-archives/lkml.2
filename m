Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380Ab0DEJSY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 05:18:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:55688 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518Ab0DEJSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 05:18:17 -0400
Message-ID: <4BB9AAB7.3020209@kernel.org>
Date: Mon, 05 Apr 2010 18:17:43 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       lkml <linux-kernel@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH ide#master] ide: clean up timed out request handling
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 05 Apr 2010 09:17:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

8f6205cd572fece673da0255d74843680f67f879 introduced a bug where a
timed out DMA request is never requeued and lost.
6072f7491f5ef391a575e18a1165e72a3eef1601 fixed this by making
ide_dma_timeout_retry() requeue the request itself.  While the fix is
correct, it makes DMA and non-DMA paths asymmetric regarding how the
in flight request is requeued.

As long as hwif->rq is set, the IDE driver is assuming ownership of
the request and the request should either be completed or requeued
when clearing hwif->rq.  In the timeout path, the ide driver holds
onto the request as long as the recovery action (ie. reset) is in
progress and clears it after the state machine is stopped (ide_stopped
return), so the existing requeueing logic is correct.  The bug
occurred because ide_dma_timeout_retry() explicitly clears hwif->rq
without requeueing it.

ide_dma_timeout_retry() is called only by ide_timer_expiry() and
returns ide_started only when ide_error() would return it - ie. after
reset state machine has started in which case the state machine will
eventually end up executing the ide_stopped path in ide_timer_expiry()
after reset protocol is complete.  So, there is no need to clear
hwif->rq from ide_dma_timeout_retry().  ide_timer_expiry() will handle
it the same way as PIO timeout path.

Kill hwif->rq clearing and requeueing from ide_dma_timeout_retry() and
let ide_timer_expiry() deal with it.  The end result should remain the
same.

grepping shows ide_dma_timeout_retry() is the only site which clears
hwif->rq without taking care of the request, so there shouldn't be
similar fallouts.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
Herbert, can you please test this survives your test case?

Thanks.

 drivers/ide/ide-dma.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index fd40a81..963bc8b 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -448,7 +448,6 @@ ide_startstop_t ide_dma_timeout_retry(ide_drive_t *drive, int error)
 	ide_hwif_t *hwif = drive->hwif;
 	const struct ide_dma_ops *dma_ops = hwif->dma_ops;
 	struct ide_cmd *cmd = &hwif->cmd;
-	struct request *rq;
 	ide_startstop_t ret = ide_stopped;

 	/*
@@ -486,14 +485,10 @@ ide_startstop_t ide_dma_timeout_retry(ide_drive_t *drive, int error)
 	ide_dma_off_quietly(drive);

 	/*
-	 * un-busy drive etc and make sure request is sane
+	 * make sure request is sane
 	 */
-	rq = hwif->rq;
-	if (rq) {
-		hwif->rq = NULL;
-		rq->errors = 0;
-		ide_requeue_and_plug(drive, rq);
-	}
+	if (hwif->rq)
+		hwif->rq->errors = 0;
 	return ret;
 }


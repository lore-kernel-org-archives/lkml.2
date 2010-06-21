Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303Ab0FUTuF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 15:50:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12867 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686Ab0FUTuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 15:50:02 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 1/2] cfq: always return false from should_idle if slice_idle is set to zero
Date: Mon, 21 Jun 2010 15:49:48 -0400
Message-Id: <1277149789-4493-2-git-send-email-jmoyer@redhat.com>
In-Reply-To: <1277149789-4493-1-git-send-email-jmoyer@redhat.com>
References: <1277149789-4493-1-git-send-email-jmoyer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In testing a competing fsync-ing process and a sequential reader on
mid-grade storage, I found that cfq was incapable of achieving the I/O
rates of deadline, no matter how it was tuned.  Investigation, and insight
from Vivek (mostly the latter), led to identifying that we were still
idling for the last queue in the service tree.

Modifying cfq_should_idle to not idle when slice_idle is set to zero got
us much closer to the performance of deadline for this workload.  I have
one follow-on patch that gets us on-par with deadline, but I think this
patch stands alone.

Comments, as always, are appreciated.

Cheers,
Jeff

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 block/cfq-iosched.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 5ff4f48..572a050 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1842,6 +1842,10 @@ static bool cfq_should_idle(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	if (prio == IDLE_WORKLOAD)
 		return false;
 
+	/* Don't idle if slice idling is disabled by the user */
+	if (cfqd->cfq_slice_idle == 0)
+		return false;
+
 	/* We do for queues that were marked with idle window flag. */
 	if (cfq_cfqq_idle_window(cfqq) &&
 	   !(blk_queue_nonrot(cfqd->queue) && cfqd->hw_tag))
-- 
1.6.5.2


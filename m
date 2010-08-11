Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757035Ab0HKWoj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 18:44:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756102Ab0HKWoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 18:44:38 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Cc: vgoyal@redhat.com
Subject: [PATCH 1/5] cfq-iosched: Do not idle if slice_idle=0
Date: Wed, 11 Aug 2010 18:44:23 -0400
Message-Id: <1281566667-7821-2-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1281566667-7821-1-git-send-email-vgoyal@redhat.com>
References: <1281566667-7821-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o do not idle either on cfq queue or service tree if slice_idle=0. User does
  not want any queue or service tree idling. Currently even if slice_idle=0,
  we were waiting for request to finish before expiring the queue and that
  can lead to lower queue depths.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index eb4086f..8830569 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1839,6 +1839,9 @@ static bool cfq_should_idle(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	BUG_ON(!service_tree);
 	BUG_ON(!service_tree->count);
 
+	if (!cfqd->cfq_slice_idle)
+		return false;
+
 	/* We never do for idle class queues. */
 	if (prio == IDLE_WORKLOAD)
 		return false;
@@ -1879,7 +1882,7 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 	/*
 	 * idle is disabled, either manually or by past process history
 	 */
-	if (!cfqd->cfq_slice_idle || !cfq_should_idle(cfqd, cfqq))
+	if (!cfq_should_idle(cfqd, cfqq))
 		return;
 
 	/*
-- 
1.7.1.1


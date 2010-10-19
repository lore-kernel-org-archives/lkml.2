Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044Ab0JSJLm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 05:11:42 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43425 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030Ab0JSJLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 05:11:41 -0400
From: Andi Kleen <andi@firstfloor.org>
To: axboe@kernel.dk
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] Fix array overflow in CFQ
Date: Tue, 19 Oct 2010 11:10:50 +0200
Message-Id: <1287479450-11447-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

gcc 4.5 complains when compiling a recent rc with

linux/block/cfq-iosched.c: In function ‘cfq_dispatch_requests’:
linux/block/cfq-iosched.c:2156:3: warning: array subscript is above array bounds

and it is right:

 slice = group_slice * count /
                max_t(unsigned, cfqg->busy_queues_avg[cfqd->serving_prio],
                      cfq_group_busy_queues_wl(cfqd->serving_prio, cfqd, cfqg));

busy_queues_avg can be indexed by this enum

enum wl_prio_t {
        BE_WORKLOAD = 0,
        RT_WORKLOAD = 1,
        IDLE_WORKLOAD = 2,
};

in cfqd->serving_prio, but is only declared as

unsigned int busy_queues_avg[2];

which is clearly off by one. Fix this here.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 block/cfq-iosched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 9eba291..76741da 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -185,7 +185,7 @@ struct cfq_group {
 	int nr_cfqq;
 
 	/* Per group busy queus average. Useful for workload slice calc. */
-	unsigned int busy_queues_avg[2];
+	unsigned int busy_queues_avg[3];
 	/*
 	 * rr lists of queues with requests, onle rr for each priority class.
 	 * Counts are embedded in the cfq_rb_root
-- 
1.7.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243Ab1DHAXb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 20:23:31 -0400
Received: from smtp-out.google.com ([74.125.121.67]:27318 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609Ab1DHAXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 20:23:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=to:subject:cc:message-id:date:from:x-system-of-record;
	b=wJvhsu4w9uRFCPAx3gRQzIq4uU5y/jYPQ5YRQMLNvhhx+ypR3ySb2/cI6A226PvTS
	VThoTG/1itKFKn/0QR+IQ==
To: a.p.zijlstra@chello.nl, mingo@elte.hu
Subject: [PATCH] sched: fix sched-domain avg_load calculation.
Cc: linux-kernel@vger.kernel.org
Message-Id: <20110408002322.3A0D812217F@elm.corp.google.com>
Date: Thu,  7 Apr 2011 17:23:22 -0700 (PDT)
From: kenchen@google.com (Ken Chen)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In function find_busiest_group(), the sched-domain avg_load isn't
calculated at all if there is a group imbalance within the domain.
This will cause erroneous imbalance calculation.  The reason is
that calculate_imbalance() sees sds->avg_load = 0 and it will dump
entire sds->max_load into imbalance variable, which is used later
on to migrate entire load from busiest CPU to the puller CPU. It
has two really bad effect:

1. stampede of task migration, and they won't be able to break out
   of the bad state because of positive feedback loop: large load
   delta -> heavier load migration -> larger imbalance and the cycle
   goes on.

2. severe imbalance in CPU queue depth.  This causes really long
   scheduling latency blip which affects badly on application that
   has tight latency requirement.

The fix is to have kernel calculate domain avg_load in both cases.
This will ensure that imbalance calculation is always sensible and
the target is usually half way between busiest and puller CPU.

Signed-off-by: Ken Chen <kenchen@google.com>
---
 kernel/sched_fair.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index c7ec5c8..c46568a 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -3127,6 +3127,8 @@ find_busiest_group(
 	if (!sds.busiest || sds.busiest_nr_running == 0)
 		goto out_balanced;
 
+	sds.avg_load = (SCHED_LOAD_SCALE * sds.total_load) / sds.total_pwr;
+
 	/*
 	 * If the busiest group is imbalanced the below checks don't
 	 * work because they assumes all things are equal, which typically
@@ -3151,7 +3153,6 @@ find_busiest_group(
 	 * Don't pull any tasks if this group is already above the domain
 	 * average load.
 	 */
-	sds.avg_load = (SCHED_LOAD_SCALE * sds.total_load) / sds.total_pwr;
 	if (sds.this_load >= sds.avg_load)
 		goto out_balanced;
 
-- 
1.7.3.1


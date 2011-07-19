Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab1GSU6k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 16:58:40 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:12425 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787Ab1GSU6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 16:58:38 -0400
Message-ID: <4E25F009.1040309@hp.com>
Date: Tue, 19 Jul 2011 14:58:49 -0600
From: Terry Loftin <terry.loftin@hp.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
CC: Bob Montgomery <bob.montgomery@hp.com>
Subject: [PATCH 2/2] sched: Fix "divide error: 0000" in find_busiest_group
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a check to sched_avg_update() to detect and reset age_stamp if the
clock value has wrapped.  Because __cycles_2_ns() includes an offset
to account for start up time, the clock may not wrap to zero, so use
the current clock value instead.

Signed-off-by: Terry Loftin <terry.loftin@hp.com>
Signed-off-by: Bob Montgomery <bob.montgomery@hp.com>
---
diff --git a/kernel/sched.c b/kernel/sched.c
index 18d38e4..b39cae1 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1256,6 +1256,8 @@ static void sched_avg_update(struct rq *rq)
 {
 	s64 period = sched_avg_period();

+	if (unlikely(rq->age_stamp > rq->clock))
+		rq->age_stamp = rq->clock;
 	while ((s64)(rq->clock - rq->age_stamp) > period) {
 		/*
 		 * Inline assembly required to prevent the compiler

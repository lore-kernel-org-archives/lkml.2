Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966586Ab2ERS6A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 14:58:00 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17646 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966089Ab2ERS57 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 14:57:59 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 18 May 2012 11:56:53 -0700
From: Peter Boonstoppel <pboonstoppel@nvidia.com>
To: "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "pjt@google.com" <pjt@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "seto.hidetoshi@jp.fujitsu.com" <seto.hidetoshi@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Peter De Schrijver <pdeschrijver@nvidia.com>
Date: Fri, 18 May 2012 11:56:51 -0700
Subject: [PATCH] sched: unthrottle rt_rq in migrate_tasks()
Thread-Topic: [PATCH] sched: unthrottle rt_rq in migrate_tasks()
Thread-Index: AQHNNSac3BKcOx5n9Eiwj2qM5OgvLg==
Message-ID: <5FBF8E85CA34454794F0F7ECBA79798F379AD507F2@HQMAIL04.nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

migrate_tasks() uses _pick_next_task_rt() to get tasks from the
real-time runqueue to be migrated. When rt_rq is throttled
_pick_next_task_rt() won't return anything, in which case
migrate_tasks() can't move all threads over and gets stuck in an
infinite loop.

Instead unthrottle rt_rq before migrating tasks.

Signed-off-by: Peter Boonstoppel <pboonstoppel@nvidia.com>
---
 kernel/sched/core.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9236a48..b37e0b3 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5159,6 +5159,12 @@ static void migrate_tasks(unsigned int dead_cpu)
 	/* Ensure any throttled groups are reachable by pick_next_task */
 	unthrottle_offline_cfs_rqs(rq);
 
+	/*
+	 * Ensure rt_rq is not throttled so its threads can be migrated using
+	 * pick_next_task_rt
+	 */
+	rq->rt.rt_throttled = 0;
+
 	for ( ; ; ) {
 		/*
 		 * There's this thread running, bail when that's the only
-- 
1.7.4.1

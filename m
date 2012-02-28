Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab2B1A72 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 19:59:28 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:48463 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096Ab2B1A71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 19:59:27 -0500
X-AuditID: 9c93016f-b7cc4ae0000027c5-7f-4f4c26ec52a0
From: Namhyung Kim <namhyung.kim@lge.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] hw breakpoint: Fix a possible memory leak
Date: Tue, 28 Feb 2012 10:19:38 +0900
Message-Id: <1330391978-28070-1-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <20120227233828.GE30232@somewhere.redhat.com>
References: <20120227233828.GE30232@somewhere.redhat.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If kzalloc() for TYPE_DATA failed on a given cpu, previous chunk
of TYPE_INST will be leaked. Fix it.

Thanks to Peter Zijlstra for suggesting this better solution. It
should work as long as the initial value of the region is all 0's
and that's the case of static (per-cpu) memory allocation.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/events/hw_breakpoint.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index b0309f76d777..3330022a7ac1 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -658,10 +658,10 @@ int __init init_hw_breakpoint(void)
 
  err_alloc:
 	for_each_possible_cpu(err_cpu) {
-		if (err_cpu == cpu)
-			break;
 		for (i = 0; i < TYPE_MAX; i++)
 			kfree(per_cpu(nr_task_bp_pinned[i], cpu));
+		if (err_cpu == cpu)
+			break;
 	}
 
 	return -ENOMEM;
-- 
1.7.9


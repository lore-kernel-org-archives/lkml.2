Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab2B0Cm0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 21:42:26 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:59278 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab2B0CmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 21:42:24 -0500
X-AuditID: 9c930197-b7ccaae000003d69-6f-4f4aed8dad91
From: Namhyung Kim <namhyung.kim@lge.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] hw breakpoint: Fix possible memory leak
Date: Mon, 27 Feb 2012 12:02:19 +0900
Message-Id: <1330311739-24302-1-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.9
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If kzalloc() for TYPE_DATA failed on a given cpu, previous chunk
will be leaked. Fix it.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 kernel/events/hw_breakpoint.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index b0309f76d777..58298b0d0e92 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -645,8 +645,12 @@ int __init init_hw_breakpoint(void)
 			task_bp_pinned = &per_cpu(nr_task_bp_pinned[i], cpu);
 			*task_bp_pinned = kzalloc(sizeof(int) * nr_slots[i],
 						  GFP_KERNEL);
-			if (!*task_bp_pinned)
+			if (!*task_bp_pinned) {
+				while (--i >= 0)
+					kfree(per_cpu(nr_task_bp_pinned[i],
+						      cpu));
 				goto err_alloc;
+			}
 		}
 	}
 
-- 
1.7.9


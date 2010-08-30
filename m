Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab0H3MNw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 08:13:52 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:39346 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755528Ab0H3MNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 08:13:49 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Robert Richter <robert.richter@amd.com>,
        Lin Ming <ming.m.lin@intel.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Don Zickus <dzickus@redhat.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: [RFC][PATCH 1/5] perf: Check if we should exclude idle thread in perf_exclude_event()
Date: Mon, 30 Aug 2010 13:13:43 +0100
Message-Id: <72c0ed93ff0b24365cc4d0a40e24efa3be3fe3df.1283123521.git.matt@console-pimps.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1283123521.git.matt@console-pimps.org>
References: <cover.1283123521.git.matt@console-pimps.org>
In-Reply-To: <cover.1283123521.git.matt@console-pimps.org>
References: <cover.1283123521.git.matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't open code the event check for excluding the idle thread. Instead
include the check in perf_exclude_event().

Signed-off-by: Matt Fleming <matt@console-pimps.org>
---
 kernel/perf_event.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 0d38f27..16b0476 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4310,6 +4310,9 @@ static int perf_exclude_event(struct perf_event *event,
 
 		if (event->attr.exclude_kernel && !user_mode(regs))
 			return 1;
+
+		if (event->attr.exclude_idle && current->pid == 0)
+			return 1;
 	}
 
 	return 0;
@@ -4512,9 +4515,8 @@ static enum hrtimer_restart perf_swevent_hrtimer(struct hrtimer *hrtimer)
 	regs = get_irq_regs();
 
 	if (regs && !perf_exclude_event(event, regs)) {
-		if (!(event->attr.exclude_idle && current->pid == 0))
-			if (perf_event_overflow(event, 0, &data, regs))
-				ret = HRTIMER_NORESTART;
+		if (perf_event_overflow(event, 0, &data, regs))
+			ret = HRTIMER_NORESTART;
 	}
 
 	period = max_t(u64, 10000, event->hw.sample_period);
-- 
1.7.1


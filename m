Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab1KVDai (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 22:30:38 -0500
Received: from dns1.mips.com ([12.201.5.69]:56348 "EHLO dns1.mips.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552Ab1KVDah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 22:30:37 -0500
From: Deng-Cheng Zhu <dczhu@mips.com>
To: <a.p.zijlstra@chello.nl>
CC: <eyal@mips.com>, <zenon@mips.com>, Deng-Cheng Zhu <dczhu@mips.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 5/5] perf: Enable applicable siblings when group leader is enable-on-exec
Date: Tue, 22 Nov 2011 11:30:01 +0800
Message-ID: <1321932601-21128-1-git-send-email-dczhu@mips.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-EMS-Proccessed: 6LP3oGfGVdcdb8o1aBnt6w==
X-EMS-STAMP: EFm9r4u4hHJdmI7MihnwqA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, when grouped events are created disabled and enable-on-exec, the
siblings won't be enabled on exec in fact. The problem looks like this:

======================================================================
-sh-4.0# perf stat -g -e r14,cycles,instructions,r12 find / >/dev/null
^Cfind: Interrupt

 Performance counter stats for 'find /':

          60684699 r14
     <not counted> cycles
     <not counted> instructions
     <not counted> r12

       4.291975113 seconds time elapsed
======================================================================

This patch fixes it.

Signed-off-by: Deng-Cheng Zhu <dczhu@mips.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: LKML <linux-kernel@vger.kernel.org>
---
 kernel/events/core.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 0e8457d..300bc66 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1651,6 +1651,8 @@ retry:
 	raw_spin_unlock_irq(&ctx->lock);
 }
 
+static int event_enable_on_exec(struct perf_event *event,
+				struct perf_event_context *ctx);
 /*
  * Put a event into inactive state and update time fields.
  * Enabling the leader of a group effectively enables all
@@ -1668,6 +1670,7 @@ static void __perf_event_mark_enabled(struct perf_event *event,
 	event->state = PERF_EVENT_STATE_INACTIVE;
 	event->tstamp_enabled = tstamp - event->total_time_enabled;
 	list_for_each_entry(sub, &event->sibling_list, group_entry) {
+		event_enable_on_exec(sub, sub->ctx);
 		if (sub->state >= PERF_EVENT_STATE_INACTIVE)
 			sub->tstamp_enabled = tstamp - sub->total_time_enabled;
 	}
-- 
1.7.1


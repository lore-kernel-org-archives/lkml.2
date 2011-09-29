Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173Ab1I2QBr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 12:01:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526Ab1I2QBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 12:01:46 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] perf tools: Exit recording if events have non matching sample type
Date: Thu, 29 Sep 2011 18:01:08 +0200
Message-Id: <1317312068-10411-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The event processing relies on all events having the same sample_type.

This is being checked when the session is being opened read only.
It also needs to be checked when we do record, since events could be
read during processing build IDs at the end of the record command.

If we process events with different sample_type the processing might
skip some events or hang.

Following command hangs on my setup:
  ./perf record -o perf.data -e ext4:ext4_mb_new_group_pa \
   -e LLC-loads -- date '+%F'

because hardware and tracepoint events have different sample type.

With the patch applied the record command displays
"Non matching sample_type" message and exits.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/builtin-record.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index f4c3fbe..71e2c4e 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -832,6 +832,12 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 		goto out_symbol_exit;
 	}
 
+	if (!perf_evlist__valid_sample_type(evsel_list)) {
+		pr_err("Non matching sample_type\n");
+		err = -EINVAL;
+		goto out_symbol_exit;
+	}
+
 	if (target_pid != -1)
 		target_tid = target_pid;
 
-- 
1.7.4


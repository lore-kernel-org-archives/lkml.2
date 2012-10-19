Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757888Ab2JSOz3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 10:55:29 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50579 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758612Ab2JSOz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 10:55:27 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com
Subject: [PATCH 1/2] perf tools: add event modifier to request exclusive PMU access
Date: Fri, 19 Oct 2012 16:52:05 +0200
Message-Id: <1350658326-14715-2-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350658326-14715-1-git-send-email-eranian@google.com>
References: <1350658326-14715-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the x modifier for events. It allows users to
request exclusive PMU access (attr->exclusive):

perf stat -e cycles:x ......
or
perf stat -e cpu/cycles/x ....

Exclusive mode is a feature of perf_events which was not yet
supported by the perf tool. Some events may require exclusive
PMU access (like on Intel SandyBridge).

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/parse-events.c |    7 +++++++
 tools/perf/util/parse-events.l |    2 +-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index aed38e4..aa73392 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -642,6 +642,7 @@ struct event_modifier {
 	int eG;
 	int precise;
 	int exclude_GH;
+	int exclusive;
 };
 
 static int get_event_modifier(struct event_modifier *mod, char *str,
@@ -656,6 +657,7 @@ static int get_event_modifier(struct event_modifier *mod, char *str,
 
 	int exclude = eu | ek | eh;
 	int exclude_GH = evsel ? evsel->exclude_GH : 0;
+	int exclusive = evsel ? evsel->attr.exclusive : 0;
 
 	/*
 	 * We are here for group and 'GH' was not set as event
@@ -690,6 +692,8 @@ static int get_event_modifier(struct event_modifier *mod, char *str,
 			eH = 0;
 		} else if (*str == 'p') {
 			precise++;
+		} else if (*str == 'x') {
+			exclusive = 1;
 		} else
 			break;
 
@@ -716,6 +720,8 @@ static int get_event_modifier(struct event_modifier *mod, char *str,
 	mod->eG = eG;
 	mod->precise = precise;
 	mod->exclude_GH = exclude_GH;
+	mod->exclusive = exclusive;
+
 	return 0;
 }
 
@@ -741,6 +747,7 @@ int parse_events__modifier_event(struct list_head *list, char *str, bool add)
 		evsel->attr.precise_ip     = mod.precise;
 		evsel->attr.exclude_host   = mod.eH;
 		evsel->attr.exclude_guest  = mod.eG;
+		evsel->attr.exclusive	   = mod.exclusive;
 		evsel->exclude_GH          = mod.exclude_GH;
 	}
 
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index c87efc1..9c8a06d 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -81,7 +81,7 @@ num_dec		[0-9]+
 num_hex		0x[a-fA-F0-9]+
 num_raw_hex	[a-fA-F0-9]+
 name		[a-zA-Z_*?][a-zA-Z0-9_*?]*
-modifier_event	[ukhpGH]{1,8}
+modifier_event	[ukhpGHx]{1,8}
 modifier_bp	[rwx]{1,3}
 
 %%
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821Ab1CGUNz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 15:13:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19860 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755656Ab1CGUNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 15:13:53 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, phan@redhat.com,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 2/2] perf,top: dont let events to eat up whole header line
Date: Mon,  7 Mar 2011 21:13:41 +0100
Message-Id: <1299528821-17521-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1299528821-17521-1-git-send-email-jolsa@redhat.com>
References: <1299528821-17521-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Passing multiple events might force out information about pid/tid/cpu.
Attached patch leaves 30 characters for this info at the expense of
the events' names.

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/top.c |   20 +++++++++++++++++---
 1 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/top.c b/tools/perf/util/top.c
index 4f869da..75cfe4d 100644
--- a/tools/perf/util/top.c
+++ b/tools/perf/util/top.c
@@ -115,9 +115,23 @@ size_t perf_top__header_snprintf(struct perf_top *top, char *bf, size_t size)
 	if (!top->display_weighted) {
 		ret += SNPRINTF(bf + ret, size - ret, "%s",
 				event_name(top->sym_evsel));
-	} else list_for_each_entry(counter, &top->evlist->entries, node) {
-		ret += SNPRINTF(bf + ret, size - ret, "%s%s",
-				counter->idx ? "/" : "", event_name(counter));
+	} else {
+		/*
+		 * Don't let events eat all the space. Leaving 30 bytes
+		 * for the rest should be enough.
+		 */
+		size_t last_pos = size - 30;
+
+		list_for_each_entry(counter, &top->evlist->entries, node) {
+			ret += SNPRINTF(bf + ret, size - ret, "%s%s",
+					counter->idx ? "/" : "",
+					event_name(counter));
+			if (ret > last_pos) {
+				sprintf(bf + last_pos - 3, "..");
+				ret = last_pos - 1;
+				break;
+			}
+		}
 	}
 
 	ret += SNPRINTF(bf + ret, size - ret, "], ");
-- 
1.7.4


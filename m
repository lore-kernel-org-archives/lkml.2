Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab1CJT35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 14:29:57 -0500
Received: from casper.infradead.org ([85.118.1.10]:57575 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab1CJT34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 14:29:56 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Han Pingtian <phan@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/4] perf top: Don't let events to eat up whole header line
Date: Thu, 10 Mar 2011 16:29:44 -0300
Message-Id: <1299785386-22234-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1299785386-22234-1-git-send-email-acme@infradead.org>
References: <1299785386-22234-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Passing multiple events might force out information about pid/tid/cpu.
Attached patch leaves 30 characters for this info at the expense of the
events' names.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Han Pingtian <phan@redhat.com>
LKML-Reference: <1299528821-17521-3-git-send-email-jolsa@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
1.6.2.5


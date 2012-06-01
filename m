Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965885Ab2FAWSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 18:18:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54296 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965657Ab2FAWQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 18:16:54 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Sunjin Yang <fan4326@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/15] perf tools: Check if callchain is corrupted
Date: Fri,  1 Jun 2012 19:16:29 -0300
Message-Id: <1338588999-32509-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1338588999-32509-1-git-send-email-acme@infradead.org>
References: <1338588999-32509-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

We faced segmentation fault on perf top -G at very high sampling rate
due to a corrupted callchain. While the root cause was not revealed (I
failed to figure it out), this patch tries to protect us from the
segfault on such cases.

Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sunjin Yang <fan4326@gmail.com>
Link: http://lkml.kernel.org/r/1338443007-24857-2-git-send-email-namhyung.kim@lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/linux/perf_event.h |    4 ++--
 tools/perf/util/session.c  |   14 +++++++++++++-
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index f325786..1817d40 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -555,6 +555,8 @@ enum perf_event_type {
 	PERF_RECORD_MAX,			/* non-ABI */
 };
 
+#define PERF_MAX_STACK_DEPTH		255
+
 enum perf_callchain_context {
 	PERF_CONTEXT_HV			= (__u64)-32,
 	PERF_CONTEXT_KERNEL		= (__u64)-128,
@@ -609,8 +611,6 @@ struct perf_guest_info_callbacks {
 #include <linux/sysfs.h>
 #include <asm/local.h>
 
-#define PERF_MAX_STACK_DEPTH		255
-
 struct perf_callchain_entry {
 	__u64				nr;
 	__u64				ip[PERF_MAX_STACK_DEPTH];
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 3b6f8e4..04d1e33 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -300,6 +300,11 @@ int machine__resolve_callchain(struct machine *self,
 
 	callchain_cursor_reset(&callchain_cursor);
 
+	if (chain->nr > PERF_MAX_STACK_DEPTH) {
+		pr_warning("corrupted callchain. skipping...\n");
+		return 0;
+	}
+
 	for (i = 0; i < chain->nr; i++) {
 		u64 ip;
 		struct addr_location al;
@@ -318,7 +323,14 @@ int machine__resolve_callchain(struct machine *self,
 			case PERF_CONTEXT_USER:
 				cpumode = PERF_RECORD_MISC_USER;	break;
 			default:
-				break;
+				pr_debug("invalid callchain context: "
+					 "%"PRId64"\n", (s64) ip);
+				/*
+				 * It seems the callchain is corrupted.
+				 * Discard all.
+				 */
+				callchain_cursor_reset(&callchain_cursor);
+				return 0;
 			}
 			continue;
 		}
-- 
1.7.1


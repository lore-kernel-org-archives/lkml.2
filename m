Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab2EaFqW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 01:46:22 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:51948 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab2EaFqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 01:46:07 -0400
X-AuditID: 9c930197-b7be2ae000000ebb-74-4fc7059a9b3c
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Sunjin Yang <fan4326@gmail.com>
Subject: [PATCH/RFC 2/2] perf tools: Check callchain is corrupted
Date: Thu, 31 May 2012 14:43:27 +0900
Message-Id: <1338443007-24857-2-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1338443007-24857-1-git-send-email-namhyung.kim@lge.com>
References: <1338443007-24857-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We faced segmentation fault on perf top -G at very high sampling
rate due to a corrupted callchain. While the root cause was not
revealed (I failed to figure it out), this patch tries to protect
us from the segfault on such cases.

Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 include/linux/perf_event.h |    4 ++--
 tools/perf/util/session.c  |   14 +++++++++++++-
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 8adf70e9e3cc..0430ea6054ef 100644
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
index a7de2acac460..fa14e60ed459 100644
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
1.7.10.1


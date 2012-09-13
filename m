Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514Ab2IMH3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 03:29:34 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:59217 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755927Ab2IMH1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 03:27:06 -0400
X-AuditID: 9c93016f-b7c19ae000000e6d-06-50518ac78f6e
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Arun Sharma <asharma@fb.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 08/15] perf callchain: Add a couple of callchain helpers
Date: Thu, 13 Sep 2012 16:20:04 +0900
Message-Id: <1347520811-28150-9-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347520811-28150-1-git-send-email-namhyung@kernel.org>
References: <1347520811-28150-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

To accumulate callchain information of a hist entry, following helper
functions are needed.

Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/callchain.c | 15 +++++++++++++++
 tools/perf/util/callchain.h | 17 +++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index d3b3f5d82137..255c4a8266be 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -461,3 +461,18 @@ int callchain_cursor_append(struct callchain_cursor *cursor,
 
 	return 0;
 }
+
+int callchain_cursor_peek_al(struct callchain_cursor *cursor,
+			     struct addr_location *al)
+{
+	struct callchain_cursor_node *node = cursor->first;
+
+	if (node == NULL || cursor->nr == 0)
+		return -1;
+
+	al->map = node->map;
+	al->sym = node->sym;
+	al->addr = node->ip;
+
+	return 0;
+}
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 3bdb407f9cd9..46ca2b4360e3 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -4,6 +4,7 @@
 #include "../perf.h"
 #include <linux/list.h>
 #include <linux/rbtree.h>
+#include <string.h>
 #include "event.h"
 #include "symbol.h"
 
@@ -143,4 +144,20 @@ static inline void callchain_cursor_advance(struct callchain_cursor *cursor)
 	cursor->curr = cursor->curr->next;
 	cursor->pos++;
 }
+
+/* NOTE: This function can leak a cursor node.  Use with caution. */
+static inline void callchain_cursor_next(struct callchain_cursor *cursor)
+{
+	cursor->first = cursor->first->next;
+	cursor->nr--;
+}
+
+static inline void callchain_cursor_copy(struct callchain_cursor *dest,
+					 struct callchain_cursor *src)
+{
+	memcpy(dest, src, sizeof(*src));
+}
+
+int callchain_cursor_peek_al(struct callchain_cursor *cursor,
+			     struct addr_location *al);
 #endif	/* __PERF_CALLCHAIN_H */
-- 
1.7.11.4


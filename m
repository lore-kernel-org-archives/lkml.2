Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab0EIQPT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 12:15:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:45118 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab0EIQPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 12:15:11 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 1/3] perf callchain: Move validate_callchain to callchain lib
Date: Sun,  9 May 2010 13:14:55 -0300
Message-Id: <1273421697-30138-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1273421697-30138-1-git-send-email-acme@infradead.org>
References: <1273421697-30138-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |   15 +--------------
 tools/perf/util/callchain.c |    7 +++++++
 tools/perf/util/callchain.h |    3 +++
 3 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 196473b..1cae877 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -123,19 +123,6 @@ static int perf_session__add_hist_entry(struct perf_session *self,
 	return 0;
 }
 
-static int validate_chain(struct ip_callchain *chain, event_t *event)
-{
-	unsigned int chain_size;
-
-	chain_size = event->header.size;
-	chain_size -= (unsigned long)&event->ip.__more_data - (unsigned long)event;
-
-	if (chain->nr*sizeof(u64) > chain_size)
-		return -1;
-
-	return 0;
-}
-
 static int add_event_total(struct perf_session *session,
 			   struct sample_data *data,
 			   struct perf_event_attr *attr)
@@ -171,7 +158,7 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 
 		dump_printf("... chain: nr:%Lu\n", data.callchain->nr);
 
-		if (validate_chain(data.callchain, event) < 0) {
+		if (!ip_callchain__valid(data.callchain, event)) {
 			pr_debug("call-chain problem with event, "
 				 "skipping it.\n");
 			return 0;
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index db628af..ac14861 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -17,6 +17,13 @@
 
 #include "callchain.h"
 
+bool ip_callchain__valid(struct ip_callchain *chain, event_t *event)
+{
+	unsigned int chain_size = event->header.size;
+	chain_size -= (unsigned long)&event->ip.__more_data - (unsigned long)event;
+	return chain->nr * sizeof(u64) <= chain_size;
+}
+
 #define chain_for_each_child(child, parent)	\
 	list_for_each_entry(child, &parent->children, brothers)
 
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 8a7e8bb..0f4da09 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -4,6 +4,7 @@
 #include "../perf.h"
 #include <linux/list.h>
 #include <linux/rbtree.h>
+#include "event.h"
 #include "util.h"
 #include "symbol.h"
 
@@ -58,4 +59,6 @@ static inline u64 cumul_hits(struct callchain_node *node)
 int register_callchain_param(struct callchain_param *param);
 int append_chain(struct callchain_node *root, struct ip_callchain *chain,
 		 struct map_symbol *syms);
+
+bool ip_callchain__valid(struct ip_callchain *chain, event_t *event);
 #endif	/* __PERF_CALLCHAIN_H */
-- 
1.6.2.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab2HCOE0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 10:04:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:45784 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245Ab2HCOBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 10:01:24 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 17/18] perf kvm top: Limit guest kernel info message to once
Date: Fri,  3 Aug 2012 11:01:09 -0300
Message-Id: <1344002470-5965-18-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1344002470-5965-1-git-send-email-acme@infradead.org>
References: <1344002470-5965-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

'perf kvm top' shows a continual flurry of:
    Can't find guest [5201]'s kernel information

if it can't find the guest info and with a lot of VMs running a user has no
chance of reading them all. Limit message to once per guest.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1343709095-7089-5-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 3409627..68cd61e 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -38,6 +38,7 @@
 #include "util/cpumap.h"
 #include "util/xyarray.h"
 #include "util/sort.h"
+#include "util/intlist.h"
 
 #include "util/debug.h"
 
@@ -706,8 +707,16 @@ static void perf_event__process_sample(struct perf_tool *tool,
 	int err;
 
 	if (!machine && perf_guest) {
-		pr_err("Can't find guest [%d]'s kernel information\n",
-			event->ip.pid);
+		static struct intlist *seen;
+
+		if (!seen)
+			seen = intlist__new();
+
+		if (!intlist__has_entry(seen, event->ip.pid)) {
+			pr_err("Can't find guest [%d]'s kernel information\n",
+				event->ip.pid);
+			intlist__add(seen, event->ip.pid);
+		}
 		return;
 	}
 
-- 
1.7.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab2GaEcX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 00:32:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40625 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737Ab2GaEcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 00:32:00 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 4/4] perf kvm top: limit guest kernel info message to once
Date: Mon, 30 Jul 2012 22:31:35 -0600
Message-Id: <1343709095-7089-5-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1343709095-7089-1-git-send-email-dsahern@gmail.com>
References: <1343709095-7089-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'perf kvm top' shows a continual flurry of:
    Can't find guest [5201]'s kernel information

if it can't find the guest info and with a lot of VMs running a user
has no chance of reading them all. Limit message to once per guest.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 tools/perf/builtin-top.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 35e86c6..0687c82 100644
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
1.7.10.1


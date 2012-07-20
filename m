Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab2GTX0g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 19:26:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36363 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab2GTX0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 19:26:30 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 11/11] perf kvm top: limit guest kernel info message to once
Date: Fri, 20 Jul 2012 17:25:56 -0600
Message-Id: <1342826756-64663-12-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1342826756-64663-1-git-send-email-dsahern@gmail.com>
References: <1342826756-64663-1-git-send-email-dsahern@gmail.com>
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
 tools/perf/builtin-top.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 1706dc9..6285374 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -706,8 +706,18 @@ static void perf_event__process_sample(struct perf_tool *tool,
 	int err;
 
 	if (!machine && perf_guest) {
-		pr_err("Can't find guest [%d]'s kernel information\n",
-			event->ip.pid);
+		static struct strlist *seen;
+		char pidstr[8];
+
+		if (!seen)
+			seen = strlist__new(true, NULL);
+
+		scnprintf(pidstr, sizeof(pidstr), "%d", event->ip.pid);
+		if (!strlist__has_entry(seen, pidstr)) {
+			pr_err("Can't find guest [%d]'s kernel information\n",
+				event->ip.pid);
+			strlist__add(seen, pidstr);
+		}
 		return;
 	}
 
-- 
1.7.10.1


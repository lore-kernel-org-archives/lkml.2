Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab2GTX00 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 19:26:26 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:40920 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795Ab2GTX0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 19:26:18 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 05/11] perf kvm: use strtol for walking guestmount directory
Date: Fri, 20 Jul 2012 17:25:50 -0600
Message-Id: <1342826756-64663-6-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1342826756-64663-1-git-send-email-dsahern@gmail.com>
References: <1342826756-64663-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 tools/perf/util/symbol.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 6802ef4..968de79 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -2825,6 +2825,7 @@ int machines__create_guest_kernel_maps(struct rb_root *machines)
 	int i, items = 0;
 	char path[PATH_MAX];
 	pid_t pid;
+	char *endp;
 
 	if (symbol_conf.default_guest_vmlinux_name ||
 	    symbol_conf.default_guest_modules ||
@@ -2841,7 +2842,14 @@ int machines__create_guest_kernel_maps(struct rb_root *machines)
 				/* Filter out . and .. */
 				continue;
 			}
-			pid = atoi(namelist[i]->d_name);
+			pid = (pid_t) strtol(namelist[i]->d_name, &endp, 10);
+			if ((*endp != '\0') ||
+			    (endp == namelist[i]->d_name) ||
+			    (errno == ERANGE)) {
+				pr_debug("invalid directory (%s). Skipping.\n",
+					 namelist[i]->d_name);
+				continue;
+			}
 			sprintf(path, "%s/%s/proc/kallsyms",
 				symbol_conf.guestmount,
 				namelist[i]->d_name);
-- 
1.7.10.1


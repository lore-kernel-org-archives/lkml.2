Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab2G3Cym (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 22:54:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44321 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920Ab2G3Cyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 22:54:40 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] perf kvm: use strtol for walking guestmount directory
Date: Sun, 29 Jul 2012 20:54:35 -0600
Message-Id: <1343616875-6455-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only want to process directories under the guestmnount directory that have a
pid as a name (ie, all digits). Other entries in the guestmount directory
should be ignored.  There is already a check that requires the first character
of each entry to be a digit, but atoi is used to convert the directory name to
a pid. For example if guestmount contains a directory with the name 1foo, atoi
converts it to a pid of 1 and a machine is created with a pid of 1. This is
wrong; this directory really should be ignored. Use strtol to do that.

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
index fdad4eee..15bc673 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -2875,6 +2875,7 @@ int machines__create_guest_kernel_maps(struct rb_root *machines)
 	int i, items = 0;
 	char path[PATH_MAX];
 	pid_t pid;
+	char *endp;
 
 	if (symbol_conf.default_guest_vmlinux_name ||
 	    symbol_conf.default_guest_modules ||
@@ -2891,7 +2892,14 @@ int machines__create_guest_kernel_maps(struct rb_root *machines)
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


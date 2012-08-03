Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab2HCOER (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 10:04:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48773 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab2HCOBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 10:01:24 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 13/18] perf kvm: Use strtol for walking guestmount directory
Date: Fri,  3 Aug 2012 11:01:05 -0300
Message-Id: <1344002470-5965-14-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1344002470-5965-1-git-send-email-acme@infradead.org>
References: <1344002470-5965-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Only want to process directories under the guestmnount directory that
have a pid as a name (ie, all digits). Other entries in the guestmount
directory should be ignored.  There is already a check that requires the
first character of each entry to be a digit, but atoi is used to convert
the directory name to a pid. For example if guestmount contains a
directory with the name 1foo, atoi converts it to a pid of 1 and a
machine is created with a pid of 1. This is wrong; this directory really
should be ignored. Use strtol to do that.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1343616875-6455-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index fe86612..8b63b67 100644
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
+			pid = (pid_t)strtol(namelist[i]->d_name, &endp, 10);
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
1.7.1


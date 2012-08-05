Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab2HEQ5c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 12:57:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56987 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697Ab2HEQ5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 12:57:31 -0400
Date: Sun, 5 Aug 2012 09:53:58 -0700
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-347ed9903a10179d1cf733d5d77072b283d89da3@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, peterz@infradead.org,
        dsahern@gmail.com, tglx@linutronix.de, namhyung@kernel.org,
        jolsa@redhat.com
In-Reply-To: <1343616875-6455-1-git-send-email-dsahern@gmail.com>
References: <1343616875-6455-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf kvm:
  Use strtol for walking guestmount directory
Git-Commit-ID: 347ed9903a10179d1cf733d5d77072b283d89da3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 05 Aug 2012 09:54:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  347ed9903a10179d1cf733d5d77072b283d89da3
Gitweb:     http://git.kernel.org/tip/347ed9903a10179d1cf733d5d77072b283d89da3
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Sun, 29 Jul 2012 20:54:35 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 3 Aug 2012 10:35:23 -0300

perf kvm: Use strtol for walking guestmount directory

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

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778Ab0DNUvl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 16:51:41 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:32911 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755688Ab0DNUvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 16:51:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=gmjqhbeOnUrY0EI4Eu+sPNJrEHl9bSg1aKNhlzqauZ/Sj4SseyOlC4Q4+Mc0zrh5hD
         eFEN0GBr/muFotNkynh9SS/9l2FqT1dYYlG2NnGY1LH8iz99xYvTNi7v+mIKz01tx5ni
         y5rUCa2MwvnJ424XIYowopR1R1HTTLm7luXSQ=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 1/3] perf: Make -f the default for perf record
Date: Wed, 14 Apr 2010 22:51:32 +0200
Message-Id: <1271278294-7336-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Force the overwriting mode by default if append mode is not explicit.
Adding -f every time one uses perf on a daily basis quickly becomes a
burden.

Keep the -f among the options though to avoid breaking some random
users scripts.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 tools/perf/Documentation/perf-record.txt |    2 +-
 tools/perf/builtin-record.c              |   40 ++++++++++++++++++-----------
 2 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index fc46c0b..b29bd2d 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -58,7 +58,7 @@ OPTIONS
 
 -f::
 --force::
-	Overwrite existing data file.
+	Overwrite existing data file. (deprecated)
 
 -c::
 --count=::
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 9a95136..dcda899 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -26,6 +26,11 @@
 #include <unistd.h>
 #include <sched.h>
 
+enum write_mode_t {
+	WRITE_FORCE,
+	WRITE_APPEND
+};
+
 static int			*fd[MAX_NR_CPUS][MAX_COUNTERS];
 
 static long			default_interval		=      0;
@@ -47,8 +52,7 @@ static pid_t			*all_tids			=      NULL;
 static int			thread_num			=      0;
 static pid_t			child_pid			=     -1;
 static bool			inherit				=   true;
-static bool			force				=  false;
-static bool			append_file			=  false;
+static enum write_mode_t	write_mode			= WRITE_FORCE;
 static bool			call_graph			=  false;
 static bool			inherit_stat			=  false;
 static bool			no_samples			=  false;
@@ -450,26 +454,19 @@ static int __cmd_record(int argc, const char **argv)
 	}
 
 	if (!stat(output_name, &st) && st.st_size) {
-		if (!force) {
-			if (!append_file) {
-				pr_err("Error, output file %s exists, use -A "
-				       "to append or -f to overwrite.\n",
-				       output_name);
-				exit(-1);
-			}
-		} else {
+		if (write_mode == WRITE_FORCE) {
 			char oldname[PATH_MAX];
 			snprintf(oldname, sizeof(oldname), "%s.old",
 				 output_name);
 			unlink(oldname);
 			rename(output_name, oldname);
 		}
-	} else {
-		append_file = false;
+	} else if (write_mode == WRITE_APPEND) {
+		write_mode = WRITE_FORCE;
 	}
 
 	flags = O_CREAT|O_RDWR;
-	if (append_file)
+	if (write_mode == WRITE_APPEND)
 		file_new = 0;
 	else
 		flags |= O_TRUNC;
@@ -480,7 +477,8 @@ static int __cmd_record(int argc, const char **argv)
 		exit(-1);
 	}
 
-	session = perf_session__new(output_name, O_WRONLY, force);
+	session = perf_session__new(output_name, O_WRONLY,
+				    write_mode == WRITE_FORCE);
 	if (session == NULL) {
 		pr_err("Not enough memory for reading perf file header\n");
 		return -1;
@@ -667,6 +665,8 @@ static const char * const record_usage[] = {
 	NULL
 };
 
+static bool force, append_file;
+
 static const struct option options[] = {
 	OPT_CALLBACK('e', "event", NULL, "event",
 		     "event selector. use 'perf list' to list available events",
@@ -688,7 +688,7 @@ static const struct option options[] = {
 	OPT_INTEGER('C', "profile_cpu", &profile_cpu,
 			    "CPU to profile on"),
 	OPT_BOOLEAN('f', "force", &force,
-			"overwrite existing data file"),
+			"overwrite existing data file (deprecated)"),
 	OPT_LONG('c', "count", &default_interval,
 		    "event period to sample"),
 	OPT_STRING('o', "output", &output_name, "file",
@@ -725,6 +725,16 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 		!system_wide && profile_cpu == -1)
 		usage_with_options(record_usage, options);
 
+	if (force && append_file) {
+		fprintf(stderr, "Can't overwrite and append at the same time."
+				" You need to choose between -f and -A");
+		usage_with_options(record_usage, options);
+	} else if (append_file) {
+		write_mode = WRITE_APPEND;
+	} else {
+		write_mode = WRITE_FORCE;
+	}
+
 	symbol__init();
 
 	if (!nr_counters) {
-- 
1.6.2.3


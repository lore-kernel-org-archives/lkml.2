Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747Ab0KUBMw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 20:12:52 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:55827 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755456Ab0KUBMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 20:12:51 -0500
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        a.p.zijlstra@chello.nl, acme@redhat.org
Cc: ianmunsi@au1.ibm.com, michaele@au1.ibm.com,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>
Subject: [PATCH] perf tools: add event grouping capability to "perf stat"
Date: Sat, 20 Nov 2010 17:07:39 -0800
Message-Id: <1290301659-4146-1-git-send-email-cjashfor@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the ability to create multiple event groups, each with their own leader
using the existing "-e <event>[,<event> ...] [-e <event>[,<event>]]"
syntax.  Each additional -e switch creates a new group, and each event
listed within a -e switch is within that group.

Signed-off-by: Corey Ashford <cjashfor@linux.vnet.ibm.com>
---
 tools/perf/Documentation/perf-stat.txt |   12 +++++++++---
 tools/perf/builtin-stat.c              |   12 ++++++++++--
 tools/perf/util/parse-events.c         |    4 ++++
 tools/perf/util/parse-events.h         |    1 +
 4 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
index 4b3a2d4..d522ebd 100644
--- a/tools/perf/Documentation/perf-stat.txt
+++ b/tools/perf/Documentation/perf-stat.txt
@@ -8,8 +8,8 @@ perf-stat - Run a command and gather performance counter statistics
 SYNOPSIS
 --------
 [verse]
-'perf stat' [-e <EVENT> | --event=EVENT] [-S] [-a] <command>
-'perf stat' [-e <EVENT> | --event=EVENT] [-S] [-a] -- <command> [<options>]
+'perf stat' [-e <EVENT>[,<EVENT>...] | --event=<EVENT>[,<EVENT>...]] [-S] [-a] <command>
+'perf stat' [-e <EVENT>[,<EVENT>...] | --event=<EVENT>[,<EVENT>...]] [-S] [-a] -- <command> [<options>]
 
 DESCRIPTION
 -----------
@@ -28,7 +28,13 @@ OPTIONS
 	Select the PMU event. Selection can be a symbolic event name
 	(use 'perf list' to list all events) or a raw PMU
 	event (eventsel+umask) in the form of rNNN where NNN is a
-	 hexadecimal event descriptor.
+	hexadecimal event descriptor.  As shown, multiple events can be
+	separated by commas in each -e/--event switch.  Each additional
+	-e/--event switch creates a new event group.  Grouped events are
+	scheduled onto the PMU hardware at the same time, which is
+	important to know when the PMU is overscheduled.  A good example of
+	this is measuring CPI where both instructions and cycles events
+	need to be scheduled simultaneously to get an accurate estimate.
 
 -i::
 --no-inherit::
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 8b9afa6..5f9fdc8 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -162,8 +162,12 @@ static int create_perf_stat_counter(int counter, bool *perm_err)
 		int cpu;
 
 		for (cpu = 0; cpu < nr_cpus; cpu++) {
+			if (counter == grp_leaders[counter])
+				/* first counter in the group is the leader */
+				fd[cpu][grp_leaders[counter]][0] = -1;
 			fd[cpu][counter][0] = sys_perf_event_open(attr,
-					-1, cpumap[cpu], -1, 0);
+					-1, cpumap[cpu],
+					fd[cpu][grp_leaders[counter]][0], 0);
 			if (fd[cpu][counter][0] < 0) {
 				if (errno == EPERM || errno == EACCES)
 					*perm_err = true;
@@ -180,8 +184,12 @@ static int create_perf_stat_counter(int counter, bool *perm_err)
 			attr->enable_on_exec = 1;
 		}
 		for (thread = 0; thread < thread_num; thread++) {
+			if (counter == grp_leaders[counter])
+				/* first counter in the group is the leader */
+				fd[0][grp_leaders[counter]][thread] = -1;
 			fd[0][counter][thread] = sys_perf_event_open(attr,
-				all_tids[thread], -1, -1, 0);
+				all_tids[thread], -1,
+				fd[0][grp_leaders[counter]][thread], 0);
 			if (fd[0][counter][thread] < 0) {
 				if (errno == EPERM || errno == EACCES)
 					*perm_err = true;
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 4af5bd5..eeecb2a 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -12,6 +12,7 @@
 
 int				nr_counters;
 
+int				grp_leaders[MAX_COUNTERS];
 struct perf_event_attr		attrs[MAX_COUNTERS];
 char				*filters[MAX_COUNTERS];
 
@@ -804,11 +805,13 @@ int parse_events(const struct option *opt __used, const char *str, int unset __u
 {
 	struct perf_event_attr attr;
 	enum event_result ret;
+	int grp_leader;
 
 	if (strchr(str, ':'))
 		if (store_event_type(str) < 0)
 			return -1;
 
+	grp_leader = nr_counters;
 	for (;;) {
 		if (nr_counters == MAX_COUNTERS)
 			return -1;
@@ -822,6 +825,7 @@ int parse_events(const struct option *opt __used, const char *str, int unset __u
 			return -1;
 
 		if (ret != EVT_HANDLED_ALL) {
+			grp_leaders[nr_counters] = grp_leader;
 			attrs[nr_counters] = attr;
 			nr_counters++;
 		}
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index fc4ab3f..d820f42 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -17,6 +17,7 @@ extern bool have_tracepoints(struct perf_event_attr *pattrs, int nb_events);
 
 extern int			nr_counters;
 
+extern int grp_leaders[MAX_COUNTERS];
 extern struct perf_event_attr attrs[MAX_COUNTERS];
 extern char *filters[MAX_COUNTERS];
 
-- 
1.7.0.4


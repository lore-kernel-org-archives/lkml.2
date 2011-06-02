Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758707Ab1FBIEa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 04:04:30 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:55174 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753021Ab1FBIEZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 04:04:25 -0400
Date: Thu, 2 Jun 2011 09:04:20 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@lists.linux-foundation.org>, mingo@elte.hu,
        acme@redhat.com, ming.m.lin@intel.com, "Brown, Len" <lenb@kernel.org>
Subject: Re: [PATCH 2/3] introduce intel_rapl driver
Message-ID: <20110602090420.73cac52f@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <20110526105527.GA27748@console-pimps.org>
References: <1306398857.2207.157.camel@rui>
	<1306403003.1200.41.camel@twins>
	<20110526105527.GA27748@console-pimps.org>
X-Mailer: Claws Mail 3.7.8cvs52 (GTK+ 2.22.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 May 2011 11:55:38 +0100
Matt Fleming <matt@console-pimps.org> wrote:

> On Thu, May 26, 2011 at 11:43:23AM +0200, Peter Zijlstra wrote:
>
> > If you expect you actually want to sample, use this event as part of a
> > group and add a sampling event in there and use PERF_FORMAT_GROUP, Matt
> > was working on patches to make perf-record capable of this.
> 
> Yep, I have some unfinished patches around here somewhere...
> 
> *rummage*
> 
> OK, they're in this repository on the perf/group-events branch,
> 
>     git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/sh-2.6.git
> 
> Obviously since I last touched them in November of last year they're
> more than likely not going to apply cleanly to tip, and perhaps more
> importantly, I don't think I ever submitted them to LKML for review.

OK, my previous patches didn't apply at all and I had to rewrite them.
This is what I came up with. It's not quite finished (it's missing
perf-report changes) but should be enough to get you started if indeed
you need this functionality. I've only touched the perf-record code but
it should be trivial to add support to builtin-stat.c.

-------->8--------

>From e19c94e9968489746ee8d8519ce4a6afbcb4d7cc Mon Sep 17 00:00:00 2001
From: Matt Fleming <matt.fleming@linux.intel.com>
Date: Tue, 31 May 2011 11:19:01 +0100
Subject: [PATCH] perf: Add support for group events

Allow events to be grouped so that they are scheduled together on the
performance hardware.

Signed-off-by: Matt Fleming <matt.fleming@linux.intel.com>
---
 tools/perf/builtin-record.c    |   17 ++++++++++-----
 tools/perf/util/evlist.c       |   23 +++++++++++++++++---
 tools/perf/util/evsel.c        |    3 ++
 tools/perf/util/evsel.h        |    2 +
 tools/perf/util/parse-events.c |   43 +++++++++++++++++++++++++++++++++++++++-
 5 files changed, 77 insertions(+), 11 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 8e2c857..4c9412b 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -163,10 +163,11 @@ static void config_attr(struct perf_evsel *evsel, struct perf_evlist *evlist)
 	struct perf_event_attr *attr = &evsel->attr;
 	int track = !evsel->idx; /* only the first counter needs these */
 
-	attr->inherit		= !no_inherit;
-	attr->read_format	= PERF_FORMAT_TOTAL_TIME_ENABLED |
-				  PERF_FORMAT_TOTAL_TIME_RUNNING |
-				  PERF_FORMAT_ID;
+	attr->inherit		= !no_inherit &&
+				  (!(attr->read_format & PERF_FORMAT_GROUP));
+	attr->read_format	|= PERF_FORMAT_TOTAL_TIME_ENABLED |
+				   PERF_FORMAT_TOTAL_TIME_RUNNING |
+				   PERF_FORMAT_ID;
 
 	attr->sample_type	|= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
 
@@ -176,9 +177,13 @@ static void config_attr(struct perf_evsel *evsel, struct perf_evlist *evlist)
 	/*
 	 * We default some events to a 1 default interval. But keep
 	 * it a weak assumption overridable by the user.
+	 *
+	 * We only allow the default to be overridden if the event is
+	 * not part of a group, or if the event is the leader of a group.
 	 */
-	if (!attr->sample_period || (user_freq != UINT_MAX &&
-				     user_interval != ULLONG_MAX)) {
+	if ((!evsel->group || (evsel->group == evsel)) &&
+	    (!attr->sample_period || (user_freq != UINT_MAX &&
+				      user_interval != ULLONG_MAX))) {
 		if (freq) {
 			attr->sample_type	|= PERF_SAMPLE_PERIOD;
 			attr->freq		= 1;
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 50aa348..a7f0f8c 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -133,17 +133,31 @@ static int perf_evlist__id_add_fd(struct perf_evlist *evlist,
 {
 	u64 read_data[4] = { 0, };
 	int id_idx = 1; /* The first entry is the counter value */
+	size_t data_sz;
+	u64 *data;
+
+	data_sz = sizeof(u64) * 4;
+
+	if (evsel->group == evsel) {
+		data_sz += evsel->group_cnt * sizeof(u64) * 4;
+		data = malloc(data_sz);
+		if (!data)
+			return -1;
+	} else
+		data = read_data;
 
 	if (!(evsel->attr.read_format & PERF_FORMAT_ID) ||
-	    read(fd, &read_data, sizeof(read_data)) == -1)
+	    read(fd, data, data_sz) == -1)
 		return -1;
 
 	if (evsel->attr.read_format & PERF_FORMAT_TOTAL_TIME_ENABLED)
 		++id_idx;
 	if (evsel->attr.read_format & PERF_FORMAT_TOTAL_TIME_RUNNING)
 		++id_idx;
+	if (evsel->group_cnt)
+		++id_idx;
 
-	perf_evlist__id_add(evlist, evsel, cpu, thread, read_data[id_idx]);
+	perf_evlist__id_add(evlist, evsel, cpu, thread, data[id_idx]);
 	return 0;
 }
 
@@ -466,9 +480,10 @@ u64 perf_evlist__sample_type(struct perf_evlist *evlist)
 	u64 type = 0;
 
 	list_for_each_entry(pos, &evlist->entries, node) {
+		u64 mask = PERF_SAMPLE_PERIOD | PERF_SAMPLE_READ;
 		if (!type)
-			type = pos->attr.sample_type;
-		else if (type != pos->attr.sample_type)
+			type = (pos->attr.sample_type & ~mask);
+		else if (type != (pos->attr.sample_type & ~mask))
 			die("non matching sample_type");
 	}
 
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index cca29ed..53960e1 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -208,6 +208,9 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 			if (!evsel->cgrp)
 				pid = threads->map[thread];
 
+			if (evsel->group && evsel->group != evsel)
+				group_fd = FD(evsel->group, cpu, thread);
+
 			FD(evsel, cpu, thread) = sys_perf_event_open(&evsel->attr,
 								     pid,
 								     cpus->map[cpu],
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index f79bb2c..14be4b9 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -61,6 +61,8 @@ struct perf_evsel {
 		off_t		id_offset;
 	};
 	struct cgroup_sel	*cgrp;
+	struct perf_evsel	*group;
+	u64			group_cnt;
 };
 
 struct cpu_map;
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 41982c3..60a3479 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -737,6 +737,9 @@ parse_event_modifier(const char **strp, struct perf_event_attr *attr)
 	if (*str == ',')
 		return 0;
 
+	if (*str == '}')
+		return 0;
+
 	if (*str++ != ':')
 		return -1;
 
@@ -825,18 +828,44 @@ modifier:
 int parse_events(const struct option *opt, const char *str, int unset __used)
 {
 	struct perf_evlist *evlist = *(struct perf_evlist **)opt->value;
+	struct perf_evsel *group_evsel = NULL;
 	struct perf_event_attr attr;
 	enum event_result ret;
 	const char *ostr;
+	u64 group_cnt = 0;
 
 	for (;;) {
 		ostr = str;
 		memset(&attr, 0, sizeof(attr));
+
+		if (*str == '{') {
+			/* Already parsing a group? */
+			if (group_evsel != NULL)
+				return -1;
+
+			/* Create an event group */
+			attr.config = PERF_COUNT_SW_TASK_CLOCK;
+			attr.type = PERF_TYPE_SOFTWARE;
+			attr.read_format = PERF_FORMAT_GROUP |
+				PERF_FORMAT_TOTAL_TIME_RUNNING |
+				PERF_FORMAT_TOTAL_TIME_ENABLED;
+			attr.sample_type = PERF_SAMPLE_READ;
+
+			group_evsel = perf_evsel__new(&attr, evlist->nr_entries);
+			if (group_evsel == NULL)
+				return -1;
+
+			group_evsel->group = group_evsel;
+			perf_evlist__add(evlist, group_evsel);
+			str++;
+		}
+
+		memset(&attr, 0, sizeof(attr));
 		ret = parse_event_symbols(opt, &str, &attr);
 		if (ret == EVT_FAILED)
 			return -1;
 
-		if (!(*str == 0 || *str == ',' || isspace(*str)))
+		if (!(*str == 0 || *str == ',' || isspace(*str) || *str == '}'))
 			return -1;
 
 		if (ret != EVT_HANDLED_ALL) {
@@ -844,12 +873,24 @@ int parse_events(const struct option *opt, const char *str, int unset __used)
 			evsel = perf_evsel__new(&attr, evlist->nr_entries);
 			if (evsel == NULL)
 				return -1;
+
+			if (group_evsel)
+				evsel->group = group_evsel;
+
 			perf_evlist__add(evlist, evsel);
 
 			evsel->name = calloc(str - ostr + 1, 1);
 			if (!evsel->name)
 				return -1;
 			strncpy(evsel->name, ostr, str - ostr);
+			group_cnt++;
+		}
+
+		if (*str == '}') {
+			group_evsel->group_cnt = group_cnt;
+			group_evsel = NULL;
+			group_cnt = 0;
+			str++;
 		}
 
 		if (*str == 0)
-- 
1.7.4.4


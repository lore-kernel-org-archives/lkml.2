Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab1DVQXn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 12:23:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:53418 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756012Ab1DVQXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 12:23:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,254,1301900400"; 
   d="scan'208";a="913202767"
Date: Fri, 22 Apr 2011 09:22:48 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 1/1] perf tools: Add missing user space support for
 config1/config2
Message-ID: <20110422162248.GC10755@tassilo.jf.intel.com>
References: <1303407662-15564-1-git-send-email-acme@infradead.org>
 <1303407662-15564-2-git-send-email-acme@infradead.org>
 <20110422063429.GA16643@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110422063429.GA16643@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 22, 2011 at 08:34:29AM +0200, Ingo Molnar wrote:
> This needs to be a *lot* more user friendly. Users do not want to type in 
> stupid hexa magic numbers to get profiling. We have moved beyond the oprofile 
> era really.

I agree that the raw events are quite user unfriendly.

Unfortunately they are the way of life in perf -- unlike oprofile -- currently
if you want any CPU specific events like this.

Really to make sense out of all this you need per CPU full event lists.

I have an own wrapper to make it more user friendly, but its functionality
should arguably migrate into perf.

I did a patch to add a mapping file some time ago, but it likely
needs some improvements before it can be merged (aka not .39), like
auto selecting a suitable mapping file and backtranslating raw
mappings on output.

BTW the new perf lat code needs the raw events config1 specification
internally, so this is needed in some form anyways.

Short of that the extended raw events is the best we can get short term I 
think. So I would prefer to have it for .39 to make this feature
usable at all.

I attached the old mapping file patch for your reference. 
I also put up a few mapping files for Intel CPUs at 
ftp://ftp.kernel.org/pub/linux/kernel/people/ak/pmu/*

e.g. to use it with Nehalem offcore events and this patch you would 
use today

wget ftp://ftp.kernel.org/pub/linux/kernel/people/ak/pmu/nhm-ep.map
perf --map-file nhm-ep.map top -e offcore_response_0.any_data.local_cache_dram

-Andi

commit 37323c19ceb57101cc2160059c567ee14055b7c8
Author: Andi Kleen <ak@linux.intel.com>
Date:   Mon Nov 8 04:52:18 2010 +0100

    mapping file support

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index a91f9f9..63bdbbb 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -120,6 +120,9 @@ Do not update the builid cache. This saves some overhead in situations
 where the information in the perf.data file (which includes buildids)
 is sufficient.
 
+--map-events=file
+Use file as event mapping file.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-list[1]
diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
index 4b3a2d4..4f20af3 100644
--- a/tools/perf/Documentation/perf-stat.txt
+++ b/tools/perf/Documentation/perf-stat.txt
@@ -53,6 +53,9 @@ comma-sperated list with no space: 0,1. Ranges of CPUs are specified with -: 0-2
 In per-thread mode, this option is ignored. The -a option is still necessary
 to activate system-wide monitoring. Default is to count on all CPUs.
 
+--map-events=file
+Use file as event mapping file.
+
 EXAMPLES
 --------
 
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 93bd2ff..6fdf892 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -794,6 +794,9 @@ const struct option record_options[] = {
 	OPT_CALLBACK('e', "event", NULL, "event",
 		     "event selector. use 'perf list' to list available events",
 		     parse_events),
+	OPT_CALLBACK(0, "map-events", NULL, "map-events",
+		     "specify mapping file for events",
+		     map_events),
 	OPT_CALLBACK(0, "filter", NULL, "filter",
 		     "event filter", parse_filter),
 	OPT_INTEGER('p', "pid", &target_pid,
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index a6b4d44..f21f307 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -525,6 +525,9 @@ static const struct option options[] = {
 	OPT_CALLBACK('e', "event", NULL, "event",
 		     "event selector. use 'perf list' to list available events",
 		     parse_events),
+	OPT_CALLBACK(0, "map-events", NULL, "map-events",
+		     "specify mapping file for events",
+		     map_events),
 	OPT_BOOLEAN('i', "no-inherit", &no_inherit,
 		    "child tasks do not inherit counters"),
 	OPT_INTEGER('p', "pid", &target_pid,
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 4af5bd5..2cc7b3d 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -83,6 +83,14 @@ static const char *sw_event_names[] = {
 	"emulation-faults",
 };
 
+struct mapping {
+	const char *str;
+	const char *res;
+};
+
+static int 		mapping_max;
+static struct mapping  *mappings;
+
 #define MAX_ALIASES 8
 
 static const char *hw_cache[][MAX_ALIASES] = {
@@ -731,12 +739,28 @@ parse_event_modifier(const char **strp, struct perf_event_attr *attr)
 	return 0;
 }
 
+static int cmp_mapping(const void *a, const void *b)
+{
+	const struct mapping *am = a;
+	const struct mapping *bm = b;
+	return strcmp(am->str, bm->str);
+}
+
+static const char *
+get_event_mapping(const char *str)
+{
+	struct mapping key = { .str = str };
+	struct mapping *r = bsearch(&key, mappings, mapping_max,
+				    sizeof(struct mapping), cmp_mapping);
+	return r ? r->res : NULL;
+}
+
 /*
  * Each event can have multiple symbolic names.
  * Symbolic names are (almost) exactly matched.
  */
 static enum event_result
-parse_event_symbols(const char **str, struct perf_event_attr *attr)
+do_parse_event_symbols(const char **str, struct perf_event_attr *attr)
 {
 	enum event_result ret;
 
@@ -774,6 +798,15 @@ modifier:
 	return ret;
 }
 
+static enum event_result
+parse_event_symbols(const char **str, struct perf_event_attr *attr)
+{
+	const char *map = get_event_mapping(*str);
+	if (map)
+		*str = map;
+	return do_parse_event_symbols(str, attr);
+}
+
 static int store_event_type(const char *orgname)
 {
 	char filename[PATH_MAX], *c;
@@ -963,3 +996,54 @@ void print_events(void)
 
 	exit(129);
 }
+
+int map_events(const struct option *opt __used, const char *str,
+		int unset __used)
+{
+	FILE *f;
+	char *line = NULL;
+	size_t linelen = 0;
+	char *p;
+	int lineno = 0;
+	static int mapping_size;
+	struct mapping *map;
+
+	f = fopen(str, "r");
+	if (!f) {
+		pr_err("Cannot open event map file");
+		return -1;
+	}
+	while (getline(&line, &linelen, f) > 0) {
+		lineno++;
+		p = strpbrk(line, "\n#");
+		if (p)
+			*p = 0;
+		p = line + strspn(line, " \t");
+		if (*p == 0)
+			continue;
+		if (mapping_max >= mapping_size) {
+			if (!mapping_size)
+				mapping_size = 2048;
+			mapping_size *= 2;
+			mappings = realloc(mappings,
+				      mapping_size * sizeof(struct mapping));
+			if (!mappings) {
+				pr_err("Out of memory\n");
+				exit(ENOMEM);
+			}
+		}
+		map = &mappings[mapping_max++];
+		map->str = strsep(&p, " \t");
+		map->res = strsep(&p, " \t");
+		if (!map->str || !map->res) {
+			fprintf(stderr, "%s:%d: Invalid line in map file\n",
+				str, lineno);
+		}
+		line = NULL;
+		linelen = 0;
+	}
+	fclose(f);
+	qsort(mappings, mapping_max, sizeof(struct mapping),
+	      cmp_mapping);
+	return 0;
+}
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index fc4ab3f..1d6df9c 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -33,5 +33,6 @@ extern void print_events(void);
 extern char debugfs_path[];
 extern int valid_debugfs_mount(const char *debugfs);
 
+extern int map_events(const struct option *opt, const char *str, int unset);
 
 #endif /* __PERF_PARSE_EVENTS_H */

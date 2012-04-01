Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab2DABmM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 21:42:12 -0400
Received: from mga14.intel.com ([143.182.124.37]:31796 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752999Ab2DABlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 21:41:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="125662202"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: a.p.zijlstra@chello.nl, mingo@elte.hu, andi@firstfloor.org,
        eranian@google.com
Cc: linux-kernel@vger.kernel.org, ming.m.lin@intel.com
Subject: [PATCH 4/6] perf tool: Parse general events from sysfs
Date: Sun,  1 Apr 2012 09:41:33 +0800
Message-Id: <1333244495-1020-5-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1333244495-1020-1-git-send-email-zheng.z.yan@intel.com>
References: <1333244495-1020-1-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

PMU can export general events to sysfs, for example:

/sys/bus/event_source/devices/uncore_nhm/events
└── CLOCKTICKS

Then we can specify the event as "<pmu>/<event>/", for example:

perf stat -a -C 0 -e "uncore_nhm/CLOCKTICKS/" sleep 1

Signed-off-by: Zheng Yan <zheng.z.yan@intel.com>
---
 tools/perf/util/parse-events.c |   24 ++++++--
 tools/perf/util/parse-events.h |    6 +-
 tools/perf/util/parse-events.y |    6 +-
 tools/perf/util/pmu.c          |  140 +++++++++++++++++++++++++++++++++++++++-
 tools/perf/util/pmu.h          |   11 +++-
 5 files changed, 172 insertions(+), 15 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 5b3a0ef..fdac544 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -24,7 +24,7 @@ struct event_symbol {
 };
 
 int parse_events_parse(struct list_head *list, struct list_head *list_tmp,
-		       int *idx);
+			int *idx, char **newcfg);
 
 #define CHW(x) .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_##x
 #define CSW(x) .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_##x
@@ -648,8 +648,8 @@ int parse_events_add_numeric(struct list_head *list, int *idx,
 			 (char *) __event_name(type, config));
 }
 
-int parse_events_add_pmu(struct list_head *list, int *idx,
-			 char *name, struct list_head *head_config)
+int parse_events_add_pmu(struct list_head *list, char **newcfg,
+			int *idx, char *name, struct list_head *head_config)
 {
 	struct perf_event_attr attr;
 	struct perf_pmu *pmu;
@@ -666,9 +666,12 @@ int parse_events_add_pmu(struct list_head *list, int *idx,
 	 */
 	config_attr(&attr, head_config, 0);
 
-	if (perf_pmu__config(pmu, &attr, head_config))
+	if (perf_pmu__config(pmu, head_config, &attr, newcfg))
 		return -EINVAL;
 
+	if (newcfg && *newcfg)
+		return 0;
+
 	return add_event(list, idx, &attr, (char *) "pmu");
 }
 
@@ -753,14 +756,25 @@ int parse_events(struct perf_evlist *evlist, const char *str, int unset __used)
 	LIST_HEAD(list_tmp);
 	YY_BUFFER_STATE buffer;
 	int ret, idx = evlist->nr_entries;
+	char *newcfg = NULL;
 
 	buffer = parse_events__scan_string(str);
 
-	ret = parse_events_parse(&list, &list_tmp, &idx);
+	ret = parse_events_parse(&list, &list_tmp, &idx, &newcfg);
 
 	parse_events__flush_buffer(buffer);
 	parse_events__delete_buffer(buffer);
 
+	if (!ret && newcfg) {
+		buffer = parse_events__scan_string(newcfg);
+
+		ret = parse_events_parse(&list, &list_tmp, &idx, NULL);
+
+		parse_events__flush_buffer(buffer);
+		parse_events__delete_buffer(buffer);
+		free(newcfg);
+	}
+
 	if (!ret) {
 		int entries = idx - evlist->nr_entries;
 		perf_evlist__splice_list_tail(evlist, &list, entries);
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index ca069f8..24924fd 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -74,13 +74,13 @@ int parse_events_add_cache(struct list_head *list, int *idx,
 			   char *type, char *op_result1, char *op_result2);
 int parse_events_add_breakpoint(struct list_head *list, int *idx,
 				void *ptr, char *type);
-int parse_events_add_pmu(struct list_head *list, int *idx,
-			 char *pmu , struct list_head *head_config);
+int parse_events_add_pmu(struct list_head *list, char **newcfg,
+			 int *idx, char *pmu , struct list_head *head_config);
 void parse_events_update_lists(struct list_head *list_event,
 			       struct list_head *list_all);
 void parse_events_error(struct list_head *list_all,
 			struct list_head *list_event,
-			int *idx, char const *msg);
+			int *idx, char **newcfg, char const *msg);
 
 void print_events(const char *event_glob);
 void print_events_type(u8 type);
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index d9637da..5f569f2 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -3,6 +3,7 @@
 %parse-param {struct list_head *list_all}
 %parse-param {struct list_head *list_event}
 %parse-param {int *idx}
+%parse-param {char **newcfg}
 
 %{
 
@@ -82,7 +83,7 @@ event_def: event_pmu |
 event_pmu:
 PE_NAME '/' event_config '/'
 {
-	ABORT_ON(parse_events_add_pmu(list_event, idx, $1, $3));
+	ABORT_ON(parse_events_add_pmu(list_event, newcfg, idx, $1, $3));
 	parse_events__free_terms($3);
 }
 
@@ -194,7 +195,7 @@ PE_NAME
 {
 	struct parse_events__term *term;
 
-	ABORT_ON(parse_events__new_term(&term, PARSE_EVENTS__TERM_TYPE_NUM,
+	ABORT_ON(parse_events__new_term(&term, PARSE_EVENTS__TERM_TYPE_STR,
 		 $1, NULL, 1));
 	$$ = term;
 }
@@ -224,6 +225,7 @@ sep_slash_dc: '/' | ':' |
 void parse_events_error(struct list_head *list_all __used,
 			struct list_head *list_event __used,
 			int *idx __used,
+			char **newcfg __used,
 			char const *msg __used)
 {
 }
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index cb08a11..71244b6 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -80,6 +80,89 @@ static int pmu_format(char *name, struct list_head *format)
 	return 0;
 }
 
+static int perf_pmu__new_event(struct list_head *list, char *name, FILE *file)
+{
+	struct perf_pmu__event *event;
+	char buf[256];
+	int ret;
+
+	ret = fread(buf, 1, sizeof(buf), file);
+	if (ret == 0)
+		return -EINVAL;
+
+	event = zalloc(sizeof(*event));
+	if (!event)
+		return -ENOMEM;
+
+	event->name = strdup(name);
+	event->config = strndup(buf, ret);
+
+	list_add_tail(&event->list, list);
+	return 0;
+}
+
+/*
+ * Process all the sysfs attributes located under the directory
+ * specified in 'dir' parameter.
+ */
+static int pmu_events_parse(char *dir, struct list_head *head)
+{
+	struct dirent *evt_ent;
+	DIR *event_dir;
+	int ret = 0;
+
+	event_dir = opendir(dir);
+	if (!event_dir)
+		return -EINVAL;
+
+	while (!ret && (evt_ent = readdir(event_dir))) {
+		char path[PATH_MAX];
+		char *name = evt_ent->d_name;
+		FILE *file;
+
+		if (!strcmp(name, ".") || !strcmp(name, ".."))
+			continue;
+
+		snprintf(path, PATH_MAX, "%s/%s", dir, name);
+
+		ret = -EINVAL;
+		file = fopen(path, "r");
+		if (!file)
+			break;
+		ret = perf_pmu__new_event(head, name, file);
+		fclose(file);
+	}
+
+	closedir(event_dir);
+	return ret;
+}
+
+/*
+ * Reading the pmu event definition, which should be located at:
+ * /sys/bus/event_source/devices/<dev>/events as sysfs group attributes.
+ */
+static int pmu_events(char *name, struct list_head *events)
+{
+	struct stat st;
+	char path[PATH_MAX];
+	const char *sysfs;
+
+	sysfs = sysfs_find_mountpoint();
+	if (!sysfs)
+		return -1;
+
+	snprintf(path, PATH_MAX,
+		 "%s/bus/event_source/devices/%s/events", sysfs, name);
+
+	if (stat(path, &st) < 0)
+		return -1;
+
+	if (pmu_events_parse(path, events))
+		return -1;
+
+	return 0;
+}
+
 /*
  * Reading/parsing the default pmu type value, which should be
  * located at:
@@ -118,6 +201,7 @@ static struct perf_pmu *pmu_lookup(char *name)
 {
 	struct perf_pmu *pmu;
 	LIST_HEAD(format);
+	LIST_HEAD(events);
 	__u32 type;
 
 	/*
@@ -135,8 +219,12 @@ static struct perf_pmu *pmu_lookup(char *name)
 	if (!pmu)
 		return NULL;
 
+	pmu_events(name, &events);
+
 	INIT_LIST_HEAD(&pmu->format);
+	INIT_LIST_HEAD(&pmu->events);
 	list_splice(&format, &pmu->format);
+	list_splice(&events, &pmu->events);
 	pmu->name = strdup(name);
 	pmu->type = type;
 	return pmu;
@@ -262,16 +350,62 @@ static int pmu_config(struct list_head *formats, struct perf_event_attr *attr,
 	return 0;
 }
 
+
+static struct perf_pmu__event*
+pmu_find_event(struct list_head *events, char *name)
+{
+	struct perf_pmu__event *event;
+
+	list_for_each_entry(event, events, list)
+		if (!strcmp(event->name, name))
+			return event;
+
+	return NULL;
+}
+
+static int pmu_event(struct perf_pmu *pmu, struct list_head *head_terms,
+		     char **newcfg)
+{
+	struct parse_events__term *term;
+	struct perf_pmu__event *event;
+	char *buf;
+
+	if (!list_is_singular(head_terms))
+		return -EINVAL;
+
+	term = list_entry(head_terms->next, struct parse_events__term, list);
+
+	if (term->type != PARSE_EVENTS__TERM_TYPE_STR || term->val.str)
+		return -EINVAL;
+
+	event = pmu_find_event(&pmu->events, term->config);
+	if (!event)
+		return -EINVAL;
+
+	buf = malloc(strlen(pmu->name) + strlen(event->config) + 3);
+	if (!buf)
+		return -ENOMEM;
+
+	sprintf(buf, "%s/%s/", pmu->name, event->config);
+	*newcfg = buf;
+
+	return 0;
+}
+
 /*
  * Configures event's 'attr' parameter based on the:
  * 1) users input - specified in terms parameter
  * 2) pmu format definitions - specified by pmu parameter
  */
-int perf_pmu__config(struct perf_pmu *pmu, struct perf_event_attr *attr,
-		     struct list_head *head_terms)
+int perf_pmu__config(struct perf_pmu *pmu, struct list_head *head_terms,
+		     struct perf_event_attr *attr, char **newcfg)
 {
+	int ret;
 	attr->type = pmu->type;
-	return pmu_config(&pmu->format, attr, head_terms);
+	ret = pmu_config(&pmu->format, attr, head_terms);
+	if (ret == -EINVAL && newcfg)
+		ret = pmu_event(pmu, head_terms, newcfg);
+	return ret;
 }
 
 int perf_pmu__new_format(struct list_head *list, char *name,
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index 68c0db9..2052b3f 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -19,16 +19,23 @@ struct perf_pmu__format {
 	struct list_head list;
 };
 
+struct perf_pmu__event {
+	char *name;
+	char *config;
+	struct list_head list;
+};
+
 struct perf_pmu {
 	char *name;
 	__u32 type;
 	struct list_head format;
+	struct list_head events;
 	struct list_head list;
 };
 
 struct perf_pmu *perf_pmu__find(char *name);
-int perf_pmu__config(struct perf_pmu *pmu, struct perf_event_attr *attr,
-		     struct list_head *head_terms);
+int perf_pmu__config(struct perf_pmu *pmu, struct list_head *head_terms,
+		     struct perf_event_attr *attr, char **newcfg);
 
 int perf_pmu_wrap(void);
 void perf_pmu_error(struct list_head *list, char *name, char const *msg);
-- 
1.7.7.6


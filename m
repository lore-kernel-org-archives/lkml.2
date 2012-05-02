Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758530Ab2EBCIF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 22:08:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:46532 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758523Ab2EBCHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 22:07:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="138970494"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: a.p.zijlstra@chello.nl, mingo@elte.hu, andi@firstfloor.org,
        eranian@google.com, jolsa@redhat.com, ming.m.lin@intel.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 9/9] perf tool: Add pmu event alias support
Date: Wed,  2 May 2012 10:07:20 +0800
Message-Id: <1335924440-11242-10-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1335924440-11242-1-git-send-email-zheng.z.yan@intel.com>
References: <1335924440-11242-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

The definition of pmu event alias is located at:
  ${sysfs_mount}/bus/event_source/devices/${pmu}/events/

Each file in the 'events' directory defines a event alias. Its contents
is like:
  config=1,config1=2

Using pmu event alias, event could be now specified like:
  uncore/CLOCKTICKS/

Signed-off-by: Zheng Yan <zheng.z.yan@intel.com>
---
 tools/perf/util/parse-events.c |   24 ++++++++-
 tools/perf/util/parse-events.y |    2 +-
 tools/perf/util/pmu.c          |  117 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/pmu.h          |   10 +++-
 4 files changed, 149 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index c587ae8..764b2c31 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -653,8 +653,12 @@ int parse_events_add_numeric(struct list_head *list, int *idx,
 int parse_events_add_pmu(struct list_head *list, int *idx,
 			 char *name, struct list_head *head_config)
 {
+	LIST_HEAD(event);
 	struct perf_event_attr attr;
 	struct perf_pmu *pmu;
+	const char *config;
+	char *str;
+	int ret;
 
 	pmu = perf_pmu__find(name);
 	if (!pmu)
@@ -668,10 +672,26 @@ int parse_events_add_pmu(struct list_head *list, int *idx,
 	 */
 	config_attr(&attr, head_config, 0);
 
-	if (perf_pmu__config(pmu, &attr, head_config))
+	ret = perf_pmu__config(pmu, &attr, head_config);
+	if (!ret)
+		return add_event(list, idx, &attr, (char *) "pmu");
+
+	config = perf_pmu__alias(pmu, head_config);
+	if (!config)
 		return -EINVAL;
 
-	return add_event(list, idx, &attr, (char *) "pmu");
+	str = malloc(strlen(pmu->name) + strlen(config) + 3);
+	if (!str)
+		return -ENOMEM;
+
+	sprintf(str, "%s/%s/", pmu->name, config);
+	ret =  __parse_events(str, idx, &event);
+	free(str);
+	if (ret)
+		return ret;
+
+	list_splice_tail(&event, list);
+	return 0;
 }
 
 void parse_events_update_lists(struct list_head *list_event,
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 52082a7..8a26f3d 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -197,7 +197,7 @@ PE_NAME
 {
 	struct parse_events__term *term;
 
-	ABORT_ON(parse_events__new_term(&term, PARSE_EVENTS__TERM_TYPE_NUM,
+	ABORT_ON(parse_events__new_term(&term, PARSE_EVENTS__TERM_TYPE_STR,
 		 $1, NULL, 1));
 	$$ = term;
 }
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index cb08a11..13dde6c 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -80,6 +80,89 @@ static int pmu_format(char *name, struct list_head *format)
 	return 0;
 }
 
+static int perf_pmu__new_alias(struct list_head *list, char *name, FILE *file)
+{
+	struct perf_pmu__alias *alias;
+	char buf[256];
+	int ret;
+
+	ret = fread(buf, 1, sizeof(buf), file);
+	if (ret == 0)
+		return -EINVAL;
+
+	alias = zalloc(sizeof(*alias));
+	if (!alias)
+		return -ENOMEM;
+
+	alias->name = strdup(name);
+	alias->config = strndup(buf, ret);
+
+	list_add_tail(&alias->list, list);
+	return 0;
+}
+
+/*
+ * Process all the sysfs attributes located under the directory
+ * specified in 'dir' parameter.
+ */
+static int pmu_aliases_parse(char *dir, struct list_head *head)
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
+		ret = perf_pmu__new_alias(head, name, file);
+		fclose(file);
+	}
+
+	closedir(event_dir);
+	return ret;
+}
+
+/*
+ * Reading the pmu event aliases definition, which should be located at:
+ * /sys/bus/event_source/devices/<dev>/events as sysfs group attributes.
+ */
+static int pmu_aliases(char *name, struct list_head *aliases)
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
+	if (pmu_aliases_parse(path, aliases))
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
+	LIST_HEAD(aliases);
 	__u32 type;
 
 	/*
@@ -135,8 +219,12 @@ static struct perf_pmu *pmu_lookup(char *name)
 	if (!pmu)
 		return NULL;
 
+	pmu_aliases(name, &aliases);
+
 	INIT_LIST_HEAD(&pmu->format);
+	INIT_LIST_HEAD(&pmu->aliases);
 	list_splice(&format, &pmu->format);
+	list_splice(&aliases, &pmu->aliases);
 	pmu->name = strdup(name);
 	pmu->type = type;
 	return pmu;
@@ -262,6 +350,18 @@ static int pmu_config(struct list_head *formats, struct perf_event_attr *attr,
 	return 0;
 }
 
+static struct perf_pmu__alias *pmu_find_alias(struct list_head *events,
+					      char *name)
+{
+	struct perf_pmu__alias *alias;
+
+	list_for_each_entry(alias, events, list) {
+		if (!strcmp(alias->name, name))
+			return alias;
+	}
+	return NULL;
+}
+
 /*
  * Configures event's 'attr' parameter based on the:
  * 1) users input - specified in terms parameter
@@ -274,6 +374,23 @@ int perf_pmu__config(struct perf_pmu *pmu, struct perf_event_attr *attr,
 	return pmu_config(&pmu->format, attr, head_terms);
 }
 
+const char *perf_pmu__alias(struct perf_pmu *pmu, struct list_head *head_terms)
+{
+	struct parse_events__term *term;
+	struct perf_pmu__alias *alias;
+
+	term = list_entry(head_terms->next, struct parse_events__term, list);
+
+	if (term->type != PARSE_EVENTS__TERM_TYPE_STR || term->val.str)
+		return NULL;
+
+	alias = pmu_find_alias(&pmu->aliases, term->config);
+	if (!alias)
+		return NULL;
+
+	return alias->config;
+}
+
 int perf_pmu__new_format(struct list_head *list, char *name,
 			 int config, unsigned long *bits)
 {
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index 68c0db9..7a100fe 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -19,17 +19,25 @@ struct perf_pmu__format {
 	struct list_head list;
 };
 
+struct perf_pmu__alias {
+	char *name;
+	char *config;
+	struct list_head list;
+};
+
 struct perf_pmu {
 	char *name;
 	__u32 type;
 	struct list_head format;
+	struct list_head aliases;
 	struct list_head list;
 };
 
 struct perf_pmu *perf_pmu__find(char *name);
 int perf_pmu__config(struct perf_pmu *pmu, struct perf_event_attr *attr,
 		     struct list_head *head_terms);
-
+const char *perf_pmu__alias(struct perf_pmu *pmu,
+			    struct list_head *head_terms);
 int perf_pmu_wrap(void);
 void perf_pmu_error(struct list_head *list, char *name, char const *msg);
 
-- 
1.7.7.6


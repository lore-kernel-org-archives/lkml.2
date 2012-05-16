Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967355Ab2EPFAn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 01:00:43 -0400
Received: from mga14.intel.com ([143.182.124.37]:54288 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967338Ab2EPFAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 01:00:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="100617344"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: a.p.zijlstra@chello.nl, mingo@elte.hu, andi@firstfloor.org,
        eranian@google.com, jolsa@redhat.com, ming.m.lin@intel.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 10/10] perf tool: Add pmu event alias support
Date: Wed, 16 May 2012 13:00:03 +0800
Message-Id: <1337144403-30841-11-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1337144403-30841-1-git-send-email-zheng.z.yan@intel.com>
References: <1337144403-30841-1-git-send-email-zheng.z.yan@intel.com>
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
 tools/perf/util/parse-events.c |   27 +++++++
 tools/perf/util/parse-events.h |    1 +
 tools/perf/util/parse-events.y |    2 +-
 tools/perf/util/pmu.c          |  153 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/pmu.h          |   11 +++-
 5 files changed, 192 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index c587ae8..b90d671 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -656,12 +656,20 @@ int parse_events_add_pmu(struct list_head *list, int *idx,
 	struct perf_event_attr attr;
 	struct perf_pmu *pmu;
 
+	/* called by parse_event_config? */
+	if (!strcmp(name, "__config")) {
+		list_splice_init(head_config, list);
+		return 0;
+	}
+
 	pmu = perf_pmu__find(name);
 	if (!pmu)
 		return -EINVAL;
 
 	memset(&attr, 0, sizeof(attr));
 
+	if (perf_pmu__check_alias(pmu, head_config))
+		return -EINVAL;
 	/*
 	 * Configure hardcoded terms first, no need to check
 	 * return value when called with fail == 0 ;)
@@ -771,6 +779,25 @@ static int __parse_events(const char *str, int *idx, struct list_head *list)
 	return ret;
 }
 
+/*
+ * parse event config string, return a list of event terms.
+ */
+int parse_event_config(struct list_head *terms, const char *str)
+{
+	char *buf;
+	int ret;
+
+	buf = malloc(strlen(str) + 10);
+	if (!buf)
+		return -ENOMEM;
+
+	sprintf(buf, "__config/%s/", str);
+	ret = __parse_events(buf, NULL, terms);
+
+	free(buf);
+	return ret;
+}
+
 int parse_events(struct perf_evlist *evlist, const char *str, int unset __used)
 {
 	LIST_HEAD(list);
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 6a98b8d..67f7948 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -32,6 +32,7 @@ extern int parse_events_option(const struct option *opt, const char *str,
 extern int parse_events(struct perf_evlist *evlist, const char *str,
 			int unset);
 extern int parse_filter(const struct option *opt, const char *str, int unset);
+extern int parse_event_config(struct list_head *terms, const char *str);
 
 #define EVENTS_HELP_MAX (128*1024)
 
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
index cb08a11..f74a1dc 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -80,6 +80,131 @@ static int pmu_format(char *name, struct list_head *format)
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
+	buf[ret] = 0;
+
+	alias = malloc(sizeof(*alias));
+	if (!alias)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&alias->terms);
+	ret = parse_event_config(&alias->terms, buf);
+	if (ret) {
+		free(alias);
+		return ret;
+	}
+
+	alias->name = strdup(name);
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
+static int pmu_aliases(char *name, struct list_head *head)
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
+	if (pmu_aliases_parse(path, head))
+		return -1;
+
+	return 0;
+}
+
+static struct perf_pmu__alias *pmu_find_alias(struct list_head *aliases,
+					struct parse_events__term *term)
+{
+	struct perf_pmu__alias *alias;
+
+	if (term->type != PARSE_EVENTS__TERM_TYPE_STR || term->val.str)
+		return NULL;
+
+	list_for_each_entry(alias, aliases, list) {
+		if (!strcmp(alias->name, term->config))
+			return alias;
+	}
+
+	return NULL;
+}
+
+static int pmu_alias_terms(struct perf_pmu__alias *alias,
+			   struct list_head *terms)
+{
+	struct parse_events__term *term, *clone;
+	LIST_HEAD(list);
+	int ret;
+
+	list_for_each_entry(term, &alias->terms, list) {
+		ret = parse_events__new_term(&clone, term->type, term->config,
+						term->val.str, term->val.num);
+		if (ret) {
+			parse_events__free_terms(&list);
+			return ret;
+		}
+		list_add_tail(&clone->list, &list);
+	}
+	list_splice(&list, terms);
+	return 0;
+}
+
 /*
  * Reading/parsing the default pmu type value, which should be
  * located at:
@@ -118,6 +243,7 @@ static struct perf_pmu *pmu_lookup(char *name)
 {
 	struct perf_pmu *pmu;
 	LIST_HEAD(format);
+	LIST_HEAD(aliases);
 	__u32 type;
 
 	/*
@@ -135,8 +261,12 @@ static struct perf_pmu *pmu_lookup(char *name)
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
@@ -274,6 +404,29 @@ int perf_pmu__config(struct perf_pmu *pmu, struct perf_event_attr *attr,
 	return pmu_config(&pmu->format, attr, head_terms);
 }
 
+/*
+ * Find alias in the terms list and replace it with the terms
+ * defined for the alias
+ */
+int perf_pmu__check_alias(struct perf_pmu *pmu, struct list_head *head_terms)
+{
+	struct parse_events__term *term, *h;
+	struct perf_pmu__alias *alias;
+	int ret;
+
+	list_for_each_entry_safe(term, h, head_terms, list) {
+		alias = pmu_find_alias(&pmu->aliases, term);
+		if (!alias)
+			continue;
+		ret = pmu_alias_terms(alias, &term->list);
+		if (ret)
+			return ret;
+		list_del(&term->list);
+		free(term);
+	}
+	return 0;
+}
+
 int perf_pmu__new_format(struct list_head *list, char *name,
 			 int config, unsigned long *bits)
 {
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index 68c0db9..535f2c5 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -19,17 +19,26 @@ struct perf_pmu__format {
 	struct list_head list;
 };
 
+struct perf_pmu__alias {
+	char *name;
+	struct list_head terms;
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
+int perf_pmu__check_alias(struct perf_pmu *pmu, struct list_head *head_terms);
+struct list_head *perf_pmu__alias(struct perf_pmu *pmu,
+				struct list_head *head_terms);
 int perf_pmu_wrap(void);
 void perf_pmu_error(struct list_head *list, char *name, char const *msg);
 
-- 
1.7.7.6


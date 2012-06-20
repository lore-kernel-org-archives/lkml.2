Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab2FTLAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 07:00:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34679 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab2FTLAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 07:00:46 -0400
Date: Wed, 20 Jun 2012 04:00:29 -0700
From: tip-bot for Zheng Yan <zheng.z.yan@intel.com>
Message-ID: <tip-a6146d5040cce560f700221158d77dd335eed332@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, akpm@linux-foundation.org, zheng.z.yan@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, zheng.z.yan@intel.com,
        tglx@linutronix.de, jolsa@redhat.com
In-Reply-To: <1339741902-8449-13-git-send-email-zheng.z.yan@intel.com>
References: <1339741902-8449-13-git-send-email-zheng.z.yan@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/tool: Add PMU event alias support
Git-Commit-ID: a6146d5040cce560f700221158d77dd335eed332
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 20 Jun 2012 04:00:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a6146d5040cce560f700221158d77dd335eed332
Gitweb:     http://git.kernel.org/tip/a6146d5040cce560f700221158d77dd335eed332
Author:     Zheng Yan <zheng.z.yan@intel.com>
AuthorDate: Fri, 15 Jun 2012 14:31:41 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 18 Jun 2012 12:13:26 +0200

perf/tool: Add PMU event alias support

Add support to specify alias term within the event description.

The definition of pmu event alias is located at:

  ${sysfs_mount}/bus/event_source/devices/${pmu}/events/

Each file in the 'events' directory defines a event alias. Its contents
are like:

  config=1,config1=2

Using pmu event alias, an event can be now specified like:

  uncore/CLOCKTICKS/ or uncore/event=CLOCKTICKS/

Signed-off-by: Zheng Yan <zheng.z.yan@intel.com>
[ Cleaned it up. ]
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1339741902-8449-13-git-send-email-zheng.z.yan@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/util/parse-events.c |   10 +++
 tools/perf/util/parse-events.h |    2 +
 tools/perf/util/pmu.c          |  166 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/pmu.h          |   11 +++-
 4 files changed, 188 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index d002170..3339424 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -701,6 +701,9 @@ int parse_events_add_pmu(struct list_head **list, int *idx,
 
 	memset(&attr, 0, sizeof(attr));
 
+	if (perf_pmu__check_alias(pmu, head_config))
+		return -EINVAL;
+
 	/*
 	 * Configure hardcoded terms first, no need to check
 	 * return value when called with fail == 0 ;)
@@ -1143,6 +1146,13 @@ int parse_events__term_str(struct parse_events__term **term,
 			config, str, 0);
 }
 
+int parse_events__term_clone(struct parse_events__term **new,
+			     struct parse_events__term *term)
+{
+	return new_term(new, term->type_val, term->type_term, term->config,
+			term->val.str, term->val.num);
+}
+
 void parse_events__free_terms(struct list_head *terms)
 {
 	struct parse_events__term *term, *h;
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 9896eda..a2c7168 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -78,6 +78,8 @@ int parse_events__term_num(struct parse_events__term **_term,
 			   int type_term, char *config, long num);
 int parse_events__term_str(struct parse_events__term **_term,
 			   int type_term, char *config, char *str);
+int parse_events__term_clone(struct parse_events__term **new,
+			     struct parse_events__term *term);
 void parse_events__free_terms(struct list_head *terms);
 int parse_events_modifier(struct list_head *list, char *str);
 int parse_events_add_tracepoint(struct list_head **list, int *idx,
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index a119a53..74d0948e 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -80,6 +80,114 @@ static int pmu_format(char *name, struct list_head *format)
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
+	ret = parse_events_terms(&alias->terms, buf);
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
+static int pmu_alias_terms(struct perf_pmu__alias *alias,
+			   struct list_head *terms)
+{
+	struct parse_events__term *term, *clone;
+	LIST_HEAD(list);
+	int ret;
+
+	list_for_each_entry(term, &alias->terms, list) {
+		ret = parse_events__term_clone(&clone, term);
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
@@ -118,6 +226,7 @@ static struct perf_pmu *pmu_lookup(char *name)
 {
 	struct perf_pmu *pmu;
 	LIST_HEAD(format);
+	LIST_HEAD(aliases);
 	__u32 type;
 
 	/*
@@ -135,8 +244,12 @@ static struct perf_pmu *pmu_lookup(char *name)
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
@@ -279,6 +392,59 @@ int perf_pmu__config(struct perf_pmu *pmu, struct perf_event_attr *attr,
 	return pmu_config(&pmu->format, attr, head_terms);
 }
 
+static struct perf_pmu__alias *pmu_find_alias(struct perf_pmu *pmu,
+					      struct parse_events__term *term)
+{
+	struct perf_pmu__alias *alias;
+	char *name;
+
+	if (parse_events__is_hardcoded_term(term))
+		return NULL;
+
+	if (term->type_val == PARSE_EVENTS__TERM_TYPE_NUM) {
+		if (term->val.num != 1)
+			return NULL;
+		if (pmu_find_format(&pmu->format, term->config))
+			return NULL;
+		name = term->config;
+	} else if (term->type_val == PARSE_EVENTS__TERM_TYPE_STR) {
+		if (strcasecmp(term->config, "event"))
+			return NULL;
+		name = term->val.str;
+	} else {
+		return NULL;
+	}
+
+	list_for_each_entry(alias, &pmu->aliases, list) {
+		if (!strcasecmp(alias->name, name))
+			return alias;
+	}
+	return NULL;
+}
+
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
+		alias = pmu_find_alias(pmu, term);
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
 

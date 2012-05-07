Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742Ab2EGIeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 04:34:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:17257 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755594Ab2EGIeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 04:34:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="162823364"
Message-ID: <4FA78904.8010306@intel.com>
Date: Mon, 07 May 2012 16:34:12 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@elte.hu,
        andi@firstfloor.org, eranian@google.com, ming.m.lin@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] perf tool: Add pmu event alias support
References: <1335924440-11242-1-git-send-email-zheng.z.yan@intel.com> <1335924440-11242-10-git-send-email-zheng.z.yan@intel.com> <20120503105655.GB1671@m.brq.redhat.com> <1336044261.22523.11.camel@twins> <20120503200518.GC1671@m.brq.redhat.com>
In-Reply-To: <20120503200518.GC1671@m.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2012 04:05 AM, Jiri Olsa wrote:
> On Thu, May 03, 2012 at 01:24:21PM +0200, Peter Zijlstra wrote:
>> On Thu, 2012-05-03 at 12:56 +0200, Jiri Olsa wrote:
>>> - in sysfs you would have directory with aliases (now called 'events')
>>> - each alias is sysfs dir, with file attrs:
>>>         file name = term name, file value = term value
>>>   eg.:
>>>         events/
>>>                 CAS_COUNT_RD/
>>>                         # files:
>>>                         config  - value 1
>>>                         config1 - value 2
>>>                         mask    - value ... 
>>
>> I'd prefer the thing Yan proposed (if the sysfs folks let us),
>>
>> $foo/events/QHL_REQUEST_REMOTE_READS
>>
>> with contents: "event=0x20,umask=0x4"
>>
>>> this way it's also possible to add extra terms to existing alias
>>> in command line if needed... might be handy
>>>
>> That should always be possible, if you modify the parser to take things
>> like:
>>
>>   event=0x20,umask=0x4,event=0x21
>>
>> and have latter values override earlier values, so it collapses into:
>>
>>   umask=0x4,event=0x21
>>
>> you can simply take whatever comes out of the event file and stick extra
>> bits at the end.
> 
> I discussed this with Peter on irc, so I'll try to sum it up
> 
> we have following options so far:
> 
>    with event alias 'al' with definition 'config=1,config1=1,config2=2'
> 
> 1) inside parse_events_add_pmu function
>    once alias term is detected as part of event definition 'pmu/al/mod' we
>    construct new event 'pmu/config=1,config1=1,config2=2/mod' and rerun the
>    event parser on that
> 
> 2) inside parse_events_add_pmu function 
>    once alias term is detected as part of event definition 'pmu/al/mod' we
>    replace that term with list of terms for that alias definition and run
>    perf_pmu__config with this new term list
> 
> 3) during bison/flex processing
>    have option 2) embeded inside flex/bison rules. Once alias term
>    is detected, insert the aliased terms directly to the list of terms,
>    not replacing expos as in option 2.
> 
> 
> - option 1 is currently implemented 
> - options 2 and 3 requires the aliased config is loaded/parsed from pmu
>   sysfs tree in form of terms list
> - option 3 is a little fuzzy for me now on how to integrate this with
>   flex/bison
> 
> My interest here is to go with option 2 or 3 if possible - preferrably 2 ;),
> because I think it's better/cleaner to deal with terms in one place once they
> are parsed - in parse_events_add_pmu function.
> 
> I think there's no need to re run the whole parser (option 1) when we
> have the whole thing ready by adding just extra terms.
> 
> thoughts?
> 

How is the patch below, it implements option 2.

Thanks
---
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index c587ae8..4ed4278 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -656,22 +656,33 @@ int parse_events_add_pmu(struct list_head *list, int *idx,
 	struct perf_event_attr attr;
 	struct perf_pmu *pmu;
 
+	/* called by parse_event_config? */
+	if (!idx) {
+		list_splice_init(head_config, list);
+		return 0;
+	}
+
 	pmu = perf_pmu__find(name);
 	if (!pmu)
 		return -EINVAL;
 
 	memset(&attr, 0, sizeof(attr));
 
-	/*
-	 * Configure hardcoded terms first, no need to check
-	 * return value when called with fail == 0 ;)
-	 */
-	config_attr(&attr, head_config, 0);
+	while (1) {
+		/*
+		 * Configure hardcoded terms first, no need to check
+		 * return value when called with fail == 0 ;)
+		 */
+		config_attr(&attr, head_config, 0);
 
-	if (perf_pmu__config(pmu, &attr, head_config))
-		return -EINVAL;
+		if (!perf_pmu__config(pmu, &attr, head_config))
+			return add_event(list, idx, &attr, (char *) "pmu");
 
-	return add_event(list, idx, &attr, (char *) "pmu");
+		head_config = perf_pmu__alias(pmu, head_config);
+		if (!head_config)
+			break;
+	}
+	return -EINVAL;
 }
 
 void parse_events_update_lists(struct list_head *list_event,
@@ -771,6 +782,26 @@ static int __parse_events(const char *str, int *idx, struct list_head *list)
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
+	buf = malloc(strlen(str) + 6);
+	if (!buf)
+		return -ENOMEM;
+
+	/* It is no matter which pmu is used here */
+	sprintf(buf, "cpu/%s/", str);
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
index e1ffeb7..5b5d698 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -30,6 +30,7 @@ extern int parse_events_option(const struct option *opt, const char *str,
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
index cb08a11..7a85779 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -80,6 +80,95 @@ static int pmu_format(char *name, struct list_head *format)
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
 /*
  * Reading/parsing the default pmu type value, which should be
  * located at:
@@ -118,6 +207,7 @@ static struct perf_pmu *pmu_lookup(char *name)
 {
 	struct perf_pmu *pmu;
 	LIST_HEAD(format);
+	LIST_HEAD(aliases);
 	__u32 type;
 
 	/*
@@ -135,8 +225,12 @@ static struct perf_pmu *pmu_lookup(char *name)
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
@@ -262,6 +356,35 @@ static int pmu_config(struct list_head *formats, struct perf_event_attr *attr,
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
+struct list_head *perf_pmu__alias(struct perf_pmu *pmu,
+				  struct list_head *head_terms)
+{
+	struct parse_events__term *term;
+	struct perf_pmu__alias *alias;
+
+	if (!list_is_singular(head_terms))
+		return NULL;
+
+	term = list_entry(head_terms->next, struct parse_events__term, list);
+	if (term->type != PARSE_EVENTS__TERM_TYPE_STR || term->val.str)
+		return NULL;
+
+	alias = pmu_find_alias(&pmu->aliases, term->config);
+	return &alias->terms;
+}
+
 /*
  * Configures event's 'attr' parameter based on the:
  * 1) users input - specified in terms parameter
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index 68c0db9..8fad317 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -19,17 +19,25 @@ struct perf_pmu__format {
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
+struct list_head *perf_pmu__alias(struct perf_pmu *pmu,
+				struct list_head *head_terms);
 int perf_pmu_wrap(void);
 void perf_pmu_error(struct list_head *list, char *name, char const *msg);
 







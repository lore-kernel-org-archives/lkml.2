Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157Ab2IKO35 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 10:29:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11904 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755148Ab2IKO3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 10:29:55 -0400
Date: Tue, 11 Sep 2012 16:27:17 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: eranian@google.com, a.p.zijlstra@chello.nl, mingo@elte.hu,
        andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/3] perf tool: Allow wildcard in PMU name
Message-ID: <20120911142717.GD3800@krava.brq.redhat.com>
References: <1347263631-23175-1-git-send-email-zheng.z.yan@intel.com>
 <1347263631-23175-4-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347263631-23175-4-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 03:53:51PM +0800, Yan, Zheng wrote:
> From: "Yan, Zheng" <zheng.z.yan@intel.com>

SNIP

> +{
> +	struct perf_evsel *evsel;
>  
> +	while (!list_empty(list)) {
> +		evsel = list_entry(list->next, struct perf_evsel, node);
> +		list_del(&evsel->node);
> +		perf_evsel__delete(evsel);
> +	}
> +	free(list);
> +}
>  
> -static int __add_event(struct list_head **_list, int *idx,
> -		       struct perf_event_attr *attr,
> -		       char *name, struct cpu_map *cpus)
> +static struct perf_evsel *__add_event(int *idx, struct perf_event_attr *attr,
> +				      char *name, struct cpu_map *cpus)
>  {
>  	struct perf_evsel *evsel;
> +
> +	event_attr_init(attr);
> +
> +	evsel = perf_evsel__new(attr, (*idx)++);
> +	if (!evsel)
> +		return NULL;
> +
> +	evsel->cpus = cpus;
> +	if (name)
> +		evsel->name = strdup(name);
> +	return evsel;
> +}
> +
> +static int add_event(struct list_head **_list, int *idx,
> +		     struct perf_event_attr *attr, char *name)
> +{
>  	struct list_head *list = *_list;
> +	struct perf_evsel *evsel;
>  
>  	if (!list) {
>  		list = malloc(sizeof(*list));
> @@ -255,28 +281,17 @@ static int __add_event(struct list_head **_list, int *idx,
>  		INIT_LIST_HEAD(list);
>  	}
>  
> -	event_attr_init(attr);
> -
> -	evsel = perf_evsel__new(attr, (*idx)++);
> +	evsel = __add_event(idx, attr, name, NULL);
>  	if (!evsel) {
>  		free(list);
>  		return -ENOMEM;
>  	}
>  
> -	evsel->cpus = cpus;
> -	if (name)
> -		evsel->name = strdup(name);
>  	list_add_tail(&evsel->node, list);
>  	*_list = list;
>  	return 0;
>  }
>  
> -static int add_event(struct list_head **_list, int *idx,
> -		     struct perf_event_attr *attr, char *name)
> -{
> -	return __add_event(_list, idx, attr, name, NULL);
> -}
> -

Would it be possible to have all '*add_event' more obvious for usage.
Also following code is duplicated after each call of __add_event:

      evsel = __add_event(idx, &attr, pmu_event_name(head_config),
                          pmu->cpus);
      if (!evsel) {
              *idx = orig_idx;
              free_event_list(list);
              return -ENOMEM;
      }
      list_add_tail(&evsel->node, list);

I tried some changes over your patch.. just compiled, not tested ;)
It should also solve the issue from my other comment.

thanks,
jirka


---
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 1b0a46f..f6bbd7a 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -268,8 +268,10 @@ static struct perf_evsel *__add_event(int *idx, struct perf_event_attr *attr,
 	return evsel;
 }
 
-static int add_event(struct list_head **_list, int *idx,
-		     struct perf_event_attr *attr, char *name)
+static struct perf_evsel*
+add_event_list(struct list_head **_list, int *idx,
+	       struct perf_event_attr *attr, char *name,
+	       struct cpu_map *cpus)
 {
 	struct list_head *list = *_list;
 	struct perf_evsel *evsel;
@@ -277,19 +279,27 @@ static int add_event(struct list_head **_list, int *idx,
 	if (!list) {
 		list = malloc(sizeof(*list));
 		if (!list)
-			return -ENOMEM;
+			return NULL;
 		INIT_LIST_HEAD(list);
 	}
 
-	evsel = __add_event(idx, attr, name, NULL);
+	evsel = __add_event(idx, attr, name, cpus);
 	if (!evsel) {
-		free(list);
-		return -ENOMEM;
+		free_event_list(list);
+		return NULL;
 	}
 
 	list_add_tail(&evsel->node, list);
-	*_list = list;
-	return 0;
+	if (!*_list)
+		*_list = list;
+
+	return evsel;
+}
+
+static int add_event(struct list_head **_list, int *idx,
+		     struct perf_event_attr *attr, char *name)
+{
+	return add_event_list(_list, idx, attr, name, NULL) ? 0 : -ENOMEM;
 }
 
 static int parse_aliases(char *str, const char *names[][PERF_EVSEL__MAX_ALIASES], int size)
@@ -635,16 +645,10 @@ int parse_events_add_pmu(struct list_head **_list, int *idx,
 			 char *name, struct list_head *head_config)
 {
 	struct perf_event_attr attr;
-	struct list_head *list;
 	struct perf_pmu *pmu = NULL;
 	struct perf_evsel *evsel, *first = NULL;
 	int orig_idx = *idx;
 
-	list = malloc(sizeof(*list));
-	if (!list)
-		return -ENOMEM;
-	INIT_LIST_HEAD(list);
-
 	while ((pmu = perf_pmu__scan(pmu))) {
 		if (pmu_name_match(pmu->name, name))
 			continue;
@@ -663,14 +667,12 @@ int parse_events_add_pmu(struct list_head **_list, int *idx,
 		if (perf_pmu__config(pmu, &attr, head_config))
 			return -EINVAL;
 
-		evsel = __add_event(idx, &attr, pmu_event_name(head_config),
-				    pmu->cpus);
+		evsel = add_event_list(_list, idx, &attr, pmu_event_name(head_config),
+				       pmu->cpus);
 		if (!evsel) {
 			*idx = orig_idx;
-			free_event_list(list);
 			return -ENOMEM;
 		}
-		list_add_tail(&evsel->node, list);
 		if (first) {
 			list_add_tail(&evsel->sibling, &first->sibling);
 			evsel->aggr_slave = true;
@@ -679,7 +681,6 @@ int parse_events_add_pmu(struct list_head **_list, int *idx,
 		}
 	}
 
-	*_list = list;
 	return 0;
 }
 

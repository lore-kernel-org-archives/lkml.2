Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776Ab2EJJxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 05:53:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22625 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758486Ab2EJJxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 05:53:14 -0400
Date: Thu, 10 May 2012 11:52:48 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@elte.hu,
        andi@firstfloor.org, eranian@google.com, ming.m.lin@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] perf tool: Add pmu event alias support
Message-ID: <20120510095248.GA3427@m.brq.redhat.com>
References: <1335924440-11242-1-git-send-email-zheng.z.yan@intel.com>
 <1335924440-11242-10-git-send-email-zheng.z.yan@intel.com>
 <20120503105655.GB1671@m.brq.redhat.com>
 <1336044261.22523.11.camel@twins>
 <20120503200518.GC1671@m.brq.redhat.com>
 <4FA78904.8010306@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA78904.8010306@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2012 at 04:34:12PM +0800, Yan, Zheng wrote:
> On 05/04/2012 04:05 AM, Jiri Olsa wrote:
> > On Thu, May 03, 2012 at 01:24:21PM +0200, Peter Zijlstra wrote:
> >> On Thu, 2012-05-03 at 12:56 +0200, Jiri Olsa wrote:
> >>> - in sysfs you would have directory with aliases (now called 'events')

SNIP

> 
> How is the patch below, it implements option 2.
hi,
sorry for late reply and long email ;) comments below

jirka

> 
> Thanks
> ---
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> index c587ae8..4ed4278 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -656,22 +656,33 @@ int parse_events_add_pmu(struct list_head *list, int *idx,
>  	struct perf_event_attr attr;
>  	struct perf_pmu *pmu;
>  
> +	/* called by parse_event_config? */
> +	if (!idx) {
> +		list_splice_init(head_config, list);
> +		return 0;
> +	}

ok, so this is because we want to use current event parser to parse the alias terms

options we have globaly ;) AFAICS:

1) the one you have
   - in case the idx pointer is NULL, we use the event list to store
     terms
   - I guess it works ;) but seems to me like we might have troubles
     in future to expand this code further..

   if we want to have it this way, we better use some new parse events
   function argument to define the function of the parser:
       - return events
       - return terms

2) I'm currently looking on having multiple starting points in the
   grammar. It seems that in some cases this is working option:

   http://www.gnu.org/software/bison/manual/html_node/Multiple-start_002dsymbols.html

   I'll update you later with this one ;)


3) having separate parser for terms parsing, which would be called
   from pmu initialization and during event parsing
   - this seems clean and doable but it smells with -ETOOMANYPARSERS ;)

4) having the alias definitions defined within the tree structure
   I described earlier:
        events/
                CAS_COUNT_RD/
                        # files:
                        config  - value 1
                        config1 - value 2
                        mask    - value ...

      - initialy I thought the current sysfs alias format would clash
        with sysfs rules.. but after talking to Peter ;) I think it's ok,
        because it's still <one file - one value>
      - but using this, we would not need special parser

- ad 4) seems now like avoiding the problem
- ad 1) hackish
- ad 3) seems most clean and extentable in future
- ad 4) need to explore

I think we should ask sysfs folks to confirm the sysfs layout.. :)

> +
>  	pmu = perf_pmu__find(name);
>  	if (!pmu)
>  		return -EINVAL;
>  
>  	memset(&attr, 0, sizeof(attr));
>  
> -	/*
> -	 * Configure hardcoded terms first, no need to check
> -	 * return value when called with fail == 0 ;)
> -	 */
> -	config_attr(&attr, head_config, 0);
> +	while (1) {
> +		/*
> +		 * Configure hardcoded terms first, no need to check
> +		 * return value when called with fail == 0 ;)
> +		 */
> +		config_attr(&attr, head_config, 0);
>  
> -	if (perf_pmu__config(pmu, &attr, head_config))
> -		return -EINVAL;
> +		if (!perf_pmu__config(pmu, &attr, head_config))
> +			return add_event(list, idx, &attr, (char *) "pmu");
>  
> -	return add_event(list, idx, &attr, (char *) "pmu");
> +		head_config = perf_pmu__alias(pmu, head_config);
> +		if (!head_config)
> +			break;
> +	}
> +	return -EINVAL;
The perf_pmu__alias checks first term in the list for the alias, but what
if the alias is second term? I think we could be more general like:


parse_events_add_pmu {
	...

	config_attr(&attr, head_config, 0);

	config_alias(pmu, head_config);

	if (perf_pmu__config(pmu, &attr, head_config))
		return -EINVAL;

	return 0;
}

config_alias(pmu, head) {
	for each term in head {
		if (is term alias in pmu) {
			replace the alias term with its term definition (multiple terms probably)
		}
	}
}

so we just replace the alias term with it's definition terms
and call perf_pmu__config with final terms

this way:
- we could add more terms on command line in addition to the alias
- alias does not need to be the first term specified on command line


>  }
>  
>  void parse_events_update_lists(struct list_head *list_event,
> @@ -771,6 +782,26 @@ static int __parse_events(const char *str, int *idx, struct list_head *list)
>  	return ret;
>  }
>  
> +/*
> + * parse event config string, return a list of event terms.
> + */
> +int parse_event_config(struct list_head *terms, const char *str)
> +{
> +	char *buf;
> +	int ret;
> +
> +	buf = malloc(strlen(str) + 6);
> +	if (!buf)
> +		return -ENOMEM;
> +
> +	/* It is no matter which pmu is used here */
> +	sprintf(buf, "cpu/%s/", str);
> +	ret = __parse_events(buf, NULL, terms);
> +
> +	free(buf);
> +	return ret;
> +}
> +
>  int parse_events(struct perf_evlist *evlist, const char *str, int unset __used)
>  {
>  	LIST_HEAD(list);
> diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
> index e1ffeb7..5b5d698 100644
> --- a/tools/perf/util/parse-events.h
> +++ b/tools/perf/util/parse-events.h
> @@ -30,6 +30,7 @@ extern int parse_events_option(const struct option *opt, const char *str,
>  extern int parse_events(struct perf_evlist *evlist, const char *str,
>  			int unset);
>  extern int parse_filter(const struct option *opt, const char *str, int unset);
> +extern int parse_event_config(struct list_head *terms, const char *str);
>  
>  #define EVENTS_HELP_MAX (128*1024)
>  
> diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
> index 52082a7..8a26f3d 100644
> --- a/tools/perf/util/parse-events.y
> +++ b/tools/perf/util/parse-events.y
> @@ -197,7 +197,7 @@ PE_NAME
>  {
>  	struct parse_events__term *term;
>  
> -	ABORT_ON(parse_events__new_term(&term, PARSE_EVENTS__TERM_TYPE_NUM,
> +	ABORT_ON(parse_events__new_term(&term, PARSE_EVENTS__TERM_TYPE_STR,
>  		 $1, NULL, 1));
>  	$$ = term;
>  }
> diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
> index cb08a11..7a85779 100644
> --- a/tools/perf/util/pmu.c
> +++ b/tools/perf/util/pmu.c
> @@ -80,6 +80,95 @@ static int pmu_format(char *name, struct list_head *format)
>  	return 0;
>  }
>  
> +static int perf_pmu__new_alias(struct list_head *list, char *name, FILE *file)
> +{
> +	struct perf_pmu__alias *alias;
> +	char buf[256];
> +	int ret;
> +
> +	ret = fread(buf, 1, sizeof(buf), file);
> +	if (ret == 0)
> +		return -EINVAL;
> +	buf[ret] = 0;
> +
> +	alias = malloc(sizeof(*alias));
> +	if (!alias)
> +		return -ENOMEM;
> +
> +	INIT_LIST_HEAD(&alias->terms);
> +	ret = parse_event_config(&alias->terms, buf);
> +	if (ret) {
> +		free(alias);
> +		return ret;
> +	}
> +
> +	alias->name = strdup(name);
> +	list_add_tail(&alias->list, list);
> +	return 0;
> +}
> +
> +/*
> + * Process all the sysfs attributes located under the directory
> + * specified in 'dir' parameter.
> + */
> +static int pmu_aliases_parse(char *dir, struct list_head *head)
> +{
> +	struct dirent *evt_ent;
> +	DIR *event_dir;
> +	int ret = 0;
> +
> +	event_dir = opendir(dir);
> +	if (!event_dir)
> +		return -EINVAL;
> +
> +	while (!ret && (evt_ent = readdir(event_dir))) {
> +		char path[PATH_MAX];
> +		char *name = evt_ent->d_name;
> +		FILE *file;
> +
> +		if (!strcmp(name, ".") || !strcmp(name, ".."))
> +			continue;
> +
> +		snprintf(path, PATH_MAX, "%s/%s", dir, name);
> +
> +		ret = -EINVAL;
> +		file = fopen(path, "r");
> +		if (!file)
> +			break;
> +		ret = perf_pmu__new_alias(head, name, file);
> +		fclose(file);
> +	}
> +
> +	closedir(event_dir);
> +	return ret;
> +}
> +
> +/*
> + * Reading the pmu event aliases definition, which should be located at:
> + * /sys/bus/event_source/devices/<dev>/events as sysfs group attributes.
> + */
> +static int pmu_aliases(char *name, struct list_head *head)
> +{
> +	struct stat st;
> +	char path[PATH_MAX];
> +	const char *sysfs;
> +
> +	sysfs = sysfs_find_mountpoint();
> +	if (!sysfs)
> +		return -1;
> +
> +	snprintf(path, PATH_MAX,
> +		 "%s/bus/event_source/devices/%s/events", sysfs, name);
> +
> +	if (stat(path, &st) < 0)
> +		return -1;
> +
> +	if (pmu_aliases_parse(path, head))
> +		return -1;
> +
> +	return 0;
> +}
> +
>  /*
>   * Reading/parsing the default pmu type value, which should be
>   * located at:
> @@ -118,6 +207,7 @@ static struct perf_pmu *pmu_lookup(char *name)
>  {
>  	struct perf_pmu *pmu;
>  	LIST_HEAD(format);
> +	LIST_HEAD(aliases);
>  	__u32 type;
>  
>  	/*
> @@ -135,8 +225,12 @@ static struct perf_pmu *pmu_lookup(char *name)
>  	if (!pmu)
>  		return NULL;
>  
> +	pmu_aliases(name, &aliases);
> +
>  	INIT_LIST_HEAD(&pmu->format);
> +	INIT_LIST_HEAD(&pmu->aliases);
>  	list_splice(&format, &pmu->format);
> +	list_splice(&aliases, &pmu->aliases);
>  	pmu->name = strdup(name);
>  	pmu->type = type;
>  	return pmu;
> @@ -262,6 +356,35 @@ static int pmu_config(struct list_head *formats, struct perf_event_attr *attr,
>  	return 0;
>  }
>  
> +static struct perf_pmu__alias *pmu_find_alias(struct list_head *events,
> +					      char *name)
> +{
> +	struct perf_pmu__alias *alias;
> +
> +	list_for_each_entry(alias, events, list) {
> +		if (!strcmp(alias->name, name))
> +			return alias;
> +	}
> +	return NULL;
> +}
> +
> +struct list_head *perf_pmu__alias(struct perf_pmu *pmu,
> +				  struct list_head *head_terms)
> +{
> +	struct parse_events__term *term;
> +	struct perf_pmu__alias *alias;
> +
> +	if (!list_is_singular(head_terms))
> +		return NULL;
> +
> +	term = list_entry(head_terms->next, struct parse_events__term, list);
> +	if (term->type != PARSE_EVENTS__TERM_TYPE_STR || term->val.str)
> +		return NULL;
> +
> +	alias = pmu_find_alias(&pmu->aliases, term->config);
> +	return &alias->terms;
> +}
> +
>  /*
>   * Configures event's 'attr' parameter based on the:
>   * 1) users input - specified in terms parameter
> diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
> index 68c0db9..8fad317 100644
> --- a/tools/perf/util/pmu.h
> +++ b/tools/perf/util/pmu.h
> @@ -19,17 +19,25 @@ struct perf_pmu__format {
>  	struct list_head list;
>  };
>  
> +struct perf_pmu__alias {
> +	char *name;
> +	struct list_head terms;
> +	struct list_head list;
> +};
> +
>  struct perf_pmu {
>  	char *name;
>  	__u32 type;
>  	struct list_head format;
> +	struct list_head aliases;
>  	struct list_head list;
>  };
>  
>  struct perf_pmu *perf_pmu__find(char *name);
>  int perf_pmu__config(struct perf_pmu *pmu, struct perf_event_attr *attr,
>  		     struct list_head *head_terms);
> -
> +struct list_head *perf_pmu__alias(struct perf_pmu *pmu,
> +				struct list_head *head_terms);
>  int perf_pmu_wrap(void);
>  void perf_pmu_error(struct list_head *list, char *name, char const *msg);
>  
> 
> 
> 
> 
> 
> 

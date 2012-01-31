Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab2AaJsO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 04:48:14 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:44242 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932Ab2AaJsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 04:48:12 -0500
Message-ID: <4F27B8CE.3010507@linux.vnet.ibm.com>
Date: Tue, 31 Jan 2012 15:17:58 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com, robert.richter@amd.com, ming.m.lin@intel.com,
        andi@firstfloor.org, asharma@fb.com, ravitillo@lbl.gov,
        vweaver1@eecs.utk.edu, dsahern@gmail.com
Subject: Re: [PATCH v4 12/18] perf: add support for sampling taken branch
 to perf record
References: <1327697778-18515-1-git-send-email-eranian@google.com> <1327697778-18515-13-git-send-email-eranian@google.com>
In-Reply-To: <1327697778-18515-13-git-send-email-eranian@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12013109-2000-0000-0000-000006401031
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 January 2012 02:26 AM, Stephane Eranian wrote:
> From: Roberto Agostino Vitillo <ravitillo@lbl.gov>
> 
> This patch adds a new option to enable taken branch stack
> sampling, i.e., leverage the PERF_SAMPLE_BRANCH_STACK feature
> of perf_events.
> 
> There is a new option to active this mode: -b.
> It is possible to pass a set of filters to select the type of
> branches to sample.
> 
> The following filters are available:
> - any : any type of branches
> - any_call : any function call or system call
> - any_ret : any function return or system call return
> - any_ind : any indirect branch
> - u:  only when the branch target is at the user level
> - k: only when the branch target is in the kernel
> - hv: only when the branch target is in the hypervisor
> 
> Filters can be combined by passing a comma separated list
> to the option:
> 
> $ perf record -b any_call,u -e cycles:u branchy
> 
> Signed-off-by: Roberto Agostino Vitillo <ravitillo@lbl.gov>
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
>  tools/perf/Documentation/perf-record.txt |   25 ++++++++++
>  tools/perf/builtin-record.c              |   74 ++++++++++++++++++++++++++++++
>  tools/perf/perf.h                        |    1 +
>  tools/perf/util/evsel.c                  |    4 ++
>  4 files changed, 104 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
> index ff9a66e..288d429 100644
> --- a/tools/perf/Documentation/perf-record.txt
> +++ b/tools/perf/Documentation/perf-record.txt
> @@ -152,6 +152,31 @@ an empty cgroup (monitor all the time) using, e.g., -G foo,,bar. Cgroups must ha
>  corresponding events, i.e., they always refer to events defined earlier on the command
>  line.
> 
> +-b::
> +--branch-stack::
> +Enable taken branch stack sampling. Each sample captures a series of consecutive
> +taken branches. The number of branches captured with each sample depends on the
> +underlying hardware, the type of branches of interest, and the executed code.
> +It is possible to select the types of branches captured by enabling filters. The
> +following filters are defined:
> +
> +        -  any :  any type of branches
> +        - any_call: any function call or system call
> +        - any_ret: any function return or system call return
> +        - any_ind: any indirect branch
> +        - u:  only when the branch target is at the user level
> +        - k: only when the branch target is in the kernel
> +        - hv: only when the target is at the hypervisor level
> +
> ++
> +At least one of any, any_call, any_ret, any_ind must be provided. The privilege levels may
> +be ommitted, in which case, the privilege levels of the associated event are applied to the
> +branch filter. Both kernel (k) and hypervisor (hv) privilege levels are subject to
> +permissions.  When sampling on multiple events, branch stack sampling is enabled for all
> +the sampling events. The sampled branch type is the same for all events.
> +Note that taken branch sampling may not be available on all processors.
> +The various filters must be specified as a comma separated list: -b any_ret,u,k
> +
>  SEE ALSO
>  --------
>  linkperf:perf-stat[1], linkperf:perf-list[1]
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 32870ee..7df6e68 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -637,6 +637,77 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
>  	return err;
>  }
> 
> +#define BRANCH_OPT(n, m) \
> +	{ .name = n, .mode = (m) }
> +
> +#define BRANCH_END { .name = NULL }
> +
> +struct branch_mode {
> +	const char *name;
> +	int mode;
> +};
> +
> +static const struct branch_mode branch_modes[] = {
> +	BRANCH_OPT("u", PERF_SAMPLE_BRANCH_USER),
> +	BRANCH_OPT("k", PERF_SAMPLE_BRANCH_KERNEL),
> +	BRANCH_OPT("hv", PERF_SAMPLE_BRANCH_HV),
> +	BRANCH_OPT("any", PERF_SAMPLE_BRANCH_ANY),
> +	BRANCH_OPT("any_call", PERF_SAMPLE_BRANCH_ANY_CALL),
> +	BRANCH_OPT("any_ret", PERF_SAMPLE_BRANCH_ANY_RETURN),
> +	BRANCH_OPT("ind_call", PERF_SAMPLE_BRANCH_IND_CALL),
> +	BRANCH_END
> +};
> +
> +static int
> +parse_branch_stack(const struct option *opt, const char *str, int unset __used)
> +{
> +#define ONLY_PLM \
> +	(PERF_SAMPLE_BRANCH_USER	|\
> +	 PERF_SAMPLE_BRANCH_KERNEL	|\
> +	 PERF_SAMPLE_BRANCH_KERNEL)

I guess this would be PERF_SAMPLE_BRANCH_HV instead of the second
PERF_SAMPLE_BRANCH_KERNEL. 

> +
> +	uint64_t *mode = (uint64_t *)opt->value;
> +	const struct branch_mode *br;
> +	char *s, *os, *p;
> +	int ret = -1;
> +
> +	*mode = 0;
> +
> +	/* because str is read-only */
> +	s = os = strdup(str);
> +	if (!s)
> +		return -1;
> +
> +	for (;;) {
> +		p = strchr(s, ',');
> +		if (p)
> +			*p = '\0';
> +
> +		for (br = branch_modes; br->name; br++) {
> +			if (!strcasecmp(s, br->name))
> +				break;
> +		}
> +		if (!br->name)
> +			goto error;
> +
> +		*mode |= br->mode;
> +
> +		if (!p)
> +			break;
> +
> +		s = p + 1;
> +	}
> +	ret = 0;
> +
> +	if ((*mode & ~ONLY_PLM) == 0) {
> +		error("need at least one branch type with -b\n");
> +		ret = -1;
> +	}
> +error:
> +	free(os);
> +	return ret;
> +}
> +
>  static const char * const record_usage[] = {
>  	"perf record [<options>] [<command>]",
>  	"perf record [<options>] -- <command> [<options>]",
> @@ -729,6 +800,9 @@ const struct option record_options[] = {
>  		     "monitor event in cgroup name only",
>  		     parse_cgroups),
>  	OPT_STRING('u', "uid", &record.uid_str, "user", "user to profile"),
> +	OPT_CALLBACK('b', "branch-stack", &record.opts.branch_stack,
> +		     "branch mode mask", "branch stack sampling modes",
> +		     parse_branch_stack),
>  	OPT_END()
>  };
> 
> diff --git a/tools/perf/perf.h b/tools/perf/perf.h
> index 8b4d25d..7f8fbab 100644
> --- a/tools/perf/perf.h
> +++ b/tools/perf/perf.h
> @@ -222,6 +222,7 @@ struct perf_record_opts {
>  	unsigned int freq;
>  	unsigned int mmap_pages;
>  	unsigned int user_freq;
> +	int	     branch_stack;
>  	u64	     default_interval;
>  	u64	     user_interval;
>  	const char   *cpu_list;
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index 472fc8c..a65a53c 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -126,6 +126,10 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts)
>  		attr->watermark = 0;
>  		attr->wakeup_events = 1;
>  	}
> +	if (opts->branch_stack) {
> +		attr->sample_type	|= PERF_SAMPLE_BRANCH_STACK;
> +		attr->branch_sample_type = opts->branch_stack;
> +	}
> 
>  	attr->mmap = track;
>  	attr->comm = track;


-- 
Anshuman Khandual
Linux Technology Centre
IBM Systems and Technology Group


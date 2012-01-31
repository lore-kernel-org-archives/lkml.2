Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab2AaKbl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 05:31:41 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:59138 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752292Ab2AaKbk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 05:31:40 -0500
MIME-Version: 1.0
In-Reply-To: <4F27B8CE.3010507@linux.vnet.ibm.com>
References: <1327697778-18515-1-git-send-email-eranian@google.com>
	<1327697778-18515-13-git-send-email-eranian@google.com>
	<4F27B8CE.3010507@linux.vnet.ibm.com>
Date: Tue, 31 Jan 2012 11:31:38 +0100
Message-ID: <CABPqkBRrjz2wPkb8U_2eSb0hZdm_fbcqkNqvPPQSQPkYHZUeHQ@mail.gmail.com>
Subject: Re: [PATCH v4 12/18] perf: add support for sampling taken branch to
 perf record
From: Stephane Eranian <eranian@google.com>
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com, robert.richter@amd.com, ming.m.lin@intel.com,
        andi@firstfloor.org, asharma@fb.com, ravitillo@lbl.gov,
        vweaver1@eecs.utk.edu, dsahern@gmail.com
X-System-Of-Record: true
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 10:47 AM, Anshuman Khandual
<khandual@linux.vnet.ibm.com> wrote:
> On Saturday 28 January 2012 02:26 AM, Stephane Eranian wrote:
>> From: Roberto Agostino Vitillo <ravitillo@lbl.gov>
>>
>> This patch adds a new option to enable taken branch stack
>> sampling, i.e., leverage the PERF_SAMPLE_BRANCH_STACK feature
>> of perf_events.
>>
>> There is a new option to active this mode: -b.
>> It is possible to pass a set of filters to select the type of
>> branches to sample.
>>
>> The following filters are available:
>> - any : any type of branches
>> - any_call : any function call or system call
>> - any_ret : any function return or system call return
>> - any_ind : any indirect branch
>> - u:  only when the branch target is at the user level
>> - k: only when the branch target is in the kernel
>> - hv: only when the branch target is in the hypervisor
>>
>> Filters can be combined by passing a comma separated list
>> to the option:
>>
>> $ perf record -b any_call,u -e cycles:u branchy
>>
>> Signed-off-by: Roberto Agostino Vitillo <ravitillo@lbl.gov>
>> Signed-off-by: Stephane Eranian <eranian@google.com>
>> ---
>>  tools/perf/Documentation/perf-record.txt |   25 ++++++++++
>>  tools/perf/builtin-record.c              |   74 ++++++++++++++++++++++++++++++
>>  tools/perf/perf.h                        |    1 +
>>  tools/perf/util/evsel.c                  |    4 ++
>>  4 files changed, 104 insertions(+), 0 deletions(-)
>>
>> diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
>> index ff9a66e..288d429 100644
>> --- a/tools/perf/Documentation/perf-record.txt
>> +++ b/tools/perf/Documentation/perf-record.txt
>> @@ -152,6 +152,31 @@ an empty cgroup (monitor all the time) using, e.g., -G foo,,bar. Cgroups must ha
>>  corresponding events, i.e., they always refer to events defined earlier on the command
>>  line.
>>
>> +-b::
>> +--branch-stack::
>> +Enable taken branch stack sampling. Each sample captures a series of consecutive
>> +taken branches. The number of branches captured with each sample depends on the
>> +underlying hardware, the type of branches of interest, and the executed code.
>> +It is possible to select the types of branches captured by enabling filters. The
>> +following filters are defined:
>> +
>> +        -  any :  any type of branches
>> +        - any_call: any function call or system call
>> +        - any_ret: any function return or system call return
>> +        - any_ind: any indirect branch
>> +        - u:  only when the branch target is at the user level
>> +        - k: only when the branch target is in the kernel
>> +        - hv: only when the target is at the hypervisor level
>> +
>> ++
>> +At least one of any, any_call, any_ret, any_ind must be provided. The privilege levels may
>> +be ommitted, in which case, the privilege levels of the associated event are applied to the
>> +branch filter. Both kernel (k) and hypervisor (hv) privilege levels are subject to
>> +permissions.  When sampling on multiple events, branch stack sampling is enabled for all
>> +the sampling events. The sampled branch type is the same for all events.
>> +Note that taken branch sampling may not be available on all processors.
>> +The various filters must be specified as a comma separated list: -b any_ret,u,k
>> +
>>  SEE ALSO
>>  --------
>>  linkperf:perf-stat[1], linkperf:perf-list[1]
>> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
>> index 32870ee..7df6e68 100644
>> --- a/tools/perf/builtin-record.c
>> +++ b/tools/perf/builtin-record.c
>> @@ -637,6 +637,77 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
>>       return err;
>>  }
>>
>> +#define BRANCH_OPT(n, m) \
>> +     { .name = n, .mode = (m) }
>> +
>> +#define BRANCH_END { .name = NULL }
>> +
>> +struct branch_mode {
>> +     const char *name;
>> +     int mode;
>> +};
>> +
>> +static const struct branch_mode branch_modes[] = {
>> +     BRANCH_OPT("u", PERF_SAMPLE_BRANCH_USER),
>> +     BRANCH_OPT("k", PERF_SAMPLE_BRANCH_KERNEL),
>> +     BRANCH_OPT("hv", PERF_SAMPLE_BRANCH_HV),
>> +     BRANCH_OPT("any", PERF_SAMPLE_BRANCH_ANY),
>> +     BRANCH_OPT("any_call", PERF_SAMPLE_BRANCH_ANY_CALL),
>> +     BRANCH_OPT("any_ret", PERF_SAMPLE_BRANCH_ANY_RETURN),
>> +     BRANCH_OPT("ind_call", PERF_SAMPLE_BRANCH_IND_CALL),
>> +     BRANCH_END
>> +};
>> +
>> +static int
>> +parse_branch_stack(const struct option *opt, const char *str, int unset __used)
>> +{
>> +#define ONLY_PLM \
>> +     (PERF_SAMPLE_BRANCH_USER        |\
>> +      PERF_SAMPLE_BRANCH_KERNEL      |\
>> +      PERF_SAMPLE_BRANCH_KERNEL)
>
> I guess this would be PERF_SAMPLE_BRANCH_HV instead of the second
> PERF_SAMPLE_BRANCH_KERNEL.
>
Oops, yes you're right.

There is also something else I realized after the fact that needs to
be tweaked about
BRANCH_HV.

The thing is the X86 code is setup to ignore priv levels it does not
know about, it seems.
Perf does not set exclude_hv by default. Thus in my patch, if the user
does not specify
any branch priv level, it will default to the level used for the
event. That is fine but in the
x86 code, I added a sanity check to reject BRANCH_HV because the HW
does not support
it. I think it should just ignore it. That way, one can do:

    $ perf record -b any_call -e cycles ls

without getting an error (because hv is not supported on branch sampling).
Currently, the workaround is to set the priv level on branches:

    $ perf record -b any_call,u,k -e cycles ls


>> +
>> +     uint64_t *mode = (uint64_t *)opt->value;
>> +     const struct branch_mode *br;
>> +     char *s, *os, *p;
>> +     int ret = -1;
>> +
>> +     *mode = 0;
>> +
>> +     /* because str is read-only */
>> +     s = os = strdup(str);
>> +     if (!s)
>> +             return -1;
>> +
>> +     for (;;) {
>> +             p = strchr(s, ',');
>> +             if (p)
>> +                     *p = '\0';
>> +
>> +             for (br = branch_modes; br->name; br++) {
>> +                     if (!strcasecmp(s, br->name))
>> +                             break;
>> +             }
>> +             if (!br->name)
>> +                     goto error;
>> +
>> +             *mode |= br->mode;
>> +
>> +             if (!p)
>> +                     break;
>> +
>> +             s = p + 1;
>> +     }
>> +     ret = 0;
>> +
>> +     if ((*mode & ~ONLY_PLM) == 0) {
>> +             error("need at least one branch type with -b\n");
>> +             ret = -1;
>> +     }
>> +error:
>> +     free(os);
>> +     return ret;
>> +}
>> +
>>  static const char * const record_usage[] = {
>>       "perf record [<options>] [<command>]",
>>       "perf record [<options>] -- <command> [<options>]",
>> @@ -729,6 +800,9 @@ const struct option record_options[] = {
>>                    "monitor event in cgroup name only",
>>                    parse_cgroups),
>>       OPT_STRING('u', "uid", &record.uid_str, "user", "user to profile"),
>> +     OPT_CALLBACK('b', "branch-stack", &record.opts.branch_stack,
>> +                  "branch mode mask", "branch stack sampling modes",
>> +                  parse_branch_stack),
>>       OPT_END()
>>  };
>>
>> diff --git a/tools/perf/perf.h b/tools/perf/perf.h
>> index 8b4d25d..7f8fbab 100644
>> --- a/tools/perf/perf.h
>> +++ b/tools/perf/perf.h
>> @@ -222,6 +222,7 @@ struct perf_record_opts {
>>       unsigned int freq;
>>       unsigned int mmap_pages;
>>       unsigned int user_freq;
>> +     int          branch_stack;
>>       u64          default_interval;
>>       u64          user_interval;
>>       const char   *cpu_list;
>> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
>> index 472fc8c..a65a53c 100644
>> --- a/tools/perf/util/evsel.c
>> +++ b/tools/perf/util/evsel.c
>> @@ -126,6 +126,10 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts)
>>               attr->watermark = 0;
>>               attr->wakeup_events = 1;
>>       }
>> +     if (opts->branch_stack) {
>> +             attr->sample_type       |= PERF_SAMPLE_BRANCH_STACK;
>> +             attr->branch_sample_type = opts->branch_stack;
>> +     }
>>
>>       attr->mmap = track;
>>       attr->comm = track;
>
>
> --
> Anshuman Khandual
> Linux Technology Centre
> IBM Systems and Technology Group
>

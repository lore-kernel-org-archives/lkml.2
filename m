Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab1IETak (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 15:30:40 -0400
Received: from smtp-out.google.com ([216.239.44.51]:5438 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401Ab1IETaf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 15:30:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=oFfj+ut6pRTI6jE3mS11gk2ylcZ/h0oqsmWJSWYvbC3h3XCS3QBsu2snK7Dk/YvOI
	B20ZCxc1nm0xvU+0W46SQ==
MIME-Version: 1.0
In-Reply-To: <CABPqkBQcAYDyyD_Z2fK+q=uX2XP7f8MbUiNg-44iytQg0pJf2Q@mail.gmail.com>
References: <20110905122402.GA9786@quad>
	<20110905180017.GA4677@ghostprotocols.net>
	<CABPqkBQcAYDyyD_Z2fK+q=uX2XP7f8MbUiNg-44iytQg0pJf2Q@mail.gmail.com>
Date: Mon, 5 Sep 2011 21:30:31 +0200
Message-ID: <CABPqkBR+DxeuR1DYqqjfVd0DUmXhsnaRUmuEgf24-b=r+6BB=Q@mail.gmail.com>
Subject: Re: [PATCH] perf: make perf.data more self-descriptive
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ming.m.lin@intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 5, 2011 at 8:54 PM, Stephane Eranian <eranian@google.com> wrote:
> On Mon, Sep 5, 2011 at 8:00 PM, Arnaldo Carvalho de Melo
> <acme@redhat.com> wrote:
>> Em Mon, Sep 05, 2011 at 02:24:02PM +0200, Stephane Eranian escreveu:
>>
>>> The goal of this patch is to include more information
>>> about the host environment into the perf.data so it is
>>> more self-descriptive. Overtime, profiles are captured
>>> on various machines and it becomes hard to track what
>>> was recorded, on what machine and when.
>>
>> I like it and indeed Ingo had requested a subset of this long ago :-)
>>
> Thanks, took me some time to figure out how to do this without breaking
> the format! It's good to know it's not just me feeling the need to have that
> information handy.
>
>> Some comments on the implementation below.
>>
>>> This patch provides a way to solve this by extending
>>> the perf.data file with basic information about the
>>> host machine. To add those extensions, we leverage
>>> the feature bits capabilities of the perf.data format.
>>> The change is backward compatible with existing perf.data
>>> files.
>>>
>>> We define the following useful new extensions:
>>>  - HEADER_HOSTNAME: the hostname
>>>  - HEADER_OSRELEASE: the kernel release number
>>>  - HEADER_ARCH: the hw architecture
>>>  - HEADER_CPUID: the cpu model description
>>>  - HEADER_NRCPUS: number of online/avail cpus
>>>  - HEADER_CMDLINE: perf command line
>>>  - HEADER_VERSION: perf version
>>>  - HEADER_TOPOLOGY: cpu topology
>>>  - HEADER_EVENT_DESC: event name + perf_event_attr
>>>
>>> The small granularity for the entries is to make it easier
>>> to extend without breaking backward compatiblity. All entries
>>> are provided as ASCII strings, easy to parse, except for part of
>>> the event description.
>>
>> At some point I thought about a system where we would stash the rpm -qa,
>> etc and stash it in a database, say, git, and then get the SHA1 and add
>> in the perf.data header, so that we later could compare what system
>> components changed that may be related to changes in performance, a
>> project for later :)
>>
> You have a lot more features bit to play with, so we can extend it later.
>
>>> The capture of the extra information is optional. You need
>>> to pass -I to perf record. Similarly, you need to pass -I
>>> to perf report to print the information.
>>
>> Perhaps its better to make this more transparent and make it not
>> optional?
>>
> Actually, that's how I had it initially, then I changed my mind to be less
> disruptive. But OTOH,  it does not cost much to systematically record
> the info. It's better to have it in there and not use it, than to not save
> it and realize later you need it. I will resubmit without the option.
> I think we can probably do the same with perf report and drop the -I.
>
>>> $ perf record -I noploop 1
>>> noploop for 1 seconds
>>> [ perf record: Woken up 1 times to write data ]
>>> [ perf record: Captured and wrote 0.043 MB perf.data (~1897 samples) ]
>>> $ perf report -I --stdio
>>> #
>>> # captured on: Mon Sep  5 11:40:06 2011
>>> # hostname : quad
>>> # os release : 3.1.0-rc4-tip
>>> # arch : x86_64
>>> # cpuid : Intel(R) Core(TM)2 Quad CPU Q6600 @ 2.40GHz
>>> # nrcpus online : 4
>>> # nrcpus avail : 4
>>> # event = cycles, type = 0, config = 0x0, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, id = { 9, 10, 11, 12 }
>>> # cmdline : perf record -I noploop 1
>>> # perf version : 3.1.0-rc4
>>> # CPU0 sibling cores  : 0-3
>>> # CPU0 sibling threads: 0
>>> # CPU1 sibling cores  : 0-3
>>> # CPU1 sibling threads: 1
>>> # CPU2 sibling cores  : 0-3
>>> # CPU2 sibling threads: 2
>>> # CPU3 sibling cores  : 0-3
>>> # CPU3 sibling threads: 3
>>> #
>>> # Events: 989  cycles
>>> #
>>> # Overhead  Command      Shared Object                Symbol
>>> # ........  .......  .................  ....................
>>> #
>>>     99.54%  noploop  noploop            [.] noploop
>>>      0.45%  noploop  [kernel.kallsyms]  [k] copy_page_c
>>>      0.01%  noploop  [kernel.kallsyms]  [k] do_raw_spin_unlock
>>>      0.00%  noploop  [kernel.kallsyms]  [k] intel_pmu_enable_all
>>>
>>>
>>> Signed-off-by: Stephane Eranian <eranian@google.com>
>>> ---
>>>
>>> diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
>>> index 5a520f8..66acb75 100644
>>> --- a/tools/perf/Documentation/perf-record.txt
>>> +++ b/tools/perf/Documentation/perf-record.txt
>>> @@ -148,6 +148,12 @@ an empty cgroup (monitor all the time) using, e.g., -G foo,,bar. Cgroups must ha
>>>  corresponding events, i.e., they always refer to events defined earlier on the command
>>>  line.
>>>
>>> +-I::
>>> +--machine-info::
>>> +Collect additional information about the host machine and kernel in an effort to
>>> +have perf.data be more self-descriptive. The type of information gathered include:
>>> +hostname, cpu model, cpu topology, kernel version, host architecture, event
>>> +descriptions and so on.
>>>  SEE ALSO
>>>  --------
>>>  linkperf:perf-stat[1], linkperf:perf-list[1]
>>> diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
>>> index 04253c0..191e10e 100644
>>> --- a/tools/perf/Documentation/perf-report.txt
>>> +++ b/tools/perf/Documentation/perf-report.txt
>>> @@ -134,6 +134,11 @@ OPTIONS
>>>       CPUs are specified with -: 0-2. Default is to report samples on all
>>>       CPUs.
>>>
>>> +-I::
>>> +--show-info::
>>> +     Display information about the perf.data file, incl. hostname,
>>> +     os release, perf version, machine desc.
>>> +
>>>  SEE ALSO
>>>  --------
>>>  linkperf:perf-stat[1]
>>> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
>>> index 6b0519f..f2a732f 100644
>>> --- a/tools/perf/builtin-record.c
>>> +++ b/tools/perf/builtin-record.c
>>> @@ -63,6 +63,7 @@ static bool                 sample_address                  =  false;
>>>  static bool                  sample_time                     =  false;
>>>  static bool                  no_buildid                      =  false;
>>>  static bool                  no_buildid_cache                =  false;
>>> +static bool                  machine_infos                   =  false;
>>>  static struct perf_evlist    *evsel_list;
>>>
>>>  static long                  samples                         =      0;
>>> @@ -513,6 +514,18 @@ static int __cmd_record(int argc, const char **argv)
>>>       if (have_tracepoints(&evsel_list->entries))
>>>               perf_header__set_feat(&session->header, HEADER_TRACE_INFO);
>>>
>>> +     if (machine_infos) {
>>> +             perf_header__set_feat(&session->header, HEADER_HOSTNAME);
>>> +             perf_header__set_feat(&session->header, HEADER_OSRELEASE);
>>> +             perf_header__set_feat(&session->header, HEADER_ARCH);
>>> +             perf_header__set_feat(&session->header, HEADER_CPUID);
>>> +             perf_header__set_feat(&session->header, HEADER_NRCPUS);
>>> +             perf_header__set_feat(&session->header, HEADER_EVENT_DESC);
>>> +             perf_header__set_feat(&session->header, HEADER_CMDLINE);
>>> +             perf_header__set_feat(&session->header, HEADER_VERSION);
>>> +             perf_header__set_feat(&session->header, HEADER_TOPOLOGY);
>>> +     }
>>> +
>>>       /* 512 kiB: default amount of unprivileged mlocked memory */
>>>       if (mmap_pages == UINT_MAX)
>>>               mmap_pages = (512 * 1024) / page_size;
>>> @@ -774,6 +787,8 @@ const struct option record_options[] = {
>>>       OPT_CALLBACK('G', "cgroup", &evsel_list, "name",
>>>                    "monitor event in cgroup name only",
>>>                    parse_cgroups),
>>> +     OPT_BOOLEAN('I', "machine-info", &machine_infos,
>>> +                 "collect information about host machine and kernel"),
>>>       OPT_END()
>>>  };
>>>
>>> @@ -782,6 +797,8 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
>>>       int err = -ENOMEM;
>>>       struct perf_evsel *pos;
>>>
>>> +     perf_header__set_cmdline(argc, argv);
>>> +
>>>       evsel_list = perf_evlist__new(NULL, NULL);
>>>       if (evsel_list == NULL)
>>>               return -ENOMEM;
>>> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
>>> index d7ff277..7721030 100644
>>> --- a/tools/perf/builtin-report.c
>>> +++ b/tools/perf/builtin-report.c
>>> @@ -40,6 +40,7 @@ static char         const *input_name = "perf.data";
>>>  static bool          force, use_tui, use_stdio;
>>>  static bool          hide_unresolved;
>>>  static bool          dont_use_callchains;
>>> +static bool          show_info;
>>>
>>>  static bool          show_threads;
>>>  static struct perf_read_values       show_threads_values;
>>> @@ -276,6 +277,9 @@ static int __cmd_report(void)
>>>                       goto out_delete;
>>>       }
>>>
>>> +     if (show_info)
>>> +             perf_session__fprintf_info(session, stdout);
>>> +
>>>       if (show_threads)
>>>               perf_read_values_init(&show_threads_values);
>>>
>>> @@ -487,6 +491,8 @@ static const struct option options[] = {
>>>       OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
>>>                   "Look for files with symbols relative to this directory"),
>>>       OPT_STRING('c', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
>>> +     OPT_BOOLEAN('I', "show-info", &show_info,
>>> +                     "display information about perf.data file"),
>>>       OPT_END()
>>>  };
>>>
>>> diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
>>> index 4702e24..b382bd5 100644
>>> --- a/tools/perf/builtin.h
>>> +++ b/tools/perf/builtin.h
>>> @@ -4,7 +4,6 @@
>>>  #include "util/util.h"
>>>  #include "util/strbuf.h"
>>>
>>> -extern const char perf_version_string[];
>>>  extern const char perf_usage_string[];
>>>  extern const char perf_more_info_string[];
>>>
>>> diff --git a/tools/perf/perf.h b/tools/perf/perf.h
>>> index a5fc660..90f9370 100644
>>> --- a/tools/perf/perf.h
>>> +++ b/tools/perf/perf.h
>>> @@ -9,18 +9,21 @@ void get_term_dimensions(struct winsize *ws);
>>>  #include "../../arch/x86/include/asm/unistd.h"
>>>  #define rmb()                asm volatile("lock; addl $0,0(%%esp)" ::: "memory")
>>>  #define cpu_relax()  asm volatile("rep; nop" ::: "memory");
>>> +#define CPUINFO_PROC "model name"
>>>  #endif
>>>
>>>  #if defined(__x86_64__)
>>>  #include "../../arch/x86/include/asm/unistd.h"
>>>  #define rmb()                asm volatile("lfence" ::: "memory")
>>>  #define cpu_relax()  asm volatile("rep; nop" ::: "memory");
>>> +#define CPUINFO_PROC "model name"
>>>  #endif
>>>
>>>  #ifdef __powerpc__
>>>  #include "../../arch/powerpc/include/asm/unistd.h"
>>>  #define rmb()                asm volatile ("sync" ::: "memory")
>>>  #define cpu_relax()  asm volatile ("" ::: "memory");
>>> +#define CPUINFO_PROC "cpu"
>>>  #endif
>>>
>>>  #ifdef __s390__
>>> @@ -37,30 +40,35 @@ void get_term_dimensions(struct winsize *ws);
>>>  # define rmb()               asm volatile("" ::: "memory")
>>>  #endif
>>>  #define cpu_relax()  asm volatile("" ::: "memory")
>>> +#define CPUINFO_PROC "cpu type"
>>>  #endif
>>>
>>>  #ifdef __hppa__
>>>  #include "../../arch/parisc/include/asm/unistd.h"
>>>  #define rmb()                asm volatile("" ::: "memory")
>>>  #define cpu_relax()  asm volatile("" ::: "memory");
>>> +#define CPUINFO_PROC "cpu"
>>>  #endif
>>>
>>>  #ifdef __sparc__
>>>  #include "../../arch/sparc/include/asm/unistd.h"
>>>  #define rmb()                asm volatile("":::"memory")
>>>  #define cpu_relax()  asm volatile("":::"memory")
>>> +#define CPUINFO_PROC "cpu"
>>>  #endif
>>>
>>>  #ifdef __alpha__
>>>  #include "../../arch/alpha/include/asm/unistd.h"
>>>  #define rmb()                asm volatile("mb" ::: "memory")
>>>  #define cpu_relax()  asm volatile("" ::: "memory")
>>> +#define CPUINFO_PROC "cpu model"
>>>  #endif
>>>
>>>  #ifdef __ia64__
>>>  #include "../../arch/ia64/include/asm/unistd.h"
>>>  #define rmb()                asm volatile ("mf" ::: "memory")
>>>  #define cpu_relax()  asm volatile ("hint @pause" ::: "memory")
>>> +#define CPUINFO_PROC "model name"
>>>  #endif
>>>
>>>  #ifdef __arm__
>>> @@ -71,6 +79,7 @@ void get_term_dimensions(struct winsize *ws);
>>>   */
>>>  #define rmb()                ((void(*)(void))0xffff0fa0)()
>>>  #define cpu_relax()  asm volatile("":::"memory")
>>> +#define CPUINFO_PROC "Processor"
>>>  #endif
>>>
>>>  #ifdef __mips__
>>> @@ -171,5 +180,6 @@ struct ip_callchain {
>>>  };
>>>
>>>  extern bool perf_host, perf_guest;
>>> +extern const char perf_version_string[];
>>>
>>>  #endif
>>> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
>>> index a03a36b..db17196 100644
>>> --- a/tools/perf/util/evsel.c
>>> +++ b/tools/perf/util/evsel.c
>>> @@ -341,7 +341,8 @@ static bool sample_overlap(const union perf_event *event,
>>>  }
>>>
>>>  int perf_event__parse_sample(const union perf_event *event, u64 type,
>>> -                          int sample_size, bool sample_id_all,
>>> +                          int sample_size,
>>> +                          bool sample_id_all,
>>>                            struct perf_sample *data)
>>>  {
>>>       const u64 *array;
>>> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
>>> index b6c1ad1..6bac5ab 100644
>>> --- a/tools/perf/util/header.c
>>> +++ b/tools/perf/util/header.c
>>> @@ -7,6 +7,7 @@
>>>  #include <stdlib.h>
>>>  #include <linux/list.h>
>>>  #include <linux/kernel.h>
>>> +#include <sys/utsname.h>
>>>
>>>  #include "evlist.h"
>>>  #include "evsel.h"
>>> @@ -23,6 +24,9 @@ static bool no_buildid_cache = false;
>>>  static int event_count;
>>>  static struct perf_trace_event_type *events;
>>>
>>> +static int header_argc;
>>> +static const char **header_argv;
>>> +
>>
>> Here I suggest moving these variables to struct perf_header, to avoid
>> globals.
>>
> Will do that.
>

Well, now I remember why I did it that way. There is a problem with
the initialization
code. To get a perf_header, you need a session. The creation of the
session is deferred
until after the options are parse. The problem is that parsing the
option is destructive on
the options to perf up the the program to monitor. So we need to stash
a copy BEFORE
parsing. We could stash it in builtin-record.c and then use the copy
to set up the
session->header. But is that really any better?

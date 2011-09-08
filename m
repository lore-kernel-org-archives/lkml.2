Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab1IHP2I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 11:28:08 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:34118 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab1IHP2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 11:28:03 -0400
Message-ID: <4E68DEF5.9040000@gmail.com>
Date: Thu, 08 Sep 2011 09:27:49 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        mingo@elte.hu
Subject: Re: [PATCH] perf: make perf.data more self-descriptive (v4)
References: <20110907191045.GA13475@quad>
In-Reply-To: <20110907191045.GA13475@quad>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 09/07/2011 01:10 PM, Stephane Eranian wrote:
> 
> The goal of this patch is to include more information
> about the host environment into the perf.data so it is
> more self-descriptive. Overtime, profiles are captured
> on various machines and it becomes hard to track what
> was recorded, on what machine and when.
> 
> This patch provides a way to solve this by extending
> the perf.data file with basic information about the
> host machine. To add those extensions, we leverage
> the feature bits capabilities of the perf.data format.
> The change is backward compatible with existing perf.data
> files.
> 
> We define the following useful new extensions:
>  - HEADER_HOSTNAME: the hostname
>  - HEADER_OSRELEASE: the kernel release number
>  - HEADER_ARCH: the hw architecture
>  - HEADER_CPUID: the cpu model description
>  - HEADER_NRCPUS: number of online/avail cpus
>  - HEADER_CMDLINE: perf command line
>  - HEADER_VERSION: perf version
>  - HEADER_TOPOLOGY: cpu topology
>  - HEADER_EVENT_DESC: full event description (attrs)
> 
> The small granularity for the entries is to make it easier
> to extend without breaking backward compatiblity. All entries
> are provided as ASCII strings, easy to parse, except for the
> event description.
> 
> In the second version, we dropped the -I option for the
> perf record command. The extra information is systematically
> captured. But it's still displayed optionally by perf report.
> There are also a couple of cleanups of function prototypes
> and global variables.
> 
> In the third version, we:
> - fixed missing MIPS support for CPUID
> - used u32 instead of int when writing integers to file
> - fixed couple of bswap() bugs
> - refactorize all write/print functions using function pointers
> - improved write_cmdline() to include actual path to perf binary
> 
> In the fourth version, we:
> - fixed a couple of int vs. u32 issues
> - factorized HEADER_BUILD_ID, HEADER_TRACE_INFO
> - added -I option to perf script report
> - reverted change to evsel.c (unrelated to meta-data)
> - modified write_*() to always write despite errors (adds_feature bit present)
> - added HEADER_TOTAL_MEM: total memory installed on this system
> - added HEADER_NUMA_TOPOLOGY: shows NUMA nodes and for each memory, cpu list
> - renamed HEADER_TOPOLOGY to HEADER_CPU_TOPOLOGY

Still some endianness problems; cross-endian analysis is causing perf to
abort. I need some time to investigate. I can send you a ppc data file
if you have the time.

David

> 
> 
> $ perf record -ecycles,instructions noploop 1
> noploop for 1 seconds
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.098 MB perf.data (~4260 samples) ]
> $ perf report -I --stdio
> #
> # captured on: Wed Sep  7 21:00:10 2011
> # hostname : quad
> # os release : 3.1.0-rc4-tip
> # arch : x86_64
> # cpuid : Intel(R) Core(TM)2 Quad CPU Q6600 @ 2.40GHz
> # nrcpus online : 4
> # nrcpus avail : 4
> # event = cycles, type = 0, config = 0x0, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, id = { 536, 537, 538, 539 }
> # event = instructions, type = 0, config = 0x1, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, id = { 540, 541, 542,
> # cmdline : /home/eranian/perfmon/official/tip/build/tools/perf/perf record -ecycles,instructions noploop 1 
> # perf version : 3.1.0-rc4
> # CPU0   sibling cores  : 0-3
> # CPU0   sibling threads: 0
> # CPU1   sibling cores  : 0-3
> # CPU1   sibling threads: 1
> # CPU2   sibling cores  : 0-3
> # CPU2   sibling threads: 2
> # CPU3   sibling cores  : 0-3
> # CPU3   sibling threads: 3
> # total memory: 8105344 kB
> # node0   meminfo : 8320608 kB
> # node0   cpu list: 0-3
> #
> # Events: 995  cycles
> #
> # Overhead  Command      Shared Object                Symbol
> # ........  .......  .................  ....................
> #
>     99.90%  noploop  noploop            [.] noploop
>      0.10%  noploop  [kernel.kallsyms]  [k] trace_hardirqs_on
>      0.00%  noploop  [kernel.kallsyms]  [k] lock_release
>      0.00%  noploop  [kernel.kallsyms]  [k] intel_pmu_enable_all
> ...
> 
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
> 
> diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
> index 04253c0..191e10e 100644
> --- a/tools/perf/Documentation/perf-report.txt
> +++ b/tools/perf/Documentation/perf-report.txt
> @@ -134,6 +134,11 @@ OPTIONS
>  	CPUs are specified with -: 0-2. Default is to report samples on all
>  	CPUs.
>  
> +-I::
> +--show-info::
> +	Display information about the perf.data file, incl. hostname,
> +	os release, perf version, machine desc.
> +
>  SEE ALSO
>  --------
>  linkperf:perf-stat[1]
> diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
> index db01786..ebf8a23 100644
> --- a/tools/perf/Documentation/perf-script.txt
> +++ b/tools/perf/Documentation/perf-script.txt
> @@ -188,6 +188,13 @@ OPTIONS
>  	CPUs are specified with -: 0-2. Default is to report samples on all
>  	CPUs.
>  
> +-I::
> +--show-info::
> +	Display information about the perf.data file, incl. hostname,
> +	os release, perf version, machine desc. It can only be used with the
> +	perf script report mode and it must be specified after the script name
> +	like for instance: perf script report syscall-counts -I.
> +
>  SEE ALSO
>  --------
>  linkperf:perf-record[1], linkperf:perf-script-perl[1],
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 6b0519f..524ebbf 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -513,6 +513,18 @@ static int __cmd_record(int argc, const char **argv)
>  	if (have_tracepoints(&evsel_list->entries))
>  		perf_header__set_feat(&session->header, HEADER_TRACE_INFO);
>  
> +	perf_header__set_feat(&session->header, HEADER_HOSTNAME);
> +	perf_header__set_feat(&session->header, HEADER_OSRELEASE);
> +	perf_header__set_feat(&session->header, HEADER_ARCH);
> +	perf_header__set_feat(&session->header, HEADER_CPUID);
> +	perf_header__set_feat(&session->header, HEADER_NRCPUS);
> +	perf_header__set_feat(&session->header, HEADER_EVENT_DESC);
> +	perf_header__set_feat(&session->header, HEADER_CMDLINE);
> +	perf_header__set_feat(&session->header, HEADER_VERSION);
> +	perf_header__set_feat(&session->header, HEADER_CPU_TOPOLOGY);
> +	perf_header__set_feat(&session->header, HEADER_TOTAL_MEM);
> +	perf_header__set_feat(&session->header, HEADER_NUMA_TOPOLOGY);
> +
>  	/* 512 kiB: default amount of unprivileged mlocked memory */
>  	if (mmap_pages == UINT_MAX)
>  		mmap_pages = (512 * 1024) / page_size;
> @@ -782,6 +794,8 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
>  	int err = -ENOMEM;
>  	struct perf_evsel *pos;
>  
> +	perf_header__set_cmdline(argc, argv);
> +
>  	evsel_list = perf_evlist__new(NULL, NULL);
>  	if (evsel_list == NULL)
>  		return -ENOMEM;
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index d7ff277..7721030 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -40,6 +40,7 @@ static char		const *input_name = "perf.data";
>  static bool		force, use_tui, use_stdio;
>  static bool		hide_unresolved;
>  static bool		dont_use_callchains;
> +static bool		show_info;
>  
>  static bool		show_threads;
>  static struct perf_read_values	show_threads_values;
> @@ -276,6 +277,9 @@ static int __cmd_report(void)
>  			goto out_delete;
>  	}
>  
> +	if (show_info)
> +		perf_session__fprintf_info(session, stdout);
> +
>  	if (show_threads)
>  		perf_read_values_init(&show_threads_values);
>  
> @@ -487,6 +491,8 @@ static const struct option options[] = {
>  	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
>  		    "Look for files with symbols relative to this directory"),
>  	OPT_STRING('c', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
> +	OPT_BOOLEAN('I', "show-info", &show_info,
> +			"display information about perf.data file"),
>  	OPT_END()
>  };
>  
> diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
> index 09024ec..dac86ab 100644
> --- a/tools/perf/builtin-script.c
> +++ b/tools/perf/builtin-script.c
> @@ -22,6 +22,7 @@ static u64			last_timestamp;
>  static u64			nr_unordered;
>  extern const struct option	record_options[];
>  static bool			no_callchain;
> +static bool			show_info = false;
>  static const char		*cpu_list;
>  static DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
>  
> @@ -1083,7 +1084,8 @@ static const struct option options[] = {
>  		     "comma separated output fields prepend with 'type:'. Valid types: hw,sw,trace,raw. Fields: comm,tid,pid,time,cpu,event,trace,ip,sym,dso,addr",
>  		     parse_output_fields),
>  	OPT_STRING('c', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
> -
> +	OPT_BOOLEAN('I', "show-info", &show_info,
> +			"display host information from perf.data file"),
>  	OPT_END()
>  };
>  
> @@ -1268,6 +1270,9 @@ int cmd_script(int argc, const char **argv, const char *prefix __used)
>  			return -1;
>  	}
>  
> +	if (show_info)
> +		perf_session__fprintf_info(session, stdout);
> +
>  	if (!no_callchain)
>  		symbol_conf.use_callchain = true;
>  	else
> diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
> index 4702e24..b382bd5 100644
> --- a/tools/perf/builtin.h
> +++ b/tools/perf/builtin.h
> @@ -4,7 +4,6 @@
>  #include "util/util.h"
>  #include "util/strbuf.h"
>  
> -extern const char perf_version_string[];
>  extern const char perf_usage_string[];
>  extern const char perf_more_info_string[];
>  
> diff --git a/tools/perf/perf.h b/tools/perf/perf.h
> index a5fc660..08b0b5e 100644
> --- a/tools/perf/perf.h
> +++ b/tools/perf/perf.h
> @@ -9,18 +9,21 @@ void get_term_dimensions(struct winsize *ws);
>  #include "../../arch/x86/include/asm/unistd.h"
>  #define rmb()		asm volatile("lock; addl $0,0(%%esp)" ::: "memory")
>  #define cpu_relax()	asm volatile("rep; nop" ::: "memory");
> +#define CPUINFO_PROC	"model name"
>  #endif
>  
>  #if defined(__x86_64__)
>  #include "../../arch/x86/include/asm/unistd.h"
>  #define rmb()		asm volatile("lfence" ::: "memory")
>  #define cpu_relax()	asm volatile("rep; nop" ::: "memory");
> +#define CPUINFO_PROC	"model name"
>  #endif
>  
>  #ifdef __powerpc__
>  #include "../../arch/powerpc/include/asm/unistd.h"
>  #define rmb()		asm volatile ("sync" ::: "memory")
>  #define cpu_relax()	asm volatile ("" ::: "memory");
> +#define CPUINFO_PROC	"cpu"
>  #endif
>  
>  #ifdef __s390__
> @@ -37,30 +40,35 @@ void get_term_dimensions(struct winsize *ws);
>  # define rmb()		asm volatile("" ::: "memory")
>  #endif
>  #define cpu_relax()	asm volatile("" ::: "memory")
> +#define CPUINFO_PROC	"cpu type"
>  #endif
>  
>  #ifdef __hppa__
>  #include "../../arch/parisc/include/asm/unistd.h"
>  #define rmb()		asm volatile("" ::: "memory")
>  #define cpu_relax()	asm volatile("" ::: "memory");
> +#define CPUINFO_PROC	"cpu"
>  #endif
>  
>  #ifdef __sparc__
>  #include "../../arch/sparc/include/asm/unistd.h"
>  #define rmb()		asm volatile("":::"memory")
>  #define cpu_relax()	asm volatile("":::"memory")
> +#define CPUINFO_PROC	"cpu"
>  #endif
>  
>  #ifdef __alpha__
>  #include "../../arch/alpha/include/asm/unistd.h"
>  #define rmb()		asm volatile("mb" ::: "memory")
>  #define cpu_relax()	asm volatile("" ::: "memory")
> +#define CPUINFO_PROC	"cpu model"
>  #endif
>  
>  #ifdef __ia64__
>  #include "../../arch/ia64/include/asm/unistd.h"
>  #define rmb()		asm volatile ("mf" ::: "memory")
>  #define cpu_relax()	asm volatile ("hint @pause" ::: "memory")
> +#define CPUINFO_PROC	"model name"
>  #endif
>  
>  #ifdef __arm__
> @@ -71,6 +79,7 @@ void get_term_dimensions(struct winsize *ws);
>   */
>  #define rmb()		((void(*)(void))0xffff0fa0)()
>  #define cpu_relax()	asm volatile("":::"memory")
> +#define CPUINFO_PROC	"Processor"
>  #endif
>  
>  #ifdef __mips__
> @@ -83,6 +92,7 @@ void get_term_dimensions(struct winsize *ws);
>  				: /* no input */			\
>  				: "memory")
>  #define cpu_relax()	asm volatile("" ::: "memory")
> +#define CPUINFO_PROC	"cpu model"
>  #endif
>  
>  #include <time.h>
> @@ -171,5 +181,6 @@ struct ip_callchain {
>  };
>  
>  extern bool perf_host, perf_guest;
> +extern const char perf_version_string[];
>  
>  #endif
> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> index b6c1ad1..73fa59e 100644
> --- a/tools/perf/util/header.c
> +++ b/tools/perf/util/header.c
> @@ -7,6 +7,7 @@
>  #include <stdlib.h>
>  #include <linux/list.h>
>  #include <linux/kernel.h>
> +#include <sys/utsname.h>
>  
>  #include "evlist.h"
>  #include "evsel.h"
> @@ -17,12 +18,19 @@
>  #include "session.h"
>  #include "symbol.h"
>  #include "debug.h"
> +#include "cpumap.h"
>  
>  static bool no_buildid_cache = false;
>  
>  static int event_count;
>  static struct perf_trace_event_type *events;
>  
> +static u32 header_argc;
> +static const char **header_argv;
> +
> +static int dsos__write_buildid_table(struct perf_header *header, int fd);
> +static int perf_session__cache_build_ids(struct perf_session *session);
> +
>  int perf_header__push_event(u64 id, const char *name)
>  {
>  	if (strlen(name) > MAX_EVENT_NAME)
> @@ -110,6 +118,843 @@ static int write_padded(int fd, const void *bf, size_t count,
>  	return err;
>  }
>  
> +static int do_write_string(int fd, const char *str)
> +{
> +	u32 len, olen;
> +	int ret;
> +
> +	olen = strlen(str) + 1;
> +	len = ALIGN(olen, NAME_ALIGN);
> +
> +	/* write len, incl. \0 */
> +	ret = do_write(fd, &len, sizeof(len));
> +	if (ret < 0)
> +		return ret;
> +
> +	return write_padded(fd, str, olen, len);
> +}
> +
> +static char *do_read_string(int fd, struct perf_header *ph)
> +{
> +	ssize_t sz, ret;
> +	u32 len;
> +	char *buf;
> +
> +	sz = read(fd, &len, sizeof(len));
> +	if (sz < (ssize_t)sizeof(len))
> +		return NULL;
> +
> +	if (ph->needs_swap)
> +		len = bswap_32(len);
> +
> +	buf = malloc(len);
> +	if (!buf)
> +		return NULL;
> +
> +	ret = read(fd, buf, len);
> +	if (ret == (ssize_t)len) {
> +		/*
> +		 * strings are padded by zeroes
> +		 * thus the actual strlen of buf
> +		 * may be less than len
> +		 */
> +		return buf;
> +	}
> +
> +	free(buf);
> +	return NULL;
> +}
> +
> +int
> +perf_header__set_cmdline(int argc, const char **argv)
> +{
> +	int i;
> +
> +	header_argc = (u32)argc;
> +
> +	/* do not include NULL termination */
> +	header_argv = calloc(argc, sizeof(char *));
> +	if (!header_argv)
> +		return -ENOMEM;
> +
> +	/*
> +	 * must copy argv contents because it gets moved
> +	 * around during option parsing
> +	 */
> +	for (i = 0; i < argc ; i++)
> +		header_argv[i] = argv[i];
> +
> +	return 0;
> +}
> +
> +static int write_trace_info(int fd, struct perf_header *h __used,
> +			    struct perf_evlist *evlist)
> +{
> +	return read_tracing_data(fd, &evlist->entries);
> +}
> +
> +
> +static int write_build_id(int fd, struct perf_header *h,
> +			  struct perf_evlist *evlist __used)
> +{
> +	struct perf_session *session;
> +	int err;
> +
> +	session = container_of(h, struct perf_session, header);
> +
> +	err = dsos__write_buildid_table(h, fd);
> +	if (err < 0) {
> +		pr_debug("failed to write buildid table\n");
> +		return err;
> +	}
> +	if (!no_buildid_cache)
> +		perf_session__cache_build_ids(session);
> +
> +	return 0;
> +}
> +
> +static int write_hostname(int fd, struct perf_header *h __used,
> +			  struct perf_evlist *evlist __used)
> +{
> +	struct utsname uts;
> +	int ret;
> +
> +	ret = uname(&uts);
> +	if (ret < 0)
> +		return -1;
> +
> +	return do_write_string(fd, uts.nodename);
> +}
> +
> +static int write_osrelease(int fd, struct perf_header *h __used,
> +			   struct perf_evlist *evlist __used)
> +{
> +	struct utsname uts;
> +	int ret;
> +
> +	ret = uname(&uts);
> +	if (ret < 0)
> +		return -1;
> +
> +	return do_write_string(fd, uts.release);
> +}
> +
> +static int write_arch(int fd, struct perf_header *h __used,
> +		      struct perf_evlist *evlist __used)
> +{
> +	struct utsname uts;
> +	int ret;
> +
> +	ret = uname(&uts);
> +	if (ret < 0)
> +		return -1;
> +
> +	return do_write_string(fd, uts.machine);
> +}
> +
> +static int write_version(int fd, struct perf_header *h __used,
> +			 struct perf_evlist *evlist __used)
> +{
> +	return do_write_string(fd, perf_version_string);
> +}
> +
> +static int write_cpuid(int fd, struct perf_header *h __used,
> +		       struct perf_evlist *evlist __used)
> +{
> +#ifndef CPUINFO_PROC
> +#define CPUINFO_PROC NULL
> +#endif
> +	FILE *file;
> +	char buf[256];
> +	char *s, *p;
> +	const char *search = CPUINFO_PROC;
> +
> +	file = fopen("/proc/cpuinfo", "r");
> +	if (!file)
> +		return -1;
> +
> +	if (search) {
> +		while (fgets(buf, sizeof(buf), file)) {
> +			if (strstr(buf, search))
> +				goto found;
> +		}
> +	}
> +	strcpy(buf, "unknown type");
> +found:
> +	fclose(file);
> +
> +	s = buf;
> +
> +	p = strchr(buf, ':');
> +	if (p && *(p+1) == ' ' && *(p+2))
> +		s = p + 2;
> +	p = strchr(s, '\n');
> +	if (p)
> +		*p = '\0';
> +
> +	/* squash extra space characters (branding string) */
> +	p = s;
> +	while (*p) {
> +		if (isspace(*p)) {
> +			char *r = p + 1;
> +			char *q = r;
> +			*p = ' ';
> +			while (*q && isspace(*q))
> +				q++;
> +			if (q != (p+1))
> +				while ((*r++ = *q++));
> +		}
> +		p++;
> +	}
> +	return do_write_string(fd, s);
> +}
> +
> +static int write_nrcpus(int fd, struct perf_header *h __used,
> +			struct perf_evlist *evlist __used)
> +{
> +	long nr;
> +	u32 nrc, nra;
> +	int ret;
> +
> +	nr = sysconf(_SC_NPROCESSORS_CONF);
> +	if (nr < 0)
> +		return -1;
> +
> +	nrc = (u32)(nr & UINT_MAX);
> +
> +	ret = sysconf(_SC_NPROCESSORS_ONLN);
> +	if (ret < 0)
> +		return -1;
> +
> +	nra = (u32)(nr & UINT_MAX);
> +
> +	ret = do_write(fd, &nrc, sizeof(nrc));
> +	if (ret < 0)
> +		return ret;
> +
> +	return do_write(fd, &nra, sizeof(nra));
> +}
> +
> +static int write_event_desc(int fd, struct perf_header *h __used,
> +			    struct perf_evlist *evlist)
> +{
> +	struct perf_evsel *attr;
> +	u32 nre = 0, nri, sz;
> +	int ret;
> +
> +	list_for_each_entry(attr, &evlist->entries, node)
> +		nre++;
> +
> +	/*
> +	 * write number of events
> +	 */
> +	ret = do_write(fd, &nre, sizeof(nre));
> +	if (ret < 0)
> +		return ret;
> +
> +	/*
> +	 * size of perf_event_attr struct
> +	 */
> +	sz = (u32)sizeof(attr->attr);
> +	ret = do_write(fd, &sz, sizeof(sz));
> +	if (ret < 0)
> +		return ret;
> +
> +	list_for_each_entry(attr, &evlist->entries, node) {
> +
> +		ret = do_write(fd, &attr->attr, sz);
> +		if (ret < 0)
> +			return ret;
> +		/*
> +		 * write number of unique id per event
> +		 * there is one id per instance of an event
> +		 *
> +		 * copy into an nri to be independent of the
> +		 * type of ids,
> +		 */
> +		nri = attr->ids;
> +		ret = do_write(fd, &nri, sizeof(nri));
> +		if (ret < 0)
> +			return ret;
> +
> +		/*
> +		 * write event string as passed on cmdline
> +		 */
> +		ret = do_write_string(fd, attr->name);
> +		if (ret < 0)
> +			return ret;
> +		/*
> +		 * write unique ids for this event
> +		 */
> +		ret = do_write(fd, attr->id, attr->ids * sizeof(u64));
> +		if (ret < 0)
> +			return ret;
> +	}
> +	return 0;
> +}
> +
> +static int write_cmdline(int fd, struct perf_header *h __used,
> +			 struct perf_evlist *evlist __used)
> +{
> +	char buf[MAXPATHLEN];
> +	char proc[32];
> +	u32 i, n;
> +	int ret;
> +
> +	/*
> +	 * actual atual path to perf binary
> +	 */
> +	sprintf(proc, "/proc/%d/exe", getpid());
> +	ret = readlink(proc, buf, sizeof(buf));
> +	if (ret <= 0)
> +		return -1;
> +
> +	/* readlink() does not add null termination */
> +	buf[ret] = '\0';
> +
> +	/* account for binary path */
> +	n = header_argc + 1;
> +
> +	ret = do_write(fd, &n, sizeof(n));
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = do_write_string(fd, buf);
> +	if (ret < 0)
> +		return ret;
> +
> +	for (i = 0 ; i < header_argc; i++) {
> +		ret = do_write_string(fd, header_argv[i]);
> +		if (ret < 0)
> +			return ret;
> +	}
> +	return 0;
> +}
> +
> +static const char *topo_fmt[] = {
> +	"/sys/devices/system/cpu/cpu%d/topology/core_siblings_list",
> +	"/sys/devices/system/cpu/cpu%d/topology/thread_siblings_list",
> +	NULL
> +};
> +
> +static int write_topo_cpu(int fd, int cpu)
> +{
> +	FILE *fp;
> +	char filename[MAXPATHLEN];
> +	char buf[MAXPATHLEN], *p, *c;
> +	const char **q = topo_fmt;
> +	int ret;
> +
> +	while (*q) {
> +
> +		sprintf(filename, *q, cpu);
> +
> +		fp = fopen(filename, "r");
> +		if (!fp)
> +			return -1;
> +
> +		c = fgets(buf, sizeof(buf), fp);
> +		if (!c) {
> +			fclose(fp);
> +			return -1;
> +		}
> +
> +		p = strchr(buf, '\n');
> +		if (p)
> +			*p = '\0';
> +
> +		fclose(fp);
> +
> +		ret = do_write_string(fd, c);
> +		if (ret < 0)
> +			return ret;
> +		q++;
> +	}
> +	return 0;
> +}
> +
> +static int write_cpu_topology(int fd, struct perf_header *h __used,
> +			  struct perf_evlist *evlist __used)
> +{
> +	u32 nr, i;
> +	long ncpus;
> +	int ret;
> +
> +	ncpus = sysconf(_SC_NPROCESSORS_CONF);
> +	if (ncpus < 0)
> +		return -1;
> +
> +	/* hopefully, this will keep compilers happy about the cast */
> +	nr = (u32)(ncpus & UINT_MAX);
> +
> +	ret = do_write(fd, &nr, sizeof(nr));
> +	if (ret < 0)
> +		return -1;
> +
> +	for (i = 0; i < nr; i++) {
> +		ret = do_write(fd, &i, sizeof(i));
> +		if (ret < 0)
> +			return ret;
> +
> +		ret = write_topo_cpu(fd, i);
> +		if (ret < 0)
> +			return ret;
> +	}
> +	return 0;
> +}
> +
> +static int write_total_mem(int fd, struct perf_header *h __used,
> +			  struct perf_evlist *evlist __used)
> +{
> +	char buf[MAXPATHLEN], *c;
> +	FILE *fp;
> +	int ret = -1, n;
> +	uint64_t mem;
> +
> +	fp = fopen("/proc/meminfo", "r");
> +	if (!fp)
> +		return -1;
> +
> +	while ((c = fgets(buf, sizeof(buf), fp))) {
> +		c = strstr(buf, "MemTotal:");
> +		if (c)
> +			break;
> +	}
> +	fclose(fp);
> +
> +	n = sscanf(buf, "%*s %"PRIu64, &mem);
> +	if (n == 1)
> +		ret = do_write(fd, &mem, sizeof(mem));
> +
> +	return ret;
> +}
> +
> +static int write_topo_node(int fd, int node)
> +{
> +	char filename[MAXPATHLEN];
> +	char buf[MAXPATHLEN], *p, *c;
> +	FILE *fp;
> +	uint64_t mem;
> +	int ret;
> +
> +	sprintf(filename, "/sys/devices/system/node/node%d/meminfo", node);
> +	fp = fopen(filename, "r");
> +	if (!fp)
> +		return -1;
> +
> +	while ((c = fgets(buf, sizeof(buf), fp))) {
> +		c = strstr(buf, "MemTotal:");
> +		if (c)
> +			break;
> +	}
> +	fclose(fp);
> +	if (!c)
> +		return -1;
> +	ret = sscanf(buf, "%*s %*d %*s %"PRIu64, &mem);
> +	if (ret != 1)
> +		return -1;
> +
> +	ret = do_write(fd, &mem, sizeof(mem));
> +	if (ret < 0)
> +		return -1;
> +
> +	sprintf(filename, "/sys/devices/system/node/node%d/cpulist", node);
> +	fp = fopen(filename, "r");
> +	if (!fp)
> +		return -1;
> +
> +	c = fgets(buf, sizeof(buf), fp);
> +	fclose(fp);
> +	if (!c)
> +		return -1;
> +
> +	p = strchr(buf, '\n');
> +	if (p)
> +		*p = '\0';
> +
> +	return do_write_string(fd, c);
> +}
> +
> +static int write_numa_topology(int fd, struct perf_header *h __used,
> +			  struct perf_evlist *evlist __used)
> +{
> +	char buf[MAXPATHLEN];
> +	FILE *fp;
> +	struct cpu_map *node_map;
> +	char *c;
> +	u32 nr, i, j;
> +	int ret;
> +
> +	fp = fopen("/sys/devices/system/node/online", "r");
> +	if (!fp)
> +		return -1;
> +
> +	c = fgets(buf, sizeof(buf), fp);
> +	fclose(fp);
> +	if (!c)
> +		return -1;
> +
> +	c = strchr(buf, '\n');
> +	if (c)
> +		*c = '\0';
> +
> +	node_map = cpu_map__new(buf);
> +	if (!node_map)
> +		return -1;
> +
> +	nr = (u32)node_map->nr;
> +	ret = do_write(fd, &nr, sizeof(nr));
> +	if (ret < 0)
> +		return -1;
> +
> +	for (i = 0; i < nr; i++) {
> +		j = (u32)node_map->map[i];
> +		ret = do_write(fd, &j, sizeof(j));
> +		if (ret < 0)
> +			goto error;
> +
> +		ret = write_topo_node(fd, i);
> +		if (ret < 0)
> +			goto error;
> +	}
> +	ret = 0;
> +error:
> +	free(node_map);
> +	return ret;
> +}
> +
> +static void print_hostname(struct perf_header *ph, int fd, FILE *fp)
> +{
> +	char *str = do_read_string(fd, ph);
> +	fprintf(fp, "# hostname : %s\n", str);
> +	free(str);
> +}
> +
> +static void print_osrelease(struct perf_header *ph, int fd, FILE *fp)
> +{
> +	char *str = do_read_string(fd, ph);
> +	fprintf(fp, "# os release : %s\n", str);
> +	free(str);
> +}
> +
> +static void print_arch(struct perf_header *ph, int fd, FILE *fp)
> +{
> +	char *str = do_read_string(fd, ph);
> +	fprintf(fp, "# arch : %s\n", str);
> +	free(str);
> +}
> +
> +static void print_cpuid(struct perf_header *ph, int fd, FILE *fp)
> +{
> +	char *str = do_read_string(fd, ph);
> +	fprintf(fp, "# cpuid : %s\n", str);
> +	free(str);
> +}
> +
> +static void print_nrcpus(struct perf_header *ph, int fd, FILE *fp)
> +{
> +	ssize_t ret;
> +	u32 nr;
> +
> +	ret = read(fd, &nr, sizeof(nr));
> +	if (ret != (ssize_t)sizeof(nr))
> +		nr = -1; /* interpreted as error */
> +
> +	if (ph->needs_swap)
> +		nr = bswap_32(nr);
> +
> +	fprintf(fp, "# nrcpus online : %u\n", nr);
> +
> +	ret = read(fd, &nr, sizeof(nr));
> +	if (ret != (ssize_t)sizeof(nr))
> +		nr = -1; /* interpreted as error */
> +
> +	if (ph->needs_swap)
> +		nr = bswap_32(nr);
> +
> +	fprintf(fp, "# nrcpus avail : %u\n", nr);
> +}
> +
> +static void print_version(struct perf_header *ph, int fd, FILE *fp)
> +{
> +	char *str = do_read_string(fd, ph);
> +	fprintf(fp, "# perf version : %s\n", str);
> +	free(str);
> +}
> +
> +static void print_cmdline(struct perf_header *ph, int fd, FILE *fp)
> +{
> +	ssize_t ret;
> +	char *str;
> +	u32 nr, i;
> +
> +	ret = read(fd, &nr, sizeof(nr));
> +	if (ret != (ssize_t)sizeof(nr)) {
> +		fprintf(fp, "# cmdline : unknown\n");
> +		return;
> +	}
> +
> +	if (ph->needs_swap)
> +		nr = bswap_32(nr);
> +
> +	fprintf(fp, "# cmdline : ");
> +
> +	for (i = 0; i < nr; i++) {
> +		str = do_read_string(fd, ph);
> +		fprintf(fp, "%s ", str);
> +		free(str);
> +	}
> +	fputc('\n', fp);
> +}
> +
> +static void print_cpu_topology(struct perf_header *ph, int fd, FILE *fp)
> +{
> +	ssize_t ret;
> +	u32 nr, c, i;
> +	char *str;
> +
> +	ret = read(fd, &nr, sizeof(nr));
> +	if (ret != (ssize_t)sizeof(nr)) {
> +		fprintf(fp, "# cpu topology  : not available\n");
> +		return;
> +	}
> +
> +	if (ph->needs_swap)
> +		nr = bswap_32(nr);
> +
> +	for (i = 0; i < nr; i++) {
> +
> +		ret = read(fd, &c, sizeof(c));
> +		if (ret != (ssize_t)sizeof(c))
> +			c = -1; /* interpreted as error */
> +
> +		if (ph->needs_swap)
> +			c = bswap_32(c);
> +
> +		str = do_read_string(fd, ph);
> +		fprintf(fp, "# CPU%u sibling cores  : %s\n", c, str);
> +		free(str);
> +
> +		str = do_read_string(fd, ph);
> +		fprintf(fp, "# CPU%u sibling threads: %s\n", c, str);
> +		free(str);
> +	}
> +}
> +
> +static void print_event_desc(struct perf_header *ph, int fd, FILE *fp)
> +{
> +	struct perf_event_attr attr;
> +	uint64_t id;
> +	void *buf = NULL;
> +	char *str;
> +	u32 nre, sz, nr, i, j, msz;
> +	int ret;
> +
> +	/* number of events */
> +	ret = read(fd, &nre, sizeof(nre));
> +	if (ret != (ssize_t)sizeof(nre))
> +		goto error;
> +
> +	if (ph->needs_swap)
> +		nre = bswap_32(nre);
> +
> +	ret = read(fd, &sz, sizeof(sz));
> +	if (ret != (ssize_t)sizeof(sz))
> +		goto error;
> +
> +	if (ph->needs_swap)
> +		sz = bswap_32(sz);
> +
> +	/*
> +	 * ensure it is at least to our ABI rev
> +	 */
> +	if (sz < (u32)sizeof(attr))
> +		goto error;
> +
> +	memset(&attr, 0, sizeof(attr));
> +
> +	/* read entire region to sync up to next field */
> +	buf = malloc(sz);
> +	if (!buf)
> +		goto error;
> +
> +	msz = sizeof(attr);
> +	if (sz < msz)
> +		msz = sz;
> +
> +	for (i = 0 ; i < nre; i++) {
> +
> +		ret = read(fd, buf, sz);
> +		if (ret != (ssize_t)sz)
> +			goto error;
> +
> +		if (ph->needs_swap)
> +			perf_event__attr_swap(buf);
> +
> +		memcpy(&attr, buf, msz);
> +
> +		ret = read(fd, &nr, sizeof(nr));
> +		if (ret != (ssize_t)sizeof(nr))
> +			goto error;
> +
> +		if (ph->needs_swap)
> +			nr = bswap_32(nr);
> +
> +		str = do_read_string(fd, ph);
> +		fprintf(fp, "# event = %s, ", str);
> +		free(str);
> +
> +		fprintf(fp, "type = %d, config = 0x%"PRIx64
> +			    ", config1 = 0x%"PRIx64", config2 = 0x%"PRIx64,
> +				attr.type,
> +				(u64)attr.config,
> +				(u64)attr.config1,
> +				(u64)attr.config2);
> +
> +		fprintf(fp, ", excl_usr = %d, excl_kern = %d",
> +				attr.exclude_user,
> +				attr.exclude_kernel);
> +
> +		if (nr)
> +			fprintf(fp, ", id = {");
> +
> +		for (j = 0 ; j < nr; j++) {
> +			ret = read(fd, &id, sizeof(id));
> +			if (ret != (ssize_t)sizeof(id))
> +				goto error;
> +
> +			if (ph->needs_swap)
> +				id = bswap_64(id);
> +
> +			if (j)
> +				fputc(',', fp);
> +
> +			fprintf(fp, " %"PRIu64, id);
> +		}
> +		if (nr && j == nr)
> +			fprintf(fp, " }");
> +		fputc('\n', fp);
> +	}
> +	free(buf);
> +	return;
> +error:
> +	fprintf(fp, "# event desc: not available or unable to read\n");
> +}
> +
> +static void print_total_mem(struct perf_header *h __used, int fd, FILE *fp)
> +{
> +	uint64_t mem;
> +	ssize_t ret;
> +
> +	ret = read(fd, &mem, sizeof(mem));
> +	if (ret != sizeof(mem))
> +		goto error;
> +
> +	if (h->needs_swap)
> +		mem = bswap_64(mem);
> +
> +	fprintf(fp, "# total memory: %"PRIu64" kB\n", mem);
> +	return;
> +error:
> +	fprintf(fp, "# total memory: unknown\n");
> +}
> +
> +static void print_numa_topology(struct perf_header *h __used, int fd, FILE *fp)
> +{
> +	ssize_t ret;
> +	u32 nr, c, i;
> +	char *str;
> +	uint64_t mem;
> +
> +	/* nr nodes */
> +	ret = read(fd, &nr, sizeof(nr));
> +	if (ret != (ssize_t)sizeof(nr))
> +		goto error;
> +
> +	if (h->needs_swap)
> +		nr = bswap_32(nr);
> +
> +	for (i = 0; i < nr; i++) {
> +
> +		/* node number */
> +		ret = read(fd, &c, sizeof(c));
> +		if (ret != (ssize_t)sizeof(c))
> +			goto error;
> +
> +		if (h->needs_swap)
> +			c = bswap_32(c);
> +
> +		ret = read(fd, &mem, sizeof(mem));
> +		if (ret != sizeof(mem))
> +			goto error;
> +
> +		if (h->needs_swap)
> +			mem = bswap_64(mem);
> +
> +		fprintf(fp, "# node%u meminfo : %"PRIu64" kB\n", c, mem);
> +
> +		str = do_read_string(fd, h);
> +		fprintf(fp, "# node%u cpu list: %s\n", c, str);
> +		free(str);
> +	}
> +	return;
> +error:
> +	fprintf(fp, "# numa topology : not available\n");
> +}
> +
> +struct feature_ops {
> +	int (*write)(int fd, struct perf_header *h, struct perf_evlist *evlist);
> +	void (*print)(struct perf_header *h, int fd, FILE *fp);
> +};
> +
> +#define FEAT_OP(n, w, p) [n] = { .write = w, .print = p }
> +
> +static struct feature_ops feat_ops[HEADER_LAST_FEATURE] = {
> +	FEAT_OP(HEADER_TRACE_INFO, write_trace_info, NULL),
> +	FEAT_OP(HEADER_BUILD_ID, write_build_id, NULL),
> +	FEAT_OP(HEADER_HOSTNAME, write_hostname, print_hostname),
> +	FEAT_OP(HEADER_OSRELEASE, write_osrelease, print_osrelease),
> +	FEAT_OP(HEADER_ARCH, write_arch, print_arch),
> +	FEAT_OP(HEADER_CPUID, write_cpuid, print_cpuid),
> +	FEAT_OP(HEADER_NRCPUS, write_nrcpus, print_nrcpus),
> +	FEAT_OP(HEADER_EVENT_DESC, write_event_desc, print_event_desc),
> +	FEAT_OP(HEADER_CMDLINE, write_cmdline, print_cmdline),
> +	FEAT_OP(HEADER_VERSION, write_version, print_version),
> +	FEAT_OP(HEADER_CPU_TOPOLOGY, write_cpu_topology, print_cpu_topology),
> +	FEAT_OP(HEADER_TOTAL_MEM, write_total_mem, print_total_mem),
> +	FEAT_OP(HEADER_NUMA_TOPOLOGY, write_numa_topology, print_numa_topology),
> +};
> +
> +static int perf_header_fprintf_info(struct perf_file_section *section,
> +				    struct perf_header *ph,
> +				    int feat, int fd, void *data)
> +{
> +	FILE *fp = data;
> +
> +	if (lseek(fd, section->offset, SEEK_SET) == (off_t)-1) {
> +		pr_debug("Failed to lseek to %" PRIu64 " offset for feature "
> +				"%d, continuing...\n", section->offset, feat);
> +		return 0;
> +	}
> +	if (feat < HEADER_TRACE_INFO || feat >= HEADER_LAST_FEATURE) {
> +		pr_warning("unknown feature %d\n", feat);
> +		return -1;
> +	}
> +
> +	if (feat_ops[feat].print)
> +		feat_ops[feat].print(ph, fd, fp);
> +
> +	return 0;
> +}
> +
> +int perf_header__fprintf_info(struct perf_session *session, FILE *fp __used)
> +{
> +	int fd = session->fd;
> +	struct perf_header *header = &session->header;
> +	perf_header__process_sections(header, fd, fp, perf_header_fprintf_info);
> +	return 0;
> +}
> +
>  #define dsos__for_each_with_build_id(pos, head)	\
>  	list_for_each_entry(pos, head, node)	\
>  		if (!pos->has_build_id)		\
> @@ -356,15 +1201,41 @@ static bool perf_session__read_build_ids(struct perf_session *session, bool with
>  	return ret;
>  }
>  
> +static int do_write_feat(int fd, struct perf_header *h, int type,
> +			 struct perf_file_section **p,
> +			 struct perf_evlist *evlist)
> +{
> +	int err;
> +	int ret = 0;
> +
> +	if (perf_header__has_feat(h, type)) {
> +
> +		(*p)->offset = lseek(fd, 0, SEEK_CUR);
> +
> +		err = feat_ops[type].write(fd, h, evlist);
> +		if (err < 0) {
> +			pr_debug("failed to write feature %d\n", type);
> +
> +			/* undo anything written */
> +			lseek(fd, (*p)->offset, SEEK_SET);
> +
> +			return -1;
> +		}
> +		(*p)->size = lseek(fd, 0, SEEK_CUR) - (*p)->offset;
> +		(*p)++;
> +	}
> +	return ret;
> +}
> +
>  static int perf_header__adds_write(struct perf_header *header,
>  				   struct perf_evlist *evlist, int fd)
>  {
>  	int nr_sections;
>  	struct perf_session *session;
> -	struct perf_file_section *feat_sec;
> +	struct perf_file_section *feat_sec, *p;
>  	int sec_size;
>  	u64 sec_start;
> -	int idx = 0, err;
> +	int err;
>  
>  	session = container_of(header, struct perf_session, header);
>  
> @@ -376,7 +1247,7 @@ static int perf_header__adds_write(struct perf_header *header,
>  	if (!nr_sections)
>  		return 0;
>  
> -	feat_sec = calloc(sizeof(*feat_sec), nr_sections);
> +	feat_sec = p = calloc(sizeof(*feat_sec), nr_sections);
>  	if (feat_sec == NULL)
>  		return -ENOMEM;
>  
> @@ -385,36 +1256,65 @@ static int perf_header__adds_write(struct perf_header *header,
>  	sec_start = header->data_offset + header->data_size;
>  	lseek(fd, sec_start + sec_size, SEEK_SET);
>  
> -	if (perf_header__has_feat(header, HEADER_TRACE_INFO)) {
> -		struct perf_file_section *trace_sec;
> -
> -		trace_sec = &feat_sec[idx++];
> +	err = do_write_feat(fd, header, HEADER_TRACE_INFO, &p, evlist);
> +	if (err)
> +		goto out_free;
>  
> -		/* Write trace info */
> -		trace_sec->offset = lseek(fd, 0, SEEK_CUR);
> -		read_tracing_data(fd, &evlist->entries);
> -		trace_sec->size = lseek(fd, 0, SEEK_CUR) - trace_sec->offset;
> +	err = do_write_feat(fd, header, HEADER_BUILD_ID, &p, evlist);
> +	if (err) {
> +		perf_header__clear_feat(header, HEADER_BUILD_ID);
> +		goto out_free;
>  	}
>  
> -	if (perf_header__has_feat(header, HEADER_BUILD_ID)) {
> -		struct perf_file_section *buildid_sec;
> +	err = do_write_feat(fd, header, HEADER_HOSTNAME, &p, evlist);
> +	if (err)
> +		perf_header__clear_feat(header, HEADER_HOSTNAME);
>  
> -		buildid_sec = &feat_sec[idx++];
> +	err = do_write_feat(fd, header, HEADER_OSRELEASE, &p, evlist);
> +	if (err)
> +		perf_header__clear_feat(header, HEADER_OSRELEASE);
>  
> -		/* Write build-ids */
> -		buildid_sec->offset = lseek(fd, 0, SEEK_CUR);
> -		err = dsos__write_buildid_table(header, fd);
> -		if (err < 0) {
> -			pr_debug("failed to write buildid table\n");
> -			goto out_free;
> -		}
> -		buildid_sec->size = lseek(fd, 0, SEEK_CUR) -
> -					  buildid_sec->offset;
> -		if (!no_buildid_cache)
> -			perf_session__cache_build_ids(session);
> -	}
> +	err = do_write_feat(fd, header, HEADER_ARCH, &p, evlist);
> +	if (err)
> +		perf_header__clear_feat(header, HEADER_ARCH);
> +
> +	err = do_write_feat(fd, header, HEADER_CPUID, &p, evlist);
> +	if (err)
> +		perf_header__clear_feat(header, HEADER_CPUID);
> +
> +	err = do_write_feat(fd, header, HEADER_NRCPUS, &p, evlist);
> +	if (err)
> +		perf_header__clear_feat(header, HEADER_NRCPUS);
> +
> +	err = do_write_feat(fd, header, HEADER_EVENT_DESC, &p, evlist);
> +	if (err)
> +		perf_header__clear_feat(header, HEADER_EVENT_DESC);
> +
> +	err = do_write_feat(fd, header, HEADER_CMDLINE, &p, evlist);
> +	if (err)
> +		perf_header__clear_feat(header, HEADER_CMDLINE);
> +
> +	err = do_write_feat(fd, header, HEADER_VERSION, &p, evlist);
> +	if (err)
> +		perf_header__clear_feat(header, HEADER_VERSION);
> +
> +	err = do_write_feat(fd, header, HEADER_CPU_TOPOLOGY, &p, evlist);
> +	if (err)
> +		perf_header__clear_feat(header, HEADER_CPU_TOPOLOGY);
> +
> +	err = do_write_feat(fd, header, HEADER_TOTAL_MEM, &p, evlist);
> +	if (err)
> +		perf_header__clear_feat(header, HEADER_TOTAL_MEM);
> +
> +	err = do_write_feat(fd, header, HEADER_NUMA_TOPOLOGY, &p, evlist);
> +	if (err)
> +		perf_header__clear_feat(header, HEADER_NUMA_TOPOLOGY);
>  
>  	lseek(fd, sec_start, SEEK_SET);
> +	/*
> +	 * may write more than needed due to dropped feature, but
> +	 * this is okay, reader will skip the mising entries
> +	 */
>  	err = do_write(fd, feat_sec, sec_size);
>  	if (err < 0)
>  		pr_debug("failed to write feature section\n");
> @@ -554,9 +1454,10 @@ static int perf_header__getbuffer64(struct perf_header *header,
>  }
>  
>  int perf_header__process_sections(struct perf_header *header, int fd,
> +				  void *data,
>  				  int (*process)(struct perf_file_section *section,
> -						 struct perf_header *ph,
> -						 int feat, int fd))
> +				  struct perf_header *ph,
> +				  int feat, int fd, void *data))
>  {
>  	struct perf_file_section *feat_sec;
>  	int nr_sections;
> @@ -584,7 +1485,7 @@ int perf_header__process_sections(struct perf_header *header, int fd,
>  		if (perf_header__has_feat(header, feat)) {
>  			struct perf_file_section *sec = &feat_sec[idx++];
>  
> -			err = process(sec, header, feat, fd);
> +			err = process(sec, header, feat, fd, data);
>  			if (err < 0)
>  				break;
>  		}
> @@ -796,7 +1697,7 @@ out:
>  
>  static int perf_file_section__process(struct perf_file_section *section,
>  				      struct perf_header *ph,
> -				      int feat, int fd)
> +				      int feat, int fd, void *data __used)
>  {
>  	if (lseek(fd, section->offset, SEEK_SET) == (off_t)-1) {
>  		pr_debug("Failed to lseek to %" PRIu64 " offset for feature "
> @@ -935,7 +1836,8 @@ int perf_session__read_header(struct perf_session *session, int fd)
>  		event_count =  f_header.event_types.size / sizeof(struct perf_trace_event_type);
>  	}
>  
> -	perf_header__process_sections(header, fd, perf_file_section__process);
> +	perf_header__process_sections(header, fd, NULL,
> +				      perf_file_section__process);
>  
>  	lseek(fd, header->data_offset, SEEK_SET);
>  
> diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
> index 1886256..455480b 100644
> --- a/tools/perf/util/header.h
> +++ b/tools/perf/util/header.h
> @@ -12,6 +12,19 @@
>  enum {
>  	HEADER_TRACE_INFO = 1,
>  	HEADER_BUILD_ID,
> +
> +	HEADER_HOSTNAME,
> +	HEADER_OSRELEASE,
> +	HEADER_ARCH,
> +	HEADER_CPUID,
> +	HEADER_NRCPUS,
> +	HEADER_EVENT_DESC,
> +	HEADER_CMDLINE,
> +	HEADER_VERSION,
> +	HEADER_CPU_TOPOLOGY,
> +	HEADER_TOTAL_MEM,
> +	HEADER_NUMA_TOPOLOGY,
> +
>  	HEADER_LAST_FEATURE,
>  };
>  
> @@ -68,10 +81,15 @@ void perf_header__set_feat(struct perf_header *header, int feat);
>  void perf_header__clear_feat(struct perf_header *header, int feat);
>  bool perf_header__has_feat(const struct perf_header *header, int feat);
>  
> +int perf_header__set_cmdline(int argc, const char **argv);
> +
>  int perf_header__process_sections(struct perf_header *header, int fd,
> +				  void *data,
>  				  int (*process)(struct perf_file_section *section,
> -						 struct perf_header *ph,
> -						 int feat, int fd));
> +				  struct perf_header *ph,
> +				  int feat, int fd, void *data));
> +
> +int perf_header__fprintf_info(struct perf_session *session, FILE *fp);
>  
>  int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
>  			  const char *name, bool is_kallsyms);
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index 72458d9..54613a2 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -1326,3 +1326,21 @@ int perf_session__cpu_bitmap(struct perf_session *session,
>  
>  	return 0;
>  }
> +
> +void perf_session__fprintf_info(struct perf_session *session, FILE *fp)
> +{
> +	struct stat st;
> +	int ret;
> +
> +	if (session == NULL || fp == NULL)
> +		return;
> +
> +	ret = fstat(session->fd, &st);
> +	if (ret == -1)
> +		return;
> +
> +	fprintf(fp, "#\n# captured on: %s", ctime(&st.st_ctime));
> +	ret = perf_header__fprintf_info(session, fp);
> +	if (ret == 0)
> +		fprintf(fp, "#\n");
> +}
> diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
> index 170601e..33a3a46 100644
> --- a/tools/perf/util/session.h
> +++ b/tools/perf/util/session.h
> @@ -176,4 +176,5 @@ void perf_session__print_ip(union perf_event *event,
>  int perf_session__cpu_bitmap(struct perf_session *session,
>  			     const char *cpu_list, unsigned long *cpu_bitmap);
>  
> +void perf_session__fprintf_info(struct perf_session *session, FILE *fp);
>  #endif /* __PERF_SESSION_H */

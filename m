Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab1IFRZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 13:25:39 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:45230 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab1IFRZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 13:25:33 -0400
Message-ID: <4E665789.10506@gmail.com>
Date: Tue, 06 Sep 2011 11:25:29 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        mingo@elte.hu, ming.m.lin@intel.com
Subject: Re: [PATCH] perf: make perf.data more self-descriptive (v2)
References: <20110906101322.GA6296@quad>
In-Reply-To: <20110906101322.GA6296@quad>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/06/2011 04:13 AM, Stephane Eranian wrote:
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
> In this second version, we dropped the -I option for the
> perf record command. The extra information is systematically
> captured. But it's still displayed optionally by perf report.
> There are also a couple of cleanups of function prototypes
> and global variables. We did not change the way the cmdline
> args are stashed (drop global variables) because it would
> more the code more complicated than needs be.
> 
> 
> $ perf record noploop 1
> noploop for 1 seconds
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.043 MB perf.data (~1895 samples) ]
> 
> $ perf report -I --stdio
> #
> # captured on: Tue Sep  6 11:16:07 2011
> # hostname : quad
> # os release : 3.1.0-rc4-tip
> # arch : x86_64
> # cpuid : Intel(R) Core(TM)2 Quad CPU Q6600 @ 2.40GHz
> # nrcpus online : 4
> # nrcpus avail : 4
> # event = cycles, type = 0, config = 0x0, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, id = { 1, 2, 3, 4 }
> # cmdline : perf record noploop 1 
> # perf version : 3.1.0-rc4
> # CPU0 sibling cores  : 0-3
> # CPU0 sibling threads: 0
> # CPU1 sibling cores  : 0-3
> # CPU1 sibling threads: 1
> # CPU2 sibling cores  : 0-3
> # CPU2 sibling threads: 2
> # CPU3 sibling cores  : 0-3
> # CPU3 sibling threads: 3

I like this. I have resorted to a wrapper that creates an 'info' file
for perf runs - to record all that contextual information about a data set.


> #
> # Events: 988  cycles
> #
> # Overhead  Command      Shared Object                Symbol
> # ........  .......  .................  ....................
> #
>     99.55%  noploop  noploop            [.] noploop
>      0.44%  noploop  [kernel.kallsyms]  [k] __bfs
>      0.01%  noploop  [kernel.kallsyms]  [k] sched_clock_local
>      0.00%  noploop  [kernel.kallsyms]  [k] intel_pmu_enable_all
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
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 6b0519f..118b0e9 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -513,6 +513,16 @@ static int __cmd_record(int argc, const char **argv)
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
> +	perf_header__set_feat(&session->header, HEADER_TOPOLOGY);
> +
>  	/* 512 kiB: default amount of unprivileged mlocked memory */
>  	if (mmap_pages == UINT_MAX)
>  		mmap_pages = (512 * 1024) / page_size;
> @@ -782,6 +792,8 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
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

What about builtin-script?


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
> index a5fc660..90f9370 100644
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
> @@ -171,5 +180,6 @@ struct ip_callchain {
>  };
>  
>  extern bool perf_host, perf_guest;
> +extern const char perf_version_string[];
>  
>  #endif
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index a03a36b..db17196 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -341,7 +341,8 @@ static bool sample_overlap(const union perf_event *event,
>  }
>  
>  int perf_event__parse_sample(const union perf_event *event, u64 type,
> -			     int sample_size, bool sample_id_all,
> +			     int sample_size,
> +			     bool sample_id_all,
>  			     struct perf_sample *data)
>  {
>  	const u64 *array;

Why? first line has 2 arguments, so the second line having 2 args is
consistent coding style.

> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> index b6c1ad1..66c0198 100644
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
> @@ -23,6 +24,9 @@ static bool no_buildid_cache = false;
>  static int event_count;
>  static struct perf_trace_event_type *events;
>  
> +static int header_argc;
> +static const char **header_argv;
> +
>  int perf_header__push_event(u64 id, const char *name)
>  {
>  	if (strlen(name) > MAX_EVENT_NAME)
> @@ -110,6 +114,528 @@ static int write_padded(int fd, const void *bf, size_t count,
>  	return err;
>  }
>  
> +static int do_write_string(int fd, const char *str)
> +{
> +	int len, olen;
> +	int ret;
> +
> +	olen = strlen(str) + 1;
> +	len = ALIGN(olen, NAME_ALIGN);
> +
> +	/* write len, incl. \0 */
> +	ret = do_write(fd, &len, sizeof(len));

you want len to be a u32 or u64 for proper endian swapping across
differing bitness.


> +	if (ret < 0)
> +		return ret;
> +
> +	return write_padded(fd, str, olen, len);
> +}
> +
> +static char *do_read_string(int fd, struct perf_header *ph)
> +{
> +	ssize_t sz, ret;
> +	int len;
> +	char *buf;
> +
> +	sz = read(fd, &len, sizeof(len));
> +	if (sz < (ssize_t)sizeof(len))
> +		return NULL;
> +
> +	if (ph->needs_swap)
> +		sz = bswap_32(sz);

use 'len' here; It is what is used below in the read (and malloc).

> +
> +	buf = malloc(len);
> +	if (!buf)
> +		return NULL;
> +
> +	ret = read(fd, buf, len);
> +	if (ret == len) {
> +		/* reduce to actual size (string is padded) */
> +		buf[strlen(buf)] = '\0';
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
> +	header_argc = argc;
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
> +static int write_hostname(int fd)
> +{
> +	struct utsname uts;
> +	const char *s = "N/A";
> +	int ret;
> +
> +	ret = uname(&uts);
> +	if (ret == 0)
> +		s = uts.nodename;
> +
> +	return do_write_string(fd, s);
> +}
> +
> +static int write_osrelease(int fd)
> +{
> +	struct utsname uts;
> +	const char *s = "N/A";
> +	int ret;
> +
> +	ret = uname(&uts);
> +	if (ret == 0)
> +		s = uts.release;
> +
> +	return do_write_string(fd, s);
> +}
> +
> +static int write_arch(int fd)
> +{
> +	struct utsname uts;
> +	const char *s = "N/A";
> +	int ret;
> +
> +	ret = uname(&uts);
> +	if (ret == 0)
> +		s = uts.machine;
> +
> +	return do_write_string(fd, s);
> +}
> +
> +static int write_version(int fd)
> +{
> +	return do_write_string(fd, perf_version_string);
> +}
> +
> +static int write_cpuid(int fd)
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
> +		while (fgets(buf, 255, file)) {
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
> +static int write_nrcpus(int fd)
> +{
> +	int nr;

u32 or u64 for nr since you are writing its length to the file.


> +
> +	/* it is okay to write -1 into the file */
> +	nr = sysconf(_SC_NPROCESSORS_CONF);
> +	do_write(fd, &nr, sizeof(nr));
> +
> +	/* it is okay to write -1 into the file */
> +	nr = sysconf(_SC_NPROCESSORS_ONLN);
> +	do_write(fd, &nr, sizeof(nr));
> +
> +	return 0;
> +}
> +
> +static int write_event_desc(int fd, struct perf_evlist *evlist)
> +{
> +	int ret, nre = 0, nri;
> +	int sz;

u32 or u64 for nre, nri and sz.

> +	struct perf_evsel *attr;
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
> +	sz = sizeof(attr->attr);
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
> +static int write_cmdline(int fd)
> +{
> +	int i, ret;
> +
> +	ret = do_write(fd, &header_argc, sizeof(header_argc));

header_argc needs to be a u32 or u64 as well.

> +	if (ret < 0)
> +		return ret;
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
> +	char filename[256], buf[256], *p;
> +	const char *c, **q = topo_fmt;
> +	int ret;
> +
> +	while (*q) {
> +
> +		c = "N/A";
> +
> +		sprintf(filename, *q, cpu);
> +
> +		fp = fopen(filename, "r");
> +		if (fp) {
> +			if (fgets(buf, 255, fp)) {
> +				c = buf;
> +				p = strchr(buf, '\n');
> +				if (p)
> +					*p = '\0';
> +			}
> +			fclose(fp);
> +		}
> +		ret = do_write_string(fd, c);
> +		if (ret < 0)
> +			return ret;
> +		q++;
> +	}
> +	return 0;
> +}
> +
> +static int write_topology(int fd)
> +{
> +	int i, nr, ret;

u32 or u64 for nr and i.

> +
> +	/* do not write entry on error */
> +	nr = sysconf(_SC_NPROCESSORS_CONF);
> +	if (nr < 0)
> +		return 0;
> +
> +	do_write(fd, &nr, sizeof(nr));
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
> +static int read_event_desc(int fd, struct perf_header *ph, FILE *fp)
> +{
> +	struct perf_event_attr attr;
> +	uint64_t id;
> +	void *buf;
> +	char *str;
> +	int ret, nre, sz, i, j, nr, msz;

ditto above on the u32/u64 type on the read side here.

> +	/* number of events */
> +	ret = read(fd, &nre, sizeof(nre));
> +	if (ret != (ssize_t)sizeof(nre))
> +		return -1;
> +
> +	if (ph->needs_swap)
> +		nre = bswap_32(nre);
> +
> +	ret = read(fd, &sz, sizeof(sz));
> +	if (ret != (ssize_t)sizeof(sz))
> +		return -1;
> +
> +	if (ph->needs_swap)
> +		sz = bswap_32(sz);
> +
> +	/*
> +	 * ensure it is at least to our ABI rev
> +	 */
> +	if (sz < (int)sizeof(attr))
> +		return -1;
> +
> +	memset(&attr, 0, sizeof(attr));
> +
> +	/* read entire region to sync up to next field */
> +	buf = malloc(sz);
> +	if (!buf)
> +		return -1;
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
> +			if (j)
> +				fputc(',', fp);
> +
> +			fprintf(fp, " %"PRIu64, id);
> +		}
> +		if (nr && j == nr)
> +			fprintf(fp, " }");
> +		fputc('\n', fp);
> +	}
> +	ret = 0;
> +error:
> +	free(buf);
> +	return ret;
> +}
> +
> +static int perf_header_fprintf_info(struct perf_file_section *section,
> +				    struct perf_header *ph,
> +				    int feat, int fd, void *data)
> +{
> +	char *str;
> +	FILE *fp = data;
> +	int nr, i, j;
> +	ssize_t ret;
> +
> +	if (lseek(fd, section->offset, SEEK_SET) == (off_t)-1) {
> +		pr_debug("Failed to lseek to %" PRIu64 " offset for feature "
> +				"%d, continuing...\n", section->offset, feat);
> +		return 0;
> +	}
> +
> +	switch (feat) {

How about a feature_ops array instead of an expanding switch?

David


> +	case HEADER_TRACE_INFO:
> +		break;
> +	case HEADER_BUILD_ID:
> +		break;
> +	case HEADER_HOSTNAME:
> +		str = do_read_string(fd, ph);
> +		fprintf(fp, "# hostname : %s\n", str);
> +		free(str);
> +		break;
> +	case HEADER_OSRELEASE:
> +		str = do_read_string(fd, ph);
> +		fprintf(fp, "# os release : %s\n", str);
> +		free(str);
> +		break;
> +	case HEADER_ARCH:
> +		str = do_read_string(fd, ph);
> +		fprintf(fp, "# arch : %s\n", str);
> +		free(str);
> +		break;
> +	case HEADER_CPUID:
> +		str = do_read_string(fd, ph);
> +		fprintf(fp, "# cpuid : %s\n", str);
> +		free(str);
> +		break;
> +	case HEADER_NRCPUS:
> +		ret = read(fd, &nr, sizeof(nr));
> +		if (ret != (ssize_t)sizeof(nr))
> +			nr = -1;
> +
> +		if (ph->needs_swap)
> +			nr = bswap_32(nr);
> +
> +		fprintf(fp, "# nrcpus online : %d\n", nr);
> +
> +		if (ph->needs_swap)
> +			nr = bswap_32(nr);
> +
> +		ret = read(fd, &nr, sizeof(nr));
> +		if (ret != (ssize_t)sizeof(nr))
> +			nr = -1;
> +		fprintf(fp, "# nrcpus avail : %d\n", nr);
> +		break;
> +	case HEADER_VERSION:
> +		str = do_read_string(fd, ph);
> +		fprintf(fp, "# perf version : %s\n", str);
> +		free(str);
> +		break;
> +	case HEADER_CMDLINE:
> +		ret = read(fd, &nr, sizeof(nr));
> +		if (ret != (ssize_t)sizeof(nr))
> +			return -1;
> +
> +		if (ph->needs_swap)
> +			nr = bswap_32(nr);
> +
> +		fprintf(fp, "# cmdline : perf ");
> +		for (i = 0; i < nr; i++) {
> +			str = do_read_string(fd, ph);
> +			fprintf(fp, "%s ", str);
> +			free(str);
> +		}
> +		fputc('\n', fp);
> +		break;
> +	case HEADER_EVENT_DESC:
> +		ret = read_event_desc(fd, ph, fp);
> +		if (ret)
> +			return -1;
> +		break;
> +	case HEADER_TOPOLOGY:
> +		ret = read(fd, &nr, sizeof(nr));
> +		if (ret != (ssize_t)sizeof(nr))
> +			return -1;
> +		if (ph->needs_swap)
> +			nr = bswap_32(nr);
> +		for (i = 0; i < nr; i++) {
> +			ret = read(fd, &j, sizeof(j));
> +			if (ret != (ssize_t)sizeof(j))
> +				return -1;
> +
> +			if (ph->needs_swap)
> +				j = bswap_32(j);
> +
> +			str = do_read_string(fd, ph);
> +			fprintf(fp, "# CPU%d sibling cores  : %s\n", j, str);
> +			free(str);
> +
> +			str = do_read_string(fd, ph);
> +			fprintf(fp, "# CPU%d sibling threads: %s\n", j, str);
> +			free(str);
> +		}
> +		break;
> +	default:
> +		pr_warning("unknown feature %d\n", feat);
> +	}
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
> @@ -356,15 +882,36 @@ static bool perf_session__read_build_ids(struct perf_session *session, bool with
>  	return ret;
>  }
>  
> +static int do_write_feat(int fd, struct perf_header *h, int type,
> +			 struct perf_file_section **p,
> +			 int (*func)(int fd))
> +{
> +	int err;
> +
> +	if (perf_header__has_feat(h, type)) {
> +
> +		(*p)->offset = lseek(fd, 0, SEEK_CUR);
> +
> +		err = (*func)(fd);
> +		if (err < 0) {
> +			pr_debug("failed to write hostname\n");
> +			return -1;
> +		}
> +		(*p)->size = lseek(fd, 0, SEEK_CUR) - (*p)->offset;
> +		(*p)++;
> +	}
> +	return 0;
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
> @@ -376,7 +923,7 @@ static int perf_header__adds_write(struct perf_header *header,
>  	if (!nr_sections)
>  		return 0;
>  
> -	feat_sec = calloc(sizeof(*feat_sec), nr_sections);
> +	feat_sec = p = calloc(sizeof(*feat_sec), nr_sections);
>  	if (feat_sec == NULL)
>  		return -ENOMEM;
>  
> @@ -386,34 +933,70 @@ static int perf_header__adds_write(struct perf_header *header,
>  	lseek(fd, sec_start + sec_size, SEEK_SET);
>  
>  	if (perf_header__has_feat(header, HEADER_TRACE_INFO)) {
> -		struct perf_file_section *trace_sec;
> -
> -		trace_sec = &feat_sec[idx++];
> -
>  		/* Write trace info */
> -		trace_sec->offset = lseek(fd, 0, SEEK_CUR);
> +		p->offset = lseek(fd, 0, SEEK_CUR);
>  		read_tracing_data(fd, &evlist->entries);
> -		trace_sec->size = lseek(fd, 0, SEEK_CUR) - trace_sec->offset;
> +		p->size = lseek(fd, 0, SEEK_CUR) - p->offset;
> +		p++;
>  	}
>  
>  	if (perf_header__has_feat(header, HEADER_BUILD_ID)) {
> -		struct perf_file_section *buildid_sec;
> -
> -		buildid_sec = &feat_sec[idx++];
> -
>  		/* Write build-ids */
> -		buildid_sec->offset = lseek(fd, 0, SEEK_CUR);
> +		p->offset = lseek(fd, 0, SEEK_CUR);
>  		err = dsos__write_buildid_table(header, fd);
>  		if (err < 0) {
>  			pr_debug("failed to write buildid table\n");
>  			goto out_free;
>  		}
> -		buildid_sec->size = lseek(fd, 0, SEEK_CUR) -
> -					  buildid_sec->offset;
> +		p->size = lseek(fd, 0, SEEK_CUR) - p->offset;
> +		p++;
>  		if (!no_buildid_cache)
>  			perf_session__cache_build_ids(session);
>  	}
>  
> +	err = do_write_feat(fd, header, HEADER_HOSTNAME, &p, write_hostname);
> +	if (err)
> +		goto out_free;
> +
> +	err = do_write_feat(fd, header, HEADER_OSRELEASE, &p, write_osrelease);
> +	if (err)
> +		goto out_free;
> +
> +	err = do_write_feat(fd, header, HEADER_ARCH, &p, write_arch);
> +	if (err)
> +		goto out_free;
> +
> +	err = do_write_feat(fd, header, HEADER_CPUID, &p, write_cpuid);
> +	if (err)
> +		goto out_free;
> +
> +	err = do_write_feat(fd, header, HEADER_NRCPUS, &p, write_nrcpus);
> +	if (err)
> +		goto out_free;
> +
> +	if (perf_header__has_feat(header, HEADER_EVENT_DESC)) {
> +		p->offset = lseek(fd, 0, SEEK_CUR);
> +		err = write_event_desc(fd, evlist);
> +		if (err < 0) {
> +			pr_debug("failed to write event desc\n");
> +			goto out_free;
> +		}
> +		p->size = lseek(fd, 0, SEEK_CUR) - p->offset;
> +		p++;
> +	}
> +
> +	err = do_write_feat(fd, header, HEADER_CMDLINE, &p, write_cmdline);
> +	if (err)
> +		goto out_free;
> +
> +	err = do_write_feat(fd, header, HEADER_VERSION, &p, write_version);
> +	if (err)
> +		goto out_free;
> +
> +	err = do_write_feat(fd, header, HEADER_TOPOLOGY, &p, write_topology);
> +	if (err)
> +		goto out_free;
> +
>  	lseek(fd, sec_start, SEEK_SET);
>  	err = do_write(fd, feat_sec, sec_size);
>  	if (err < 0)
> @@ -554,9 +1137,10 @@ static int perf_header__getbuffer64(struct perf_header *header,
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
> @@ -584,7 +1168,7 @@ int perf_header__process_sections(struct perf_header *header, int fd,
>  		if (perf_header__has_feat(header, feat)) {
>  			struct perf_file_section *sec = &feat_sec[idx++];
>  
> -			err = process(sec, header, feat, fd);
> +			err = process(sec, header, feat, fd, data);
>  			if (err < 0)
>  				break;
>  		}
> @@ -796,7 +1380,7 @@ out:
>  
>  static int perf_file_section__process(struct perf_file_section *section,
>  				      struct perf_header *ph,
> -				      int feat, int fd)
> +				      int feat, int fd, void *data __used)
>  {
>  	if (lseek(fd, section->offset, SEEK_SET) == (off_t)-1) {
>  		pr_debug("Failed to lseek to %" PRIu64 " offset for feature "
> @@ -935,7 +1519,8 @@ int perf_session__read_header(struct perf_session *session, int fd)
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
> index 1886256..3c74f7b 100644
> --- a/tools/perf/util/header.h
> +++ b/tools/perf/util/header.h
> @@ -12,6 +12,17 @@
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
> +	HEADER_TOPOLOGY,
> +
>  	HEADER_LAST_FEATURE,
>  };
>  
> @@ -68,10 +79,15 @@ void perf_header__set_feat(struct perf_header *header, int feat);
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

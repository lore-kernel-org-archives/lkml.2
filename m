Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309Ab1I0IRM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 04:17:12 -0400
Received: from smtp-out.google.com ([74.125.121.67]:14212 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab1I0IRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 04:17:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:to:cc:subject:message-id:
	mime-version:content-type:content-disposition:user-agent:x-system-of-record;
	b=gCssI+7brvk7HcqUShJztYdmILLkjRy8shN3yx+i2eqMBJ1VuGHzvX6E7eL+4rrNv
	3E99Qby5FpRPCVk1er/rw==
Date: Tue, 27 Sep 2011 10:16:54 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, peterz@infradead.org, dsahern@gmail.com,
        robert.richter@amd.com, ak@linux.intel.com, mingo@elte.hu
Subject: [PATCH] perf: make perf.data more self-descriptive (v6)
Message-ID: <20110927081654.GA6599@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The goal of this patch is to include more information
about the host environment into the perf.data so it is
more self-descriptive. Overtime, profiles are captured
on various machines and it becomes hard to track what
was recorded, on what machine and when.

This patch provides a way to solve this by extending
the perf.data file with basic information about the
host machine. To add those extensions, we leverage
the feature bits capabilities of the perf.data format.
The change is backward compatible with existing perf.data
files.

We define the following useful new extensions:
 - HEADER_HOSTNAME: the hostname
 - HEADER_OSRELEASE: the kernel release number
 - HEADER_ARCH: the hw architecture
 - HEADER_CPUDESC: generic CPU description
 - HEADER_NRCPUS: number of online/avail cpus
 - HEADER_CMDLINE: perf command line
 - HEADER_VERSION: perf version
 - HEADER_TOPOLOGY: cpu topology
 - HEADER_EVENT_DESC: full event description (attrs)
 - HEADER_CPUID: easy-to-parse low level CPU identication 

The small granularity for the entries is to make it easier
to extend without breaking backward compatiblity. All entries
are provided as ASCII strings, easy to parse, except for the
event description.

In the second version, we dropped the -I option for the
perf record command. The extra information is systematically
captured. But it's still displayed optionally by perf report.
There are also a couple of cleanups of function prototypes
and global variables.

In the third version, we:
- fixed missing MIPS support for CPUID
- used u32 instead of int when writing integers to file
- fixed couple of bswap() bugs
- refactorize all write/print functions using function pointers
- improved write_cmdline() to include actual path to perf binary

In the fourth version, we:
- fixed a couple of int vs. u32 issues
- factorized HEADER_BUILD_ID, HEADER_TRACE_INFO
- added -I option to perf script report
- reverted change to evsel.c (unrelated to meta-data)
- modified write_*() to always write despite errors (adds_feature bit present)
- added HEADER_TOTAL_MEM: total memory installed on this system
- added HEADER_NUMA_TOPOLOGY: shows NUMA nodes and for each memory, cpu list
- renamed HEADER_TOPOLOGY to HEADER_CPU_TOPOLOGY

In the fifth version, we:
- renamed HEADER_CPUID -> HEADER_CPUDESC. It provides a description of the CPU
- added HEADER_CPUID to capture the CPU identification

The advantage of CPUID over CPUDESC is that it is easy to parse automatically.
The CPUDESC provides a human-readable description of the CPU model. On X86, for
instance, CPUDESC captures the "branding" string, whereas CPUID captures vendor,
family, model, stepping. We also provide the PPC implementation, where CPUID
captures the CPU version, revision.  The CPUID feature is implemented via the
get_cpuid() arch callback.  When the arch does not provide the callback, the
CPUID is simply not captured.

In the sixth version, we:
- reordered the header field to have the one liners show up first
- compacted the CPU topology info
- have basic info displayed systematically with perf report
- made CPU and NUMA topology optional via -I
- have NUMA topology including total + free memory (can compute used memory)
- cleaned up syntax to make it easier to parse (':', '=' as as separators)
- use getline() instead of fgets() for parsing sysfs files
- fixed PPC compile error with mfspr() macro

$ perf report --stdio
# ========
# captured on : Mon Sep 26 15:22:14 2011
# hostname : quad
# os release : 3.1.0-rc4-tip
# perf version : 3.1.0-rc4
# arch : x86_64
# nrcpus online : 4
# nrcpus avail : 4
# cpudesc : Intel(R) Core(TM)2 Quad CPU Q6600 @ 2.40GHz
# cpuid : GenuineIntel,6,15,11
# total memory : 8105360 kB
# cmdline : /home/eranian/perfmon/official/tip/build/tools/perf/perf record date 
# event : name = cycles, type = 0, config = 0x0, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, id = { 29, 30, 31,
# HEADER_CPU_TOPOLOGY info available, use -I to display
# HEADER_NUMA_TOPOLOGY info available, use -I to display
# ========
#
...

$ perf report --stdio -I
# ========
# captured on : Mon Sep 26 15:22:14 2011
# hostname : quad
# os release : 3.1.0-rc4-tip
# perf version : 3.1.0-rc4
# arch : x86_64
# nrcpus online : 4
# nrcpus avail : 4
# cpudesc : Intel(R) Core(TM)2 Quad CPU Q6600 @ 2.40GHz
# cpuid : GenuineIntel,6,15,11
# total memory : 8105360 kB
# cmdline : /home/eranian/perfmon/official/tip/build/tools/perf/perf record date 
# event : name = cycles, type = 0, config = 0x0, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, id = { 29, 30, 31,
# sibling cores   : 0-3
# sibling threads : 0
# sibling threads : 1
# sibling threads : 2
# sibling threads : 3
# node0 meminfo  : total = 8320608 kB, free = 7571024 kB
# node0 cpu list : 0-3
# ========
#
...

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 04253c0..b9e2a56 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -134,6 +134,12 @@ OPTIONS
 	CPUs are specified with -: 0-2. Default is to report samples on all
 	CPUs.
 
+-I::
+--show-info::
+	Display extended information about the perf.data file. This adds
+	information which may be very large and thus may clutter the display.
+	It currently includes: cpu and numa topology of the host system.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1]
diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
index db01786..0c398f8 100644
--- a/tools/perf/Documentation/perf-script.txt
+++ b/tools/perf/Documentation/perf-script.txt
@@ -188,6 +188,15 @@ OPTIONS
 	CPUs are specified with -: 0-2. Default is to report samples on all
 	CPUs.
 
+-I::
+--show-info::
+	Display extended information about the perf.data file. This adds
+	information which may be very large and thus may clutter the display.
+	It currently includes: cpu and numa topology of the host system.
+
+	It can only be used with the perf script report mode. It must be
+	specified after the script name: perf script report syscall-counts -I.
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-script-perl[1],
diff --git a/tools/perf/arch/powerpc/Makefile b/tools/perf/arch/powerpc/Makefile
index 15130b5..744e629 100644
--- a/tools/perf/arch/powerpc/Makefile
+++ b/tools/perf/arch/powerpc/Makefile
@@ -2,3 +2,4 @@ ifndef NO_DWARF
 PERF_HAVE_DWARF_REGS := 1
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/header.o
diff --git a/tools/perf/arch/powerpc/util/header.c b/tools/perf/arch/powerpc/util/header.c
new file mode 100644
index 0000000..eba80c2
--- /dev/null
+++ b/tools/perf/arch/powerpc/util/header.c
@@ -0,0 +1,36 @@
+#include <sys/types.h>
+#include <unistd.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include "../../util/header.h"
+
+#define __stringify_1(x)        #x
+#define __stringify(x)          __stringify_1(x)
+
+#define mfspr(rn)       ({unsigned long rval; \
+			 asm volatile("mfspr %0," __stringify(rn) \
+				      : "=r" (rval)); rval; })
+
+#define SPRN_PVR        0x11F	/* Processor Version Register */
+#define PVR_VER(pvr)    (((pvr) >>  16) & 0xFFFF) /* Version field */
+#define PVR_REV(pvr)    (((pvr) >>   0) & 0xFFFF) /* Revison field */
+
+int
+get_cpuid(char *buffer, size_t sz)
+{
+	unsigned long pvr;
+	int nb;
+
+	pvr = mfspr(SPRN_PVR);
+
+	nb = snprintf(buffer, sz, "%lu,%lu$", PVR_VER(pvr), PVR_REV(pvr));
+
+	/* look for end marker to ensure the entire data fit */
+	if (strchr(buffer, '$')) {
+		buffer[nb-1] = '\0';
+		return 0;
+	}
+	return -1;
+}
diff --git a/tools/perf/arch/x86/Makefile b/tools/perf/arch/x86/Makefile
index 15130b5..744e629 100644
--- a/tools/perf/arch/x86/Makefile
+++ b/tools/perf/arch/x86/Makefile
@@ -2,3 +2,4 @@ ifndef NO_DWARF
 PERF_HAVE_DWARF_REGS := 1
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/header.o
diff --git a/tools/perf/arch/x86/util/header.c b/tools/perf/arch/x86/util/header.c
new file mode 100644
index 0000000..f940060
--- /dev/null
+++ b/tools/perf/arch/x86/util/header.c
@@ -0,0 +1,59 @@
+#include <sys/types.h>
+#include <unistd.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include "../../util/header.h"
+
+static inline void
+cpuid(unsigned int op, unsigned int *a, unsigned int *b, unsigned int *c,
+      unsigned int *d)
+{
+	__asm__ __volatile__ (".byte 0x53\n\tcpuid\n\t"
+			      "movl %%ebx, %%esi\n\t.byte 0x5b"
+			: "=a" (*a),
+			"=S" (*b),
+			"=c" (*c),
+			"=d" (*d)
+			: "a" (op));
+}
+
+int
+get_cpuid(char *buffer, size_t sz)
+{
+	unsigned int a, b, c, d, lvl;
+	int family = -1, model = -1, step = -1;
+	int nb;
+	char vendor[16];
+
+	cpuid(0, &lvl, &b, &c, &d);
+	strncpy(&vendor[0], (char *)(&b), 4);
+	strncpy(&vendor[4], (char *)(&d), 4);
+	strncpy(&vendor[8], (char *)(&c), 4);
+	vendor[12] = '\0';
+
+	if (lvl >= 1) {
+		cpuid(1, &a, &b, &c, &d);
+
+		family = (a >> 8) & 0xf;  /* bits 11 - 8 */
+		model  = (a >> 4) & 0xf;  /* Bits  7 - 4 */
+		step   = a & 0xf;
+
+		/* extended family */
+		if (family == 0xf)
+			family += (a >> 20) & 0xff;
+
+		/* extended model */
+		if (family >= 0x6)
+			model += ((a >> 16) & 0xf) << 4;
+	}
+	nb = snprintf(buffer, sz, "%s,%u,%u,%u$", vendor, family, model, step);
+
+	/* look for end marker to ensure the entire data fit */
+	if (strchr(buffer, '$')) {
+		buffer[nb-1] = '\0';
+		return 0;
+	}
+	return -1;
+}
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 6b0519f..1817217 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -513,6 +513,19 @@ static int __cmd_record(int argc, const char **argv)
 	if (have_tracepoints(&evsel_list->entries))
 		perf_header__set_feat(&session->header, HEADER_TRACE_INFO);
 
+	perf_header__set_feat(&session->header, HEADER_HOSTNAME);
+	perf_header__set_feat(&session->header, HEADER_OSRELEASE);
+	perf_header__set_feat(&session->header, HEADER_ARCH);
+	perf_header__set_feat(&session->header, HEADER_CPUDESC);
+	perf_header__set_feat(&session->header, HEADER_NRCPUS);
+	perf_header__set_feat(&session->header, HEADER_EVENT_DESC);
+	perf_header__set_feat(&session->header, HEADER_CMDLINE);
+	perf_header__set_feat(&session->header, HEADER_VERSION);
+	perf_header__set_feat(&session->header, HEADER_CPU_TOPOLOGY);
+	perf_header__set_feat(&session->header, HEADER_TOTAL_MEM);
+	perf_header__set_feat(&session->header, HEADER_NUMA_TOPOLOGY);
+	perf_header__set_feat(&session->header, HEADER_CPUID);
+
 	/* 512 kiB: default amount of unprivileged mlocked memory */
 	if (mmap_pages == UINT_MAX)
 		mmap_pages = (512 * 1024) / page_size;
@@ -782,6 +795,8 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 	int err = -ENOMEM;
 	struct perf_evsel *pos;
 
+	perf_header__set_cmdline(argc, argv);
+
 	evsel_list = perf_evlist__new(NULL, NULL);
 	if (evsel_list == NULL)
 		return -ENOMEM;
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index d7ff277..1b34300 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -40,6 +40,7 @@ static char		const *input_name = "perf.data";
 static bool		force, use_tui, use_stdio;
 static bool		hide_unresolved;
 static bool		dont_use_callchains;
+static bool		show_full_info;
 
 static bool		show_threads;
 static struct perf_read_values	show_threads_values;
@@ -276,6 +277,9 @@ static int __cmd_report(void)
 			goto out_delete;
 	}
 
+	if (use_browser <= 0)
+		perf_session__fprintf_info(session, stdout, show_full_info);
+
 	if (show_threads)
 		perf_read_values_init(&show_threads_values);
 
@@ -487,6 +491,8 @@ static const struct option options[] = {
 	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
 		    "Look for files with symbols relative to this directory"),
 	OPT_STRING('c', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
+	OPT_BOOLEAN('I', "show-full-info", &show_full_info,
+			"display extended information about perf.data file"),
 	OPT_END()
 };
 
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 09024ec..da68245 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -22,6 +22,7 @@ static u64			last_timestamp;
 static u64			nr_unordered;
 extern const struct option	record_options[];
 static bool			no_callchain;
+static bool			show_full_info = false;
 static const char		*cpu_list;
 static DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
 
@@ -1083,7 +1084,8 @@ static const struct option options[] = {
 		     "comma separated output fields prepend with 'type:'. Valid types: hw,sw,trace,raw. Fields: comm,tid,pid,time,cpu,event,trace,ip,sym,dso,addr",
 		     parse_output_fields),
 	OPT_STRING('c', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
-
+	OPT_BOOLEAN('I', "show-full-info", &show_full_info,
+			"display extended information from perf.data file"),
 	OPT_END()
 };
 
@@ -1268,6 +1270,8 @@ int cmd_script(int argc, const char **argv, const char *prefix __used)
 			return -1;
 	}
 
+	perf_session__fprintf_info(session, stdout, show_full_info);
+
 	if (!no_callchain)
 		symbol_conf.use_callchain = true;
 	else
diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
index 4702e24..b382bd5 100644
--- a/tools/perf/builtin.h
+++ b/tools/perf/builtin.h
@@ -4,7 +4,6 @@
 #include "util/util.h"
 #include "util/strbuf.h"
 
-extern const char perf_version_string[];
 extern const char perf_usage_string[];
 extern const char perf_more_info_string[];
 
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index a5fc660..08b0b5e 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -9,18 +9,21 @@ void get_term_dimensions(struct winsize *ws);
 #include "../../arch/x86/include/asm/unistd.h"
 #define rmb()		asm volatile("lock; addl $0,0(%%esp)" ::: "memory")
 #define cpu_relax()	asm volatile("rep; nop" ::: "memory");
+#define CPUINFO_PROC	"model name"
 #endif
 
 #if defined(__x86_64__)
 #include "../../arch/x86/include/asm/unistd.h"
 #define rmb()		asm volatile("lfence" ::: "memory")
 #define cpu_relax()	asm volatile("rep; nop" ::: "memory");
+#define CPUINFO_PROC	"model name"
 #endif
 
 #ifdef __powerpc__
 #include "../../arch/powerpc/include/asm/unistd.h"
 #define rmb()		asm volatile ("sync" ::: "memory")
 #define cpu_relax()	asm volatile ("" ::: "memory");
+#define CPUINFO_PROC	"cpu"
 #endif
 
 #ifdef __s390__
@@ -37,30 +40,35 @@ void get_term_dimensions(struct winsize *ws);
 # define rmb()		asm volatile("" ::: "memory")
 #endif
 #define cpu_relax()	asm volatile("" ::: "memory")
+#define CPUINFO_PROC	"cpu type"
 #endif
 
 #ifdef __hppa__
 #include "../../arch/parisc/include/asm/unistd.h"
 #define rmb()		asm volatile("" ::: "memory")
 #define cpu_relax()	asm volatile("" ::: "memory");
+#define CPUINFO_PROC	"cpu"
 #endif
 
 #ifdef __sparc__
 #include "../../arch/sparc/include/asm/unistd.h"
 #define rmb()		asm volatile("":::"memory")
 #define cpu_relax()	asm volatile("":::"memory")
+#define CPUINFO_PROC	"cpu"
 #endif
 
 #ifdef __alpha__
 #include "../../arch/alpha/include/asm/unistd.h"
 #define rmb()		asm volatile("mb" ::: "memory")
 #define cpu_relax()	asm volatile("" ::: "memory")
+#define CPUINFO_PROC	"cpu model"
 #endif
 
 #ifdef __ia64__
 #include "../../arch/ia64/include/asm/unistd.h"
 #define rmb()		asm volatile ("mf" ::: "memory")
 #define cpu_relax()	asm volatile ("hint @pause" ::: "memory")
+#define CPUINFO_PROC	"model name"
 #endif
 
 #ifdef __arm__
@@ -71,6 +79,7 @@ void get_term_dimensions(struct winsize *ws);
  */
 #define rmb()		((void(*)(void))0xffff0fa0)()
 #define cpu_relax()	asm volatile("":::"memory")
+#define CPUINFO_PROC	"Processor"
 #endif
 
 #ifdef __mips__
@@ -83,6 +92,7 @@ void get_term_dimensions(struct winsize *ws);
 				: /* no input */			\
 				: "memory")
 #define cpu_relax()	asm volatile("" ::: "memory")
+#define CPUINFO_PROC	"cpu model"
 #endif
 
 #include <time.h>
@@ -171,5 +181,6 @@ struct ip_callchain {
 };
 
 extern bool perf_host, perf_guest;
+extern const char perf_version_string[];
 
 #endif
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index b6c1ad1..fb0f6fc 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -7,6 +7,7 @@
 #include <stdlib.h>
 #include <linux/list.h>
 #include <linux/kernel.h>
+#include <sys/utsname.h>
 
 #include "evlist.h"
 #include "evsel.h"
@@ -17,12 +18,19 @@
 #include "session.h"
 #include "symbol.h"
 #include "debug.h"
+#include "cpumap.h"
 
 static bool no_buildid_cache = false;
 
 static int event_count;
 static struct perf_trace_event_type *events;
 
+static u32 header_argc;
+static const char **header_argv;
+
+static int dsos__write_buildid_table(struct perf_header *header, int fd);
+static int perf_session__cache_build_ids(struct perf_session *session);
+
 int perf_header__push_event(u64 id, const char *name)
 {
 	if (strlen(name) > MAX_EVENT_NAME)
@@ -110,6 +118,1021 @@ static int write_padded(int fd, const void *bf, size_t count,
 	return err;
 }
 
+static int do_write_string(int fd, const char *str)
+{
+	u32 len, olen;
+	int ret;
+
+	olen = strlen(str) + 1;
+	len = ALIGN(olen, NAME_ALIGN);
+
+	/* write len, incl. \0 */
+	ret = do_write(fd, &len, sizeof(len));
+	if (ret < 0)
+		return ret;
+
+	return write_padded(fd, str, olen, len);
+}
+
+static char *do_read_string(int fd, struct perf_header *ph)
+{
+	ssize_t sz, ret;
+	u32 len;
+	char *buf;
+
+	sz = read(fd, &len, sizeof(len));
+	if (sz < (ssize_t)sizeof(len))
+		return NULL;
+
+	if (ph->needs_swap)
+		len = bswap_32(len);
+
+	buf = malloc(len);
+	if (!buf)
+		return NULL;
+
+	ret = read(fd, buf, len);
+	if (ret == (ssize_t)len) {
+		/*
+		 * strings are padded by zeroes
+		 * thus the actual strlen of buf
+		 * may be less than len
+		 */
+		return buf;
+	}
+
+	free(buf);
+	return NULL;
+}
+
+int
+perf_header__set_cmdline(int argc, const char **argv)
+{
+	int i;
+
+	header_argc = (u32)argc;
+
+	/* do not include NULL termination */
+	header_argv = calloc(argc, sizeof(char *));
+	if (!header_argv)
+		return -ENOMEM;
+
+	/*
+	 * must copy argv contents because it gets moved
+	 * around during option parsing
+	 */
+	for (i = 0; i < argc ; i++)
+		header_argv[i] = argv[i];
+
+	return 0;
+}
+
+static int write_trace_info(int fd, struct perf_header *h __used,
+			    struct perf_evlist *evlist)
+{
+	return read_tracing_data(fd, &evlist->entries);
+}
+
+
+static int write_build_id(int fd, struct perf_header *h,
+			  struct perf_evlist *evlist __used)
+{
+	struct perf_session *session;
+	int err;
+
+	session = container_of(h, struct perf_session, header);
+
+	err = dsos__write_buildid_table(h, fd);
+	if (err < 0) {
+		pr_debug("failed to write buildid table\n");
+		return err;
+	}
+	if (!no_buildid_cache)
+		perf_session__cache_build_ids(session);
+
+	return 0;
+}
+
+static int write_hostname(int fd, struct perf_header *h __used,
+			  struct perf_evlist *evlist __used)
+{
+	struct utsname uts;
+	int ret;
+
+	ret = uname(&uts);
+	if (ret < 0)
+		return -1;
+
+	return do_write_string(fd, uts.nodename);
+}
+
+static int write_osrelease(int fd, struct perf_header *h __used,
+			   struct perf_evlist *evlist __used)
+{
+	struct utsname uts;
+	int ret;
+
+	ret = uname(&uts);
+	if (ret < 0)
+		return -1;
+
+	return do_write_string(fd, uts.release);
+}
+
+static int write_arch(int fd, struct perf_header *h __used,
+		      struct perf_evlist *evlist __used)
+{
+	struct utsname uts;
+	int ret;
+
+	ret = uname(&uts);
+	if (ret < 0)
+		return -1;
+
+	return do_write_string(fd, uts.machine);
+}
+
+static int write_version(int fd, struct perf_header *h __used,
+			 struct perf_evlist *evlist __used)
+{
+	return do_write_string(fd, perf_version_string);
+}
+
+static int write_cpudesc(int fd, struct perf_header *h __used,
+		       struct perf_evlist *evlist __used)
+{
+#ifndef CPUINFO_PROC
+#define CPUINFO_PROC NULL
+#endif
+	FILE *file;
+	char *buf = NULL;
+	char *s, *p;
+	const char *search = CPUINFO_PROC;
+	size_t len = 0;
+	int ret = -1;
+
+	file = fopen("/proc/cpuinfo", "r");
+	if (!file)
+		return -1;
+
+	if (search) {
+		while (getline(&buf, &len, file) > 0) {
+			ret = strncmp(buf, search, strlen(search));
+			if (!ret)
+				break;
+		}
+	}
+	if (ret)
+		goto done;
+
+	s = buf;
+
+	p = strchr(buf, ':');
+	if (p && *(p+1) == ' ' && *(p+2))
+		s = p + 2;
+	p = strchr(s, '\n');
+	if (p)
+		*p = '\0';
+
+	/* squash extra space characters (branding string) */
+	p = s;
+	while (*p) {
+		if (isspace(*p)) {
+			char *r = p + 1;
+			char *q = r;
+			*p = ' ';
+			while (*q && isspace(*q))
+				q++;
+			if (q != (p+1))
+				while ((*r++ = *q++));
+		}
+		p++;
+	}
+	ret = do_write_string(fd, s);
+done:
+	free(buf);
+	fclose(file);
+	return ret;
+}
+
+static int write_nrcpus(int fd, struct perf_header *h __used,
+			struct perf_evlist *evlist __used)
+{
+	long nr;
+	u32 nrc, nra;
+	int ret;
+
+	nr = sysconf(_SC_NPROCESSORS_CONF);
+	if (nr < 0)
+		return -1;
+
+	nrc = (u32)(nr & UINT_MAX);
+
+	ret = sysconf(_SC_NPROCESSORS_ONLN);
+	if (ret < 0)
+		return -1;
+
+	nra = (u32)(nr & UINT_MAX);
+
+	ret = do_write(fd, &nrc, sizeof(nrc));
+	if (ret < 0)
+		return ret;
+
+	return do_write(fd, &nra, sizeof(nra));
+}
+
+static int write_event_desc(int fd, struct perf_header *h __used,
+			    struct perf_evlist *evlist)
+{
+	struct perf_evsel *attr;
+	u32 nre = 0, nri, sz;
+	int ret;
+
+	list_for_each_entry(attr, &evlist->entries, node)
+		nre++;
+
+	/*
+	 * write number of events
+	 */
+	ret = do_write(fd, &nre, sizeof(nre));
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * size of perf_event_attr struct
+	 */
+	sz = (u32)sizeof(attr->attr);
+	ret = do_write(fd, &sz, sizeof(sz));
+	if (ret < 0)
+		return ret;
+
+	list_for_each_entry(attr, &evlist->entries, node) {
+
+		ret = do_write(fd, &attr->attr, sz);
+		if (ret < 0)
+			return ret;
+		/*
+		 * write number of unique id per event
+		 * there is one id per instance of an event
+		 *
+		 * copy into an nri to be independent of the
+		 * type of ids,
+		 */
+		nri = attr->ids;
+		ret = do_write(fd, &nri, sizeof(nri));
+		if (ret < 0)
+			return ret;
+
+		/*
+		 * write event string as passed on cmdline
+		 */
+		ret = do_write_string(fd, attr->name);
+		if (ret < 0)
+			return ret;
+		/*
+		 * write unique ids for this event
+		 */
+		ret = do_write(fd, attr->id, attr->ids * sizeof(u64));
+		if (ret < 0)
+			return ret;
+	}
+	return 0;
+}
+
+static int write_cmdline(int fd, struct perf_header *h __used,
+			 struct perf_evlist *evlist __used)
+{
+	char buf[MAXPATHLEN];
+	char proc[32];
+	u32 i, n;
+	int ret;
+
+	/*
+	 * actual atual path to perf binary
+	 */
+	sprintf(proc, "/proc/%d/exe", getpid());
+	ret = readlink(proc, buf, sizeof(buf));
+	if (ret <= 0)
+		return -1;
+
+	/* readlink() does not add null termination */
+	buf[ret] = '\0';
+
+	/* account for binary path */
+	n = header_argc + 1;
+
+	ret = do_write(fd, &n, sizeof(n));
+	if (ret < 0)
+		return ret;
+
+	ret = do_write_string(fd, buf);
+	if (ret < 0)
+		return ret;
+
+	for (i = 0 ; i < header_argc; i++) {
+		ret = do_write_string(fd, header_argv[i]);
+		if (ret < 0)
+			return ret;
+	}
+	return 0;
+}
+
+#define CORE_SIB_FMT \
+	"/sys/devices/system/cpu/cpu%d/topology/core_siblings_list"
+#define THRD_SIB_FMT \
+	"/sys/devices/system/cpu/cpu%d/topology/thread_siblings_list"
+
+struct cpu_topo {
+	u32 core_sib;
+	u32 thread_sib;
+	char **core_siblings;
+	char **thread_siblings;
+};
+
+static int build_cpu_topo(struct cpu_topo *tp, int cpu)
+{
+	FILE *fp;
+	char filename[MAXPATHLEN];
+	char *buf = NULL, *p;
+	size_t len = 0;
+	u32 i = 0;
+	int ret = -1;
+
+	ret = -1;
+
+	sprintf(filename, CORE_SIB_FMT, cpu);
+	fp = fopen(filename, "r");
+	if (!fp)
+		return -1;
+
+	if (getline(&buf, &len, fp) <= 0) {
+		fclose(fp);
+		return -1;
+	}
+	fclose(fp);
+
+	p = strchr(buf, '\n');
+	if (p)
+		*p = '\0';
+
+	for (i = 0; i < tp->core_sib; i++) {
+		if (!strcmp(buf, tp->core_siblings[i]))
+			break;
+	}
+	if (i == tp->core_sib) {
+		tp->core_siblings[i] = buf;
+		tp->core_sib++;
+	}
+
+	sprintf(filename, THRD_SIB_FMT, cpu);
+	fp = fopen(filename, "r");
+	if (!fp)
+		return -1;
+
+	buf = NULL;
+	len = 0;
+	if (getline(&buf, &len, fp) <= 0) {
+		fclose(fp);
+		return -1;
+	}
+
+	fclose(fp);
+
+	p = strchr(buf, '\n');
+	if (p)
+		*p = '\0';
+
+	for (i = 0; i < tp->thread_sib; i++) {
+		if (!strcmp(buf, tp->thread_siblings[i]))
+			break;
+	}
+	if (i == tp->thread_sib) {
+		tp->thread_siblings[i] = buf;
+		tp->thread_sib++;
+	}
+	return 0;
+}
+
+static void free_cpu_topo(struct cpu_topo *tp)
+{
+	u32 i;
+
+	if (!tp)
+		return;
+
+	for (i = 0 ; i < tp->core_sib; i++)
+		free(tp->core_siblings[i]);
+
+	for (i = 0 ; i < tp->thread_sib; i++)
+		free(tp->thread_siblings[i]);
+
+	free(tp);
+}
+
+static struct cpu_topo *build_cpu_topology(void)
+{
+	struct cpu_topo *tp;
+	void *addr;
+	u32 nr, i;
+	size_t sz;
+	long ncpus;
+	int ret = -1;
+
+	ncpus = sysconf(_SC_NPROCESSORS_CONF);
+	if (ncpus < 0)
+		return NULL;
+
+	nr = (u32)(ncpus & UINT_MAX);
+
+	sz = nr * sizeof(char *);
+
+	addr = malloc(sizeof(*tp) + 2 * sz);
+	if (!addr)
+		return NULL;
+
+	tp = addr;
+
+	tp->core_sib = tp->thread_sib = 0;
+
+	addr += sizeof(*tp);
+	tp->core_siblings = addr;
+	addr += sz;
+	tp->thread_siblings = addr;
+
+	for (i = 0; i < nr; i++) {
+		ret = build_cpu_topo(tp, i);
+		if (ret < 0)
+			break;
+	}
+	if (ret) {
+		free_cpu_topo(tp);
+		tp = NULL;
+	}
+	return tp;
+}
+
+static int write_cpu_topology(int fd, struct perf_header *h __used,
+			  struct perf_evlist *evlist __used)
+{
+	struct cpu_topo *tp;
+	u32 i;
+	int ret;
+
+	tp = build_cpu_topology();
+	if (!tp)
+		return -1;
+
+	ret = do_write(fd, &tp->core_sib, sizeof(tp->core_sib));
+	if (ret < 0)
+		goto done;
+
+	for (i = 0; i < tp->core_sib; i++) {
+		ret = do_write_string(fd, tp->core_siblings[i]);
+		if (ret < 0)
+			goto done;
+	}
+	ret = do_write(fd, &tp->thread_sib, sizeof(tp->thread_sib));
+	if (ret < 0)
+		goto done;
+
+	for (i = 0; i < tp->thread_sib; i++) {
+		ret = do_write_string(fd, tp->thread_siblings[i]);
+		if (ret < 0)
+			break;
+	}
+done:
+	free_cpu_topo(tp);
+	return ret;
+}
+
+
+
+static int write_total_mem(int fd, struct perf_header *h __used,
+			  struct perf_evlist *evlist __used)
+{
+	char *buf = NULL;
+	FILE *fp;
+	size_t len = 0;
+	int ret = -1, n;
+	uint64_t mem;
+
+	fp = fopen("/proc/meminfo", "r");
+	if (!fp)
+		return -1;
+
+	while (getline(&buf, &len, fp) > 0) {
+		ret = strncmp(buf, "MemTotal:", 9);
+		if (!ret)
+			break;
+	}
+	if (!ret) {
+		n = sscanf(buf, "%*s %"PRIu64, &mem);
+		if (n == 1)
+			ret = do_write(fd, &mem, sizeof(mem));
+	}
+	free(buf);
+	fclose(fp);
+	return ret;
+}
+
+static int write_topo_node(int fd, int node)
+{
+	char str[MAXPATHLEN];
+	char field[32];
+	char *buf = NULL, *p;
+	size_t len = 0;
+	FILE *fp;
+	u64 mem_total, mem_free, mem;
+	int ret = -1;
+
+	sprintf(str, "/sys/devices/system/node/node%d/meminfo", node);
+	fp = fopen(str, "r");
+	if (!fp)
+		return -1;
+
+	while (getline(&buf, &len, fp) > 0) {
+		/* skip over invalid lines */
+		if (!strchr(buf, ':'))
+			continue;
+		if (sscanf(buf, "%*s %*d %s %"PRIu64, field, &mem) != 2)
+			goto done;
+		if (!strcmp(field, "MemTotal:"))
+			mem_total = mem;
+		if (!strcmp(field, "MemFree:"))
+			mem_free = mem;
+	}
+
+	fclose(fp);
+
+	ret = do_write(fd, &mem_total, sizeof(u64));
+	if (ret)
+		goto done;
+
+	ret = do_write(fd, &mem_free, sizeof(u64));
+	if (ret)
+		goto done;
+
+	ret = -1;
+	sprintf(str, "/sys/devices/system/node/node%d/cpulist", node);
+
+	fp = fopen(str, "r");
+	if (!fp)
+		goto done;
+
+	if (getline(&buf, &len, fp) <= 0)
+		goto done;
+
+	p = strchr(buf, '\n');
+	if (p)
+		*p = '\0';
+
+	ret = do_write_string(fd, buf);
+done:
+	free(buf);
+	fclose(fp);
+	return ret;
+}
+
+static int write_numa_topology(int fd, struct perf_header *h __used,
+			  struct perf_evlist *evlist __used)
+{
+	char *buf = NULL;
+	size_t len = 0;
+	FILE *fp;
+	struct cpu_map *node_map = NULL;
+	char *c;
+	u32 nr, i, j;
+	int ret = -1;
+
+	fp = fopen("/sys/devices/system/node/online", "r");
+	if (!fp)
+		return -1;
+
+	if (getline(&buf, &len, fp) <= 0)
+		goto done;
+
+	c = strchr(buf, '\n');
+	if (c)
+		*c = '\0';
+
+	node_map = cpu_map__new(buf);
+	if (!node_map)
+		goto done;
+
+	nr = (u32)node_map->nr;
+
+	ret = do_write(fd, &nr, sizeof(nr));
+	if (ret < 0)
+		goto done;
+
+	for (i = 0; i < nr; i++) {
+		j = (u32)node_map->map[i];
+		ret = do_write(fd, &j, sizeof(j));
+		if (ret < 0)
+			break;
+
+		ret = write_topo_node(fd, i);
+		if (ret < 0)
+			break;
+	}
+done:
+	free(buf);
+	fclose(fp);
+	free(node_map);
+	return ret;
+}
+
+/*
+ * default get_cpuid(): nothing gets recorded
+ * actual implementation must be in arch/$(ARCH)/util/header.c
+ */
+int __attribute__((weak)) get_cpuid(char *buffer __used, size_t sz __used)
+{
+	return -1;
+}
+
+static int write_cpuid(int fd, struct perf_header *h __used,
+		       struct perf_evlist *evlist __used)
+{
+	char buffer[64];
+	int ret;
+
+	ret = get_cpuid(buffer, sizeof(buffer));
+	if (!ret)
+		goto write_it;
+
+	return -1;
+write_it:
+	return do_write_string(fd, buffer);
+}
+
+static void print_hostname(struct perf_header *ph, int fd, FILE *fp)
+{
+	char *str = do_read_string(fd, ph);
+	fprintf(fp, "# hostname : %s\n", str);
+	free(str);
+}
+
+static void print_osrelease(struct perf_header *ph, int fd, FILE *fp)
+{
+	char *str = do_read_string(fd, ph);
+	fprintf(fp, "# os release : %s\n", str);
+	free(str);
+}
+
+static void print_arch(struct perf_header *ph, int fd, FILE *fp)
+{
+	char *str = do_read_string(fd, ph);
+	fprintf(fp, "# arch : %s\n", str);
+	free(str);
+}
+
+static void print_cpudesc(struct perf_header *ph, int fd, FILE *fp)
+{
+	char *str = do_read_string(fd, ph);
+	fprintf(fp, "# cpudesc : %s\n", str);
+	free(str);
+}
+
+static void print_nrcpus(struct perf_header *ph, int fd, FILE *fp)
+{
+	ssize_t ret;
+	u32 nr;
+
+	ret = read(fd, &nr, sizeof(nr));
+	if (ret != (ssize_t)sizeof(nr))
+		nr = -1; /* interpreted as error */
+
+	if (ph->needs_swap)
+		nr = bswap_32(nr);
+
+	fprintf(fp, "# nrcpus online : %u\n", nr);
+
+	ret = read(fd, &nr, sizeof(nr));
+	if (ret != (ssize_t)sizeof(nr))
+		nr = -1; /* interpreted as error */
+
+	if (ph->needs_swap)
+		nr = bswap_32(nr);
+
+	fprintf(fp, "# nrcpus avail : %u\n", nr);
+}
+
+static void print_version(struct perf_header *ph, int fd, FILE *fp)
+{
+	char *str = do_read_string(fd, ph);
+	fprintf(fp, "# perf version : %s\n", str);
+	free(str);
+}
+
+static void print_cmdline(struct perf_header *ph, int fd, FILE *fp)
+{
+	ssize_t ret;
+	char *str;
+	u32 nr, i;
+
+	ret = read(fd, &nr, sizeof(nr));
+	if (ret != (ssize_t)sizeof(nr))
+		return;
+
+	if (ph->needs_swap)
+		nr = bswap_32(nr);
+
+	fprintf(fp, "# cmdline : ");
+
+	for (i = 0; i < nr; i++) {
+		str = do_read_string(fd, ph);
+		fprintf(fp, "%s ", str);
+		free(str);
+	}
+	fputc('\n', fp);
+}
+
+static void print_cpu_topology(struct perf_header *ph, int fd, FILE *fp)
+{
+	ssize_t ret;
+	u32 nr, i;
+	char *str;
+
+	ret = read(fd, &nr, sizeof(nr));
+	if (ret != (ssize_t)sizeof(nr))
+		return;
+
+	if (ph->needs_swap)
+		nr = bswap_32(nr);
+
+	for (i = 0; i < nr; i++) {
+		str = do_read_string(fd, ph);
+		fprintf(fp, "# sibling cores   : %s\n", str);
+		free(str);
+	}
+
+	ret = read(fd, &nr, sizeof(nr));
+	if (ret != (ssize_t)sizeof(nr))
+		return;
+
+	if (ph->needs_swap)
+		nr = bswap_32(nr);
+
+	for (i = 0; i < nr; i++) {
+		str = do_read_string(fd, ph);
+		fprintf(fp, "# sibling threads : %s\n", str);
+		free(str);
+	}
+}
+
+static void print_event_desc(struct perf_header *ph, int fd, FILE *fp)
+{
+	struct perf_event_attr attr;
+	uint64_t id;
+	void *buf = NULL;
+	char *str;
+	u32 nre, sz, nr, i, j, msz;
+	int ret;
+
+	/* number of events */
+	ret = read(fd, &nre, sizeof(nre));
+	if (ret != (ssize_t)sizeof(nre))
+		goto error;
+
+	if (ph->needs_swap)
+		nre = bswap_32(nre);
+
+	ret = read(fd, &sz, sizeof(sz));
+	if (ret != (ssize_t)sizeof(sz))
+		goto error;
+
+	if (ph->needs_swap)
+		sz = bswap_32(sz);
+
+	/*
+	 * ensure it is at least to our ABI rev
+	 */
+	if (sz < (u32)sizeof(attr))
+		goto error;
+
+	memset(&attr, 0, sizeof(attr));
+
+	/* read entire region to sync up to next field */
+	buf = malloc(sz);
+	if (!buf)
+		goto error;
+
+	msz = sizeof(attr);
+	if (sz < msz)
+		msz = sz;
+
+	for (i = 0 ; i < nre; i++) {
+
+		ret = read(fd, buf, sz);
+		if (ret != (ssize_t)sz)
+			goto error;
+
+		if (ph->needs_swap)
+			perf_event__attr_swap(buf);
+
+		memcpy(&attr, buf, msz);
+
+		ret = read(fd, &nr, sizeof(nr));
+		if (ret != (ssize_t)sizeof(nr))
+			goto error;
+
+		if (ph->needs_swap)
+			nr = bswap_32(nr);
+
+		str = do_read_string(fd, ph);
+		fprintf(fp, "# event : name = %s, ", str);
+		free(str);
+
+		fprintf(fp, "type = %d, config = 0x%"PRIx64
+			    ", config1 = 0x%"PRIx64", config2 = 0x%"PRIx64,
+				attr.type,
+				(u64)attr.config,
+				(u64)attr.config1,
+				(u64)attr.config2);
+
+		fprintf(fp, ", excl_usr = %d, excl_kern = %d",
+				attr.exclude_user,
+				attr.exclude_kernel);
+
+		if (nr)
+			fprintf(fp, ", id = {");
+
+		for (j = 0 ; j < nr; j++) {
+			ret = read(fd, &id, sizeof(id));
+			if (ret != (ssize_t)sizeof(id))
+				goto error;
+
+			if (ph->needs_swap)
+				id = bswap_64(id);
+
+			if (j)
+				fputc(',', fp);
+
+			fprintf(fp, " %"PRIu64, id);
+		}
+		if (nr && j == nr)
+			fprintf(fp, " }");
+		fputc('\n', fp);
+	}
+	free(buf);
+	return;
+error:
+	fprintf(fp, "# event desc: not available or unable to read\n");
+}
+
+static void print_total_mem(struct perf_header *h __used, int fd, FILE *fp)
+{
+	uint64_t mem;
+	ssize_t ret;
+
+	ret = read(fd, &mem, sizeof(mem));
+	if (ret != sizeof(mem))
+		goto error;
+
+	if (h->needs_swap)
+		mem = bswap_64(mem);
+
+	fprintf(fp, "# total memory : %"PRIu64" kB\n", mem);
+	return;
+error:
+	fprintf(fp, "# total memory : unknown\n");
+}
+
+static void print_numa_topology(struct perf_header *h __used, int fd, FILE *fp)
+{
+	ssize_t ret;
+	u32 nr, c, i;
+	char *str;
+	uint64_t mem_total, mem_free;
+
+	/* nr nodes */
+	ret = read(fd, &nr, sizeof(nr));
+	if (ret != (ssize_t)sizeof(nr))
+		goto error;
+
+	if (h->needs_swap)
+		nr = bswap_32(nr);
+
+	for (i = 0; i < nr; i++) {
+
+		/* node number */
+		ret = read(fd, &c, sizeof(c));
+		if (ret != (ssize_t)sizeof(c))
+			goto error;
+
+		if (h->needs_swap)
+			c = bswap_32(c);
+
+		ret = read(fd, &mem_total, sizeof(u64));
+		if (ret != sizeof(u64))
+			goto error;
+
+		ret = read(fd, &mem_free, sizeof(u64));
+		if (ret != sizeof(u64))
+			goto error;
+
+		if (h->needs_swap) {
+			mem_total = bswap_64(mem_total);
+			mem_free = bswap_64(mem_free);
+		}
+
+		fprintf(fp, "# node%u meminfo  : total = %"PRIu64" kB,"
+			    " free = %"PRIu64" kB\n",
+			c,
+			mem_total,
+			mem_free);
+
+		str = do_read_string(fd, h);
+		fprintf(fp, "# node%u cpu list : %s\n", c, str);
+		free(str);
+	}
+	return;
+error:
+	fprintf(fp, "# numa topology : not available\n");
+}
+
+static void print_cpuid(struct perf_header *ph, int fd, FILE *fp)
+{
+	char *str = do_read_string(fd, ph);
+	fprintf(fp, "# cpuid : %s\n", str);
+	free(str);
+}
+
+struct feature_ops {
+	int (*write)(int fd, struct perf_header *h, struct perf_evlist *evlist);
+	void (*print)(struct perf_header *h, int fd, FILE *fp);
+	const char *name;
+	bool full_only;
+};
+
+#define FEAT_OPA(n, w, p) \
+	[n] = { .name = #n, .write = w, .print = p }
+#define FEAT_OPF(n, w, p) \
+	[n] = { .name = #n, .write = w, .print = p, .full_only = true }
+
+static const struct feature_ops feat_ops[HEADER_LAST_FEATURE] = {
+	FEAT_OPA(HEADER_TRACE_INFO, write_trace_info, NULL),
+	FEAT_OPA(HEADER_BUILD_ID, write_build_id, NULL),
+	FEAT_OPA(HEADER_HOSTNAME, write_hostname, print_hostname),
+	FEAT_OPA(HEADER_OSRELEASE, write_osrelease, print_osrelease),
+	FEAT_OPA(HEADER_VERSION, write_version, print_version),
+	FEAT_OPA(HEADER_ARCH, write_arch, print_arch),
+	FEAT_OPA(HEADER_NRCPUS, write_nrcpus, print_nrcpus),
+	FEAT_OPA(HEADER_CPUDESC, write_cpudesc, print_cpudesc),
+	FEAT_OPA(HEADER_CPUID, write_cpuid, print_cpuid),
+	FEAT_OPA(HEADER_TOTAL_MEM, write_total_mem, print_total_mem),
+	FEAT_OPA(HEADER_EVENT_DESC, write_event_desc, print_event_desc),
+	FEAT_OPA(HEADER_CMDLINE, write_cmdline, print_cmdline),
+	FEAT_OPF(HEADER_CPU_TOPOLOGY, write_cpu_topology, print_cpu_topology),
+	FEAT_OPF(HEADER_NUMA_TOPOLOGY, write_numa_topology, print_numa_topology),
+};
+
+struct header_print_data {
+	FILE *fp;
+	bool full; /* extended list of headers */
+};
+
+static int perf_header_fprintf_info(struct perf_file_section *section,
+				    struct perf_header *ph,
+				    int feat, int fd, void *data)
+{
+	struct header_print_data *hd = data;
+
+	if (lseek(fd, section->offset, SEEK_SET) == (off_t)-1) {
+		pr_debug("Failed to lseek to %" PRIu64 " offset for feature "
+				"%d, continuing...\n", section->offset, feat);
+		return 0;
+	}
+	if (feat < HEADER_TRACE_INFO || feat >= HEADER_LAST_FEATURE) {
+		pr_warning("unknown feature %d\n", feat);
+		return -1;
+	}
+	if (!feat_ops[feat].print)
+		return 0;
+
+	if (!feat_ops[feat].full_only || hd->full)
+		feat_ops[feat].print(ph, fd, hd->fp);
+	else
+		fprintf(hd->fp, "# %s info available, use -I to display\n",
+			feat_ops[feat].name);
+
+	return 0;
+}
+
+int perf_header__fprintf_info(struct perf_session *session, FILE *fp, bool full)
+{
+	struct header_print_data hd;
+	struct perf_header *header = &session->header;
+	int fd = session->fd;
+	hd.fp = fp;
+	hd.full = full;
+
+	perf_header__process_sections(header, fd, &hd,
+				      perf_header_fprintf_info);
+	return 0;
+}
+
 #define dsos__for_each_with_build_id(pos, head)	\
 	list_for_each_entry(pos, head, node)	\
 		if (!pos->has_build_id)		\
@@ -356,15 +1379,41 @@ static bool perf_session__read_build_ids(struct perf_session *session, bool with
 	return ret;
 }
 
+static int do_write_feat(int fd, struct perf_header *h, int type,
+			 struct perf_file_section **p,
+			 struct perf_evlist *evlist)
+{
+	int err;
+	int ret = 0;
+
+	if (perf_header__has_feat(h, type)) {
+
+		(*p)->offset = lseek(fd, 0, SEEK_CUR);
+
+		err = feat_ops[type].write(fd, h, evlist);
+		if (err < 0) {
+			pr_debug("failed to write feature %d\n", type);
+
+			/* undo anything written */
+			lseek(fd, (*p)->offset, SEEK_SET);
+
+			return -1;
+		}
+		(*p)->size = lseek(fd, 0, SEEK_CUR) - (*p)->offset;
+		(*p)++;
+	}
+	return ret;
+}
+
 static int perf_header__adds_write(struct perf_header *header,
 				   struct perf_evlist *evlist, int fd)
 {
 	int nr_sections;
 	struct perf_session *session;
-	struct perf_file_section *feat_sec;
+	struct perf_file_section *feat_sec, *p;
 	int sec_size;
 	u64 sec_start;
-	int idx = 0, err;
+	int err;
 
 	session = container_of(header, struct perf_session, header);
 
@@ -376,7 +1425,7 @@ static int perf_header__adds_write(struct perf_header *header,
 	if (!nr_sections)
 		return 0;
 
-	feat_sec = calloc(sizeof(*feat_sec), nr_sections);
+	feat_sec = p = calloc(sizeof(*feat_sec), nr_sections);
 	if (feat_sec == NULL)
 		return -ENOMEM;
 
@@ -385,36 +1434,69 @@ static int perf_header__adds_write(struct perf_header *header,
 	sec_start = header->data_offset + header->data_size;
 	lseek(fd, sec_start + sec_size, SEEK_SET);
 
-	if (perf_header__has_feat(header, HEADER_TRACE_INFO)) {
-		struct perf_file_section *trace_sec;
-
-		trace_sec = &feat_sec[idx++];
+	err = do_write_feat(fd, header, HEADER_TRACE_INFO, &p, evlist);
+	if (err)
+		goto out_free;
 
-		/* Write trace info */
-		trace_sec->offset = lseek(fd, 0, SEEK_CUR);
-		read_tracing_data(fd, &evlist->entries);
-		trace_sec->size = lseek(fd, 0, SEEK_CUR) - trace_sec->offset;
+	err = do_write_feat(fd, header, HEADER_BUILD_ID, &p, evlist);
+	if (err) {
+		perf_header__clear_feat(header, HEADER_BUILD_ID);
+		goto out_free;
 	}
 
-	if (perf_header__has_feat(header, HEADER_BUILD_ID)) {
-		struct perf_file_section *buildid_sec;
+	err = do_write_feat(fd, header, HEADER_HOSTNAME, &p, evlist);
+	if (err)
+		perf_header__clear_feat(header, HEADER_HOSTNAME);
 
-		buildid_sec = &feat_sec[idx++];
+	err = do_write_feat(fd, header, HEADER_OSRELEASE, &p, evlist);
+	if (err)
+		perf_header__clear_feat(header, HEADER_OSRELEASE);
 
-		/* Write build-ids */
-		buildid_sec->offset = lseek(fd, 0, SEEK_CUR);
-		err = dsos__write_buildid_table(header, fd);
-		if (err < 0) {
-			pr_debug("failed to write buildid table\n");
-			goto out_free;
-		}
-		buildid_sec->size = lseek(fd, 0, SEEK_CUR) -
-					  buildid_sec->offset;
-		if (!no_buildid_cache)
-			perf_session__cache_build_ids(session);
-	}
+	err = do_write_feat(fd, header, HEADER_VERSION, &p, evlist);
+	if (err)
+		perf_header__clear_feat(header, HEADER_VERSION);
+
+	err = do_write_feat(fd, header, HEADER_ARCH, &p, evlist);
+	if (err)
+		perf_header__clear_feat(header, HEADER_ARCH);
+
+	err = do_write_feat(fd, header, HEADER_NRCPUS, &p, evlist);
+	if (err)
+		perf_header__clear_feat(header, HEADER_NRCPUS);
+
+	err = do_write_feat(fd, header, HEADER_CPUDESC, &p, evlist);
+	if (err)
+		perf_header__clear_feat(header, HEADER_CPUDESC);
+
+	err = do_write_feat(fd, header, HEADER_CPUID, &p, evlist);
+	if (err)
+		perf_header__clear_feat(header, HEADER_CPUID);
+
+	err = do_write_feat(fd, header, HEADER_TOTAL_MEM, &p, evlist);
+	if (err)
+		perf_header__clear_feat(header, HEADER_TOTAL_MEM);
+
+	err = do_write_feat(fd, header, HEADER_CMDLINE, &p, evlist);
+	if (err)
+		perf_header__clear_feat(header, HEADER_CMDLINE);
+
+	err = do_write_feat(fd, header, HEADER_EVENT_DESC, &p, evlist);
+	if (err)
+		perf_header__clear_feat(header, HEADER_EVENT_DESC);
+
+	err = do_write_feat(fd, header, HEADER_CPU_TOPOLOGY, &p, evlist);
+	if (err)
+		perf_header__clear_feat(header, HEADER_CPU_TOPOLOGY);
+
+	err = do_write_feat(fd, header, HEADER_NUMA_TOPOLOGY, &p, evlist);
+	if (err)
+		perf_header__clear_feat(header, HEADER_NUMA_TOPOLOGY);
 
 	lseek(fd, sec_start, SEEK_SET);
+	/*
+	 * may write more than needed due to dropped feature, but
+	 * this is okay, reader will skip the mising entries
+	 */
 	err = do_write(fd, feat_sec, sec_size);
 	if (err < 0)
 		pr_debug("failed to write feature section\n");
@@ -554,9 +1636,10 @@ static int perf_header__getbuffer64(struct perf_header *header,
 }
 
 int perf_header__process_sections(struct perf_header *header, int fd,
+				  void *data,
 				  int (*process)(struct perf_file_section *section,
-						 struct perf_header *ph,
-						 int feat, int fd))
+				  struct perf_header *ph,
+				  int feat, int fd, void *data))
 {
 	struct perf_file_section *feat_sec;
 	int nr_sections;
@@ -584,7 +1667,7 @@ int perf_header__process_sections(struct perf_header *header, int fd,
 		if (perf_header__has_feat(header, feat)) {
 			struct perf_file_section *sec = &feat_sec[idx++];
 
-			err = process(sec, header, feat, fd);
+			err = process(sec, header, feat, fd, data);
 			if (err < 0)
 				break;
 		}
@@ -796,7 +1879,7 @@ out:
 
 static int perf_file_section__process(struct perf_file_section *section,
 				      struct perf_header *ph,
-				      int feat, int fd)
+				      int feat, int fd, void *data __used)
 {
 	if (lseek(fd, section->offset, SEEK_SET) == (off_t)-1) {
 		pr_debug("Failed to lseek to %" PRIu64 " offset for feature "
@@ -935,7 +2018,8 @@ int perf_session__read_header(struct perf_session *session, int fd)
 		event_count =  f_header.event_types.size / sizeof(struct perf_trace_event_type);
 	}
 
-	perf_header__process_sections(header, fd, perf_file_section__process);
+	perf_header__process_sections(header, fd, NULL,
+				      perf_file_section__process);
 
 	lseek(fd, header->data_offset, SEEK_SET);
 
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 1886256..3d5a742 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -12,6 +12,20 @@
 enum {
 	HEADER_TRACE_INFO = 1,
 	HEADER_BUILD_ID,
+
+	HEADER_HOSTNAME,
+	HEADER_OSRELEASE,
+	HEADER_VERSION,
+	HEADER_ARCH,
+	HEADER_NRCPUS,
+	HEADER_CPUDESC,
+	HEADER_CPUID,
+	HEADER_TOTAL_MEM,
+	HEADER_CMDLINE,
+	HEADER_EVENT_DESC,
+	HEADER_CPU_TOPOLOGY,
+	HEADER_NUMA_TOPOLOGY,
+
 	HEADER_LAST_FEATURE,
 };
 
@@ -68,10 +82,15 @@ void perf_header__set_feat(struct perf_header *header, int feat);
 void perf_header__clear_feat(struct perf_header *header, int feat);
 bool perf_header__has_feat(const struct perf_header *header, int feat);
 
+int perf_header__set_cmdline(int argc, const char **argv);
+
 int perf_header__process_sections(struct perf_header *header, int fd,
+				  void *data,
 				  int (*process)(struct perf_file_section *section,
-						 struct perf_header *ph,
-						 int feat, int fd));
+				  struct perf_header *ph,
+				  int feat, int fd, void *data));
+
+int perf_header__fprintf_info(struct perf_session *s, FILE *fp, bool full);
 
 int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
 			  const char *name, bool is_kallsyms);
@@ -104,4 +123,10 @@ int perf_event__synthesize_build_id(struct dso *pos, u16 misc,
 				    struct perf_session *session);
 int perf_event__process_build_id(union perf_event *event,
 				 struct perf_session *session);
+
+/*
+ * arch specific callback
+ */
+int get_cpuid(char *buffer, size_t sz);
+
 #endif /* __PERF_HEADER_H */
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 72458d9..a00cbdf 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1326,3 +1326,22 @@ int perf_session__cpu_bitmap(struct perf_session *session,
 
 	return 0;
 }
+
+void perf_session__fprintf_info(struct perf_session *session, FILE *fp,
+				bool full)
+{
+	struct stat st;
+	int ret;
+
+	if (session == NULL || fp == NULL)
+		return;
+
+	ret = fstat(session->fd, &st);
+	if (ret == -1)
+		return;
+
+	fprintf(fp, "# ========\n");
+	fprintf(fp, "# captured on : %s", ctime(&st.st_ctime));
+	perf_header__fprintf_info(session, fp, full);
+	fprintf(fp, "# ========\n#\n");
+}
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 170601e..054a187 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -176,4 +176,5 @@ void perf_session__print_ip(union perf_event *event,
 int perf_session__cpu_bitmap(struct perf_session *session,
 			     const char *cpu_list, unsigned long *cpu_bitmap);
 
+void perf_session__fprintf_info(struct perf_session *s, FILE *fp, bool full);
 #endif /* __PERF_SESSION_H */

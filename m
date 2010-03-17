Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab0CQJYq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 05:24:46 -0400
Received: from mga06.intel.com ([134.134.136.21]:57195 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753445Ab0CQJYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 05:24:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,656,1262592000"; 
   d="scan'208";a="501309944"
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
 host side
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       zhiteng.huang@intel.com
In-Reply-To: <20100316094758.GH7961@elte.hu>
References: <1268717232.2813.36.camel@localhost>
	 <4B9F19F7.6000309@redhat.com> <1268725724.2813.48.camel@localhost>
	 <1268731733.2813.54.camel@localhost>  <20100316094758.GH7961@elte.hu>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 17 Mar 2010 17:26:53 +0800
Message-Id: <1268818013.2813.82.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-16 at 10:47 +0100, Ingo Molnar wrote:
> * Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> 
> > On Tue, 2010-03-16 at 15:48 +0800, Zhang, Yanmin wrote:
> > > On Tue, 2010-03-16 at 07:41 +0200, Avi Kivity wrote:
> > > > On 03/16/2010 07:27 AM, Zhang, Yanmin wrote:
> > > > > From: Zhang, Yanmin<yanmin_zhang@linux.intel.com>
> > > > >
> > > > > Based on the discussion in KVM community, I worked out the patch to support
> > > > > perf to collect guest os statistics from host side. This patch is implemented
> > > > > with Ingo, Peter and some other guys' kind help. Yang Sheng pointed out a
> > > > > critical bug and provided good suggestions with other guys. I really appreciate
> > > > > their kind help.
> > > > >
> > > > > The patch adds new subcommand kvm to perf.
> > > > >
> > > > >    perf kvm top
> > > > >    perf kvm record
> > > > >    perf kvm report
> > > > >    perf kvm diff
> > > > >
> > > > > The new perf could profile guest os kernel except guest os user space, but it
> > > > > could summarize guest os user space utilization per guest os.
> > > > >
> > > > > Below are some examples.
> > > > > 1) perf kvm top
> > > > > [root@lkp-ne01 norm]# perf kvm --host --guest --guestkallsyms=/home/ymzhang/guest/kallsyms
> > > > > --guestmodules=/home/ymzhang/guest/modules top
> > > > >
> > > > >    
> > > > 
> > > Thanks for your kind comments.
> > > 
> > > > Excellent, support for guest kernel != host kernel is critical (I can't 
> > > > remember the last time I ran same kernels).
> > > > 
> > > > How would we support multiple guests with different kernels?
> > > With the patch, 'perf kvm report --sort pid" could show
> > > summary statistics for all guest os instances. Then, use
> > > parameter --pid of 'perf kvm record' to collect single problematic instance data.
> > Sorry. I found currently --pid isn't process but a thread (main thread).
> > 
> > Ingo,
> > 
> > Is it possible to support a new parameter or extend --inherit, so 'perf 
> > record' and 'perf top' could collect data on all threads of a process when 
> > the process is running?
> > 
> > If not, I need add a new ugly parameter which is similar to --pid to filter 
> > out process data in userspace.
> 
> Yeah. For maximum utility i'd suggest to extend --pid to include this, and 
> introduce --tid for the previous, limited-to-a-single-task functionality.
> 
> Most users would expect --pid to work like a 'late attach' - i.e. to work like 
> strace -f or like a gdb attach.

Thanks Ingo, Avi.

I worked out below patch against tip/master of March 15th.

Subject: [PATCH] Change perf's parameter --pid to process-wide collection
From: Zhang, Yanmin <yanmin_zhang@linux.intel.com>

Change parameter -p (--pid) to real process pid and add -t (--tid) meaning
thread id. Now, --pid means perf collects the statistics of all threads of
the process, while --tid means perf just collect the statistics of that thread.

BTW, the patch fixes a bug of 'perf stat -p'. 'perf stat' always configures
attr->disabled=1 if it isn't a system-wide collection. If there is a '-p'
and no forks, 'perf stat -p' doesn't collect any data. In addition, the
while(!done) in run_perf_stat consumes 100% single cpu time which has bad impact
on running workload. I added a sleep(1) in the loop.

Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>

---

diff -Nraup linux-2.6_tipmaster0315/tools/perf/builtin-record.c linux-2.6_tipmaster0315_perfpid/tools/perf/builtin-record.c
--- linux-2.6_tipmaster0315/tools/perf/builtin-record.c	2010-03-16 08:59:54.896488489 +0800
+++ linux-2.6_tipmaster0315_perfpid/tools/perf/builtin-record.c	2010-03-17 16:30:17.755551706 +0800
@@ -27,7 +27,7 @@
 #include <unistd.h>
 #include <sched.h>
 
-static int			fd[MAX_NR_CPUS][MAX_COUNTERS];
+static int			*fd[MAX_NR_CPUS][MAX_COUNTERS];
 
 static long			default_interval		=      0;
 
@@ -43,6 +43,9 @@ static int			raw_samples			=      0;
 static int			system_wide			=      0;
 static int			profile_cpu			=     -1;
 static pid_t			target_pid			=     -1;
+static pid_t			target_tid			=     -1;
+static int			*all_tids			=      NULL;
+static int			thread_num			=      0;
 static pid_t			child_pid			=     -1;
 static int			inherit				=      1;
 static int			force				=      0;
@@ -60,7 +63,7 @@ static struct timeval		this_read;
 
 static u64			bytes_written			=      0;
 
-static struct pollfd		event_array[MAX_NR_CPUS * MAX_COUNTERS];
+static struct pollfd		*event_array;
 
 static int			nr_poll				=      0;
 static int			nr_cpu				=      0;
@@ -77,7 +80,7 @@ struct mmap_data {
 	unsigned int		prev;
 };
 
-static struct mmap_data		mmap_array[MAX_NR_CPUS][MAX_COUNTERS];
+static struct mmap_data		*mmap_array[MAX_NR_CPUS][MAX_COUNTERS];
 
 static unsigned long mmap_read_head(struct mmap_data *md)
 {
@@ -225,11 +228,12 @@ static struct perf_header_attr *get_head
 	return h_attr;
 }
 
-static void create_counter(int counter, int cpu, pid_t pid, bool forks)
+static void create_counter(int counter, int cpu, bool forks)
 {
 	char *filter = filters[counter];
 	struct perf_event_attr *attr = attrs + counter;
 	struct perf_header_attr *h_attr;
+	int thread_index;
 	int track = !counter; /* only the first counter needs these */
 	int ret;
 	struct {
@@ -280,117 +284,124 @@ static void create_counter(int counter, 
 	if (forks)
 		attr->enable_on_exec = 1;
 
+	for (thread_index = 0; thread_index < thread_num; thread_index++) {
 try_again:
-	fd[nr_cpu][counter] = sys_perf_event_open(attr, pid, cpu, group_fd, 0);
+		fd[nr_cpu][counter][thread_index] = sys_perf_event_open(attr,
+				all_tids[thread_index], cpu, group_fd, 0);
 
-	if (fd[nr_cpu][counter] < 0) {
-		int err = errno;
+		if (fd[nr_cpu][counter][thread_index] < 0) {
+			int err = errno;
 
-		if (err == EPERM || err == EACCES)
-			die("Permission error - are you root?\n"
-			    "\t Consider tweaking /proc/sys/kernel/perf_event_paranoid.\n");
-		else if (err ==  ENODEV && profile_cpu != -1)
-			die("No such device - did you specify an out-of-range profile CPU?\n");
+			if (err == EPERM || err == EACCES)
+				die("Permission error - are you root?\n"
+						"\t Consider tweaking /proc/sys/kernel/perf_event_paranoid.\n");
+			else if (err ==  ENODEV && profile_cpu != -1)
+				die("No such device - did you specify an out-of-range profile CPU?\n");
 
-		/*
-		 * If it's cycles then fall back to hrtimer
-		 * based cpu-clock-tick sw counter, which
-		 * is always available even if no PMU support:
-		 */
-		if (attr->type == PERF_TYPE_HARDWARE
-			&& attr->config == PERF_COUNT_HW_CPU_CYCLES) {
+			/*
+			 * If it's cycles then fall back to hrtimer
+			 * based cpu-clock-tick sw counter, which
+			 * is always available even if no PMU support:
+			 */
+			if (attr->type == PERF_TYPE_HARDWARE
+					&& attr->config == PERF_COUNT_HW_CPU_CYCLES) {
 
-			if (verbose)
-				warning(" ... trying to fall back to cpu-clock-ticks\n");
-			attr->type = PERF_TYPE_SOFTWARE;
-			attr->config = PERF_COUNT_SW_CPU_CLOCK;
-			goto try_again;
-		}
-		printf("\n");
-		error("perfcounter syscall returned with %d (%s)\n",
-			fd[nr_cpu][counter], strerror(err));
+				if (verbose)
+					warning(" ... trying to fall back to cpu-clock-ticks\n");
+				attr->type = PERF_TYPE_SOFTWARE;
+				attr->config = PERF_COUNT_SW_CPU_CLOCK;
+				goto try_again;
+			}
+			printf("\n");
+			error("perfcounter syscall returned with %d (%s)\n",
+				fd[nr_cpu][counter][thread_index],
+				strerror(err));
 
 #if defined(__i386__) || defined(__x86_64__)
-		if (attr->type == PERF_TYPE_HARDWARE && err == EOPNOTSUPP)
-			die("No hardware sampling interrupt available. No APIC? If so then you can boot the kernel with the \"lapic\" boot parameter to force-enable it.\n");
+			if (attr->type == PERF_TYPE_HARDWARE && err == EOPNOTSUPP)
+				die("No hardware sampling interrupt available. No APIC? If so then you can boot the kernel with the \"lapic\" boot parameter to force-enable it.\n");
 #endif
 
-		die("No CONFIG_PERF_EVENTS=y kernel support configured?\n");
-		exit(-1);
-	}
+			die("No CONFIG_PERF_EVENTS=y kernel support configured?\n");
+			exit(-1);
+		}
 
-	h_attr = get_header_attr(attr, counter);
-	if (h_attr == NULL)
-		die("nomem\n");
+		h_attr = get_header_attr(attr, counter);
+		if (h_attr == NULL)
+			die("nomem\n");
+
+		if (!file_new) {
+			if (memcmp(&h_attr->attr, attr, sizeof(*attr))) {
+				fprintf(stderr, "incompatible append\n");
+				exit(-1);
+			}
+		}
 
-	if (!file_new) {
-		if (memcmp(&h_attr->attr, attr, sizeof(*attr))) {
-			fprintf(stderr, "incompatible append\n");
+		if (read(fd[nr_cpu][counter][thread_index], &read_data, sizeof(read_data)) == -1) {
+			perror("Unable to read perf file descriptor\n");
 			exit(-1);
 		}
-	}
-
-	if (read(fd[nr_cpu][counter], &read_data, sizeof(read_data)) == -1) {
-		perror("Unable to read perf file descriptor\n");
-		exit(-1);
-	}
 
-	if (perf_header_attr__add_id(h_attr, read_data.id) < 0) {
-		pr_warning("Not enough memory to add id\n");
-		exit(-1);
-	}
+		if (perf_header_attr__add_id(h_attr, read_data.id) < 0) {
+			pr_warning("Not enough memory to add id\n");
+			exit(-1);
+		}
 
-	assert(fd[nr_cpu][counter] >= 0);
-	fcntl(fd[nr_cpu][counter], F_SETFL, O_NONBLOCK);
+		assert(fd[nr_cpu][counter][thread_index] >= 0);
+		fcntl(fd[nr_cpu][counter][thread_index], F_SETFL, O_NONBLOCK);
 
-	/*
-	 * First counter acts as the group leader:
-	 */
-	if (group && group_fd == -1)
-		group_fd = fd[nr_cpu][counter];
-	if (multiplex && multiplex_fd == -1)
-		multiplex_fd = fd[nr_cpu][counter];
+		/*
+		 * First counter acts as the group leader:
+		 */
+		if (group && group_fd == -1)
+			group_fd = fd[nr_cpu][counter][thread_index];
+		if (multiplex && multiplex_fd == -1)
+			multiplex_fd = fd[nr_cpu][counter][thread_index];
 
-	if (multiplex && fd[nr_cpu][counter] != multiplex_fd) {
+		if (multiplex && fd[nr_cpu][counter][thread_index] != multiplex_fd) {
 
-		ret = ioctl(fd[nr_cpu][counter], PERF_EVENT_IOC_SET_OUTPUT, multiplex_fd);
-		assert(ret != -1);
-	} else {
-		event_array[nr_poll].fd = fd[nr_cpu][counter];
-		event_array[nr_poll].events = POLLIN;
-		nr_poll++;
-
-		mmap_array[nr_cpu][counter].counter = counter;
-		mmap_array[nr_cpu][counter].prev = 0;
-		mmap_array[nr_cpu][counter].mask = mmap_pages*page_size - 1;
-		mmap_array[nr_cpu][counter].base = mmap(NULL, (mmap_pages+1)*page_size,
-				PROT_READ|PROT_WRITE, MAP_SHARED, fd[nr_cpu][counter], 0);
-		if (mmap_array[nr_cpu][counter].base == MAP_FAILED) {
-			error("failed to mmap with %d (%s)\n", errno, strerror(errno));
-			exit(-1);
+			ret = ioctl(fd[nr_cpu][counter][thread_index], PERF_EVENT_IOC_SET_OUTPUT, multiplex_fd);
+			assert(ret != -1);
+		} else {
+			event_array[nr_poll].fd = fd[nr_cpu][counter][thread_index];
+			event_array[nr_poll].events = POLLIN;
+			nr_poll++;
+
+			mmap_array[nr_cpu][counter][thread_index].counter = counter;
+			mmap_array[nr_cpu][counter][thread_index].prev = 0;
+			mmap_array[nr_cpu][counter][thread_index].mask = mmap_pages*page_size - 1;
+			mmap_array[nr_cpu][counter][thread_index].base = mmap(NULL,
+							(mmap_pages+1)*page_size,
+							PROT_READ|PROT_WRITE, MAP_SHARED,
+							fd[nr_cpu][counter][thread_index],
+							0);
+			if (mmap_array[nr_cpu][counter][thread_index].base == MAP_FAILED) {
+				error("failed to mmap with %d (%s)\n", errno, strerror(errno));
+				exit(-1);
+			}
 		}
-	}
 
-	if (filter != NULL) {
-		ret = ioctl(fd[nr_cpu][counter],
-			    PERF_EVENT_IOC_SET_FILTER, filter);
-		if (ret) {
-			error("failed to set filter with %d (%s)\n", errno,
-			      strerror(errno));
-			exit(-1);
+		if (filter != NULL) {
+			ret = ioctl(fd[nr_cpu][counter][thread_index],
+					PERF_EVENT_IOC_SET_FILTER, filter);
+			if (ret) {
+				error("failed to set filter with %d (%s)\n", errno,
+						strerror(errno));
+				exit(-1);
+			}
 		}
-	}
 
-	ioctl(fd[nr_cpu][counter], PERF_EVENT_IOC_ENABLE);
+		ioctl(fd[nr_cpu][counter][thread_index], PERF_EVENT_IOC_ENABLE);
+	}
 }
 
-static void open_counters(int cpu, pid_t pid, bool forks)
+static void open_counters(int cpu, bool forks)
 {
 	int counter;
 
 	group_fd = -1;
 	for (counter = 0; counter < nr_counters; counter++)
-		create_counter(counter, cpu, pid, forks);
+		create_counter(counter, cpu, forks);
 
 	nr_cpu++;
 }
@@ -425,7 +436,7 @@ static int __cmd_record(int argc, const 
 	int err;
 	unsigned long waking = 0;
 	int child_ready_pipe[2], go_pipe[2];
-	const bool forks = target_pid == -1 && argc > 0;
+	const bool forks = target_tid == -1 && argc > 0;
 	char buf;
 
 	page_size = sysconf(_SC_PAGE_SIZE);
@@ -534,7 +545,7 @@ static int __cmd_record(int argc, const 
 		child_pid = pid;
 
 		if (!system_wide)
-			target_pid = pid;
+			target_tid = pid;
 
 		close(child_ready_pipe[1]);
 		close(go_pipe[0]);
@@ -550,11 +561,11 @@ static int __cmd_record(int argc, const 
 
 
 	if ((!system_wide && !inherit) || profile_cpu != -1) {
-		open_counters(profile_cpu, target_pid, forks);
+		open_counters(profile_cpu, forks);
 	} else {
 		nr_cpus = read_cpu_map();
 		for (i = 0; i < nr_cpus; i++)
-			open_counters(cpumap[i], target_pid, forks);
+			open_counters(cpumap[i], forks);
 	}
 
 	if (file_new) {
@@ -579,7 +590,7 @@ static int __cmd_record(int argc, const 
 	}
 
 	if (!system_wide && profile_cpu == -1)
-		event__synthesize_thread(target_pid, process_synthesized_event,
+		event__synthesize_thread(target_tid, process_synthesized_event,
 					 session);
 	else
 		event__synthesize_threads(process_synthesized_event, session);
@@ -602,11 +613,15 @@ static int __cmd_record(int argc, const 
 
 	for (;;) {
 		int hits = samples;
+		int thread;
 
 		for (i = 0; i < nr_cpu; i++) {
 			for (counter = 0; counter < nr_counters; counter++) {
-				if (mmap_array[i][counter].base)
-					mmap_read(&mmap_array[i][counter]);
+				for (thread = 0;
+					thread < thread_num; thread++) {
+					if (mmap_array[i][counter][thread].base)
+						mmap_read(&mmap_array[i][counter][thread]);
+				}
 			}
 		}
 
@@ -619,8 +634,13 @@ static int __cmd_record(int argc, const 
 
 		if (done) {
 			for (i = 0; i < nr_cpu; i++) {
-				for (counter = 0; counter < nr_counters; counter++)
-					ioctl(fd[i][counter], PERF_EVENT_IOC_DISABLE);
+				for (counter = 0; counter < nr_counters;
+					counter++) {
+					for (thread = 0;
+						thread < thread_num; thread++)
+						ioctl(fd[i][counter][thread],
+							PERF_EVENT_IOC_DISABLE);
+				}
 			}
 		}
 	}
@@ -653,6 +673,8 @@ static const struct option options[] = {
 		     "event filter", parse_filter),
 	OPT_INTEGER('p', "pid", &target_pid,
 		    "record events on existing pid"),
+	OPT_INTEGER('t', "tid", &target_tid,
+		    "record events on existing thread id"),
 	OPT_INTEGER('r', "realtime", &realtime_prio,
 		    "collect data with this RT SCHED_FIFO priority"),
 	OPT_BOOLEAN('R', "raw-samples", &raw_samples,
@@ -693,10 +715,11 @@ static const struct option options[] = {
 int cmd_record(int argc, const char **argv, const char *prefix __used)
 {
 	int counter;
+	int i,j;
 
 	argc = parse_options(argc, argv, options, record_usage,
 			    PARSE_OPT_STOP_AT_NON_OPTION);
-	if (!argc && target_pid == -1 && !system_wide && profile_cpu == -1)
+	if (!argc && target_tid == -1 && !system_wide && profile_cpu == -1)
 		usage_with_options(record_usage, options);
 
 	symbol__init();
@@ -707,6 +730,37 @@ int cmd_record(int argc, const char **ar
 		attrs[0].config = PERF_COUNT_HW_CPU_CYCLES;
 	}
 
+	if (target_pid != -1) {
+		target_tid = target_pid;
+		thread_num = find_all_tid(target_pid, &all_tids);
+		if (thread_num <= 0) {
+			fprintf(stderr, "Can't find all threads of pid %d\n",
+				target_pid);
+			usage_with_options(record_usage, options);
+		}
+	} else {
+		all_tids=malloc(sizeof(int));
+		if (!all_tids)
+			return -ENOMEM;
+
+		all_tids[0] = target_tid;
+		thread_num = 1;
+	}
+
+	for (i = 0; i < MAX_NR_CPUS; i++) {
+		for (j = 0; j < MAX_COUNTERS; j++) {
+			fd[i][j] = malloc(sizeof(int)*thread_num);
+			mmap_array[i][j] = malloc(
+				sizeof(struct mmap_data)*thread_num);
+			if (!fd[i][j] || !mmap_array[i][j])
+				return -ENOMEM;
+		}
+	}
+	event_array = malloc(
+		sizeof(struct pollfd)*MAX_NR_CPUS*MAX_COUNTERS*thread_num);
+	if (!event_array)
+		return -ENOMEM;
+
 	/*
 	 * User specified count overrides default frequency.
 	 */
diff -Nraup linux-2.6_tipmaster0315/tools/perf/builtin-stat.c linux-2.6_tipmaster0315_perfpid/tools/perf/builtin-stat.c
--- linux-2.6_tipmaster0315/tools/perf/builtin-stat.c	2010-03-16 08:59:54.892460680 +0800
+++ linux-2.6_tipmaster0315_perfpid/tools/perf/builtin-stat.c	2010-03-17 16:30:25.484062179 +0800
@@ -46,6 +46,7 @@
 #include "util/debug.h"
 #include "util/header.h"
 #include "util/cpumap.h"
+#include "util/thread.h"
 
 #include <sys/prctl.h>
 #include <math.h>
@@ -74,10 +75,14 @@ static int			run_count			=  1;
 static int			inherit				=  1;
 static int			scale				=  1;
 static pid_t			target_pid			= -1;
+static pid_t			target_tid			= -1;
+static int			*all_tids			=  NULL;
+static int			thread_num			=  0;
 static pid_t			child_pid			= -1;
 static int			null_run			=  0;
+static bool			forks				=  false;
 
-static int			fd[MAX_NR_CPUS][MAX_COUNTERS];
+static int			*fd[MAX_NR_CPUS][MAX_COUNTERS];
 
 static int			event_scaled[MAX_COUNTERS];
 
@@ -140,9 +145,10 @@ struct stats			runtime_branches_stats;
 #define ERR_PERF_OPEN \
 "Error: counter %d, sys_perf_event_open() syscall returned with %d (%s)\n"
 
-static void create_perf_stat_counter(int counter, int pid)
+static void create_perf_stat_counter(int counter)
 {
 	struct perf_event_attr *attr = attrs + counter;
+	int thread;
 
 	if (scale)
 		attr->read_format = PERF_FORMAT_TOTAL_TIME_ENABLED |
@@ -152,20 +158,24 @@ static void create_perf_stat_counter(int
 		unsigned int cpu;
 
 		for (cpu = 0; cpu < nr_cpus; cpu++) {
-			fd[cpu][counter] = sys_perf_event_open(attr, -1, cpumap[cpu], -1, 0);
-			if (fd[cpu][counter] < 0 && verbose)
+			fd[cpu][counter][0] = sys_perf_event_open(attr, -1, cpumap[cpu], -1, 0);
+			if (fd[cpu][counter][0] < 0 && verbose)
 				fprintf(stderr, ERR_PERF_OPEN, counter,
-					fd[cpu][counter], strerror(errno));
+					fd[cpu][counter][0], strerror(errno));
 		}
 	} else {
 		attr->inherit	     = inherit;
-		attr->disabled	     = 1;
+		if (forks)
+			attr->disabled	     = 1;
 		attr->enable_on_exec = 1;
 
-		fd[0][counter] = sys_perf_event_open(attr, pid, -1, -1, 0);
-		if (fd[0][counter] < 0 && verbose)
-			fprintf(stderr, ERR_PERF_OPEN, counter,
-				fd[0][counter], strerror(errno));
+		for (thread = 0; thread < thread_num; thread++) {
+			fd[0][counter][thread] = sys_perf_event_open(attr,
+				all_tids[thread], -1, -1, 0);
+			if (fd[0][counter][thread] < 0 && verbose)
+				fprintf(stderr, ERR_PERF_OPEN, counter,
+					fd[0][counter][thread], strerror(errno));
+		}
 	}
 }
 
@@ -190,25 +200,29 @@ static void read_counter(int counter)
 	unsigned int cpu;
 	size_t res, nv;
 	int scaled;
-	int i;
+	int i, thread;
 
 	count[0] = count[1] = count[2] = 0;
 
 	nv = scale ? 3 : 1;
 	for (cpu = 0; cpu < nr_cpus; cpu++) {
-		if (fd[cpu][counter] < 0)
-			continue;
-
-		res = read(fd[cpu][counter], single_count, nv * sizeof(u64));
-		assert(res == nv * sizeof(u64));
-
-		close(fd[cpu][counter]);
-		fd[cpu][counter] = -1;
-
-		count[0] += single_count[0];
-		if (scale) {
-			count[1] += single_count[1];
-			count[2] += single_count[2];
+		
+		for (thread = 0; thread < thread_num; thread++) {
+			if (fd[cpu][counter][thread] < 0)
+				continue;
+
+			res = read(fd[cpu][counter][thread],
+					single_count, nv * sizeof(u64));
+			assert(res == nv * sizeof(u64));
+
+			close(fd[cpu][counter][thread]);
+			fd[cpu][counter][thread] = -1;
+
+			count[0] += single_count[0];
+			if (scale) {
+				count[1] += single_count[1];
+				count[2] += single_count[2];
+			}
 		}
 	}
 
@@ -251,11 +265,11 @@ static int run_perf_stat(int argc __used
 	unsigned long long t0, t1;
 	int status = 0;
 	int counter;
-	int pid = target_pid;
+	int pid = target_tid;
 	int child_ready_pipe[2], go_pipe[2];
-	const bool forks = (target_pid == -1 && argc > 0);
 	char buf;
 
+	forks = (target_tid == -1 && argc > 0);
 	if (!system_wide)
 		nr_cpus = 1;
 
@@ -307,10 +321,12 @@ static int run_perf_stat(int argc __used
 		if (read(child_ready_pipe[0], &buf, 1) == -1)
 			perror("unable to read pipe");
 		close(child_ready_pipe[0]);
+
+		all_tids[0] = pid;
 	}
 
 	for (counter = 0; counter < nr_counters; counter++)
-		create_perf_stat_counter(counter, pid);
+		create_perf_stat_counter(counter);
 
 	/*
 	 * Enable counters and exec the command:
@@ -321,7 +337,7 @@ static int run_perf_stat(int argc __used
 		close(go_pipe[1]);
 		wait(&status);
 	} else {
-		while(!done);
+		while(!done) sleep(1);
 	}
 
 	t1 = rdclock();
@@ -429,12 +445,12 @@ static void print_stat(int argc, const c
 
 	fprintf(stderr, "\n");
 	fprintf(stderr, " Performance counter stats for ");
-	if(target_pid == -1) {
+	if(target_tid == -1) {
 		fprintf(stderr, "\'%s", argv[0]);
 		for (i = 1; i < argc; i++)
 			fprintf(stderr, " %s", argv[i]);
 	}else
-		fprintf(stderr, "task pid \'%d", target_pid);
+		fprintf(stderr, "task pid \'%d", target_tid);
 
 	fprintf(stderr, "\'");
 	if (run_count > 1)
@@ -459,7 +475,7 @@ static volatile int signr = -1;
 
 static void skip_signal(int signo)
 {
-	if(target_pid != -1)
+	if(target_tid != -1)
 		done = 1;
 
 	signr = signo;
@@ -488,8 +504,10 @@ static const struct option options[] = {
 		     parse_events),
 	OPT_BOOLEAN('i', "inherit", &inherit,
 		    "child tasks inherit counters"),
-	OPT_INTEGER('p', "pid", &target_pid,
+	OPT_INTEGER('p', "pid", &target_tid,
 		    "stat events on existing pid"),
+	OPT_INTEGER('t', "tid", &target_tid,
+		    "stat events on existing tid"),
 	OPT_BOOLEAN('a', "all-cpus", &system_wide,
 		    "system-wide collection from all CPUs"),
 	OPT_BOOLEAN('c', "scale", &scale,
@@ -506,10 +524,11 @@ static const struct option options[] = {
 int cmd_stat(int argc, const char **argv, const char *prefix __used)
 {
 	int status;
+	int i,j;
 
 	argc = parse_options(argc, argv, options, stat_usage,
 		PARSE_OPT_STOP_AT_NON_OPTION);
-	if (!argc && target_pid == -1)
+	if (!argc && (target_pid == -1 || target_tid == -1))
 		usage_with_options(stat_usage, options);
 	if (run_count <= 0)
 		usage_with_options(stat_usage, options);
@@ -525,6 +544,32 @@ int cmd_stat(int argc, const char **argv
 	else
 		nr_cpus = 1;
 
+	if (target_pid != -1) {
+		target_tid = target_pid;
+		thread_num = find_all_tid(target_pid, &all_tids);
+		if (thread_num <= 0) {
+			fprintf(stderr, "Can't find all threads of pid %d\n",
+				target_pid);
+			usage_with_options(stat_usage, options);
+		}
+
+	} else {
+		all_tids=malloc(sizeof(int));
+		if (!all_tids)
+			return -ENOMEM;
+
+		all_tids[0] = target_tid;
+		thread_num = 1;
+	}
+
+	for (i = 0; i < MAX_NR_CPUS; i++) {
+		for (j = 0; j < MAX_COUNTERS; j++) {
+			fd[i][j] = malloc(sizeof(int)*thread_num);
+			if (!fd[i][j])
+				return -ENOMEM;
+		}
+	}
+
 	/*
 	 * We dont want to block the signals - that would cause
 	 * child tasks to inherit that and Ctrl-C would not work.
diff -Nraup linux-2.6_tipmaster0315/tools/perf/builtin-top.c linux-2.6_tipmaster0315_perfpid/tools/perf/builtin-top.c
--- linux-2.6_tipmaster0315/tools/perf/builtin-top.c	2010-03-16 08:59:54.760470652 +0800
+++ linux-2.6_tipmaster0315_perfpid/tools/perf/builtin-top.c	2010-03-17 16:30:35.316716557 +0800
@@ -55,7 +55,8 @@
 #include <linux/unistd.h>
 #include <linux/types.h>
 
-static int			fd[MAX_NR_CPUS][MAX_COUNTERS];
+static int			*fd[MAX_NR_CPUS][MAX_COUNTERS];
+static int			*all_tids			=      NULL;
 
 static int			system_wide			=      0;
 
@@ -64,7 +65,9 @@ static int			default_interval		=      0;
 static int			count_filter			=      5;
 static int			print_entries;
 
+static int			target_tid			=     -1;
 static int			target_pid			=     -1;
+static int			thread_num			=      0;
 static int			inherit				=      0;
 static int			profile_cpu			=     -1;
 static int			nr_cpus				=      0;
@@ -524,13 +527,15 @@ static void print_sym_table(void)
 
 	if (target_pid != -1)
 		printf(" (target_pid: %d", target_pid);
+	else if (target_tid != -1)
+		printf(" (target_tid: %d", target_tid);
 	else
 		printf(" (all");
 
 	if (profile_cpu != -1)
 		printf(", cpu: %d)\n", profile_cpu);
 	else {
-		if (target_pid != -1)
+		if (target_tid != -1)
 			printf(")\n");
 		else
 			printf(", %d CPUs)\n", nr_cpus);
@@ -1124,16 +1129,21 @@ static void perf_session__mmap_read_coun
 	md->prev = old;
 }
 
-static struct pollfd event_array[MAX_NR_CPUS * MAX_COUNTERS];
-static struct mmap_data mmap_array[MAX_NR_CPUS][MAX_COUNTERS];
+static struct pollfd *event_array;
+static struct mmap_data *mmap_array[MAX_NR_CPUS][MAX_COUNTERS];
 
 static void perf_session__mmap_read(struct perf_session *self)
 {
-	int i, counter;
+	int i, counter, thread_index;
 
 	for (i = 0; i < nr_cpus; i++) {
 		for (counter = 0; counter < nr_counters; counter++)
-			perf_session__mmap_read_counter(self, &mmap_array[i][counter]);
+			for (thread_index = 0;
+				thread_index < thread_num;
+				thread_index++) {
+				perf_session__mmap_read_counter(self,
+					&mmap_array[i][counter][thread_index]);
+			}
 	}
 }
 
@@ -1144,9 +1154,10 @@ static void start_counter(int i, int cou
 {
 	struct perf_event_attr *attr;
 	int cpu;
+	int thread_index;
 
 	cpu = profile_cpu;
-	if (target_pid == -1 && profile_cpu == -1)
+	if (target_tid == -1 && profile_cpu == -1)
 		cpu = cpumap[i];
 
 	attr = attrs + counter;
@@ -1162,55 +1173,58 @@ static void start_counter(int i, int cou
 	attr->inherit		= (cpu < 0) && inherit;
 	attr->mmap		= 1;
 
+	for (thread_index = 0; thread_index < thread_num; thread_index++) {
 try_again:
-	fd[i][counter] = sys_perf_event_open(attr, target_pid, cpu, group_fd, 0);
+		fd[i][counter][thread_index] = sys_perf_event_open(attr,
+				all_tids[thread_index], cpu, group_fd, 0);
+
+		if (fd[i][counter][thread_index] < 0) {
+			int err = errno;
 
-	if (fd[i][counter] < 0) {
-		int err = errno;
+			if (err == EPERM || err == EACCES)
+				die("No permission - are you root?\n");
+			/*
+			 * If it's cycles then fall back to hrtimer
+			 * based cpu-clock-tick sw counter, which
+			 * is always available even if no PMU support:
+			 */
+			if (attr->type == PERF_TYPE_HARDWARE
+					&& attr->config == PERF_COUNT_HW_CPU_CYCLES) {
+
+				if (verbose)
+					warning(" ... trying to fall back to cpu-clock-ticks\n");
+
+				attr->type = PERF_TYPE_SOFTWARE;
+				attr->config = PERF_COUNT_SW_CPU_CLOCK;
+				goto try_again;
+			}
+			printf("\n");
+			error("perfcounter syscall returned with %d (%s)\n",
+					fd[i][counter][thread_index], strerror(err));
+			die("No CONFIG_PERF_EVENTS=y kernel support configured?\n");
+			exit(-1);
+		}
+		assert(fd[i][counter][thread_index] >= 0);
+		fcntl(fd[i][counter][thread_index], F_SETFL, O_NONBLOCK);
 
-		if (err == EPERM || err == EACCES)
-			die("No permission - are you root?\n");
 		/*
-		 * If it's cycles then fall back to hrtimer
-		 * based cpu-clock-tick sw counter, which
-		 * is always available even if no PMU support:
+		 * First counter acts as the group leader:
 		 */
-		if (attr->type == PERF_TYPE_HARDWARE
-			&& attr->config == PERF_COUNT_HW_CPU_CYCLES) {
+		if (group && group_fd == -1)
+			group_fd = fd[i][counter][thread_index];
 
-			if (verbose)
-				warning(" ... trying to fall back to cpu-clock-ticks\n");
-
-			attr->type = PERF_TYPE_SOFTWARE;
-			attr->config = PERF_COUNT_SW_CPU_CLOCK;
-			goto try_again;
-		}
-		printf("\n");
-		error("perfcounter syscall returned with %d (%s)\n",
-			fd[i][counter], strerror(err));
-		die("No CONFIG_PERF_EVENTS=y kernel support configured?\n");
-		exit(-1);
+		event_array[nr_poll].fd = fd[i][counter][thread_index];
+		event_array[nr_poll].events = POLLIN;
+		nr_poll++;
+
+		mmap_array[i][counter][thread_index].counter = counter;
+		mmap_array[i][counter][thread_index].prev = 0;
+		mmap_array[i][counter][thread_index].mask = mmap_pages*page_size - 1;
+		mmap_array[i][counter][thread_index].base = mmap(NULL, (mmap_pages+1)*page_size,
+				PROT_READ, MAP_SHARED, fd[i][counter][thread_index], 0);
+		if (mmap_array[i][counter][thread_index].base == MAP_FAILED)
+			die("failed to mmap with %d (%s)\n", errno, strerror(errno));
 	}
-	assert(fd[i][counter] >= 0);
-	fcntl(fd[i][counter], F_SETFL, O_NONBLOCK);
-
-	/*
-	 * First counter acts as the group leader:
-	 */
-	if (group && group_fd == -1)
-		group_fd = fd[i][counter];
-
-	event_array[nr_poll].fd = fd[i][counter];
-	event_array[nr_poll].events = POLLIN;
-	nr_poll++;
-
-	mmap_array[i][counter].counter = counter;
-	mmap_array[i][counter].prev = 0;
-	mmap_array[i][counter].mask = mmap_pages*page_size - 1;
-	mmap_array[i][counter].base = mmap(NULL, (mmap_pages+1)*page_size,
-			PROT_READ, MAP_SHARED, fd[i][counter], 0);
-	if (mmap_array[i][counter].base == MAP_FAILED)
-		die("failed to mmap with %d (%s)\n", errno, strerror(errno));
 }
 
 static int __cmd_top(void)
@@ -1226,8 +1240,8 @@ static int __cmd_top(void)
 	if (session == NULL)
 		return -ENOMEM;
 
-	if (target_pid != -1)
-		event__synthesize_thread(target_pid, event__process, session);
+	if (target_tid != -1)
+		event__synthesize_thread(target_tid, event__process, session);
 	else
 		event__synthesize_threads(event__process, session);
 
@@ -1238,7 +1252,7 @@ static int __cmd_top(void)
 	}
 
 	/* Wait for a minimal set of events before starting the snapshot */
-	poll(event_array, nr_poll, 100);
+	poll(&event_array[0], nr_poll, 100);
 
 	perf_session__mmap_read(session);
 
@@ -1282,6 +1296,8 @@ static const struct option options[] = {
 		    "event period to sample"),
 	OPT_INTEGER('p', "pid", &target_pid,
 		    "profile events on existing pid"),
+	OPT_INTEGER('t', "tid", &target_tid,
+		    "profile events on existing tid"),
 	OPT_BOOLEAN('a', "all-cpus", &system_wide,
 			    "system-wide collection from all CPUs"),
 	OPT_INTEGER('C', "CPU", &profile_cpu,
@@ -1322,6 +1338,7 @@ static const struct option options[] = {
 int cmd_top(int argc, const char **argv, const char *prefix __used)
 {
 	int counter;
+	int i,j;
 
 	page_size = sysconf(_SC_PAGE_SIZE);
 
@@ -1329,8 +1346,39 @@ int cmd_top(int argc, const char **argv,
 	if (argc)
 		usage_with_options(top_usage, options);
 
+	if (target_pid != -1) {
+		target_tid = target_pid;
+		thread_num = find_all_tid(target_pid, &all_tids);
+		if (thread_num <= 0) {
+			fprintf(stderr, "Can't find all threads of pid %d\n",
+				target_pid);
+			usage_with_options(top_usage, options);
+		}
+	} else {
+		all_tids=malloc(sizeof(int));
+		if (!all_tids)
+			return -ENOMEM;
+
+		all_tids[0] = target_tid;
+		thread_num = 1;
+	}
+
+	for (i = 0; i < MAX_NR_CPUS; i++) {
+		for (j = 0; j < MAX_COUNTERS; j++) {
+			fd[i][j] = malloc(sizeof(int)*thread_num);
+			mmap_array[i][j] = malloc(
+				sizeof(struct mmap_data)*thread_num);
+			if (!fd[i][j] || !mmap_array[i][j])
+				return -ENOMEM;
+		}
+	}
+	event_array = malloc(
+		sizeof(struct pollfd)*MAX_NR_CPUS*MAX_COUNTERS*thread_num);
+	if (!event_array)
+		return -ENOMEM;
+
 	/* CPU and PID are mutually exclusive */
-	if (target_pid != -1 && profile_cpu != -1) {
+	if (target_tid > 0 && profile_cpu != -1) {
 		printf("WARNING: PID switch overriding CPU\n");
 		sleep(1);
 		profile_cpu = -1;
@@ -1371,7 +1419,7 @@ int cmd_top(int argc, const char **argv,
 		attrs[counter].sample_period = default_interval;
 	}
 
-	if (target_pid != -1 || profile_cpu != -1)
+	if (target_tid != -1 || profile_cpu != -1)
 		nr_cpus = 1;
 	else
 		nr_cpus = read_cpu_map();
diff -Nraup linux-2.6_tipmaster0315/tools/perf/util/thread.c linux-2.6_tipmaster0315_perfpid/tools/perf/util/thread.c
--- linux-2.6_tipmaster0315/tools/perf/util/thread.c	2010-03-16 08:59:54.892460680 +0800
+++ linux-2.6_tipmaster0315_perfpid/tools/perf/util/thread.c	2010-03-17 14:07:25.725218425 +0800
@@ -7,6 +7,37 @@
 #include "util.h"
 #include "debug.h"
 
+int find_all_tid(int pid, int ** all_tid)
+{
+	char name[256];
+	int items;
+	struct dirent **namelist = NULL;
+	int ret = 0;
+	int i;
+
+	sprintf(name, "/proc/%d/task", pid);
+	items = scandir(name, &namelist, NULL, NULL);
+	if (items <= 0)
+                return -ENOENT;
+	*all_tid = malloc(sizeof(int) * items);
+	if (!*all_tid) {
+		ret = -ENOMEM;
+		goto failure;
+	}
+
+	for (i = 0; i < items; i++)
+		(*all_tid)[i] = atoi(namelist[i]->d_name);
+
+	ret = items;
+
+failure:
+	for (i=0; i<items; i++)
+		free(namelist[i]);
+	free(namelist);
+
+	return ret;
+}
+
 void map_groups__init(struct map_groups *self)
 {
 	int i;
@@ -348,3 +379,4 @@ struct symbol *map_groups__find_symbol(s
 
 	return NULL;
 }
+
diff -Nraup linux-2.6_tipmaster0315/tools/perf/util/thread.h linux-2.6_tipmaster0315_perfpid/tools/perf/util/thread.h
--- linux-2.6_tipmaster0315/tools/perf/util/thread.h	2010-03-16 08:59:54.764469663 +0800
+++ linux-2.6_tipmaster0315_perfpid/tools/perf/util/thread.h	2010-03-17 14:03:09.628322688 +0800
@@ -23,6 +23,7 @@ struct thread {
 	int			comm_len;
 };
 
+int find_all_tid(int pid, int ** all_tid);
 void map_groups__init(struct map_groups *self);
 int thread__set_comm(struct thread *self, const char *comm);
 int thread__comm_len(struct thread *self);



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab2DPIe4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 04:34:56 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:32766
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751360Ab2DPIey convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 04:34:54 -0400
X-SpamScore: 11
X-BigFish: VPS11(zzzz1202hzz8275bh11f642sz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M2KD5Y-02-03L-02
X-M-MSG: 
From: "Chen, Dennis (SRDC SW)" <Dennis1.Chen@amd.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 1/2] tools perf: Add a new benchmark tool for semaphore/mutex
Thread-Topic: [PATCH 1/2] tools perf: Add a new benchmark tool for
 semaphore/mutex
Thread-Index: Ac0bq8MflXUZwOd4SI6p7+Nhh3anqA==
Date: Mon, 16 Apr 2012 08:34:39 +0000
Message-ID: <491D6B4EAD0A714894D8AD22F4BDE043B158CD@SCYBEXDAG03.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.74.102]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A new benchmark tool for semaphore or mutex lock.

Signed-off-by: Dennis Chen <dennis1.chen@amd.com>
---
diff --git a/tools/perf/bench/lock-mutex.c b/tools/perf/bench/lock-mutex.c
new file mode 100644
index 0000000..4f6edb2
--- /dev/null
+++ b/tools/perf/bench/lock-mutex.c
@@ -0,0 +1,294 @@
+/*
+ * tools/perf/bench/lock-mutex.c
+ *
+ * mutex lock: performance benchmark for semaphore or mutex lock
+ *
+ * Started by Dennis Chen <dennis1.chen@amd.com>
+ */
+
+#include "../util/util.h"
+#include "../util/parse-options.h"
+#include "../util/header.h"
+#include "bench.h"
+
+#include <sched.h>
+#include <semaphore.h>
+#include <sys/mman.h>
+#include <sys/times.h>
+
+#define NR_TASK         5000UL
+#define PATH_MAX_LEN    256
+/*
+ * 'sys/module' is a good start point as the benchmark target since it has
+ * almost no dependencies on external devices. Although sysfs in the kernel
+ * is in a slow path, we just use it as the semaphore/mutex lock performance
+ * benchmark...
+ */
+
+#define        TEST_DIR        "/sys/module"
+#define        FILE_MODE       (S_IRWXU|S_IRWXG|S_IRWXO)
+#define        DIR_MODE        FILE_MODE
+
+typedef void (*MUTEX_BENCH_FN)(char *);
+
+static unsigned int nr_cpus;
+static unsigned int nr_tasks;
+static bool    use_clock;
+static int     clock_fd;
+
+static const struct option options[] = {
+       OPT_UINTEGER('p', "cpus", &nr_cpus,
+                   "Specify the cpu count in the system. "),
+       OPT_UINTEGER('t', "tasks", &nr_tasks,
+                   "Specify the count of tasks will be created."),
+       OPT_BOOLEAN('c', "clock", &use_clock,
+                   "Use CPU clock for measuring"),
+       OPT_END()
+};
+
+/* shared data area among tasks to store the perf data*/
+struct mutex_perf_data {
+       struct timeval dur;
+       u64 cpu_cycle;
+       u64 cpu_ins;
+       sem_t sem;
+};
+
+struct mutex_perf_data *sdata;
+
+static void print_usage(void)
+{
+       printf("Usage:\n");
+       printf("perf bench locking mutex -p cpus -t tasks [-c]\n");
+}
+
+static const char * const bench_lock_mutex_usage[] = {
+       "perf bench locking mutex <options>",
+       NULL
+};
+
+static struct perf_event_attr clock_attr = {
+       .type           = PERF_TYPE_HARDWARE,
+       .config         = PERF_COUNT_HW_CPU_CYCLES
+};
+
+static void init_clock(void)
+{
+       clock_fd = sys_perf_event_open(&clock_attr, getpid(), -1, -1, 0);
+
+       if (clock_fd < 0 && errno == ENOSYS)
+               die("No CONFIG_PERF_EVENTS=y kernel support configured?\n");
+       else
+               BUG_ON(clock_fd < 0);
+}
+
+static u64 get_clock(void)
+{
+       int ret;
+       u64 clk;
+
+       ret = read(clock_fd, &clk, sizeof(u64));
+       BUG_ON(ret != sizeof(u64));
+
+       return clk;
+}
+
+static void do_read_file(char *filename)
+{
+       int fd;
+       ssize_t size;
+       char buff;
+
+       fd = open(filename, O_RDONLY);
+       if (fd < 0)
+               return;
+
+       size = read(fd, &buff, sizeof(char));
+       if (size < 0) {
+               close(fd);
+               return;
+       }
+
+       close(fd);
+}
+
+/*
+ * we need to find a mutex lock/unlock sensitive workload, currently
+ * READ operation of both DIR and FILE in sysfs will use mutex lock heavily
+ * each task will read every dir and file under '/sys/module' recursively
+ */
+static void recursive_dir(char *path)
+{
+       struct stat statbuf;
+       struct dirent   *dirp;
+       DIR *dp;
+       char *ptr;
+
+       if (lstat(path, &statbuf) < 0) {
+               printf("lstat %s error:%s\n", path, strerror(errno));
+               return;
+       }
+
+       /* not a directory */
+       if (!S_ISDIR(statbuf.st_mode)) {
+               /*
+                * we only read regular file, 3 times to triger mutex lock
+                * as many as possible
+                */
+               if (S_ISREG(statbuf.st_mode)) {
+                       do_read_file(path);
+                       do_read_file(path);
+                       do_read_file(path);
+               }
+               return;
+       }
+
+       ptr = path + strlen(path);
+       *ptr++ = '/';
+       *ptr = 0;
+
+       dp = opendir(path);
+       if (dp == NULL) {
+               printf("opendir %s error:%s\n", path, strerror(errno));
+               return;
+       }
+
+       while ((dirp = readdir(dp)) != NULL) {
+               if (strcmp(dirp->d_name, ".") == 0 ||
+                       strcmp(dirp->d_name, "..") == 0)
+                       continue;
+               strcpy(ptr, dirp->d_name);
+               recursive_dir(path);
+       }
+
+       if (closedir(dp) < 0)
+               perror("closedir");
+
+}
+
+static inline void do_mutex_bench(MUTEX_BENCH_FN fn, char *dir)
+{
+       BUG_ON(fn == NULL);
+       BUG_ON(dir == NULL);
+       fn(dir);
+}
+
+static void do_bench_func(unsigned int idx)
+{
+       cpu_set_t cpu_set;
+       int cpu;
+       char fullpath[PATH_MAX_LEN];
+       struct timeval tv_start = {0, 0}, tv_end = {0, 0}, tv_diff;
+       u64 clock_start = 0ULL, clock_end = 0ULL;
+
+       CPU_ZERO(&cpu_set);
+       cpu = idx % nr_cpus;
+       CPU_SET(cpu, &cpu_set);
+       BUG_ON(sched_setaffinity(getpid(), sizeof(cpu_set), &cpu_set));
+
+       strcpy(fullpath, TEST_DIR);
+       fullpath[PATH_MAX_LEN - 1] = 0;
+
+       if (use_clock) {
+               clock_start = get_clock();
+               do_mutex_bench(recursive_dir, fullpath);
+               clock_end = get_clock();
+
+               sem_wait(&sdata->sem);
+               sdata->cpu_cycle += clock_end - clock_start;
+               sem_post(&sdata->sem);
+               printf(" [%-6d]/%d   cpu clocks  %" PRIu64 "\n",
+                       getpid(), cpu, clock_end - clock_start);
+
+       } else {
+               BUG_ON(gettimeofday(&tv_start, NULL));
+               do_mutex_bench(recursive_dir, fullpath);
+               BUG_ON(gettimeofday(&tv_end, NULL));
+               timersub(&tv_end, &tv_start, &tv_diff);
+
+               sem_wait(&sdata->sem);
+               timeradd(&sdata->dur, &tv_diff, &sdata->dur);
+               sem_post(&sdata->sem);
+               printf(" [%-6d]/%d  duration  %8ld s %8ld us\n",
+                       getpid(), cpu, tv_diff.tv_sec, tv_diff.tv_usec);
+       }
+}
+
+static void process_time(clock_t real, struct tms *start, struct tms *end)
+{
+       long clktck = 0;
+
+       BUG_ON((clktck = sysconf(_SC_CLK_TCK)) < 0);
+       printf("\n real: %-7.2f s\n", real/(double)clktck);
+       printf(" user: %-7.2f\n",
+               (end->tms_utime - start->tms_utime)/(double)clktck);
+       printf(" sys:  %-7.2f\n",
+               (end->tms_stime - start->tms_stime)/(double)clktck);
+}
+
+/*the main entry point of the mutex/semaphore benchmark...*/
+int bench_lock_mutex(int argc, const char **argv,
+                    const char *prefix __used)
+{
+       pid_t   pid;
+       unsigned int i;
+       void *area;
+       struct tms tms_start, tms_end;
+       clock_t start, end;
+       int status = -1;
+
+       if (argc < 5) {
+               print_usage();
+               goto end;
+       }
+
+       argc = parse_options(argc, argv, options,
+                               bench_lock_mutex_usage, 0);
+
+       if (nr_cpus == 0 || nr_tasks > NR_TASK) {
+               printf("Bad options: cpus--[1, ], tasks--[ ,%lu]\n", NR_TASK);
+               goto end;
+       }
+
+       if (use_clock)
+               init_clock();
+
+       area = mmap(0, sizeof(struct mutex_perf_data),
+                               PROT_READ | PROT_WRITE,
+                               MAP_ANON | MAP_SHARED, -1, 0);
+       if (area == MAP_FAILED) {
+               printf("mmap error:%s\n", strerror(errno));
+               goto end;
+       }
+       sdata = (struct mutex_perf_data *)area;
+
+       if (sem_init(&sdata->sem, 1, 1) == -1) {
+               printf("sem_init error:%s\n", strerror(errno));
+               goto end;
+       }
+
+       signal(SIGCHLD, SIG_IGN);
+
+       BUG_ON((start = times(&tms_start)) == -1);
+       for (i = 0; i < nr_tasks; i++) {
+               pid = fork();
+               if (pid == 0) {
+                       do_bench_func(i);
+                       return 0;
+               }
+       }
+
+       wait(NULL);
+
+       BUG_ON((end = times(&tms_end)) == -1);
+       printf(" -----------------------------------\n");
+       if (use_clock)
+               printf(" Total cpu cycles  %" PRIu64 "\n", sdata->cpu_cycle);
+       else
+               printf(" Total duration  %8ld s %8ld us\n",
+                               sdata->dur.tv_sec, sdata->dur.tv_usec);
+       process_time(end-start, &tms_start, &tms_end);
+       status = 0;
+end:
+       return status;
+}                                                                                                                                                                


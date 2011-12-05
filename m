Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261Ab1LENNV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:13:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57288 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756400Ab1LENNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:13:20 -0500
Date: Mon, 5 Dec 2011 05:12:58 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-svag18v2z4idas0dyz3umjpq@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf test: Validate PERF_RECORD_ events and perf_sample fields
Git-Commit-ID: 3e7c439a7ce537ed662e347b9e6414d7881fb3dc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 05:13:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3e7c439a7ce537ed662e347b9e6414d7881fb3dc
Gitweb:     http://git.kernel.org/tip/3e7c439a7ce537ed662e347b9e6414d7881fb3dc
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 2 Dec 2011 11:13:50 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 2 Dec 2011 11:13:50 -0200

perf test: Validate PERF_RECORD_ events and perf_sample fields

This new test will validate these new routines extracted from 'perf
record':

 - perf_evlist__config_attrs
 - perf_evlist__prepare_workload
 - perf_evlist__start_workload

In addition to several other perf_evlist methods.

It consists of starting a simple workload, setting up just one event to
monitor ("cycles") requesting that several PERF_SAMPLE_ fields be
present in all events.

It then will check that the expected PERF_RECORD_ events are produced
and will sanity check all its fields.

Some checks performed:

. PERF_SAMPLE_TIME monotonically increases.

. PERF_SAMPLE_CPU is the one requested with sched_setaffinity

. PERF_SAMPLE_TID and PERF_SAMPLE_PID matches the one we forked
  in perf_evlist__prepare_workload and that is stored in
  evlist->workload.pid

. For the events where these fields are also present in its
  pre-sample_id_all fields (e.g. event->mmap.pid), that they are what
  is expected too.

. That we get a bunch of mmaps:

  PATH/libcSUFFIX
  PATH/ldSUFFIX
  [vdso]
  PATH/sleep

Example:

  [root@emilia ~]# taskset -c 3,4 perf test -v1 perf_sample
   6: Validate PERF_RECORD_* events & perf_sample fields:
  --- start ---
  7159480799825 3 PERF_RECORD_SAMPLE
  7159480805584 3 PERF_RECORD_SAMPLE
  7159480807814 3 PERF_RECORD_SAMPLE
  7159480810430 3 PERF_RECORD_SAMPLE
  7159480861511 3 PERF_RECORD_MMAP 8086/8086: [0x7fffffffd000(0x2000) @ 0x7fffffffd000]: //anon
  7159481052516 3 PERF_RECORD_COMM: sleep:8086
  7159481070188 3 PERF_RECORD_MMAP 8086/8086: [0x400000(0x6000) @ 0]: /bin/sleep
  7159481077104 3 PERF_RECORD_MMAP 8086/8086: [0x3d06400000(0x221000) @ 0]: /lib64/ld-2.12.so
  7159481092912 3 PERF_RECORD_MMAP 8086/8086: [0x7fff1adff000(0x1000) @ 0x7fff1adff000]: [vdso]
  7159481196779 3 PERF_RECORD_MMAP 8086/8086: [0x3d06800000(0x37f000) @ 0]: /lib64/libc-2.12.so
  7160481558435 3 PERF_RECORD_EXIT(8086:8086):(8086:8086)
  ---- end ----
  Validate PERF_RECORD_* events & perf_sample fields: Ok
  [root@emilia ~]#

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-svag18v2z4idas0dyz3umjpq@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-test.c |  337 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 337 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 3ab2722..f1e3611 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -841,6 +841,339 @@ static int test__parse_events(void)
 
 	return ret;
 }
+
+static int sched__get_first_possible_cpu(pid_t pid, cpu_set_t **maskp,
+					 size_t *sizep)
+{
+	cpu_set_t *mask;
+	size_t size;
+	int i, cpu = -1, nrcpus = 1024;
+realloc:
+	mask = CPU_ALLOC(nrcpus);
+	size = CPU_ALLOC_SIZE(nrcpus);
+	CPU_ZERO_S(size, mask);
+
+	if (sched_getaffinity(pid, size, mask) == -1) {
+		CPU_FREE(mask);
+		if (errno == EINVAL && nrcpus < (1024 << 8)) {
+			nrcpus = nrcpus << 2;
+			goto realloc;
+		}
+		perror("sched_getaffinity");
+			return -1;
+	}
+
+	for (i = 0; i < nrcpus; i++) {
+		if (CPU_ISSET_S(i, size, mask)) {
+			if (cpu == -1) {
+				cpu = i;
+				*maskp = mask;
+				*sizep = size;
+			} else
+				CPU_CLR_S(i, size, mask);
+		}
+	}
+
+	if (cpu == -1)
+		CPU_FREE(mask);
+
+	return cpu;
+}
+
+static int test__PERF_RECORD(void)
+{
+	struct perf_record_opts opts = {
+		.target_pid = -1,
+		.target_tid = -1,
+		.no_delay   = true,
+		.freq	    = 10,
+		.mmap_pages = 256,
+		.sample_id_all_avail = true,
+	};
+	cpu_set_t *cpu_mask = NULL;
+	size_t cpu_mask_size = 0;
+	struct perf_evlist *evlist = perf_evlist__new(NULL, NULL);
+	struct perf_evsel *evsel;
+	struct perf_sample sample;
+	const char *cmd = "sleep";
+	const char *argv[] = { cmd, "1", NULL, };
+	char *bname;
+	u64 sample_type, prev_time = 0;
+	bool found_cmd_mmap = false,
+	     found_libc_mmap = false,
+	     found_vdso_mmap = false,
+	     found_ld_mmap = false;
+	int err = -1, i, wakeups = 0, sample_size;
+	u32 cpu;
+	int total_events = 0, nr_events[PERF_RECORD_MAX] = { 0, };
+
+	if (evlist == NULL || argv == NULL) {
+		pr_debug("Not enough memory to create evlist\n");
+		goto out;
+	}
+
+	/*
+	 * We need at least one evsel in the evlist, use the default
+	 * one: "cycles".
+	 */
+	err = perf_evlist__add_default(evlist);
+	if (err < 0) {
+		pr_debug("Not enough memory to create evsel\n");
+		goto out_delete_evlist;
+	}
+
+	/*
+	 * Create maps of threads and cpus to monitor. In this case
+	 * we start with all threads and cpus (-1, -1) but then in
+	 * perf_evlist__prepare_workload we'll fill in the only thread
+	 * we're monitoring, the one forked there.
+	 */
+	err = perf_evlist__create_maps(evlist, opts.target_pid,
+				       opts.target_tid, opts.cpu_list);
+	if (err < 0) {
+		pr_debug("Not enough memory to create thread/cpu maps\n");
+		goto out_delete_evlist;
+	}
+
+	/*
+	 * Prepare the workload in argv[] to run, it'll fork it, and then wait
+	 * for perf_evlist__start_workload() to exec it. This is done this way
+	 * so that we have time to open the evlist (calling sys_perf_event_open
+	 * on all the fds) and then mmap them.
+	 */
+	err = perf_evlist__prepare_workload(evlist, &opts, argv);
+	if (err < 0) {
+		pr_debug("Couldn't run the workload!\n");
+		goto out_delete_evlist;
+	}
+
+	/*
+	 * Config the evsels, setting attr->comm on the first one, etc.
+	 */
+	evsel = list_entry(evlist->entries.next, struct perf_evsel, node);
+	evsel->attr.sample_type |= PERF_SAMPLE_CPU;
+	evsel->attr.sample_type |= PERF_SAMPLE_TID;
+	evsel->attr.sample_type |= PERF_SAMPLE_TIME;
+	perf_evlist__config_attrs(evlist, &opts);
+
+	err = sched__get_first_possible_cpu(evlist->workload.pid, &cpu_mask,
+					    &cpu_mask_size);
+	if (err < 0) {
+		pr_debug("sched__get_first_possible_cpu: %s\n", strerror(errno));
+		goto out_delete_evlist;
+	}
+
+	cpu = err;
+
+	/*
+	 * So that we can check perf_sample.cpu on all the samples.
+	 */
+	if (sched_setaffinity(evlist->workload.pid, cpu_mask_size, cpu_mask) < 0) {
+		pr_debug("sched_setaffinity: %s\n", strerror(errno));
+		goto out_free_cpu_mask;
+	}
+
+	/*
+	 * Call sys_perf_event_open on all the fds on all the evsels,
+	 * grouping them if asked to.
+	 */
+	err = perf_evlist__open(evlist, opts.group);
+	if (err < 0) {
+		pr_debug("perf_evlist__open: %s\n", strerror(errno));
+		goto out_delete_evlist;
+	}
+
+	/*
+	 * mmap the first fd on a given CPU and ask for events for the other
+	 * fds in the same CPU to be injected in the same mmap ring buffer
+	 * (using ioctl(PERF_EVENT_IOC_SET_OUTPUT)).
+	 */
+	err = perf_evlist__mmap(evlist, opts.mmap_pages, false);
+	if (err < 0) {
+		pr_debug("perf_evlist__mmap: %s\n", strerror(errno));
+		goto out_delete_evlist;
+	}
+
+	/*
+	 * We'll need these two to parse the PERF_SAMPLE_* fields in each
+	 * event.
+	 */
+	sample_type = perf_evlist__sample_type(evlist);
+	sample_size = __perf_evsel__sample_size(sample_type);
+
+	/*
+	 * Now that all is properly set up, enable the events, they will
+	 * count just on workload.pid, which will start...
+	 */
+	perf_evlist__enable(evlist);
+
+	/*
+	 * Now!
+	 */
+	perf_evlist__start_workload(evlist);
+
+	err = -1;
+
+	while (1) {
+		int before = total_events;
+
+		for (i = 0; i < evlist->nr_mmaps; i++) {
+			union perf_event *event;
+
+			while ((event = perf_evlist__mmap_read(evlist, i)) != NULL) {
+				const u32 type = event->header.type;
+				const char *name = perf_event__name(type);
+
+				++total_events;
+				if (type < PERF_RECORD_MAX)
+					nr_events[type]++;
+
+				if (perf_event__parse_sample(event, sample_type,
+							     sample_size, true,
+							     &sample, false) < 0) {
+					if (verbose)
+						perf_event__fprintf(event, stderr);
+					pr_debug("Couldn't parse sample\n");
+					goto out_err;
+				}
+
+				if (verbose) {
+					pr_info("%" PRIu64" %d ", sample.time, sample.cpu);
+					perf_event__fprintf(event, stderr);
+				}
+
+				if (prev_time > sample.time) {
+					pr_debug("%s going backwards in time, prev=%" PRIu64 ", curr=%" PRIu64 "\n",
+						 name, prev_time, sample.time);
+					goto out_err;
+				}
+
+				prev_time = sample.time;
+
+				if (sample.cpu != cpu) {
+					pr_debug("%s with unexpected cpu, expected %d, got %d\n",
+						 name, cpu, sample.cpu);
+					goto out_err;
+				}
+
+				if ((pid_t)sample.pid != evlist->workload.pid) {
+					pr_debug("%s with unexpected pid, expected %d, got %d\n",
+						 name, evlist->workload.pid, sample.pid);
+					goto out_err;
+				}
+
+				if ((pid_t)sample.tid != evlist->workload.pid) {
+					pr_debug("%s with unexpected tid, expected %d, got %d\n",
+						 name, evlist->workload.pid, sample.tid);
+					goto out_err;
+				}
+
+				if ((type == PERF_RECORD_COMM ||
+				     type == PERF_RECORD_MMAP ||
+				     type == PERF_RECORD_FORK ||
+				     type == PERF_RECORD_EXIT) &&
+				     (pid_t)event->comm.pid != evlist->workload.pid) {
+					pr_debug("%s with unexpected pid/tid\n", name);
+					goto out_err;
+				}
+
+				if ((type == PERF_RECORD_COMM ||
+				     type == PERF_RECORD_MMAP) &&
+				     event->comm.pid != event->comm.tid) {
+					pr_debug("%s with different pid/tid!\n", name);
+					goto out_err;
+				}
+
+				switch (type) {
+				case PERF_RECORD_COMM:
+					if (strcmp(event->comm.comm, cmd)) {
+						pr_debug("%s with unexpected comm!\n", name);
+						goto out_err;
+					}
+					break;
+				case PERF_RECORD_EXIT:
+					goto found_exit;
+				case PERF_RECORD_MMAP:
+					bname = strrchr(event->mmap.filename, '/');
+					if (bname != NULL) {
+						if (!found_cmd_mmap)
+							found_cmd_mmap = !strcmp(bname + 1, cmd);
+						if (!found_libc_mmap)
+							found_libc_mmap = !strncmp(bname + 1, "libc", 4);
+						if (!found_ld_mmap)
+							found_ld_mmap = !strncmp(bname + 1, "ld", 2);
+					} else if (!found_vdso_mmap)
+						found_vdso_mmap = !strcmp(event->mmap.filename, "[vdso]");
+					break;
+
+				case PERF_RECORD_SAMPLE:
+					/* Just ignore samples for now */
+					break;
+				default:
+					pr_debug("Unexpected perf_event->header.type %d!\n",
+						 type);
+					goto out_err;
+				}
+			}
+		}
+
+		/*
+		 * We don't use poll here because at least at 3.1 times the
+		 * PERF_RECORD_{!SAMPLE} events don't honour
+		 * perf_event_attr.wakeup_events, just PERF_EVENT_SAMPLE does.
+		 */
+		if (total_events == before && false)
+			poll(evlist->pollfd, evlist->nr_fds, -1);
+
+		sleep(1);
+		if (++wakeups > 5) {
+			pr_debug("No PERF_RECORD_EXIT event!\n");
+			goto out_err;
+		}
+	}
+
+found_exit:
+	if (nr_events[PERF_RECORD_COMM] > 1) {
+		pr_debug("Excessive number of PERF_RECORD_COMM events!\n");
+		goto out_err;
+	}
+
+	if (nr_events[PERF_RECORD_COMM] == 0) {
+		pr_debug("Missing PERF_RECORD_COMM for %s!\n", cmd);
+		goto out_err;
+	}
+
+	if (!found_cmd_mmap) {
+		pr_debug("PERF_RECORD_MMAP for %s missing!\n", cmd);
+		goto out_err;
+	}
+
+	if (!found_libc_mmap) {
+		pr_debug("PERF_RECORD_MMAP for %s missing!\n", "libc");
+		goto out_err;
+	}
+
+	if (!found_ld_mmap) {
+		pr_debug("PERF_RECORD_MMAP for %s missing!\n", "ld");
+		goto out_err;
+	}
+
+	if (!found_vdso_mmap) {
+		pr_debug("PERF_RECORD_MMAP for %s missing!\n", "[vdso]");
+		goto out_err;
+	}
+
+	err = 0;
+out_err:
+	perf_evlist__munmap(evlist);
+out_free_cpu_mask:
+	CPU_FREE(cpu_mask);
+out_delete_evlist:
+	perf_evlist__delete(evlist);
+out:
+	return err;
+}
+
 static struct test {
 	const char *desc;
 	int (*func)(void);
@@ -866,6 +1199,10 @@ static struct test {
 		.func = test__parse_events,
 	},
 	{
+		.desc = "Validate PERF_RECORD_* events & perf_sample fields",
+		.func = test__PERF_RECORD,
+	},
+	{
 		.func = NULL,
 	},
 };

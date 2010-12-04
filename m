Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab0LDW1g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 17:27:36 -0500
Received: from canuck.infradead.org ([134.117.69.58]:44195 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238Ab0LDW1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 17:27:30 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
        Ian Munsie <imunsie@au1.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 5/5] perf tools: Ask for ID PERF_SAMPLE_ info on all PERF_RECORD_ events
Date: Sat,  4 Dec 2010 20:26:57 -0200
Message-Id: <1291501617-6966-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1291501617-6966-1-git-send-email-acme@infradead.org>
References: <1291501617-6966-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

So that we can use -T == --timestamp, asking for PERF_SAMPLE_TIME:

  $ perf record -aT
  $ perf report -D | grep PERF_RECORD_
  <SNIP>
   3   5951915425 0x47530 [0x58]: PERF_RECORD_SAMPLE(IP, 1): 16811/16811: 0xffffffff8138c1a2 period: 215979 cpu:3
   3   5952026879 0x47588 [0x90]: PERF_RECORD_SAMPLE(IP, 1): 16811/16811: 0xffffffff810cb480 period: 215979 cpu:3
   3   5952059959 0x47618 [0x38]: PERF_RECORD_FORK(6853:6853):(16811:16811)
   3   5952138878 0x47650 [0x78]: PERF_RECORD_SAMPLE(IP, 1): 16811/16811: 0xffffffff811bac35 period: 431478 cpu:3
   3   5952375068 0x476c8 [0x30]: PERF_RECORD_COMM: find:6853
   3   5952395923 0x476f8 [0x50]: PERF_RECORD_MMAP 6853/6853: [0x400000(0x25000) @ 0]: /usr/bin/find
   3   5952413756 0x47748 [0xa0]: PERF_RECORD_SAMPLE(IP, 1): 6853/6853: 0xffffffff810d080f period: 859332 cpu:3
   3   5952419837 0x477e8 [0x58]: PERF_RECORD_MMAP 6853/6853: [0x3f44600000(0x21d000) @ 0]: /lib64/ld-2.5.so
   3   5952437929 0x47840 [0x48]: PERF_RECORD_MMAP 6853/6853: [0x7fff7e1c9000(0x1000) @ 0x7fff7e1c9000]: [vdso]
   3   5952570127 0x47888 [0x58]: PERF_RECORD_MMAP 6853/6853: [0x3f46200000(0x218000) @ 0]: /lib64/libselinux.so.1
   3   5952623637 0x478e0 [0x58]: PERF_RECORD_MMAP 6853/6853: [0x3f44a00000(0x356000) @ 0]: /lib64/libc-2.5.so
   3   5952675720 0x47938 [0x58]: PERF_RECORD_MMAP 6853/6853: [0x3f44e00000(0x204000) @ 0]: /lib64/libdl-2.5.so
   3   5952710080 0x47990 [0x58]: PERF_RECORD_MMAP 6853/6853: [0x3f45a00000(0x246000) @ 0]: /lib64/libsepol.so.1
   3   5952847802 0x479e8 [0x58]: PERF_RECORD_SAMPLE(IP, 1): 6853/6853: 0xffffffff813897f0 period: 1142536 cpu:3
  <SNIP>

First column is the cpu and the second the timestamp.

That way we can investigate problems in the event stream.

If the new perf binary is run on an older kernel, it will disable this feature
automatically.

Tested-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ian Munsie <imunsie@au1.ibm.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Ian Munsie <imunsie@au1.ibm.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <1291318772-30880-5-git-send-email-acme@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-record.txt |    5 +
 tools/perf/builtin-record.c              |   16 ++
 tools/perf/builtin-top.c                 |   14 +-
 tools/perf/util/event.c                  |  285 +++++++++++++++++++++---------
 tools/perf/util/event.h                  |    7 +-
 tools/perf/util/header.c                 |   18 ++
 tools/perf/util/header.h                 |    1 +
 tools/perf/util/session.c                |   66 +++++++-
 tools/perf/util/session.h                |    3 +
 9 files changed, 315 insertions(+), 100 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 0ad1bc7..52462ae 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -108,6 +108,11 @@ OPTIONS
 --data::
 	Sample addresses.
 
+-T::
+--timestamp::
+	Sample timestamps. Use it with 'perf report -D' to see the timestamps,
+	for instance.
+
 -n::
 --no-samples::
 	Don't sample.
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index b34de92..699dd21 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -49,6 +49,7 @@ static const char		*output_name			= "perf.data";
 static int			group				=      0;
 static int			realtime_prio			=      0;
 static bool			raw_samples			=  false;
+static bool			sample_id_all_avail		=   true;
 static bool			system_wide			=  false;
 static pid_t			target_pid			=     -1;
 static pid_t			target_tid			=     -1;
@@ -61,6 +62,7 @@ static bool			call_graph			=  false;
 static bool			inherit_stat			=  false;
 static bool			no_samples			=  false;
 static bool			sample_address			=  false;
+static bool			sample_time			=  false;
 static bool			no_buildid			=  false;
 static bool			no_buildid_cache		=  false;
 
@@ -283,6 +285,9 @@ static void create_counter(int counter, int cpu)
 	if (system_wide)
 		attr->sample_type	|= PERF_SAMPLE_CPU;
 
+	if (sample_time)
+		attr->sample_type	|= PERF_SAMPLE_TIME;
+
 	if (raw_samples) {
 		attr->sample_type	|= PERF_SAMPLE_TIME;
 		attr->sample_type	|= PERF_SAMPLE_RAW;
@@ -299,6 +304,8 @@ static void create_counter(int counter, int cpu)
 		attr->disabled = 1;
 		attr->enable_on_exec = 1;
 	}
+retry_sample_id:
+	attr->sample_id_all = sample_id_all_avail ? 1 : 0;
 
 	for (thread_index = 0; thread_index < thread_num; thread_index++) {
 try_again:
@@ -315,6 +322,12 @@ try_again:
 			else if (err ==  ENODEV && cpu_list) {
 				die("No such device - did you specify"
 					" an out-of-range profile CPU?\n");
+			} else if (err == EINVAL && sample_id_all_avail) {
+				/*
+				 * Old kernel, no attr->sample_id_type_all field
+				 */
+				sample_id_all_avail = false;
+				goto retry_sample_id;
 			}
 
 			/*
@@ -661,6 +674,8 @@ static int __cmd_record(int argc, const char **argv)
 
 	post_processing_offset = lseek(output, 0, SEEK_CUR);
 
+	perf_session__set_sample_id_all(session, sample_id_all_avail);
+
 	if (pipe_output) {
 		err = event__synthesize_attrs(&session->header,
 					      process_synthesized_event,
@@ -841,6 +856,7 @@ const struct option record_options[] = {
 		    "per thread counts"),
 	OPT_BOOLEAN('d', "data", &sample_address,
 		    "Sample addresses"),
+	OPT_BOOLEAN('T', "timestamp", &sample_time, "Sample timestamps"),
 	OPT_BOOLEAN('n', "no-samples", &no_samples,
 		    "don't sample"),
 	OPT_BOOLEAN('N', "no-buildid-cache", &no_buildid_cache,
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 5aa29e1..0515ce9 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -977,12 +977,12 @@ static int symbol_filter(struct map *map, struct symbol *sym)
 }
 
 static void event__process_sample(const event_t *self,
-				 struct perf_session *session, int counter)
+				  struct sample_data *sample,
+				  struct perf_session *session, int counter)
 {
 	u64 ip = self->ip.ip;
 	struct sym_entry *syme;
 	struct addr_location al;
-	struct sample_data data;
 	struct machine *machine;
 	u8 origin = self->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 
@@ -1025,9 +1025,7 @@ static void event__process_sample(const event_t *self,
 	if (self->header.misc & PERF_RECORD_MISC_EXACT_IP)
 		exact_samples++;
 
-	event__parse_sample(self, session->sample_type, &data);
-
-	if (event__preprocess_sample(self, session, &al, &data,
+	if (event__preprocess_sample(self, session, &al, sample,
 				     symbol_filter) < 0 ||
 	    al.filtered)
 		return;
@@ -1107,6 +1105,7 @@ static void perf_session__mmap_read_counter(struct perf_session *self,
 	unsigned int head = mmap_read_head(md);
 	unsigned int old = md->prev;
 	unsigned char *data = md->base + page_size;
+	struct sample_data sample;
 	int diff;
 
 	/*
@@ -1154,10 +1153,11 @@ static void perf_session__mmap_read_counter(struct perf_session *self,
 			event = &event_copy;
 		}
 
+		event__parse_sample(event, self, &sample);
 		if (event->header.type == PERF_RECORD_SAMPLE)
-			event__process_sample(event, self, md->counter);
+			event__process_sample(event, &sample, self, md->counter);
 		else
-			event__process(event, NULL, self);
+			event__process(event, &sample, self);
 		old += size;
 	}
 
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 34510f4..e4cdc1e 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -33,11 +33,10 @@ static struct sample_data synth_sample = {
 	.period	   = 1,
 };
 
-static pid_t event__synthesize_comm(pid_t pid, int full,
+static pid_t event__synthesize_comm(event_t *event, pid_t pid, int full,
 				    event__handler_t process,
 				    struct perf_session *session)
 {
-	event_t ev;
 	char filename[PATH_MAX];
 	char bf[BUFSIZ];
 	FILE *fp;
@@ -58,34 +57,39 @@ out_race:
 		return 0;
 	}
 
-	memset(&ev.comm, 0, sizeof(ev.comm));
-	while (!ev.comm.comm[0] || !ev.comm.pid) {
-		if (fgets(bf, sizeof(bf), fp) == NULL)
-			goto out_failure;
+	memset(&event->comm, 0, sizeof(event->comm));
+
+	while (!event->comm.comm[0] || !event->comm.pid) {
+		if (fgets(bf, sizeof(bf), fp) == NULL) {
+			pr_warning("couldn't get COMM and pgid, malformed %s\n", filename);
+			goto out;
+		}
 
 		if (memcmp(bf, "Name:", 5) == 0) {
 			char *name = bf + 5;
 			while (*name && isspace(*name))
 				++name;
 			size = strlen(name) - 1;
-			memcpy(ev.comm.comm, name, size++);
+			memcpy(event->comm.comm, name, size++);
 		} else if (memcmp(bf, "Tgid:", 5) == 0) {
 			char *tgids = bf + 5;
 			while (*tgids && isspace(*tgids))
 				++tgids;
-			tgid = ev.comm.pid = atoi(tgids);
+			tgid = event->comm.pid = atoi(tgids);
 		}
 	}
 
-	ev.comm.header.type = PERF_RECORD_COMM;
+	event->comm.header.type = PERF_RECORD_COMM;
 	size = ALIGN(size, sizeof(u64));
-	ev.comm.header.size = sizeof(ev.comm) - (sizeof(ev.comm.comm) - size);
-
+	memset(event->comm.comm + size, 0, session->id_hdr_size);
+	event->comm.header.size = (sizeof(event->comm) -
+				(sizeof(event->comm.comm) - size) +
+				session->id_hdr_size);
 	if (!full) {
-		ev.comm.tid = pid;
+		event->comm.tid = pid;
 
-		process(&ev, &synth_sample, session);
-		goto out_fclose;
+		process(event, &synth_sample, session);
+		goto out;
 	}
 
 	snprintf(filename, sizeof(filename), "/proc/%d/task", pid);
@@ -100,22 +104,19 @@ out_race:
 		if (*end)
 			continue;
 
-		ev.comm.tid = pid;
+		event->comm.tid = pid;
 
-		process(&ev, &synth_sample, session);
+		process(event, &synth_sample, session);
 	}
-	closedir(tasks);
 
-out_fclose:
+	closedir(tasks);
+out:
 	fclose(fp);
-	return tgid;
 
-out_failure:
-	pr_warning("couldn't get COMM and pgid, malformed %s\n", filename);
-	return -1;
+	return tgid;
 }
 
-static int event__synthesize_mmap_events(pid_t pid, pid_t tgid,
+static int event__synthesize_mmap_events(event_t *event, pid_t pid, pid_t tgid,
 					 event__handler_t process,
 					 struct perf_session *session)
 {
@@ -133,29 +134,25 @@ static int event__synthesize_mmap_events(pid_t pid, pid_t tgid,
 		return -1;
 	}
 
+	event->header.type = PERF_RECORD_MMAP;
+	/*
+	 * Just like the kernel, see __perf_event_mmap in kernel/perf_event.c
+	 */
+	event->header.misc = PERF_RECORD_MISC_USER;
+
 	while (1) {
 		char bf[BUFSIZ], *pbf = bf;
-		event_t ev = {
-			.header = {
-				.type = PERF_RECORD_MMAP,
-				/*
-				 * Just like the kernel, see __perf_event_mmap
-				 * in kernel/perf_event.c
-				 */
-				.misc = PERF_RECORD_MISC_USER,
-			 },
-		};
 		int n;
 		size_t size;
 		if (fgets(bf, sizeof(bf), fp) == NULL)
 			break;
 
 		/* 00400000-0040c000 r-xp 00000000 fd:01 41038  /bin/cat */
-		n = hex2u64(pbf, &ev.mmap.start);
+		n = hex2u64(pbf, &event->mmap.start);
 		if (n < 0)
 			continue;
 		pbf += n + 1;
-		n = hex2u64(pbf, &ev.mmap.len);
+		n = hex2u64(pbf, &event->mmap.len);
 		if (n < 0)
 			continue;
 		pbf += n + 3;
@@ -170,19 +167,21 @@ static int event__synthesize_mmap_events(pid_t pid, pid_t tgid,
 				continue;
 
 			pbf += 3;
-			n = hex2u64(pbf, &ev.mmap.pgoff);
+			n = hex2u64(pbf, &event->mmap.pgoff);
 
 			size = strlen(execname);
 			execname[size - 1] = '\0'; /* Remove \n */
-			memcpy(ev.mmap.filename, execname, size);
+			memcpy(event->mmap.filename, execname, size);
 			size = ALIGN(size, sizeof(u64));
-			ev.mmap.len -= ev.mmap.start;
-			ev.mmap.header.size = (sizeof(ev.mmap) -
-					       (sizeof(ev.mmap.filename) - size));
-			ev.mmap.pid = tgid;
-			ev.mmap.tid = pid;
-
-			process(&ev, &synth_sample, session);
+			event->mmap.len -= event->mmap.start;
+			event->mmap.header.size = (sizeof(event->mmap) -
+					        (sizeof(event->mmap.filename) - size));
+			memset(event->mmap.filename + size, 0, session->id_hdr_size);
+			event->mmap.header.size += session->id_hdr_size;
+			event->mmap.pid = tgid;
+			event->mmap.tid = pid;
+
+			process(event, &synth_sample, session);
 		}
 	}
 
@@ -196,20 +195,27 @@ int event__synthesize_modules(event__handler_t process,
 {
 	struct rb_node *nd;
 	struct map_groups *kmaps = &machine->kmaps;
-	u16 misc;
+	event_t *event = zalloc(sizeof(event->mmap) + session->id_hdr_size);
+
+	if (event == NULL) {
+		pr_debug("Not enough memory synthesizing mmap event "
+			 "for kernel modules\n");
+		return -1;
+	}
+
+	event->header.type = PERF_RECORD_MMAP;
 
 	/*
 	 * kernel uses 0 for user space maps, see kernel/perf_event.c
 	 * __perf_event_mmap
 	 */
 	if (machine__is_host(machine))
-		misc = PERF_RECORD_MISC_KERNEL;
+		event->header.misc = PERF_RECORD_MISC_KERNEL;
 	else
-		misc = PERF_RECORD_MISC_GUEST_KERNEL;
+		event->header.misc = PERF_RECORD_MISC_GUEST_KERNEL;
 
 	for (nd = rb_first(&kmaps->maps[MAP__FUNCTION]);
 	     nd; nd = rb_next(nd)) {
-		event_t ev;
 		size_t size;
 		struct map *pos = rb_entry(nd, struct map, rb_node);
 
@@ -217,39 +223,78 @@ int event__synthesize_modules(event__handler_t process,
 			continue;
 
 		size = ALIGN(pos->dso->long_name_len + 1, sizeof(u64));
-		memset(&ev, 0, sizeof(ev));
-		ev.mmap.header.misc = misc;
-		ev.mmap.header.type = PERF_RECORD_MMAP;
-		ev.mmap.header.size = (sizeof(ev.mmap) -
-				        (sizeof(ev.mmap.filename) - size));
-		ev.mmap.start = pos->start;
-		ev.mmap.len   = pos->end - pos->start;
-		ev.mmap.pid   = machine->pid;
-
-		memcpy(ev.mmap.filename, pos->dso->long_name,
+		event->mmap.header.type = PERF_RECORD_MMAP;
+		event->mmap.header.size = (sizeof(event->mmap) -
+				        (sizeof(event->mmap.filename) - size));
+		memset(event->mmap.filename + size, 0, session->id_hdr_size);
+		event->mmap.header.size += session->id_hdr_size;
+		event->mmap.start = pos->start;
+		event->mmap.len   = pos->end - pos->start;
+		event->mmap.pid   = machine->pid;
+
+		memcpy(event->mmap.filename, pos->dso->long_name,
 		       pos->dso->long_name_len + 1);
-		process(&ev, &synth_sample, session);
+		process(event, &synth_sample, session);
 	}
 
+	free(event);
 	return 0;
 }
 
-int event__synthesize_thread(pid_t pid, event__handler_t process,
-			     struct perf_session *session)
+static int __event__synthesize_thread(event_t *comm_event, event_t *mmap_event,
+				      pid_t pid, event__handler_t process,
+				      struct perf_session *session)
 {
-	pid_t tgid = event__synthesize_comm(pid, 1, process, session);
+	pid_t tgid = event__synthesize_comm(comm_event, pid, 1, process,
+					    session);
 	if (tgid == -1)
 		return -1;
-	return event__synthesize_mmap_events(pid, tgid, process, session);
+	return event__synthesize_mmap_events(mmap_event, pid, tgid,
+					     process, session);
 }
 
-void event__synthesize_threads(event__handler_t process,
-			       struct perf_session *session)
+int event__synthesize_thread(pid_t pid, event__handler_t process,
+			     struct perf_session *session)
+{
+	event_t *comm_event, *mmap_event;
+	int err = -1;
+
+	comm_event = malloc(sizeof(comm_event->comm) + session->id_hdr_size);
+	if (comm_event == NULL)
+		goto out;
+
+	mmap_event = malloc(sizeof(mmap_event->mmap) + session->id_hdr_size);
+	if (mmap_event == NULL)
+		goto out_free_comm;
+
+	err = __event__synthesize_thread(comm_event, mmap_event, pid,
+					 process, session);
+	free(mmap_event);
+out_free_comm:
+	free(comm_event);
+out:
+	return err;
+}
+
+int event__synthesize_threads(event__handler_t process,
+			      struct perf_session *session)
 {
 	DIR *proc;
 	struct dirent dirent, *next;
+	event_t *comm_event, *mmap_event;
+	int err = -1;
+
+	comm_event = malloc(sizeof(comm_event->comm) + session->id_hdr_size);
+	if (comm_event == NULL)
+		goto out;
+
+	mmap_event = malloc(sizeof(mmap_event->mmap) + session->id_hdr_size);
+	if (mmap_event == NULL)
+		goto out_free_comm;
 
 	proc = opendir("/proc");
+	if (proc == NULL)
+		goto out_free_mmap;
 
 	while (!readdir_r(proc, &dirent, &next) && next) {
 		char *end;
@@ -258,10 +303,18 @@ void event__synthesize_threads(event__handler_t process,
 		if (*end) /* only interested in proper numerical dirents */
 			continue;
 
-		event__synthesize_thread(pid, process, session);
+		__event__synthesize_thread(comm_event, mmap_event, pid,
+					   process, session);
 	}
 
 	closedir(proc);
+	err = 0;
+out_free_mmap:
+	free(mmap_event);
+out_free_comm:
+	free(comm_event);
+out:
+	return err;
 }
 
 struct process_symbol_args {
@@ -295,18 +348,20 @@ int event__synthesize_kernel_mmap(event__handler_t process,
 	char path[PATH_MAX];
 	char name_buff[PATH_MAX];
 	struct map *map;
-
-	event_t ev = {
-		.header = {
-			.type = PERF_RECORD_MMAP,
-		},
-	};
+	int err;
 	/*
 	 * We should get this from /sys/kernel/sections/.text, but till that is
 	 * available use this, and after it is use this as a fallback for older
 	 * kernels.
 	 */
 	struct process_symbol_args args = { .name = symbol_name, };
+	event_t *event = zalloc(sizeof(event->mmap) + session->id_hdr_size);
+
+	if (event == NULL) {
+		pr_debug("Not enough memory synthesizing mmap event "
+			 "for kernel modules\n");
+		return -1;
+	}
 
 	mmap_name = machine__mmap_name(machine, name_buff, sizeof(name_buff));
 	if (machine__is_host(machine)) {
@@ -314,10 +369,10 @@ int event__synthesize_kernel_mmap(event__handler_t process,
 		 * kernel uses PERF_RECORD_MISC_USER for user space maps,
 		 * see kernel/perf_event.c __perf_event_mmap
 		 */
-		ev.header.misc = PERF_RECORD_MISC_KERNEL;
+		event->header.misc = PERF_RECORD_MISC_KERNEL;
 		filename = "/proc/kallsyms";
 	} else {
-		ev.header.misc = PERF_RECORD_MISC_GUEST_KERNEL;
+		event->header.misc = PERF_RECORD_MISC_GUEST_KERNEL;
 		if (machine__is_default_guest(machine))
 			filename = (char *) symbol_conf.default_guest_kallsyms;
 		else {
@@ -330,17 +385,21 @@ int event__synthesize_kernel_mmap(event__handler_t process,
 		return -ENOENT;
 
 	map = machine->vmlinux_maps[MAP__FUNCTION];
-	size = snprintf(ev.mmap.filename, sizeof(ev.mmap.filename),
+	size = snprintf(event->mmap.filename, sizeof(event->mmap.filename),
 			"%s%s", mmap_name, symbol_name) + 1;
 	size = ALIGN(size, sizeof(u64));
-	ev.mmap.header.size = (sizeof(ev.mmap) -
-			(sizeof(ev.mmap.filename) - size));
-	ev.mmap.pgoff = args.start;
-	ev.mmap.start = map->start;
-	ev.mmap.len   = map->end - ev.mmap.start;
-	ev.mmap.pid   = machine->pid;
-
-	return process(&ev, &synth_sample, session);
+	event->mmap.header.type = PERF_RECORD_MMAP;
+	event->mmap.header.size = (sizeof(event->mmap) -
+			(sizeof(event->mmap.filename) - size) + session->id_hdr_size);
+	event->mmap.pgoff = args.start;
+	event->mmap.start = map->start;
+	event->mmap.len   = map->end - event->mmap.start;
+	event->mmap.pid   = machine->pid;
+
+	err = process(event, &synth_sample, session);
+	free(event);
+
+	return err;
 }
 
 static void thread__comm_adjust(struct thread *self, struct hists *hists)
@@ -756,9 +815,65 @@ out_filtered:
 	return 0;
 }
 
-int event__parse_sample(const event_t *event, u64 type, struct sample_data *data)
+static int event__parse_id_sample(const event_t *event,
+				  struct perf_session *session,
+				  struct sample_data *sample)
 {
-	const u64 *array = event->sample.array;
+	const u64 *array;
+	u64 type;
+
+	sample->cpu = sample->pid = sample->tid = -1;
+	sample->stream_id = sample->id = sample->time = -1ULL;
+
+	if (!session->sample_id_all)
+		return 0;
+
+	array = event->sample.array;
+	array += ((event->header.size -
+		   sizeof(event->header)) / sizeof(u64)) - 1;
+	type = session->sample_type;
+
+	if (type & PERF_SAMPLE_CPU) {
+		u32 *p = (u32 *)array;
+		sample->cpu = *p;
+		array--;
+	}
+
+	if (type & PERF_SAMPLE_STREAM_ID) {
+		sample->stream_id = *array;
+		array--;
+	}
+
+	if (type & PERF_SAMPLE_ID) {
+		sample->id = *array;
+		array--;
+	}
+
+	if (type & PERF_SAMPLE_TIME) {
+		sample->time = *array;
+		array--;
+	}
+
+	if (type & PERF_SAMPLE_TID) {
+		u32 *p = (u32 *)array;
+		sample->pid = p[0];
+		sample->tid = p[1];
+	}
+
+	return 0;
+}
+
+int event__parse_sample(const event_t *event, struct perf_session *session,
+			struct sample_data *data)
+{
+	const u64 *array;
+	u64 type;
+
+	if (event->header.type != PERF_RECORD_SAMPLE)
+		return event__parse_id_sample(event, session, data);
+
+	array = event->sample.array;
+	type = session->sample_type;
 
 	if (type & PERF_SAMPLE_IP) {
 		data->ip = event->ip.ip;
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 08c400b..a95ab18 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -142,8 +142,8 @@ typedef int (*event__handler_t)(event_t *event, struct sample_data *sample,
 
 int event__synthesize_thread(pid_t pid, event__handler_t process,
 			     struct perf_session *session);
-void event__synthesize_threads(event__handler_t process,
-			       struct perf_session *session);
+int event__synthesize_threads(event__handler_t process,
+			      struct perf_session *session);
 int event__synthesize_kernel_mmap(event__handler_t process,
 				struct perf_session *session,
 				struct machine *machine,
@@ -168,7 +168,8 @@ struct addr_location;
 int event__preprocess_sample(const event_t *self, struct perf_session *session,
 			     struct addr_location *al, struct sample_data *data,
 			     symbol_filter_t filter);
-int event__parse_sample(const event_t *event, u64 type, struct sample_data *data);
+int event__parse_sample(const event_t *event, struct perf_session *session,
+			struct sample_data *sample);
 
 extern const char *event__name[];
 
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index fe652f3..073f0e1 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -946,6 +946,24 @@ u64 perf_header__sample_type(struct perf_header *header)
 	return type;
 }
 
+bool perf_header__sample_id_all(const struct perf_header *header)
+{
+	bool value = false, first = true;
+	int i;
+
+	for (i = 0; i < header->attrs; i++) {
+		struct perf_header_attr *attr = header->attr[i];
+
+		if (first) {
+			value = attr->attr.sample_id_all;
+			first = false;
+		} else if (value != attr->attr.sample_id_all)
+			die("non matching sample_id_all");
+	}
+
+	return value;
+}
+
 struct perf_event_attr *
 perf_header__find_attr(u64 id, struct perf_header *header)
 {
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index ed550bf..6335965 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -81,6 +81,7 @@ void perf_header_attr__delete(struct perf_header_attr *self);
 int perf_header_attr__add_id(struct perf_header_attr *self, u64 id);
 
 u64 perf_header__sample_type(struct perf_header *header);
+bool perf_header__sample_id_all(const struct perf_header *header);
 struct perf_event_attr *
 perf_header__find_attr(u64 id, struct perf_header *header);
 void perf_header__set_feat(struct perf_header *self, int feat);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 08ec018..5c75660 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -65,9 +65,37 @@ out_close:
 	return -1;
 }
 
-void perf_session__update_sample_type(struct perf_session *self)
+static void perf_session__id_header_size(struct perf_session *session)
 {
-	self->sample_type = perf_header__sample_type(&self->header);
+       struct sample_data *data;
+       u64 sample_type = session->sample_type;
+       u16 size = 0;
+
+	if (!session->sample_id_all)
+		goto out;
+
+       if (sample_type & PERF_SAMPLE_TID)
+               size += sizeof(data->tid) * 2;
+
+       if (sample_type & PERF_SAMPLE_TIME)
+               size += sizeof(data->time);
+
+       if (sample_type & PERF_SAMPLE_ID)
+               size += sizeof(data->id);
+
+       if (sample_type & PERF_SAMPLE_STREAM_ID)
+               size += sizeof(data->stream_id);
+
+       if (sample_type & PERF_SAMPLE_CPU)
+               size += sizeof(data->cpu) * 2;
+out:
+       session->id_hdr_size = size;
+}
+
+void perf_session__set_sample_id_all(struct perf_session *session, bool value)
+{
+	session->sample_id_all = value;
+	perf_session__id_header_size(session);
 }
 
 void perf_session__set_sample_type(struct perf_session *session, u64 type)
@@ -75,6 +103,13 @@ void perf_session__set_sample_type(struct perf_session *session, u64 type)
 	session->sample_type = type;
 }
 
+void perf_session__update_sample_type(struct perf_session *self)
+{
+	self->sample_type = perf_header__sample_type(&self->header);
+	self->sample_id_all = perf_header__sample_id_all(&self->header);
+	perf_session__id_header_size(self);
+}
+
 int perf_session__create_kernel_maps(struct perf_session *self)
 {
 	int ret = machine__create_kernel_maps(&self->host_machine);
@@ -443,7 +478,7 @@ static void flush_sample_queue(struct perf_session *s,
 		if (iter->timestamp > limit)
 			break;
 
-		event__parse_sample(iter->event, s->sample_type, &sample);
+		event__parse_sample(iter->event, s, &sample);
 		ops->sample(iter->event, &sample, s);
 
 		os->last_flush = iter->timestamp;
@@ -618,6 +653,23 @@ static void callchain__dump(struct sample_data *sample)
 		printf("..... %2d: %016Lx\n", i, sample->callchain->ips[i]);
 }
 
+static void perf_session__print_tstamp(struct perf_session *session,
+				       event_t *event,
+				       struct sample_data *sample)
+{
+	if (event->header.type != PERF_RECORD_SAMPLE &&
+	    !session->sample_id_all) {
+		fputs("-1 -1 ", stdout);
+		return;
+	}
+
+	if ((session->sample_type & PERF_SAMPLE_CPU))
+		printf("%u ", sample->cpu);
+
+	if (session->sample_type & PERF_SAMPLE_TIME)
+		printf("%Lu ", sample->time);
+}
+
 static int perf_session__process_event(struct perf_session *self,
 				       event_t *event,
 				       struct perf_event_ops *ops,
@@ -630,8 +682,12 @@ static int perf_session__process_event(struct perf_session *self,
 	if (self->header.needs_swap && event__swap_ops[event->header.type])
 		event__swap_ops[event->header.type](event);
 
-	if (event->header.type == PERF_RECORD_SAMPLE)
-		event__parse_sample(event, self->sample_type, &sample);
+	if (event->header.type >= PERF_RECORD_MMAP &&
+	    event->header.type <= PERF_RECORD_SAMPLE) {
+		event__parse_sample(event, self, &sample);
+		if (dump_trace)
+			perf_session__print_tstamp(self, event, &sample);
+	}
 
 	if (event->header.type < PERF_RECORD_HEADER_MAX) {
 		dump_printf("%#Lx [%#x]: PERF_RECORD_%s",
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 4578f86..ac36f99 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -46,6 +46,8 @@ struct perf_session {
 	int			fd;
 	bool			fd_pipe;
 	bool			repipe;
+	bool			sample_id_all;
+	u16			id_hdr_size;
 	int			cwdlen;
 	char			*cwd;
 	struct ordered_samples	ordered_samples;
@@ -106,6 +108,7 @@ int perf_session__create_kernel_maps(struct perf_session *self);
 
 int do_read(int fd, void *buf, size_t size);
 void perf_session__update_sample_type(struct perf_session *self);
+void perf_session__set_sample_id_all(struct perf_session *session, bool value);
 void perf_session__set_sample_type(struct perf_session *session, u64 type);
 void perf_session__remove_thread(struct perf_session *self, struct thread *th);
 
-- 
1.6.2.5


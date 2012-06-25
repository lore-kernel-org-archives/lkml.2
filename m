Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757738Ab2FYXU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 19:20:26 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:33888 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925Ab2FYXUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 19:20:22 -0400
Date: Mon, 25 Jun 2012 20:20:16 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Dmitry Antipov <dmitry.antipov@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Subject: Re: [PATCH] perf sched replay: fix event lookup
Message-ID: <20120625232016.GA28525@infradead.org>
References: <1339232758-920-1-git-send-email-dmitry.antipov@linaro.org>
 <87pq96pfj9.fsf@sejong.aot.lge.com>
 <20120611140852.GB2202@infradead.org>
 <8739616pc9.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
In-Reply-To: <8739616pc9.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Em Tue, Jun 12, 2012 at 03:01:26PM +0900, Namhyung Kim escreveu:
> On Mon, 11 Jun 2012 11:08:52 -0300, Arnaldo Carvalho de Melo wrote:
> > So I think we should have a per perf.data (perf_session) method that
> > knows that it shouldn't look _at all_ to /sys, but just at what came in
> > the perf.data file.
> >
> 
> Fair enough. The method should be a simple wrapper to libtraceevent APIs
> like this patch.

The pevent thing is per perf.data file, so I made it stop being static
and become a perf_session member, so tools processing perf.data files
use perf_session and _there_ we read the event into session->pevent and
then have to change everywhere to stop using that single global pevent
variable and use the per session one.

Dmitry, can you test the attached patch to check if it solves the
problems you reported?

Note that it _doesn't_ fall backs to trace__event_id, as we're not
interested at all in what is present in the
/sys/kernel/debug/tracing/events in the workstation doing the analysis,
just in what is in the perf.data file.

- Arnaldo

--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="per_session_pevent.patch"

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 547af48..4921429 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -57,6 +57,11 @@ static unsigned long nr_allocs, nr_cross_allocs;
 
 #define PATH_SYS_NODE	"/sys/devices/system/node"
 
+struct perf_kmem {
+	struct perf_tool    tool;
+	struct perf_session *session;
+};
+
 static void init_cpunode_map(void)
 {
 	FILE *fp;
@@ -278,14 +283,16 @@ static void process_free_event(void *data,
 	s_alloc->alloc_cpu = -1;
 }
 
-static void process_raw_event(union perf_event *raw_event __used, void *data,
+static void process_raw_event(struct perf_tool *tool,
+			      union perf_event *raw_event __used, void *data,
 			      int cpu, u64 timestamp, struct thread *thread)
 {
+	struct perf_kmem *kmem = container_of(tool, struct perf_kmem, tool);
 	struct event_format *event;
 	int type;
 
-	type = trace_parse_common_type(data);
-	event = trace_find_event(type);
+	type = trace_parse_common_type(kmem->session->pevent, data);
+	event = pevent_find_event(kmem->session->pevent, type);
 
 	if (!strcmp(event->name, "kmalloc") ||
 	    !strcmp(event->name, "kmem_cache_alloc")) {
@@ -306,7 +313,7 @@ static void process_raw_event(union perf_event *raw_event __used, void *data,
 	}
 }
 
-static int process_sample_event(struct perf_tool *tool __used,
+static int process_sample_event(struct perf_tool *tool,
 				union perf_event *event,
 				struct perf_sample *sample,
 				struct perf_evsel *evsel __used,
@@ -322,16 +329,18 @@ static int process_sample_event(struct perf_tool *tool __used,
 
 	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
 
-	process_raw_event(event, sample->raw_data, sample->cpu,
+	process_raw_event(tool, event, sample->raw_data, sample->cpu,
 			  sample->time, thread);
 
 	return 0;
 }
 
-static struct perf_tool perf_kmem = {
-	.sample			= process_sample_event,
-	.comm			= perf_event__process_comm,
-	.ordered_samples	= true,
+static struct perf_kmem perf_kmem = {
+	.tool = {
+		.sample			= process_sample_event,
+		.comm			= perf_event__process_comm,
+		.ordered_samples	= true,
+	},
 };
 
 static double fragmentation(unsigned long n_req, unsigned long n_alloc)
@@ -487,10 +496,12 @@ static int __cmd_kmem(void)
 {
 	int err = -EINVAL;
 	struct perf_session *session = perf_session__new(input_name, O_RDONLY,
-							 0, false, &perf_kmem);
+							 0, false, &perf_kmem.tool);
 	if (session == NULL)
 		return -ENOMEM;
 
+	perf_kmem.session = session;
+
 	if (perf_session__create_kernel_maps(session) < 0)
 		goto out_delete;
 
@@ -498,7 +509,7 @@ static int __cmd_kmem(void)
 		goto out_delete;
 
 	setup_pager();
-	err = perf_session__process_events(session, &perf_kmem);
+	err = perf_session__process_events(session, &perf_kmem.tool);
 	if (err != 0)
 		goto out_delete;
 	sort_result();
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index fd53319..b3c4285 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -724,8 +724,8 @@ process_raw_event(void *data, int cpu, u64 timestamp, struct thread *thread)
 	struct event_format *event;
 	int type;
 
-	type = trace_parse_common_type(data);
-	event = trace_find_event(type);
+	type = trace_parse_common_type(session->pevent, data);
+	event = pevent_find_event(session->pevent, type);
 
 	if (!strcmp(event->name, "lock_acquire"))
 		process_lock_acquire_event(data, event, cpu, timestamp, thread);
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 9fe77b1..472c0e8 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -43,6 +43,11 @@ static u64			sleep_measurement_overhead;
 
 static unsigned long		nr_tasks;
 
+struct perf_sched {
+	struct perf_tool    tool;
+	struct perf_session *session;
+};
+
 struct sched_atom;
 
 struct task_desc {
@@ -1597,6 +1602,7 @@ static int perf_sched__process_tracepoint_sample(struct perf_tool *tool,
 						 struct perf_evsel *evsel,
 						 struct machine *machine)
 {
+	struct perf_sched *sched = container_of(tool, struct perf_sched, tool);
 	struct thread *thread = machine__findnew_thread(machine, sample->pid);
 
 	if (thread == NULL) {
@@ -1612,7 +1618,8 @@ static int perf_sched__process_tracepoint_sample(struct perf_tool *tool,
 		tracepoint_handler f = evsel->handler.func;
 
 		if (evsel->handler.data == NULL)
-			evsel->handler.data = trace_find_event(evsel->attr.config);
+			evsel->handler.data = pevent_find_event(sched->session->pevent,
+								evsel->attr.config);
 
 		f(tool, evsel->handler.data, sample, machine, thread);
 	}
@@ -1620,12 +1627,14 @@ static int perf_sched__process_tracepoint_sample(struct perf_tool *tool,
 	return 0;
 }
 
-static struct perf_tool perf_sched = {
-	.sample			= perf_sched__process_tracepoint_sample,
-	.comm			= perf_event__process_comm,
-	.lost			= perf_event__process_lost,
-	.fork			= perf_event__process_task,
-	.ordered_samples	= true,
+static struct perf_sched perf_sched = {
+	.tool = {
+		.sample		 = perf_sched__process_tracepoint_sample,
+		.comm		 = perf_event__process_comm,
+		.lost		 = perf_event__process_lost,
+		.fork		 = perf_event__process_task,
+		.ordered_samples = true,
+	},
 };
 
 static void read_events(bool destroy, struct perf_session **psession)
@@ -1641,15 +1650,17 @@ static void read_events(bool destroy, struct perf_session **psession)
 		{ "sched:sched_migrate_task", process_sched_migrate_task_event, },
 	};
 	struct perf_session *session = perf_session__new(input_name, O_RDONLY,
-							 0, false, &perf_sched);
+							 0, false, &perf_sched.tool);
 	if (session == NULL)
 		die("No Memory");
 
-	err = perf_evlist__set_tracepoints_handlers_array(session->evlist, handlers);
+	perf_sched.session = session;
+
+	err = perf_session__set_tracepoints_handlers(session, handlers);
 	assert(err == 0);
 
 	if (perf_session__has_traces(session, "record -R")) {
-		err = perf_session__process_events(session, &perf_sched);
+		err = perf_session__process_events(session, &perf_sched.tool);
 		if (err)
 			die("Failed to process events, error %d", err);
 
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 8fecd3b..e3d5bbf 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -28,6 +28,11 @@ static bool			system_wide;
 static const char		*cpu_list;
 static DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
 
+struct perf_script {
+	struct perf_tool    tool;
+	struct perf_session *session;
+};
+
 enum perf_output_field {
 	PERF_OUTPUT_COMM            = 1U << 0,
 	PERF_OUTPUT_TID             = 1U << 1,
@@ -257,7 +262,8 @@ static int perf_session__check_output_opt(struct perf_session *session)
 	return 0;
 }
 
-static void print_sample_start(struct perf_sample *sample,
+static void print_sample_start(struct pevent *pevent,
+			       struct perf_sample *sample,
 			       struct thread *thread,
 			       struct perf_evsel *evsel)
 {
@@ -302,8 +308,13 @@ static void print_sample_start(struct perf_sample *sample,
 
 	if (PRINT_FIELD(EVNAME)) {
 		if (attr->type == PERF_TYPE_TRACEPOINT) {
-			type = trace_parse_common_type(sample->raw_data);
-			event = trace_find_event(type);
+			/*
+			 * XXX Do we really need this here?
+			 * perf_evlist__set_tracepoint_names should have done
+			 * this already
+			 */
+			type = trace_parse_common_type(pevent, sample->raw_data);
+			event = pevent_find_event(pevent, type);
 			if (event)
 				evname = event->name;
 		} else
@@ -404,6 +415,7 @@ static void print_sample_bts(union perf_event *event,
 }
 
 static void process_event(union perf_event *event __unused,
+			  struct pevent *pevent,
 			  struct perf_sample *sample,
 			  struct perf_evsel *evsel,
 			  struct machine *machine,
@@ -414,7 +426,7 @@ static void process_event(union perf_event *event __unused,
 	if (output[attr->type].fields == 0)
 		return;
 
-	print_sample_start(sample, thread, evsel);
+	print_sample_start(pevent, sample, thread, evsel);
 
 	if (is_bts_event(attr)) {
 		print_sample_bts(event, sample, evsel, machine, thread);
@@ -422,7 +434,7 @@ static void process_event(union perf_event *event __unused,
 	}
 
 	if (PRINT_FIELD(TRACE))
-		print_trace_event(sample->cpu, sample->raw_data,
+		print_trace_event(pevent, sample->cpu, sample->raw_data,
 				  sample->raw_size);
 
 	if (PRINT_FIELD(ADDR))
@@ -453,7 +465,8 @@ static int default_stop_script(void)
 	return 0;
 }
 
-static int default_generate_script(const char *outfile __unused)
+static int default_generate_script(struct pevent *pevent __unused,
+				   const char *outfile __unused)
 {
 	return 0;
 }
@@ -491,6 +504,7 @@ static int process_sample_event(struct perf_tool *tool __used,
 				struct machine *machine)
 {
 	struct addr_location al;
+	struct perf_script *script = container_of(tool, struct perf_script, tool);
 	struct thread *thread = machine__findnew_thread(machine, event->ip.tid);
 
 	if (thread == NULL) {
@@ -522,24 +536,27 @@ static int process_sample_event(struct perf_tool *tool __used,
 	if (cpu_list && !test_bit(sample->cpu, cpu_bitmap))
 		return 0;
 
-	scripting_ops->process_event(event, sample, evsel, machine, thread);
+	scripting_ops->process_event(event, script->session->pevent,
+				     sample, evsel, machine, thread);
 
 	evsel->hists.stats.total_period += sample->period;
 	return 0;
 }
 
-static struct perf_tool perf_script = {
-	.sample		 = process_sample_event,
-	.mmap		 = perf_event__process_mmap,
-	.comm		 = perf_event__process_comm,
-	.exit		 = perf_event__process_task,
-	.fork		 = perf_event__process_task,
-	.attr		 = perf_event__process_attr,
-	.event_type	 = perf_event__process_event_type,
-	.tracing_data	 = perf_event__process_tracing_data,
-	.build_id	 = perf_event__process_build_id,
-	.ordered_samples = true,
-	.ordering_requires_timestamps = true,
+static struct perf_script perf_script = {
+	.tool = {
+		.sample		 = process_sample_event,
+		.mmap		 = perf_event__process_mmap,
+		.comm		 = perf_event__process_comm,
+		.exit		 = perf_event__process_task,
+		.fork		 = perf_event__process_task,
+		.attr		 = perf_event__process_attr,
+		.event_type	 = perf_event__process_event_type,
+		.tracing_data	 = perf_event__process_tracing_data,
+		.build_id	 = perf_event__process_build_id,
+		.ordered_samples = true,
+		.ordering_requires_timestamps = true,
+	},
 };
 
 extern volatile int session_done;
@@ -555,7 +572,7 @@ static int __cmd_script(struct perf_session *session)
 
 	signal(SIGINT, sig_handler);
 
-	ret = perf_session__process_events(session, &perf_script);
+	ret = perf_session__process_events(session, &perf_script.tool);
 
 	if (debug_mode)
 		pr_err("Misordered timestamps: %" PRIu64 "\n", nr_unordered);
@@ -1337,10 +1354,12 @@ int cmd_script(int argc, const char **argv, const char *prefix __used)
 	if (!script_name)
 		setup_pager();
 
-	session = perf_session__new(input_name, O_RDONLY, 0, false, &perf_script);
+	session = perf_session__new(input_name, O_RDONLY, 0, false, &perf_script.tool);
 	if (session == NULL)
 		return -ENOMEM;
 
+	perf_script.session = session;
+
 	if (cpu_list) {
 		if (perf_session__cpu_bitmap(session, cpu_list, cpu_bitmap))
 			return -1;
@@ -1386,7 +1405,7 @@ int cmd_script(int argc, const char **argv, const char *prefix __used)
 			return -1;
 		}
 
-		err = scripting_ops->generate_script("perf-script");
+		err = scripting_ops->generate_script(session->pevent, "perf-script");
 		goto out;
 	}
 
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 7400fb3..a9c0cd4 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -224,8 +224,7 @@ out_free_attrs:
 	return err;
 }
 
-static struct perf_evsel *
-	perf_evlist__find_tracepoint_by_id(struct perf_evlist *evlist, int id)
+struct perf_evsel *perf_evlist__find_tracepoint_by_id(struct perf_evlist *evlist, int id)
 {
 	struct perf_evsel *evsel;
 
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 989bee9..8519bcc 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -73,6 +73,8 @@ int perf_evlist__set_tracepoints_handlers(struct perf_evlist *evlist,
 #define perf_evlist__set_tracepoints_handlers_array(evlist, array) \
 	perf_evlist__set_tracepoints_handlers(evlist, array, ARRAY_SIZE(array))
 
+struct perf_evsel *perf_evlist__find_tracepoint_by_id(struct perf_evlist *evlist, int id);
+
 void perf_evlist__id_add(struct perf_evlist *evlist, struct perf_evsel *evsel,
 			 int cpu, int thread, u64 id);
 
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index a5e2015..7e5af8d 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1474,15 +1474,15 @@ out:
 
 static int process_tracing_data(struct perf_file_section *section __unused,
 			      struct perf_header *ph __unused,
-			      int feat __unused, int fd)
+			      int feat __unused, int fd, void *data)
 {
-	trace_report(fd, false);
+	trace_report(fd, data, false);
 	return 0;
 }
 
 static int process_build_id(struct perf_file_section *section,
 			    struct perf_header *ph,
-			    int feat __unused, int fd)
+			    int feat __unused, int fd, void *data __used)
 {
 	if (perf_header__read_build_ids(ph, fd, section->offset, section->size))
 		pr_debug("Failed to read buildids, continuing...\n");
@@ -1493,7 +1493,7 @@ struct feature_ops {
 	int (*write)(int fd, struct perf_header *h, struct perf_evlist *evlist);
 	void (*print)(struct perf_header *h, int fd, FILE *fp);
 	int (*process)(struct perf_file_section *section,
-		       struct perf_header *h, int feat, int fd);
+		       struct perf_header *h, int feat, int fd, void *data);
 	const char *name;
 	bool full_only;
 };
@@ -1988,7 +1988,7 @@ int perf_file_header__read(struct perf_file_header *header,
 
 static int perf_file_section__process(struct perf_file_section *section,
 				      struct perf_header *ph,
-				      int feat, int fd, void *data __used)
+				      int feat, int fd, void *data)
 {
 	if (lseek(fd, section->offset, SEEK_SET) == (off_t)-1) {
 		pr_debug("Failed to lseek to %" PRIu64 " offset for feature "
@@ -2004,7 +2004,7 @@ static int perf_file_section__process(struct perf_file_section *section,
 	if (!feat_ops[feat].process)
 		return 0;
 
-	return feat_ops[feat].process(section, ph, feat, fd);
+	return feat_ops[feat].process(section, ph, feat, fd, data);
 }
 
 static int perf_file_header__read_pipe(struct perf_pipe_file_header *header,
@@ -2093,9 +2093,10 @@ static int read_attr(int fd, struct perf_header *ph,
 	return ret <= 0 ? -1 : 0;
 }
 
-static int perf_evsel__set_tracepoint_name(struct perf_evsel *evsel)
+static int perf_evsel__set_tracepoint_name(struct perf_evsel *evsel,
+					   struct pevent *pevent)
 {
-	struct event_format *event = trace_find_event(evsel->attr.config);
+	struct event_format *event = pevent_find_event(pevent, evsel->attr.config);
 	char bf[128];
 
 	if (event == NULL)
@@ -2109,13 +2110,14 @@ static int perf_evsel__set_tracepoint_name(struct perf_evsel *evsel)
 	return 0;
 }
 
-static int perf_evlist__set_tracepoint_names(struct perf_evlist *evlist)
+static int perf_evlist__set_tracepoint_names(struct perf_evlist *evlist,
+					     struct pevent *pevent)
 {
 	struct perf_evsel *pos;
 
 	list_for_each_entry(pos, &evlist->entries, node) {
 		if (pos->attr.type == PERF_TYPE_TRACEPOINT &&
-		    perf_evsel__set_tracepoint_name(pos))
+		    perf_evsel__set_tracepoint_name(pos, pevent))
 			return -1;
 	}
 
@@ -2198,12 +2200,12 @@ int perf_session__read_header(struct perf_session *session, int fd)
 		event_count =  f_header.event_types.size / sizeof(struct perf_trace_event_type);
 	}
 
-	perf_header__process_sections(header, fd, NULL,
+	perf_header__process_sections(header, fd, &session->pevent,
 				      perf_file_section__process);
 
 	lseek(fd, header->data_offset, SEEK_SET);
 
-	if (perf_evlist__set_tracepoint_names(session->evlist))
+	if (perf_evlist__set_tracepoint_names(session->evlist, session->pevent))
 		goto out_delete_evlist;
 
 	header->frozen = 1;
@@ -2419,7 +2421,7 @@ int perf_event__process_tracing_data(union perf_event *event,
 	lseek(session->fd, offset + sizeof(struct tracing_data_event),
 	      SEEK_SET);
 
-	size_read = trace_report(session->fd, session->repipe);
+	size_read = trace_report(session->fd, &session->pevent, session->repipe);
 
 	padding = ALIGN(size_read, sizeof(u64)) - size_read;
 
diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index 4c1b3d7..d865496 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -233,7 +233,7 @@ static void define_event_symbols(struct event_format *event,
 		define_event_symbols(event, ev_name, args->next);
 }
 
-static inline struct event_format *find_cache_event(int type)
+static inline struct event_format *find_cache_event(struct pevent *pevent, int type)
 {
 	static char ev_name[256];
 	struct event_format *event;
@@ -241,7 +241,7 @@ static inline struct event_format *find_cache_event(int type)
 	if (events[type])
 		return events[type];
 
-	events[type] = event = trace_find_event(type);
+	events[type] = event = pevent_find_event(pevent, type);
 	if (!event)
 		return NULL;
 
@@ -252,7 +252,8 @@ static inline struct event_format *find_cache_event(int type)
 	return event;
 }
 
-static void perl_process_tracepoint(union perf_event *pevent __unused,
+static void perl_process_tracepoint(union perf_event *perf_event __unused,
+				    struct pevent *pevent,
 				    struct perf_sample *sample,
 				    struct perf_evsel *evsel,
 				    struct machine *machine __unused,
@@ -275,13 +276,13 @@ static void perl_process_tracepoint(union perf_event *pevent __unused,
 	if (evsel->attr.type != PERF_TYPE_TRACEPOINT)
 		return;
 
-	type = trace_parse_common_type(data);
+	type = trace_parse_common_type(pevent, data);
 
-	event = find_cache_event(type);
+	event = find_cache_event(pevent, type);
 	if (!event)
 		die("ug! no event found for type %d", type);
 
-	pid = trace_parse_common_pid(data);
+	pid = trace_parse_common_pid(pevent, data);
 
 	sprintf(handler, "%s::%s", event->system, event->name);
 
@@ -314,7 +315,7 @@ static void perl_process_tracepoint(union perf_event *pevent __unused,
 				offset = field->offset;
 			XPUSHs(sv_2mortal(newSVpv((char *)data + offset, 0)));
 		} else { /* FIELD_IS_NUMERIC */
-			val = read_size(data + field->offset, field->size);
+			val = read_size(pevent, data + field->offset, field->size);
 			if (field->flags & FIELD_IS_SIGNED) {
 				XPUSHs(sv_2mortal(newSViv(val)));
 			} else {
@@ -368,14 +369,15 @@ static void perl_process_event_generic(union perf_event *pevent __unused,
 	LEAVE;
 }
 
-static void perl_process_event(union perf_event *pevent,
+static void perl_process_event(union perf_event *event,
+			       struct pevent *pevent,
 			       struct perf_sample *sample,
 			       struct perf_evsel *evsel,
 			       struct machine *machine,
 			       struct thread *thread)
 {
-	perl_process_tracepoint(pevent, sample, evsel, machine, thread);
-	perl_process_event_generic(pevent, sample, evsel, machine, thread);
+	perl_process_tracepoint(event, pevent, sample, evsel, machine, thread);
+	perl_process_event_generic(event, sample, evsel, machine, thread);
 }
 
 static void run_start_sub(void)
@@ -448,7 +450,7 @@ static int perl_stop_script(void)
 	return 0;
 }
 
-static int perl_generate_script(const char *outfile)
+static int perl_generate_script(struct pevent *pevent, const char *outfile)
 {
 	struct event_format *event = NULL;
 	struct format_field *f;
@@ -495,7 +497,7 @@ static int perl_generate_script(const char *outfile)
 	fprintf(ofp, "sub trace_begin\n{\n\t# optional\n}\n\n");
 	fprintf(ofp, "sub trace_end\n{\n\t# optional\n}\n\n");
 
-	while ((event = trace_find_next_event(event))) {
+	while ((event = trace_find_next_event(pevent, event))) {
 		fprintf(ofp, "sub %s::%s\n{\n", event->system, event->name);
 		fprintf(ofp, "\tmy (");
 
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index acb9795..c724fdf 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -190,7 +190,7 @@ static void define_event_symbols(struct event_format *event,
 		define_event_symbols(event, ev_name, args->next);
 }
 
-static inline struct event_format *find_cache_event(int type)
+static inline struct event_format *find_cache_event(struct pevent *pevent, int type)
 {
 	static char ev_name[256];
 	struct event_format *event;
@@ -198,7 +198,7 @@ static inline struct event_format *find_cache_event(int type)
 	if (events[type])
 		return events[type];
 
-	events[type] = event = trace_find_event(type);
+	events[type] = event = pevent_find_event(pevent, type);
 	if (!event)
 		return NULL;
 
@@ -209,7 +209,8 @@ static inline struct event_format *find_cache_event(int type)
 	return event;
 }
 
-static void python_process_event(union perf_event *pevent __unused,
+static void python_process_event(union perf_event *perf_event __unused,
+				 struct pevent *pevent,
 				 struct perf_sample *sample,
 				 struct perf_evsel *evsel __unused,
 				 struct machine *machine __unused,
@@ -233,13 +234,13 @@ static void python_process_event(union perf_event *pevent __unused,
 	if (!t)
 		Py_FatalError("couldn't create Python tuple");
 
-	type = trace_parse_common_type(data);
+	type = trace_parse_common_type(pevent, data);
 
-	event = find_cache_event(type);
+	event = find_cache_event(pevent, type);
 	if (!event)
 		die("ug! no event found for type %d", type);
 
-	pid = trace_parse_common_pid(data);
+	pid = trace_parse_common_pid(pevent, data);
 
 	sprintf(handler_name, "%s__%s", event->system, event->name);
 
@@ -284,7 +285,7 @@ static void python_process_event(union perf_event *pevent __unused,
 				offset = field->offset;
 			obj = PyString_FromString((char *)data + offset);
 		} else { /* FIELD_IS_NUMERIC */
-			val = read_size(data + field->offset, field->size);
+			val = read_size(pevent, data + field->offset, field->size);
 			if (field->flags & FIELD_IS_SIGNED) {
 				if ((long long)val >= LONG_MIN &&
 				    (long long)val <= LONG_MAX)
@@ -438,7 +439,7 @@ out:
 	return err;
 }
 
-static int python_generate_script(const char *outfile)
+static int python_generate_script(struct pevent *pevent, const char *outfile)
 {
 	struct event_format *event = NULL;
 	struct format_field *f;
@@ -487,7 +488,7 @@ static int python_generate_script(const char *outfile)
 	fprintf(ofp, "def trace_end():\n");
 	fprintf(ofp, "\tprint \"in trace_end\"\n\n");
 
-	while ((event = trace_find_next_event(event))) {
+	while ((event = trace_find_next_event(pevent, event))) {
 		fprintf(ofp, "def %s__%s(", event->system, event->name);
 		fprintf(ofp, "event_name, ");
 		fprintf(ofp, "context, ");
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 6b305fb..99329c9 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -14,6 +14,7 @@
 #include "sort.h"
 #include "util.h"
 #include "cpumap.h"
+#include "event-parse.h"
 
 static int perf_session__open(struct perf_session *self, bool force)
 {
@@ -1610,3 +1611,57 @@ void perf_session__fprintf_info(struct perf_session *session, FILE *fp,
 	perf_header__fprintf_info(session, fp, full);
 	fprintf(fp, "# ========\n#\n");
 }
+
+
+int __perf_session__set_tracepoints_handlers(struct perf_session *session,
+					     const struct perf_evsel_str_handler *assocs,
+					     size_t nr_assocs)
+{
+	struct perf_evlist *evlist = session->evlist;
+	struct event_format *format;
+	struct perf_evsel *evsel;
+	char *tracepoint, *name;
+	size_t i;
+	int err;
+
+	for (i = 0; i < nr_assocs; i++) {
+		err = -ENOMEM;
+		tracepoint = strdup(assocs[i].name);
+		if (tracepoint == NULL)
+			goto out;
+
+		err = -ENOENT;
+		name = strchr(tracepoint, ':');
+		if (name == NULL)
+                       goto out_free;
+
+		*name++ = '\0';
+		format = pevent_find_event_by_name(session->pevent, tracepoint, name);
+		if (format == NULL) {
+			/*
+ 			 * Adding a handler for an event not in the session,
+ 			 * just ignore it.
+ 			 */
+			goto next;
+		}
+
+		evsel = perf_evlist__find_tracepoint_by_id(evlist, format->id);
+		if (evsel == NULL)
+			goto next;
+
+		err = -EEXIST;
+		if (evsel->handler.func != NULL)
+			goto out_free;
+		evsel->handler.func = assocs[i].handler;
+next:
+		free(tracepoint);
+	}
+
+	err = 0;
+out:
+	return err;
+
+out_free:
+	free(tracepoint);
+	goto out;
+}
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index c71a1a7..7c435bd 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -33,6 +33,7 @@ struct perf_session {
 	struct machine		host_machine;
 	struct rb_root		machines;
 	struct perf_evlist	*evlist;
+	struct pevent		*pevent;
 	/*
 	 * FIXME: Need to split this up further, we need global
 	 *	  stats + per event stats. 'perf diff' also needs
@@ -158,4 +159,13 @@ int perf_session__cpu_bitmap(struct perf_session *session,
 			     const char *cpu_list, unsigned long *cpu_bitmap);
 
 void perf_session__fprintf_info(struct perf_session *s, FILE *fp, bool full);
+
+struct perf_evsel_str_handler;
+
+int __perf_session__set_tracepoints_handlers(struct perf_session *session,
+					     const struct perf_evsel_str_handler *assocs,
+					     size_t nr_assocs);
+
+#define perf_session__set_tracepoints_handlers(session, array) \
+	__perf_session__set_tracepoints_handlers(session, array, ARRAY_SIZE(array))
 #endif /* __PERF_SESSION_H */
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index df2fddb..2a6b32c 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -32,29 +32,25 @@ int header_page_size_size;
 int header_page_ts_size;
 int header_page_data_offset;
 
-struct pevent *perf_pevent;
-static struct pevent *pevent;
-
 bool latency_format;
 
-int read_trace_init(int file_bigendian, int host_bigendian)
+struct pevent *read_trace_init(int file_bigendian, int host_bigendian)
 {
-	if (pevent)
-		return 0;
-
-	perf_pevent = pevent_alloc();
-	pevent = perf_pevent;
+	struct pevent *pevent = pevent_alloc();
 
-	pevent_set_flag(pevent, PEVENT_NSEC_OUTPUT);
-	pevent_set_file_bigendian(pevent, file_bigendian);
-	pevent_set_host_bigendian(pevent, host_bigendian);
+	if (pevent != NULL) {
+		pevent_set_flag(pevent, PEVENT_NSEC_OUTPUT);
+		pevent_set_file_bigendian(pevent, file_bigendian);
+		pevent_set_host_bigendian(pevent, host_bigendian);
+	}
 
-	return 0;
+	return pevent;
 }
 
 static int get_common_field(struct scripting_context *context,
 			    int *offset, int *size, const char *type)
 {
+	struct pevent *pevent = context->pevent;
 	struct event_format *event;
 	struct format_field *field;
 
@@ -150,7 +146,7 @@ void *raw_field_ptr(struct event_format *event, const char *name, void *data)
 	return data + field->offset;
 }
 
-int trace_parse_common_type(void *data)
+int trace_parse_common_type(struct pevent *pevent, void *data)
 {
 	struct pevent_record record;
 
@@ -158,7 +154,7 @@ int trace_parse_common_type(void *data)
 	return pevent_data_type(pevent, &record);
 }
 
-int trace_parse_common_pid(void *data)
+int trace_parse_common_pid(struct pevent *pevent, void *data)
 {
 	struct pevent_record record;
 
@@ -166,27 +162,21 @@ int trace_parse_common_pid(void *data)
 	return pevent_data_pid(pevent, &record);
 }
 
-unsigned long long read_size(void *ptr, int size)
+unsigned long long read_size(struct pevent *pevent, void *ptr, int size)
 {
 	return pevent_read_number(pevent, ptr, size);
 }
 
-struct event_format *trace_find_event(int type)
-{
-	return pevent_find_event(pevent, type);
-}
-
-
-void print_trace_event(int cpu, void *data, int size)
+void print_trace_event(struct pevent *pevent, int cpu, void *data, int size)
 {
 	struct event_format *event;
 	struct pevent_record record;
 	struct trace_seq s;
 	int type;
 
-	type = trace_parse_common_type(data);
+	type = trace_parse_common_type(pevent, data);
 
-	event = trace_find_event(type);
+	event = pevent_find_event(pevent, type);
 	if (!event) {
 		warning("ug! no event found for type %d", type);
 		return;
@@ -203,8 +193,8 @@ void print_trace_event(int cpu, void *data, int size)
 	printf("\n");
 }
 
-void print_event(int cpu, void *data, int size, unsigned long long nsecs,
-		  char *comm)
+void print_event(struct pevent *pevent, int cpu, void *data, int size,
+		 unsigned long long nsecs, char *comm)
 {
 	struct pevent_record record;
 	struct trace_seq s;
@@ -227,7 +217,7 @@ void print_event(int cpu, void *data, int size, unsigned long long nsecs,
 	printf("\n");
 }
 
-void parse_proc_kallsyms(char *file, unsigned int size __unused)
+void parse_proc_kallsyms(struct pevent *pevent, char *file, unsigned int size __unused)
 {
 	unsigned long long addr;
 	char *func;
@@ -258,7 +248,7 @@ void parse_proc_kallsyms(char *file, unsigned int size __unused)
 	}
 }
 
-void parse_ftrace_printk(char *file, unsigned int size __unused)
+void parse_ftrace_printk(struct pevent *pevent, char *file, unsigned int size __unused)
 {
 	unsigned long long addr;
 	char *printk;
@@ -282,17 +272,18 @@ void parse_ftrace_printk(char *file, unsigned int size __unused)
 	}
 }
 
-int parse_ftrace_file(char *buf, unsigned long size)
+int parse_ftrace_file(struct pevent *pevent, char *buf, unsigned long size)
 {
 	return pevent_parse_event(pevent, buf, size, "ftrace");
 }
 
-int parse_event_file(char *buf, unsigned long size, char *sys)
+int parse_event_file(struct pevent *pevent, char *buf, unsigned long size, char *sys)
 {
 	return pevent_parse_event(pevent, buf, size, sys);
 }
 
-struct event_format *trace_find_next_event(struct event_format *event)
+struct event_format *trace_find_next_event(struct pevent *pevent,
+					   struct event_format *event)
 {
 	static int idx;
 
diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index f097e0d..24539f4 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -114,20 +114,20 @@ static void skip(int size)
 	};
 }
 
-static unsigned int read4(void)
+static unsigned int read4(struct pevent *pevent)
 {
 	unsigned int data;
 
 	read_or_die(&data, 4);
-	return __data2host4(perf_pevent, data);
+	return __data2host4(pevent, data);
 }
 
-static unsigned long long read8(void)
+static unsigned long long read8(struct pevent *pevent)
 {
 	unsigned long long data;
 
 	read_or_die(&data, 8);
-	return __data2host8(perf_pevent, data);
+	return __data2host8(pevent, data);
 }
 
 static char *read_string(void)
@@ -168,12 +168,12 @@ static char *read_string(void)
 	return str;
 }
 
-static void read_proc_kallsyms(void)
+static void read_proc_kallsyms(struct pevent *pevent)
 {
 	unsigned int size;
 	char *buf;
 
-	size = read4();
+	size = read4(pevent);
 	if (!size)
 		return;
 
@@ -181,29 +181,29 @@ static void read_proc_kallsyms(void)
 	read_or_die(buf, size);
 	buf[size] = '\0';
 
-	parse_proc_kallsyms(buf, size);
+	parse_proc_kallsyms(pevent, buf, size);
 
 	free(buf);
 }
 
-static void read_ftrace_printk(void)
+static void read_ftrace_printk(struct pevent *pevent)
 {
 	unsigned int size;
 	char *buf;
 
-	size = read4();
+	size = read4(pevent);
 	if (!size)
 		return;
 
 	buf = malloc_or_die(size);
 	read_or_die(buf, size);
 
-	parse_ftrace_printk(buf, size);
+	parse_ftrace_printk(pevent, buf, size);
 
 	free(buf);
 }
 
-static void read_header_files(void)
+static void read_header_files(struct pevent *pevent)
 {
 	unsigned long long size;
 	char *header_event;
@@ -214,7 +214,7 @@ static void read_header_files(void)
 	if (memcmp(buf, "header_page", 12) != 0)
 		die("did not read header page");
 
-	size = read8();
+	size = read8(pevent);
 	skip(size);
 
 	/*
@@ -227,47 +227,47 @@ static void read_header_files(void)
 	if (memcmp(buf, "header_event", 13) != 0)
 		die("did not read header event");
 
-	size = read8();
+	size = read8(pevent);
 	header_event = malloc_or_die(size);
 	read_or_die(header_event, size);
 	free(header_event);
 }
 
-static void read_ftrace_file(unsigned long long size)
+static void read_ftrace_file(struct pevent *pevent, unsigned long long size)
 {
 	char *buf;
 
 	buf = malloc_or_die(size);
 	read_or_die(buf, size);
-	parse_ftrace_file(buf, size);
+	parse_ftrace_file(pevent, buf, size);
 	free(buf);
 }
 
-static void read_event_file(char *sys, unsigned long long size)
+static void read_event_file(struct pevent *pevent, char *sys, unsigned long long size)
 {
 	char *buf;
 
 	buf = malloc_or_die(size);
 	read_or_die(buf, size);
-	parse_event_file(buf, size, sys);
+	parse_event_file(pevent, buf, size, sys);
 	free(buf);
 }
 
-static void read_ftrace_files(void)
+static void read_ftrace_files(struct pevent *pevent)
 {
 	unsigned long long size;
 	int count;
 	int i;
 
-	count = read4();
+	count = read4(pevent);
 
 	for (i = 0; i < count; i++) {
-		size = read8();
-		read_ftrace_file(size);
+		size = read8(pevent);
+		read_ftrace_file(pevent, size);
 	}
 }
 
-static void read_event_files(void)
+static void read_event_files(struct pevent *pevent)
 {
 	unsigned long long size;
 	char *sys;
@@ -275,15 +275,15 @@ static void read_event_files(void)
 	int count;
 	int i,x;
 
-	systems = read4();
+	systems = read4(pevent);
 
 	for (i = 0; i < systems; i++) {
 		sys = read_string();
 
-		count = read4();
+		count = read4(pevent);
 		for (x=0; x < count; x++) {
-			size = read8();
-			read_event_file(sys, size);
+			size = read8(pevent);
+			read_event_file(pevent, sys, size);
 		}
 	}
 }
@@ -377,7 +377,7 @@ static int calc_index(void *ptr, int cpu)
 	return (unsigned long)ptr - (unsigned long)cpu_data[cpu].page;
 }
 
-struct pevent_record *trace_peek_data(int cpu)
+struct pevent_record *trace_peek_data(struct pevent *pevent, int cpu)
 {
 	struct pevent_record *data;
 	void *page = cpu_data[cpu].page;
@@ -399,15 +399,15 @@ struct pevent_record *trace_peek_data(int cpu)
 		/* FIXME: handle header page */
 		if (header_page_ts_size != 8)
 			die("expected a long long type for timestamp");
-		cpu_data[cpu].timestamp = data2host8(perf_pevent, ptr);
+		cpu_data[cpu].timestamp = data2host8(pevent, ptr);
 		ptr += 8;
 		switch (header_page_size_size) {
 		case 4:
-			cpu_data[cpu].page_size = data2host4(perf_pevent, ptr);
+			cpu_data[cpu].page_size = data2host4(pevent, ptr);
 			ptr += 4;
 			break;
 		case 8:
-			cpu_data[cpu].page_size = data2host8(perf_pevent, ptr);
+			cpu_data[cpu].page_size = data2host8(pevent, ptr);
 			ptr += 8;
 			break;
 		default:
@@ -421,10 +421,10 @@ read_again:
 
 	if (idx >= cpu_data[cpu].page_size) {
 		get_next_page(cpu);
-		return trace_peek_data(cpu);
+		return trace_peek_data(pevent, cpu);
 	}
 
-	type_len_ts = data2host4(perf_pevent, ptr);
+	type_len_ts = data2host4(pevent, ptr);
 	ptr += 4;
 
 	type_len = type_len4host(type_len_ts);
@@ -434,14 +434,14 @@ read_again:
 	case RINGBUF_TYPE_PADDING:
 		if (!delta)
 			die("error, hit unexpected end of page");
-		length = data2host4(perf_pevent, ptr);
+		length = data2host4(pevent, ptr);
 		ptr += 4;
 		length *= 4;
 		ptr += length;
 		goto read_again;
 
 	case RINGBUF_TYPE_TIME_EXTEND:
-		extend = data2host4(perf_pevent, ptr);
+		extend = data2host4(pevent, ptr);
 		ptr += 4;
 		extend <<= TS_SHIFT;
 		extend += delta;
@@ -452,7 +452,7 @@ read_again:
 		ptr += 12;
 		break;
 	case 0:
-		length = data2host4(perf_pevent, ptr);
+		length = data2host4(pevent, ptr);
 		ptr += 4;
 		die("here! length=%d", length);
 		break;
@@ -477,17 +477,17 @@ read_again:
 	return data;
 }
 
-struct pevent_record *trace_read_data(int cpu)
+struct pevent_record *trace_read_data(struct pevent *pevent, int cpu)
 {
 	struct pevent_record *data;
 
-	data = trace_peek_data(cpu);
+	data = trace_peek_data(pevent, cpu);
 	cpu_data[cpu].next = NULL;
 
 	return data;
 }
 
-ssize_t trace_report(int fd, bool __repipe)
+ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
 {
 	char buf[BUFSIZ];
 	char test[] = { 23, 8, 68 };
@@ -519,30 +519,32 @@ ssize_t trace_report(int fd, bool __repipe)
 	file_bigendian = buf[0];
 	host_bigendian = bigendian();
 
-	read_trace_init(file_bigendian, host_bigendian);
+	*ppevent = read_trace_init(file_bigendian, host_bigendian);
+	if (*ppevent == NULL)
+		die("read_trace_init failed");
 
 	read_or_die(buf, 1);
 	long_size = buf[0];
 
-	page_size = read4();
+	page_size = read4(*ppevent);
 
-	read_header_files();
+	read_header_files(*ppevent);
 
-	read_ftrace_files();
-	read_event_files();
-	read_proc_kallsyms();
-	read_ftrace_printk();
+	read_ftrace_files(*ppevent);
+	read_event_files(*ppevent);
+	read_proc_kallsyms(*ppevent);
+	read_ftrace_printk(*ppevent);
 
 	size = calc_data_size - 1;
 	calc_data_size = 0;
 	repipe = false;
 
 	if (show_funcs) {
-		pevent_print_funcs(perf_pevent);
+		pevent_print_funcs(*ppevent);
 		return size;
 	}
 	if (show_printk) {
-		pevent_print_printk(perf_pevent);
+		pevent_print_printk(*ppevent);
 		return size;
 	}
 
diff --git a/tools/perf/util/trace-event-scripting.c b/tools/perf/util/trace-event-scripting.c
index 18ae6c1..474aa7a 100644
--- a/tools/perf/util/trace-event-scripting.c
+++ b/tools/perf/util/trace-event-scripting.c
@@ -36,6 +36,7 @@ static int stop_script_unsupported(void)
 }
 
 static void process_event_unsupported(union perf_event *event __unused,
+				      struct pevent *pevent __unused,
 				      struct perf_sample *sample __unused,
 				      struct perf_evsel *evsel __unused,
 				      struct machine *machine __unused,
@@ -61,7 +62,8 @@ static int python_start_script_unsupported(const char *script __unused,
 	return -1;
 }
 
-static int python_generate_script_unsupported(const char *outfile __unused)
+static int python_generate_script_unsupported(struct pevent *pevent __unused,
+					      const char *outfile __unused)
 {
 	print_python_unsupported_msg();
 
@@ -122,7 +124,8 @@ static int perl_start_script_unsupported(const char *script __unused,
 	return -1;
 }
 
-static int perl_generate_script_unsupported(const char *outfile __unused)
+static int perl_generate_script_unsupported(struct pevent *pevent __unused,
+					    const char *outfile __unused)
 {
 	print_perl_unsupported_msg();
 
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 639852a..1797822 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -8,6 +8,7 @@
 struct machine;
 struct perf_sample;
 union perf_event;
+struct perf_tool;
 struct thread;
 
 extern int header_page_size_size;
@@ -29,35 +30,34 @@ enum {
 
 int bigendian(void);
 
-int read_trace_init(int file_bigendian, int host_bigendian);
-void print_trace_event(int cpu, void *data, int size);
+struct pevent *read_trace_init(int file_bigendian, int host_bigendian);
+void print_trace_event(struct pevent *pevent, int cpu, void *data, int size);
 
-void print_event(int cpu, void *data, int size, unsigned long long nsecs,
-		  char *comm);
+void print_event(struct pevent *pevent, int cpu, void *data, int size,
+		 unsigned long long nsecs, char *comm);
 
-int parse_ftrace_file(char *buf, unsigned long size);
-int parse_event_file(char *buf, unsigned long size, char *sys);
+int parse_ftrace_file(struct pevent *pevent, char *buf, unsigned long size);
+int parse_event_file(struct pevent *pevent, char *buf, unsigned long size, char *sys);
 
-struct pevent_record *trace_peek_data(int cpu);
-struct event_format *trace_find_event(int type);
+struct pevent_record *trace_peek_data(struct pevent *pevent, int cpu);
 
 unsigned long long
 raw_field_value(struct event_format *event, const char *name, void *data);
 void *raw_field_ptr(struct event_format *event, const char *name, void *data);
 
-void parse_proc_kallsyms(char *file, unsigned int size __unused);
-void parse_ftrace_printk(char *file, unsigned int size __unused);
+void parse_proc_kallsyms(struct pevent *pevent, char *file, unsigned int size __unused);
+void parse_ftrace_printk(struct pevent *pevent, char *file, unsigned int size __unused);
 
-ssize_t trace_report(int fd, bool repipe);
+ssize_t trace_report(int fd, struct pevent **pevent, bool repipe);
 
-int trace_parse_common_type(void *data);
-int trace_parse_common_pid(void *data);
+int trace_parse_common_type(struct pevent *pevent, void *data);
+int trace_parse_common_pid(struct pevent *pevent, void *data);
 
-struct event_format *trace_find_next_event(struct event_format *event);
-unsigned long long read_size(void *ptr, int size);
+struct event_format *trace_find_next_event(struct pevent *pevent, struct event_format *event);
+unsigned long long read_size(struct pevent *pevent, void *ptr, int size);
 unsigned long long eval_flag(const char *flag);
 
-struct pevent_record *trace_read_data(int cpu);
+struct pevent_record *trace_read_data(struct pevent *pevent, int cpu);
 int read_tracing_data(int fd, struct list_head *pattrs);
 
 struct tracing_data {
@@ -77,11 +77,12 @@ struct scripting_ops {
 	int (*start_script) (const char *script, int argc, const char **argv);
 	int (*stop_script) (void);
 	void (*process_event) (union perf_event *event,
+			       struct pevent *pevent,
 			       struct perf_sample *sample,
 			       struct perf_evsel *evsel,
 			       struct machine *machine,
 			       struct thread *thread);
-	int (*generate_script) (const char *outfile);
+	int (*generate_script) (struct pevent *pevent, const char *outfile);
 };
 
 int script_spec_register(const char *spec, struct scripting_ops *ops);
@@ -90,6 +91,7 @@ void setup_perl_scripting(void);
 void setup_python_scripting(void);
 
 struct scripting_context {
+	struct pevent *pevent;
 	void *event_data;
 };
 

--k+w/mQv8wyuph6w0--

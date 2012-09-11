Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550Ab2IKXyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 19:54:15 -0400
Received: from [205.233.59.134] ([205.233.59.134]:37398 "EHLO
	merlin.infradead.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755230Ab2IKXyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 19:54:11 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 03/18] perf kmem: Remove die() calls
Date: Tue, 11 Sep 2012 20:52:55 -0300
Message-Id: <1347407590-30960-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1347407590-30960-1-git-send-email-acme@infradead.org>
References: <1347407590-30960-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Just use pr_err() + return -1 and perf_session__process_events to abort
when some event would call die(), then let the perf's main() exit doing
whatever it needs.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-i7rhuqfwshjiwc9gr9m1vov4@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kmem.c |  108 ++++++++++++++++++++++++++++-----------------
 1 file changed, 67 insertions(+), 41 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index fc6607b..ad9f520 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -58,41 +58,52 @@ static unsigned long nr_allocs, nr_cross_allocs;
 
 #define PATH_SYS_NODE	"/sys/devices/system/node"
 
-static void init_cpunode_map(void)
+static int init_cpunode_map(void)
 {
 	FILE *fp;
-	int i;
+	int i, err = -1;
 
 	fp = fopen("/sys/devices/system/cpu/kernel_max", "r");
 	if (!fp) {
 		max_cpu_num = 4096;
-		return;
+		return 0;
+	}
+
+	if (fscanf(fp, "%d", &max_cpu_num) < 1) {
+		pr_err("Failed to read 'kernel_max' from sysfs");
+		goto out_close;
 	}
 
-	if (fscanf(fp, "%d", &max_cpu_num) < 1)
-		die("Failed to read 'kernel_max' from sysfs");
 	max_cpu_num++;
 
 	cpunode_map = calloc(max_cpu_num, sizeof(int));
-	if (!cpunode_map)
-		die("calloc");
+	if (!cpunode_map) {
+		pr_err("%s: calloc failed\n", __func__);
+		goto out_close;
+	}
+
 	for (i = 0; i < max_cpu_num; i++)
 		cpunode_map[i] = -1;
+
+	err = 0;
+out_close:
 	fclose(fp);
+	return err;
 }
 
-static void setup_cpunode_map(void)
+static int setup_cpunode_map(void)
 {
 	struct dirent *dent1, *dent2;
 	DIR *dir1, *dir2;
 	unsigned int cpu, mem;
 	char buf[PATH_MAX];
 
-	init_cpunode_map();
+	if (init_cpunode_map())
+		return -1;
 
 	dir1 = opendir(PATH_SYS_NODE);
 	if (!dir1)
-		return;
+		return -1;
 
 	while ((dent1 = readdir(dir1)) != NULL) {
 		if (dent1->d_type != DT_DIR ||
@@ -112,10 +123,11 @@ static void setup_cpunode_map(void)
 		closedir(dir2);
 	}
 	closedir(dir1);
+	return 0;
 }
 
-static void insert_alloc_stat(unsigned long call_site, unsigned long ptr,
-			      int bytes_req, int bytes_alloc, int cpu)
+static int insert_alloc_stat(unsigned long call_site, unsigned long ptr,
+			     int bytes_req, int bytes_alloc, int cpu)
 {
 	struct rb_node **node = &root_alloc_stat.rb_node;
 	struct rb_node *parent = NULL;
@@ -139,8 +151,10 @@ static void insert_alloc_stat(unsigned long call_site, unsigned long ptr,
 		data->bytes_alloc += bytes_alloc;
 	} else {
 		data = malloc(sizeof(*data));
-		if (!data)
-			die("malloc");
+		if (!data) {
+			pr_err("%s: malloc failed\n", __func__);
+			return -1;
+		}
 		data->ptr = ptr;
 		data->pingpong = 0;
 		data->hit = 1;
@@ -152,9 +166,10 @@ static void insert_alloc_stat(unsigned long call_site, unsigned long ptr,
 	}
 	data->call_site = call_site;
 	data->alloc_cpu = cpu;
+	return 0;
 }
 
-static void insert_caller_stat(unsigned long call_site,
+static int insert_caller_stat(unsigned long call_site,
 			      int bytes_req, int bytes_alloc)
 {
 	struct rb_node **node = &root_caller_stat.rb_node;
@@ -179,8 +194,10 @@ static void insert_caller_stat(unsigned long call_site,
 		data->bytes_alloc += bytes_alloc;
 	} else {
 		data = malloc(sizeof(*data));
-		if (!data)
-			die("malloc");
+		if (!data) {
+			pr_err("%s: malloc failed\n", __func__);
+			return -1;
+		}
 		data->call_site = call_site;
 		data->pingpong = 0;
 		data->hit = 1;
@@ -190,11 +207,12 @@ static void insert_caller_stat(unsigned long call_site,
 		rb_link_node(&data->node, parent, node);
 		rb_insert_color(&data->node, &root_caller_stat);
 	}
+
+	return 0;
 }
 
-static void perf_evsel__process_alloc_event(struct perf_evsel *evsel,
-					    struct perf_sample *sample,
-					    int node)
+static int perf_evsel__process_alloc_event(struct perf_evsel *evsel,
+					   struct perf_sample *sample, int node)
 {
 	struct event_format *event = evsel->tp_format;
 	void *data = sample->raw_data;
@@ -209,8 +227,9 @@ static void perf_evsel__process_alloc_event(struct perf_evsel *evsel,
 	bytes_req = raw_field_value(event, "bytes_req", data);
 	bytes_alloc = raw_field_value(event, "bytes_alloc", data);
 
-	insert_alloc_stat(call_site, ptr, bytes_req, bytes_alloc, cpu);
-	insert_caller_stat(call_site, bytes_req, bytes_alloc);
+	if (insert_alloc_stat(call_site, ptr, bytes_req, bytes_alloc, cpu) ||
+	    insert_caller_stat(call_site, bytes_req, bytes_alloc))
+		return -1;
 
 	total_requested += bytes_req;
 	total_allocated += bytes_alloc;
@@ -222,6 +241,7 @@ static void perf_evsel__process_alloc_event(struct perf_evsel *evsel,
 			nr_cross_allocs++;
 	}
 	nr_allocs++;
+	return 0;
 }
 
 static int ptr_cmp(struct alloc_stat *, struct alloc_stat *);
@@ -252,8 +272,8 @@ static struct alloc_stat *search_alloc_stat(unsigned long ptr,
 	return NULL;
 }
 
-static void perf_evsel__process_free_event(struct perf_evsel *evsel,
-					   struct perf_sample *sample)
+static int perf_evsel__process_free_event(struct perf_evsel *evsel,
+					  struct perf_sample *sample)
 {
 	unsigned long ptr = raw_field_value(evsel->tp_format, "ptr",
 					    sample->raw_data);
@@ -261,41 +281,43 @@ static void perf_evsel__process_free_event(struct perf_evsel *evsel,
 
 	s_alloc = search_alloc_stat(ptr, 0, &root_alloc_stat, ptr_cmp);
 	if (!s_alloc)
-		return;
+		return 0;
 
 	if ((short)sample->cpu != s_alloc->alloc_cpu) {
 		s_alloc->pingpong++;
 
 		s_caller = search_alloc_stat(0, s_alloc->call_site,
 					     &root_caller_stat, callsite_cmp);
-		assert(s_caller);
+		if (!s_caller)
+			return -1;
 		s_caller->pingpong++;
 	}
 	s_alloc->alloc_cpu = -1;
+
+	return 0;
 }
 
-static void perf_evsel__process_kmem_event(struct perf_evsel *evsel,
-					   struct perf_sample *sample)
+static int perf_evsel__process_kmem_event(struct perf_evsel *evsel,
+					  struct perf_sample *sample)
 {
 	struct event_format *event = evsel->tp_format;
 
 	if (!strcmp(event->name, "kmalloc") ||
 	    !strcmp(event->name, "kmem_cache_alloc")) {
-		perf_evsel__process_alloc_event(evsel, sample, 0);
-		return;
+		return perf_evsel__process_alloc_event(evsel, sample, 0);
 	}
 
 	if (!strcmp(event->name, "kmalloc_node") ||
 	    !strcmp(event->name, "kmem_cache_alloc_node")) {
-		perf_evsel__process_alloc_event(evsel, sample, 1);
-		return;
+		return perf_evsel__process_alloc_event(evsel, sample, 1);
 	}
 
 	if (!strcmp(event->name, "kfree") ||
 	    !strcmp(event->name, "kmem_cache_free")) {
-		perf_evsel__process_free_event(evsel, sample);
-		return;
+		return perf_evsel__process_free_event(evsel, sample);
 	}
+
+	return 0;
 }
 
 static int process_sample_event(struct perf_tool *tool __used,
@@ -314,8 +336,7 @@ static int process_sample_event(struct perf_tool *tool __used,
 
 	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
 
-	perf_evsel__process_kmem_event(evsel, sample);
-	return 0;
+	return perf_evsel__process_kmem_event(evsel, sample);
 }
 
 static struct perf_tool perf_kmem = {
@@ -613,8 +634,10 @@ static int sort_dimension__add(const char *tok, struct list_head *list)
 	for (i = 0; i < NUM_AVAIL_SORTS; i++) {
 		if (!strcmp(avail_sorts[i]->name, tok)) {
 			sort = malloc(sizeof(*sort));
-			if (!sort)
-				die("malloc");
+			if (!sort) {
+				pr_err("%s: malloc failed\n", __func__);
+				return -1;
+			}
 			memcpy(sort, avail_sorts[i], sizeof(*sort));
 			list_add_tail(&sort->list, list);
 			return 0;
@@ -629,8 +652,10 @@ static int setup_sorting(struct list_head *sort_list, const char *arg)
 	char *tok;
 	char *str = strdup(arg);
 
-	if (!str)
-		die("strdup");
+	if (!str) {
+		pr_err("%s: strdup failed\n", __func__);
+		return -1;
+	}
 
 	while (true) {
 		tok = strsep(&str, ",");
@@ -758,7 +783,8 @@ int cmd_kmem(int argc, const char **argv, const char *prefix __used)
 	if (!strncmp(argv[0], "rec", 3)) {
 		return __cmd_record(argc, argv);
 	} else if (!strcmp(argv[0], "stat")) {
-		setup_cpunode_map();
+		if (setup_cpunode_map())
+			return -1;
 
 		if (list_empty(&caller_sort))
 			setup_sorting(&caller_sort, default_sort_order);
-- 
1.7.9.2.358.g22243


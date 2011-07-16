Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab1GPLZO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 07:25:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33502 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884Ab1GPLW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 07:22:58 -0400
X-Authority-Analysis: v=1.1 cv=PfPQ8rIoTcZsncbPZjVSZ7K0hy8Zc4hmL68r4VPNpKE= c=1 sm=0 a=vhdKIqpQuCYA:10 a=QxqqLcmqM7oA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=3nbZYyFuAAAA:8 a=pGLkceISAAAA:8 a=hGzw-44bAAAA:8 a=h3sCQ_blAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=h1nsI4b9oP8hKIZPRHEA:9 a=RR1waO044EqkF0wpDocA:7 a=EvKJbDF4Ut8A:10 a=MSl-tDqOz04A:10 a=dowx1zmaLagA:10 a=fNChW5oJl9MA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110716112256.683602159@goodmis.org>
User-Agent: quilt/0.48-1
Date: Sat, 16 Jul 2011 07:22:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 20/20] perf probe: Support adding probes on offline kernel modules
References: <20110716112200.096203519@goodmis.org>
Content-Disposition: inline; filename=0020-perf-probe-Support-adding-probes-on-offline-kernel-m.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Support adding probes on offline kernel modules. This enables
perf-probe to trace kernel-module init functions via perf-probe.
If user gives the path of module with -m option, perf-probe
expects the module is offline.
This feature works with --add, --funcs, and --vars.

E.g)
 # perf probe -m /lib/modules/`uname -r`/kernel/fs/btrfs/btrfs.ko \
   -a "extent_io_init:5 extent_state_cache"
 Add new events:
   probe:extent_io_init (on extent_io_init:5 with extent_state_cache)
   probe:extent_io_init_1 (on extent_io_init:5 with extent_state_cache)

 You can now use it on all perf tools, such as:

         perf record -e probe:extent_io_init_1 -aR sleep 1

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Link: http://lkml.kernel.org/r/20110627072751.6528.10230.stgit@fedora15
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/perf/Documentation/perf-probe.txt |    6 ++-
 tools/perf/builtin-probe.c              |    3 +-
 tools/perf/util/probe-event.c           |   52 +++++++++++++++++++++++++-----
 3 files changed, 49 insertions(+), 12 deletions(-)

diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index 02bafce..2780d9c 100644
--- a/tools/perf/Documentation/perf-probe.txt
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -34,9 +34,11 @@ OPTIONS
 	Specify vmlinux path which has debuginfo (Dwarf binary).
 
 -m::
---module=MODNAME::
+--module=MODNAME|PATH::
 	Specify module name in which perf-probe searches probe points
-	or lines.
+	or lines. If a path of module file is passed, perf-probe
+	treat it as an offline module (this means you can add a probe on
+        a module which has not been loaded yet).
 
 -s::
 --source=PATH::
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 2c0e64d..5f2a5c7 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -242,7 +242,8 @@ static const struct option options[] = {
 	OPT_STRING('s', "source", &symbol_conf.source_prefix,
 		   "directory", "path to kernel source"),
 	OPT_STRING('m', "module", &params.target_module,
-		   "modname", "target module name"),
+		   "modname|path",
+		   "target module name (for online) or path (for offline)"),
 #endif
 	OPT__DRY_RUN(&probe_event_dry_run),
 	OPT_INTEGER('\0', "max-probes", &params.max_probe_points,
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index ee3f41e..b82d54f 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -117,6 +117,10 @@ static struct map *kernel_get_module_map(const char *module)
 	struct rb_node *nd;
 	struct map_groups *grp = &machine.kmaps;
 
+	/* A file path -- this is an offline module */
+	if (module && strchr(module, '/'))
+		return machine__new_module(&machine, 0, module);
+
 	if (!module)
 		module = "kernel";
 
@@ -173,12 +177,19 @@ const char *kernel_get_module_path(const char *module)
 /* Open new debuginfo of given module */
 static struct debuginfo *open_debuginfo(const char *module)
 {
-	const char *path = kernel_get_module_path(module);
+	const char *path;
 
-	if (!path) {
-		pr_err("Failed to find path of %s module.\n",
-		       module ?: "kernel");
-		return NULL;
+	/* A file path -- this is an offline module */
+	if (module && strchr(module, '/'))
+		path = module;
+	else {
+		path = kernel_get_module_path(module);
+
+		if (!path) {
+			pr_err("Failed to find path of %s module.\n",
+			       module ?: "kernel");
+			return NULL;
+		}
 	}
 	return debuginfo__new(path);
 }
@@ -229,13 +240,36 @@ static int kprobe_convert_to_perf_probe(struct probe_trace_point *tp,
 static int add_module_to_probe_trace_events(struct probe_trace_event *tevs,
 					    int ntevs, const char *module)
 {
-	int i;
+	int i, ret = 0;
+	char *tmp;
+
+	if (!module)
+		return 0;
+
+	tmp = strrchr(module, '/');
+	if (tmp) {
+		/* This is a module path -- get the module name */
+		module = strdup(tmp + 1);
+		if (!module)
+			return -ENOMEM;
+		tmp = strchr(module, '.');
+		if (tmp)
+			*tmp = '\0';
+		tmp = (char *)module;	/* For free() */
+	}
+
 	for (i = 0; i < ntevs; i++) {
 		tevs[i].point.module = strdup(module);
-		if (!tevs[i].point.module)
-			return -ENOMEM;
+		if (!tevs[i].point.module) {
+			ret = -ENOMEM;
+			break;
+		}
 	}
-	return 0;
+
+	if (tmp)
+		free(tmp);
+
+	return ret;
 }
 
 /* Try to find perf_probe_event with debuginfo */
-- 
1.7.5.4



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757700Ab1F1ME3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 08:04:29 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:55286 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757482Ab1F1L6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 07:58:21 -0400
X-AuditID: b753bd60-a3cafba0000019f4-7d-4e09c1db4111
X-AuditID: b753bd60-a3cafba0000019f4-7d-4e09c1db4111
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip 13/13] perf probe: Support adding probes on offline
 kernel modules
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Date: Mon, 27 Jun 2011 16:27:51 +0900
Message-ID: <20110627072751.6528.10230.stgit@fedora15>
In-Reply-To: <20110627072626.6528.41792.stgit@fedora15>
References: <20110627072626.6528.41792.stgit@fedora15>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---

 tools/perf/Documentation/perf-probe.txt |    6 ++--
 tools/perf/builtin-probe.c              |    3 +-
 tools/perf/util/probe-event.c           |   52 ++++++++++++++++++++++++++-----
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
index 4f3460a..66ddaa5 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -247,7 +247,8 @@ static const struct option options[] = {
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


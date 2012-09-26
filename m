Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab2IZIDh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 04:03:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:58563 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575Ab2IZIDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 04:03:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,489,1344236400"; 
   d="scan'208";a="226890966"
Date: Wed, 26 Sep 2012 15:57:07 +0800
From: Feng Tang <feng.tang@intel.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>, mingo@elte.hu, a.p.zijlstra@chello.nl,
        andi@firstfloor.org, dsahern@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 8/9] perf hists browser: Add option for runtime
 switching perf data file
Message-ID: <20120926075707.GA4919@feng-i7>
References: <1348500251-9937-1-git-send-email-feng.tang@intel.com>
 <1348500251-9937-9-git-send-email-feng.tang@intel.com>
 <87d31ayhpy.fsf@sejong.aot.lge.com>
 <20120925162053.51f60773@feng-i7>
 <20120925111703.GC28902@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120925111703.GC28902@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 08:17:03AM -0300, Arnaldo Carvalho de Melo wrote:
> Em Tue, Sep 25, 2012 at 04:20:53PM +0800, Feng Tang escreveu:
> > On Tue, 25 Sep 2012 11:11:21 +0900
> > Namhyung Kim <namhyung@kernel.org> wrote:
> > > Ditto.  Plus it might leak previous input_name.
> > 
> > Nice catch, will check the return value of "strdup". 
> > 
> > For input_name mem leak, in some cases the input_name can't be called
> >  with free(), like those got from parse "-i" option. In case the old
> > input_name is got from malloc through strdup, I think it's not a big
> > issue given that buffer will be freed any way when the application exit.
> 
> I think this is a matter of discipline, leaking is bad, kernel or
> userspace, why special case it?
>

I see, then we need make sure all "input_name" point to a malloced buffer, 
here is a initial debug patch will only touch the annotate/report/script
cmds, pls review and more suggestions are welcomed:

----
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index b3d60ae..5165660 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -288,6 +288,8 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	argc = parse_options(argc, argv, options, annotate_usage, 0);
 
+	try_dup_input_name();
+
 	if (annotate.use_stdio)
 		use_browser = 0;
 	else if (annotate.use_tui)
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index b4d216b..bec614c 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -668,6 +668,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 			input_name = "perf.data";
 	}
 
+	try_dup_input_name();
+
 repeat:
 	session = perf_session__new(input_name, O_RDONLY,
 				    report.force, false, &report.tool);
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 30e880c..f13df66 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -1477,6 +1477,8 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (!script_name)
 		setup_pager();
 
+	try_dup_input_name();
+
 	session = perf_session__new(input_name, O_RDONLY, 0, false,
 				    &perf_script);
 	if (session == NULL)
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 2a09de0..d6a097e 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -64,6 +64,20 @@ struct pager_config {
 	int val;
 };
 
+/*
+ * "input_name" may point to a memory regsion got or not got from
+ * malloc(), this fun will enforce it to point to a malloced region,
+ * this is to avoid memory leak when runtime siwtching perf data file.
+ */
+void try_dup_input_name(void)
+{
+	if (input_name) {
+		input_name = strdup(input_name);
+		if (!input_name)
+			printf("Warning: Fail to duplicate input_name\n");
+	}
+}
+
 static int pager_command_config(const char *var, const char *value, void *data)
 {
 	struct pager_config *c = data;
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 42da932..1159213 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -207,6 +207,7 @@ extern bool perf_host, perf_guest;
 extern const char perf_version_string[];
 
 void pthread__unblock_sigwinch(void);
+void try_dup_input_name(void);
 
 #include "util/target.h"
 

Thanks,
Feng


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932926Ab2EWOdO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 10:33:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17128 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755923Ab2EWOdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 10:33:12 -0400
Date: Wed, 23 May 2012 10:33:05 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Steven Rostedt <srostedt@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Perf build failure in v3.4-4842-g61011677
Message-ID: <20120523143304.GF1143@zod.bos.redhat.com>
References: <20120523141359.GE1143@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120523141359.GE1143@zod.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 10:13:59AM -0400, Josh Boyer wrote:
> Building Linus' latest tree as of this morning results in perf being
> very unhappy.  The build machine is running Fedora 17, so gcc 4.7.  The
> gtk2 missing errors are fine as far as I'm concerned, but the rest of
> the errors seem like things that might want fixing?
> 
> josh
> 
> + make -j8 -C tools/perf -s V=1 WERROR=0 HAVE_CPLUS_DEMANGLE=1

<snip>

> util/scripting-engines/trace-event-perl.c: In function
> 'define_event_symbols':
> util/scripting-engines/trace-event-perl.c:188:2: warning: enumeration
> value 'PRINT_BSTRING' not handled in switch [-Wswitch-enum]
> util/scripting-engines/trace-event-perl.c:188:2: warning: enumeration
> value 'PRINT_DYNAMIC_ARRAY' not handled in switch [-Wswitch-enum]
> util/scripting-engines/trace-event-perl.c:188:2: warning: enumeration
> value 'PRINT_FUNC' not handled in switch [-Wswitch-enum]
> util/scripting-engines/trace-event-perl.c: In function
> 'find_cache_event':
> util/scripting-engines/trace-event-perl.c:240:23: warning: assignment
> from incompatible pointer type [enabled by default]
> util/scripting-engines/trace-event-perl.c:244:34: error: dereferencing
> pointer to incomplete type
> util/scripting-engines/trace-event-perl.c:244:49: error: dereferencing
> pointer to incomplete type
> util/scripting-engines/trace-event-perl.c:246:44: error: dereferencing
> pointer to incomplete type

<snip>

OK, seems Steven fixed the trace-event-python.c file with commit
aaf045f7233, but missed the perl one.  This patch seems to fixup the
errors.

josh

-----

From: Josh Boyer <jwboyer@redhat.com>
Subject: [PATCH] perf: Fix trace-event-perl.c build

Commit aaf045f7233 (perf: Have perf use the new libtraceevent.a library)
converted the trace-event-python.c scripting engine but missed the
trace-event-perl.c file.  Fix it up to use the event_format structure
and clean up a few enum warnings from GCC.

Signed-off-by: Josh Boyer <jwboyer@redhat.com>

---

diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index e30749e..b1ac27b 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -56,7 +56,7 @@ INTERP my_perl;
 #define FTRACE_MAX_EVENT				\
 	((1 << (sizeof(unsigned short) * 8)) - 1)
 
-struct event *events[FTRACE_MAX_EVENT];
+struct event_format *events[FTRACE_MAX_EVENT];
 
 extern struct scripting_context *scripting_context;
 
@@ -181,7 +181,7 @@ static void define_flag_field(const char *ev_name,
 	LEAVE;
 }
 
-static void define_event_symbols(struct event *event,
+static void define_event_symbols(struct event_format *event,
 				 const char *ev_name,
 				 struct print_arg *args)
 {
@@ -221,6 +221,9 @@ static void define_event_symbols(struct event *event,
 		define_event_symbols(event, ev_name, args->op.right);
 		break;
 	default:
+	case PRINT_BSTRING:
+	case PRINT_DYNAMIC_ARRAY:
+	case PRINT_FUNC:
 		/* we should warn... */
 		return;
 	}
@@ -229,10 +232,10 @@ static void define_event_symbols(struct event *event,
 		define_event_symbols(event, ev_name, args->next);
 }
 
-static inline struct event *find_cache_event(int type)
+static inline struct event_format *find_cache_event(int type)
 {
 	static char ev_name[256];
-	struct event *event;
+	struct event_format *event;
 
 	if (events[type])
 		return events[type];
@@ -258,7 +261,7 @@ static void perl_process_tracepoint(union perf_event *pevent __unused,
 	static char handler[256];
 	unsigned long long val;
 	unsigned long s, ns;
-	struct event *event;
+	struct event_format *event;
 	int type;
 	int pid;
 	int cpu = sample->cpu;
@@ -446,7 +449,7 @@ static int perl_stop_script(void)
 
 static int perl_generate_script(const char *outfile)
 {
-	struct event *event = NULL;
+	struct event_format *event = NULL;
 	struct format_field *f;
 	char fname[PATH_MAX];
 	int not_first, count;
> 
> 
> 

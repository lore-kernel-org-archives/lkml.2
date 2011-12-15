Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759280Ab1LORYG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 12:24:06 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:57190
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759238Ab1LORYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 12:24:04 -0500
X-SpamScore: 7
X-BigFish: VPS7(z1039ozzz1202hzz8275bhz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LW99NX-01-A8G-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 3/4] perf script: Add generic perl handler to process events
Date: Thu, 15 Dec 2011 18:23:43 +0100
Message-ID: <1323969824-9711-4-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1323969824-9711-1-git-send-email-robert.richter@amd.com>
References: <1323969824-9711-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current perf scripting facility only supports tracepoints. This
patch implements a generic perl handler to support other events than
tracepoints too.

This patch introduces a function process_event() that is called by
perf for each sample. The function is called with byte streams as
arguments containing information about the event, its attributes, the
sample and raw data. Perl's unpack() function can easily be used for
byte decoding. The following is the default implementation for
process_event() that can also be generated with perf script:

 # Packed byte string args of process_event():
 #
 # $event:       union perf_event        util/event.h
 # $attr:        struct perf_event_attr  linux/perf_event.h
 # $sample:      struct perf_sample      util/event.h
 # $raw_data:    perf_sample->raw_data   util/event.h

 sub process_event
 {
         my ($event, $attr, $sample, $raw_data) = @_;

         my @event       = unpack("LSS", $event);
         my @attr        = unpack("LLQQQQQLLQQ", $attr);
         my @sample      = unpack("QLLQQQQQLL", $sample);
         my @raw_data    = unpack("C*", $raw_data);

         use Data::Dumper;
         print Dumper \@event, \@attr, \@sample, \@raw_data;
 }

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 .../perf/util/scripting-engines/trace-event-perl.c |   73 ++++++++++++++++++--
 1 files changed, 67 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index a82ce43..e30749e 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -30,6 +30,7 @@
 #include "../thread.h"
 #include "../event.h"
 #include "../trace-event.h"
+#include "../evsel.h"
 
 #include <EXTERN.h>
 #include <perl.h>
@@ -247,11 +248,11 @@ static inline struct event *find_cache_event(int type)
 	return event;
 }
 
-static void perl_process_event(union perf_event *pevent __unused,
-			       struct perf_sample *sample,
-			       struct perf_evsel *evsel,
-			       struct machine *machine __unused,
-			       struct thread *thread)
+static void perl_process_tracepoint(union perf_event *pevent __unused,
+				    struct perf_sample *sample,
+				    struct perf_evsel *evsel,
+				    struct machine *machine __unused,
+				    struct thread *thread)
 {
 	struct format_field *field;
 	static char handler[256];
@@ -267,6 +268,9 @@ static void perl_process_event(union perf_event *pevent __unused,
 
 	dSP;
 
+	if (evsel->attr.type != PERF_TYPE_TRACEPOINT)
+		return;
+
 	type = trace_parse_common_type(data);
 
 	event = find_cache_event(type);
@@ -334,6 +338,42 @@ static void perl_process_event(union perf_event *pevent __unused,
 	LEAVE;
 }
 
+static void perl_process_event_generic(union perf_event *pevent __unused,
+				       struct perf_sample *sample,
+				       struct perf_evsel *evsel __unused,
+				       struct machine *machine __unused,
+				       struct thread *thread __unused)
+{
+	dSP;
+
+	if (!get_cv("process_event", 0))
+		return;
+
+	ENTER;
+	SAVETMPS;
+	PUSHMARK(SP);
+	XPUSHs(sv_2mortal(newSVpvn((const char *)pevent, pevent->header.size)));
+	XPUSHs(sv_2mortal(newSVpvn((const char *)&evsel->attr, sizeof(evsel->attr))));
+	XPUSHs(sv_2mortal(newSVpvn((const char *)sample, sizeof(*sample))));
+	XPUSHs(sv_2mortal(newSVpvn((const char *)sample->raw_data, sample->raw_size)));
+	PUTBACK;
+	call_pv("process_event", G_SCALAR);
+	SPAGAIN;
+	PUTBACK;
+	FREETMPS;
+	LEAVE;
+}
+
+static void perl_process_event(union perf_event *pevent,
+			       struct perf_sample *sample,
+			       struct perf_evsel *evsel,
+			       struct machine *machine,
+			       struct thread *thread)
+{
+	perl_process_tracepoint(pevent, sample, evsel, machine, thread);
+	perl_process_event_generic(pevent, sample, evsel, machine, thread);
+}
+
 static void run_start_sub(void)
 {
 	dSP; /* access to Perl stack */
@@ -555,7 +595,28 @@ static int perl_generate_script(const char *outfile)
 	fprintf(ofp, "sub print_header\n{\n"
 		"\tmy ($event_name, $cpu, $secs, $nsecs, $pid, $comm) = @_;\n\n"
 		"\tprintf(\"%%-20s %%5u %%05u.%%09u %%8u %%-20s \",\n\t       "
-		"$event_name, $cpu, $secs, $nsecs, $pid, $comm);\n}");
+		"$event_name, $cpu, $secs, $nsecs, $pid, $comm);\n}\n");
+
+	fprintf(ofp,
+		"\n# Packed byte string args of process_event():\n"
+		"#\n"
+		"# $event:\tunion perf_event\tutil/event.h\n"
+		"# $attr:\tstruct perf_event_attr\tlinux/perf_event.h\n"
+		"# $sample:\tstruct perf_sample\tutil/event.h\n"
+		"# $raw_data:\tperf_sample->raw_data\tutil/event.h\n"
+		"\n"
+		"sub process_event\n"
+		"{\n"
+		"\tmy ($event, $attr, $sample, $raw_data) = @_;\n"
+		"\n"
+		"\tmy @event\t= unpack(\"LSS\", $event);\n"
+		"\tmy @attr\t= unpack(\"LLQQQQQLLQQ\", $attr);\n"
+		"\tmy @sample\t= unpack(\"QLLQQQQQLL\", $sample);\n"
+		"\tmy @raw_data\t= unpack(\"C*\", $raw_data);\n"
+		"\n"
+		"\tuse Data::Dumper;\n"
+		"\tprint Dumper \\@event, \\@attr, \\@sample, \\@raw_data;\n"
+		"}\n");
 
 	fclose(ofp);
 
-- 
1.7.7



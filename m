Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959Ab0LBQoF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 11:44:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34525 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757830Ab0LBQmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 11:42:40 -0500
From: Thomas Renninger <trenn@suse.de>
Cc: Thomas Renninger <trenn@suse.de>, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: [PATCH 7/8] perf timechart: Map power:cpu_idle events to the corresponding cpuidle state
Date: Thu,  2 Dec 2010 17:42:27 +0100
Message-Id: <1291308148-28628-8-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1291308148-28628-7-git-send-email-trenn@suse.de>
References: <1291308148-28628-1-git-send-email-trenn@suse.de>
 <1291308148-28628-2-git-send-email-trenn@suse.de>
 <1291308148-28628-3-git-send-email-trenn@suse.de>
 <1291308148-28628-4-git-send-email-trenn@suse.de>
 <1291308148-28628-5-git-send-email-trenn@suse.de>
 <1291308148-28628-6-git-send-email-trenn@suse.de>
 <1291308148-28628-7-git-send-email-trenn@suse.de>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before, power:cpu_idle events were very specific X86 Intel mwait events.
This got fixed with previous patches and cpu_idle events are now thrown by
all cpuidle drivers and can be mapped to the corresponding cpuidle state
in /sys.

This patch reads out the corresponding cpuidle name of a cpu_idle event
and uses it in the title line of the chart (c-states Cx in x86, omap2
- DDR self refresh states for various arm archs).

It also reads out the corresponding abbr(eviation) and uses the string
to draw the cpu idle occurences. This needs a short (3 letter) string
to keep the overview in the chart.

Signed-off-by: Thomas Renninger <trenn@suse.de>
CC: lenb@kernel.org
CC: linux-acpi@vger.kernel.org
CC: linux-pm@lists.linux-foundation.org
CC: Arjan van de Ven <arjan@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
CC: linux-perf-users@vger.kernel.org
CC: linux-omap@vger.kernel.org
---
 tools/perf/builtin-timechart.c |   26 ++++++-
 tools/perf/util/svghelper.c    |  156 +++++++++++++++++++++++++++++++++++-----
 2 files changed, 163 insertions(+), 19 deletions(-)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 148dc5e..391e475 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -31,6 +31,7 @@
 #include "util/event.h"
 #include "util/session.h"
 #include "util/svghelper.h"
+#include "util/debug.h"
 
 #define SUPPORT_OLD_POWER_EVENTS 1
 #define PWR_EVENT_EXIT -1
@@ -379,6 +380,10 @@ static void c_state_end(int cpu, u64 timestamp)
 	pwr->next = power_events;
 
 	power_events = pwr;
+	if (verbose)
+		printf("CPU: %d - start_time: %llu - end_time: %llu\n",
+		       power_events->cpu, power_events->start_time,
+		       power_events->end_time);
 }
 
 static void p_state_change(int cpu, u64 timestamp, u64 new_freq)
@@ -657,8 +662,25 @@ static void draw_c_p_states(void)
 	 * two pass drawing so that the P state bars are on top of the C state blocks
 	 */
 	while (pwr) {
-		if (pwr->type == CSTATE)
-			svg_cstate(pwr->cpu, pwr->start_time, pwr->end_time, pwr->state);
+		if (pwr->type == CSTATE) {
+			if (verbose) {
+				printf("CPU: %d, Start: %llu, End: %llu, type:"
+				       " %d\n", pwr->cpu, pwr->start_time,
+				       pwr->end_time, pwr->state);
+			}
+			/* trenn: Looks like there is a dummy c-state entry of
+			 * type==0, start_time==0, end_time==highest_timestamp
+			 * for each CPU at the end of the list, this one should
+			 * better be filtered out before  -> ignore it here.
+			*/
+			if ((pwr->state == 0 && pwr->start_time == 0)) {
+				pwr = pwr->next;
+				continue;
+			}
+
+			svg_cstate(pwr->cpu, pwr->start_time, pwr->end_time,
+				   pwr->state);
+		}
 		pwr = pwr->next;
 	}
 
diff --git a/tools/perf/util/svghelper.c b/tools/perf/util/svghelper.c
index b3637db..20c02fc 100644
--- a/tools/perf/util/svghelper.c
+++ b/tools/perf/util/svghelper.c
@@ -16,8 +16,13 @@
 #include <stdlib.h>
 #include <unistd.h>
 #include <string.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+
+#include <linux/cpuidle.h>
 
 #include "svghelper.h"
+#include "debug.h"
 
 static u64 first_time, last_time;
 static u64 turbo_frequency, max_freq;
@@ -43,11 +48,11 @@ static double cpu2y(int cpu)
 	return cpu2slot(cpu) * SLOT_MULT;
 }
 
-static double time2pixels(u64 time)
+static double time2pixels(u64 __time)
 {
 	double X;
 
-	X = 1.0 * svg_page_width * (time - first_time) / (last_time - first_time);
+	X = 1.0 * svg_page_width * (__time - first_time) / (last_time - first_time);
 	return X;
 }
 
@@ -107,12 +112,14 @@ void open_svg(const char *filename, int cpus, int rows, u64 start, u64 end)
 	fprintf(svgfile, "      rect.WAITING  { fill:rgb(255,214, 48); fill-opacity:0.6; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
 	fprintf(svgfile, "      rect.cpu      { fill:rgb(192,192,192); fill-opacity:0.2; stroke-width:0.5; stroke:rgb(128,128,128); } \n");
 	fprintf(svgfile, "      rect.pstate   { fill:rgb(128,128,128); fill-opacity:0.8; stroke-width:0; } \n");
-	fprintf(svgfile, "      rect.c1       { fill:rgb(255,214,214); fill-opacity:0.5; stroke-width:0; } \n");
-	fprintf(svgfile, "      rect.c2       { fill:rgb(255,172,172); fill-opacity:0.5; stroke-width:0; } \n");
-	fprintf(svgfile, "      rect.c3       { fill:rgb(255,130,130); fill-opacity:0.5; stroke-width:0; } \n");
-	fprintf(svgfile, "      rect.c4       { fill:rgb(255, 88, 88); fill-opacity:0.5; stroke-width:0; } \n");
-	fprintf(svgfile, "      rect.c5       { fill:rgb(255, 44, 44); fill-opacity:0.5; stroke-width:0; } \n");
-	fprintf(svgfile, "      rect.c6       { fill:rgb(255,  0,  0); fill-opacity:0.5; stroke-width:0; } \n");
+	fprintf(svgfile, "      rect.c0       { fill:rgb(102,255,102); fill-opacity:0.5; stroke-width:0; } \n");
+	fprintf(svgfile, "      rect.c1       { fill:rgb(102,255,  0); fill-opacity:0.5; stroke-width:0; } \n");
+	fprintf(svgfile, "      rect.c2       { fill:rgb(  0,255,102); fill-opacity:0.5; stroke-width:0; } \n");
+	fprintf(svgfile, "      rect.c3       { fill:rgb( 51,255, 51); fill-opacity:0.5; stroke-width:0; } \n");
+	fprintf(svgfile, "      rect.c4       { fill:rgb( 51,255,  0); fill-opacity:0.5; stroke-width:0; } \n");
+	fprintf(svgfile, "      rect.c5       { fill:rgb(  0,255, 51); fill-opacity:0.5; stroke-width:0; } \n");
+	fprintf(svgfile, "      rect.c6       { fill:rgb(  0,204,  0); fill-opacity:0.5; stroke-width:0; } \n");
+	fprintf(svgfile, "      rect.c7       { fill:rgb(  0,153,  0); fill-opacity:0.5; stroke-width:0; } \n");
 	fprintf(svgfile, "      line.pstate   { stroke:rgb(255,255,  0); stroke-opacity:0.8; stroke-width:2; } \n");
 
 	fprintf(svgfile, "    ]]>\n   </style>\n</defs>\n");
@@ -199,6 +206,81 @@ void svg_waiting(int Yslot, u64 start, u64 end)
 	fprintf(svgfile, "</g>\n");
 }
 
+/* Cpuidle info from sysfs ***************************/
+struct cpuidle_state cpuidle_states[CPUIDLE_STATE_MAX];
+unsigned int cpuidle_info_max;
+
+static void debug_dump_cpuidle_states(void)
+{
+	unsigned int state;
+
+	if (cpuidle_info_max == 0) {
+		printf("No cpuidle info retrieved from /sys\n");
+		return;
+	}
+	printf("cpuidle_info_max: %u\n", cpuidle_info_max);
+	for (state = 0; state < cpuidle_info_max; state++) {
+		printf("CPUIDLE[%u]:\n", state);
+		printf("Name: %s\n", cpuidle_states[state].name);
+		printf("Abbr: %s\n", cpuidle_states[state].abbr);
+	}
+}
+static int get_sysfs_string(const char *path, char *string,
+			     int max_string_size)
+{
+	int fd;
+	size_t numread, i;
+
+	fd = open(path, O_RDONLY);
+	if (fd == -1)
+		return -1;
+
+	numread = read(fd, string, max_string_size-1);
+	if (numread < 1) {
+		close(fd);
+		return -1;
+	}
+	for (i = 0; i < numread; i++)
+		if (string[i] == '\n')
+			string[i] = '\0';
+	string[numread] = '\0';
+	close(fd);
+	return 0;
+}
+
+#define PERF_CPUIDLE_SYS_PATH "/sys/devices/system/cpu/cpu0/cpuidle/state%u/"
+#define PERF_SYSFS_PATH_MAX 255
+
+/*
+ * Fills up cpuidle_states[CPUIDLE_STATE_MAX] info from
+ * /sys/devices/system/cpu/cpu0/cpuidle/stateX/ and sets cpuidle_info_max
+ * to found states
+ */
+static int retrieve_cpuidle_info(void)
+{
+	char path[PERF_SYSFS_PATH_MAX];
+	int state, ret;
+
+	for (state = 0; state < CPUIDLE_STATE_MAX; state++) {
+		snprintf(path, sizeof(path), PERF_CPUIDLE_SYS_PATH "name",
+			 state);
+		ret = get_sysfs_string(path, cpuidle_states[state].name,
+				       CPUIDLE_NAME_LEN + 1);
+		if (ret)
+			break;
+
+		snprintf(path, sizeof(path), PERF_CPUIDLE_SYS_PATH "abbr",
+			 state);
+		ret = get_sysfs_string(path, cpuidle_states[state].abbr,
+				       CPUIDLE_ABBR_LEN + 1);
+		if (ret)
+			break;
+	}
+	cpuidle_info_max = state;
+	return state;
+}
+/* Cpuidle info from sysfs ***************************/
+
 static char *cpu_model(void)
 {
 	static char cpu_m[255];
@@ -278,17 +360,33 @@ void svg_process(int cpu, u64 start, u64 end, const char *type, const char *name
 	fprintf(svgfile, "</g>\n");
 }
 
+/*
+ * Svg util and kernel supported max cpuidle states may differ.
+ * Cmp. with tools/perf/utils/include/linux/cpuidle.h
+ * and include/linux/cpuidle.h
+ * Currently cpuidle kernel interface and this svg tool, both support 8 states
+ */
+#define PERF_SVG_CPUIDLE_STATE_MAX 8
+
 void svg_cstate(int cpu, u64 start, u64 end, int type)
 {
 	double width;
 	char style[128];
+	static bool max_states_exceed_msg;
 
 	if (!svgfile)
 		return;
 
+	if (type > PERF_SVG_CPUIDLE_STATE_MAX) {
+		if (verbose || max_states_exceed_msg == false) {
+			max_states_exceed_msg = true;
+			printf("cpuidle state (%d) exceeding max supported "
+			       "states (%d).. ignoring\n",
+			       type, PERF_SVG_CPUIDLE_STATE_MAX);
+			return;
+		}
+	}
 
-	if (type > 6)
-		type = 6;
 	sprintf(style, "c%i", type);
 
 	fprintf(svgfile, "<rect class=\"%s\" x=\"%4.8f\" width=\"%4.8f\" y=\"%4.1f\" height=\"%4.1f\"/>\n",
@@ -451,16 +549,40 @@ static void svg_legenda_box(int X, const char *text, const char *style)
 
 void svg_legenda(void)
 {
+	unsigned int cstate, offset = 500;
+	char class[3];
+
+	retrieve_cpuidle_info();
+	/* perf timechart does not implement a verbose (-v) param yet
+	   remove below comment if you want to be more verbose. */
+	/* verbose = 1; */
+	if (verbose)
+		debug_dump_cpuidle_states();
+
 	if (!svgfile)
 		return;
 
-	svg_legenda_box(0,	"Running", "sample");
-	svg_legenda_box(100,	"Idle","rect.c1");
-	svg_legenda_box(200,	"Deeper Idle", "rect.c3");
-	svg_legenda_box(350,	"Deepest Idle", "rect.c6");
-	svg_legenda_box(550,	"Sleeping", "process2");
-	svg_legenda_box(650,	"Waiting for cpu", "waiting");
-	svg_legenda_box(800,	"Blocked on IO", "blocked");
+		svg_legenda_box(0,	"Running", "sample");
+		svg_legenda_box(100,	"Sleeping", "process2");
+		svg_legenda_box(200,	"Waiting for cpu", "waiting");
+		svg_legenda_box(350,	"Blocked on IO", "blocked");
+	/* trenn: Arch specific events. Only C1 exists on x86 if
+	   no cpuidle driver registered. Deeper and Deepest can get
+	   removed. Also C1 events may only get fired through cpuidle
+	   driver at some time. */
+	if (cpuidle_info_max == 0) {
+		svg_legenda_box(500,	"Idle", "c1");
+	} else {
+		for (cstate = 0; cstate < cpuidle_info_max; cstate++) {
+			sprintf(class, "c%u", cstate);
+			svg_legenda_box(offset, cpuidle_states[cstate].name,
+					class);
+			/* The box */
+			offset += 20;
+			/* The text */
+			offset += (strlen(cpuidle_states[cstate].name) * 10);
+		}
+	}
 }
 
 void svg_time_grid(void)
-- 
1.6.0.2


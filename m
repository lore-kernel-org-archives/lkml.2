Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746Ab1AGKbF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 05:31:05 -0500
Received: from cantor.suse.de ([195.135.220.2]:43294 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475Ab1AGKaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 05:30:09 -0500
From: Thomas Renninger <trenn@suse.de>
Cc: linux-perf-users@vger.kernel.org, mingo@elte.hu, arjan@linux.intel.com,
        lenb@kernel.org, j-pihet@ti.com, Thomas Renninger <trenn@suse.de>,
        linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 8/9] perf timechart: Map power:cpu_idle events to the corresponding cpuidle state
Date: Fri,  7 Jan 2011 11:29:49 +0100
Message-Id: <1294396190-23031-9-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1294396190-23031-1-git-send-email-trenn@suse.de>
References: <1294396190-23031-1-git-send-email-trenn@suse.de>
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
CC: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/util/include/linux/cpuidle.h |   20 ++++
 tools/perf/util/svghelper.c             |  149 +++++++++++++++++++++++++++---
 2 files changed, 154 insertions(+), 15 deletions(-)
 create mode 100644 tools/perf/util/include/linux/cpuidle.h

diff --git a/tools/perf/util/include/linux/cpuidle.h b/tools/perf/util/include/linux/cpuidle.h
new file mode 100644
index 0000000..7012f33
--- /dev/null
+++ b/tools/perf/util/include/linux/cpuidle.h
@@ -0,0 +1,20 @@
+#ifndef __PERF_CPUIDLE_H_
+#define __PERF_CPUIDLE_H_
+
+/* This comes from include/linux/cpuidle.h kernel header **********/
+#define CPUIDLE_STATE_MAX	8
+#define CPUIDLE_NAME_LEN	16
+#define CPUIDLE_DESC_LEN	32
+#define CPUIDLE_ABBR_LEN	3
+/******************************************************************/
+
+struct cpuidle_state {
+	char name[CPUIDLE_NAME_LEN + 1];
+	char abbr[CPUIDLE_ABBR_LEN + 1];
+};
+
+extern struct cpuidle_state cpuidle_states[CPUIDLE_STATE_MAX];
+
+extern unsigned int cpuidle_info_max;
+
+#endif
diff --git a/tools/perf/util/svghelper.c b/tools/perf/util/svghelper.c
index 38b9e40..5cf6c9e 100644
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
@@ -108,12 +113,14 @@ void open_svg(const char *filename, int cpus, int rows, u64 start, u64 end)
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
@@ -200,6 +207,81 @@ void svg_waiting(int Yslot, u64 start, u64 end)
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
@@ -279,17 +361,33 @@ void svg_process(int cpu, u64 start, u64 end, const char *type, const char *name
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
@@ -452,16 +550,37 @@ static void svg_legenda_box(int X, const char *text, const char *style)
 
 void svg_legenda(void)
 {
+	unsigned int cstate, offset = 500;
+	char class[3];
+
+	retrieve_cpuidle_info();
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
1.7.3.1


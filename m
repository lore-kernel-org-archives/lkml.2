Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab2CLJY3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 05:24:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:39230 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754017Ab2CLJY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 05:24:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="120092777"
Message-ID: <4F5DC075.105@intel.com>
Date: Mon, 12 Mar 2012 17:23:01 +0800
From: ShuoX Liu <shuox.liu@intel.com>
Reply-To: shuox.liu@intel.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Valentin, Eduardo" <eduardo.valentin@ti.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        "Brown, Len" <len.brown@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>
Subject: [PATCH 3/3] cpupower: Update the cpupower tool for new debugfs entries
 of cpuidle.
References: <C6CB66606345BC4B80CBE69D22ABFBB10220E1@SHSMSX101.ccr.corp.intel.com> <4F545A4E.8010801@linux.vnet.ibm.com> <4F5466C4.2090808@intel.com> <20120305101827.GA19408@khazad-dum.debian.net> <CAGF5oy_BUytjeDa8Oc62pRabaEqwqKCFuVJuzLd-XNZg34ne2w@mail.gmail.com> <1330998885.1916.89.camel@ymzhang> <20120306052236.GA19416@kroah.com> <1331013078.1916.103.camel@ymzhang> <20120306143935.GA23346@kroah.com> <1331082051.1916.124.camel@ymzhang> <20120308180106.GD26516@kroah.com> <4F5DBFA8.3080300@intel.com>
In-Reply-To: <4F5DBFA8.3080300@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ShuoX Liu <shuox.liu@intel.com>

sys entries of each CPU's cpuidle states has been moved to debugfs, so
we should update the cpupower tool.

Signed-off-by: ShuoX Liu <shuox.liu@intel.com>
---
  tools/power/cpupower/Makefile                      |    3 +-
  tools/power/cpupower/man/cpupower-monitor.1        |    4 +-
  tools/power/cpupower/utils/cpuidle-info.c          |   27 ++--
  tools/power/cpupower/utils/helpers/debugfs.c       |  224 
++++++++++++++++++++
  tools/power/cpupower/utils/helpers/debugfs.h       |   21 ++
  tools/power/cpupower/utils/helpers/sysfs.c         |  177 ---------------
  tools/power/cpupower/utils/helpers/sysfs.h         |   12 -
  .../cpupower/utils/idle_monitor/cpuidle_sysfs.c    |   11 +-
  8 files changed, 269 insertions(+), 210 deletions(-)
  create mode 100644 tools/power/cpupower/utils/helpers/debugfs.c
  create mode 100644 tools/power/cpupower/utils/helpers/debugfs.h

diff --git a/tools/power/cpupower/Makefile b/tools/power/cpupower/Makefile
index e8a03ac..d9b0507 100644
--- a/tools/power/cpupower/Makefile
+++ b/tools/power/cpupower/Makefile
@@ -114,7 +114,8 @@ CFLAGS += -DVERSION=\"$(VERSION)\" 
-DPACKAGE=\"$(PACKAGE)\" \
  		-DPACKAGE_BUGREPORT=\"$(PACKAGE_BUGREPORT)\" -D_GNU_SOURCE

  UTIL_OBJS =  utils/helpers/amd.o utils/helpers/topology.o 
utils/helpers/msr.o \
-	utils/helpers/sysfs.o utils/helpers/misc.o utils/helpers/cpuid.o \
+	utils/helpers/sysfs.o utils/helpers/debugfs.o utils/helpers/misc.o \
+	utils/helpers/cpuid.o \
  	utils/helpers/pci.o utils/helpers/bitmask.o \
  	utils/idle_monitor/nhm_idle.o utils/idle_monitor/snb_idle.o \
  	utils/idle_monitor/amd_fam14h_idle.o utils/idle_monitor/cpuidle_sysfs.o \
diff --git a/tools/power/cpupower/man/cpupower-monitor.1 
b/tools/power/cpupower/man/cpupower-monitor.1
index d5cfa26..1cb2951 100644
--- a/tools/power/cpupower/man/cpupower-monitor.1
+++ b/tools/power/cpupower/man/cpupower-monitor.1
@@ -79,7 +79,7 @@ Increase verbosity if the binary was compiled with the 
DEBUG option set.
  .SH MONITOR DESCRIPTIONS
  .SS "Idle_Stats"
  Shows statistics of the cpuidle kernel subsystem. Values are retrieved 
from
-/sys/devices/system/cpu/cpu*/cpuidle/state*/.
+$(debugfs_root)/cpu/cpu*/cpuidle/state*/.
  The kernel updates these values every time an idle state is entered or
  left. Therefore there can be some inaccuracy when cores are in an idle
  state for some time when the measure starts or ends. In worst case it 
can happen
@@ -165,7 +165,7 @@ http://www.intel.com/products/processor/manuals
  .ta
  .nf
  /dev/cpu/*/msr
-/sys/devices/system/cpu/cpu*/cpuidle/state*/.
+$(debugfs_root)/cpu/cpu*/cpuidle/state*/.
  .fi

  .SH "SEE ALSO"
diff --git a/tools/power/cpupower/utils/cpuidle-info.c 
b/tools/power/cpupower/utils/cpuidle-info.c
index b028267..17df26a 100644
--- a/tools/power/cpupower/utils/cpuidle-info.c
+++ b/tools/power/cpupower/utils/cpuidle-info.c
@@ -16,6 +16,7 @@

  #include "helpers/helpers.h"
  #include "helpers/sysfs.h"
+#include "helpers/debugfs.h"
  #include "helpers/bitmask.h"

  #define LINE_LEN 10
@@ -27,7 +28,7 @@ static void cpuidle_cpu_output(unsigned int cpu, int 
verbose)

  	printf(_ ("Analyzing CPU %d:\n"), cpu);

-	idlestates = sysfs_get_idlestate_count(cpu);
+	idlestates = debugfs_get_idlestate_count(cpu);
  	if (idlestates == 0) {
  		printf(_("CPU %u: No idle states\n"), cpu);
  		return;
@@ -35,7 +36,7 @@ static void cpuidle_cpu_output(unsigned int cpu, int 
verbose)
  		printf(_("CPU %u: Can't read idle state info\n"), cpu);
  		return;
  	}
-	tmp = sysfs_get_idlestate_name(cpu, idlestates - 1);
+	tmp = debugfs_get_idlestate_name(cpu, idlestates - 1);
  	if (!tmp) {
  		printf(_("Could not determine max idle state %u\n"),
  		       idlestates - 1);
@@ -46,7 +47,7 @@ static void cpuidle_cpu_output(unsigned int cpu, int 
verbose)

  	printf(_("Available idle states:"));
  	for (idlestate = 1; idlestate < idlestates; idlestate++) {
-		tmp = sysfs_get_idlestate_name(cpu, idlestate);
+		tmp = debugfs_get_idlestate_name(cpu, idlestate);
  		if (!tmp)
  			continue;
  		printf(" %s", tmp);
@@ -58,24 +59,24 @@ static void cpuidle_cpu_output(unsigned int cpu, int 
verbose)
  		return;

  	for (idlestate = 1; idlestate < idlestates; idlestate++) {
-		tmp = sysfs_get_idlestate_name(cpu, idlestate);
+		tmp = debugfs_get_idlestate_name(cpu, idlestate);
  		if (!tmp)
  			continue;
  		printf("%s:\n", tmp);
  		free(tmp);

-		tmp = sysfs_get_idlestate_desc(cpu, idlestate);
+		tmp = debugfs_get_idlestate_desc(cpu, idlestate);
  		if (!tmp)
  			continue;
  		printf(_("Flags/Description: %s\n"), tmp);
  		free(tmp);

  		printf(_("Latency: %lu\n"),
-		       sysfs_get_idlestate_latency(cpu, idlestate));
+		       debugfs_get_idlestate_latency(cpu, idlestate));
  		printf(_("Usage: %lu\n"),
-		       sysfs_get_idlestate_usage(cpu, idlestate));
+		       debugfs_get_idlestate_usage(cpu, idlestate));
  		printf(_("Duration: %llu\n"),
-		       sysfs_get_idlestate_time(cpu, idlestate));
+		       debugfs_get_idlestate_time(cpu, idlestate));
  	}
  	printf("\n");
  }
@@ -108,7 +109,7 @@ static void proc_cpuidle_cpu_output(unsigned int cpu)
  	long max_allowed_cstate = 2000000000;
  	int cstates, cstate;

-	cstates = sysfs_get_idlestate_count(cpu);
+	cstates = debugfs_get_idlestate_count(cpu);
  	if (cstates == 0) {
  		/*
  		 * Go on and print same useless info as you'd see with
@@ -131,11 +132,11 @@ static void proc_cpuidle_cpu_output(unsigned int cpu)
  			 "type[C%d] "), cstate, cstate);
  		printf(_("promotion[--] demotion[--] "));
  		printf(_("latency[%03lu] "),
-		       sysfs_get_idlestate_latency(cpu, cstate));
+		       debugfs_get_idlestate_latency(cpu, cstate));
  		printf(_("usage[%08lu] "),
-		       sysfs_get_idlestate_usage(cpu, cstate));
-		printf(_("duration[%020Lu] \n"),
-		       sysfs_get_idlestate_time(cpu, cstate));
+		       debugfs_get_idlestate_usage(cpu, cstate));
+		printf(_("duration[%020Lu]\n"),
+		       debugfs_get_idlestate_time(cpu, cstate));
  	}
  }

diff --git a/tools/power/cpupower/utils/helpers/debugfs.c 
b/tools/power/cpupower/utils/helpers/debugfs.c
new file mode 100644
index 0000000..1e12e8b
--- /dev/null
+++ b/tools/power/cpupower/utils/helpers/debugfs.c
@@ -0,0 +1,224 @@
+#include <stdio.h>
+#include <errno.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <unistd.h>
+
+#include "helpers/debugfs.h"
+
+char debugfs_root[DEBUGFS_PATH_MAX + 1] = "/sys/kernel/debug";
+
+const char *get_debugfs_root()
+{
+	FILE *fp;
+	char type[100];
+
+	fp = fopen("/proc/mounts", "r");
+	if (fp == NULL)
+		return NULL;
+
+	while (fscanf(fp, "%*s %" STR(DEBUGFS_PATH_MAX) "s %99s %*s %*d %*d\n",
+				debugfs_root, type) == 2)
+		if (strcmp(type, "debugfs") == 0)
+			break;
+	fclose(fp);
+
+	if (strcmp(type, "debugfs") != 0)
+		return NULL;
+
+	return debugfs_root;
+}
+
+/* CPUidle idlestate specific $(debugfs_root)/cpu/cpuX/cpuidle/ access */
+
+/*
+ * helper function to read file from $(debugfs_root) into given buffer
+ * fname is a relative path under "cpuX/cpuidle/stateX/" dir
+ * cstates starting with 0, C0 is not counted as cstate.
+ * This means if you want C1 info, pass 0 as idlestate param
+ */
+unsigned int debugfs_idlestate_read_file(unsigned int cpu,
+				unsigned int idlestate, const char *fname,
+				char *buf, size_t buflen)
+{
+	char path[DEBUGFS_PATH_MAX];
+	int fd;
+	ssize_t numread;
+
+	if (get_debugfs_root() == NULL)
+		return 0;
+
+	snprintf(path, sizeof(path), "%s/cpu/" "cpu%u/cpuidle/state%u/%s",
+		 debugfs_root, cpu, idlestate, fname);
+
+	fd = open(path, O_RDONLY);
+	if (fd == -1)
+		return 0;
+
+	numread = read(fd, buf, buflen - 1);
+	if (numread < 1) {
+		close(fd);
+		return 0;
+	}
+
+	buf[numread] = '\0';
+	close(fd);
+
+	return (unsigned int) numread;
+}
+
+/* read access to files which contain one numeric value */
+
+enum idlestate_value {
+	IDLESTATE_USAGE,
+	IDLESTATE_POWER,
+	IDLESTATE_LATENCY,
+	IDLESTATE_TIME,
+	MAX_IDLESTATE_VALUE_FILES
+};
+
+static const char *idlestate_value_files[MAX_IDLESTATE_VALUE_FILES] = {
+	[IDLESTATE_USAGE] = "usage",
+	[IDLESTATE_POWER] = "power",
+	[IDLESTATE_LATENCY] = "latency",
+	[IDLESTATE_TIME]  = "time",
+};
+
+static unsigned long long debugfs_idlestate_get_one_value(unsigned int cpu,
+						     unsigned int idlestate,
+						     enum idlestate_value which)
+{
+	unsigned long long value;
+	unsigned int len;
+	char linebuf[255];
+	char *endp;
+
+	if (which >= MAX_IDLESTATE_VALUE_FILES)
+		return 0;
+
+	len = debugfs_idlestate_read_file(cpu, idlestate,
+					idlestate_value_files[which],
+					linebuf, sizeof(linebuf));
+	if (len == 0)
+		return 0;
+
+	value = strtoull(linebuf, &endp, 0);
+
+	if (endp == linebuf || errno == ERANGE)
+		return 0;
+
+	return value;
+}
+
+/* read access to files which contain one string */
+
+enum idlestate_string {
+	IDLESTATE_DESC,
+	IDLESTATE_NAME,
+	MAX_IDLESTATE_STRING_FILES
+};
+
+static const char *idlestate_string_files[MAX_IDLESTATE_STRING_FILES] = {
+	[IDLESTATE_DESC] = "desc",
+	[IDLESTATE_NAME] = "name",
+};
+
+
+static char *debugfs_idlestate_get_one_string(unsigned int cpu,
+					unsigned int idlestate,
+					enum idlestate_string which)
+{
+	char linebuf[255];
+	char *result;
+	unsigned int len;
+
+	if (which >= MAX_IDLESTATE_STRING_FILES)
+		return NULL;
+
+	len = debugfs_idlestate_read_file(cpu, idlestate,
+					idlestate_string_files[which],
+					linebuf, sizeof(linebuf));
+	if (len == 0)
+		return NULL;
+
+	result = strdup(linebuf);
+	if (result == NULL)
+		return NULL;
+
+	if (result[strlen(result) - 1] == '\n')
+		result[strlen(result) - 1] = '\0';
+
+	return result;
+}
+
+unsigned long debugfs_get_idlestate_latency(unsigned int cpu,
+					unsigned int idlestate)
+{
+	return debugfs_idlestate_get_one_value(cpu, idlestate,
+						IDLESTATE_LATENCY);
+}
+
+unsigned long debugfs_get_idlestate_usage(unsigned int cpu,
+					unsigned int idlestate)
+{
+	return debugfs_idlestate_get_one_value(cpu, idlestate,
+						IDLESTATE_USAGE);
+}
+
+unsigned long long debugfs_get_idlestate_time(unsigned int cpu,
+					unsigned int idlestate)
+{
+	return debugfs_idlestate_get_one_value(cpu, idlestate,
+						IDLESTATE_TIME);
+}
+
+char *debugfs_get_idlestate_name(unsigned int cpu, unsigned int idlestate)
+{
+	return debugfs_idlestate_get_one_string(cpu, idlestate,
+						IDLESTATE_NAME);
+}
+
+char *debugfs_get_idlestate_desc(unsigned int cpu, unsigned int idlestate)
+{
+	return debugfs_idlestate_get_one_string(cpu, idlestate,
+						IDLESTATE_DESC);
+}
+
+/*
+ * Returns number of supported C-states of CPU core cpu
+ * Negativ in error case
+ * Zero if cpuidle does not export any C-states
+ */
+int debugfs_get_idlestate_count(unsigned int cpu)
+{
+	char file[DEBUGFS_PATH_MAX];
+	struct stat statbuf;
+	int idlestates = 1;
+
+	if (get_debugfs_root() == NULL) {
+		perror("Please make sure debugfs has been mounted!\n");
+		return 0;
+	}
+
+	snprintf(file, DEBUGFS_PATH_MAX, "%s/cpu/" "cpu%u/cpuidle",
+					debugfs_root, cpu);
+	if (stat(file, &statbuf) != 0 || !S_ISDIR(statbuf.st_mode))
+		return -ENODEV;
+
+	snprintf(file, DEBUGFS_PATH_MAX, "%s/cpu/" "cpu%u/cpuidle/state0",
+					debugfs_root, cpu);
+	if (stat(file, &statbuf) != 0 || !S_ISDIR(statbuf.st_mode))
+		return 0;
+
+	while (stat(file, &statbuf) == 0 && S_ISDIR(statbuf.st_mode)) {
+		snprintf(file, DEBUGFS_PATH_MAX, "%s/cpu/"
+				"cpu%u/cpuidle/state%d",
+				debugfs_root, cpu, idlestates);
+		idlestates++;
+	}
+	idlestates--;
+	return idlestates;
+}
diff --git a/tools/power/cpupower/utils/helpers/debugfs.h 
b/tools/power/cpupower/utils/helpers/debugfs.h
new file mode 100644
index 0000000..8db8afc
--- /dev/null
+++ b/tools/power/cpupower/utils/helpers/debugfs.h
@@ -0,0 +1,21 @@
+#ifndef __CPUPOWER_HELPERS_DEBUGFS_H__
+#define __CPUPOWER_HELPERS_DEBUGFS_H__
+
+#define _STR(x) #x
+#define STR(x) _STR(x)
+
+#define DEBUGFS_PATH_MAX 255
+
+extern unsigned long debugfs_get_idlestate_latency(unsigned int cpu,
+						unsigned int idlestate);
+extern unsigned long debugfs_get_idlestate_usage(unsigned int cpu,
+					unsigned int idlestate);
+extern unsigned long long debugfs_get_idlestate_time(unsigned int cpu,
+						unsigned int idlestate);
+extern char *debugfs_get_idlestate_name(unsigned int cpu,
+				unsigned int idlestate);
+extern char *debugfs_get_idlestate_desc(unsigned int cpu,
+				unsigned int idlestate);
+extern int debugfs_get_idlestate_count(unsigned int cpu);
+
+#endif /* __CPUPOWER_HELPERS_DEBUGFS_H__ */
diff --git a/tools/power/cpupower/utils/helpers/sysfs.c 
b/tools/power/cpupower/utils/helpers/sysfs.c
index c634302..e97a58e 100644
--- a/tools/power/cpupower/utils/helpers/sysfs.c
+++ b/tools/power/cpupower/utils/helpers/sysfs.c
@@ -106,181 +106,6 @@ int sysfs_is_cpu_online(unsigned int cpu)
  	return value;
  }

-/* CPUidle idlestate specific /sys/devices/system/cpu/cpuX/cpuidle/ 
access */
-
-/*
- * helper function to read file from /sys into given buffer
- * fname is a relative path under "cpuX/cpuidle/stateX/" dir
- * cstates starting with 0, C0 is not counted as cstate.
- * This means if you want C1 info, pass 0 as idlestate param
- */
-unsigned int sysfs_idlestate_read_file(unsigned int cpu, unsigned int 
idlestate,
-			     const char *fname, char *buf, size_t buflen)
-{
-	char path[SYSFS_PATH_MAX];
-	int fd;
-	ssize_t numread;
-
-	snprintf(path, sizeof(path), PATH_TO_CPU "cpu%u/cpuidle/state%u/%s",
-		 cpu, idlestate, fname);
-
-	fd = open(path, O_RDONLY);
-	if (fd == -1)
-		return 0;
-
-	numread = read(fd, buf, buflen - 1);
-	if (numread < 1) {
-		close(fd);
-		return 0;
-	}
-
-	buf[numread] = '\0';
-	close(fd);
-
-	return (unsigned int) numread;
-}
-
-/* read access to files which contain one numeric value */
-
-enum idlestate_value {
-	IDLESTATE_USAGE,
-	IDLESTATE_POWER,
-	IDLESTATE_LATENCY,
-	IDLESTATE_TIME,
-	MAX_IDLESTATE_VALUE_FILES
-};
-
-static const char *idlestate_value_files[MAX_IDLESTATE_VALUE_FILES] = {
-	[IDLESTATE_USAGE] = "usage",
-	[IDLESTATE_POWER] = "power",
-	[IDLESTATE_LATENCY] = "latency",
-	[IDLESTATE_TIME]  = "time",
-};
-
-static unsigned long long sysfs_idlestate_get_one_value(unsigned int cpu,
-						     unsigned int idlestate,
-						     enum idlestate_value which)
-{
-	unsigned long long value;
-	unsigned int len;
-	char linebuf[MAX_LINE_LEN];
-	char *endp;
-
-	if (which >= MAX_IDLESTATE_VALUE_FILES)
-		return 0;
-
-	len = sysfs_idlestate_read_file(cpu, idlestate,
-					idlestate_value_files[which],
-					linebuf, sizeof(linebuf));
-	if (len == 0)
-		return 0;
-
-	value = strtoull(linebuf, &endp, 0);
-
-	if (endp == linebuf || errno == ERANGE)
-		return 0;
-
-	return value;
-}
-
-/* read access to files which contain one string */
-
-enum idlestate_string {
-	IDLESTATE_DESC,
-	IDLESTATE_NAME,
-	MAX_IDLESTATE_STRING_FILES
-};
-
-static const char *idlestate_string_files[MAX_IDLESTATE_STRING_FILES] = {
-	[IDLESTATE_DESC] = "desc",
-	[IDLESTATE_NAME] = "name",
-};
-
-
-static char *sysfs_idlestate_get_one_string(unsigned int cpu,
-					unsigned int idlestate,
-					enum idlestate_string which)
-{
-	char linebuf[MAX_LINE_LEN];
-	char *result;
-	unsigned int len;
-
-	if (which >= MAX_IDLESTATE_STRING_FILES)
-		return NULL;
-
-	len = sysfs_idlestate_read_file(cpu, idlestate,
-					idlestate_string_files[which],
-					linebuf, sizeof(linebuf));
-	if (len == 0)
-		return NULL;
-
-	result = strdup(linebuf);
-	if (result == NULL)
-		return NULL;
-
-	if (result[strlen(result) - 1] == '\n')
-		result[strlen(result) - 1] = '\0';
-
-	return result;
-}
-
-unsigned long sysfs_get_idlestate_latency(unsigned int cpu,
-					unsigned int idlestate)
-{
-	return sysfs_idlestate_get_one_value(cpu, idlestate, IDLESTATE_LATENCY);
-}
-
-unsigned long sysfs_get_idlestate_usage(unsigned int cpu,
-					unsigned int idlestate)
-{
-	return sysfs_idlestate_get_one_value(cpu, idlestate, IDLESTATE_USAGE);
-}
-
-unsigned long long sysfs_get_idlestate_time(unsigned int cpu,
-					unsigned int idlestate)
-{
-	return sysfs_idlestate_get_one_value(cpu, idlestate, IDLESTATE_TIME);
-}
-
-char *sysfs_get_idlestate_name(unsigned int cpu, unsigned int idlestate)
-{
-	return sysfs_idlestate_get_one_string(cpu, idlestate, IDLESTATE_NAME);
-}
-
-char *sysfs_get_idlestate_desc(unsigned int cpu, unsigned int idlestate)
-{
-	return sysfs_idlestate_get_one_string(cpu, idlestate, IDLESTATE_DESC);
-}
-
-/*
- * Returns number of supported C-states of CPU core cpu
- * Negativ in error case
- * Zero if cpuidle does not export any C-states
- */
-int sysfs_get_idlestate_count(unsigned int cpu)
-{
-	char file[SYSFS_PATH_MAX];
-	struct stat statbuf;
-	int idlestates = 1;
-
-
-	snprintf(file, SYSFS_PATH_MAX, PATH_TO_CPU "cpuidle");
-	if (stat(file, &statbuf) != 0 || !S_ISDIR(statbuf.st_mode))
-		return -ENODEV;
-
-	snprintf(file, SYSFS_PATH_MAX, PATH_TO_CPU "cpu%u/cpuidle/state0", cpu);
-	if (stat(file, &statbuf) != 0 || !S_ISDIR(statbuf.st_mode))
-		return 0;
-
-	while (stat(file, &statbuf) == 0 && S_ISDIR(statbuf.st_mode)) {
-		snprintf(file, SYSFS_PATH_MAX, PATH_TO_CPU
-			 "cpu%u/cpuidle/state%d", cpu, idlestates);
-		idlestates++;
-	}
-	idlestates--;
-	return idlestates;
-}
-
  /* CPUidle general /sys/devices/system/cpu/cpuidle/ sysfs access ********/

  /*
@@ -297,8 +122,6 @@ static unsigned int sysfs_cpuidle_read_file(const 
char *fname, char *buf,
  	return sysfs_read_file(path, buf, buflen);
  }

-
-
  /* read access to files which contain one string */

  enum cpuidle_string {
diff --git a/tools/power/cpupower/utils/helpers/sysfs.h 
b/tools/power/cpupower/utils/helpers/sysfs.h
index 8cb797b..d189777 100644
--- a/tools/power/cpupower/utils/helpers/sysfs.h
+++ b/tools/power/cpupower/utils/helpers/sysfs.h
@@ -9,18 +9,6 @@ extern unsigned int sysfs_read_file(const char *path, 
char *buf, size_t buflen);

  extern int sysfs_is_cpu_online(unsigned int cpu);

-extern unsigned long sysfs_get_idlestate_latency(unsigned int cpu,
-						unsigned int idlestate);
-extern unsigned long sysfs_get_idlestate_usage(unsigned int cpu,
-					unsigned int idlestate);
-extern unsigned long long sysfs_get_idlestate_time(unsigned int cpu,
-						unsigned int idlestate);
-extern char *sysfs_get_idlestate_name(unsigned int cpu,
-				unsigned int idlestate);
-extern char *sysfs_get_idlestate_desc(unsigned int cpu,
-				unsigned int idlestate);
-extern int sysfs_get_idlestate_count(unsigned int cpu);
-
  extern char *sysfs_get_cpuidle_governor(void);
  extern char *sysfs_get_cpuidle_driver(void);

diff --git a/tools/power/cpupower/utils/idle_monitor/cpuidle_sysfs.c 
b/tools/power/cpupower/utils/idle_monitor/cpuidle_sysfs.c
index bcd22a1..a10fec9 100644
--- a/tools/power/cpupower/utils/idle_monitor/cpuidle_sysfs.c
+++ b/tools/power/cpupower/utils/idle_monitor/cpuidle_sysfs.c
@@ -12,6 +12,7 @@
  #include <limits.h>

  #include "helpers/sysfs.h"
+#include "helpers/debugfs.h"
  #include "helpers/helpers.h"
  #include "idle_monitor/cpupower-monitor.h"

@@ -51,7 +52,7 @@ static int cpuidle_start(void)
  		for (state = 0; state < cpuidle_sysfs_monitor.hw_states_num;
  		     state++) {
  			previous_count[cpu][state] =
-				sysfs_get_idlestate_time(cpu, state);
+				debugfs_get_idlestate_time(cpu, state);
  			dprint("CPU %d - State: %d - Val: %llu\n",
  			       cpu, state, previous_count[cpu][state]);
  		}
@@ -70,7 +71,7 @@ static int cpuidle_stop(void)
  		for (state = 0; state < cpuidle_sysfs_monitor.hw_states_num;
  		     state++) {
  			current_count[cpu][state] =
-				sysfs_get_idlestate_time(cpu, state);
+				debugfs_get_idlestate_time(cpu, state);
  			dprint("CPU %d - State: %d - Val: %llu\n",
  			       cpu, state, previous_count[cpu][state]);
  		}
@@ -132,13 +133,13 @@ static struct cpuidle_monitor *cpuidle_register(void)
  	char *tmp;

  	/* Assume idle state count is the same for all CPUs */
-	cpuidle_sysfs_monitor.hw_states_num = sysfs_get_idlestate_count(0);
+	cpuidle_sysfs_monitor.hw_states_num = debugfs_get_idlestate_count(0);

  	if (cpuidle_sysfs_monitor.hw_states_num <= 0)
  		return NULL;

  	for (num = 0; num < cpuidle_sysfs_monitor.hw_states_num; num++) {
-		tmp = sysfs_get_idlestate_name(0, num);
+		tmp = debugfs_get_idlestate_name(0, num);
  		if (tmp == NULL)
  			continue;

@@ -146,7 +147,7 @@ static struct cpuidle_monitor *cpuidle_register(void)
  		strncpy(cpuidle_cstates[num].name, tmp, CSTATE_NAME_LEN - 1);
  		free(tmp);

-		tmp = sysfs_get_idlestate_desc(0, num);
+		tmp = debugfs_get_idlestate_desc(0, num);
  		if (tmp == NULL)
  			continue;
  		strncpy(cpuidle_cstates[num].desc, tmp,	CSTATE_DESC_LEN - 1);
-- 
1.7.1

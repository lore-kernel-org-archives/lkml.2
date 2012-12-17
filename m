Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab2LQNhf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 08:37:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125Ab2LQNhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 08:37:33 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/3] perf tool: Add support to include non architectural event aliases
Date: Mon, 17 Dec 2012 14:37:04 +0100
Message-Id: <1355751425-7993-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1355751425-7993-1-git-send-email-jolsa@redhat.com>
References: <1355751425-7993-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support to parse non architectural event aliases
for given cpu. These aliases will be provided as 'events'
directory like architectural ones provided by kernel.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 tools/perf/arch/x86/Makefile   |  7 +++
 tools/perf/arch/x86/util/pmu.c | 98 ++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/pmu.c          | 18 +++++---
 tools/perf/util/pmu.h          |  4 ++
 4 files changed, 121 insertions(+), 6 deletions(-)
 create mode 100644 tools/perf/arch/x86/util/pmu.c

diff --git a/tools/perf/arch/x86/Makefile b/tools/perf/arch/x86/Makefile
index 815841c..c175f65 100644
--- a/tools/perf/arch/x86/Makefile
+++ b/tools/perf/arch/x86/Makefile
@@ -6,3 +6,10 @@ ifndef NO_LIBUNWIND
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/unwind.o
 endif
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/header.o
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/pmu.o
+
+$(OUTPUT)$(OUTPUT)arch/$(ARCH)/util/pmu.o: $(OUTPUT)arch/$(ARCH)/util/pmu.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) \
+	 '-DPERF_EXEC_PATH="$(perfexecdir_SQ)"' \
+	 '-DPREFIX="$(prefix_SQ)"' \
+	 $<
diff --git a/tools/perf/arch/x86/util/pmu.c b/tools/perf/arch/x86/util/pmu.c
new file mode 100644
index 0000000..0938c70
--- /dev/null
+++ b/tools/perf/arch/x86/util/pmu.c
@@ -0,0 +1,98 @@
+
+#include <linux/compiler.h>
+#include <linux/kernel.h>
+#include <stdio.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
+#include "pmu.h"
+#include "util.h"
+#include "sysfs.h"
+
+static int intel_aliases(struct list_head *head, unsigned model)
+{
+	struct stat st;
+	char path[PATH_MAX];
+	const char *model_str;
+
+	switch (model) {
+	case 42:
+		model_str = "SandyBridge";
+		break;
+	default:
+		/* unknown model.. plenty to cover ;-) */
+		return 0;
+	}
+
+	/* try local one first */
+	scnprintf(path, PATH_MAX, "./arch/x86/events/intel/%s/", model_str);
+
+	if (stat(path, &st) < 0) {
+		scnprintf(path, PATH_MAX, "%s/%s/events/x86/intel/%s/",
+			  PREFIX, PERF_EXEC_PATH, model_str);
+
+		if (stat(path, &st) < 0)
+			return -1;
+	}
+
+	if (pmu_aliases_parse(path, head))
+		return -1;
+
+	return 0;
+}
+
+static int cpu_specs(unsigned *vendor, unsigned *model)
+{
+	FILE *file;
+	struct stat st;
+	char path[PATH_MAX];
+	int ret = 0;
+
+	scnprintf(path, PATH_MAX, "%s/devices/system/cpu/modalias",
+		  sysfs_find_mountpoint());
+
+	if (stat(path, &st) < 0)
+		return -ENOENT;
+
+	file = fopen(path, "r");
+	if (!file)
+		return -errno;
+
+	if (2 != fscanf(file, "x86cpu:vendor:%X:family:%*X:model:%X:",
+			vendor, model))
+		ret = -1;
+
+	fclose(file);
+	return ret;
+}
+
+static int cpu_aliases(struct list_head *head)
+{
+	unsigned vendol, model;
+	int ret;
+
+	ret = cpu_specs(&vendol, &model);
+	if (ret) {
+		pr_info("failed to get cpu aliases");
+		return 0;
+	}
+
+	switch (vendol) {
+	/* Intel */
+	case 0:
+		return intel_aliases(head, model);
+	default:
+		/* unknown vendor.. plenty to cover ;-) */
+		return 0;
+	}
+
+	return 0;
+}
+
+int arch_pmu_aliases(char *name, struct list_head *head)
+{
+	if (!strcmp(name, "cpu"))
+		return cpu_aliases(head);
+
+	return 0;
+}
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 9bdc60c..626d9d7 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -114,7 +114,7 @@ static int perf_pmu__new_alias(struct list_head *list, char *name, FILE *file)
  * Process all the sysfs attributes located under the directory
  * specified in 'dir' parameter.
  */
-static int pmu_aliases_parse(char *dir, struct list_head *head)
+int pmu_aliases_parse(char *dir, struct list_head *head)
 {
 	struct dirent *evt_ent;
 	DIR *event_dir;
@@ -146,6 +146,13 @@ static int pmu_aliases_parse(char *dir, struct list_head *head)
 	return ret;
 }
 
+__attribute__((weak))
+int arch_pmu_aliases(char *name __maybe_unused,
+		     struct list_head *head __maybe_unused)
+{
+	return 0;
+}
+
 /*
  * Reading the pmu event aliases definition, which should be located at:
  * /sys/bus/event_source/devices/<dev>/events as sysfs group attributes.
@@ -163,13 +170,12 @@ static int pmu_aliases(char *name, struct list_head *head)
 	snprintf(path, PATH_MAX,
 		 "%s/bus/event_source/devices/%s/events", sysfs, name);
 
-	if (stat(path, &st) < 0)
-		return 0;	 /* no error if 'events' does not exist */
-
-	if (pmu_aliases_parse(path, head))
+	/* no error if 'events' does not exist */
+	if (!stat(path, &st) &&
+	    pmu_aliases_parse(path, head))
 		return -1;
 
-	return 0;
+	return arch_pmu_aliases(name, head);
 }
 
 static int pmu_alias_terms(struct perf_pmu__alias *alias,
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index a313ed7..62da834 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -53,5 +53,9 @@ int perf_pmu__format_parse(char *dir, struct list_head *head);
 
 struct perf_pmu *perf_pmu__scan(struct perf_pmu *pmu);
 
+int pmu_aliases_parse(char *dir, struct list_head *head);
+
+int arch_pmu_aliases(char *name, struct list_head *head);
+
 int perf_pmu__test(void);
 #endif /* __PMU_H */
-- 
1.7.11.7


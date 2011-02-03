Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750920Ab1BCFFY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 00:05:24 -0500
Received: from outmail011.snc4.facebook.com ([66.220.144.143]:36122 "EHLO
	mx-out.facebook.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750713Ab1BCFFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 00:05:23 -0500
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Feb 2011 00:05:23 EST
Date: Wed, 2 Feb 2011 21:00:21 -0800
From: Arun Sharma <asharma@fb.com>
To: linux-kernel@vger.kernel.org, acme@redhat.com
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tom Zanussi <tzanussi@gmail.com>,
        perfmon2-devel@lists.sourceforge.net
Subject: [PATCH] Add libpfm4 support
Message-ID: <20110203050021.GA29482@radium.snc4.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


libpfm4 is a library that takes a CPU vendor documentation
compatible string and fills out perf_event_attr. Typical
use case: user wants to look at events other than the 
ones supported by perf using symbolic names.

Signed-off-by: Arun Sharma <asharma@fb.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: perfmon2-devel@lists.sourceforge.net

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 2b5387d..a358e54 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -602,6 +602,19 @@ else
 	endif
 endif
 
+ifdef NO_LIBPFM4
+	BASIC_CFLAGS += -DNO_LIBPFM4_SUPPORT
+else
+	FLAGS_LIBPFM4=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -lpfm
+	ifneq ($(call try-cc,$(SOURCE_LIBPFM4),$(FLAGS_LIBPFM4)),y)
+		msg := $(warning libpfm4 not found, events restricted to generic ones. Please install libpfm4-devel or libpfm4-dev);
+		BASIC_CFLAGS += -DNO_LIBPFM4_SUPPORT
+	else
+		BASIC_CFLAGS += -DLIBPFM4
+		EXTLIBS += -lpfm
+	endif
+endif
+
 ifdef NO_LIBPERL
 	BASIC_CFLAGS += -DNO_LIBPERL
 else
diff --git a/tools/perf/feature-tests.mak b/tools/perf/feature-tests.mak
index b041ca6..ec6b27b 100644
--- a/tools/perf/feature-tests.mak
+++ b/tools/perf/feature-tests.mak
@@ -121,6 +121,17 @@ int main(void)
 }
 endef
 
+ifndef NO_LIBPFM4
+define SOURCE_LIBPFM4
+#include <perfmon/pfmlib_perf_event.h>
+
+int main(void)
+{
+	return pfm_initialize();
+}
+endef
+endif
+
 # try-cc
 # Usage: option = $(call try-cc, source-to-build, cc-options)
 try-cc = $(shell sh -c						  \
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 5b1ecd6..0fde6d3 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -474,6 +474,12 @@ int main(int argc, const char **argv)
 	}
 	cmd = argv[0];
 
+#ifdef LIBPFM4
+	if (pfm_initialize() != PFM_SUCCESS) {
+		fprintf(stderr, "pfm_initialize failed\n");
+		return 1;
+ 	}
+#endif
 	/*
 	 * We use PATH to find perf commands, but we prepend some higher
 	 * precedence paths: the "--exec-path" option, the PERF_EXEC_PATH
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 5cb6f4b..f1597dd 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -724,6 +724,47 @@ parse_numeric_event(const char **strp, struct perf_event_attr *attr)
 	return EVT_FAILED;
 }
 
+#ifdef LIBPFM4
+static enum event_result
+parse_libpfm4_event(const char **strp, struct perf_event_attr *attr)
+{
+	int ret;
+	const char *str = *strp;
+	const char *comma_loc = NULL;
+	char *evt_name = NULL;
+	size_t len = 0;
+
+	comma_loc = strchr(str, ',');
+	if (comma_loc) {
+		/* take the event name up to the comma */
+		len = comma_loc - str;
+		evt_name = strndup(str, len+1);
+		if (evt_name == NULL) {
+			pr_err("strndup returned NULL. Out of memory?");
+			return EVT_FAILED;
+		}
+		evt_name[len] = '\0';
+	} else {
+		evt_name = (char *) *strp;
+	}
+	
+	ret = pfm_get_perf_event_encoding(evt_name, PFM_PLM0|PFM_PLM3, attr,
+					  NULL, NULL);
+	if (ret != PFM_SUCCESS) {
+		return EVT_FAILED;
+	}
+	
+	if (comma_loc) {
+		*strp += len;
+		free(evt_name);
+	} else {
+		*strp += strlen(evt_name);
+	}
+
+	return EVT_HANDLED;
+}
+#endif
+
 static enum event_result
 parse_event_modifier(const char **strp, struct perf_event_attr *attr)
 {
@@ -789,6 +830,17 @@ parse_event_symbols(const char **str, struct perf_event_attr *attr)
 	if (ret != EVT_FAILED)
 		goto modifier;
 
+#ifdef LIBPFM4
+	/*
+	 * Handle libpfm4 before generic_hw events.
+	 * Some events (eg: LLC_MISSES) fail otherwise.
+	 */
+	ret = parse_libpfm4_event(str, attr);
+	if (ret != EVT_FAILED)
+		/* libpfm4 has its own modifier parsing code */
+		goto modifier;
+#endif
+
 	ret = parse_generic_hw_event(str, attr);
 	if (ret != EVT_FAILED)
 		goto modifier;
@@ -995,6 +1047,45 @@ void print_events(void)
 		}
 	}
 
+#ifdef LIBPFM4
+	printf("\n");
+	pfm_for_all_pmus(i) {
+		int ret;
+		pfm_pmu_info_t pinfo;
+		int count;
+		int k;
+
+		ret = pfm_get_pmu_info(i, &pinfo);
+		if (ret != PFM_SUCCESS)
+			continue;
+		if (!pinfo.is_present)
+			continue;
+		if (pinfo.pmu == PFM_PMU_PERF_EVENT)
+			continue;
+
+		printf("\nDetected PMU:  %s -- %s Total events: %d\n", 
+			pinfo.name,
+			pinfo.desc,
+			pinfo.nevents);
+
+		count = 0;
+		pfm_for_each_event(k) {
+			pfm_event_info_t info;
+
+			ret = pfm_get_event_info(k, &info);
+			if (info.pmu != pinfo.pmu)
+				continue;
+
+			count++;
+			if (count > pinfo.nevents)
+				break;
+			printf("  %-42s [%s]\n",
+				info.name,
+				event_type_descriptors[PERF_TYPE_HARDWARE]);
+		}
+	}
+#endif
+
 	printf("\n");
 	printf("  %-42s [%s]\n",
 		"rNNN (see 'perf list --help' on how to encode it)",
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index b82cafb..4a30ade 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -5,6 +5,9 @@
  */
 
 #include "../../../include/linux/perf_event.h"
+#ifdef LIBPFM4
+#include <perfmon/pfmlib_perf_event.h>
+#endif
 
 struct list_head;
 struct perf_evsel;

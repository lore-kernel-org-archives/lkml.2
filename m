Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102Ab2I1Iig (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 04:38:36 -0400
Received: from mga14.intel.com ([143.182.124.37]:30725 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756942Ab2I1IhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 04:37:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,501,1344236400"; 
   d="scan'208";a="150188641"
From: Feng Tang <feng.tang@intel.com>
To: acme@redhat.com
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, andi@firstfloor.org,
        namhyung@kernel.org, dsahern@gmail.com, linux-kernel@vger.kernel.org,
        Feng Tang <feng.tang@intel.com>
Subject: [PATCH v4 7/8] perf hists browser: Add option for runtime switching perf data file
Date: Fri, 28 Sep 2012 16:30:39 +0800
Message-Id: <1348821040-9724-8-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1348821040-9724-1-git-send-email-feng.tang@intel.com>
References: <1348821040-9724-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on perf report/top/scripts browser integration idea from acme.

This will enable user to runtime switch the data file, when this option
is selected, it will popup all the legal data files in current working
directory, and the filename selected by user is saved in the global
variable "input_name", and a new key 'K_SWITCH_INPUT_DATA' will be
passed back to the built-in command which will perform the switch.

This initial version only enables it for 'perf report', by checking
the "timer" parameter of perf_evsel__hists_browser() equals NULL.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 tools/perf/ui/browsers/hists.c |  106 +++++++++++++++++++++++++++++++++++++++-
 tools/perf/ui/keysyms.h        |    1 +
 2 files changed, 106 insertions(+), 1 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index edada57..be47bb3 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1125,6 +1125,91 @@ static inline void free_popup_options(char **options, int n)
 	}
 }
 
+/*
+ * Only runtime switching of perf data file will make "input_name" point
+ * to a malloced buffer. So add "is_input_name_malloced" flag to decide
+ * whether we need to call free() for current "input_name" during the switch.
+ */
+static bool is_input_name_malloced = false;
+
+static int switch_data_file(void)
+{
+	char *pwd, *options[256], *abs_path[256], *tmp;
+	DIR *pwd_dir;
+	int nr_options = 0, choice = -1, ret = -1;
+
+	struct dirent *dent;
+
+	pwd = getenv("PWD");
+	if (!pwd)
+		return ret;
+
+	pwd_dir = opendir(pwd);
+	if (!pwd_dir)
+		return ret;
+
+	memset(options, 0, sizeof(options));
+	memset(options, 0, sizeof(abs_path));
+
+	while ((dent = readdir(pwd_dir))) {
+		char path[PATH_MAX];
+		u64 magic;
+		char *name = dent->d_name;
+		FILE *file;
+
+		if (!(dent->d_type == DT_REG))
+			continue;
+
+		snprintf(path, PATH_MAX, "%s/%s", pwd, name);
+
+		file = fopen(path, "r");
+		if (!file)
+			continue;
+
+		if (fread(&magic, 1, 8, file) < 8)
+			goto close_file_and_continue;
+
+		if (is_perf_magic(magic)) {
+			options[nr_options] = strdup(name);
+			if (!options[nr_options])
+				goto close_file_and_continue;
+
+			abs_path[nr_options] = strdup(path);
+			if (!abs_path[nr_options]) {
+				free(options[nr_options]);
+				goto close_file_and_continue;
+			}
+
+			nr_options++;
+		}
+
+close_file_and_continue:
+		fclose(file);
+		if (nr_options >= 256)
+			break;
+	}
+	closedir(pwd_dir);
+
+	if (nr_options) {
+		choice = ui__popup_menu(nr_options, options);
+		if (choice < nr_options && choice >= 0) {
+			tmp = strdup(abs_path[choice]);
+			if (tmp) {
+				if (is_input_name_malloced)
+					free((void *)input_name);
+				input_name = tmp;
+				is_input_name_malloced = true;
+				ret = 0;
+			}
+		}
+	}
+
+	free_popup_options(options, nr_options);
+	free_popup_options(abs_path, nr_options);
+	return ret;
+}
+
+
 static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 				    const char *helpline, const char *ev_name,
 				    bool left_exits,
@@ -1158,7 +1243,8 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 		int choice = 0,
 		    annotate = -2, zoom_dso = -2, zoom_thread = -2,
 		    annotate_f = -2, annotate_t = -2, browse_map = -2;
-		int scripts_comm = -2, scripts_symbol = -2, scripts_all = -2;
+		int scripts_comm = -2, scripts_symbol = -2,
+		    scripts_all = -2, switch_data = -2;
 
 		nr_options = 0;
 
@@ -1213,6 +1299,11 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 			continue;
 		case 'r':
 			goto do_scripts;
+		case 's':
+			/* input_name for 'perf top' is NULL */
+			if (input_name)
+				goto do_data_switch;
+			continue;
 		case K_F1:
 		case 'h':
 		case '?':
@@ -1232,6 +1323,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 					"d             Zoom into current DSO\n"
 					"t             Zoom into current Thread\n"
 					"r             Run available scripts\n"
+					"s             Switch to another data file in PWD\n"
 					"P             Print histograms to perf.hist.N\n"
 					"V             Verbose (DSO names in callchains, etc)\n"
 					"/             Filter symbol by name");
@@ -1339,6 +1431,9 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 		if (asprintf(&options[nr_options], "Run scripts for all samples") > 0)
 			scripts_all = nr_options++;
 
+		if (!timer && asprintf(&options[nr_options],
+				"Switch to another data file in PWD") > 0)
+			switch_data = nr_options++;
 add_exit_option:
 		options[nr_options++] = (char *)"Exit";
 retry_popup_menu:
@@ -1447,6 +1542,14 @@ do_scripts:
 
 			script_browse(script_opt);
 		}
+		/* Switch to another data file */
+		else if (choice == switch_data) {
+do_data_switch:
+			if (!switch_data_file()) {
+				key = K_SWITCH_INPUT_DATA;
+				break;
+			}
+		}
 	}
 out_free_stack:
 	pstack__delete(fstack);
@@ -1561,6 +1664,7 @@ browse_hists:
 						"Do you really want to exit?"))
 					continue;
 				/* Fall thru */
+			case K_SWITCH_INPUT_DATA:
 			case 'q':
 			case CTRL('c'):
 				goto out;
diff --git a/tools/perf/ui/keysyms.h b/tools/perf/ui/keysyms.h
index 809eca5..65092d5 100644
--- a/tools/perf/ui/keysyms.h
+++ b/tools/perf/ui/keysyms.h
@@ -23,5 +23,6 @@
 #define K_TIMER	 -1
 #define K_ERROR	 -2
 #define K_RESIZE -3
+#define K_SWITCH_INPUT_DATA -4
 
 #endif /* _PERF_KEYSYMS_H_ */
-- 
1.7.1


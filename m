Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537Ab2IXPaq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 11:30:46 -0400
Received: from mga03.intel.com ([143.182.124.21]:56118 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756498Ab2IXPan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 11:30:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,476,1344236400"; 
   d="scan'208";a="196413253"
From: Feng Tang <feng.tang@intel.com>
To: acme@redhat.com
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, andi@firstfloor.org,
        namhyung@kernel.org, dsahern@gmail.com, linux-kernel@vger.kernel.org,
        Feng Tang <feng.tang@intel.com>
Subject: [PATCH v3 8/9] perf hists browser: Add option for runtime switching perf data file
Date: Mon, 24 Sep 2012 23:24:10 +0800
Message-Id: <1348500251-9937-9-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1348500251-9937-1-git-send-email-feng.tang@intel.com>
References: <1348500251-9937-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on perf report/top/scripts browser integration idea from acme.

This will enable user to runtime swich the data file, when this option
is selected, it will popup all the legal data files in current working
directory, and the filename selected by user is saved in the global
variable "input_name", and a new key 'K_SWITCH_INPUT_DATA' will be
passed back and notify the builtin command that there is a pending data
switch, andd the command will perform the switch.

This initial version only enables it for 'perf report', by checking
the "timer" parameter of perf_evsel__hists_browser() equals NULL.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 tools/perf/ui/browsers/hists.c |   75 +++++++++++++++++++++++++++++++++++++++-
 tools/perf/ui/keysyms.h        |    1 +
 2 files changed, 75 insertions(+), 1 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index c491b78..7390614 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1125,6 +1125,67 @@ static inline void free_popup_options(char **options, int n)
 	}
 }
 
+static int switch_data_file(void)
+{
+	char *pwd, *options[256], *abs_path[256];
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
+		if (fread(&magic, 1, 8, file) < 8) {
+			fclose(file);
+			continue;
+		}
+
+		if (!check_perf_magic(magic)) {
+			options[nr_options] = strdup(name);
+			abs_path[nr_options++] = strdup(path);
+		}
+		fclose(file);
+	}
+	closedir(pwd_dir);
+
+	if (nr_options) {
+		choice = ui__popup_menu(nr_options, options);
+		if (choice < nr_options && choice >= 0) {
+			input_name = strdup(abs_path[choice]);
+			ret = 0;
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
@@ -1159,7 +1220,8 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 		int choice = 0,
 		    annotate = -2, zoom_dso = -2, zoom_thread = -2,
 		    annotate_f = -2, annotate_t = -2, browse_map = -2;
-		int scripts_comm = -2, scripts_symbol = -2, scripts_all = -2;
+		int scripts_comm = -2, scripts_symbol = -2,
+		    scripts_all = -2, switch_data = -2;
 
 		nr_options = 0;
 
@@ -1340,6 +1402,9 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 		if (asprintf(&options[nr_options], "Run scripts for all samples") > 0)
 			scripts_all = nr_options++;
 
+		if (!timer && asprintf(&options[nr_options],
+				"Switch to another data file in current dir") > 0)
+			switch_data = nr_options++;
 add_exit_option:
 		options[nr_options++] = (char *)"Exit";
 retry_popup_menu:
@@ -1446,6 +1511,13 @@ do_scripts:
 
 			script_browse(script_opt);
 		}
+		/* Switch to another data file */
+		else if (choice == switch_data) {
+			if (!switch_data_file()) {
+				key = K_SWITCH_INPUT_DATA;
+				break;
+			}
+		}
 	}
 out_free_stack:
 	pstack__delete(fstack);
@@ -1560,6 +1632,7 @@ browse_hists:
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


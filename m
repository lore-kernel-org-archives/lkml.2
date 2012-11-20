Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349Ab2KTQR0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 11:17:26 -0500
Received: from mga03.intel.com ([143.182.124.21]:4457 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513Ab2KTQRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 11:17:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,286,1352102400"; 
   d="scan'208";a="170605871"
Date: Wed, 21 Nov 2012 00:16:28 +0800
From: Feng Tang <feng.tang@intel.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] perf hists browser: Add option for runtime switching
 perf data file
Message-ID: <20121120161628.GA522@feng-snb>
References: <1353403877-10730-1-git-send-email-feng.tang@intel.com>
 <1353403877-10730-2-git-send-email-feng.tang@intel.com>
 <20121120151644.GB14928@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121120151644.GB14928@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Tue, Nov 20, 2012 at 12:16:44PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Tue, Nov 20, 2012 at 05:31:16PM +0800, Feng Tang escreveu:
> > +static int switch_data_file(void)
> > +{
> > +	char *pwd, *options[32], *abs_path[32], *tmp;
> > +	DIR *pwd_dir;
> > +	int nr_options = 0, choice = -1, ret = -1;
> > +
> 
> no need for this empty line
> 
> > +	while ((dent = readdir(pwd_dir))) {
> > +		char path[PATH_MAX];
> > +		u64 magic;
> > +		char *name = dent->d_name;
> > +		FILE *file;
> > +
> > +		if (!(dent->d_type == DT_REG))
> > +			continue;
> > +
> > +		snprintf(path, PATH_MAX, "%s/%s", pwd, name);
> 
>                        sizeof(path)

Thanks for the review, here is the updated one:


>From 6e3259cf652af9f3c41bdc76c71190b7a723f702 Mon Sep 17 00:00:00 2001
From: Feng Tang <feng.tang@intel.com>
Date: Tue, 20 Nov 2012 16:21:10 +0800
Subject: [PATCH 2/3] perf hists browser: Add option for runtime switching
 perf data file

Based on perf report/top/scripts browser integration idea from acme.

This will enable user to runtime switch the data file, when this option
is selected, it will popup all the legal data files in current working
directory, and the filename selected by user is saved in the global
variable "input_name", and a new key 'K_SWITCH_INPUT_DATA' will be
passed back to the built-in command which will perform the switch.

This initial version only enables it for 'perf report'.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 tools/perf/ui/browsers/hists.c |  113 +++++++++++++++++++++++++++++++++++++++-
 tools/perf/ui/keysyms.h        |    1 +
 2 files changed, 113 insertions(+), 1 deletion(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index ccc4bd1..c64254b 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1135,6 +1135,97 @@ static inline bool is_report_browser(void *timer)
 	return timer == NULL;
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
+	char *pwd, *options[32], *abs_path[32], *tmp;
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
+				ui__warning("Can't search all data files due to memory shortage.\n");
+				fclose(file);
+				break;
+			}
+
+			nr_options++;
+		}
+
+close_file_and_continue:
+		fclose(file);
+		if (nr_options >= 32) {
+			ui__warning("Too many perf data files in PWD!\n"
+				    "Only the first 32 files will be listed.\n");
+			break;
+		}
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
+			} else
+				ui__warning("Data switch failed due to memory shortage!\n");
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
@@ -1169,7 +1260,8 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 		int choice = 0,
 		    annotate = -2, zoom_dso = -2, zoom_thread = -2,
 		    annotate_f = -2, annotate_t = -2, browse_map = -2;
-		int scripts_comm = -2, scripts_symbol = -2, scripts_all = -2;
+		int scripts_comm = -2, scripts_symbol = -2,
+		    scripts_all = -2, switch_data = -2;
 
 		nr_options = 0;
 
@@ -1226,6 +1318,10 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 			if (is_report_browser(hbt))
 				goto do_scripts;
 			continue;
+		case 's':
+			if (is_report_browser(hbt))
+				goto do_data_switch;
+			continue;
 		case K_F1:
 		case 'h':
 		case '?':
@@ -1245,6 +1341,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 					"d             Zoom into current DSO\n"
 					"t             Zoom into current Thread\n"
 					"r             Run available scripts('perf report' only)\n"
+					"s             Switch to another data file in PWD ('perf report' only)\n"
 					"P             Print histograms to perf.hist.N\n"
 					"V             Verbose (DSO names in callchains, etc)\n"
 					"/             Filter symbol by name");
@@ -1352,6 +1449,9 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 		if (asprintf(&options[nr_options], "Run scripts for all samples") > 0)
 			scripts_all = nr_options++;
 
+		if (is_report_browser(hbt) && asprintf(&options[nr_options],
+				"Switch to another data file in PWD") > 0)
+			switch_data = nr_options++;
 add_exit_option:
 		options[nr_options++] = (char *)"Exit";
 retry_popup_menu:
@@ -1462,6 +1562,16 @@ do_scripts:
 
 			script_browse(script_opt);
 		}
+		/* Switch to another data file */
+		else if (choice == switch_data) {
+do_data_switch:
+			if (!switch_data_file()) {
+				key = K_SWITCH_INPUT_DATA;
+				break;
+			} else
+				ui__warning("Won't switch the data files due to\n"
+					"no valid data file get selected!\n");
+		}
 	}
 out_free_stack:
 	pstack__delete(fstack);
@@ -1578,6 +1688,7 @@ browse_hists:
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
1.7.9.5


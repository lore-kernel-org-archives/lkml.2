Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355Ab2CIN35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 08:29:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58755 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152Ab2CIN3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 08:29:55 -0500
Date: Fri, 9 Mar 2012 05:29:15 -0800
From: tip-bot for Roberto Agostino Vitillo <ravitillo@lbl.gov>
Message-ID: <tip-b50311dc2ac1c04ad19163c2359910b25e16caf6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, ravitillo@lbl.gov, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, ravitillo@lbl.gov, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1328826068-11713-14-git-send-email-eranian@google.com>
References: <1328826068-11713-14-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/hw-branch-sampling] perf report:
  Add support for taken branch sampling
Git-Commit-ID: b50311dc2ac1c04ad19163c2359910b25e16caf6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 09 Mar 2012 05:29:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b50311dc2ac1c04ad19163c2359910b25e16caf6
Gitweb:     http://git.kernel.org/tip/b50311dc2ac1c04ad19163c2359910b25e16caf6
Author:     Roberto Agostino Vitillo <ravitillo@lbl.gov>
AuthorDate: Thu, 9 Feb 2012 23:21:03 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 9 Mar 2012 08:26:05 +0100

perf report: Add support for taken branch sampling

This patch adds support for taken branch sampling, i.e, the
PERF_SAMPLE_BRANCH_STACK feature to perf report. In other
words, to display histograms based on taken branches rather
than executed instructions addresses.

The new option is called -b and it takes no argument. To
generate meaningful output, the perf.data must have been
obtained using perf record -b xxx ... where xxx is a branch
filter option.

The output shows symbols, modules, sorted by 'who branches
where' the most often. The percentages reported in the first
column refer to the total number of branches captured and
not the usual number of samples.

Here is a quick example.
Here branchy is simple test program which looks as follows:

void f2(void)
{}
void f3(void)
{}
void f1(unsigned long n)
{
  if (n & 1UL)
    f2();
  else
    f3();
}
int main(void)
{
  unsigned long i;

  for (i=0; i < N; i++)
   f1(i);
  return 0;
}

Here is the output captured on Nehalem, if we are
only interested in user level function calls.

$ perf record -b any_call,u -e cycles:u branchy

$ perf report -b --sort=symbol
    52.34%  [.] main                   [.] f1
    24.04%  [.] f1                     [.] f3
    23.60%  [.] f1                     [.] f2
     0.01%  [k] _IO_new_file_xsputn    [k] _IO_file_overflow
     0.01%  [k] _IO_vfprintf_internal  [k] _IO_new_file_xsputn
     0.01%  [k] _IO_vfprintf_internal  [k] strchrnul
     0.01%  [k] __printf               [k] _IO_vfprintf_internal
     0.01%  [k] main                   [k] __printf

About half (52%) of the call branches captured are from main()
-> f1(). The second half (24%+23%) is split in two equal shares
between f1() -> f2(), f1() ->f3(). The output is as expected
given the code.

It should be noted, that using -b in perf record does not
eliminate information in the perf.data file. Consequently, a
typical profile can also be obtained by perf report by simply
not using its -b option.

It is possible to sort on branch related columns:

   - dso_from, symbol_from
   - dso_to, symbol_to
   - mispredict

Signed-off-by: Roberto Agostino Vitillo <ravitillo@lbl.gov>
Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: peterz@infradead.org
Cc: acme@redhat.com
Cc: robert.richter@amd.com
Cc: ming.m.lin@intel.com
Cc: andi@firstfloor.org
Cc: asharma@fb.com
Cc: vweaver1@eecs.utk.edu
Cc: khandual@linux.vnet.ibm.com
Cc: dsahern@gmail.com
Link: http://lkml.kernel.org/r/1328826068-11713-14-git-send-email-eranian@google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Documentation/perf-report.txt |    7 ++
 tools/perf/builtin-report.c              |  107 +++++++++++++++++++++++++++---
 2 files changed, 105 insertions(+), 9 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 9b430e9..19b9092 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -153,6 +153,13 @@ OPTIONS
 	information which may be very large and thus may clutter the display.
 	It currently includes: cpu and numa topology of the host system.
 
+-b::
+--branch-stack::
+	Use the addresses of sampled taken branches instead of the instruction
+	address to build the histograms. To generate meaningful output, the
+	perf.data file must have been obtained using perf record -b xxx where
+	xxx is a branch filter option.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-annotate[1]
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 25d34d4..528789f 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -53,6 +53,50 @@ struct perf_report {
 	DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
 };
 
+static int perf_report__add_branch_hist_entry(struct perf_tool *tool,
+					struct addr_location *al,
+					struct perf_sample *sample,
+					struct perf_evsel *evsel,
+				      struct machine *machine)
+{
+	struct perf_report *rep = container_of(tool, struct perf_report, tool);
+	struct symbol *parent = NULL;
+	int err = 0;
+	unsigned i;
+	struct hist_entry *he;
+	struct branch_info *bi;
+
+	if ((sort__has_parent || symbol_conf.use_callchain)
+	    && sample->callchain) {
+		err = machine__resolve_callchain(machine, evsel, al->thread,
+						 sample->callchain, &parent);
+		if (err)
+			return err;
+	}
+
+	bi = machine__resolve_bstack(machine, al->thread,
+				     sample->branch_stack);
+	if (!bi)
+		return -ENOMEM;
+
+	for (i = 0; i < sample->branch_stack->nr; i++) {
+		if (rep->hide_unresolved && !(bi[i].from.sym && bi[i].to.sym))
+			continue;
+		/*
+		 * The report shows the percentage of total branches captured
+		 * and not events sampled. Thus we use a pseudo period of 1.
+		 */
+		he = __hists__add_branch_entry(&evsel->hists, al, parent,
+					       &bi[i], 1);
+		if (he) {
+			evsel->hists.stats.total_period += 1;
+			hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
+		} else
+			return -ENOMEM;
+	}
+	return err;
+}
+
 static int perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 				      struct addr_location *al,
 				      struct perf_sample *sample,
@@ -126,14 +170,21 @@ static int process_sample_event(struct perf_tool *tool,
 	if (rep->cpu_list && !test_bit(sample->cpu, rep->cpu_bitmap))
 		return 0;
 
-	if (al.map != NULL)
-		al.map->dso->hit = 1;
+	if (sort__branch_mode) {
+		if (perf_report__add_branch_hist_entry(tool, &al, sample,
+						       evsel, machine)) {
+			pr_debug("problem adding lbr entry, skipping event\n");
+			return -1;
+		}
+	} else {
+		if (al.map != NULL)
+			al.map->dso->hit = 1;
 
-	if (perf_evsel__add_hist_entry(evsel, &al, sample, machine)) {
-		pr_debug("problem incrementing symbol period, skipping event\n");
-		return -1;
+		if (perf_evsel__add_hist_entry(evsel, &al, sample, machine)) {
+			pr_debug("problem incrementing symbol period, skipping event\n");
+			return -1;
+		}
 	}
-
 	return 0;
 }
 
@@ -188,6 +239,15 @@ static int perf_report__setup_sample_type(struct perf_report *rep)
 			}
 	}
 
+	if (sort__branch_mode) {
+		if (!(self->sample_type & PERF_SAMPLE_BRANCH_STACK)) {
+			fprintf(stderr, "selected -b but no branch data."
+					" Did you call perf record without"
+					" -b?\n");
+			return -1;
+		}
+	}
+
 	return 0;
 }
 
@@ -477,7 +537,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 	OPT_BOOLEAN(0, "stdio", &report.use_stdio,
 		    "Use the stdio interface"),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
-		   "sort by key(s): pid, comm, dso, symbol, parent"),
+		   "sort by key(s): pid, comm, dso, symbol, parent, dso_to,"
+		   " dso_from, symbol_to, symbol_from, mispredict"),
 	OPT_BOOLEAN(0, "showcpuutilization", &symbol_conf.show_cpu_utilization,
 		    "Show sample percentage for different cpu modes"),
 	OPT_STRING('p', "parent", &parent_pattern, "regex",
@@ -517,6 +578,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 		   "Specify disassembler style (e.g. -M intel for intel syntax)"),
 	OPT_BOOLEAN(0, "show-total-period", &symbol_conf.show_total_period,
 		    "Show a column with the sum of periods"),
+	OPT_BOOLEAN('b', "branch-stack", &sort__branch_mode,
+		    "use branch records for histogram filling"),
 	OPT_END()
 	};
 
@@ -537,10 +600,36 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 			report.input_name = "perf.data";
 	}
 
-	if (strcmp(report.input_name, "-") != 0)
+	if (sort__branch_mode) {
+		if (use_browser)
+			fprintf(stderr, "Warning: TUI interface not supported"
+					" in branch mode\n");
+		if (symbol_conf.dso_list_str != NULL)
+			fprintf(stderr, "Warning: dso filtering not supported"
+					" in branch mode\n");
+		if (symbol_conf.sym_list_str != NULL)
+			fprintf(stderr, "Warning: symbol filtering not"
+					" supported in branch mode\n");
+
+		report.use_stdio = true;
+		use_browser = 0;
 		setup_browser(true);
-	else
+		symbol_conf.dso_list_str = NULL;
+		symbol_conf.sym_list_str = NULL;
+
+		/*
+		 * if no sort_order is provided, then specify branch-mode
+		 * specific order
+		 */
+		if (sort_order == default_sort_order)
+			sort_order = "comm,dso_from,symbol_from,"
+				     "dso_to,symbol_to";
+
+	} else if (strcmp(report.input_name, "-") != 0) {
+		setup_browser(true);
+	} else {
 		use_browser = 0;
+	}
 
 	/*
 	 * Only in the newt browser we are doing integrated annotation,

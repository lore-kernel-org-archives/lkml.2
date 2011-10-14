Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932962Ab1JNMjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 08:39:18 -0400
Received: from smtp-out.google.com ([216.239.44.51]:26903 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932941Ab1JNMjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 08:39:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:from:to:cc:subject:date:message-id:x-mailer:
	in-reply-to:references:x-system-of-record;
	b=PkNaXoQPDbvmhw0Ed2JLN1Mo3QhI+WFSksQYPw06eTr12dD1rboHS09MGFyw2R5pZ
	WAXkeaMlLsIJUaBkMpgxg==
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com, ming.m.lin@intel.com,
        andi@firstfloor.org, robert.richter@amd.com, ravitillo@lbl.gov,
        will.deacon@arm.com, paulus@samba.org, benh@kernel.crashing.org,
        rth@twiddle.net, ralf@linux-mips.org, davem@davemloft.net,
        lethal@linux-sh.org
Subject: [PATCH 12/12] perf: add support for taken branch sampling to perf report (v2)
Date: Fri, 14 Oct 2011 14:37:13 +0200
Message-Id: <1318595833-29984-13-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1318595833-29984-1-git-send-email-eranian@google.com>
References: <1318595833-29984-1-git-send-email-eranian@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roberto Agostino Vitillo <ravitillo@lbl.gov>

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

About half (52%) of the call branches captured are from main() -> f1().
The second half (24%+23%) is split in two equal shares between
f1() -> f2(), f1() ->f3(). The output is as expected given the code.

It should be noted, that using -b in perf record does not eliminate
information in the perf.data file. Consequently, a typical profile
can also be obtained by perf report by simply not using its -b option.

Signed-off-by: Roberto Agostino Vitillo <ravitillo@lbl.gov>
Signed-off-by: Stephane Eranian <eranian@google.com>
---
 tools/perf/Documentation/perf-report.txt |    7 ++
 tools/perf/builtin-report.c              |   93 +++++++++++++++++++++++++++---
 2 files changed, 91 insertions(+), 9 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 212f24d..3163be5 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -152,6 +152,13 @@ OPTIONS
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
index 4d7c834..f52f65c 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -55,6 +55,46 @@ static symbol_filter_t	annotate_init;
 static const char	*cpu_list;
 static DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
 
+static int perf_session__add_branch_hist_entry(struct perf_session *session,
+					struct addr_location *al,
+					struct perf_sample *sample,
+					struct perf_evsel *evsel){
+	struct symbol *parent = NULL;
+	int err = 0;
+	unsigned i;
+	struct hist_entry *he;
+	struct branch_info *bi;
+
+	if ((sort__has_parent || symbol_conf.use_callchain) && sample->callchain) {
+		err = perf_session__resolve_callchain(session, al->thread,
+						      sample->callchain, &parent);
+		if (err)
+			return err;
+	}
+
+	bi = perf_session__resolve_bstack(session, al->thread,
+					  sample->branch_stack);
+	if (!bi)
+		return -ENOMEM;
+
+	for(i = 0; i < sample->branch_stack->nr; i++) {
+		if(hide_unresolved && !(bi[i].from.sym && bi[i].to.sym))
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
 static int perf_session__add_hist_entry(struct perf_session *session,
 					struct addr_location *al,
 					struct perf_sample *sample,
@@ -120,20 +160,28 @@ static int process_sample_event(union perf_event *event,
 		return -1;
 	}
 
-	if (al.filtered || (hide_unresolved && al.sym == NULL))
-		return 0;
-
 	if (cpu_list && !test_bit(sample->cpu, cpu_bitmap))
 		return 0;
 
-	if (al.map != NULL)
-		al.map->dso->hit = 1;
+	if (sort__branch_mode) {
+		if(perf_session__add_branch_hist_entry(session, &al, sample,
+						    evsel)) {
+			pr_debug("problem adding lbr entry, skipping event\n");
+			return -1;
+		}
+	} else {
+		if (al.filtered || (hide_unresolved && al.sym == NULL))
+			return 0;
 
-	if (perf_session__add_hist_entry(session, &al, sample, evsel)) {
-		pr_debug("problem incrementing symbol period, skipping event\n");
-		return -1;
-	}
+		if (al.map != NULL)
+			al.map->dso->hit = 1;
 
+		if (perf_session__add_hist_entry(session, &al, sample, evsel)) {
+			pr_debug("problem incrementing symbol period, skipping"
+					" event\n");
+			return -1;
+		}
+	}
 	return 0;
 }
 
@@ -183,6 +231,15 @@ static int perf_session__setup_sample_type(struct perf_session *self)
 			}
 	}
 
+	if(sort__branch_mode){
+		if(!(self->sample_type & PERF_SAMPLE_BRANCH_STACK)){
+			fprintf(stderr, "selected -b but no branch data."
+					" Did you call perf record without"
+					" -b?\n");
+			return -1;
+		}
+	}
+
 	return 0;
 }
 
@@ -499,6 +556,8 @@ static const struct option options[] = {
 		   "Specify disassembler style (e.g. -M intel for intel syntax)"),
 	OPT_BOOLEAN(0, "show-total-period", &symbol_conf.show_total_period,
 		    "Show a column with the sum of periods"),
+	OPT_BOOLEAN('b', "branch-stack", &sort__branch_mode,
+		    "use branch records for histogram filling"),
 	OPT_END()
 };
 
@@ -514,6 +573,22 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 	if (inverted_callchain)
 		callchain_param.order = ORDER_CALLER;
 
+	if (sort__branch_mode){
+		if(use_browser)
+			fprintf(stderr, "Warning: TUI interface not supported"
+					" in branch mode\n");
+		if(symbol_conf.dso_list_str != NULL)
+			fprintf(stderr, "Warning: dso filtering not supported"
+					" in branch mode\n");
+		if(symbol_conf.sym_list_str != NULL)
+			fprintf(stderr, "Warning: symbol filtering not supported"
+					" in branch mode\n");
+
+		use_browser = 0;
+		symbol_conf.dso_list_str = NULL;
+		symbol_conf.sym_list_str = NULL;
+	}
+
 	if (strcmp(input_name, "-") != 0)
 		setup_browser(true);
 	else
-- 
1.7.1


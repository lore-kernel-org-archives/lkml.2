Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab2BFS1M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 13:27:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555Ab2BFS1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 13:27:11 -0500
Date: Mon, 6 Feb 2012 16:14:41 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        robert.richter@amd.com, ming.m.lin@intel.com, andi@firstfloor.org,
        asharma@fb.com, ravitillo@lbl.gov, vweaver1@eecs.utk.edu,
        khandual@linux.vnet.ibm.com, dsahern@gmail.com
Subject: Re: [PATCH v5 13/18] perf: add support for taken branch sampling
	to perf report
Message-ID: <20120206181441.GE6367@infradead.org>
References: <1328187288-24395-1-git-send-email-eranian@google.com> <1328187288-24395-14-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328187288-24395-14-git-send-email-eranian@google.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Feb 02, 2012 at 01:54:43PM +0100, Stephane Eranian escreveu:
> From: Roberto Agostino Vitillo <ravitillo@lbl.gov>
> 
> This patch adds support for taken branch sampling, i.e, the
> PERF_SAMPLE_BRANCH_STACK feature to perf report. In other
> words, to display histograms based on taken branches rather
> than executed instructions addresses.
> 
> The new option is called -b and it takes no argument. To
> generate meaningful output, the perf.data must have been
> obtained using perf record -b xxx ... where xxx is a branch
> filter option.
> 
> The output shows symbols, modules, sorted by 'who branches
> where' the most often. The percentages reported in the first
> column refer to the total number of branches captured and
> not the usual number of samples.
> 
> Here is a quick example.
> Here branchy is simple test program which looks as follows:
> 
> void f2(void)
> {}
> void f3(void)
> {}
> void f1(unsigned long n)
> {
>   if (n & 1UL)
>     f2();
>   else
>     f3();
> }
> int main(void)
> {
>   unsigned long i;
> 
>   for (i=0; i < N; i++)
>    f1(i);
>   return 0;
> }
> 
> Here is the output captured on Nehalem, if we are
> only interested in user level function calls.
> 
> $ perf record -b any_call,u -e cycles:u branchy
> 
> $ perf report -b --sort=symbol
>     52.34%  [.] main                   [.] f1
>     24.04%  [.] f1                     [.] f3
>     23.60%  [.] f1                     [.] f2
>      0.01%  [k] _IO_new_file_xsputn    [k] _IO_file_overflow
>      0.01%  [k] _IO_vfprintf_internal  [k] _IO_new_file_xsputn
>      0.01%  [k] _IO_vfprintf_internal  [k] strchrnul
>      0.01%  [k] __printf               [k] _IO_vfprintf_internal
>      0.01%  [k] main                   [k] __printf
> 
> About half (52%) of the call branches captured are from main() -> f1().
> The second half (24%+23%) is split in two equal shares between
> f1() -> f2(), f1() ->f3(). The output is as expected given the code.

It would be great to have a 'perf test' entry for the above test case,
that would try to use this feature and if the kernel didn't bailed out,
meaning the hardware supports it, validate the results like is done in
other perf test cases.

Just some minor comments about method naming/class ownership below.
 
> It should be noted, that using -b in perf record does not eliminate
> information in the perf.data file. Consequently, a typical profile
> can also be obtained by perf report by simply not using its -b option.
> 
> Signed-off-by: Roberto Agostino Vitillo <ravitillo@lbl.gov>
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
>  tools/perf/Documentation/perf-report.txt |    7 ++
>  tools/perf/builtin-report.c              |   98 +++++++++++++++++++++++++++---
>  2 files changed, 96 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
> index 9b430e9..19b9092 100644
> --- a/tools/perf/Documentation/perf-report.txt
> +++ b/tools/perf/Documentation/perf-report.txt
> @@ -153,6 +153,13 @@ OPTIONS
>  	information which may be very large and thus may clutter the display.
>  	It currently includes: cpu and numa topology of the host system.
>  
> +-b::
> +--branch-stack::
> +	Use the addresses of sampled taken branches instead of the instruction
> +	address to build the histograms. To generate meaningful output, the
> +	perf.data file must have been obtained using perf record -b xxx where
> +	xxx is a branch filter option.
> +
>  SEE ALSO
>  --------
>  linkperf:perf-stat[1], linkperf:perf-annotate[1]
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index 25d34d4..8a8d2f9 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -53,6 +53,50 @@ struct perf_report {
>  	DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
>  };
>  
> +static int perf_session__add_branch_hist_entry(struct perf_tool *tool,
> +					struct addr_location *al,
> +					struct perf_sample *sample,
> +					struct perf_evsel *evsel,
> +				      struct machine *machine)

The naming here should be:

static int perf_report__add_branch_hist_entry, as this is just a
'struct perf_report' specific method, perf_report being an
specialization of a 'perf_tool', etc.

> +{
> +	struct perf_report *rep = container_of(tool, struct perf_report, tool);
> +	struct symbol *parent = NULL;
> +	int err = 0;
> +	unsigned i;
> +	struct hist_entry *he;
> +	struct branch_info *bi;
> +
> +	if ((sort__has_parent || symbol_conf.use_callchain)
> +	    && sample->callchain) {
> +		err = machine__resolve_callchain(machine, evsel, al->thread,
> +						 sample->callchain, &parent);
> +		if (err)
> +			return err;
> +	}
> +
> +	bi = perf_session__resolve_bstack(machine, al->thread,
> +					  sample->branch_stack);

This one then is just a 'struct machine' method, hence:

	bi = machine__resolve_bstack(machine, al->thread, sample->branch_stack);

> +	if (!bi)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < sample->branch_stack->nr; i++) {
> +		if (rep->hide_unresolved && !(bi[i].from.sym && bi[i].to.sym))
> +			continue;
> +		/*
> +		 * The report shows the percentage of total branches captured
> +		 * and not events sampled. Thus we use a pseudo period of 1.
> +		 */
> +		he = __hists__add_branch_entry(&evsel->hists, al, parent,
> +					       &bi[i], 1);
> +		if (he) {
> +			evsel->hists.stats.total_period += 1;
> +			hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
> +		} else
> +			return -ENOMEM;
> +	}
> +	return err;
> +}
> +
>  static int perf_evsel__add_hist_entry(struct perf_evsel *evsel,
>  				      struct addr_location *al,
>  				      struct perf_sample *sample,
> @@ -126,14 +170,21 @@ static int process_sample_event(struct perf_tool *tool,
>  	if (rep->cpu_list && !test_bit(sample->cpu, rep->cpu_bitmap))
>  		return 0;
>  
> -	if (al.map != NULL)
> -		al.map->dso->hit = 1;
> +	if (sort__branch_mode) {
> +		if (perf_session__add_branch_hist_entry(tool, &al, sample,
> +						    evsel, machine)) {
> +			pr_debug("problem adding lbr entry, skipping event\n");
> +			return -1;
> +		}
> +	} else {
> +		if (al.map != NULL)
> +			al.map->dso->hit = 1;
>  
> -	if (perf_evsel__add_hist_entry(evsel, &al, sample, machine)) {
> -		pr_debug("problem incrementing symbol period, skipping event\n");
> -		return -1;
> +		if (perf_evsel__add_hist_entry(evsel, &al, sample, machine)) {
> +			pr_debug("problem incrementing symbol period, skipping event\n");
> +			return -1;
> +		}
>  	}
> -
>  	return 0;
>  }
>  
> @@ -188,6 +239,15 @@ static int perf_report__setup_sample_type(struct perf_report *rep)
>  			}
>  	}
>  
> +	if (sort__branch_mode) {
> +		if (!(self->sample_type & PERF_SAMPLE_BRANCH_STACK)) {
> +			fprintf(stderr, "selected -b but no branch data."
> +					" Did you call perf record without"
> +					" -b?\n");
> +			return -1;
> +		}
> +	}
> +
>  	return 0;
>  }
>  
> @@ -477,7 +537,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
>  	OPT_BOOLEAN(0, "stdio", &report.use_stdio,
>  		    "Use the stdio interface"),
>  	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
> -		   "sort by key(s): pid, comm, dso, symbol, parent"),
> +		   "sort by key(s): pid, comm, dso, symbol, parent, dso_to,"
> +		   " dso_from, symbol_to, symbol_from, mispredict"),
>  	OPT_BOOLEAN(0, "showcpuutilization", &symbol_conf.show_cpu_utilization,
>  		    "Show sample percentage for different cpu modes"),
>  	OPT_STRING('p', "parent", &parent_pattern, "regex",
> @@ -517,6 +578,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
>  		   "Specify disassembler style (e.g. -M intel for intel syntax)"),
>  	OPT_BOOLEAN(0, "show-total-period", &symbol_conf.show_total_period,
>  		    "Show a column with the sum of periods"),
> +	OPT_BOOLEAN('b', "branch-stack", &sort__branch_mode,
> +		    "use branch records for histogram filling"),
>  	OPT_END()
>  	};
>  
> @@ -537,10 +600,27 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
>  			report.input_name = "perf.data";
>  	}
>  
> -	if (strcmp(report.input_name, "-") != 0)
> +	if (sort__branch_mode) {
> +		if (use_browser)
> +			fprintf(stderr, "Warning: TUI interface not supported"
> +					" in branch mode\n");

I'll put this on my TODO list :-)

> +		if (symbol_conf.dso_list_str != NULL)
> +			fprintf(stderr, "Warning: dso filtering not supported"
> +					" in branch mode\n");
> +		if (symbol_conf.sym_list_str != NULL)
> +			fprintf(stderr, "Warning: symbol filtering not"
> +					" supported in branch mode\n");
> +
> +		report.use_stdio = true;
> +		use_browser = 0;
>  		setup_browser(true);
> -	else
> +		symbol_conf.dso_list_str = NULL;
> +		symbol_conf.sym_list_str = NULL;
> +	} else if (strcmp(report.input_name, "-") != 0) {
> +		setup_browser(true);
> +	} else {
>  		use_browser = 0;
> +	}
>  
>  	/*
>  	 * Only in the newt browser we are doing integrated annotation,
> -- 
> 1.7.4.1

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933312Ab1LFNXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 08:23:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50518 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933164Ab1LFNXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 08:23:11 -0500
Date: Tue, 6 Dec 2011 11:22:59 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/10] perf report: Accept fifos as input file
Message-ID: <20111206132259.GE7059@infradead.org>
References: <1323167560-2282-1-git-send-email-robert.richter@amd.com> <1323167560-2282-8-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323167560-2282-8-git-send-email-robert.richter@amd.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 06, 2011 at 11:32:37AM +0100, Robert Richter escreveu:
> The default input file for perf report is not handled the same way as
> perf record does it for its output file. This leads to unexpected
> behavior of perf report, etc. E.g.:
> 
>  # perf record -a -e cpu-cycles sleep 2 | perf report | cat
>  failed to open perf.data: No such file or directory  (try 'perf record' first)
>
> While perf record writes to a fifo, perf report expects perf.data to
> be read. This patch changes this to accept fifos as input file.

Nice feature!

The idea of writing to a pipe initially considered just 'perf script'
iirc, but having it working for all commands like this is indeed a good
thing.
 
> Applies to the following commands:
> 
>  perf annotate
>  perf buildid-list
>  perf evlist
>  perf kmem
>  perf lock
>  perf report
>  perf sched
>  perf script
>  perf timechart
> 
> Also fixes char const* -> const char* type declaration for filename
> strings.
> 
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  tools/perf/Documentation/perf-annotate.txt     |    2 +-
>  tools/perf/Documentation/perf-buildid-list.txt |    2 +-
>  tools/perf/Documentation/perf-evlist.txt       |    2 +-
>  tools/perf/Documentation/perf-kmem.txt         |    2 +-
>  tools/perf/Documentation/perf-lock.txt         |    2 +-
>  tools/perf/Documentation/perf-report.txt       |    2 +-
>  tools/perf/Documentation/perf-sched.txt        |    2 +-
>  tools/perf/Documentation/perf-script.txt       |    2 +-
>  tools/perf/Documentation/perf-timechart.txt    |    2 +-
>  tools/perf/builtin-annotate.c                  |    4 ++--
>  tools/perf/builtin-buildid-list.c              |   19 ++++++++++---------
>  tools/perf/builtin-evlist.c                    |    2 +-
>  tools/perf/builtin-kmem.c                      |    2 +-
>  tools/perf/builtin-lock.c                      |    2 +-
>  tools/perf/builtin-report.c                    |    4 ++--
>  tools/perf/builtin-sched.c                     |    2 +-
>  tools/perf/builtin-script.c                    |    4 ++--
>  tools/perf/builtin-timechart.c                 |    4 ++--
>  tools/perf/util/session.c                      |   15 +++++++++++++--
>  19 files changed, 44 insertions(+), 32 deletions(-)
> 
> diff --git a/tools/perf/Documentation/perf-annotate.txt b/tools/perf/Documentation/perf-annotate.txt
> index fe6762e..0d0f217 100644
> --- a/tools/perf/Documentation/perf-annotate.txt
> +++ b/tools/perf/Documentation/perf-annotate.txt
> @@ -22,7 +22,7 @@ OPTIONS
>  -------
>  -i::
>  --input=::
> -        Input file name. (default: perf.data)
> +        Input file name. (default: perf.data unless stdin is a fifo)
>  
>  -d::
>  --dsos=<dso[,dso...]>::
> diff --git a/tools/perf/Documentation/perf-buildid-list.txt b/tools/perf/Documentation/perf-buildid-list.txt
> index cc22325..25c52ef 100644
> --- a/tools/perf/Documentation/perf-buildid-list.txt
> +++ b/tools/perf/Documentation/perf-buildid-list.txt
> @@ -26,7 +26,7 @@ OPTIONS
>          Show only DSOs with hits.
>  -i::
>  --input=::
> -        Input file name. (default: perf.data)
> +        Input file name. (default: perf.data unless stdin is a fifo)
>  -f::
>  --force::
>  	Don't do ownership validation.
> diff --git a/tools/perf/Documentation/perf-evlist.txt b/tools/perf/Documentation/perf-evlist.txt
> index 0cada9e..0507ec7 100644
> --- a/tools/perf/Documentation/perf-evlist.txt
> +++ b/tools/perf/Documentation/perf-evlist.txt
> @@ -18,7 +18,7 @@ OPTIONS
>  -------
>  -i::
>  --input=::
> -        Input file name. (default: perf.data)
> +        Input file name. (default: perf.data unless stdin is a fifo)
>  
>  SEE ALSO
>  --------
> diff --git a/tools/perf/Documentation/perf-kmem.txt b/tools/perf/Documentation/perf-kmem.txt
> index a52fcde..7c8fbbf 100644
> --- a/tools/perf/Documentation/perf-kmem.txt
> +++ b/tools/perf/Documentation/perf-kmem.txt
> @@ -23,7 +23,7 @@ OPTIONS
>  -------
>  -i <file>::
>  --input=<file>::
> -	Select the input file (default: perf.data)
> +	Select the input file (default: perf.data unless stdin is a fifo)
>  
>  --caller::
>  	Show per-callsite statistics
> diff --git a/tools/perf/Documentation/perf-lock.txt b/tools/perf/Documentation/perf-lock.txt
> index 4a26a2f..d6b2a4f 100644
> --- a/tools/perf/Documentation/perf-lock.txt
> +++ b/tools/perf/Documentation/perf-lock.txt
> @@ -29,7 +29,7 @@ COMMON OPTIONS
>  
>  -i::
>  --input=<file>::
> -        Input file name.
> +        Input file name. (default: perf.data unless stdin is a fifo)
>  
>  -v::
>  --verbose::
> diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
> index 212f24d..a67be86 100644
> --- a/tools/perf/Documentation/perf-report.txt
> +++ b/tools/perf/Documentation/perf-report.txt
> @@ -19,7 +19,7 @@ OPTIONS
>  -------
>  -i::
>  --input=::
> -        Input file name. (default: perf.data)
> +        Input file name. (default: perf.data unless stdin is a fifo)
>  
>  -v::
>  --verbose::
> diff --git a/tools/perf/Documentation/perf-sched.txt b/tools/perf/Documentation/perf-sched.txt
> index 5b212b5..8ff4df9 100644
> --- a/tools/perf/Documentation/perf-sched.txt
> +++ b/tools/perf/Documentation/perf-sched.txt
> @@ -40,7 +40,7 @@ OPTIONS
>  -------
>  -i::
>  --input=<file>::
> -        Input file name. (default: perf.data)
> +        Input file name. (default: perf.data unless stdin is a fifo)
>  
>  -v::
>  --verbose::
> diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
> index dec87ec..d465c11 100644
> --- a/tools/perf/Documentation/perf-script.txt
> +++ b/tools/perf/Documentation/perf-script.txt
> @@ -106,7 +106,7 @@ OPTIONS
>  
>  -i::
>  --input=::
> -        Input file name.
> +        Input file name. (default: perf.data unless stdin is a fifo)
>  
>  -d::
>  --debug-mode::
> diff --git a/tools/perf/Documentation/perf-timechart.txt b/tools/perf/Documentation/perf-timechart.txt
> index d7b79e2..1632b0e 100644
> --- a/tools/perf/Documentation/perf-timechart.txt
> +++ b/tools/perf/Documentation/perf-timechart.txt
> @@ -27,7 +27,7 @@ OPTIONS
>          Select the output file (default: output.svg)
>  -i::
>  --input=::
> -        Select the input file (default: perf.data)
> +        Select the input file (default: perf.data unless stdin is a fifo)
>  -w::
>  --width=::
>          Select the width of the SVG file (default: 1000)
> diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
> index 46b4c24..a6374cd 100644
> --- a/tools/perf/builtin-annotate.c
> +++ b/tools/perf/builtin-annotate.c
> @@ -30,7 +30,7 @@
>  
>  #include <linux/bitmap.h>
>  
> -static char		const *input_name = "perf.data";
> +static const char	*input_name;
>  
>  static bool		force, use_tui, use_stdio;
>  
> @@ -223,7 +223,7 @@ static int __cmd_annotate(void)
>  	}
>  
>  	if (total_nr_samples == 0) {
> -		ui__warning("The %s file has no samples!\n", input_name);
> +		ui__warning("The %s file has no samples!\n", session->filename);
>  		goto out_delete;
>  	}
>  out_delete:
> diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
> index 4895668..5248046 100644
> --- a/tools/perf/builtin-buildid-list.c
> +++ b/tools/perf/builtin-buildid-list.c
> @@ -18,7 +18,7 @@
>  
>  #include <libelf.h>
>  
> -static char const *input_name = "perf.data";
> +static const char *input_name;
>  static bool force;
>  static bool show_kernel;
>  static bool with_hits;
> @@ -71,16 +71,24 @@ static int perf_session__list_build_ids(void)
>  {
>  	struct perf_session *session;
>  
> +	elf_version(EV_CURRENT);
> +
>  	session = perf_session__new(input_name, O_RDONLY, force, false,
>  				    &build_id__mark_dso_hit_ops);
>  	if (session == NULL)
>  		return -1;
>  
> +	/*
> +	 * See if this is an ELF file first:
> +	 */
> +	if (filename__fprintf_build_id(session->filename, stdout))
> +		goto out;
> +
>  	if (with_hits)
>  		perf_session__process_events(session, &build_id__mark_dso_hit_ops);
>  
>  	perf_session__fprintf_dsos_buildid(session, stdout, with_hits);
> -
> +out:
>  	perf_session__delete(session);
>  	return 0;
>  }
> @@ -90,13 +98,6 @@ static int __cmd_buildid_list(void)
>  	if (show_kernel)
>  		return sysfs__fprintf_build_id(stdout);
>  
> -	elf_version(EV_CURRENT);
> -	/*
> - 	 * See if this is an ELF file first:
> - 	 */
> -	if (filename__fprintf_build_id(input_name, stdout))
> -		return 0;
> -
>  	return perf_session__list_build_ids();
>  }
>  
> diff --git a/tools/perf/builtin-evlist.c b/tools/perf/builtin-evlist.c
> index 4c5e9e0..2676032 100644
> --- a/tools/perf/builtin-evlist.c
> +++ b/tools/perf/builtin-evlist.c
> @@ -15,7 +15,7 @@
>  #include "util/parse-options.h"
>  #include "util/session.h"
>  
> -static char const *input_name = "perf.data";
> +static const char *input_name;
>  
>  static int __cmd_evlist(void)
>  {
> diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
> index 225e963..f2a1c33 100644
> --- a/tools/perf/builtin-kmem.c
> +++ b/tools/perf/builtin-kmem.c
> @@ -18,7 +18,7 @@
>  struct alloc_stat;
>  typedef int (*sort_fn_t)(struct alloc_stat *, struct alloc_stat *);
>  
> -static char const		*input_name = "perf.data";
> +static const char		*input_name;
>  
>  static int			alloc_flag;
>  static int			caller_flag;
> diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
> index 899080a..c743b2a 100644
> --- a/tools/perf/builtin-lock.c
> +++ b/tools/perf/builtin-lock.c
> @@ -325,7 +325,7 @@ alloc_failed:
>  	die("memory allocation failed\n");
>  }
>  
> -static char			const *input_name = "perf.data";
> +static const char *input_name;
>  
>  struct raw_event_sample {
>  	u32			size;
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index 88ca2d4..19c2217 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -35,7 +35,7 @@
>  
>  #include <linux/bitmap.h>
>  
> -static char		const *input_name = "perf.data";
> +static const char	*input_name;
>  
>  static bool		force, use_tui, use_stdio;
>  static bool		hide_unresolved;
> @@ -327,7 +327,7 @@ static int __cmd_report(void)
>  	}
>  
>  	if (nr_samples == 0) {
> -		ui__warning("The %s file has no samples!\n", input_name);
> +		ui__warning("The %s file has no samples!\n", session->filename);
>  		goto out_delete;
>  	}
>  
> diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
> index 5177964..9816fa9 100644
> --- a/tools/perf/builtin-sched.c
> +++ b/tools/perf/builtin-sched.c
> @@ -19,7 +19,7 @@
>  #include <pthread.h>
>  #include <math.h>
>  
> -static char			const *input_name = "perf.data";
> +static const char		*input_name;
>  
>  static char			default_sort_order[] = "avg, max, switch, runtime";
>  static const char		*sort_order = default_sort_order;
> diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
> index 82cca10..6d74933 100644
> --- a/tools/perf/builtin-script.c
> +++ b/tools/perf/builtin-script.c
> @@ -433,7 +433,7 @@ static int cleanup_scripting(void)
>  	return scripting_ops->stop_script();
>  }
>  
> -static char const		*input_name = "perf.data";
> +static const char *input_name;
>  
>  static int process_sample_event(union perf_event *event,
>  				struct perf_sample *sample,
> @@ -1302,7 +1302,7 @@ int cmd_script(int argc, const char **argv, const char *prefix __used)
>  			return -1;
>  		}
>  
> -		input = open(input_name, O_RDONLY);
> +		input = open(session->filename, O_RDONLY);	/* input_name */
>  		if (input < 0) {
>  			perror("failed to open file");
>  			exit(-1);
> diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
> index aa26f4d..08e4fd0 100644
> --- a/tools/perf/builtin-timechart.c
> +++ b/tools/perf/builtin-timechart.c
> @@ -36,8 +36,8 @@
>  #define PWR_EVENT_EXIT -1
>  
>  
> -static char		const *input_name = "perf.data";
> -static char		const *output_name = "output.svg";
> +static const char	*input_name;
> +static const char	*output_name = "output.svg";
>  
>  static unsigned int	numcpus;
>  static u64		min_freq;	/* Lowest CPU frequency seen */
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index 2ad9c10..fdd135d 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -132,8 +132,19 @@ struct perf_session *perf_session__new(const char *filename, int mode,
>  				       bool force, bool repipe,
>  				       struct perf_event_ops *ops)
>  {
> -	size_t len = filename ? strlen(filename) : 0;
> -	struct perf_session *self = zalloc(sizeof(*self) + len);
> +	struct perf_session *self;
> +	struct stat st;
> +	size_t len;
> +
> +	if (!filename || !strlen(filename)) {
> +		if (!fstat(STDIN_FILENO, &st) && S_ISFIFO(st.st_mode))
> +			filename = "-";
> +		else
> +			filename = "perf.data";
> +	}
> +
> +	len = strlen(filename);
> +	self = zalloc(sizeof(*self) + len);
>  
>  	if (self == NULL)
>  		goto out;
> -- 
> 1.7.7
> 

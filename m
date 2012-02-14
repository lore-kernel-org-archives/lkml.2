Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332Ab2BNPKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 10:10:52 -0500
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:58771
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760752Ab2BNPKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 10:10:50 -0500
X-SpamScore: -22
X-BigFish: VPS-22(zz146fK1432N98dKzz1202hzz15d4R8275bhz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LZE25U-01-4LQ-02
X-M-MSG: 
Date: Tue, 14 Feb 2012 16:10:39 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
CC: David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@gmail.com>, <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Arun Sharma <asharma@fb.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Wang <jasowang@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Lin Ming <ming.m.lin@intel.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Roberto Agostino Vitillo <ravitillo@lbl.gov>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vweaver1@eecs.utk.edu>
Subject: Re: [GIT PULL 00/16] perf/core improvements and fixes
Message-ID: <20120214151039.GA2238@amd.com>
References: <1329184375-27911-1-git-send-email-acme@infradead.org>
 <4F39CBE0.6050806@gmail.com>
 <4F39D00D.2060206@gmail.com>
 <4F39ECDB.5090609@lge.com>
 <4F39EFBB.2010301@gmail.com>
 <20120214105018.GV22598@amd.com>
 <20120214131046.GA28614@infradead.org>
 <20120214143853.GC28614@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120214143853.GC28614@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 14, 2012 at 12:38:53PM -0200, Arnaldo Carvalho de Melo wrote:
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 08ed24b..d6c10e8 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -205,6 +205,9 @@ static void perf_record__open(struct perf_record *rec)
>  
>  		if (opts->group && pos != first)
>  			group_fd = first->fd;
> +fallback_missing_features:
> +		if (opts->exclude_guest_missing)
> +			attr->exclude_guest = attr->exclude_host = 0;
>  retry_sample_id:
>  		attr->sample_id_all = opts->sample_id_all_avail ? 1 : 0;
>  try_again:
> @@ -218,15 +221,23 @@ try_again:
>  			} else if (err ==  ENODEV && opts->cpu_list) {
>  				die("No such device - did you specify"
>  					" an out-of-range profile CPU?\n");
> -			} else if (err == EINVAL && opts->sample_id_all_avail) {
> -				/*
> -				 * Old kernel, no attr->sample_id_type_all field
> -				 */
> -				opts->sample_id_all_avail = false;
> -				if (!opts->sample_time && !opts->raw_samples && !time_needed)
> -					attr->sample_type &= ~PERF_SAMPLE_TIME;
> -
> -				goto retry_sample_id;
> +			} else if (err == EINVAL) {
> +				if (!opts->exclude_guest_missing &&
> +				    (attr->exclude_guest || attr->exclude_host)) {
> +					pr_debug("Old kernel, cannot exclude "
> +						 "guest or host samples.\n");
> +					opts->exclude_guest_missing = true;
> +					goto fallback_missing_features;
> +				} else if (opts->sample_id_all_avail) {
> +					/*
> +					 * Old kernel, no attr->sample_id_type_all field
> +					 */
> +					opts->sample_id_all_avail = false;
> +					if (!opts->sample_time && !opts->raw_samples && !time_needed)
> +						attr->sample_type &= ~PERF_SAMPLE_TIME;
> +
> +					goto retry_sample_id;
> +				}
>  			}
>  
>  			/*
> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index 5a88c0d..02e11ff 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -872,6 +872,9 @@ static void perf_top__start_counters(struct perf_top *top)
>  		attr->mmap = 1;
>  		attr->comm = 1;
>  		attr->inherit = top->inherit;
> +fallback_missing_features:
> +		if (top->exclude_guest_missing)
> +			attr->exclude_guest = attr->exclude_host = 0;
>  retry_sample_id:
>  		attr->sample_id_all = top->sample_id_all_avail ? 1 : 0;
>  try_again:
> @@ -883,12 +886,20 @@ try_again:
>  			if (err == EPERM || err == EACCES) {
>  				ui__error_paranoid();
>  				goto out_err;
> -			} else if (err == EINVAL && top->sample_id_all_avail) {
> -				/*
> -				 * Old kernel, no attr->sample_id_type_all field
> -				 */
> -				top->sample_id_all_avail = false;
> -				goto retry_sample_id;
> +			} else if (err == EINVAL) {
> +				if (!top->exclude_guest_missing &&
> +				    (attr->exclude_guest || attr->exclude_host)) {
> +					pr_debug("Old kernel, cannot exclude "
> +						 "guest or host samples.\n");
> +					top->exclude_guest_missing = true;
> +					goto fallback_missing_features;
> +				} else if (top->sample_id_all_avail) {
> +					/*
> +					 * Old kernel, no attr->sample_id_type_all field
> +					 */
> +					top->sample_id_all_avail = false;
> +					goto retry_sample_id;
> +				}
>  			}
>  			/*
>  			 * If it's cycles then fall back to hrtimer
> diff --git a/tools/perf/perf.h b/tools/perf/perf.h
> index 03a0456..8b9c436 100644
> --- a/tools/perf/perf.h
> +++ b/tools/perf/perf.h
> @@ -199,6 +199,7 @@ struct perf_record_opts {
>  	bool	     sample_address;
>  	bool	     sample_time;
>  	bool	     sample_id_all_avail;
> +	bool	     exclude_guest_missing;
>  	bool	     system_wide;
>  	bool	     period;
>  	unsigned int freq;
> diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
> index 49eb848..7dea891 100644
> --- a/tools/perf/util/top.h
> +++ b/tools/perf/util/top.h
> @@ -35,6 +35,7 @@ struct perf_top {
>  	bool		   inherit;
>  	bool		   group;
>  	bool		   sample_id_all_avail;
> +	bool		   exclude_guest_missing;
>  	bool		   dump_symtab;
>  	const char	   *cpu_list;
>  	struct hist_entry  *sym_filter_entry;

I was about to prepare a similar patch :) But anyway, this one works
too.

Tested-by: Joerg Roedel <joerg.roedel@amd.com>

(on 2.6.32)

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632


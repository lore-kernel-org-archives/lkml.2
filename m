Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136Ab1C1BCp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 21:02:45 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:50902 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab1C1BCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 21:02:44 -0400
X-AuditID: b753bd60-a32b8ba000004916-0e-4d8fde31c665
X-AuditID: b753bd60-a32b8ba000004916-0e-4d8fde31c665
Message-ID: <4D8FDE2E.8080009@hitachi.com>
Date: Mon, 28 Mar 2011 10:02:38 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Lin Ming <ming.m.lin@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip v3] perf probe: Add fastpath to do lookup by function
 name
References: <1301041668.14111.52.camel@minggr.sh.intel.com>
In-Reply-To: <1301041668.14111.52.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/03/25 17:27), Lin Ming wrote:
> v3 -> v2:
> - Make pubname_search_cb more generic
> - Add fastpath to find_probes also

Good catch! :)

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you,

> 
> v2 -> v1:
> - Don't compare file names with cu_find_realpath(...), instead, compare
>   them with the name returned by dwarf_decl_file(sp_die)
> 
> The vmlinux file may have thousands of CUs.
> We can lookup function name from .debug_pubnames section
> to avoid the slow loop on CUs.
> 
> 1. Improvement data for find_line_range
> 
> ./perf stat -e cycles -r 10 -- ./perf probe -k /home/mlin/vmlinux \
>         -s /home/mlin/linux-2.6 \
>         --line csum_partial_copy_to_user > tmp.log
> 
> before patch applied
> =====================
>        847,988,276 cycles
> 
>         0.355075856  seconds time elapsed
> 
> after patch applied
> =====================
>        206,102,622 cycles
> 
>         0.086883555  seconds time elapsed
> 
> 2. Improvement data for find_probes
> 
> ./perf stat -e cycles -r 10 -- ./perf probe -k /home/mlin/vmlinux \
>         -s /home/mlin/linux-2.6 \
>         --vars csum_partial_copy_to_user > tmp.log
> 
> before patch applied
> =====================
>        848,490,844 cycles
> 
>         0.355307901  seconds time elapsed
> 
> after patch applied
> =====================
>        205,684,469 cycles
> 
>         0.086694010  seconds time elapsed
> 
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> ---
>  tools/perf/util/probe-finder.c |   68 ++++++++++++++++++++++++++++++++++++++++
>  tools/perf/util/probe-finder.h |    2 +
>  2 files changed, 70 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
> index 194f9e2..23fc9eb 100644
> --- a/tools/perf/util/probe-finder.c
> +++ b/tools/perf/util/probe-finder.c
> @@ -1435,6 +1435,38 @@ static int find_probe_point_by_func(struct probe_finder *pf)
>  	return _param.retval;
>  }
>  
> +struct pubname_callback_param {
> +	char *function;
> +	char *file;
> +	Dwarf_Die *cu_die;
> +	Dwarf_Die *sp_die;
> +	int found;
> +};
> +
> +static int pubname_search_cb(Dwarf *dbg, Dwarf_Global *gl, void *data)
> +{
> +	struct pubname_callback_param *param = data;
> +
> +	if (dwarf_offdie(dbg, gl->die_offset, param->sp_die)) {
> +		if (dwarf_tag(param->sp_die) != DW_TAG_subprogram)
> +			return DWARF_CB_OK;
> +
> +		if (die_compare_name(param->sp_die, param->function)) {
> +			if (!dwarf_offdie(dbg, gl->cu_offset, param->cu_die))
> +				return DWARF_CB_OK;
> +
> +			if (param->file &&
> +			    strtailcmp(param->file, dwarf_decl_file(param->sp_die)))
> +				return DWARF_CB_OK;
> +
> +			param->found = 1;
> +			return DWARF_CB_ABORT;
> +		}
> +	}
> +
> +	return DWARF_CB_OK;
> +}
> +
>  /* Find probe points from debuginfo */
>  static int find_probes(int fd, struct probe_finder *pf)
>  {
> @@ -1461,6 +1493,23 @@ static int find_probes(int fd, struct probe_finder *pf)
>  
>  	off = 0;
>  	line_list__init(&pf->lcache);
> +
> +	/* Fastpath: lookup by function name from .debug_pubnames section */
> +	if (pp->function) {
> +		struct pubname_callback_param pubname_param = {
> +			.function = pp->function, .file = pp->file,
> +			.cu_die = &pf->cu_die, .sp_die = &pf->sp_die, .found = 0};
> +		struct dwarf_callback_param probe_param = {
> +			.data = (void *)pf, .retval = 0};
> +
> +		dwarf_getpubnames(dbg, pubname_search_cb, &pubname_param, 0);
> +		if (pubname_param.found) {
> +			ret = probe_point_search_cb(&pf->sp_die, &probe_param);
> +			if (ret)
> +				goto found;
> +		}
> +	}
> +
>  	/* Loop on CUs (Compilation Unit) */
>  	while (!dwarf_nextcu(dbg, off, &noff, &cuhl, NULL, NULL, NULL)) {
>  		/* Get the DIE(Debugging Information Entry) of this CU */
> @@ -1488,6 +1537,8 @@ static int find_probes(int fd, struct probe_finder *pf)
>  		}
>  		off = noff;
>  	}
> +
> +found:
>  	line_list__free(&pf->lcache);
>  	if (dwfl)
>  		dwfl_end(dwfl);
> @@ -1895,6 +1946,22 @@ int find_line_range(int fd, struct line_range *lr)
>  		return -EBADF;
>  	}
>  
> +	/* Fastpath: lookup by function name from .debug_pubnames section */
> +	if (lr->function) {
> +		struct pubname_callback_param pubname_param = {
> +			.function = lr->function, .file = lr->file,
> +			.cu_die = &lf.cu_die, .sp_die = &lf.sp_die, .found = 0};
> +		struct dwarf_callback_param line_range_param = {
> +			.data = (void *)&lf, .retval = 0};
> +
> +		dwarf_getpubnames(dbg, pubname_search_cb, &pubname_param, 0);
> +		if (pubname_param.found) {
> +			line_range_search_cb(&lf.sp_die, &line_range_param);
> +			if (lf.found)
> +				goto found;
> +		}
> +	}
> +
>  	/* Loop on CUs (Compilation Unit) */
>  	while (!lf.found && ret >= 0) {
>  		if (dwarf_nextcu(dbg, off, &noff, &cuhl, NULL, NULL, NULL) != 0)
> @@ -1923,6 +1990,7 @@ int find_line_range(int fd, struct line_range *lr)
>  		off = noff;
>  	}
>  
> +found:
>  	/* Store comp_dir */
>  	if (lf.found) {
>  		comp_dir = cu_get_comp_dir(&lf.cu_die);
> diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
> index beaefc3..605730a 100644
> --- a/tools/perf/util/probe-finder.h
> +++ b/tools/perf/util/probe-finder.h
> @@ -49,6 +49,7 @@ struct probe_finder {
>  	Dwarf_Addr		addr;		/* Address */
>  	const char		*fname;		/* Real file name */
>  	Dwarf_Die		cu_die;		/* Current CU */
> +	Dwarf_Die		sp_die;
>  	struct list_head	lcache;		/* Line cache for lazy match */
>  
>  	/* For variable searching */
> @@ -83,6 +84,7 @@ struct line_finder {
>  	int			lno_s;		/* Start line number */
>  	int			lno_e;		/* End line number */
>  	Dwarf_Die		cu_die;		/* Current CU */
> +	Dwarf_Die		sp_die;
>  	int			found;
>  };
>  


-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com

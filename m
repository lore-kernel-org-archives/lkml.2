Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032019Ab2COReb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 13:34:31 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39224 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757183Ab2CORe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 13:34:27 -0400
Date: Thu, 15 Mar 2012 14:34:21 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf report: Fix calculation of the symbol column width
Message-ID: <20120315173421.GG9528@infradead.org>
References: <1331615369-23324-1-git-send-email-namhyung.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331615369-23324-1-git-send-email-namhyung.kim@lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Mar 13, 2012 at 02:09:29PM +0900, Namhyung Kim escreveu:
> The calculation of each column width is determining longest string or
> number in the data (including header). However printing symbol column
> doesn't honor the width. This is fine if symbol column is printed at
> last (default behavior), but if user changes the order using -s option
> the output will be messed up:

This one is clashing with b5387528:

"perf tools: Add code to support PERF_SAMPLE_BRANCH_STACK"

Ingo merged it recently, can you please respin this patch on perf/core?

- Arnaldo
 
>  $ perf report -s sym,dso,comm
>  ...
>  # Overhead  Symbol     Shared Object  Command
>  # ........  ......  ................  .......
>  #
>      99.96%  [.] main  noploop           noploop
>       0.03%  [.] memset  ld-2.12.1.so      noploop
>       0.00%  [.] 0x7ff751107b70    [unknown]          :18961
>       0.00%  [.] _start  ld-2.12.1.so      noploop
> 
> Also, the symbol column adds 4 characters which represents the cpu mode
> before the symbol and the width of unresolved symbols were not counted.
> 
> In addition, if user gave -v option it would print raw ip value and
> symbol origin character before the symbol name. After all of these
> concerns are addressed, the end result will look like this:
> 
>  $ perf report -s sym,dso,comm
>  ...
>  # Overhead              Symbol  Shared Object  Command
>  # ........  ..................  .............  .......
>  #
>      99.96%  [.] main            noploop        noploop
>       0.03%  [.] memset          ld-2.12.1.so   noploop
>       0.00%  [.] 0x7ff751107b70  [unknown]       :18961
>       0.00%  [.] _start          ld-2.12.1.so   noploop
> 
> Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
> ---
>  tools/perf/util/hist.c |   27 ++++++++++++++++++++-------
>  tools/perf/util/sort.c |   14 ++++++++------
>  2 files changed, 28 insertions(+), 13 deletions(-)
> 
> diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
> index 6f505d1abac7..2f5f8ff16e7e 100644
> --- a/tools/perf/util/hist.c
> +++ b/tools/perf/util/hist.c
> @@ -54,16 +54,25 @@ static void hists__calc_col_len(struct hists *hists, struct hist_entry *h)
>  {
>  	u16 len;
>  
> -	if (h->ms.sym)
> -		hists__new_col_len(hists, HISTC_SYMBOL, h->ms.sym->namelen);
> +	if (h->ms.sym) {
> +		len = h->ms.sym->namelen;
> +		if (!sort_dso.elide)
> +			len += 4;
> +		hists__new_col_len(hists, HISTC_SYMBOL, len);
> +	}
>  	else {
> -		const unsigned int unresolved_col_width = BITS_PER_LONG / 4;
> -
> -		if (hists__col_len(hists, HISTC_DSO) < unresolved_col_width &&
> +		char buf[BITS_PER_LONG / 4 + 3];
> +		len = snprintf(buf, BITS_PER_LONG / 4 + 2, "%#llx",
> +			       (unsigned long long)h->ip);
> +		if (!sort_dso.elide)
> +			len += 4;
> +		hists__new_col_len(hists, HISTC_SYMBOL, len);
> +
> +		len = strlen("[unknown]");
> +		if (hists__col_len(hists, HISTC_DSO) < len &&
>  		    !symbol_conf.col_width_list_str && !symbol_conf.field_sep &&
>  		    !symbol_conf.dso_list)
> -			hists__set_col_len(hists, HISTC_DSO,
> -					   unresolved_col_width);
> +			hists__set_col_len(hists, HISTC_DSO, len);
>  	}
>  
>  	len = thread__comm_len(h->thread);
> @@ -984,6 +993,8 @@ size_t hists__fprintf(struct hists *hists, struct hists *pair,
>  		}
>  		if (!hists__new_col_len(hists, se->se_width_idx, width))
>  			width = hists__col_len(hists, se->se_width_idx);
> +		if (verbose && se->se_width_idx == HISTC_SYMBOL)
> +			width += BITS_PER_LONG / 4 + 2 + 3;
>  		fprintf(fp, "  %*s", width, se->se_header);
>  	}
>  
> @@ -1016,6 +1027,8 @@ size_t hists__fprintf(struct hists *hists, struct hists *pair,
>  		width = hists__col_len(hists, se->se_width_idx);
>  		if (width == 0)
>  			width = strlen(se->se_header);
> +		if (verbose && se->se_width_idx == HISTC_SYMBOL)
> +			width += BITS_PER_LONG / 4 + 2 + 3;
>  		for (i = 0; i < width; i++)
>  			fprintf(fp, ".");
>  	}
> diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
> index 16da30d8d765..806752870b9c 100644
> --- a/tools/perf/util/sort.c
> +++ b/tools/perf/util/sort.c
> @@ -167,25 +167,27 @@ sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
>  }
>  
>  static int hist_entry__sym_snprintf(struct hist_entry *self, char *bf,
> -				    size_t size, unsigned int width __used)
> +				    size_t size, unsigned int width)
>  {
>  	size_t ret = 0;
>  
>  	if (verbose) {
>  		char o = self->ms.map ? dso__symtab_origin(self->ms.map->dso) : '!';
>  		ret += repsep_snprintf(bf, size, "%-#*llx %c ",
> -				       BITS_PER_LONG / 4, self->ip, o);
> +				       BITS_PER_LONG / 4 + 2, self->ip, o);
>  	}
>  
> -	if (!sort_dso.elide)
> +	if (!sort_dso.elide) {
>  		ret += repsep_snprintf(bf + ret, size - ret, "[%c] ", self->level);
> +		width -= 4;
> +	}
>  
>  	if (self->ms.sym)
> -		ret += repsep_snprintf(bf + ret, size - ret, "%s",
> +		ret += repsep_snprintf(bf + ret, size - ret, "%-*s", width,
>  				       self->ms.sym->name);
>  	else
> -		ret += repsep_snprintf(bf + ret, size - ret, "%-#*llx",
> -				       BITS_PER_LONG / 4, self->ip);
> +		ret += repsep_snprintf(bf + ret, size - ret, "%-#*llx", width,
> +				       self->ip);
>  
>  	return ret;
>  }
> -- 
> 1.7.9

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128Ab1DLHdA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 03:33:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:62538 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756732Ab1DLHc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 03:32:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,194,1301900400"; 
   d="scan'208";a="732175033"
Subject: Re: [PATCH -tip] perf hists browser: Fix seg fault when annotate
 null symbol
From: Lin Ming <ming.m.lin@intel.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1302244286.4106.36.camel@minggr.sh.intel.com>
References: <1302244286.4106.36.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Apr 2011 15:32:43 +0800
Message-ID: <1302593563.29423.17.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-08 at 14:31 +0800, Lin Ming wrote:
> In hists browser, press hotkey 'a' to annotate current symbol.
> Now it causes segment fault if 'a' is pressed on a null symbol.
> 
> Here are 2 small bugs:
> - In perf_evsel__hists_browse, the condition check after 'a' is pressed
>   is not correct, we should check ->sym instead of ->map.
> - In symbol__tui_annotate we must check whether sym is NULL or not
>   before getting annotation structure.
> 
> This patch fixes above 2 small bugs.

Hi, Arnaldo

Could you have a look at this segment fault fix?

Thanks,
Lin Ming

> 
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> ---
>  tools/perf/util/ui/browsers/annotate.c |    6 ++++--
>  tools/perf/util/ui/browsers/hists.c    |    2 +-
>  2 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
> index 8c17a87..15633d6 100644
> --- a/tools/perf/util/ui/browsers/annotate.c
> +++ b/tools/perf/util/ui/browsers/annotate.c
> @@ -256,10 +256,9 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
>  			 int refresh)
>  {
>  	struct objdump_line *pos, *n;
> -	struct annotation *notes = symbol__annotation(sym);
> +	struct annotation *notes;
>  	struct annotate_browser browser = {
>  		.b = {
> -			.entries = &notes->src->source,
>  			.refresh = ui_browser__list_head_refresh,
>  			.seek	 = ui_browser__list_head_seek,
>  			.write	 = annotate_browser__write,
> @@ -281,6 +280,8 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
>  
>  	ui_helpline__push("Press <- or ESC to exit");
>  
> +	notes = symbol__annotation(sym);
> +
>  	list_for_each_entry(pos, &notes->src->source, node) {
>  		struct objdump_line_rb_node *rbpos;
>  		size_t line_len = strlen(pos->line);
> @@ -291,6 +292,7 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
>  		rbpos->idx = browser.b.nr_entries++;
>  	}
>  
> +	browser.b.entries = &notes->src->source,
>  	browser.b.width += 18; /* Percentage */
>  	ret = annotate_browser__run(&browser, evidx, refresh);
>  	list_for_each_entry_safe(pos, n, &notes->src->source, node) {
> diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
> index 798efdc..5d767c6 100644
> --- a/tools/perf/util/ui/browsers/hists.c
> +++ b/tools/perf/util/ui/browsers/hists.c
> @@ -851,7 +851,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel,
>  			goto out_free_stack;
>  		case 'a':
>  			if (browser->selection == NULL ||
> -			    browser->selection->map == NULL ||
> +			    browser->selection->sym == NULL ||
>  			    browser->selection->map->dso->annotate_warned)
>  				continue;
>  			goto do_annotate;
> 



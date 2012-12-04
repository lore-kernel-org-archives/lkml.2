Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101Ab2LDNpv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 08:45:51 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:56007 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab2LDNpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 08:45:50 -0500
Date: Tue, 4 Dec 2012 10:45:44 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 3/3] perf diff: Use internal rb tree for compute resort
Message-ID: <20121204134544.GB3159@ghostprotocols.net>
References: <1354596265-9901-1-git-send-email-namhyung@kernel.org>
 <1354596265-9901-4-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354596265-9901-4-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 04, 2012 at 01:44:25PM +0900, Namhyung Kim escreveu:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> There's no reason to run hists_compute_resort() using output tree.
> Convert it to use internal tree so that it can remove unnecessary
> _output_resort.  Also move position computation below the resort since
> it changes the output ordering.

Have you tested this with 'perf top'? With the highest frequency?

- Arnaldo
 
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Stephane Eranian <eranian@google.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/builtin-diff.c | 32 +++++++++++++++++++-------------
>  1 file changed, 19 insertions(+), 13 deletions(-)
> 
> diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
> index b52f5d8c4a6b..4e18cea7c845 100644
> --- a/tools/perf/builtin-diff.c
> +++ b/tools/perf/builtin-diff.c
> @@ -435,19 +435,25 @@ static void insert_hist_entry_by_compute(struct rb_root *root,
>  
>  static void hists__compute_resort(struct hists *hists)
>  {
> -	struct rb_root tmp = RB_ROOT;
> -	struct rb_node *next = rb_first(&hists->entries);
> +	struct rb_root *root;
> +	struct rb_node *next;
> +
> +	if (sort__need_collapse)
> +		root = &hists->entries_collapsed;
> +	else
> +		root = hists->entries_in;
> +
> +	hists->entries = RB_ROOT;
> +	next = rb_first(root);
>  
>  	while (next != NULL) {
> -		struct hist_entry *he = rb_entry(next, struct hist_entry, rb_node);
> +		struct hist_entry *he;
>  
> -		next = rb_next(&he->rb_node);
> +		he = rb_entry(next, struct hist_entry, rb_node_in);
> +		next = rb_next(&he->rb_node_in);
>  
> -		rb_erase(&he->rb_node, &hists->entries);
> -		insert_hist_entry_by_compute(&tmp, he, compute);
> +		insert_hist_entry_by_compute(&hists->entries, he, compute);
>  	}
> -
> -	hists->entries = tmp;
>  }
>  
>  static void hists__process(struct hists *old, struct hists *new)
> @@ -459,16 +465,16 @@ static void hists__process(struct hists *old, struct hists *new)
>  	else
>  		hists__link(new, old);
>  
> -	hists__output_resort(new);
> -
> -	if (show_displacement)
> -		hists__compute_position(new);
> -
>  	if (sort_compute) {
>  		hists__precompute(new);
>  		hists__compute_resort(new);
> +	} else {
> +		hists__output_resort(new);
>  	}
>  
> +	if (show_displacement)
> +		hists__compute_position(new);
> +
>  	hists__fprintf(new, true, 0, 0, stdout);
>  }
>  
> -- 
> 1.7.11.7

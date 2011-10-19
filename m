Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844Ab1JSSix (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 14:38:53 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58855 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab1JSSiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 14:38:52 -0400
Date: Wed, 19 Oct 2011 16:38:48 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com
Subject: Re: [PATCH] perf top: fix crash on annotate request
Message-ID: <20111019183848.GE2229@ghostprotocols.net>
References: <1319048598-15030-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319048598-15030-1-git-send-email-dsahern@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Oct 19, 2011 at 12:23:18PM -0600, David Ahern escreveu:
> Hitting an annotate case where src is not set and
> perf-top crashes.

How did you got there? Navigating thru callq? I  wonder if in this case
we'd instead shouldn't call

symbol__alloc_hist(sym, evlist->nr_entries)

And proceed, only complaining on ENOMEM, like we do in parse_source in
builtin-top.c.

I.e. if the user asked to go to a function without hits, no problem,
allocate the data structures needed for doing the annotation and show 0
hits on all lines.

- Arnaldo
 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> ---
>  tools/perf/util/annotate.c             |    3 +++
>  tools/perf/util/ui/browsers/annotate.c |    2 ++
>  2 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
> index bc8f477..26652b1 100644
> --- a/tools/perf/util/annotate.c
> +++ b/tools/perf/util/annotate.c
> @@ -205,6 +205,9 @@ static int symbol__parse_objdump_line(struct symbol *sym, struct map *map,
>  	size_t line_len;
>  	s64 line_ip, offset = -1;
>  
> +	if (!notes->src)
> +		return -1;
> +
>  	if (getline(&line, &line_len, file) < 0)
>  		return -1;
>  
> diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
> index a2c351c..5a67ead 100644
> --- a/tools/perf/util/ui/browsers/annotate.c
> +++ b/tools/perf/util/ui/browsers/annotate.c
> @@ -410,6 +410,8 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
>  	ui_helpline__push("Press <- or ESC to exit");
>  
>  	notes = symbol__annotation(sym);
> +	if (!notes->src)
> +		return -1;
>  
>  	list_for_each_entry(pos, &notes->src->source, node) {
>  		struct objdump_line_rb_node *rbpos;
> -- 
> 1.7.6.4

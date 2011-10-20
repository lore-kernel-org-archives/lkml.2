Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab1JTMvu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 08:51:50 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35568 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab1JTMvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 08:51:49 -0400
Date: Thu, 20 Oct 2011 10:51:43 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com
Subject: Re: [PATCH] perf top: fix crash on annotate request
Message-ID: <20111020125143.GA1772@ghostprotocols.net>
References: <1319048598-15030-1-git-send-email-dsahern@gmail.com>
 <20111019183848.GE2229@ghostprotocols.net>
 <4E9F1AA0.4010706@gmail.com>
 <20111019192011.GG2229@ghostprotocols.net>
 <4E9F4392.406@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E9F4392.406@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Oct 19, 2011 at 03:39:30PM -0600, David Ahern escreveu:
> On 10/19/2011 01:20 PM, Arnaldo Carvalho de Melo wrote:
> > Can you check if that is the problem? I.e. take notes->lock, check if
> > ->src is NULL, if so call symbol__alloc_hist, etc?
> > 
> 
> Reproduced it on a lab box. This fixes the segfault:
> 
> diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
> index bc8f477..6bd501a 100644
> --- a/tools/perf/util/annotate.c
> +++ b/tools/perf/util/annotate.c
> @@ -253,6 +253,17 @@ static int symbol__parse_objdump_line(struct symbol
> *sym, struct map *map,
>         free(line);
>         return -1;
>     }
> +
> +   pthread_mutex_lock(&notes->lock);
> +   if (notes->src == NULL &&
> +       symbol__alloc_hist(sym, 1) < 0) {
> +       pthread_mutex_unlock(&notes->lock);
> +       ui__warning("Not enough memory for annotating '%s' symbol!\n",
> +               sym->name);
> +       return -1;
> +   }
> +   pthread_mutex_unlock(&notes->lock);
> +
>     objdump__add_line(&notes->src->source, objdump_line);
> 
>     return 0;
> 
> Should I plumb nr_events down versus assuming its 1?

better to plumb it properly, i.e. at some point where you have access to
evlist to get its ->nr_entries so that we properly support multiple
events.

- Arnaldo

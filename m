Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab2LETHE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 14:07:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828Ab2LETHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 14:07:02 -0500
Date: Wed, 5 Dec 2012 20:06:46 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/3] perf hists: Link hist entries before inserting to an
 output tree
Message-ID: <20121205190646.GB1037@krava.brq.redhat.com>
References: <1354690603-31364-1-git-send-email-namhyung@kernel.org>
 <1354690603-31364-3-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354690603-31364-3-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2012 at 03:56:42PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 

SNIP

> -	struct rb_node *next = rb_first(&hists->entries);
> +	struct rb_root *root;
> +	struct rb_node *next;
> +
> +	if (sort__need_collapse)
> +		root = &hists->entries_collapsed;
> +	else
> +		root = hists->entries_in;
>  
> +	next = rb_first(root);
>  	while (next != NULL) {
> -		struct hist_entry *he = rb_entry(next, struct hist_entry, rb_node);
> +		struct hist_entry *he = rb_entry(next, struct hist_entry, rb_node_in);
>  
> -		next = rb_next(&he->rb_node);
> +		next = rb_next(&he->rb_node_in);
>  		if (!hist_entry__next_pair(he)) {
> -			rb_erase(&he->rb_node, &hists->entries);
> +			rb_erase(&he->rb_node_in, root);
>  			hist_entry__free(he);
>  		}
>  	}
> @@ -481,6 +459,11 @@ static void hists__process(struct hists *old, struct hists *new)
>  	else
>  		hists__link(new, old);
>  
> +	hists__output_resort(new);
> +
> +	if (show_displacement)
> +		hists__compute_position(new);
> +

Computing the position after hists__link screws up the position data,
because we likely have new entries in.

However, I wonder if anyone is actualy using displacement info..?

jirka

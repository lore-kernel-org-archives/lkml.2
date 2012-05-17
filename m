Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758855Ab2EQUXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 16:23:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38846 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788Ab2EQUXo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 16:23:44 -0400
Message-ID: <1337286204.4281.87.camel@twins>
Subject: Re: [PATCH] mm: Optimize put_mems_allowed() usage
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Miao Xie <miaox@cn.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Pekka Enberg <penberg@cs.helsinki.fi>
Date: Thu, 17 May 2012 22:23:24 +0200
In-Reply-To: <20120517131610.d1b09fd8.akpm@linux-foundation.org>
References: <20120307180852.GE17697@suse.de>
	 <1332759384.16159.92.camel@twins> <20120326155027.GF16573@suse.de>
	 <1332778852.16159.138.camel@twins> <20120327124734.GH16573@suse.de>
	 <1332854070.16159.223.camel@twins>
	 <20120517131610.d1b09fd8.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-17 at 13:16 -0700, Andrew Morton wrote:
> I do think it was a bad idea to remove that comment.  As it stands, the
> reader will be wondering why we did the read_mems_allowed_begin() at
> all, and whether failing to check for a change is a bug.
> 
> --- a/mm/slub.c~mm-optimize-put_mems_allowed-usage-fix
> +++ a/mm/slub.c
> @@ -1624,8 +1624,16 @@ static struct page *get_any_partial(stru
>                         if (n && cpuset_zone_allowed_hardwall(zone, flags) &&
>                                         n->nr_partial > s->min_partial) {
>                                 object = get_partial_node(s, n, c);
> -                               if (object)
> +                               if (object) {
> +                                       /*
> +                                        * Don't check read_mems_allowed_retry()
> +                                        * here - if mems_allowed was updated in
> +                                        * parallel, that was a harmless race
> +                                        * between allocation and the cpuset
> +                                        * update
> +                                        */
>                                         return object;
> +                               }
>                         }
>                 }
>         } while (read_mems_allowed_retry(cpuset_mems_cookie)); 

OK, it seemed weird to have that comment in this one place whilst it is
the general pattern of this construct.

The whole read_mems_allowed_retry() should only ever be attempted in
case the allocation failed.

But sure..

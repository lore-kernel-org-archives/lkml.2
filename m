Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967742Ab2EQUQO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 16:16:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33888 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965962Ab2EQUQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 16:16:12 -0400
Date: Thu, 17 May 2012 13:16:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mel Gorman <mgorman@suse.de>, Miao Xie <miaox@cn.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] mm: Optimize put_mems_allowed() usage
Message-Id: <20120517131610.d1b09fd8.akpm@linux-foundation.org>
In-Reply-To: <1332854070.16159.223.camel@twins>
References: <20120307180852.GE17697@suse.de>
	<1332759384.16159.92.camel@twins>
	<20120326155027.GF16573@suse.de>
	<1332778852.16159.138.camel@twins>
	<20120327124734.GH16573@suse.de>
	<1332854070.16159.223.camel@twins>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2012 15:14:30 +0200
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Subject: mm: Optimize put_mems_allowed() usage
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Mon Mar 26 14:13:05 CEST 2012
> 
> Since put_mems_allowed() is strictly optional, its a seqcount retry,
> we don't need to evaluate the function if the allocation was in fact
> successful, saving a smp_rmb some loads and comparisons on some
> relative fast-paths.
> 
> Since the naming, get/put_mems_allowed() does suggest a mandatory
> pairing, rename the interface, as suggested by Mel, to resemble the
> seqcount interface.
> 
> This gives us: read_mems_allowed_begin() and
> read_mems_allowed_retry(), where it is important to note that the
> return value of the latter call is inverted from its previous
> incarnation.
> 
> ...
>
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1606,7 +1606,7 @@ static struct page *get_any_partial(stru
>  		return NULL;
>  
>  	do {
> -		cpuset_mems_cookie = get_mems_allowed();
> +		cpuset_mems_cookie = read_mems_allowed_begin();
>  		zonelist = node_zonelist(slab_node(current->mempolicy), flags);
>  		for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
>  			struct kmem_cache_node *n;
> @@ -1616,21 +1616,11 @@ static struct page *get_any_partial(stru
>  			if (n && cpuset_zone_allowed_hardwall(zone, flags) &&
>  					n->nr_partial > s->min_partial) {
>  				object = get_partial_node(s, n, c);
> -				if (object) {
> -					/*
> -					 * Return the object even if
> -					 * put_mems_allowed indicated that
> -					 * the cpuset mems_allowed was
> -					 * updated in parallel. It's a
> -					 * harmless race between the alloc
> -					 * and the cpuset update.
> -					 */
> -					put_mems_allowed(cpuset_mems_cookie);
> +				if (object)
>  					return object;
> -				}
>  			}
>  		}
> -	} while (!put_mems_allowed(cpuset_mems_cookie));
> +	} while (read_mems_allowed_retry(cpuset_mems_cookie));

I do think it was a bad idea to remove that comment.  As it stands, the
reader will be wondering why we did the read_mems_allowed_begin() at
all, and whether failing to check for a change is a bug.

--- a/mm/slub.c~mm-optimize-put_mems_allowed-usage-fix
+++ a/mm/slub.c
@@ -1624,8 +1624,16 @@ static struct page *get_any_partial(stru
 			if (n && cpuset_zone_allowed_hardwall(zone, flags) &&
 					n->nr_partial > s->min_partial) {
 				object = get_partial_node(s, n, c);
-				if (object)
+				if (object) {
+					/*
+					 * Don't check read_mems_allowed_retry()
+					 * here - if mems_allowed was updated in
+					 * parallel, that was a harmless race
+					 * between allocation and the cpuset
+					 * update
+					 */
 					return object;
+				}
 			}
 		}
 	} while (read_mems_allowed_retry(cpuset_mems_cookie));
_


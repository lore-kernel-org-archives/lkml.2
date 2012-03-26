Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932839Ab2CZPud (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 11:50:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52534 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932489Ab2CZPuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 11:50:32 -0400
Date: Mon, 26 Mar 2012 16:50:27 +0100
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Miao Xie <miaox@cn.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuset: mm: Reduce large amounts of memory barrier
 related damage v3
Message-ID: <20120326155027.GF16573@suse.de>
References: <20120307180852.GE17697@suse.de>
 <1332759384.16159.92.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1332759384.16159.92.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 12:56:24PM +0200, Peter Zijlstra wrote:
> On Wed, 2012-03-07 at 18:08 +0000, Mel Gorman wrote:
> > +               } while (!put_mems_allowed(cpuset_mems_cookie) && !page);
> 
> Sorry for only noticing this now, but wouldn't it be better to first
> check page and only then bother with the put_mems_allowed() thing? That
> avoids the smp_rmb() and seqcount conditional all together in the likely
> case the allocation actually succeeded.
> 
> <SNIP>
>
> diff --git a/mm/filemap.c b/mm/filemap.c
> index c3811bc..3b41553 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -504,7 +504,7 @@ struct page *__page_cache_alloc(gfp_t gfp)
>  			cpuset_mems_cookie = get_mems_allowed();
>  			n = cpuset_mem_spread_node();
>  			page = alloc_pages_exact_node(n, gfp, 0);
> -		} while (!put_mems_allowed(cpuset_mems_cookie) && !page);
> +		} while (!page && !put_mems_allowed(cpuset_mems_cookie));
>  
>  		return page;
>  	}

I think such a change would be better but should also rename the API.
If developers see a get_foo type call, they will expect to see a put_foo
call or assume it's a bug even though the implementation happens to be ok
with that. Any suggestion on what a good new name would be?

How about read_mems_allowed_begin() and read_mems_allowed_retry()?

read_mems_allowed_begin would be a rename of get_mems_allowed().  In an
error path, read_mems_allowed_retry() would documented to be *optionally*
called when deciding whether to retry the operation or not. In this scheme,
!put_mems_allowed would become read_mems_allowed_retry() which might be
a bit easier to read overall.

-- 
Mel Gorman
SUSE Labs

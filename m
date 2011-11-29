Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab1K2MaA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 07:30:00 -0500
Received: from mga14.intel.com ([143.182.124.37]:36642 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752357Ab1K2M35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 07:29:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,590,1315206000"; 
   d="scan'208";a="80181643"
Date: Tue, 29 Nov 2011 20:29:51 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 5/8] readahead: add /debug/readahead/stats
Message-ID: <20111129122951.GA17432@localhost>
References: <20111121091819.394895091@intel.com>
 <20111121093846.636765408@intel.com>
 <20111121152958.e4fd76d4.akpm@linux-foundation.org>
 <20111129032323.GC19506@localhost>
 <20111128204950.29404d0b.akpm@linux-foundation.org>
 <20111129064109.GA8612@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111129064109.GA8612@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  int force_page_cache_readahead(struct address_space *mapping, struct file *filp,
>  		pgoff_t offset, unsigned long nr_to_read)
>  {
> +	struct file_ra_state fadvice_ra = {
> +		.pattern	= RA_PATTERN_FADVISE,
> +	};
>  	int ret = 0;
>  
>  	if (unlikely(!mapping->a_ops->readpage && !mapping->a_ops->readpages))
> @@ -222,8 +397,9 @@ int force_page_cache_readahead(struct ad
>  
>  		if (this_chunk > nr_to_read)
>  			this_chunk = nr_to_read;
> -		err = __do_page_cache_readahead(mapping, filp,
> -						offset, this_chunk, 0);
> +		fadvice_ra.start = offset;
> +		fadvice_ra.size = this_chunk;
> +		err = ra_submit(&fadvice_ra, mapping, filp, offset, nr_to_read);
>  		if (err < 0) {
>  			ret = err;
>  			break;

It looks that we can safely use filp->f_ra:

@@ -214,6 +386,7 @@ int force_page_cache_readahead(struct ad
        if (unlikely(!mapping->a_ops->readpage && !mapping->a_ops->readpages))
                return -EINVAL;

+       filp->f_ra.pattern = RA_PATTERN_FADVISE;
        nr_to_read = max_sane_readahead(nr_to_read);
        while (nr_to_read) {
                int err;
@@ -222,8 +395,9 @@ int force_page_cache_readahead(struct ad
               
                if (this_chunk > nr_to_read)
                        this_chunk = nr_to_read;
-               err = __do_page_cache_readahead(mapping, filp,
-                                               offset, this_chunk, 0);
+               filp->f_ra.start = offset;
+               filp->f_ra.size = this_chunk;
+               err = ra_submit(&filp->f_ra, mapping, filp, offset, nr_to_read);
                if (err < 0) {
                        ret = err;
                        break;

But still, it adds one more function call to the fadvise path.

Thanks,
Fengguang

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848Ab0D1CAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 22:00:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753548Ab0D1CAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 22:00:41 -0400
Date: Wed, 28 Apr 2010 01:10:07 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] mm,migration: Prevent rmap_walk_[anon|ksm] seeing
 the wrong VMA information
Message-ID: <20100427231007.GA510@random.random>
References: <1272403852-10479-1-git-send-email-mel@csn.ul.ie>
 <1272403852-10479-3-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272403852-10479-3-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 10:30:51PM +0100, Mel Gorman wrote:
> diff --git a/mm/mmap.c b/mm/mmap.c
> index f90ea92..61d6f1d 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -578,6 +578,9 @@ again:			remove_next = 1 + (end > next->vm_end);
>  		}
>  	}
>  
> +	if (vma->anon_vma)
> +		spin_lock(&vma->anon_vma->lock);
> +
>  	if (root) {
>  		flush_dcache_mmap_lock(mapping);
>  		vma_prio_tree_remove(vma, root);
> @@ -620,6 +623,9 @@ again:			remove_next = 1 + (end > next->vm_end);
>  	if (mapping)
>  		spin_unlock(&mapping->i_mmap_lock);
>  
> +	if (vma->anon_vma)
> +		spin_unlock(&vma->anon_vma->lock);
> +
>  	if (remove_next) {
>  		if (file) {
>  			fput(file);

The old code did:

    /*
     * When changing only vma->vm_end, we don't really need
     * anon_vma lock.
     */
    if (vma->anon_vma && (insert || importer || start !=  vma->vm_start))
	anon_vma = vma->anon_vma;
    if (anon_vma) {
        spin_lock(&anon_vma->lock);

why did it become unconditional? (and no idea why it was removed)

But I'm not sure about this part.... this is really only a question, I
may well be wrong, I just don't get it.

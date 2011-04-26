Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139Ab1DZAhU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 20:37:20 -0400
Received: from smtp-out.google.com ([74.125.121.67]:26331 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913Ab1DZAhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 20:37:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=wOe2PLMKYl6q2mvgWxdvKIqelnZ3BQ//sabW1qy4e2y99SlIiTZ6iMJg5gmTEuS1KH
         M59URk090YgrkNXVicSg==
Date: Mon, 25 Apr 2011 17:37:19 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Willy Tarreau <w@1wt.eu>
cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        Bob Liu <lliubbo@gmail.com>, David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Enrik Berkhan <Enrik.Berkhan@ge.com>
Subject: Re: [PATCH 165/173] ramfs: fix memleak on no-mmu arch
In-Reply-To: <20110425200240.164070671@pcw.home.local>
Message-ID: <alpine.LSU.2.00.1104251653310.5571@sister.anvils>
References: <20110425200240.164070671@pcw.home.local>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Apr 2011, Willy Tarreau wrote:

> 2.6.27.59-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> 
> From: Bob Liu <lliubbo@gmail.com>
> 
> commit b836aec53e2bce71de1d5415313380688c851477 upstream.
> 
> On no-mmu arch, there is a memleak during shmem test.  The cause of this
> memleak is ramfs_nommu_expand_for_mapping() added page refcount to 2
> which makes iput() can't free that pages.
> 
...
> 
> Signed-off-by: Bob Liu <lliubbo@gmail.com>
> Acked-by: Hugh Dickins <hughd@google.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  fs/ramfs/file-nommu.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- a/fs/ramfs/file-nommu.c
> +++ b/fs/ramfs/file-nommu.c
> @@ -111,6 +111,7 @@ int ramfs_nommu_expand_for_mapping(struc
>  		SetPageDirty(page);
>  
>  		unlock_page(page);
> +		put_page(page);
>  	}
>  
>  	return 0;


I'm not absolutely certain, but I rather think this patch should NOT
be included: I never looked to see when the bug it fixes crept in,
but now I'm thinking it may have been 2678958e1225 "ramfs-nommu:
use generic lru cache", which did not go in until 2.6.30 -
__lru_cache_add adding the unbalanced page_cache_get.

Whereas the "SetPageDirty" you can see above is not in 2.6.27.59-rc1:
I think you'd do well to include the patch below which introduced it.
(It may give you a reject because __pagevec_lru_add was enhanced to
__pagevec_lru_add_file by the time that patch went in.)

Yes, the pages Enrik reports as being wrongly discarded, would not
have been discarded if their reference counts were too high:
I do believe you need Enrik's patch instead of Bob's patch.

Hugh

commit 020fe22ff14320927f394de222cbb11708bcc7a8
Author: Enrik Berkhan <Enrik.Berkhan@ge.com>
Date:   Fri Mar 13 13:51:56 2009 -0700

    nommu: ramfs: pages allocated to an inode's pagecache may get wrongly discarded
    
    The pages attached to a ramfs inode's pagecache by truncation from nothing
    - as done by SYSV SHM for example - may get discarded under memory
    pressure.
    
    The problem is that the pages are not marked dirty.  Anything that creates
    data in an MMU-based ramfs will cause the pages holding that data will
    cause the set_page_dirty() aop to be called.
    
    For the NOMMU-based mmap, set_page_dirty() may be called by write(), but
    it won't be called by page-writing faults on writable mmaps, and it isn't
    called by ramfs_nommu_expand_for_mapping() when a file is being truncated
    from nothing to allocate a contiguous run.
    
    The solution is to mark the pages dirty at the point of allocation by the
    truncation code.
    
    Signed-off-by: Enrik Berkhan <Enrik.Berkhan@ge.com>
    Signed-off-by: David Howells <dhowells@redhat.com>
    Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Cc: Nick Piggin <nickpiggin@yahoo.com.au>
    Cc: Johannes Weiner <hannes@cmpxchg.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/fs/ramfs/file-nommu.c b/fs/ramfs/file-nommu.c
index b9b567a..90d72be 100644
--- a/fs/ramfs/file-nommu.c
+++ b/fs/ramfs/file-nommu.c
@@ -114,6 +114,9 @@ int ramfs_nommu_expand_for_mapping(struct inode *inode, size_t newsize)
 		if (!pagevec_add(&lru_pvec, page))
 			__pagevec_lru_add_file(&lru_pvec);
 
+		/* prevent the page from being discarded on memory pressure */
+		SetPageDirty(page);
+
 		unlock_page(page);
 	}
 

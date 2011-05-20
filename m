Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204Ab1ETRuK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 13:50:10 -0400
Received: from smtp-out.google.com ([74.125.121.67]:28073 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab1ETRuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 13:50:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=lmjDgmwYVvB8glrdZL90BNIUXdSJ68W6g/Cb0NtvyMYmVgB431VdlW9jlO+NQyvs1n
         AZNQ2roJycUAknMJ6iRg==
Date: Fri, 20 May 2011 10:49:59 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Greg KH <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: [15/24] tmpfs: fix spurious ENOSPC when racing with unswap
In-Reply-To: <20110519183127.122729561@clark.kroah.org>
Message-ID: <alpine.LSU.2.00.1105201026430.9887@sister.anvils>
References: <20110519183127.122729561@clark.kroah.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 May 2011, Greg KH wrote:
> 2.6.33-longterm review patch.  If anyone has any objections, please let us know.

We've got in a muddle on this one: too many tmpfs races and too many trees!

> 
> ------------------
> Content-Length: 3111
> Lines: 91
> 
> From: Hugh Dickins <hughd@google.com>
> 
> commit 59a16ead572330deb38e5848151d30ed1af754bc upstream.
> 
> Testing the shmem_swaplist replacements for igrab() revealed another bug:
> writes to /dev/loop0 on a tmpfs file which fills its filesystem were
> sometimes failing with "Buffer I/O error"s.
> 
> These came from ENOSPC failures of shmem_getpage(), when racing with
> swapoff: the same could happen when racing with another shmem_getpage(),
> pulling the page in from swap in between our find_lock_page() and our
> taking the info->lock (though not in the single-threaded loop case).
> 
> This is unacceptable, and surprising that I've not noticed it before:
> it dates back many years, but (presumably) was made a lot easier to
> reproduce in 2.6.36, which sited a page preallocation in the race window.
> 
> Fix it by rechecking the page cache before settling on an ENOSPC error.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

So far, so good: indeed let's have the spurious ENOSPC fix in
33-longterm.

But here this 15/24 patch veers off into a quite different patch,
for "tmpfs: fix race between umount and writepage" (46/71 in the
38-stable series).  I've appended the actual ENOSPC backport at the end.

Yes, let's have this writepage fix in 33-longterm too (the 38-stable
patch should apply), but it does need "tmpfs: fix race between swapoff
and writepage" (47/71 in the 38-stable series) on top to correct it,
please add that in too.

For differing reasons, none of these races is as likely in 2.6.33
as in 2.6.38, but good to include the fixes anyway; whereas 2.6.32
gets more complicated for some of them, so I haven't bothered there.

(I think I'm reading the mails right, but of course made a fool of
myself in the past, because of how gmail "rationalized" my view of
them: I hope this won't be another such case.)

> 
> 
> ---
>  mm/shmem.c |   31 ++++++++++++++++++++-----------
>  1 file changed, 20 insertions(+), 11 deletions(-)
> 
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1035,6 +1035,7 @@ static int shmem_writepage(struct page *
>  	struct address_space *mapping;
>  	unsigned long index;
>  	struct inode *inode;
> +	bool unlock_mutex = false;
>  
>  	BUG_ON(!PageLocked(page));
>  	mapping = page->mapping;
> @@ -1060,7 +1061,26 @@ static int shmem_writepage(struct page *
>  	else
>  		swap.val = 0;
>  
> +	/*
> +	 * Add inode to shmem_unuse()'s list of swapped-out inodes,
> +	 * if it's not already there.  Do it now because we cannot take
> +	 * mutex while holding spinlock, and must do so before the page
> +	 * is moved to swap cache, when its pagelock no longer protects
> +	 * the inode from eviction.  But don't unlock the mutex until
> +	 * we've taken the spinlock, because shmem_unuse_inode() will
> +	 * prune a !swapped inode from the swaplist under both locks.
> +	 */
> +	if (swap.val && list_empty(&info->swaplist)) {
> +		mutex_lock(&shmem_swaplist_mutex);
> +		/* move instead of add in case we're racing */
> +		list_move_tail(&info->swaplist, &shmem_swaplist);
> +		unlock_mutex = true;
> +	}
> +
>  	spin_lock(&info->lock);
> +	if (unlock_mutex)
> +		mutex_unlock(&shmem_swaplist_mutex);
> +
>  	if (index >= info->next_index) {
>  		BUG_ON(!(info->flags & SHMEM_TRUNCATE));
>  		goto unlock;
> @@ -1080,22 +1100,11 @@ static int shmem_writepage(struct page *
>  		remove_from_page_cache(page);
>  		shmem_swp_set(info, entry, swap.val);
>  		shmem_swp_unmap(entry);
> -		if (list_empty(&info->swaplist))
> -			inode = igrab(inode);
> -		else
> -			inode = NULL;
>  		spin_unlock(&info->lock);
>  		swap_shmem_alloc(swap);
>  		BUG_ON(page_mapped(page));
>  		page_cache_release(page);	/* pagecache ref */
>  		swap_writepage(page, wbc);
> -		if (inode) {
> -			mutex_lock(&shmem_swaplist_mutex);
> -			/* move instead of add in case we're racing */
> -			list_move_tail(&info->swaplist, &shmem_swaplist);
> -			mutex_unlock(&shmem_swaplist_mutex);
> -			iput(inode);
> -		}
>  		return 0;
>  	}
>  

Here's that ENOSPC backport again:

commit 59a16ead572330deb38e5848151d30ed1af754bc backported
Author: Hugh Dickins <hughd@google.com>
Date:   Wed May 11 15:13:38 2011 -0700
Subject: [PATCH] tmpfs: fix spurious ENOSPC when racing with unswap
    
    Testing the shmem_swaplist replacements for igrab() revealed another bug:
    writes to /dev/loop0 on a tmpfs file which fills its filesystem were
    sometimes failing with "Buffer I/O error"s.
    
    These came from ENOSPC failures of shmem_getpage(), when racing with
    swapoff: the same could happen when racing with another shmem_getpage(),
    pulling the page in from swap in between our find_lock_page() and our
    taking the info->lock (though not in the single-threaded loop case).
    
    This is unacceptable, and surprising that I've not noticed it before:
    it dates back many years, but (presumably) was made a lot easier to
    reproduce in 2.6.36, which sited a page preallocation in the race window.
    
    Fix it by rechecking the page cache before settling on an ENOSPC error.
    
    Signed-off-by: Hugh Dickins <hughd@google.com>
    Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
    Cc: <stable@kernel.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1396,18 +1396,13 @@ repeat:
 			if (sbinfo->free_blocks == 0 ||
 			    shmem_acct_block(info->flags)) {
 				spin_unlock(&sbinfo->stat_lock);
-				spin_unlock(&info->lock);
-				error = -ENOSPC;
-				goto failed;
+				goto nospace;
 			}
 			sbinfo->free_blocks--;
 			inode->i_blocks += BLOCKS_PER_PAGE;
 			spin_unlock(&sbinfo->stat_lock);
-		} else if (shmem_acct_block(info->flags)) {
-			spin_unlock(&info->lock);
-			error = -ENOSPC;
-			goto failed;
-		}
+		} else if (shmem_acct_block(info->flags))
+			goto nospace;
 
 		if (!filepage) {
 			int ret;
@@ -1476,6 +1471,24 @@ done:
 	*pagep = filepage;
 	return 0;
 
+nospace:
+	/*
+	 * Perhaps the page was brought in from swap between find_lock_page
+	 * and taking info->lock?  We allow for that at add_to_page_cache_lru,
+	 * but must also avoid reporting a spurious ENOSPC while working on a
+	 * full tmpfs.  (When filepage has been passed in to shmem_getpage, it
+	 * is already in page cache, which prevents this race from occurring.)
+	 */
+	if (!filepage) {
+		struct page *page = find_get_page(mapping, idx);
+		if (page) {
+			spin_unlock(&info->lock);
+			page_cache_release(page);
+			goto repeat;
+		}
+	}
+	spin_unlock(&info->lock);
+	error = -ENOSPC;
 failed:
 	if (*pagep != filepage) {
 		unlock_page(filepage);

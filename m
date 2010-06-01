Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450Ab0FAWEw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 18:04:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47099 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752388Ab0FAWEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 18:04:51 -0400
Date: Tue, 1 Jun 2010 15:04:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Mel Gorman <mel@csn.ul.ie>, Andrea Arcangeli <aarcange@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 2/5] change direct call of spin_lock(anon_vma->lock) to
 inline function
Message-Id: <20100601150402.c828b219.akpm@linux-foundation.org>
In-Reply-To: <20100526153926.1272945b@annuminas.surriel.com>
References: <20100526153819.6e5cec0d@annuminas.surriel.com>
	<20100526153926.1272945b@annuminas.surriel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010 15:39:26 -0400
Rik van Riel <riel@redhat.com> wrote:

> @@ -303,10 +303,10 @@ again:
>  		goto out;
>  
>  	anon_vma = (struct anon_vma *) (anon_mapping - PAGE_MAPPING_ANON);
> -	spin_lock(&anon_vma->lock);
> +	anon_vma_lock(anon_vma);
>  
>  	if (page_rmapping(page) != anon_vma) {
> -		spin_unlock(&anon_vma->lock);
> +		anon_vma_unlock(anon_vma);
>  		goto again;
>  	}
>  

This bit is dependent upon Peter's
mm-revalidate-anon_vma-in-page_lock_anon_vma.patch (below).  I've been
twiddling thumbs for weeks awaiting the updated version of that patch
(hint).

Do we think that this patch series is needed in 2.6.35?  If so, why? 
And if so I guess we'll need to route around
mm-revalidate-anon_vma-in-page_lock_anon_vma.patch, or just merge it
as-is.


From: Peter Zijlstra <a.p.zijlstra@chello.nl>

There is nothing preventing the anon_vma from being detached while we are
spinning to acquire the lock.  Most (all?) current users end up calling
something like vma_address(page, vma) on it, which has a fairly good
chance of weeding out wonky vmas.

However suppose the anon_vma got freed and re-used while we were waiting
to acquire the lock, and the new anon_vma fits with the page->index
(because that is the only thing vma_address() uses to determine if the
page fits in a particular vma, we could end up traversing faulty anon_vma
chains.

Close this hole for good by re-validating that page->mapping still holds
the very same anon_vma pointer after we acquire the lock, if not be
utterly paranoid and retry the whole operation (which will very likely
bail, because it's unlikely the page got attached to a different anon_vma
in the meantime).

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN mm/rmap.c~mm-revalidate-anon_vma-in-page_lock_anon_vma mm/rmap.c
--- a/mm/rmap.c~mm-revalidate-anon_vma-in-page_lock_anon_vma
+++ a/mm/rmap.c
@@ -370,6 +370,7 @@ struct anon_vma *page_lock_anon_vma(stru
 	unsigned long anon_mapping;
 
 	rcu_read_lock();
+again:
 	anon_mapping = (unsigned long) ACCESS_ONCE(page->mapping);
 	if ((anon_mapping & PAGE_MAPPING_FLAGS) != PAGE_MAPPING_ANON)
 		goto out;
@@ -378,6 +379,12 @@ struct anon_vma *page_lock_anon_vma(stru
 
 	anon_vma = (struct anon_vma *) (anon_mapping - PAGE_MAPPING_ANON);
 	spin_lock(&anon_vma->lock);
+
+	if (page_rmapping(page) != anon_vma) {
+		spin_unlock(&anon_vma->lock);
+		goto again;
+	}
+
 	return anon_vma;
 out:
 	rcu_read_unlock();
_


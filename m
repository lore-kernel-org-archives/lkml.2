Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403Ab2ISQo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 12:44:28 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:57873 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756142Ab2ISQoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 12:44:23 -0400
Date: Wed, 19 Sep 2012 12:44:11 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <levinsasha928@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>, Michel Lespinasse <walken@google.com>,
        Ying Han <yinghan@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] mm: fix invalidate_complete_page2 lock ordering
Message-ID: <20120919164411.GP1560@cmpxchg.org>
References: <alpine.LSU.2.00.1209182045370.11632@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1209182045370.11632@eggly.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 08:51:47PM -0700, Hugh Dickins wrote:
> In fuzzing with trinity, lockdep protested "possible irq lock inversion
> dependency detected" when isolate_lru_page() reenabled interrupts while
> still holding the supposedly irq-safe tree_lock:
> 
> invalidate_inode_pages2
>   invalidate_complete_page2
>     spin_lock_irq(&mapping->tree_lock)
>     clear_page_mlock
>       isolate_lru_page
>         spin_unlock_irq(&zone->lru_lock)
> 
> isolate_lru_page() is correct to enable interrupts unconditionally:
> invalidate_complete_page2() is incorrect to call clear_page_mlock()
> while holding tree_lock, which is supposed to nest inside lru_lock.
> 
> Both truncate_complete_page() and invalidate_complete_page() call
> clear_page_mlock() before taking tree_lock to remove page from
> radix_tree.  I guess invalidate_complete_page2() preferred to test
> PageDirty (again) under tree_lock before committing to the munlock;
> but since the page has already been unmapped, its state is already
> somewhat inconsistent, and no worse if clear_page_mlock() moved up.
> 
> Reported-by: Sasha Levin <levinsasha928@gmail.com>
> Deciphered-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michel Lespinasse <walken@google.com>
> Cc: Ying Han <yinghan@google.com>
> Cc: stable@vger.kernel.org

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

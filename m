Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916Ab2I1NaW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 09:30:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18476 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755977Ab2I1NaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 09:30:21 -0400
Date: Fri, 28 Sep 2012 15:30:06 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [patch for-3.6] mm, thp: fix mapped pages avoiding unevictable
 list on mlock
Message-ID: <20120928133005.GA19474@redhat.com>
References: <alpine.DEB.2.00.1209191818490.7879@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1209191818490.7879@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Wed, Sep 19, 2012 at 06:19:27PM -0700, David Rientjes wrote:
> +	if ((flags & FOLL_MLOCK) && (vma->vm_flags & VM_LOCKED)) {
> +		if (page->mapping && trylock_page(page)) {
> +			lru_add_drain();
> +			if (page->mapping)
> +				mlock_vma_page(page);
> +			unlock_page(page);
> +		}
> +	}

Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>

Without the patch the kernel will be perfectly fine too, this is is
only to show more "uptodate" values in meminfo.

The meminfo would eventually go in sync as the vmscan started walking
lrus and the old behavior will still happen when trylock
fails.

Without the patch the refiling events happen lazily as needed, now
they happen even if they're not needed.

In some ways we could drop this and also the 4k case and we'd overall
improve performance.

But transparent hugepages must behave identical to 4k pages, so unless
we remove it from the 4k case, it's certainly good to apply the above.

The patch can be deferred to 3.7 if needed.

Thanks!
Andrea

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab1KNSit (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 13:38:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588Ab1KNSis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 13:38:48 -0500
Date: Mon, 14 Nov 2011 19:38:12 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Colin Cross <ccross@android.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH] mm: avoid livelock on !__GFP_FS allocations
Message-ID: <20111114183812.GC4414@redhat.com>
References: <20111114140421.GA27150@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111114140421.GA27150@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 14, 2011 at 02:04:21PM +0000, Mel Gorman wrote:
> In his fix, he avoided retrying the allocation if reclaim made no
> progress and __GFP_FS was not set. The problem is that this would
> result in GFP_NOIO allocations failing that previously succeeded
> which would be very unfortunate.

GFP_NOFS are made by filesystems/buffers to avoid locking up on fs/vfs
locking. Those also should be able to handle failure gracefully but
userland is more likely to get a -ENOMEM from these (for example
during direct-io) if those fs allocs fails. So clearly it sounds risky
to apply the modification quoted above and risk having any GFP_NOFS
fail. Said that I'm afraid we're not deadlock safe with current code
that cannot fail but there's no easy solution and no way to fix it in
the short term, and it's only a theoretical concern.

For !__GFP_FS allocations, __GFP_NOFAIL is the default for order <=
PAGE_ALLOC_COSTLY_ORDER and __GFP_NORETRY is the default for order >
PAGE_ALLOC_COSTLY_ORDER. This inconsistency is not so clean in my
view. Also for GFP_KERNEL/USER/__GFP_FS regular allocations the
__GFP_NOFAIL looks more like a __GFP_MAY_OOM.  But if we fix that and
we drop __GFP_NORETRY, and we set __GFP_NOFAIL within the
GFP_NOFS/NOIO #defines (to remove the magic PAGE_ALLOC_COSTLY_ORDER
check in should_alloc_retry) we may loop forever if somebody allocates
several mbytes of huge contiguous RAM with GFP_NOIO. So at least
there's a practical explanation for the current code.

Patch looks good to me (and safer) even if I don't like keeping
infinite loops from a purely theoretical standpoint.

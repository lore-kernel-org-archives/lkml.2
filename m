Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab1AVPaj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 10:30:39 -0500
Received: from relay3.sgi.com ([192.48.152.1]:56403 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753439Ab1AVPai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 10:30:38 -0500
Date: Sat, 22 Jan 2011 09:30:33 -0600
From: Robin Holt <holt@sgi.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hugh@veritas.com>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: shmget limited by SHMEM_MAX_BYTES to 0x4020010000 bytes.
Message-ID: <20110122153033.GR2912@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a customer system with 12 TB of memory.  The customer is trying
to do a shmget() call with size of 4TB and it fails due to the check in
shmem_file_setup() against SHMEM_MAX_BYTES which is 0x4020010000.

I have considered a bunch of options and really do not know which
direction I should take this.

I could add a third level and fourth level with a similar 1/4 size being
the current level of indirection, and the next quarter being a next level.
That would get me closer, but not all the way there.

Given the complexity we would be introducing, I really lean towards
having a tree of tables like the page tables instead of the current
half is one level of indirection and the other half is two levels.
It adds complexity which really does not have much value that I can see.


An alternative to the current halves being different levels
of indirection, I considered reworking the info->next_index
increment/decrement to put it inside the same locking as the walk/fill
of the table.  With that, I could resize the table depth based
upon the next_index value.  For next_index from SHMEM_NR_DIRECT
to SHMEM_NR_DIRECT + ENTRIES_PER_PAGE (2MB), it could be direct.
>From there to SHMEM_NR_DIRECT + ENTRIES_PER_PAGE ** 2 (1GB), it could
be one level of indirection.  Then from there to SHMEM_NR_DIRECT +
ENTRIES_PER_PAGE ** 3 (512GB), it could be two levels of indirection.
Finally, from there to SHMEM_NR_DIRECT + ENTRIES_PER_PAGE ** 4 (256TB),
it could be three levels.  That should be enough for a little while.

I am unsure about the value of having the direct entries at the beginning.
Given they have been this way for this long, I would probably leave them
to minimize the chances for a performance impact.

Thanks,
Robin Holt

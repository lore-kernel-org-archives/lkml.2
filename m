Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab1A1O65 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 09:58:57 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:53674 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914Ab1A1O64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 09:58:56 -0500
Date: Fri, 28 Jan 2011 08:58:54 -0600
From: Robert Jennings <rcj@linux.vnet.ibm.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] [v2] zram/xvmalloc: free bit block insertion
 optimization
Message-ID: <20110128145853.GD2062@linux.vnet.ibm.com>
Mail-Followup-To: Nitin Gupta <ngupta@vflare.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Pekka Enberg <penberg@cs.helsinki.fi>, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <20110128145602.GA2062@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110128145602.GA2062@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change is in a conditional block which is entered only when there is
an existing data block on the freelist where the insert has taken place.

The new block is pushed onto the freelist stack and this conditional block
is updating links in the prior stack head to point to the new stack head.
After this conditional block the first-/second-level indices are updated
to indicate that there is a free block at this location.

This patch adds an immediate return from the conditional block to avoid
setting bits again to indicate a free block on this freelist. The bits
would already be set because there was an existing free block on this
freelist.

Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>
---
 drivers/staging/zram/xvmalloc.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/zram/xvmalloc.c b/drivers/staging/zram/xvmalloc.c
index b644067..149138a 100644
--- a/drivers/staging/zram/xvmalloc.c
+++ b/drivers/staging/zram/xvmalloc.c
@@ -200,6 +200,8 @@ static void insert_block(struct xv_pool *pool, struct page *page, u32 offset,
 		nextblock->link.prev_page = page;
 		nextblock->link.prev_offset = offset;
 		put_ptr_atomic(nextblock, KM_USER1);
+		/* If there was a next page then the free bits are set. */
+		return;
 	}
 
 	__set_bit(slindex % BITS_PER_LONG, &pool->slbitmap[flindex]);
-- 
1.7.0.4


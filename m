Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab0IFIUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 04:20:55 -0400
Received: from smtp-out.google.com ([216.239.44.51]:55779 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab0IFIUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 04:20:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=AWoSp7e52j39zeEt2ELINUwSb3kIqbPH0LrwYuDeZ2gMagkoSUoh7f9GQYA8L4D1q
	SZeX4TSTHUdU2Wy2cUXZg==
Date: Mon, 6 Sep 2010 01:21:03 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Nigel Cunningham <nigel@tuxonice.net>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] swap: discard while swapping only if SWAP_FLAG_DISCARD
In-Reply-To: <alpine.LSU.2.00.1009060104410.13600@sister.anvils>
Message-ID: <alpine.LSU.2.00.1009060117140.13600@sister.anvils>
References: <alpine.LSU.2.00.1009060104410.13600@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tests with recent firmware on Intel X25-M 80GB and OCZ Vertex 60GB SSDs
show a shift since I last tested in December: in part because of firmware
updates, in part because of the necessary move from barriers to awaiting
completion at the block layer.  While discard at swapon still shows as
slightly beneficial on both, discarding 1MB swap cluster when allocating
is now disadvanteous: adds 25% overhead on Intel, adds 230% on OCZ (YMMV).

Surrender: discard as presently implemented is more hindrance than help
for swap; but might prove useful on other devices, or with improvements.
So continue to do the discard at swapon, but make discard while swapping
conditional on a SWAP_FLAG_DISCARD to sys_swapon() (which has been using
only the lower 16 bits of int flags).

We can add a --discard or -d to swapon(8), and a "discard" to swap in
/etc/fstab: matching the mount option for btrfs, ext4, fat, gfs2, nilfs2.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Nigel Cunningham <nigel@tuxonice.net>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <jaxboe@fusionio.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: stable@kernel.org
---

 include/linux/swap.h |    3 ++-
 mm/swapfile.c        |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- swap3/include/linux/swap.h	2010-09-05 22:37:07.000000000 -0700
+++ swap4/include/linux/swap.h	2010-09-05 22:49:06.000000000 -0700
@@ -19,6 +19,7 @@ struct bio;
 #define SWAP_FLAG_PREFER	0x8000	/* set if swap priority specified */
 #define SWAP_FLAG_PRIO_MASK	0x7fff
 #define SWAP_FLAG_PRIO_SHIFT	0
+#define SWAP_FLAG_DISCARD	0x10000 /* discard swap cluster after use */
 
 static inline int current_is_kswapd(void)
 {
@@ -142,7 +143,7 @@ struct swap_extent {
 enum {
 	SWP_USED	= (1 << 0),	/* is slot in swap_info[] used? */
 	SWP_WRITEOK	= (1 << 1),	/* ok to write to this swap?	*/
-	SWP_DISCARDABLE = (1 << 2),	/* blkdev supports discard */
+	SWP_DISCARDABLE = (1 << 2),	/* swapon+blkdev support discard */
 	SWP_DISCARDING	= (1 << 3),	/* now discarding a free cluster */
 	SWP_SOLIDSTATE	= (1 << 4),	/* blkdev seeks are cheap */
 	SWP_CONTINUED	= (1 << 5),	/* swap_map has count continuation */
--- swap3/mm/swapfile.c	2010-09-05 22:47:21.000000000 -0700
+++ swap4/mm/swapfile.c	2010-09-05 22:49:06.000000000 -0700
@@ -2047,7 +2047,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 			p->flags |= SWP_SOLIDSTATE;
 			p->cluster_next = 1 + (random32() % p->highest_bit);
 		}
-		if (discard_swap(p) == 0)
+		if (discard_swap(p) == 0 && (swap_flags & SWAP_FLAG_DISCARD))
 			p->flags |= SWP_DISCARDABLE;
 	}
 

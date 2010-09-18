Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921Ab0IRTPc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:15:32 -0400
Received: from kroah.org ([198.145.64.141]:43523 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756689Ab0IRTPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:15:25 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:02 2010
Message-Id: <20100918191302.752403842@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:12:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@lst.de>,
        Nigel Cunningham <nigel@tuxonice.net>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [063/129] swap: discard while swapping only if SWAP_FLAG_DISCARD
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hugh Dickins <hughd@google.com>

commit 3399446632739fcd05fd8b272b476a69c6e6d14a upstream.

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/swap.h |    3 ++-
 mm/swapfile.c        |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/include/linux/swap.h
+++ b/include/linux/swap.h
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
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2050,7 +2050,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 			p->flags |= SWP_SOLIDSTATE;
 			p->cluster_next = 1 + (random32() % p->highest_bit);
 		}
-		if (discard_swap(p) == 0)
+		if (discard_swap(p) == 0 && (swap_flags & SWAP_FLAG_DISCARD))
 			p->flags |= SWP_DISCARDABLE;
 	}
 



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab1EDRj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 13:39:27 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:40657 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968Ab1EDRj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 13:39:26 -0400
Date: Wed, 4 May 2011 10:39:17 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Christoph Hellwig <hch@infradead.org>,
        Chris Mason <chris.mason@oracle.com>, Jeff Layton <jlayton@redhat.com>,
        Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Joel Becker <jlbec@evilplan.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Mingming Cao <mcao@us.ibm.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org
Subject: [PATCH v3 1/3] ext4: Clean up some wait_on_page_writeback calls
Message-ID: <20110504173917.GF20579@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20110321164305.GC7153@quack.suse.cz> <20110406232938.GF1110@tux1.beaverton.ibm.com> <20110407165700.GB7363@quack.suse.cz> <20110408203135.GH1110@tux1.beaverton.ibm.com> <20110411124229.47bc28f6@corrin.poochiereds.net> <1302543595-sup-4352@think> <1302569212.2580.13.camel@mingming-laptop> <20110412005719.GA23077@infradead.org> <1302742128.2586.274.camel@mingming-laptop> <20110422000226.GA22189@tux1.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110422000226.GA22189@tux1.beaverton.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wait_on_page_writeback already checks the writeback bit, so callers of it
needn't do that test.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 fs/ext4/inode.c       |    4 +---
 fs/ext4/move_extent.c |    3 +--
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f2fa5e8..3db34b2 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2796,9 +2796,7 @@ static int write_cache_pages_da(struct address_space *mapping,
 				continue;
 			}
 
-			if (PageWriteback(page))
-				wait_on_page_writeback(page);
-
+			wait_on_page_writeback(page);
 			BUG_ON(PageWriteback(page));
 
 			if (mpd->next_page != page->index)
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index d5c5783..d1548b1 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -876,8 +876,7 @@ move_extent_per_page(struct file *o_filp, struct inode *donor_inode,
 	 * It needs to call wait_on_page_writeback() to wait for the
 	 * writeback of the page.
 	 */
-	if (PageWriteback(page))
-		wait_on_page_writeback(page);
+	wait_on_page_writeback(page);
 
 	/* Release old bh and drop refs */
 	try_to_release_page(page, 0);

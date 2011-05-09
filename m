Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868Ab1EIXFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 19:05:00 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:45032 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753567Ab1EIXE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 19:04:57 -0400
Subject: [PATCH 4/7] ext4: Clean up some wait_on_page_writeback calls
To: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        "Darrick J. Wong" <djwong@us.ibm.com>
From: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jeff Layton <jlayton@redhat.com>, Dave Chinner <david@fromorbit.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
        Chris Mason <chris.mason@oracle.com>, Joel Becker <jlbec@evilplan.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, Mingming Cao <mcao@us.ibm.com>
Date: Mon, 09 May 2011 16:03:49 -0700
Message-ID: <20110509230349.19566.27020.stgit@elm3c44.beaverton.ibm.com>
In-Reply-To: <20110509230318.19566.66202.stgit@elm3c44.beaverton.ibm.com>
References: <20110509230318.19566.66202.stgit@elm3c44.beaverton.ibm.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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
index b9f3e78..2b8304b 100644
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


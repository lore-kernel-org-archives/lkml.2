Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932448Ab1EIXDk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 19:03:40 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:40861 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab1EIXDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 19:03:38 -0400
Subject: [PATCH 1/7] mm: Wait for writeback when grabbing pages to begin a
	write
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
Date: Mon, 09 May 2011 16:03:26 -0700
Message-ID: <20110509230326.19566.16027.stgit@elm3c44.beaverton.ibm.com>
In-Reply-To: <20110509230318.19566.66202.stgit@elm3c44.beaverton.ibm.com>
References: <20110509230318.19566.66202.stgit@elm3c44.beaverton.ibm.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When grabbing a page for a buffered IO write, the mm should wait for writeback
on the page to complete so that the page does not become writable during the IO
operation.  This change is needed to provide page stability during writes for
all filesystems.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 mm/filemap.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)


diff --git a/mm/filemap.c b/mm/filemap.c
index c641edf..fd0e7f2 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2288,7 +2288,7 @@ struct page *grab_cache_page_write_begin(struct address_space *mapping,
 repeat:
 	page = find_lock_page(mapping, index);
 	if (page)
-		return page;
+		goto found;
 
 	page = __page_cache_alloc(mapping_gfp_mask(mapping) & ~gfp_notmask);
 	if (!page)
@@ -2301,6 +2301,8 @@ repeat:
 			goto repeat;
 		return NULL;
 	}
+found:
+	wait_on_page_writeback(page);
 	return page;
 }
 EXPORT_SYMBOL(grab_cache_page_write_begin);


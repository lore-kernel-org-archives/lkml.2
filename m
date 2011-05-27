Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab1E0TXv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 15:23:51 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:46699 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755990Ab1E0TXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 15:23:46 -0400
Subject: [PATCH 1/2] mm: Wait for writeback when grabbing pages to begin a
	write
To: Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J. Wong" <djwong@us.ibm.com>
From: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Jens Axboe <axboe@kernel.dk>, Theodore Tso <tytso@mit.edu>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jeff Layton <jlayton@redhat.com>, Dave Chinner <david@fromorbit.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        Chris Mason <chris.mason@oracle.com>, Joel Becker <jlbec@evilplan.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        linux-ext4@vger.kernel.org, Mingming Cao <mcao@us.ibm.com>
Date: Fri, 27 May 2011 12:23:34 -0700
Message-ID: <20110527192334.32105.99904.stgit@elm3c44.beaverton.ibm.com>
In-Reply-To: <20110527192326.32105.34164.stgit@elm3c44.beaverton.ibm.com>
References: <20110527192326.32105.34164.stgit@elm3c44.beaverton.ibm.com>
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
index bcdc393..dac95a2 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2327,7 +2327,7 @@ struct page *grab_cache_page_write_begin(struct address_space *mapping,
 repeat:
 	page = find_lock_page(mapping, index);
 	if (page)
-		return page;
+		goto found;
 
 	page = __page_cache_alloc(mapping_gfp_mask(mapping) & ~gfp_notmask);
 	if (!page)
@@ -2340,6 +2340,8 @@ repeat:
 			goto repeat;
 		return NULL;
 	}
+found:
+	wait_on_page_writeback(page);
 	return page;
 }
 EXPORT_SYMBOL(grab_cache_page_write_begin);


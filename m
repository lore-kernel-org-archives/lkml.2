Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab0F1RiW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 13:38:22 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:45342 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab0F1RiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 13:38:20 -0400
Date: Mon, 28 Jun 2010 10:35:29 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com,
       Tao Ma <tao.ma@oracle.com>, Dave Chinner <dchinner@redhat.com>,
       Christoph Hellwig <hch@lst.de>, Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH] Revert "writeback: limit write_cache_pages integrity
 scanning to current EOF"
Message-ID: <20100628173529.GA10573@mail.oracle.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	ocfs2-devel@oss.oracle.com, Tao Ma <tao.ma@oracle.com>,
	Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
	Mark Fasheh <mfasheh@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4C28DDCE.00EC:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit d87815cb2090e07b0b0b2d73dc9740706e92c80c.

This patch causes any filesystem with an allocation unit larger than the
filesystem blocksize will leak unzeroed data.  During a file extend, the
entire allocation unit is zeroed.  However, this patch prevents the tail
blocks of the allocation unit from being written back to disk.  When the
file is next extended, i_size will now cover these unzeroed blocks,
leaking the old contents of the disk to userspace and creating a corrupt
file.

This affects ocfs2 directly.  As Tao Ma mentioned in his reporting
email:

1. all the place we use filemap_fdatawrite in ocfs2 doesn't flush pages
after i_size now.
2. sync, fsync, fdatasync and umount don't flush pages after i_size(they
are called from writeback_single_inode).
3. reflink have a BUG_ON triggered because we have some dirty pages
while during CoW. http://oss.oracle.com/bugzilla/show_bug.cgi?id=1265

Because this patch breaks ocfs2 file extends, we need to request its
reversion.

Reported-by: Tao Ma <tao.ma@oracle.com>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 mm/page-writeback.c |   15 ---------------
 1 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index bbd396a..b3dbb80 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -851,22 +851,7 @@ int write_cache_pages(struct address_space *mapping,
 		if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
 			range_whole = 1;
 		cycled = 1; /* ignore range_cyclic tests */
-
-		/*
-		 * If this is a data integrity sync, cap the writeback to the
-		 * current end of file. Any extension to the file that occurs
-		 * after this is a new write and we don't need to write those
-		 * pages out to fulfil our data integrity requirements. If we
-		 * try to write them out, we can get stuck in this scan until
-		 * the concurrent writer stops adding dirty pages and extending
-		 * EOF.
-		 */
-		if (wbc->sync_mode == WB_SYNC_ALL &&
-		    wbc->range_end == LLONG_MAX) {
-			end = i_size_read(mapping->host) >> PAGE_CACHE_SHIFT;
-		}
 	}
-
 retry:
 	done_index = index;
 	while (!done && (index <= end)) {
-- 
1.7.1


-- 

"Senator let's be sincere,
 As much as you can."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127

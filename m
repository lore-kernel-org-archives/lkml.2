Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960Ab0IRTPi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:15:38 -0400
Received: from kroah.org ([198.145.64.141]:43584 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756731Ab0IRTPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:15:35 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:03 2010
Message-Id: <20100918191303.615263035@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:12:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jeff Moyer <jmoyer@redhat.com>, Josef Bacik <jbacik@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Chris Mason <chris.mason@oracle.com>
Subject: [073/129] O_DIRECT: fix the splitting up of contiguous I/O
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Moyer <jmoyer@redhat.com>

commit 7a801ac6f5067539ceb5fad0fe90ec49fc156e47 upstream.

commit c2c6ca4 (direct-io: do not merge logically non-contiguous requests)
introduced a bug whereby all O_DIRECT I/Os were submitted a page at a time
to the block layer.  The problem is that the code expected
dio->block_in_file to correspond to the current page in the dio.  In fact,
it corresponds to the previous page submitted via submit_page_section.
This was purely an oversight, as the dio->cur_page_fs_offset field was
introduced for just this purpose.  This patch simply uses the correct
variable when calculating whether there is a mismatch between contiguous
logical blocks and contiguous physical blocks (as described in the
comments).

I also switched the if conditional following this check to an else if, to
ensure that we never call dio_bio_submit twice for the same dio (in
theory, this should not happen, anyway).

I've tested this by running blktrace and verifying that a 64KB I/O was
submitted as a single I/O.  I also ran the patched kernel through
xfstests' aio tests using xfs, ext4 (with 1k and 4k block sizes) and btrfs
and verified that there were no regressions as compared to an unpatched
kernel.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Acked-by: Josef Bacik <jbacik@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/direct-io.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -634,7 +634,7 @@ static int dio_send_cur_page(struct dio
 	int ret = 0;
 
 	if (dio->bio) {
-		loff_t cur_offset = dio->block_in_file << dio->blkbits;
+		loff_t cur_offset = dio->cur_page_fs_offset;
 		loff_t bio_next_offset = dio->logical_offset_in_bio +
 			dio->bio->bi_size;
 
@@ -659,7 +659,7 @@ static int dio_send_cur_page(struct dio
 		 * Submit now if the underlying fs is about to perform a
 		 * metadata read
 		 */
-		if (dio->boundary)
+		else if (dio->boundary)
 			dio_bio_submit(dio);
 	}
 



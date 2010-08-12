Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760607Ab0HLUvM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 16:51:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753970Ab0HLUvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 16:51:11 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Andrew Morton <akpm@linuxfoundation.org>
Cc: Josef Bacik <josef@redhat.com>, linux-kernel@vger.kernel.org,
        btrfs-devel <btrfs-devel@oss.oracle.com>
Subject: [patch] O_DIRECT: fix the splitting up of contiguous I/O
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 12 Aug 2010 16:50:59 -0400
Message-ID: <x49vd7f368c.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

commit c2c6ca4 (direct-io: do not merge logically non-contiguous
requests) introduced a bug whereby all O_DIRECT I/Os were submitted a
page at a time to the block layer.  The problem is that the code
expected dio->block_in_file to correspond to the current page in the
dio.  In fact, it corresponds to the previous page submitted via
submit_page_section.  This was purely an oversight, as the
dio->cur_page_fs_offset field was introduced for just this purpose.
This patch simply uses the correct variable when calculating whether
there is a mismatch between contiguous logical blocks and contiguous
physical blocks (as described in the comments).

I also switched the if conditional following this check to an else if,
to ensure that we never call dio_bio_submit twice for the same dio (in
theory, this should not happen, anyway).

I've tested this by running blktrace and verifying that a 64KB I/O was
submitted as a single I/O.  I also ran the patched kernel through
xfstests' aio tests using xfs, ext4 (with 1k and 4k block sizes) and
btrfs and verified that there were no regressions as compared to an
unpatched kernel.

Comments, as always, are welcome.

Cheers,
Jeff

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Acked-by: Josef Bacik <jbacik@redhat.com>

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 7600aac..445901c 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -632,7 +632,7 @@ static int dio_send_cur_page(struct dio *dio)
 	int ret = 0;
 
 	if (dio->bio) {
-		loff_t cur_offset = dio->block_in_file << dio->blkbits;
+		loff_t cur_offset = dio->cur_page_fs_offset;
 		loff_t bio_next_offset = dio->logical_offset_in_bio +
 			dio->bio->bi_size;
 
@@ -657,7 +657,7 @@ static int dio_send_cur_page(struct dio *dio)
 		 * Submit now if the underlying fs is about to perform a
 		 * metadata read
 		 */
-		if (dio->boundary)
+		else if (dio->boundary)
 			dio_bio_submit(dio);
 	}
 


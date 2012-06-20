Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042Ab2FTSBm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:01:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13778 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756284Ab2FTSBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:01:39 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, torsten.hilbrich@secunet.com,
        Nick Piggin <npiggin@kernel.dk>
Subject: [patch] block: fix off-by-one in init_page_buffers
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 20 Jun 2012 14:01:28 -0400
Message-ID: <x49txy5yi9z.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This commit:

commit 080399aaaf3531f5b8761ec0ac30ff98891e8686
Author: Jeff Moyer <jmoyer@redhat.com>
Date:   Fri May 11 16:34:10 2012 +0200

    block: don't mark buffers beyond end of disk as mapped

introduced a bug whereby the last block on the device was treated as
beyond the end of the device.  This causes the mount program to hang
when trying to (erroneously) mount an extended partition, as reported by
Torsten Hilbrich here: https://lkml.org/lkml/2012/6/18/54, and also
reported independently here:
http://www.sysresccd.org/forums/viewtopic.php?f=13&t=4511.

The attached patch was tested by myself and Torsten and found to resolve
the problem.  I also instrumented the init_page_buffers routine to
ensure that the end_block is indeed the last block of the device.

Comments, as always, are appreciated.

--

This needs backporting to the stable trees where the offending commit
was backported.  I'm sure that includes 3.0 and 3.3, but not sure where
else it was committed.  Is there an easy way to tell what trees got the
commit?

CC: stable@vger.kernel.org, npiggin@kernel.dk
Reported-and-Tested-by: Torsten Hilbrich <torsten.hilbrich@secunet.com>
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

diff --git a/fs/buffer.c b/fs/buffer.c
index 838a9cf..769b30b 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -930,7 +930,7 @@ init_page_buffers(struct page *page, struct block_device *bdev,
 			bh->b_blocknr = block;
 			if (uptodate)
 				set_buffer_uptodate(bh);
-			if (block < end_block)
+			if (block <= end_block)
 				set_buffer_mapped(bh);
 		}
 		block++;

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933088Ab0G3SIJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:08:09 -0400
Received: from kroah.org ([198.145.64.141]:59221 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932795Ab0G3R5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:57:44 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:50 2010
Message-Id: <20100730175150.541705685@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:53:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tao Ma <tao.ma@oracle.com>, Jens Axboe <jaxboe@fusionio.com>
Subject: [183/205] block: Dont count_vm_events for discard bio in submit_bio.
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tao Ma <tao.ma@oracle.com>

commit 1b99973f1c82707e46e8cb9416865a1e955e8f8c upstream.

In submit_bio, we count vm events by check READ/WRITE.
But actually DISCARD_NOBARRIER also has the WRITE flag set.
It looks as if in blkdev_issue_discard, we also add a
page as the payload and the bio_has_data check isn't enough.
So add another check for discard bio.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 block/blk-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1556,7 +1556,7 @@ void submit_bio(int rw, struct bio *bio)
 	 * If it's a regular read/write or a barrier with data attached,
 	 * go through the normal accounting stuff before submission.
 	 */
-	if (bio_has_data(bio)) {
+	if (bio_has_data(bio) && !(rw & (1 << BIO_RW_DISCARD))) {
 		if (rw & WRITE) {
 			count_vm_events(PGPGOUT, count);
 		} else {



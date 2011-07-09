Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940Ab1GICwB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 22:52:01 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44517 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab1GICwA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 22:52:00 -0400
MIME-Version: 1.0
Date: Fri, 8 Jul 2011 19:51:59 -0700
Message-ID: <CAFR8uee7XwO0bKcUrGY1N328CwRQAs4Qak1oXUjZdYoeUEhAtA@mail.gmail.com>
Subject: [PATCH] block: Initialize bi_rw in mpage so bio_add can make use of it.
From: Muthu Kumar <muthu.lkml@gmail.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens et al,

do_mpage_readpage()/__mpage_writepage(): When they allocate a new bio,
bi_rw is not initialized. So later when they call __bio_add_page(),
struct bvec_merge_data bvm's .bi_rw will not be initialized with right
direction.
It will be useful for some merge functions if they know the direction
of transfer.

Let me know if this looks good. There are few more places like this
(e.g blkdev_issue_zeroout()). Would it make sense to send patch for
these cases also?

Signed-off-by: Muthukumar R <muthu.lkml@gmail.com>

--------
fs/mpage.c |    2 ++
1 files changed, 2 insertions(+), 0 deletions(-)
diff --git a/fs/mpage.c b/fs/mpage.c
index fdfae9f..c8e0f8a 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -293,6 +293,7 @@ alloc_new:
                       goto confused;
       }

+    bio->bi_rw = READ;
       length = first_hole << blkbits;
       if (bio_add_page(bio, page, length, 0) < length) {
               bio = mpage_bio_submit(READ, bio);
@@ -590,6 +591,7 @@ alloc_new:
        * the confused fail path above (OOM) will be very confused when
        * it finds all bh marked clean (i.e. it will not write anything)
        */
+    bio->bi_rw = WRITE;
       length = first_unmapped << blkbits;
       if (bio_add_page(bio, page, length, 0) < length) {
               bio = mpage_bio_submit(WRITE, bio);

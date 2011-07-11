Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270Ab1GKRbs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 13:31:48 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:52134 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758241Ab1GKRbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 13:31:47 -0400
MIME-Version: 1.0
Date: Mon, 11 Jul 2011 10:31:46 -0700
Message-ID: <CAFR8uec5MxvHEWS=hgRXo1eunjQqWrpPCVXthdGMfWR+Yitw_A@mail.gmail.com>
Subject: [PATCH]: block: try-2 (modified): Initialize bi_rw in mpage so
 bio_add can make use of it.
From: Muthu Kumar <muthu.lkml@gmail.com>
To: jaxboe <jaxboe@fusionio.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
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

Signed-off-by: Muthukumar R <muthur@gmail.com>

------------------------
 fs/mpage.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)
------------------------
diff --git a/fs/mpage.c b/fs/mpage.c
index fdfae9f..efabfc0 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -291,6 +291,7 @@ alloc_new:
                                GFP_KERNEL);
                if (bio == NULL)
                        goto confused;
+                bio->bi_rw = READ;
        }

        length = first_hole << blkbits;
@@ -583,6 +584,7 @@ alloc_new:
                                bio_get_nr_vecs(bdev), GFP_NOFS|__GFP_HIGH);
                if (bio == NULL)
                        goto confused;
+                bio->bi_rw = WRITE;
        }

        /*

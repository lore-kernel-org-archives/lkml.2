Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872Ab0LBQVJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 11:21:09 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:54339 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757663Ab0LBQVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 11:21:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Sg4Bz06Sfs3i+MtWdMgNr+UmhOuPkYEA5oldtlax4qx/bmB8wq6q5M+kiXNblhZgDq
         CMF+3bvW/sBRZIsI/ho3I9p9Nr7aHSgHM84ZgINbUXWgaHW3Y1UxNxjtmoiVCHGiHRTp
         1Hvzhd5SuPQ6XNQFRKyy5NdztXUeMCVB07gE4=
From: Sankar P <sankar.curiosity@gmail.com>
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Sankar P <sankar.curiosity@gmail.com>
Subject: [PATCH] fs: btrfs: Shuffle preprocessor macros
Date: Thu,  2 Dec 2010 21:49:39 +0530
Message-Id: <1291306779-16186-1-git-send-email-sankar.curiosity@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function btree_migratepage will be extended from the baseclass
only when CONFIG_MIGRATION option is enabled. So, it's useful to
define/build this function only when that config option is enabled.

Fixes an "unused function"  compiler warning when CONFIG_MIGRATION
is not enabled and also removes an return -ENOSYS statement,
whose scenario will not happen.

Signed-off-by: Sankar P <sankar.curiosity@gmail.com>
---
 fs/btrfs/disk-io.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index c547cca..7199239 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -696,6 +696,7 @@ static int btree_submit_bio_hook(struct inode *inode, int rw, struct bio *bio,
 				   __btree_submit_bio_done);
 }
 
+#ifdef CONFIG_MIGRATION
 static int btree_migratepage(struct address_space *mapping,
 			struct page *newpage, struct page *page)
 {
@@ -712,12 +713,9 @@ static int btree_migratepage(struct address_space *mapping,
 	if (page_has_private(page) &&
 	    !try_to_release_page(page, GFP_KERNEL))
 		return -EAGAIN;
-#ifdef CONFIG_MIGRATION
 	return migrate_page(mapping, newpage, page);
-#else
-	return -ENOSYS;
-#endif
 }
+#endif
 
 static int btree_writepage(struct page *page, struct writeback_control *wbc)
 {
-- 
1.7.1


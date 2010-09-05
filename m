Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab0IESce (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 14:32:34 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46186 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673Ab0IEScc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 14:32:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=WjRp1pJLuXvRCbblEMGcNiFm1bQKWFvtPYYEAnpj0tvUYPnc1+LBtSGPn7Dbm5Xi+P
         CxmVuKGT54UEMTBfsb9+YH7PlsHFBgbEvXnv+6ElWfsswr2sFtDonOOKNfzr1QdByoMO
         otmRXbHY6rwMkNJuD5loc0ueA35mko4H5jidk=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Vasiliy Kulikov <segooon@gmail.com>, Neil Brown <neilb@suse.de>,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 03/14] md: check return code of read_sb_page
Date: Sun,  5 Sep 2010 22:32:25 +0400
Message-Id: <1283711546-7205-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasiliy Kulikov <segooon@gmail.com>

Function read_sb_page may return ERR_PTR(...). Check for it.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Compile tested.

 drivers/md/bitmap.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index ed4900a..33531da 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -936,6 +936,7 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 	int outofdate;
 	int ret = -ENOSPC;
 	void *paddr;
+	struct page *p;
 
 	chunks = bitmap->chunks;
 	file = bitmap->file;
@@ -999,11 +1000,16 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 				 */
 				page = bitmap->sb_page;
 				offset = sizeof(bitmap_super_t);
-				if (!file)
-					read_sb_page(bitmap->mddev,
+				if (!file) {
+					p = read_sb_page(bitmap->mddev,
 						     bitmap->mddev->bitmap_info.offset,
 						     page,
 						     index, count);
+					if (IS_ERR(p)) {
+						ret = PTR_ERR(p);
+						goto err;
+					}
+				}
 			} else if (file) {
 				page = read_page(file, index, bitmap, count);
 				offset = 0;
-- 
1.7.0.4


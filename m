Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab0GLPI5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 11:08:57 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42534 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997Ab0GLPIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 11:08:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        b=tJh++l/ECMAoy8HGiUtdWecSyLX+zCqdMMFP6zRJbfpD0O0N3ThFFwuTcxTb0mT3CK
         uwhBbQ+xZouR+T+xXhv1dtF+TRXS1JaXYSd38AqRhGO2DB0Y3Lqah541Gko36ZDfFSTa
         kcGtgR60S+FlPOKhGeN2dvshVK/se4l0Fi1qY=
Date: Mon, 12 Jul 2010 23:09:09 +0800
From: "crosslonelyover" <crosslonelyover@gmail.com>
To: "linux-ext4" <linux-ext4@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "kernel-janitors" <kernel-janitors@vger.kernel.org>
Subject: [PATCH] remove unnecesary while loop in ext2_xattr_get
Message-ID: <201007122309063128435@gmail.com>
X-mailer: Foxmail 6, 15, 201, 22 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
     In ext2_xattr_get, we'll check the xattr entry one 
by one in the following loop:
         entry = FIRST_ENTRY(bh);
         while (!IS_LAST_ENTRY(entry)) {
                 struct ext2_xattr_entry *next =
                         EXT2_XATTR_NEXT(entry);
                 if ((char *)next >= end)
                         goto bad_block;
                 if (name_index == entry->e_name_index &&
                     name_len == entry->e_name_len &&
                     memcmp(name, entry->e_name, name_len) == 0)
                         goto found;
                 entry = next;
         }
We can only execute the code immediately following 
the loop when !IS_LAST_ENTRY(entry) is true. So the
followed while loop seems unnecessary. I think we can
remove it.
      Following is my patch. It's against 2.6.35-rc4.
Please check it.


Signed-off-by: Wang Sheng-Hui <crosslonelyover@gmail.com>
---
 fs/ext2/xattr.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index 0b94d61..a6bccdb 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -201,14 +201,7 @@ bad_block:	ext2_error(inode->i_sb, "ext2_xattr_get",
 			goto found;
 		entry = next;
 	}
-	/* Check the remaining name entries */
-	while (!IS_LAST_ENTRY(entry)) {
-		struct ext2_xattr_entry *next =
-			EXT2_XATTR_NEXT(entry);
-		if ((char *)next >= end)
-			goto bad_block;
-		entry = next;
-	}
+
 	if (ext2_xattr_cache_insert(bh))
 		ea_idebug(inode, "cache insert failed");
 	error = -ENODATA;
-- 
1.7.1.1



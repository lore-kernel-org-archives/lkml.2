Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418Ab2GWQju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 12:39:50 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:49704 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754364Ab2GWQjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 12:39:49 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: lkml <linux-kernel@vger.kernel.org>
CC: Jan Kara <jack@suze.cz>, Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH] udf: fix udf_setsize() for file data in ICB
Date: Mon, 23 Jul 2012 17:39:29 +0100
Message-ID: <1343061569-3629-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 1.7.8.6
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the new size is larger than the old size and the old file data was
stored in the ICB (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) and the
new size still fits in the ICB, skip the call to udf_extend_file() as it
does not handle this i_alloc_type value (it calls BUG()).

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 fs/udf/inode.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index fafaad7..15fb17e 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1124,14 +1124,17 @@ int udf_setsize(struct inode *inode, loff_t newsize)
 				if (err)
 					return err;
 				down_write(&iinfo->i_data_sem);
-			} else
+			} else {
 				iinfo->i_lenAlloc = newsize;
+				goto extended_ad_in_icb;
+			}
 		}
 		err = udf_extend_file(inode, newsize);
 		if (err) {
 			up_write(&iinfo->i_data_sem);
 			return err;
 		}
+extended_ad_in_icb:
 		truncate_setsize(inode, newsize);
 		up_write(&iinfo->i_data_sem);
 	} else {
-- 
1.7.8.6


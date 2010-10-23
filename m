Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230Ab0JWLiK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 07:38:10 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40536 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502Ab0JWLiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 07:38:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=XEgCCSTTHnuc553Oh52pIzJqwmK2/itI/Fgt9QkHLHrrIOqwrp8rzn4w+D6qlxCfEh
         MJeOG74ie9rANmvDJ3cXZdo5y8uFear6QttzUmnGHekkB0iUVpFGen/2Qrw2TGl2aWaT
         oF1hberdZ3Kt/GKPsyQ8hBon4CynP5RXC1Pic=
From: Alessio Igor Bogani <abogani@texware.it>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tim Bird <tim.bird@am.sony.com>, LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH 4/6] udf: Replace BKL
Date: Sat, 23 Oct 2010 13:37:31 +0200
Message-Id: <1287833853-4175-4-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1287833853-4175-1-git-send-email-abogani@texware.it>
References: <1287833853-4175-1-git-send-email-abogani@texware.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace BKL with i_mutex in udf_symlink_filler function.

This work was supported by a hardware donation from the CE Linux Forum.

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 fs/udf/symlink.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/udf/symlink.c b/fs/udf/symlink.c
index 1606478..cdf4492 100644
--- a/fs/udf/symlink.c
+++ b/fs/udf/symlink.c
@@ -27,7 +27,7 @@
 #include <linux/mm.h>
 #include <linux/stat.h>
 #include <linux/pagemap.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/buffer_head.h>
 #include "udf_i.h"
 
@@ -79,8 +79,8 @@ static int udf_symlink_filler(struct file *file, struct page *page)
 	unsigned char *p = kmap(page);
 	struct udf_inode_info *iinfo;
 
-	lock_kernel();
 	iinfo = UDF_I(inode);
+	mutex_lock(&inode->i_mutex);
 	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
 		symlink = iinfo->i_ext.i_data + iinfo->i_lenEAttr;
 	} else {
@@ -95,14 +95,14 @@ static int udf_symlink_filler(struct file *file, struct page *page)
 	udf_pc_to_char(inode->i_sb, symlink, inode->i_size, p);
 	brelse(bh);
 
-	unlock_kernel();
+	mutex_unlock(&inode->i_mutex);
 	SetPageUptodate(page);
 	kunmap(page);
 	unlock_page(page);
 	return 0;
 
 out:
-	unlock_kernel();
+	mutex_unlock(&inode->i_mutex);
 	SetPageError(page);
 	kunmap(page);
 	unlock_page(page);
-- 
1.7.0.4


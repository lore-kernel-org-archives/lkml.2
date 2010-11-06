Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083Ab0KFOmX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 10:42:23 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:64795 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516Ab0KFOl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 10:41:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=VPDlFSeQ/hPSQn2UfbyFSaVa0DnIwpljDUHPz68jyFQ6yekCGjnanfibrKkyFz5qG0
         m+hFt5/S8JqfcIohibYZMVmqngb6Jj5HkC6HkBYD7LZ4avp/Beubk/b8KC9SsDBX1VYg
         NwLNykMdgcYfWSPD2TBmjPsyxMfQvAQSeqgdo=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mtd: mtdchar: fix information leak to userland
Date: Sat,  6 Nov 2010 17:41:24 +0300
Message-Id: <1289054485-18190-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Structure mtd_info_user is copied to userland with padding byted
between "type" and "flags" fields uninitialized.  It leads to leaking
of contents of kernel stack memory.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Compile tested.

 drivers/mtd/mtdchar.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index 3eff1e5..2a0bc9e 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -601,6 +601,7 @@ static int mtd_ioctl(struct file *file, u_int cmd, u_long arg)
 	}
 
 	case MEMGETINFO:
+		memset(&info, 0, sizeof(info));
 		info.type	= mtd->type;
 		info.flags	= mtd->flags;
 		info.size	= mtd->size;
@@ -609,7 +610,6 @@ static int mtd_ioctl(struct file *file, u_int cmd, u_long arg)
 		info.oobsize	= mtd->oobsize;
 		/* The below fields are obsolete */
 		info.ecctype	= -1;
-		info.eccsize	= 0;
 		if (copy_to_user(argp, &info, sizeof(struct mtd_info_user)))
 			return -EFAULT;
 		break;
-- 
1.7.0.4


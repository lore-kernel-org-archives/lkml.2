Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706Ab0J0Pk5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 11:40:57 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64860 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756187Ab0J0Pkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 11:40:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=thLzhVm9WXOllU9ssgxBosBTbLpAvQoxPGIWag/lg7HjN4lseA6deJcbEsbN2v43ZA
         nPsutGR2KI47Isn2wMk4N1zOBYFyMh8fRmchxEYtphkVaOtzobjG0EKr4moq273NOaZa
         /7aGs9Y9QJxT3hI7TQyn+pRcKwyQcbwYPag9I=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Mike Miller <mike.miller@hp.com>, Jens Axboe <jaxboe@fusionio.com>,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        Andrew Morton <akpm@linux-foundation.org>, iss_storagedev@hp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] block: cciss: fix information leak to userland
Date: Wed, 27 Oct 2010 19:40:48 +0400
Message-Id: <1288194048-9233-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Structure IOCTL_Command_struct is copied to userland with
some padding fields at the end of the struct unitialized.
It leads to leaking of contents of kernel stack memory.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Compile tested.

 drivers/block/cciss.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index f09e6df..13d87a0 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1184,6 +1184,7 @@ static int cciss_ioctl32_big_passthru(struct block_device *bdev, fmode_t mode,
 	int err;
 	u32 cp;
 
+	memset(&arg64, 0, sizeof(arg64));
 	err = 0;
 	err |=
 	    copy_from_user(&arg64.LUN_info, &arg32->LUN_info,
-- 
1.7.0.4


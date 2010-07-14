Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080Ab0GNRyY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 13:54:24 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:36788 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692Ab0GNRyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 13:54:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=gBiEVzwYiJSj8P+SnUKipBhweUYViyRBWI/sNdeo5uXMT9qRuu4cthqC+ohkIgcUNs
         OybB9Fjd62re6gSk8GufdkWXwup/qLznwxCD+7RFwq/f0s8bcb/Y9opjEdXooYwjT49J
         xMyAGT5BW6B55S/Th26g8RCJHkDaViRQzBxYU=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Julia Lawall <julia@diku.dk>, Frederic Weisbecker <fweisbec@gmail.com>,
        John Kacur <jkacur@redhat.com>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: dpt_i2o: fix memory leak
Date: Wed, 14 Jul 2010 21:53:27 +0400
Message-Id: <1279130008-9934-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Free allocated memory if adpt_ioctl_to_context() failed.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/scsi/dpt_i2o.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index f2d4df1..dd9a43b 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -1839,8 +1839,10 @@ static int adpt_i2o_passthru(adpt_hba* pHba, u32 __user *arg)
 	sg_offset = (msg[0]>>4)&0xf;
 	msg[2] = 0x40000000; // IOCTL context
 	msg[3] = adpt_ioctl_to_context(pHba, reply);
-	if (msg[3] == (u32)-1)
+	if (msg[3] == (u32)-1) {
+		kfree(reply);
 		return -EBUSY;
+	}
 
 	memset(sg_list,0, sizeof(sg_list[0])*pHba->sg_tablesize);
 	if(sg_offset) {
-- 
1.7.0.4


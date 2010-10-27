Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759366Ab0J0PlE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 11:41:04 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64860 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756815Ab0J0Pk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 11:40:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=e7UghnqOOkxMOr0roeNNJQM46PsEtaOyJc5JIV8T5Um1YlTBpHGWbCXc4rpNHUum12
         uibRoY0WloNsoG0D0oD/n+s1wqOBxivbfPcZF0WL4F6ZJgZ28EMopFLiCxhpAj4WEDQX
         lVhsot5YGoGi3HVFMJWRBZvL3mMO52veXSD7w=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Mike Miller <mike.miller@hp.com>, iss_storagedev@hp.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: hpsa: fix information leak to userland
Date: Wed, 27 Oct 2010 19:40:54 +0400
Message-Id: <1288194054-9276-1-git-send-email-segooon@gmail.com>
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

 drivers/scsi/hpsa.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index c5d0606..641a38c 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2298,6 +2298,7 @@ static int hpsa_ioctl32_passthru(struct scsi_device *dev, int cmd, void *arg)
 	int err;
 	u32 cp;
 
+	memset(&arg64, 0, sizeof(arg64));
 	err = 0;
 	err |= copy_from_user(&arg64.LUN_info, &arg32->LUN_info,
 			   sizeof(arg64.LUN_info));
@@ -2334,6 +2335,7 @@ static int hpsa_ioctl32_big_passthru(struct scsi_device *dev,
 	int err;
 	u32 cp;
 
+	memset(&arg64, 0, sizeof(arg64));
 	err = 0;
 	err |= copy_from_user(&arg64.LUN_info, &arg32->LUN_info,
 			   sizeof(arg64.LUN_info));
-- 
1.7.0.4


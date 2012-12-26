Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab2LZUbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 15:31:55 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:44907 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab2LZUbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 15:31:53 -0500
Date: Wed, 26 Dec 2012 21:31:51 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: "James E.J. Bottomley" <JBottomley@parallels.com>
cc: Naresh Kumar Inna <naresh@chelsio.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [SCSI] csiostor: Don't leak mem or fail to release firmware
 in csio_hw_flash_config()
Message-ID: <alpine.LNX.2.00.1212262129490.23814@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If kzalloc() or csio_hw_check_fwconfig() fail we may leave the
csio_hw_flash_config() function without freeing allocated memory or
firmware. This should take care of the leaks.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/scsi/csiostor/csio_hw.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

 Note: I'm unable to really test this, so the patch is compile tested
       only.

diff --git a/drivers/scsi/csiostor/csio_hw.c b/drivers/scsi/csiostor/csio_hw.c
index 8ecdb94..bdd78fb 100644
--- a/drivers/scsi/csiostor/csio_hw.c
+++ b/drivers/scsi/csiostor/csio_hw.c
@@ -2131,13 +2131,16 @@ csio_hw_flash_config(struct csio_hw *hw, u32 *fw_cfg_param, char *path)
 		value_to_add = 4 - (cf->size % 4);
 
 	cfg_data = kzalloc(cf->size+value_to_add, GFP_KERNEL);
-	if (cfg_data == NULL)
-		return -ENOMEM;
+	if (cfg_data == NULL) {
+		ret = -ENOMEM;
+		goto leave;
+	}
 
 	memcpy((void *)cfg_data, (const void *)cf->data, cf->size);
-
-	if (csio_hw_check_fwconfig(hw, fw_cfg_param) != 0)
-		return -EINVAL;
+	if (csio_hw_check_fwconfig(hw, fw_cfg_param) != 0) {
+		ret = -EINVAL;
+		goto leave;
+	}
 
 	mtype = FW_PARAMS_PARAM_Y_GET(*fw_cfg_param);
 	maddr = FW_PARAMS_PARAM_Z_GET(*fw_cfg_param) << 16;
@@ -2149,9 +2152,9 @@ csio_hw_flash_config(struct csio_hw *hw, u32 *fw_cfg_param, char *path)
 		strncpy(path, "/lib/firmware/" CSIO_CF_FNAME, 64);
 	}
 
+leave:
 	kfree(cfg_data);
 	release_firmware(cf);
-
 	return ret;
 }
 
-- 
1.7.1


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.


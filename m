Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965783Ab2EPIZ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 04:25:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:13338 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933174Ab2EPIZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 04:25:55 -0400
X-IronPort-AV: E=Sophos;i="4.75,602,1330876800"; 
   d="scan'208";a="4968081"
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
To: debora@linux.vnet.ibm.com, srajiv@linux.vnet.ibm.com
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PATCH] tpm: fix memleak when register hardware fails
Date: Wed, 16 May 2012 16:24:28 +0800
Message-Id: <1337156668-19462-1-git-send-email-gaowanlong@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/05/16 16:24:39,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/05/16 16:24:41,
	Serialize complete at 2012/05/16 16:24:41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 drivers/char/tpm/tpm.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index ad7c732..c967919 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -1405,15 +1405,12 @@ struct tpm_chip *tpm_register_hardware(struct device *dev,
 			"unable to misc_register %s, minor %d\n",
 			chip->vendor.miscdev.name,
 			chip->vendor.miscdev.minor);
-		put_device(chip->dev);
-		return NULL;
+		goto put_device;
 	}
 
 	if (sysfs_create_group(&dev->kobj, chip->vendor.attr_group)) {
 		misc_deregister(&chip->vendor.miscdev);
-		put_device(chip->dev);
-
-		return NULL;
+		goto put_device;
 	}
 
 	chip->bios_dir = tpm_bios_log_setup(devname);
@@ -1425,6 +1422,8 @@ struct tpm_chip *tpm_register_hardware(struct device *dev,
 
 	return chip;
 
+put_device:
+	put_device(chip->dev);
 out_free:
 	kfree(chip);
 	kfree(devname);
-- 
1.7.10


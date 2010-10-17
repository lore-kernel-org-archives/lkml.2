Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207Ab0JQOwC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 10:52:02 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34172 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932211Ab0JQOv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 10:51:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=VjEXROiePDcNBWsIpeFdRAxdHwz1g4DhJCUfE9Q6b3hUw7zjkxPEGKz8+JKmAZhnNL
         mNsnFfuQ7YXTF/aZT5UN1Iy/+gJagv4LkLzMDc44pxhnisw6xxBztOs1GpZ2PIyZgIpC
         Q27bt5GO3BssaZ76034cf85lOHEPcC42xdGcg=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, William Hubbs <w.d.hubbs@gmail.com>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: speakup: fix leaks of sysfs groups
Date: Sun, 17 Oct 2010 18:51:53 +0400
Message-Id: <1287327114-9201-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

speakup_kobj_init() and speakup_kobj_exit() didn't remove
i18n_attr_group and main_attr_group sysfs groups.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 drivers/staging/speakup/kobjects.c |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/speakup/kobjects.c b/drivers/staging/speakup/kobjects.c
index e12b0e7..cc79f9e 100644
--- a/drivers/staging/speakup/kobjects.c
+++ b/drivers/staging/speakup/kobjects.c
@@ -989,24 +989,34 @@ int speakup_kobj_init(void)
 
 	speakup_kobj = kobject_create_and_add("speakup", accessibility_kobj);
 	if (!speakup_kobj) {
-		kobject_put(accessibility_kobj);
-		return -ENOMEM;
+		retval = -ENOMEM;
+		goto err_acc;
 	}
 
 	/* Create the files associated with this kobject */
 	retval = sysfs_create_group(speakup_kobj, &main_attr_group);
 	if (retval)
-		speakup_kobj_exit();
+		goto err_speakup;
 
 	retval = sysfs_create_group(speakup_kobj, &i18n_attr_group);
 	if (retval)
-		speakup_kobj_exit();
+		goto err_group;
+
+	return 0;
 
+err_group:
+	sysfs_remove_group(speakup_kobj, &main_attr_group);
+err_speakup:
+	kobject_put(speakup_kobj);
+err_acc:
+	kobject_put(accessibility_kobj);
 	return retval;
 }
 
 void speakup_kobj_exit(void)
 {
+	sysfs_remove_group(speakup_kobj, &i18n_attr_group);
+	sysfs_remove_group(speakup_kobj, &main_attr_group);
 	kobject_put(speakup_kobj);
 	kobject_put(accessibility_kobj);
 }
-- 
1.7.0.4


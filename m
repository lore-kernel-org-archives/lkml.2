Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab1G0EFt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 00:05:49 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:56824 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752860Ab1G0EFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 00:05:47 -0400
X-Sasl-enc: TmK/hXwOOoMEd/YvfbunVR0otBSuwaZvEsFkCQ4Dq7mI 1311739546
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Axel Lin <axel.lin@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 08/11] firmware: gsmi: remove sysfs entries when unload the module
Date: Tue, 26 Jul 2011 21:05:18 -0700
Message-Id: <1311739521-11014-8-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311739521-11014-1-git-send-email-gregkh@suse.de>
References: <20110726045707.GA2321@kroah.com>
 <1311739521-11014-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Axel Lin <axel.lin@gmail.com>

This patch removes sysfs entries in gsmi_exit() and gsmi_init() error path.

Also move the driver successfully loaded message to the end of gsmi_init()
and return proper error if register_efivars() fails.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/firmware/google/gsmi.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/firmware/google/gsmi.c b/drivers/firmware/google/gsmi.c
index fa7f0b3..68810fd 100644
--- a/drivers/firmware/google/gsmi.c
+++ b/drivers/firmware/google/gsmi.c
@@ -869,8 +869,6 @@ static __init int gsmi_init(void)
 		goto out_err;
 	}
 
-	printk(KERN_INFO "gsmi version " DRIVER_VERSION " loaded\n");
-
 	/* Register in the firmware directory */
 	ret = -ENOMEM;
 	gsmi_kobj = kobject_create_and_add("gsmi", firmware_kobj);
@@ -890,12 +888,13 @@ static __init int gsmi_init(void)
 	ret = sysfs_create_files(gsmi_kobj, gsmi_attrs);
 	if (ret) {
 		printk(KERN_INFO "gsmi: Failed to add attrs");
-		goto out_err;
+		goto out_remove_bin_file;
 	}
 
-	if (register_efivars(&efivars, &efivar_ops, gsmi_kobj)) {
+	ret = register_efivars(&efivars, &efivar_ops, gsmi_kobj);
+	if (ret) {
 		printk(KERN_INFO "gsmi: Failed to register efivars\n");
-		goto out_err;
+		goto out_remove_sysfs_files;
 	}
 
 	register_reboot_notifier(&gsmi_reboot_notifier);
@@ -903,9 +902,15 @@ static __init int gsmi_init(void)
 	atomic_notifier_chain_register(&panic_notifier_list,
 				       &gsmi_panic_notifier);
 
+	printk(KERN_INFO "gsmi version " DRIVER_VERSION " loaded\n");
+
 	return 0;
 
- out_err:
+out_remove_sysfs_files:
+	sysfs_remove_files(gsmi_kobj, gsmi_attrs);
+out_remove_bin_file:
+	sysfs_remove_bin_file(gsmi_kobj, &eventlog_bin_attr);
+out_err:
 	kobject_put(gsmi_kobj);
 	gsmi_buf_free(gsmi_dev.param_buf);
 	gsmi_buf_free(gsmi_dev.data_buf);
@@ -925,6 +930,8 @@ static void __exit gsmi_exit(void)
 					 &gsmi_panic_notifier);
 	unregister_efivars(&efivars);
 
+	sysfs_remove_files(gsmi_kobj, gsmi_attrs);
+	sysfs_remove_bin_file(gsmi_kobj, &eventlog_bin_attr);
 	kobject_put(gsmi_kobj);
 	gsmi_buf_free(gsmi_dev.param_buf);
 	gsmi_buf_free(gsmi_dev.data_buf);
-- 
1.7.6


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021Ab1F2H6L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 03:58:11 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48994 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab1F2H6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 03:58:02 -0400
Subject: [PATCH] firmware: gsmi: remove sysfs entries when unload the module
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mike Waychison <mikew@google.com>, Duncan Laurie <dlaurie@google.com>,
        Aaron Durbin <adurbin@google.com>, Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Jun 2011 15:57:53 +0800
Message-ID: <1309334273.6368.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes sysfs entries in gsmi_exit() and gsmi_init() error path.

Also move the driver successfully loaded message to the end of gsmi_init()
and return proper error if register_efivars() fails.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
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
1.7.4.1




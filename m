Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab0F3JXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 05:23:25 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60837 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab0F3JXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 05:23:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=a/TUc6ArsVCYXGjrEtgDM3zqJodPBVRBFLPKK2UCUjCHjBf8EVn00DT4oao0ANp4zQ
         UPMb/z6AcbTDf6FZOpoqo/ZWFPsGYT8i0F7d5EeTOnMJ62CK3BkFNAolSoy3Z5tY37MC
         kO63vQWfpeMlA2sVq957lu+AUlecSTd6IPOn0=
Subject: [PATCH] dell-wmi: fix a memory leak
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
       Dmitry Torokhov <dtor@mail.ru>,
       =?ISO-8859-1?Q?M=E1rton_N=E9meth?= <nm127@freemail.hu>,
       platform-driver-x86@vger.kernel.org
Content-Type: text/plain
Date: Wed, 30 Jun 2010 17:25:46 +0800
Message-Id: <1277889946.30827.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If dell_new_hk_type is true, dell_legacy_wmi_keymap will point to a memory
allocated in setup_new_hk_map().
In this case, the memory is not freed in current implementation.
This patch fixes the leak by kfree(dell_wmi_keymap) if dell_new_hk_type is true.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/platform/x86/dell-wmi.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/dell-wmi.c b/drivers/platform/x86/dell-wmi.c
index 66f53c3..ee6452e 100644
--- a/drivers/platform/x86/dell-wmi.c
+++ b/drivers/platform/x86/dell-wmi.c
@@ -339,13 +339,18 @@ static int __init dell_wmi_init(void)
 	acpi_video = acpi_video_backlight_support();
 
 	err = dell_wmi_input_setup();
-	if (err)
+	if (err) {
+		if (dell_new_hk_type)
+			kfree(dell_wmi_keymap);
 		return err;
+	}
 
 	status = wmi_install_notify_handler(DELL_EVENT_GUID,
 					 dell_wmi_notify, NULL);
 	if (ACPI_FAILURE(status)) {
 		input_unregister_device(dell_wmi_input_dev);
+		if (dell_new_hk_type)
+			kfree(dell_wmi_keymap);
 		printk(KERN_ERR
 			"dell-wmi: Unable to register notify handler - %d\n",
 			status);
@@ -359,6 +364,8 @@ static void __exit dell_wmi_exit(void)
 {
 	wmi_remove_notify_handler(DELL_EVENT_GUID);
 	input_unregister_device(dell_wmi_input_dev);
+	if (dell_new_hk_type)
+		kfree(dell_wmi_keymap);
 }
 
 module_init(dell_wmi_init);
-- 
1.5.4.3




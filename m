Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab0GEH27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 03:28:59 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:50651 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab0GEH25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 03:28:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=DC1GMxqn+bMwZ6/i8pZGTc1CPWQHI3nXSPgrZX1siF0S4n0gPwj175+Y68Eti46PHx
         plgpV/Ym16I8b/HyhIT8fsaGwkA50jZ1x8+BFcEau1U+qj44p6EYhCC5fXf1BvSTnrdV
         3JNqKW2WEYqNupmIzDlQFXcDAptH/FkAN0MP8=
Subject: [PATCH] asus-laptop: fix asus_input_init error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Corentin Chary <corentincj@iksaif.net>, Matthew Garrett <mjg@redhat.com>,
       Len Brown <len.brown@intel.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       acpi4asus-user@lists.sourceforge.net,
       platform-driver-x86@vger.kernel.org
Content-Type: text/plain
Date: Mon, 05 Jul 2010 15:29:00 +0800
Message-Id: <1278314940.12801.10.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch includes below fixes:
1. return -ENOMEM instead of 0 if input_allocate_device fail.
2. fix wrong goto if sparse_keymap_setup fail.
3. fix wrong goto if input_register_device fail.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/platform/x86/asus-laptop.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index 71db2ef..3a7aeb9 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -1123,7 +1123,7 @@ static int asus_input_init(struct asus_laptop *asus)
 	input = input_allocate_device();
 	if (!input) {
 		pr_info("Unable to allocate input device\n");
-		return 0;
+		return -ENOMEM;
 	}
 	input->name = "Asus Laptop extra buttons";
 	input->phys = ASUS_LAPTOP_FILE "/input0";
@@ -1134,20 +1134,20 @@ static int asus_input_init(struct asus_laptop *asus)
 	error = sparse_keymap_setup(input, asus_keymap, NULL);
 	if (error) {
 		pr_err("Unable to setup input device keymap\n");
-		goto err_keymap;
+		goto err_free_dev;
 	}
 	error = input_register_device(input);
 	if (error) {
 		pr_info("Unable to register input device\n");
-		goto err_device;
+		goto err_free_keymap;
 	}
 
 	asus->inputdev = input;
 	return 0;
 
-err_keymap:
+err_free_keymap:
 	sparse_keymap_free(input);
-err_device:
+err_free_dev:
 	input_free_device(input);
 	return error;
 }
-- 
1.5.4.3




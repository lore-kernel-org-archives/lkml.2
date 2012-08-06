Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab2HFVX1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 17:23:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52865 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212Ab2HFVXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 17:23:24 -0400
From: manoj.iyer@canonical.com
To: linux-kernel@vger.kernel.org
Cc: ibm-acpi-devel@lists.sourceforge.net, platform-driver-x86@vger.kernel.org,
        mjg@redhat.com, ibm-acpi@hmh.eng.br
Subject: [PATCH] thinkpad-acpi: recognize latest V-Series using DMI_BIOS_VENDOR
Date: Mon,  6 Aug 2012 16:23:20 -0500
Message-Id: <1344288200-8502-1-git-send-email-manoj.iyer@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manoj Iyer <manoj.iyer@canonical.com>

In the latest V-series bios DMI_PRODUCT_VERSION does not contain
the string Lenovo or Thinkpad, but is set to the model number, this
causes the thinkpad_acpi module to fail to load. Recognize laptop
as Lenovo using DMI_BIOS_VENDOR instead, which is set to Lenovo.

Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>
---
 drivers/platform/x86/thinkpad_acpi.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index e7f7328..17692c8 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -8658,11 +8658,16 @@ static int __must_check __init get_thinkpad_model_data(
 	}
 
 	s = dmi_get_system_info(DMI_PRODUCT_VERSION);
-	if (s && !(strnicmp(s, "ThinkPad", 8) && strnicmp(s, "Lenovo", 6))) {
+	if (s && !(strnicmp(s, "ThinkPad", 8) && strnicmp(s, "Lenovo", 6)))
 		tp->model_str = kstrdup(s, GFP_KERNEL);
-		if (!tp->model_str)
-			return -ENOMEM;
-	}
+	else {
+		s = dmi_get_system_info(DMI_BIOS_VENDOR);
+		if (s && !(strnicmp(s, "Lenovo", 6)))
+			tp->model_str = kstrdup(s, GFP_KERNEL);
+	} 
+
+	if (!tp->model_str)
+		return -ENOMEM;
 
 	s = dmi_get_system_info(DMI_PRODUCT_NAME);
 	tp->nummodel_str = kstrdup(s, GFP_KERNEL);
-- 
1.7.9.5


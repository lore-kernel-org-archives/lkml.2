Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759617Ab2CTIym (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 04:54:42 -0400
Received: from smtp5.tech.numericable.fr ([82.216.111.41]:39256 "EHLO
	smtp5.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759545Ab2CTIyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 04:54:36 -0400
From: Corentin Chary <corentin.chary@gmail.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: platform-driver-x86@vger.kernel.org,
        Corentin Chary <corentin.chary@gmail.com>,
        Corentin Chary <corentincj@iksaif.net>,
        acpi4asus-user@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 14/14] asus-wmi: don't update power and brightness when using scalar
Date: Tue, 20 Mar 2012 09:53:14 +0100
Message-Id: <1332233594-13099-15-git-send-email-corentin.chary@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1332233594-13099-1-git-send-email-corentin.chary@gmail.com>
References: <1332233594-13099-1-git-send-email-corentin.chary@gmail.com>
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegvddrgeejucetggdotefuucfrrhhofhhilhgvmecupfgfoffgtffkveetuefngfenuceurghilhhouhhtmecufedttdenuc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

But we can still do it on other boards, as this might happen
if the backlight driver change when update_bl is called.

Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
---
 drivers/platform/x86/asus-wmi.c |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index ff9cfd8..7d1684b 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -1152,15 +1152,21 @@ static int update_bl_status(struct backlight_device *bd)
 					    ctrl_param, NULL);
 		if (asus->driver->quirks->store_backlight_power)
 			asus->driver->panel_power = bd->props.power;
-	} else {
-		if (asus->driver->quirks->scalar_panel_brightness)
-			ctrl_param = get_scalar_command(bd);
-		else
-			ctrl_param = bd->props.brightness;
 
-		err = asus_wmi_set_devstate(ASUS_WMI_DEVID_BRIGHTNESS,
-					    ctrl_param, NULL);
+		/* When using scalar brightness, updating the brightness
+		 * will mess with the backlight power */
+		if (asus->driver->quirks->scalar_panel_brightness)
+			return err;
 	}
+
+	if (asus->driver->quirks->scalar_panel_brightness)
+		ctrl_param = get_scalar_command(bd);
+	else
+		ctrl_param = bd->props.brightness;
+
+	err = asus_wmi_set_devstate(ASUS_WMI_DEVID_BRIGHTNESS,
+				    ctrl_param, NULL);
+
 	return err;
 }
 
-- 
1.7.3.4


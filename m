Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759605Ab2CTIyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 04:54:40 -0400
Received: from smtp5.tech.numericable.fr ([82.216.111.41]:39255 "EHLO
	smtp5.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759594Ab2CTIyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 04:54:37 -0400
From: Corentin Chary <corentin.chary@gmail.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: platform-driver-x86@vger.kernel.org,
        Corentin Chary <corentin.chary@gmail.com>,
        Corentin Chary <corentincj@iksaif.net>,
        acpi4asus-user@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 13/14] eeepc-wmi: split et2012 specific hacks
Date: Tue, 20 Mar 2012 09:53:13 +0100
Message-Id: <1332233594-13099-14-git-send-email-corentin.chary@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1332233594-13099-1-git-send-email-corentin.chary@gmail.com>
References: <1332233594-13099-1-git-send-email-corentin.chary@gmail.com>
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegvddrgeejucetggdotefuucfrrhhofhhilhgvmecupfgfoffgtffkveetuefngfenuceurghilhhouhhtmecufedttdenuc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
---
 drivers/platform/x86/eeepc-wmi.c |   34 ++++++++++++++++++++--------------
 1 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
index 0bb0aaf..6567613 100644
--- a/drivers/platform/x86/eeepc-wmi.c
+++ b/drivers/platform/x86/eeepc-wmi.c
@@ -109,26 +109,32 @@ static struct quirk_entry quirk_asus_et2012_type3 = {
 
 static struct quirk_entry *quirks;
 
+static void et2012_quirks(void)
+{
+	const struct dmi_device *dev = NULL;
+	char oemstring[30];
+
+	while ((dev = dmi_find_device(DMI_DEV_TYPE_OEM_STRING, NULL, dev))) {
+		if (sscanf(dev->name, "AEMS%24c", oemstring) == 1) {
+			if (oemstring[18] == '1')
+				quirks = &quirk_asus_et2012_type1;
+			else if (oemstring[18] == '3')
+				quirks = &quirk_asus_et2012_type3;
+			break;
+		}
+	}
+}
+
 static int dmi_matched(const struct dmi_system_id *dmi)
 {
 	char *model;
+
 	quirks = dmi->driver_data;
 
 	model = (char *)dmi->matches[1].substr;
-	if (unlikely(strncmp(model, "ET2012", 6) == 0)) {
-		const struct dmi_device *dev = NULL;
-		char oemstring[30];
-		while ((dev = dmi_find_device(DMI_DEV_TYPE_OEM_STRING,
-					      NULL, dev))) {
-			if (sscanf(dev->name, "AEMS%24c", oemstring) == 1) {
-				if (oemstring[18] == '1')
-					quirks = &quirk_asus_et2012_type1;
-				else if (oemstring[18] == '3')
-					quirks = &quirk_asus_et2012_type3;
-				break;
-			}
-		}
-	}
+	if (unlikely(strncmp(model, "ET2012", 6) == 0))
+		et2012_quirks();
+
 	return 1;
 }
 
-- 
1.7.3.4


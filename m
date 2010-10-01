Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab0JAHka (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 03:40:30 -0400
Received: from adelie.canonical.com ([91.189.90.139]:38124 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663Ab0JAHk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 03:40:28 -0400
From: Ike Panhc <ike.pan@canonical.com>
To: platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
        Corentin Chary <corentincj@iksaif.net>,
        David Woodhouse <David.Woodhouse@intel.com>, Mario.Holbe@TU-Ilmenau.DE
Subject: [PATCH 9/9] ideapad: Add param: no_bt_rfkill
Date: Fri,  1 Oct 2010 15:40:22 +0800
Message-Id: <1285918822-13116-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285918660-12802-1-git-send-email-ike.pan@canonical.com>
References: <1285918660-12802-1-git-send-email-ike.pan@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new module parameter that force module not to register bluetooth rfkill.

There is report that saying using this bluetooth rfkill to enable/disable
bluetooth will let bluetooth device initial failed when enable on Lenovo
ideapad S12. Fortunately there is another rfkill registered by bluetooth
driver for S12 and user can shutdown the bluetooth by either bluetooth driver
or HW RF switch.

For dual OS user, it may have some trouble that using Linux after turning off
bluetooth with another OS if we do not register bluetooth rfkill at all. So
we will force bluetooth enable when no_bt_rfkill=1.

Signed-off-by: Ike Panhc <ike.pan@canonical.com>
Tested-by: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
---
 drivers/platform/x86/ideapad-laptop.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index 78ac02a..6a4396e 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -52,6 +52,10 @@ static struct {
 	{ "ideapad_killsw",	0,  0,    RFKILL_TYPE_WLAN }
 };
 
+static bool no_bt_rfkill;
+module_param(no_bt_rfkill, bool, 0444);
+MODULE_PARM_DESC(no_bt_rfkill, "No rfkill for bluetooth.");
+
 /*
  * ACPI Helpers
  */
@@ -232,6 +236,14 @@ static int ideapad_register_rfkill(struct acpi_device *adevice, int dev)
 	int ret;
 	unsigned long sw_blocked;
 
+	if (no_bt_rfkill &&
+	    (ideapad_rfk_data[dev].type == RFKILL_TYPE_BLUETOOTH)) {
+		/* Force to enable bluetooth when no_bt_rfkill=1 */
+		write_ec_cmd(ideapad_priv->handle,
+			     ideapad_rfk_data[dev].opcode, 1);
+		return 0;
+	}
+
 	priv->rfk[dev] = rfkill_alloc(ideapad_rfk_data[dev].name, &adevice->dev,
 				      ideapad_rfk_data[dev].type, &ideapad_rfk_ops,
 				      (void *)(long)dev);
-- 
1.7.1


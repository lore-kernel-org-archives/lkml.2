Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab2GFIHy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 04:07:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35567 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab2GFIHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 04:07:46 -0400
From: Ike Panhc <ike.pan@canonical.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Maxim Mikityanskiy <maxtram95@gmail.com>,
        Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: [PATCH 1/4] ideapad: uninitialized data in ideapad_acpi_add()
Date: Fri,  6 Jul 2012 16:07:39 +0800
Message-Id: <1341562059-6985-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341562023-6951-1-git-send-email-ike.pan@canonical.com>
References: <1341562023-6951-1-git-send-email-ike.pan@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

We only initialize the high bits of "cfg".  It probably doesn't cause
a problem given that this is platform specific code and doesn't have to
worry about endianness etc.  But it's sort of messy.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Ike Panhc <ike.pan@canonical.com>
---
 drivers/platform/x86/ideapad-laptop.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index 4f20f8d..5fdd1aa 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -693,11 +693,10 @@ MODULE_DEVICE_TABLE(acpi, ideapad_device_ids);
 
 static int __devinit ideapad_acpi_add(struct acpi_device *adevice)
 {
-	int ret, i;
-	unsigned long cfg;
+	int ret, i, cfg;
 	struct ideapad_private *priv;
 
-	if (read_method_int(adevice->handle, "_CFG", (int *)&cfg))
+	if (read_method_int(adevice->handle, "_CFG", &cfg))
 		return -ENODEV;
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
@@ -721,7 +720,7 @@ static int __devinit ideapad_acpi_add(struct acpi_device *adevice)
 		goto input_failed;
 
 	for (i = 0; i < IDEAPAD_RFKILL_DEV_NUM; i++) {
-		if (test_bit(ideapad_rfk_data[i].cfgbit, &cfg))
+		if (test_bit(ideapad_rfk_data[i].cfgbit, &priv->cfg))
 			ideapad_register_rfkill(adevice, i);
 		else
 			priv->rfk[i] = NULL;
-- 
1.7.9.5


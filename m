Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298Ab0HRIhl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 04:37:41 -0400
Received: from adelie.canonical.com ([91.189.90.139]:51146 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240Ab0HRIhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 04:37:39 -0400
From: Ike Panhc <ike.pan@canonical.com>
To: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Cc: Thomas Renninger <trenn@suse.de>, Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Corentin Chary <corentincj@iksaif.net>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Len Brown <len.brown@intel.com>, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 3/8] ideapad: make sure we bind on the correct device
Date: Wed, 18 Aug 2010 16:37:33 +0800
Message-Id: <1282120653-11434-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282120564-11324-1-git-send-email-ike.pan@canonical.com>
References: <1282120564-11324-1-git-send-email-ike.pan@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By reading from method _STA and _CFG to make sure we bind on the correct
VPC2004 device.

Signed-off-by: Ike Panhc <ike.pan@canonical.com>
---
 drivers/platform/x86/ideapad_acpi.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/ideapad_acpi.c b/drivers/platform/x86/ideapad_acpi.c
index 6176597..c1eec70 100644
--- a/drivers/platform/x86/ideapad_acpi.c
+++ b/drivers/platform/x86/ideapad_acpi.c
@@ -328,10 +328,18 @@ MODULE_DEVICE_TABLE(acpi, ideapad_device_ids);
 
 static int ideapad_acpi_add(struct acpi_device *adevice)
 {
-	int i;
+	int i, cfg;
 	int devs_present[5];
 	struct ideapad_private *priv;
 
+	if (read_method_int(adevice->handle, "_STA", &i))
+		return -ENODEV;
+	if (i != 0x0F)
+		return -ENODEV;
+
+	if (read_method_int(adevice->handle, "_CFG", &cfg))
+		return -ENODEV;
+
 	for (i = IDEAPAD_DEV_CAMERA; i < IDEAPAD_DEV_KILLSW; i++) {
 		devs_present[i] = ideapad_dev_exists(i);
 		if (devs_present[i] < 0)
-- 
1.7.0.4


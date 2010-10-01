Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab0JAHjN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 03:39:13 -0400
Received: from adelie.canonical.com ([91.189.90.139]:36942 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590Ab0JAHjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 03:39:10 -0400
From: Ike Panhc <ike.pan@canonical.com>
To: platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
        Corentin Chary <corentincj@iksaif.net>,
        David Woodhouse <David.Woodhouse@intel.com>, Mario.Holbe@TU-Ilmenau.DE
Subject: [PATCH 2/9] ideapad: check VPC bit before sync rfkill hw status
Date: Fri,  1 Oct 2010 15:39:05 +0800
Message-Id: <1285918745-12913-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285918660-12802-1-git-send-email-ike.pan@canonical.com>
References: <1285918660-12802-1-git-send-email-ike.pan@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check VPC bit to make sure the HW rfkill is touched.

Signed-off-by: Ike Panhc <ike.pan@canonical.com>
---
 drivers/platform/x86/ideapad_acpi.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/ideapad_acpi.c b/drivers/platform/x86/ideapad_acpi.c
index 1ecf679..15d7e7e 100644
--- a/drivers/platform/x86/ideapad_acpi.c
+++ b/drivers/platform/x86/ideapad_acpi.c
@@ -379,7 +379,21 @@ static int ideapad_acpi_remove(struct acpi_device *adevice, int type)
 
 static void ideapad_acpi_notify(struct acpi_device *adevice, u32 event)
 {
-	ideapad_sync_rfk_state(adevice);
+	acpi_handle handle = adevice->handle;
+	unsigned long vpc1, vpc2, vpc_bit;
+
+	if (read_ec_data(handle, 0x10, &vpc1))
+		return;
+	if (read_ec_data(handle, 0x1A, &vpc2))
+		return;
+
+	vpc1 = (vpc2 << 8) | vpc1;
+	for (vpc_bit = 0; vpc_bit < 16; vpc_bit++) {
+		if (test_bit(vpc_bit, &vpc1)) {
+			if (vpc_bit == 9)
+				ideapad_sync_rfk_state(adevice);
+		}
+	}
 }
 
 static struct acpi_driver ideapad_acpi_driver = {
-- 
1.7.1


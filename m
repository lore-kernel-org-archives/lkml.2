Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab0HRIhc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 04:37:32 -0400
Received: from adelie.canonical.com ([91.189.90.139]:51037 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab0HRIha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 04:37:30 -0400
From: Ike Panhc <ike.pan@canonical.com>
To: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Cc: Thomas Renninger <trenn@suse.de>, Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Corentin Chary <corentincj@iksaif.net>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Len Brown <len.brown@intel.com>, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 2/8] ideapad: check VPC bit before sync rfkill hw status
Date: Wed, 18 Aug 2010 16:37:17 +0800
Message-Id: <1282120637-11398-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282120564-11324-1-git-send-email-ike.pan@canonical.com>
References: <1282120564-11324-1-git-send-email-ike.pan@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check VPC bit to make sure the HW rfkill is touched.

Signed-off-by: Ike Panhc <ike.pan@canonical.com>
---
 drivers/platform/x86/ideapad_acpi.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/ideapad_acpi.c b/drivers/platform/x86/ideapad_acpi.c
index af630e2..6176597 100644
--- a/drivers/platform/x86/ideapad_acpi.c
+++ b/drivers/platform/x86/ideapad_acpi.c
@@ -381,7 +381,21 @@ static int ideapad_acpi_remove(struct acpi_device *adevice, int type)
 
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
1.7.0.4


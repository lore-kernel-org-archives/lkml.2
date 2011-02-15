Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab1BOJga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 04:36:30 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54223 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787Ab1BOJg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 04:36:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=lyTp2xyJDxkKt7BR/sP4KB4rxSuJD/LmVf9JGCCOADLwC6FTUOmVHzWAFABOKxyOMf
         79E5O714uRbeBIXVVfINDjDzJgWsqr8H5lqVoBhTGAWjubskgvzRKsZSAh0H72bapo1U
         DctWzQm1Gg2u3iiK+TTQj6ryf5kvcxPtA3QuI=
From: Keng-Yu Lin <keng-yu.lin@canonical.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Alessio Igor Bogani <abogani@texware.it>, superm1@ubuntu.com,
        Keng-Yu Lin <keng-yu.lin@canonical.com>
Subject: [PATCH] dell-laptop: Toggle the unsupported hardware killswitch
Date: Tue, 15 Feb 2011 17:36:07 +0800
Message-Id: <1297762567-4880-1-git-send-email-keng-yu.lin@canonical.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is found on Dell Inspiron 1018 that the firmware reports that the hardware
killswitch is not supported. This makes the rfkill key not functional.

This patch forces the driver to toggle the firmware rfkill status in the case
that the hardware killswitch is indicated as unsupported by the firmware.

Signed-off-by: Keng-Yu Lin <keng-yu.lin@canonical.com>
Tested-by: Alessio Igor Bogani <abogani@texware.it>
---
 drivers/platform/x86/dell-laptop.c |   24 ++++++++++++++++++++++--
 1 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index 34657f9..ad24ef3 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -290,9 +290,12 @@ static int dell_rfkill_set(void *data, bool blocked)
 	dell_send_request(buffer, 17, 11);
 
 	/* If the hardware switch controls this radio, and the hardware
-	   switch is disabled, don't allow changing the software state */
+	   switch is disabled, don't allow changing the software state.
+	   If the hardware switch is reported as not supported, always
+	   fire the SMI to toggle the killswitch. */
 	if ((hwswitch_state & BIT(hwswitch_bit)) &&
-	    !(buffer->output[1] & BIT(16))) {
+	    !(buffer->output[1] & BIT(16)) &&
+	    (buffer->output[1] & BIT(0))) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -398,6 +401,23 @@ static const struct file_operations dell_debugfs_fops = {
 
 static void dell_update_rfkill(struct work_struct *ignored)
 {
+	int status;
+
+	get_buffer();
+	dell_send_request(buffer, 17, 11);
+	status = buffer->output[1];
+	release_buffer();
+
+	/* if hardware rfkill is not supported, set it explicitly */
+	if (!(status & BIT(0))) {
+		if (wifi_rfkill)
+			dell_rfkill_set((void *)1, !((status & BIT(17)) >> 17));
+		if (bluetooth_rfkill)
+			dell_rfkill_set((void *)2, !((status & BIT(18)) >> 18));
+		if (wwan_rfkill)
+			dell_rfkill_set((void *)3, !((status & BIT(19)) >> 19));
+	}
+
 	if (wifi_rfkill)
 		dell_rfkill_query(wifi_rfkill, (void *)1);
 	if (bluetooth_rfkill)
-- 
1.7.1


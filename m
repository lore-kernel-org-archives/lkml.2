Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624Ab1F0KVc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 06:21:32 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53049 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757893Ab1F0KTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 06:19:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=b91Qi8/B+RtbuD1mAM5/X9dtJ8HZAiqfa91LgdhZgWgTRqsXHP+eVGqGNYLXvOsmMR
         MR9QqzFYLq4x23DUxfqm6Hz3E7rsZ/2JTPM1HeXbXx0/vLCEeQwoeyAOpit/FIyB+iGn
         vHDSlnShzumz1DtzT83M6opQeJUQ3VeBrAoFc=
From: Keng-Yu Lin <kengyu@canonical.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: gmane@colin.guthr.ie
Subject: [PATCH] Revert: "dell-laptop: Toggle the unsupported hardware killswitch"
Date: Mon, 27 Jun 2011 11:19:03 +0100
Message-Id: <1309169943-3786-1-git-send-email-kengyu@canonical.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit a3d77411e8b2ad661958c1fbee65beb476ec6d70,

as it causes a mess in the wireless rfkill status on some models.
It is probably a bad idea to toggle the rfkill for all dell models
without the respect to the claim that it is hardware-controlled.

Signed-off-by: Keng-Yu Lin <kengyu@canonical.com>
---
 drivers/platform/x86/dell-laptop.c |   24 ++----------------------
 1 files changed, 2 insertions(+), 22 deletions(-)

diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index d3841de..04c34f1 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -292,12 +292,9 @@ static int dell_rfkill_set(void *data, bool blocked)
 	dell_send_request(buffer, 17, 11);
 
 	/* If the hardware switch controls this radio, and the hardware
-	   switch is disabled, don't allow changing the software state.
-	   If the hardware switch is reported as not supported, always
-	   fire the SMI to toggle the killswitch. */
+	   switch is disabled, don't allow changing the software state */
 	if ((hwswitch_state & BIT(hwswitch_bit)) &&
-	    !(buffer->output[1] & BIT(16)) &&
-	    (buffer->output[1] & BIT(0))) {
+	    !(buffer->output[1] & BIT(16))) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -403,23 +400,6 @@ static const struct file_operations dell_debugfs_fops = {
 
 static void dell_update_rfkill(struct work_struct *ignored)
 {
-	int status;
-
-	get_buffer();
-	dell_send_request(buffer, 17, 11);
-	status = buffer->output[1];
-	release_buffer();
-
-	/* if hardware rfkill is not supported, set it explicitly */
-	if (!(status & BIT(0))) {
-		if (wifi_rfkill)
-			dell_rfkill_set((void *)1, !((status & BIT(17)) >> 17));
-		if (bluetooth_rfkill)
-			dell_rfkill_set((void *)2, !((status & BIT(18)) >> 18));
-		if (wwan_rfkill)
-			dell_rfkill_set((void *)3, !((status & BIT(19)) >> 19));
-	}
-
 	if (wifi_rfkill)
 		dell_rfkill_query(wifi_rfkill, (void *)1);
 	if (bluetooth_rfkill)
-- 
1.7.4.1


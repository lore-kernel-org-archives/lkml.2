Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758080Ab1F1NiZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 09:38:25 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58885 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757517Ab1F1NgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 09:36:21 -0400
From: Keng-Yu Lin <kengyu@canonical.com>
To: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: ike.pan@canonical.com, vanhoof@canonical.com, kent.lin@canonical.com,
        sylee@canonical.com, Keng-Yu Lin <kengyu@canonical.com>
Subject: [PATCH 2/2] ideapad-laptop: Handle the App-controlled RF event
Date: Tue, 28 Jun 2011 14:35:54 +0100
Message-Id: <1309268154-6872-2-git-send-email-kengyu@canonical.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309268154-6872-1-git-send-email-kengyu@canonical.com>
References: <1309268154-6872-1-git-send-email-kengyu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Notification with VPC2 bit 5 set is generated when the wireless
hotkey is pressed. BIOS fires this to notify a Windows
application to handle the RF switch.

On Linux, there is no such application. This patch implements
a toggle for all RF devices through accessing the EC I/O ports.

Without the explicit EC commands, the wifi LED is always on.

Signed-off-by: Keng-Yu Lin <kengyu@canonical.com>
---
 drivers/platform/x86/ideapad-laptop.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index 820f013..5e1e971 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -461,7 +461,11 @@ static void ideapad_acpi_notify(struct acpi_device *adevice, u32 event)
 		if (test_bit(vpc_bit, &vpc1)) {
 			if (vpc_bit == 9)
 				ideapad_sync_rfk_state(adevice);
-			else if (vpc_bit == 4)
+			else if (vpc_bit == 13) {
+				read_ec_data(handle, 0x23, &vpc2);
+				write_ec_cmd(handle, 0x24, !vpc2);
+				ideapad_sync_rfk_state(adevice);
+			} else if (vpc_bit == 4)
 				read_ec_data(handle, 0x12, &vpc2);
 			else if (vpc_bit == 1) {
 			} else
-- 
1.7.4.1


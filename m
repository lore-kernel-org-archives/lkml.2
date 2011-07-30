Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094Ab1G3PB3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 11:01:29 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34835 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab1G3PBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 11:01:23 -0400
From: Mart Gerrits <mart1987@gmail.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mart Gerrits <mart1987@gmail.com>
Subject: [PATCH 1/1] watchdog: Fix POST failure on ASUS P5N32-E SLI and similar boards
Date: Sat, 30 Jul 2011 16:59:12 +0200
Message-Id: <1312037952-3646-1-git-send-email-mart1987@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At present the module does not unset the NO_REBOOT bit upon shutdown, this
causes the BIOS to fail the POST once and reset. During the next boot it
displays the following error message:

***** Warning: System BOOT Fail *****
Your system last boot fail or POST interrupted.
Please enter setup to load default and reboot again.
Press F1 to continue, DEL to enter SETUP

With this patch the NO_REBOOT flag will be unset on shutdown and thus stop
this failure from occurring.

Tested on 'ASUS P5N32-E SLI with BIOS revision 1801' and
          'ASUS P5N32-E SLI PLUS with BIOS revision 1502'.

Signed-off-by: Mart Gerrits <mart1987@gmail.com>
---
 drivers/watchdog/nv_tco.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/watchdog/nv_tco.c b/drivers/watchdog/nv_tco.c
index afa78a5..09de584 100644
--- a/drivers/watchdog/nv_tco.c
+++ b/drivers/watchdog/nv_tco.c
@@ -458,7 +458,15 @@ static int __devexit nv_tco_remove(struct platform_device *dev)

 static void nv_tco_shutdown(struct platform_device *dev)
 {
+	u32 val;
+
 	tco_timer_stop();
+
+	/* Some BIOSes fail the POST (once) if the NO_REBOOT flag is not
+	* unset during shutdown. */
+	pci_read_config_dword(tco_pci, MCP51_SMBUS_SETUP_B, &val);
+	val &= ~MCP51_SMBUS_SETUP_B_TCO_REBOOT;
+	pci_write_config_dword(tco_pci, MCP51_SMBUS_SETUP_B, val);
 }

 static struct platform_driver nv_tco_driver = {
--
1.7.6

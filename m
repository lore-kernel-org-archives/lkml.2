Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328Ab2ILTAi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 15:00:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718Ab2ILTAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 15:00:37 -0400
From: David Milburn <dmilburn@redhat.com>
To: axboe@kernel.dk
Cc: asamymuthupa@micron.com, linux-kernel@vger.kernel.org, thenzl@redhat.com
Subject: [PATCH] mtip32xx: fix user_buffer check in exec_drive_command
Date: Wed, 12 Sep 2012 14:06:12 -0500
Message-Id: <1347476772-21798-1-git-send-email-dmilburn@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current user_buffer check is incorrect and causes hdparm to fail

# hdparm -I /dev/rssda
 HDIO_DRIVE_CMD(identify) failed: Input/output error

/dev/rssda:

Patching linux-3.6-rc5 hdparm works as expected

# hdparm -I /dev/rssda
/dev/rssda:

ATA device, with non-removable media
	Model Number:       DELL_P320h-MTFDGAL350SAH                
	Serial Number:      00000000121302025F01
	Firmware Revision:  B1442808
<snip>

Reported-by: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: David Milburn <dmilburn@redhat.com>
---
 drivers/block/mtip32xx/mtip32xx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index a8fddeb..b24efe3 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -1900,7 +1900,7 @@ static int exec_drive_command(struct mtip_port *port, u8 *command,
 	int rv = 0, xfer_sz = command[3];
 
 	if (xfer_sz) {
-		if (user_buffer)
+		if (!user_buffer)
 			return -EFAULT;
 
 		buf = dmam_alloc_coherent(&port->dd->pdev->dev,

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab1AWWTd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 17:19:33 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:19965 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab1AWWTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 17:19:18 -0500
Date: Sun, 23 Jan 2011 23:19:55 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-usb@vger.kernel.org
cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, The Zapman <zapman@interlan.net>,
        Michael Rothwell <rothwell@interlan.net>
Subject: [PATCH] USB NET KL5KUSB101: Fix mem leak in error path of
 kaweth_download_firmware()
Message-ID: <alpine.LNX.2.00.1101232315230.30955@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We will leak the storage allocated by request_firmware() if the size of 
the firmware is greater than KAWETH_FIRMWARE_BUF_SIZE.
This removes the leak by calling release_firmware() before we return 
-ENOSPC.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 kaweth.c |    1 +
 1 file changed, 1 insertion(+)

  Compile tested only since I do not have the hardware.

diff --git a/drivers/net/usb/kaweth.c b/drivers/net/usb/kaweth.c
index 5e98643..7dc8497 100644
--- a/drivers/net/usb/kaweth.c
+++ b/drivers/net/usb/kaweth.c
@@ -406,6 +406,7 @@ static int kaweth_download_firmware(struct kaweth_device *kaweth,
 
 	if (fw->size > KAWETH_FIRMWARE_BUF_SIZE) {
 		err("Firmware too big: %zu", fw->size);
+		release_firmware(fw);
 		return -ENOSPC;
 	}
 	data_len = fw->size;


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.


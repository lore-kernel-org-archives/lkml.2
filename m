Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab1A0XgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 18:36:17 -0500
Received: from smtp.flash.net.br ([201.46.240.48]:46016 "EHLO
	smtp.gru.flash.tv.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750Ab1A0XgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 18:36:16 -0500
Date: Thu, 27 Jan 2011 21:24:56 -0200
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: linux-kernel@vger.kernel.org
Cc: Alexander Holler <holler@ahsoftware.de>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>, rbrito@ime.usp.br
Subject: [PATCH 02/02] ath3k: Avoid duplication of code
Message-ID: <20110127232453.GA3531@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

In commit 86e09287e4f8c81831b4d4118a48597565f0d21b, to reduce memory
usage, the functions of the ath3k module were rewritten to release the
firmware blob after it has been loaded (successfully or not).

The resuting code has some redundancy and the compiler can potentially
produce better code if we omit a function call that is unconditionally
executed in

,----
| 	if (ath3k_load_firmware(udev, firmware)) {
| 		release_firmware(firmware);
| 		return -EIO;
| 	}
| 	release_firmware(firmware);
| 
| 	return 0;
| }
`----

It may also be argued that the code becomes easier to read, and also to
see the code coverage of the snippet in question.

Signed-off-by: Rogério Brito <rbrito@ime.usp.br>

---

This is the second (preferred?) version of the patch in question.

---

diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
index a126e61..d51c5a3 100644
--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -116,13 +116,10 @@ static int ath3k_probe(struct usb_interface *intf,
 		return -EIO;
 	}
 
-	if (ath3k_load_firmware(udev, firmware)) {
-		release_firmware(firmware);
-		return -EIO;
-	}
+	ret = ath3k_load_firmware(udev, firmware);
 	release_firmware(firmware);
 
-	return 0;
+	return ret ? -EIO : 0;
 }
 
 static void ath3k_disconnect(struct usb_interface *intf)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab1A0XbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 18:31:17 -0500
Received: from smtp.flash.net.br ([201.46.240.48]:45883 "EHLO
	smtp.gru.flash.tv.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab1A0XbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 18:31:16 -0500
X-Greylist: delayed 492 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Jan 2011 18:31:16 EST
Date: Thu, 27 Jan 2011 21:22:56 -0200
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: linux-kernel@vger.kernel.org
Cc: Alexander Holler <holler@ahsoftware.de>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>, rbrito@ime.usp.br
Subject: [PATCH 01/02] ath3k: Avoid duplication of code
Message-ID: <20110127232252.GA3493@ime.usp.br>
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

It may also be argued that the rewritten code becomes easier to read,
and also to see the code coverage of the snippet in question.


Signed-off-by: Rogério Brito <rbrito@ime.usp.br>

---

I am sending here two proposals for rewriting the code.  This is the
first one. The second uses the ternary operator and seems to have more
usage in the kernel (or, at least, under mm).

---

diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
index a126e61..0043781 100644
--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -116,13 +116,13 @@ static int ath3k_probe(struct usb_interface *intf,
 		return -EIO;
 	}
 
-	if (ath3k_load_firmware(udev, firmware)) {
-		release_firmware(firmware);
-		return -EIO;
-	}
+	ret = ath3k_load_firmware(udev, firmware);
 	release_firmware(firmware);
 
-	return 0;
+	if (ret)
+		return -EIO;
+	else
+		return 0;
 }
 
 static void ath3k_disconnect(struct usb_interface *intf)

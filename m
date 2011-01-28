Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732Ab1A1WSR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 17:18:17 -0500
Received: from smtp.flash.net.br ([201.46.240.48]:57003 "EHLO
	smtp.gru.flash.tv.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab1A1WSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 17:18:15 -0500
Date: Fri, 28 Jan 2011 20:18:10 -0200
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: linux-kernel@vger.kernel.org
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Alexander Holler <holler@ahsoftware.de>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>, rbrito@ime.usp.br
Subject: [PATCH] ath3k: Avoid duplication of code
Message-ID: <20110128221807.GA9741@ime.usp.br>
References: <20110127232453.GA3531@ime.usp.br>
 <4D4284D7.8000200@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D4284D7.8000200@ahsoftware.de>
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
|	}
|	release_firmware(firmware);
|
|	return 0;
| }
`----

It may also be argued that the rewritten code becomes easier to read,
and also to see the code coverage of the snippet in question.


Signed-off-by: Rogério Brito <rbrito@ime.usp.br>
Cc: Alexander Holler <holler@ahsoftware.de>
Cc: "Gustavo F. Padovan" <padovan@profusion.mobi>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>

---

Thanks for all the feedback on the previous patches. The one that didn't
compile before was sent without a hunk. This time everything all the
basics are verified.


diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
index a126e61..42fa531 100644
--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -106,6 +106,7 @@ static int ath3k_probe(struct usb_interface *intf,
 {
 	const struct firmware *firmware;
 	struct usb_device *udev = interface_to_usbdev(intf);
+	int ret;
 
 	BT_DBG("intf %p id %p", intf, id);
 
@@ -116,13 +117,10 @@ static int ath3k_probe(struct usb_interface *intf,
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

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org

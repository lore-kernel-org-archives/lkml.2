Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab2CXWjW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 18:39:22 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:22267 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab2CXWjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 18:39:20 -0400
Date: Sat, 24 Mar 2012 23:39:18 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        Sylwester Nawrocki <snjw23@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, trivial@kernel.org
Subject: [PATCH] staging/media/as102: Don't call release_firmware() on
 uninitialized variable
Message-ID: <alpine.LNX.2.00.1203242336340.8210@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If, in drivers/staging/media/as102/as102_fw.c::as102_fw_upload(), the call
	cmd_buf = kzalloc(MAX_FW_PKT_SIZE, GFP_KERNEL);
should fail and return NULL so that we jump to the 'error:' label,
then we'll end up calling 'release_firmware(firmware);' with
'firmware' still uninitialized - not good.

The easy fix is to just initialize 'firmware' to NULL when we declare
it, since release_firmware() deals gracefully with being passed NULL
pointers.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/media/as102/as102_fw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

 Only compile tested.

diff --git a/drivers/staging/media/as102/as102_fw.c b/drivers/staging/media/as102/as102_fw.c
index 43ebc43..1075fb1 100644
--- a/drivers/staging/media/as102/as102_fw.c
+++ b/drivers/staging/media/as102/as102_fw.c
@@ -165,7 +165,7 @@ error:
 int as102_fw_upload(struct as10x_bus_adapter_t *bus_adap)
 {
 	int errno = -EFAULT;
-	const struct firmware *firmware;
+	const struct firmware *firmware = NULL;
 	unsigned char *cmd_buf = NULL;
 	char *fw1, *fw2;
 	struct usb_device *dev = bus_adap->usb_dev;
-- 
1.7.9.4


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.


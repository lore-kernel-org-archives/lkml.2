Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933223Ab3AIUiQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:38:16 -0500
Received: from mail.kernel.org ([198.145.19.201]:41980 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933057Ab3AIUiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:38:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 027/123] rtlwifi: fix incorrect use of usb_alloc_coherent with usb_control_msg
Date: Wed,  9 Jan 2013 12:34:26 -0800
Message-Id: <20130109201501.990969304@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

commit 4c3de5920c486b8eefa6187ee6a181864c161100 upstream.

Incorrect use of usb_alloc_coherent memory as input buffer to usb_control_msg
can cause problems in arch DMA code, for example kernel BUG at
'arch/arm/include/asm/dma-mapping.h:321' on ARM (linux-3.4).

Change _usb_writeN_sync use kmalloc'd buffer instead.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rtlwifi/usb.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -210,17 +210,16 @@ static void _usb_writeN_sync(struct rtl_
 	u16 index = REALTEK_USB_VENQT_CMD_IDX;
 	int pipe = usb_sndctrlpipe(udev, 0); /* write_out */
 	u8 *buffer;
-	dma_addr_t dma_addr;
 
-	wvalue = (u16)(addr&0x0000ffff);
-	buffer = usb_alloc_coherent(udev, (size_t)len, GFP_ATOMIC, &dma_addr);
+	wvalue = (u16)(addr & 0x0000ffff);
+	buffer = kmalloc(len, GFP_ATOMIC);
 	if (!buffer)
 		return;
 	memcpy(buffer, data, len);
 	usb_control_msg(udev, pipe, request, reqtype, wvalue,
 			index, buffer, len, 50);
 
-	usb_free_coherent(udev, (size_t)len, buffer, dma_addr);
+	kfree(buffer);
 }
 
 static void _rtl_usb_io_handler_init(struct device *dev,



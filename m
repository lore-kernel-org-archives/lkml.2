Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab2ILXfy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:35:54 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37074 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756548Ab2ILXfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:35:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Oliver Neukum <oneukum@suse.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 085/108] usbnet: fix deadlock in resume
Date: Wed, 12 Sep 2012 16:29:23 -0700
Message-Id: <20120912232459.417462728@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912232450.500619493@linuxfoundation.org>
References: <20120912232816.GA1655@kroah.com>
 <20120912232450.500619493@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oliver@neukum.org>

commit ab6f148de28261682d300662e87b9477f7efc95b upstream.

A usbnet device can share a multifunction device
with a storage device. If the storage device is autoresumed
the usbnet devices also needs to be autoresumed. Allocating
memory with GFP_KERNEL can deadlock in this case.

This should go back into all kernels that have
commit 65841fd5132c3941cdf5df09e70df3ed28323212
That is 3.5

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/usb/usbnet.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1580,7 +1580,7 @@ int usbnet_resume (struct usb_interface
 				netif_device_present(dev->net) &&
 				!timer_pending(&dev->delay) &&
 				!test_bit(EVENT_RX_HALT, &dev->flags))
-					rx_alloc_submit(dev, GFP_KERNEL);
+					rx_alloc_submit(dev, GFP_NOIO);
 
 			if (!(dev->txq.qlen >= TX_QLEN(dev)))
 				netif_tx_wake_all_queues(dev->net);



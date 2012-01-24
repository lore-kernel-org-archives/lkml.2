Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443Ab2AXCqH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:46:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50337 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932368Ab2AXCp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:45:59 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:27 2012
Message-Id: <20120124023927.922193487@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:34:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        Grant Grundler <grundler@chromium.org>, Allan Chou <allan@asix.com.tw>,
        "David S. Miller" <davem@davemloft.net>
Subject: [045/129] asix: fix setting custom MAC address on Asix 88772 devices
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1513
Lines: 46

From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

commit 8ef66bdc4bda6aac2dae73b84d79dc8c2db33637 upstream.

In kernel v3.2 initialization sequence for Asix 88772 devices was changed so
that hardware is reseted on every time interface is brought up (ifconfig up),
instead just at USB probe time. This causes problem with setting custom MAC
address to device as ax88772_reset causes reload of MAC address from EEPROM.

This patch fixes the issue by rewriting MAC address at end of ax88772_reset.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Acked-by: Grant Grundler <grundler@chromium.org>
Cc: Allan Chou <allan@asix.com.tw>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/usb/asix.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/net/usb/asix.c
+++ b/drivers/net/usb/asix.c
@@ -974,6 +974,7 @@ static int ax88772_link_reset(struct usb
 
 static int ax88772_reset(struct usbnet *dev)
 {
+	struct asix_data *data = (struct asix_data *)&dev->data;
 	int ret, embd_phy;
 	u16 rx_ctl;
 
@@ -1051,6 +1052,13 @@ static int ax88772_reset(struct usbnet *
 		goto out;
 	}
 
+	/* Rewrite MAC address */
+	memcpy(data->mac_addr, dev->net->dev_addr, ETH_ALEN);
+	ret = asix_write_cmd(dev, AX_CMD_WRITE_NODE_ID, 0, 0, ETH_ALEN,
+							data->mac_addr);
+	if (ret < 0)
+		goto out;
+
 	/* Set RX_CTL to default values with 2k buffer, and enable cactus */
 	ret = asix_write_rx_ctl(dev, AX_DEFAULT_RX_CTL);
 	if (ret < 0)



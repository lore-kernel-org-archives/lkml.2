Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254Ab1CLWvQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 17:51:16 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57222 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab1CLWvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 17:51:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=d0g+cdlCcDHajPFKlT0vHbIr71IdQ95PYvcC5Y2CoDGEbuQSJLjaJbdQPaPMHVzY3G
         DuLGzlVuBJRM65XO5h+gciJj2Zvi4lKl7ypKSEH4R/3ykMxt5hECDgLTmmCJqE6TPWWn
         42rkxxV4QoPglTXs3BiFqfEGtfjR6//pBESOE=
From: Andy Green <andy@warmcat.com>
Subject: [RFC PATCH 5/5] USBNET: SMSC95XX: if mac set in platform data no need
 for random one
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: patches@linaro.org, Steve Glendinning <steve.glendinning@smsc.com>,
        Andy Green <andy.green@linaro.org>
Date: Sat, 12 Mar 2011 22:51:09 +0000
Message-ID: <20110312225109.27728.88417.stgit@otae.warmcat.com>
In-Reply-To: <20110312224440.27728.60593.stgit@otae.warmcat.com>
References: <20110312224440.27728.60593.stgit@otae.warmcat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is part of an RFC patch series introducing asynchronous platform
data, which may be attached to discovered bus devices at probe time
based on the device path.

As part of the series, platform_data is enabled in usbnet layer.

This patch allows smsc95xx usbnet driver to understand that the MAC
setting was handled by plaform_data sent into usbnet, and that it
does not need to overwrite the already correct MAC with a random one.

Cc: Steve Glendinning <steve.glendinning@smsc.com>
Signed-off-by: Andy Green <andy.green@linaro.org>
---

 drivers/net/usb/smsc95xx.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index bc86f4b..1d09cad 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -639,6 +639,16 @@ static int smsc95xx_ioctl(struct net_device *netdev, struct ifreq *rq, int cmd)
 
 static void smsc95xx_init_mac_address(struct usbnet *dev)
 {
+	struct usbnet_platform_data *pdata = dev->udev->dev.platform_data;
+
+	/*
+	 * if netdev platform data has taken responsibility for forcing
+	 * the MAC then nothing to do here
+	 */
+
+	if (pdata && pdata->flags & USBNET_PLATDATA_FLAG__USE_MAC)
+		return;
+
 	/* try reading mac address from EEPROM */
 	if (smsc95xx_read_eeprom(dev, EEPROM_MAC_OFFSET, ETH_ALEN,
 			dev->net->dev_addr) == 0) {


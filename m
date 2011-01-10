Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab1AJCXs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 21:23:48 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:63352 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab1AJCXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 21:23:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=RVjqPBtso8fNLlryhI+25wCGRp+s7O1zqhh/KtQQrcCT2Ct64VZFDPl29KZwKIt93h
         e6xyAxGJCl6pKg1tpIvAcxi3ET512WFOu8Cce6e+0ck8PO4Kw4Bt3HB+ssAO10uWd099
         yQ43NXAbFFR7l9XQZ/c87QPOGferpBtJ2HrL0=
Subject: [PATCH] iwmc3200wifi: Return proper error for iwm_if_alloc
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <samuel.ortiz@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>, Zhu Yi <yi.zhu@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain
Date: Mon, 10 Jan 2011 10:26:00 +0800
Message-Id: <1294626360.25455.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case of alloc_netdev_mq failure and kmalloc failure,
current implementation returns ERR_PTR(0).

As a result, the caller of iwm_if_alloc does not catch the error by IS_ERR
macro. Fix it by setting proper error code for ret variable in the failure
cases.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/net/wireless/iwmc3200wifi/netdev.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/netdev.c b/drivers/net/wireless/iwmc3200wifi/netdev.c
index 13a69eb..5091d77 100644
--- a/drivers/net/wireless/iwmc3200wifi/netdev.c
+++ b/drivers/net/wireless/iwmc3200wifi/netdev.c
@@ -126,6 +126,7 @@ void *iwm_if_alloc(int sizeof_bus, struct device *dev,
 	ndev = alloc_netdev_mq(0, "wlan%d", ether_setup, IWM_TX_QUEUES);
 	if (!ndev) {
 		dev_err(dev, "no memory for network device instance\n");
+		ret = -ENOMEM;
 		goto out_priv;
 	}
 
@@ -138,6 +139,7 @@ void *iwm_if_alloc(int sizeof_bus, struct device *dev,
 				    GFP_KERNEL);
 	if (!iwm->umac_profile) {
 		dev_err(dev, "Couldn't alloc memory for profile\n");
+		ret = -ENOMEM;
 		goto out_profile;
 	}
 
-- 
1.7.2




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab2DXXN6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 19:13:58 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:41084 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab2DXXN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 19:13:56 -0400
From: Krzysztof Wilczynski <krzysztof.wilczynski@linux.com>
To: Karsten Keil <isdn@linux-pingi.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Simon Horman <horms@verge.net.au>, Jiri Kosina <trivial@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mISDN: Ignore return value of driver_for_each_device in function hfcpci_softirq.
Date: Wed, 25 Apr 2012 00:13:50 +0100
Message-Id: <1335309230-23428-1-git-send-email-krzysztof.wilczynski@linux.com>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function hfcpci_softirq uses driver_for_each_device to call _hfcpci_softirq for
each device. Given that _hfcpci_softirq always returns 0, we collect this return
value and simply do nothing with it.  This is purely to address the following
warning during compilation time:

  drivers/isdn/hardware/mISDN/hfcpci.c: In function ‘hfcpci_softirq’:
  drivers/isdn/hardware/mISDN/hfcpci.c:2319: warning: ignoring return value of
    ‘driver_for_each_device’, declared with attribute warn_unused_result

Similar approach was used in function cx18_alsa_exit from "cx18-alsa-main.c".

Signed-off-by: Krzysztof Wilczynski <krzysztof.wilczynski@linux.com>
---
 drivers/isdn/hardware/mISDN/hfcpci.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
index e2c83a2..f0d0180 100644
--- a/drivers/isdn/hardware/mISDN/hfcpci.c
+++ b/drivers/isdn/hardware/mISDN/hfcpci.c
@@ -2316,8 +2316,11 @@ _hfcpci_softirq(struct device *dev, void *arg)
 static void
 hfcpci_softirq(void *arg)
 {
-	(void) driver_for_each_device(&hfc_driver.driver, NULL, arg,
-				      _hfcpci_softirq);
+	int ret;
+
+	/* Collect return value, but do not use it; suppress GCC warning ... */
+	ret = driver_for_each_device(&hfc_driver.driver, NULL, arg,
+				     _hfcpci_softirq);
 
 	/* if next event would be in the past ... */
 	if ((s32)(hfc_jiffies + tics - jiffies) <= 0)
-- 
1.7.2.5


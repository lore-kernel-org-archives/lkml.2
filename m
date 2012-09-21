Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289Ab2IUKZ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 06:25:28 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:2037 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753525Ab2IUKZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 06:25:26 -0400
Message-ID: <1348223124.1581.15.camel@x61.thuisdomein>
Subject: [PATCH] mISDN: suppress compiler warning
From: Paul Bolle <pebolle@tiscali.nl>
To: Karsten Keil <isdn@linux-pingi.de>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 21 Sep 2012 12:25:24 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-1.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Sep 2012 10:25:25.0178 (UTC) FILETIME=[69C941A0:01CD97E3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building the hfcpci driver triggers this GCC warning:
    drivers/isdn/hardware/mISDN/hfcpci.c:2298:2: warning: ignoring return value of 'driver_for_each_device', declared with attribute warn_unused_result [-Wunused-result]

That return value is apparently ignored because _hfcpci_softirq() will
always return 0. Suppress this warning in the way a few other drivers do
that too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) I noticed this warning while building v3.6-rc6 on current Fedora 17,
using Fedora's default config.

1) Compile tested only.

 drivers/isdn/hardware/mISDN/hfcpci.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
index 81363ff..a547c8c 100644
--- a/drivers/isdn/hardware/mISDN/hfcpci.c
+++ b/drivers/isdn/hardware/mISDN/hfcpci.c
@@ -2295,8 +2295,11 @@ _hfcpci_softirq(struct device *dev, void *arg)
 static void
 hfcpci_softirq(void *arg)
 {
-	(void) driver_for_each_device(&hfc_driver.driver, NULL, arg,
+	int ret;
+
+	ret = driver_for_each_device(&hfc_driver.driver, NULL, arg,
 				      _hfcpci_softirq);
+	(void)ret;	/* suppress compiler warning */
 
 	/* if next event would be in the past ... */
 	if ((s32)(hfc_jiffies + tics - jiffies) <= 0)
-- 
1.7.11.4


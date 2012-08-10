Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab2HJGUV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 02:20:21 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3186 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458Ab2HJGUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 02:20:18 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 09 Aug 2012 23:15:02 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <stern@rowland.harvard.edu>, <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH] usb: host: tegra: fix warning messages in ehci_remove
Date: Fri, 10 Aug 2012 11:42:43 +0530
Message-ID: <1344579163-10190-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Existing implementation of tegra_ehci_remove() calls
usb_put_hcd(hcd) first and then iounmap(hcd->regs).

usb_put_hcd() implementation calls hcd_release()
which frees up memory allocated for hcd.

As iounmap is trying to unmap hcd->regs, after hcd
getting freed up, warning messages were observed during
unload of USB.

Hence fixing it.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
 drivers/usb/host/ehci-tegra.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
index 950e95e..26dedb3 100644
--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@ -799,11 +799,12 @@ static int tegra_ehci_remove(struct platform_device *pdev)
 #endif
 
 	usb_remove_hcd(hcd);
-	usb_put_hcd(hcd);
 
 	tegra_usb_phy_close(tegra->phy);
 	iounmap(hcd->regs);
 
+	usb_put_hcd(hcd);
+
 	clk_disable_unprepare(tegra->clk);
 	clk_put(tegra->clk);
 
-- 
1.7.1.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611Ab2GLCyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 22:54:08 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:60088 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817Ab2GLCyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 22:54:05 -0400
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH v2] usb/host/ehci-hub: Fix the issue EG20T USB host controller has long resuming time, when pen drive is attached.
Date: Thu, 12 Jul 2012 11:53:37 +0900
Message-Id: <1342061617-5630-1-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1341966511-4373-1-git-send-email-tomoya.rohm@gmail.com>
References: <1341966511-4373-1-git-send-email-tomoya.rohm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel EG20T USB host controller does not send SOF in resuming time after suspending, if the FLR bit was not cleared. When pen drive is attached, the controller has a long resuming time to try re-connect it. This patch clear the FLR bit in suspending time for fixing the issue.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
v2: Update comments from Alan Stern
	Add patch description
	Always clear the STS_FLR flag.
---
 drivers/usb/host/ehci-hub.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
index fc9e7cc..818a2f1 100644
--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -318,6 +318,7 @@ static int ehci_bus_suspend (struct usb_hcd *hcd)
 	ehci_readl(ehci, &ehci->regs->intr_enable);
 
 	ehci->next_statechange = jiffies + msecs_to_jiffies(10);
+	ehci_writel(ehci, STS_FLR, &ehci->regs->status);
 	spin_unlock_irq (&ehci->lock);
 
 	/* ehci_work() may have re-enabled the watchdog timer, which we do not
-- 
1.7.4.4


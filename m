Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886Ab2INRF4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 13:05:56 -0400
Received: from mail-gg0-f202.google.com ([209.85.161.202]:45867 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757815Ab2INRFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 13:05:54 -0400
From: Michael Spang <spang@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Michael Spang <spang@chromium.org>
Subject: [PATCH] Increase XHCI suspend timeout to 16ms
Date: Fri, 14 Sep 2012 13:05:49 -0400
Message-Id: <1347642349-9397-1-git-send-email-spang@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Intel XHCI specification says that after clearing the run/stop bit
the controller may take up to 16ms to halt. We've seen a device take
14ms, which with the current timeout of 10ms causes the kernel to
abort the suspend. Increasing the timeout to the recommended value
fixes the problem.

Signed-off-by: Michael Spang <spang@chromium.org>
---
 drivers/usb/host/xhci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index c59d5b5..7710ccf 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -785,7 +785,7 @@ int xhci_suspend(struct xhci_hcd *xhci)
 	command &= ~CMD_RUN;
 	xhci_writel(xhci, command, &xhci->op_regs->command);
 	if (handshake(xhci, &xhci->op_regs->status,
-		      STS_HALT, STS_HALT, 100*100)) {
+		      STS_HALT, STS_HALT, XHCI_MAX_HALT_USEC)) {
 		xhci_warn(xhci, "WARN: xHC CMD_RUN timeout\n");
 		spin_unlock_irq(&xhci->lock);
 		return -ETIMEDOUT;
-- 
1.7.7.3


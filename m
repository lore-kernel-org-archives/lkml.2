Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284Ab2JNOyG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:54:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46648 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932167Ab2JNOnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:43:47 -0400
Message-Id: <20121014143541.181729196@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:36:27 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michael Spang <spang@chromium.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 054/147] Increase XHCI suspend timeout to 16ms
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Spang <spang@chromium.org>

commit a6e097dfdfd189b6929af6efa1d289af61858386 upstream.

The Intel XHCI specification says that after clearing the run/stop bit
the controller may take up to 16ms to halt. We've seen a device take
14ms, which with the current timeout of 10ms causes the kernel to
abort the suspend. Increasing the timeout to the recommended value
fixes the problem.

This patch should be backported to kernels as old as 2.6.37, that
contain the commit 5535b1d5f8885695c6ded783c692e3c0d0eda8ca "USB: xHCI:
PCI power management implementation".

Signed-off-by: Michael Spang <spang@chromium.org>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index a4b0ce1..52b04b0 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -888,7 +888,7 @@ int xhci_suspend(struct xhci_hcd *xhci)
 	command &= ~CMD_RUN;
 	xhci_writel(xhci, command, &xhci->op_regs->command);
 	if (handshake(xhci, &xhci->op_regs->status,
-		      STS_HALT, STS_HALT, 100*100)) {
+		      STS_HALT, STS_HALT, XHCI_MAX_HALT_USEC)) {
 		xhci_warn(xhci, "WARN: xHC CMD_RUN timeout\n");
 		spin_unlock_irq(&xhci->lock);
 		return -ETIMEDOUT;



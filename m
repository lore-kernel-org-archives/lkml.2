Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934311Ab2JDVZH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:25:07 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56720 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934252Ab2JDVY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:24:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Michael Spang <spang@chromium.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 32/52] Increase XHCI suspend timeout to 16ms
Date: Thu,  4 Oct 2012 14:21:23 -0700
Message-Id: <20121004210639.369058849@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121004210635.372689554@linuxfoundation.org>
References: <20121004210635.372689554@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -890,7 +890,7 @@ int xhci_suspend(struct xhci_hcd *xhci)
 	command &= ~CMD_RUN;
 	xhci_writel(xhci, command, &xhci->op_regs->command);
 	if (handshake(xhci, &xhci->op_regs->status,
-		      STS_HALT, STS_HALT, 100*100)) {
+		      STS_HALT, STS_HALT, XHCI_MAX_HALT_USEC)) {
 		xhci_warn(xhci, "WARN: xHC CMD_RUN timeout\n");
 		spin_unlock_irq(&xhci->lock);
 		return -ETIMEDOUT;



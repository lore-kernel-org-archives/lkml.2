Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932842Ab1KWAoL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:44:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43124 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932815Ab1KWAm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:42:59 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:24:08 2011
Message-Id: <20111123002407.989350266@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:23:43 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>
Subject: [36/53] USB: workaround for bug in old version of GCC
In-Reply-To: <20111123002419.GA8531@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 97ff22ee3b4cb3a334f7385e269773141aed702f upstream.

This patch (as1491) works around a bug in GCC-3.4.6, which is still
supposed to be supported.  The number of microseconds in the udelay()
call in quirk_usb_disable_ehci() is fixed at 100, but the compiler
doesn't understand this and generates a link-time error.  So we
replace the otherwise unused variable "delta" with a simple constant
100.  This same pattern is already used in other delay loops in that
source file.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Konrad Rzepecki <krzepecki@dentonet.pl>
Tested-by: Konrad Rzepecki <krzepecki@dentonet.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/pci-quirks.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -626,7 +626,7 @@ static void __devinit quirk_usb_disable_
 	void __iomem *base, *op_reg_base;
 	u32	hcc_params, cap, val;
 	u8	offset, cap_length;
-	int	wait_time, delta, count = 256/4;
+	int	wait_time, count = 256/4;
 
 	if (!mmio_resource_enabled(pdev, 0))
 		return;
@@ -672,11 +672,10 @@ static void __devinit quirk_usb_disable_
 		writel(val, op_reg_base + EHCI_USBCMD);
 
 		wait_time = 2000;
-		delta = 100;
 		do {
 			writel(0x3f, op_reg_base + EHCI_USBSTS);
-			udelay(delta);
-			wait_time -= delta;
+			udelay(100);
+			wait_time -= 100;
 			val = readl(op_reg_base + EHCI_USBSTS);
 			if ((val == ~(u32)0) || (val & EHCI_USBSTS_HALTED)) {
 				break;



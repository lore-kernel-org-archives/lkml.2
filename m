Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab2CMPWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 11:22:08 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57002 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143Ab2CMPWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 11:22:05 -0400
From: "Manjunathappa, Prakash" <prakash.pm@ti.com>
To: <davinci-linux-open-source@linux.davincidsp.com>
CC: <nsekhar@ti.com>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        "Manjunathappa, Prakash" <prakash.pm@ti.com>,
        Ajay Kumar Gupta <ajay.gupta@ti.com>
Subject: [PATCH] arm:da850: register musb device
Date: Tue, 13 Mar 2012 20:33:35 +0530
Message-ID: <1331651015-32586-1-git-send-email-prakash.pm@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Properly set up the OTG mode thru the CFGCHIP2 register, enable the
USB0_DRVVBUS pin, and finally register the MUSB platform device.

Signed-off-by: Ajay Kumar Gupta <ajay.gupta@ti.com>
Signed-off-by: Manjunathappa, Prakash <prakash.pm@ti.com>
---
Patche are on top below posted patches:
http://www.spinics.net/lists/linux-usb/msg59656.html

 arch/arm/mach-davinci/board-da850-evm.c |   12 ++++++++++++
 arch/arm/mach-davinci/usb.c             |    9 +++++++++
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index 178d178..539e12c 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -787,6 +787,18 @@ static __init void da850_evm_usb_init(void)
 	 */
 	cfgchip2 &= ~CFGCHIP2_USB1PHYCLKMUX;
 	cfgchip2 |=  CFGCHIP2_USB2PHYCLKMUX;
+	/*
+	 * We have to override VBUS/ID signals when MUSB is configured into the
+	 * host-only mode -- ID pin will float if no cable is connected, so the
+	 * controller won't be able to drive VBUS thinking that it's a B-device.
+	 * Otherwise, we want to use the OTG mode and enable VBUS comparators.
+	 */
+	cfgchip2 &= ~CFGCHIP2_OTGMODE;
+#if CONFIG_USB_MUSB_DA8XX
+	cfgchip2 |=  CFGCHIP2_FORCE_HOST;
+#else
+	cfgchip2 |=  CFGCHIP2_SESENDEN | CFGCHIP2_VBDTCTEN;
+#endif
 
 	__raw_writel(cfgchip2, DA8XX_SYSCFG0_VIRT(DA8XX_CFGCHIP2_REG));
 
diff --git a/arch/arm/mach-davinci/usb.c b/arch/arm/mach-davinci/usb.c
index 25c3520..a941dc5 100644
--- a/arch/arm/mach-davinci/usb.c
+++ b/arch/arm/mach-davinci/usb.c
@@ -284,6 +284,15 @@ void __init da8xx_board_usb_init(const short pins[],
 		goto usb11_setup_fail;
 	}
 
+	/*
+	 * TPS2065 switch @ 5V supplies 1 A (sustains 1.5 A),
+	 * with the power on to power good time of 3 ms.
+	 */
+	ret = da8xx_register_usb20(1000, 3);
+	if (ret)
+		pr_warning("%s: USB 2.0 registration failed: %d\n",
+			   __func__, ret);
+
 	return;
 
 usb11_setup_fail:
-- 
1.7.1


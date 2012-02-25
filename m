Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998Ab2BYQCZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 11:02:25 -0500
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:42160
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755050Ab2BYQCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 11:02:24 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Shengzhou Liu <Shengzhou.Liu@freescale.com>
To: <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>,
        Shengzhou Liu <Shengzhou.Liu@freescale.com>
Subject: [PATCH] powerpc/usb: fix usb CTRL_PHY_CLK_VALID breaks on some platform
Date: Sat, 25 Feb 2012 23:56:30 +0800
Message-ID: <1330185390-30614-1-git-send-email-Shengzhou.Liu@freescale.com>
X-Mailer: git-send-email 1.7.5.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checking of CTRL_PHY_CLK_VALID bit break on some platform on which
there is not USB CTRL_PHY_CLK_VALID bit.
  - P1023/P3041/P5020 etc,have this bit
  - P3060/4080/PSC913x do have this bit, but not mentioned in RM.
  - P1022(perhaps and other) has no this bit

Signed-off-by: Shengzhou Liu <Shengzhou.Liu@freescale.com>
---
 drivers/usb/host/ehci-fsl.c |   24 ++++++++++++++----------
 1 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/host/ehci-fsl.c b/drivers/usb/host/ehci-fsl.c
index c26a82e..5ba3ea4 100644
--- a/drivers/usb/host/ehci-fsl.c
+++ b/drivers/usb/host/ehci-fsl.c
@@ -244,7 +244,11 @@ static int ehci_fsl_usb_setup(struct ehci_hcd *ehci)
 	struct usb_hcd *hcd = ehci_to_hcd(ehci);
 	struct fsl_usb2_platform_data *pdata;
 	void __iomem *non_ehci = hcd->regs;
-	u32 temp;
+	u32 temp, chip, rev, svr;
+
+	svr = mfspr(SPRN_SVR);
+	chip = svr >> 16;
+	rev = (svr >> 4) & 0xf;
 
 	pdata = hcd->self.controller->platform_data;
 
@@ -273,12 +277,6 @@ static int ehci_fsl_usb_setup(struct ehci_hcd *ehci)
 		ehci_fsl_setup_phy(ehci, pdata->phy_mode, 0);
 
 	if (pdata->operating_mode == FSL_USB2_MPH_HOST) {
-		unsigned int chip, rev, svr;
-
-		svr = mfspr(SPRN_SVR);
-		chip = svr >> 16;
-		rev = (svr >> 4) & 0xf;
-
 		/* Deal with USB Erratum #14 on MPC834x Rev 1.0 & 1.1 chips */
 		if ((rev == 1) && (chip >= 0x8050) && (chip <= 0x8055))
 			ehci->has_fsl_port_bug = 1;
@@ -300,9 +298,15 @@ static int ehci_fsl_usb_setup(struct ehci_hcd *ehci)
 		out_be32(non_ehci + FSL_SOC_USB_SICTRL, 0x00000001);
 	}
 
-	if (!(in_be32(non_ehci + FSL_SOC_USB_CTRL) & CTRL_PHY_CLK_VALID)) {
-		printk(KERN_WARNING "fsl-ehci: USB PHY clock invalid\n");
-		return -ENODEV;
+	/* There is no CTRL_PHY_CLK_VALID bit on some platforms, e.g. P1022 */
+#define SVR_P1022_N_ID 0x80E6
+#define SVR_P1022_S_ID 0x80EE
+	if (chip != SVR_P1022_N_ID && chip != SVR_P1022_S_ID) {
+		if (!(in_be32(non_ehci + FSL_SOC_USB_CTRL) &
+					CTRL_PHY_CLK_VALID)) {
+			printk(KERN_WARNING "fsl-ehci: USB PHY clock invalid\n");
+			return -ENODEV;
+		}
 	}
 	return 0;
 }
-- 
1.7.0.4



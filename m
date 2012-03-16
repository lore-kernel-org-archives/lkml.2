Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760797Ab2CPJ3B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 05:29:01 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:11241
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760682Ab2CPJ27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 05:28:59 -0400
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839hd24h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: <linuxppc-dev@lists.ozlabs.org>
CC: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <leoli@freescale.com>
Subject: [PATCH] fsl_pmc: update device bindings
Date: Fri, 16 Mar 2012 17:31:02 +0800
Message-ID: <1331890262-25391-1-git-send-email-chenhui.zhao@freescale.com>
X-Mailer: git-send-email 1.6.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Yang <leoli@freescale.com>

 * Added compatible "fsl,p1022-pmc".
 * Added clock nodes to control the clock of wake-up source.
 * Used "fsl,pmc-handle" property to connect device and clock node.

Signed-off-by: Li Yang <leoli@freescale.com>
Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
---
 .../devicetree/bindings/powerpc/fsl/pmc.txt        |   65 ++++++++++++--------
 1 files changed, 40 insertions(+), 25 deletions(-)

diff --git a/Documentation/devicetree/bindings/powerpc/fsl/pmc.txt b/Documentation/devicetree/bindings/powerpc/fsl/pmc.txt
index 07256b7..d296e88 100644
--- a/Documentation/devicetree/bindings/powerpc/fsl/pmc.txt
+++ b/Documentation/devicetree/bindings/powerpc/fsl/pmc.txt
@@ -9,22 +9,26 @@ Properties:
 
   "fsl,mpc8548-pmc" should be listed for any chip whose PMC is
   compatible.  "fsl,mpc8536-pmc" should also be listed for any chip
-  whose PMC is compatible, and implies deep-sleep capability.
+  whose PMC is compatible, and implies deep-sleep capability and
+  wake on user defined packet(wakeup on ARP). "fsl,p1022-pmc"
+  should be listed for any chip whose PMC is compatible, and
+  implies lossless Ethernet capability during sleep or deep sleep.
 
   "fsl,mpc8641d-pmc" should be listed for any chip whose PMC is
   compatible; all statements below that apply to "fsl,mpc8548-pmc" also
   apply to "fsl,mpc8641d-pmc".
 
   Compatibility does not include bit assignments in SCCR/PMCDR/DEVDISR; these
-  bit assignments are indicated via the sleep specifier in each device's
-  sleep property.
+  bit assignments are indicated via the clock nodes. Device which has a
+  controllable clock source should have a "fsl,pmc-handle" property pointing
+  to the clock node.
 
 - reg: For devices compatible with "fsl,mpc8349-pmc", the first resource
   is the PMC block, and the second resource is the Clock Configuration
   block.
 
-  For devices compatible with "fsl,mpc8548-pmc", the first resource
-  is a 32-byte block beginning with DEVDISR.
+  For devices compatible with "fsl,mpc8548-pmc", the resource is a 32-byte
+  block beginning with the register DEVDISR.
 
 - interrupts: For "fsl,mpc8349-pmc"-compatible devices, the first
   resource is the PMC block interrupt.
@@ -33,31 +37,42 @@ Properties:
   this is a phandle to an "fsl,gtm" node on which timer 4 can be used as
   a wakeup source from deep sleep.
 
-Sleep specifiers:
-
-  fsl,mpc8349-pmc: Sleep specifiers consist of one cell.  For each bit
-  that is set in the cell, the corresponding bit in SCCR will be saved
-  and cleared on suspend, and restored on resume.  This sleep controller
-  supports disabling and resuming devices at any time.
-
-  fsl,mpc8536-pmc: Sleep specifiers consist of three cells, the third of
-  which will be ORed into PMCDR upon suspend, and cleared from PMCDR
-  upon resume.  The first two cells are as described for fsl,mpc8578-pmc.
-  This sleep controller only supports disabling devices during system
-  sleep, or permanently.
+Clock nodes:
+The clock nodes are to describe the masks in PM controller registers for each
+soc clock.
+- fsl,pmcdr-mask: For "fsl,mpc8548-pmc"-compatible devices, some blocks as
+  wake-up sources can run in low power mode. If a block used as a wake-up
+  source in low power mode, the corresponding bit in the register PMCDR should
+  be cleared on suspend and set on resume. If setting bits of the mask,
+  the corresponding blocks will be used as wake-up sources.
 
-  fsl,mpc8548-pmc: Sleep specifiers consist of one or two cells, the
-  first of which will be ORed into DEVDISR (and the second into
-  DEVDISR2, if present -- this cell should be zero or absent if the
-  hardware does not have DEVDISR2) upon a request for permanent device
-  disabling.  This sleep controller does not support configuring devices
-  to disable during system sleep (unless supported by another compatible
-  match), or dynamically.
+- fsl,sccr-mask: For "fsl,mpc8349-pmc"-compatible devices, the corresponding
+  bit specified by the mask in SCCR will be saved and cleared on suspend, and
+  restored on resume.
 
-Example:
+- fsl,devdisr-mask: Contain one or two cells, depending on the availability of
+  DEVDISR2 register.  For compatible devices, the mask will be ORed into DEVDISR
+  or DEVDISR2 when the clock should be permenently disabled.
 
+Example 1:
 	power@b00 {
 		compatible = "fsl,mpc8313-pmc", "fsl,mpc8349-pmc";
 		reg = <0xb00 0x100 0xa00 0x100>;
 		interrupts = <80 8>;
 	};
+
+Example 2:
+	power@e0070 {
+		compatible = "fsl,mpc8548-pmc", "fsl,mpc8536-pmc";
+		reg = <0xe0070 0x20>;
+
+		etsec1_clk: soc-clk@24 {
+			fsl,pmcdr-mask = <0x00000080>;
+		};
+		etsec2_clk: soc-clk@25 {
+			fsl,pmcdr-mask = <0x00000040>;
+		};
+		etsec3_clk: soc-clk@26 {
+			fsl,pmcdr-mask = <0x00000020>;
+		};
+	};
-- 
1.6.4.1



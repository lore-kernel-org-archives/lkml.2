Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab2KUJsH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 04:48:07 -0500
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:21811
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751051Ab2KUJsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 04:48:04 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzd799hc8kzz1de0h1202h1d1ah1d2ahzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1155h)
From: <b29237@freescale.com>
To: <dan.j.williams@gmail.com>, <vinod.koul@intel.com>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
CC: <iws@ovro.caltech.edu>, Xuelin Shi <b29237@freescale.com>,
        Harninder Rai <harninder.rai@freescale.com>,
        Naveen Burmi <naveenburmi@freescale.com>
Subject: [PATCH 1/2] powerpc/dma/raidengine: add raidengine device
Date: Wed, 21 Nov 2012 17:01:20 +0800
Message-ID: <1353488481-14371-1-git-send-email-b29237@freescale.com>
X-Mailer: git-send-email 1.7.5.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xuelin Shi <b29237@freescale.com>

The RaidEngine is a new Freescale hardware that used for parity
computation offloading in RAID5/6.

This patch adds the device node in device tree and related binding
documentation.

Signed-off-by: Harninder Rai <harninder.rai@freescale.com>
Signed-off-by: Naveen Burmi <naveenburmi@freescale.com>
Signed-off-by: Xuelin Shi <b29237@freescale.com>
---
 .../devicetree/bindings/powerpc/fsl/raideng.txt    |   81 +++++++++++++++++++
 arch/powerpc/boot/dts/fsl/p5020si-post.dtsi        |    1 +
 arch/powerpc/boot/dts/fsl/p5020si-pre.dtsi         |    6 ++
 arch/powerpc/boot/dts/fsl/qoriq-raid1.0-0.dtsi     |   85 ++++++++++++++++++++
 4 files changed, 173 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/powerpc/fsl/raideng.txt
 create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-raid1.0-0.dtsi

diff --git a/Documentation/devicetree/bindings/powerpc/fsl/raideng.txt b/Documentation/devicetree/bindings/powerpc/fsl/raideng.txt
new file mode 100644
index 0000000..4ad29b9
--- /dev/null
+++ b/Documentation/devicetree/bindings/powerpc/fsl/raideng.txt
@@ -0,0 +1,81 @@
+* Freescale 85xx RAID Engine nodes
+
+RAID Engine nodes are defined to describe on-chip RAID accelerators.  Each RAID
+Engine should have a separate node.
+
+Supported chips:
+P5020, P5040
+
+Required properties:
+
+- compatible:	Should contain "fsl,raideng-v1.0" as the value
+		This identifies RAID Engine block. 1 in 1.0 represents
+		major number whereas 0 represents minor number. The
+		version matches the hardware IP version.
+- reg:		offset and length of the register set for the device
+- ranges:	standard ranges property specifying the translation
+		between child address space and parent address space
+
+Example:
+	/* P5020 */
+	raideng: raideng@320000 {
+		compatible = "fsl,raideng-v1.0";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		reg	= <0x320000 0x10000>;
+		ranges	= <0 0x320000 0x10000>;
+	};
+
+
+There must be a sub-node for each job queue present in RAID Engine
+This node must be a sub-node of the main RAID Engine node
+
+- compatible:	Should contain "fsl,raideng-v1.0-job-queue" as the value
+		This identifies the job queue interface
+- reg:		offset and length of the register set for job queue
+- ranges:	standard ranges property specifying the translation
+		between child address space and parent address space
+
+Example:
+	/* P5020 */
+	raideng_jq0@1000 {
+		compatible = "fsl,raideng-v1.0-job-queue";
+		reg	   = <0x1000 0x1000>;
+		ranges	   = <0x0 0x1000 0x1000>;
+	};
+
+
+There must be a sub-node for each job ring present in RAID Engine
+This node must be a sub-node of job queue node
+
+- compatible:	Must contain "fsl,raideng-v1.0-job-ring" as the value
+		This identifies job ring. Should contain either
+		"fsl,raideng-v1.0-hp-ring" or "fsl,raideng-v1.0-lp-ring"
+		depending upon whether ring has high or low priority
+- reg:		offset and length of the register set for job ring
+- interrupts:	interrupt mapping for job ring IRQ
+
+Optional property:
+
+- fsl,liodn:	Specifies the LIODN to be used for Job Ring. This
+		property is normally set by firmware. Value
+		is of 12-bits which is the LIODN number for this JR.
+		This property is used by the IOMMU (PAMU) to distinquish
+		transactions from this JR and than be able to do address
+		translation & protection accordingly.
+
+Example:
+	/* P5020 */
+	raideng_jq0@1000 {
+		compatible = "fsl,raideng-v1.0-job-queue";
+		reg	   = <0x1000 0x1000>;
+		ranges	   = <0x0 0x1000 0x1000>;
+
+		raideng_jr0: jr@0 {
+			compatible = "fsl,raideng-v1.0-job-ring", "fsl,raideng-v1.0-hp-ring";
+			reg	   = <0x0 0x400>;
+			interrupts = <139 2 0 0>;
+			interrupt-parent = <&mpic>;
+			fsl,liodn = <0x41>;
+		};
+	};
diff --git a/arch/powerpc/boot/dts/fsl/p5020si-post.dtsi b/arch/powerpc/boot/dts/fsl/p5020si-post.dtsi
index 64b6abe..5d7205b 100644
--- a/arch/powerpc/boot/dts/fsl/p5020si-post.dtsi
+++ b/arch/powerpc/boot/dts/fsl/p5020si-post.dtsi
@@ -354,4 +354,5 @@
 /include/ "qoriq-sata2-0.dtsi"
 /include/ "qoriq-sata2-1.dtsi"
 /include/ "qoriq-sec4.2-0.dtsi"
+/include/ "qoriq-raid1.0-0.dtsi"
 };
diff --git a/arch/powerpc/boot/dts/fsl/p5020si-pre.dtsi b/arch/powerpc/boot/dts/fsl/p5020si-pre.dtsi
index 0a198b0..8df47fc 100644
--- a/arch/powerpc/boot/dts/fsl/p5020si-pre.dtsi
+++ b/arch/powerpc/boot/dts/fsl/p5020si-pre.dtsi
@@ -73,6 +73,12 @@
 		rtic_c = &rtic_c;
 		rtic_d = &rtic_d;
 		sec_mon = &sec_mon;
+
+		raideng = &raideng;
+		raideng_jr0 = &raideng_jr0;
+		raideng_jr1 = &raideng_jr1;
+		raideng_jr2 = &raideng_jr2;
+		raideng_jr3 = &raideng_jr3;
 	};
 
 	cpus {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-raid1.0-0.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-raid1.0-0.dtsi
new file mode 100644
index 0000000..8d2e8aa
--- /dev/null
+++ b/arch/powerpc/boot/dts/fsl/qoriq-raid1.0-0.dtsi
@@ -0,0 +1,85 @@
+/*
+ * QorIQ RAID 1.0 device tree stub [ controller @ offset 0x320000 ]
+ *
+ * Copyright 2012 Freescale Semiconductor Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are met:
+ *     * Redistributions of source code must retain the above copyright
+ *       notice, this list of conditions and the following disclaimer.
+ *     * Redistributions in binary form must reproduce the above copyright
+ *       notice, this list of conditions and the following disclaimer in the
+ *       documentation and/or other materials provided with the distribution.
+ *     * Neither the name of Freescale Semiconductor nor the
+ *       names of its contributors may be used to endorse or promote products
+ *       derived from this software without specific prior written permission.
+ *
+ *
+ * ALTERNATIVELY, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") as published by the Free Software
+ * Foundation, either version 2 of that License or (at your option) any
+ * later version.
+ *
+ * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
+ * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
+ * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
+ * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
+ * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
+ * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
+ * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
+ * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
+ * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+raideng: raideng@320000 {
+	compatible = "fsl,raideng-v1.0";
+	#address-cells = <1>;
+	#size-cells = <1>;
+	reg = <0x320000 0x10000>;
+	ranges = <0 0x320000 0x10000>;
+
+	raideng_jq0@1000 {
+		compatible = "fsl,raideng-v1.0-job-queue";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		reg = <0x1000 0x1000>;
+		ranges = <0x0 0x1000 0x1000>;
+
+		raideng_jr0: jr@0 {
+			compatible = "fsl,raideng-v1.0-job-ring", "fsl,raideng-v1.0-hp-ring";
+			reg = <0x0 0x400>;
+			interrupts = <139 2 0 0>;
+			interrupt-parent = <&mpic>;
+		};
+
+		raideng_jr1: jr@400 {
+			compatible = "fsl,raideng-v1.0-job-ring", "fsl,raideng-v1.0-lp-ring";
+			reg = <0x400 0x400>;
+			interrupts = <140 2 0 0>;
+			interrupt-parent = <&mpic>;
+		};
+	};
+
+	raideng_jq1@2000 {
+		compatible = "fsl,raideng-v1.0-job-queue";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		reg = <0x2000 0x1000>;
+		ranges = <0x0 0x2000 0x1000>;
+
+		raideng_jr2: jr@0 {
+			compatible = "fsl,raideng-v1.0-job-ring", "fsl,raideng-v1.0-hp-ring";
+			reg = <0x0 0x400>;
+			interrupts = <141 2 0 0>;
+			interrupt-parent = <&mpic>;
+		};
+
+		raideng_jr3: jr@400 {
+			compatible = "fsl,raideng-v1.0-job-ring", "fsl,raideng-v1.0-lp-ring";
+			reg = <0x400 0x400>;
+			interrupts = <142 2 0 0>;
+			interrupt-parent = <&mpic>;
+		};
+	};
+};
-- 
1.7.9.5



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934221Ab3AIUnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:43:42 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:62346 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934210Ab3AIUni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:43:38 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-tegra@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: [PATCH 12/14] ARM: tegra: tec: Add PCIe support
Date: Wed,  9 Jan 2013 21:43:12 +0100
Message-Id: <1357764194-12677-13-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:EjgDFW26M3f9R4kn/lQcr3AUj5eT1d7fPWbyao2MsUJ
 ZSrdKDr4NZ9uwLm75No/vbF8QtHM3OwleCxMqpH4fNimsgEMWH
 4NVVMZOhVTWz5nJ0k0TEbrcQU3+tQP8e86qZtz2Hky5ADkLBs9
 rdJsDBL+iCg7TrQ6aYv+yOUTiu7kjmq4QQT7ip4k2RaNlsbCu/
 Dfg7b1dyfOgk3N4H7Q3J3oYbMjN4l8mrSaW23ENkF9qQ3tO32y
 Da0FWqb8KYSqVM6GyPj8AUgOGPcYe9WVV7WVsS1VUgBFF7v1Xk
 8oZLAxq+a7uL3AXpfWq/jYI9Ij9bq2aK896/KRx80i547LyVsG
 9iNFlZMJs9VcpT2gHjf0zEoAQV9rbP0pQEIoEhGa+OpiZ/95zn
 JZlmCyQVY3Xzip1T8jScX97CVsghNfAOqHQ/+MVhO0SNrjr4Mv
 F4Kji
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable the first PCIe root port which is connected to an FPGA on the
Tamonten Evaluation Carrier and add device nodes for each of the PCI
endpoints available in the standard configuration.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 arch/arm/boot/dts/tegra20-tec.dts | 198 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 198 insertions(+)

diff --git a/arch/arm/boot/dts/tegra20-tec.dts b/arch/arm/boot/dts/tegra20-tec.dts
index 25f70ee..b75f979 100644
--- a/arch/arm/boot/dts/tegra20-tec.dts
+++ b/arch/arm/boot/dts/tegra20-tec.dts
@@ -60,6 +60,204 @@
 		};
 	};
 
+	pcie-controller {
+		vdd-supply = <&pci_vdd_reg>;
+		pex-clk-supply = <&pci_clk_reg>;
+		status = "okay";
+
+		pci@1,0 {
+			bus-range = <0x01 0x0a>;
+			status = "okay";
+
+			pci@0,0 {
+				reg = <0x010000 0 0 0 0>;
+				bus-range = <0x02 0x0a>;
+
+				compatible = "plda,pcie";
+				device_type = "pci";
+
+				#address-cells = <3>;
+				#size-cells = <2>;
+
+				pci@0,0 {
+					reg = <0x020000 0 0 0 0>;
+					bus-range = <0x03 0x03>;
+
+					compatible = "ad,pcie";
+					device_type = "pci";
+
+					#address-cells = <3>;
+					#size-cells = <2>;
+
+					pci-test-ep@0,0 {
+						compatible = "ad,pcietest";
+						reg = <0x030000 0 0 0 0>;
+					};
+				};
+
+				pci@1,0 {
+					reg = <0x020800 0 0 0 0>;
+					bus-range = <0x04 0x04>;
+
+					compatible = "ad,pcie";
+					device_type = "pci";
+
+					#address-cells = <3>;
+					#size-cells = <2>;
+
+					pci@0,0 {
+						compatible = "opencores,spi";
+						reg = <0x040000 0 0 0 0>;
+
+						#address-cells = <1>;
+						#size-cells = <0>;
+
+						clock-frequency = <66000000>;
+
+						m25p80@0 {
+							compatible = "m25p80";
+							reg = <0>;
+
+							spi-max-frequency = <25000000>;
+
+							#address-cells = <1>;
+							#size-cells = <1>;
+
+							partition@0 {
+								reg = <0x00000000 0x00400000>;
+								label = "FPGA";
+							};
+
+							partition@400000 {
+								reg = <0x00400000 0x00400000>;
+								label = "FPGA (gold)";
+								read-only;
+							};
+						};
+					};
+				};
+
+				pci@2,0 {
+					reg = <0x021000 0 0 0 0>;
+					bus-range = <0x05 0x05>;
+
+					compatible = "ad,pcie";
+					device_type = "pci";
+
+					#address-cells = <3>;
+					#size-cells = <2>;
+
+					pci-i2c-ep@0,0 {
+						compatible = "opencores,i2c";
+						reg = <0x050000 0 0 0 0>;
+
+						clock-frequency = <66000000>;
+						reg-io-width = <4>;
+						reg-shift = <3>;
+					};
+				};
+
+				pci@3,0 {
+					reg = <0x021800 0 0 0 0>;
+					bus-range = <0x06 0x06>;
+
+					compatible = "ad,pcie";
+					device_type = "pci";
+
+					#address-cells = <3>;
+					#size-cells = <2>;
+
+					pci@0,0 {
+						compatible = "ad,gpio-ad64p";
+						reg = <0x060000 0 0 0 0>;
+
+						gpio-controller;
+						#gpio-cells = <2>;
+
+						interrupt-controller;
+						#interrupt-cells = <2>;
+					};
+				};
+
+				pci@4,0 {
+					reg = <0x022000 0 0 0 0>;
+					bus-range = <0x07 0x07>;
+
+					compatible = "ad,pcie";
+					device_type = "pci";
+
+					#address-cells = <3>;
+					#size-cells = <2>;
+
+					pci@0,0 {
+						compatible = "opencores,uart";
+						reg = <0x070000 0 0 0 0>;
+					};
+				};
+
+				pci@5,0 {
+					reg = <0x022800 0 0 0 0>;
+					bus-range = <0x08 0x08>;
+
+					compatible = "ad,pcie";
+					device_type = "pci";
+
+					#address-cells = <3>;
+					#size-cells = <2>;
+
+					pci@0,0 {
+						compatible = "opencores,ethmac";
+						reg = <0x080000 0 0 0 0>;
+					};
+				};
+
+				pci@6,0 {
+					reg = <0x023000 0 0 0 0>;
+					bus-range = <0x09 0x09>;
+
+					compatible = "ad,pcie";
+					device_type = "pci";
+
+					#address-cells = <3>;
+					#size-cells = <2>;
+
+					pci@0,0 {
+						compatible = "opencores,can";
+						reg = <0x090000 0 0 0 0>;
+					};
+				};
+
+				pci@7,0 {
+					reg = <0x023800 0 0 0 0>;
+					bus-range = <0x0a 0x0a>;
+
+					compatible = "ad,pcie";
+					device_type = "pci";
+
+					#address-cells = <3>;
+					#size-cells = <2>;
+
+					pci@0,0 {
+						compatible = "opencores,can";
+						reg = <0x0a0000 0 0 0 0>;
+					};
+				};
+			};
+		};
+	};
+
+	regulators {
+		pci_vdd_reg: regulator@1 {
+			compatible = "regulator-fixed";
+			reg = <1>;
+			regulator-name = "vdd_1v05";
+			regulator-min-microvolt = <1050000>;
+			regulator-max-microvolt = <1050000>;
+			gpio = <&pmic 2 0>;
+			enable-active-high;
+		};
+	};
+
 	sound {
 		compatible = "ad,tegra-audio-wm8903-tec",
 			     "nvidia,tegra-audio-wm8903";
-- 
1.8.1


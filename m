Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344Ab2LJTme (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 14:42:34 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:20564 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218Ab2LJTm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 14:42:28 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-9c-50c63b235f98
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: g.liakhovetski@gmx.de, linux-media@vger.kernel.org
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com,
        thomas.abraham@linaro.org, t.figa@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH RFC 08/13] media: add V4L2 DT binding documentation
Date: Mon, 10 Dec 2012 20:41:34 +0100
Message-id: <1355168499-5847-9-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1355168499-5847-1-git-send-email-s.nawrocki@samsung.com>
References: <1355168499-5847-1-git-send-email-s.nawrocki@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGJMWRmVeSWpSXmKPExsVy+t9jQV1l62MBBtO+clpc3jWHzaJnw1ZW
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDJ2TV/EVnBZp+La1MAGxn1KXYycHBICJhJrjjSxQ9hi
	EhfurWfrYuTiEBKYziix+e4rdging0ni6Pp2JpAqNgFDid6jfYwgtoiAmcS7zscsIEXMAg8Z
	JT6/6mcBSQgLOEus/riHFcRmEVCVuPZoL1gzr4CrxOftd4BqOIDWKUjMmWQDEuYUcJN4fagV
	bKYQUMmPmeuYJzDyLmBkWMUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kR7PtnUjsYVzZYHGIU
	4GBU4uHV0DoWIMSaWFZcmXuIUYKDWUmEN0ICKMSbklhZlVqUH19UmpNafIhRmoNFSZy32SMl
	QEggPbEkNTs1tSC1CCbLxMEp1cDoYzbjxI/+rVNP/i+9bi6hZ/jy8rdH82fcaJ1jtuTAKYEC
	K+uqFcY3Vy77rhow0X22i9OsgMOu/JoNu45V6hjOvq20xPGOxzO1OgErLWu79QKy+79MaPok
	FR8jxGgrtfxR/f+6XUd9TLilE+Q23Rbe3/km4fherhXzDwgV7CjQ/bSiS3j+1sMJSizFGYmG
	WsxFxYkAOwPIhvkBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

This patch adds a document, describing common V4L2 device tree bindings.

Co-authored-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 Documentation/devicetree/bindings/media/v4l2.txt |  162 ++++++++++++++++++++++
 1 file changed, 162 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/v4l2.txt

diff --git a/Documentation/devicetree/bindings/media/v4l2.txt b/Documentation/devicetree/bindings/media/v4l2.txt
new file mode 100644
index 0000000..b8b3f41
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/v4l2.txt
@@ -0,0 +1,162 @@
+Video4Linux Version 2 (V4L2)
+
+General concept
+---------------
+
+Video pipelines consist of external devices, e.g. camera sensors, controlled
+over an I2C, SPI or UART bus, and SoC internal IP blocks, including video DMA
+engines and video data processors.
+
+SoC internal blocks are described by DT nodes, placed similarly to other SoC
+blocks. External devices are represented as child nodes of their respective bus
+controller nodes, e.g. I2C.
+
+Data interfaces on all video devices are described by "port" child DT nodes.
+Configuration of a port depends on other devices participating in the data
+transfer and is described by "link" DT nodes, specified as children of the
+"port" nodes:
+
+/foo {
+	port@0 {
+		link@0 { ... };
+		link@1 { ... };
+	};
+	port@1 { ... };
+};
+
+If a port can be configured to work with more than one other device on the same
+bus, a "link" child DT node must be provided for each of them. If more than one
+port is present on a device or more than one link is connected to a port, a
+common scheme, using "#address-cells," "#size-cells" and "reg" properties is
+used.
+
+Optional link properties:
+- remote: phandle to the other endpoint link DT node.
+- slave-mode: a boolean property, run the link in slave mode. Default is master
+  mode.
+- data-shift: on parallel data busses, if data-width is used to specify the
+  number of data lines, data-shift can be used to specify which data lines are
+  used, e.g. "data-width=<10>; data-shift=<2>;" means, that lines 9:2 are used.
+- hsync-active: 1 or 0 for active-high or -low HSYNC signal polarity
+  respectively.
+- vsync-active: ditto for VSYNC. Note, that if HSYNC and VSYNC polarities are
+  not specified, embedded synchronisation may be required, where supported.
+- data-active: similar to HSYNC and VSYNC specifies data line polarity.
+- field-even-active: field signal level during the even field data transmission.
+- pclk-sample: rising (1) or falling (0) edge to sample the pixel clock pin.
+- data-lanes: array of serial, e.g. MIPI CSI-2, data hardware lane numbers in
+  the ascending order, beginning with logical lane 0.
+- clock-lanes: hardware lane number, used for the clock lane.
+- clock-noncontinuous: a boolean property to allow MIPI CSI-2 non-continuous
+  clock mode.
+
+Example:
+
+	ceu0: ceu@0xfe910000 {
+		compatible = "renesas,sh-mobile-ceu";
+		reg = <0xfe910000 0xa0>;
+		interrupts = <0x880>;
+
+		mclk: master_clock {
+			compatible = "renesas,ceu-clock";
+			#clock-cells = <1>;
+			clock-frequency = <50000000>;	/* max clock frequency */
+			clock-output-names = "mclk";
+		};
+
+		port {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			ceu0_1: link@1 {
+				reg = <1>;		/* local link # */
+				remote = <&ov772x_1_1>;	/* remote phandle */
+				bus-width = <8>;	/* used data lines */
+				data-shift = <0>;	/* lines 7:0 are used */
+
+				/* If [hv]sync-active are missing, embedded bt.605 sync is used */
+				hsync-active = <1>;	/* active high */
+				vsync-active = <1>;	/* active high */
+				data-active = <1>;	/* active high */
+				pclk-sample = <1>;	/* rising */
+			};
+
+			ceu0_0: link@0 {
+				reg = <0>;
+				remote = <&csi2_2>;
+				immutable;
+			};
+		};
+	};
+
+	i2c0: i2c@0xfff20000 {
+		...
+		ov772x_1: camera@0x21 {
+			compatible = "omnivision,ov772x";
+			reg = <0x21>;
+			vddio-supply = <&regulator1>;
+			vddcore-supply = <&regulator2>;
+
+			clock-frequency = <20000000>;
+			clocks = <&mclk 0>;
+			clock-names = "xclk";
+
+			port {
+				/* With 1 link per port no need in addresses */
+				ov772x_1_1: link {
+					bus-width = <8>;
+					remote = <&ceu0_1>;
+					hsync-active = <1>;
+					vsync-active = <0>;	/* who came up with an inverter here?... */
+					data-active = <1>;
+					pclk-sample = <1>;
+				};
+			};
+		};
+
+		imx074: camera@0x1a {
+			compatible = "sony,imx074";
+			reg = <0x1a>;
+			vddio-supply = <&regulator1>;
+			vddcore-supply = <&regulator2>;
+
+			clock-frequency = <30000000>;	/* shared clock with ov772x_1 */
+			clocks = <&mclk 0>;
+			clock-names = "sysclk";		/* assuming this is the name in the datasheet */
+
+			port {
+				imx074_1: link {
+					clock-lanes = <0>;
+					data-lanes = <1>, <2>;
+					remote = <&csi2_1>;
+				};
+			};
+		};
+	};
+
+	csi2: csi2@0xffc90000 {
+		compatible = "renesas,sh-mobile-csi2";
+		reg = <0xffc90000 0x1000>;
+		interrupts = <0x17a0>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		port@1 {
+			compatible = "renesas,csi2c";	/* one of CSI2I and CSI2C */
+			reg = <1>;			/* CSI-2 PHY #1 of 2: PHY_S, PHY_M has port address 0, is unused */
+
+			csi2_1: link {
+				clock-lanes = <0>;
+				data-lanes = <2>, <1>;
+				remote = <&imx074_1>;
+			};
+		};
+		port@2 {
+			reg = <2>;			/* port 2: link to the CEU */
+
+			csi2_2: link {
+				immutable;
+				remote = <&ceu0_0>;
+			};
+		};
+	};
-- 
1.7.9.5


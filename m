Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446Ab2CZLtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 07:49:32 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:54648 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932430Ab2CZLta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 07:49:30 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <akpm@linux-foundation.org>
Cc: <spear-devel@list.st.com>, <viresh.linux@gmail.com>,
        <devicetree-discuss@lists.ozlabs.org>, <rajeev-dlh.kumar@st.com>,
        <sr@denx.de>, <rtc-linux@googlegroups.com>, <a.zummo@towertech.it>,
        <linux-kernel@vger.kernel.org>, Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH V2] rtc/spear: Add Device Tree probing capability
Date: Mon, 26 Mar 2012 17:18:10 +0530
Message-ID: <0e8f36e3ab86241dd2352eaa298843a586b5dfa3.1332762373.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.10.rc2.10.gb47606
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SPEAr platforms now support DT and so must convert all drivers support DT. This
patch adds DT probing support for rtc and updates its documentation too.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
Changes in V2:
- updated compatible to spear600-rtc instead of spear-rtc

 Documentation/devicetree/bindings/rtc/spear-rtc.txt |   18 ++++++++++++++++++
 drivers/rtc/rtc-spear.c                             |   10 ++++++++++
 2 files changed, 28 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rtc/spear-rtc.txt

diff --git a/Documentation/devicetree/bindings/rtc/spear-rtc.txt b/Documentation/devicetree/bindings/rtc/spear-rtc.txt
new file mode 100644
index 0000000..153946e
--- /dev/null
+++ b/Documentation/devicetree/bindings/rtc/spear-rtc.txt
@@ -0,0 +1,18 @@
+* SPEAr RTC
+
+Required properties:
+- compatible : "st,spear600-rtc"
+- reg : Address range of the rtc registers
+- interrupt-parent: Should be the phandle for the interrupt controller
+  that services interrupts for this device
+- interrupt: Should contain the rtc interrupt number
+
+Example:
+
+	rtc@fc000000 {
+		compatible = "st,spear600-rtc";
+		reg = <0xfc000000 0x1000>;
+		interrupt-parent = <&vic1>;
+		interrupts = <12>;
+	};
+
diff --git a/drivers/rtc/rtc-spear.c b/drivers/rtc/rtc-spear.c
index e38da0d..1f76320 100644
--- a/drivers/rtc/rtc-spear.c
+++ b/drivers/rtc/rtc-spear.c
@@ -16,6 +16,7 @@
 #include <linux/io.h>
 #include <linux/irq.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/rtc.h>
 #include <linux/slab.h>
@@ -519,6 +520,14 @@ static void spear_rtc_shutdown(struct platform_device *pdev)
 	clk_disable(config->clk);
 }
 
+#ifdef CONFIG_OF
+static const struct of_device_id spear_rtc_id_table[] = {
+	{ .compatible = "st,spear600-rtc" },
+	{}
+};
+MODULE_DEVICE_TABLE(of, spear_rtc_id_table);
+#endif
+
 static struct platform_driver spear_rtc_driver = {
 	.probe = spear_rtc_probe,
 	.remove = __devexit_p(spear_rtc_remove),
@@ -527,6 +536,7 @@ static struct platform_driver spear_rtc_driver = {
 	.shutdown = spear_rtc_shutdown,
 	.driver = {
 		.name = "rtc-spear",
+		.of_match_table = of_match_ptr(spear_rtc_id_table),
 	},
 };
 
-- 
1.7.10.rc2.10.gb47606


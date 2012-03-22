Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab2CVHMP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 03:12:15 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53805 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab2CVHMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 03:12:09 -0400
Date: Thu, 22 Mar 2012 15:11:54 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        Samuel Ortiz <sameo@linux.intel.com>, patches@linaro.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Nancy Chen <Nancy.Chen@freescale.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCH v13] Regulator: Add Anatop regulator driver
Message-ID: <20120322071152.GC2213@S2101-09.ap.freescale.net>
References: <1331692152-9256-1-git-send-email-paul.liu@linaro.org>
 <20120322052449.GB2213@S2101-09.ap.freescale.net>
 <4F6ACB80.10809@linaro.org>
MIME-Version: 1.0
In-Reply-To: <4F6ACB80.10809@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 02:49:36PM +0800, Ying-Chun Liu (PaulLiu) wrote:
...
> Ouch. I'll prepare a separate patch to add back the documentation.
> 
I just gave a quick testing on the driver with the dts change you
posted on imx6.  There is some little problem we may need to address.

prom_parse: Bad cell count for /soc/aips-bus@02000000/anatop@020c8000/regulator-vddpu@140
vddpu: 725 <--> 1300 mV at 1100 mV
prom_parse: Bad cell count for /soc/aips-bus@02000000/anatop@020c8000/regulator-vddcore@140
cpu: 725 <--> 1300 mV at 1100 mV
prom_parse: Bad cell count for /soc/aips-bus@02000000/anatop@020c8000/regulator-vddsoc@140
vddsoc: 725 <--> 1300 mV at 1100 mV
prom_parse: Bad cell count for /soc/aips-bus@02000000/anatop@020c8000/regulator-2p5@130
vdd2p5: 2000 <--> 2775 mV at 2400 mV
prom_parse: Bad cell count for /soc/aips-bus@02000000/anatop@020c8000/regulator-1p1@110
vdd1p1: 800 <--> 1400 mV at 1100 mV
prom_parse: Bad cell count for /soc/aips-bus@02000000/anatop@020c8000/regulator-3p0@120
vdd3p0: 2800 <--> 3150 mV at 3000 mV

The DT core function __of_translate_address will give some annoying
error messages.  We call of_platform_populate from anatop mfd driver
to populate regulator device, and during the call, DT core tries to
translate "reg" property to address resource, and will complain if
!(#size-cells > 0). 

To fix that, we may want to rename "reg" property to something else,
e.g. "anatop-reg-offset".  I tested the following changes removed the
error messages above.

diff --git a/arch/arm/boot/dts/imx6q.dtsi b/arch/arm/boot/dts/imx6q.dtsi
index 56d3c16..65bad45 100644
--- a/arch/arm/boot/dts/imx6q.dtsi
+++ b/arch/arm/boot/dts/imx6q.dtsi
@@ -346,16 +346,14 @@
                                compatible = "fsl,imx6q-anatop";
                                reg = <0x020c8000 0x1000>;
                                interrupts = <0 49 0x04 0 54 0x04 0 127 0x04>;
-                               #address-cells = <1>;
-                               #size-cells = <0>;

-                               regulator-vddpu@140 {
+                               regulator-vddpu {
                                        compatible = "fsl,anatop-regulator";
                                        regulator-name = "vddpu";
                                        regulator-min-microvolt = <725000>;
                                        regulator-max-microvolt = <1300000>;
                                        regulator-always-on;
-                                       reg = <0x140>;
+                                       anatop-reg-offset = <0x140>;
                                        anatop-vol-bit-shift = <9>;
                                        anatop-vol-bit-width = <5>;
                                        anatop-min-bit-val = <1>;
@@ -363,13 +361,13 @@
                                        anatop-max-voltage = <1300000>;
                                };

-                               regulator-vddcore@140 {
+                               regulator-vddcore {
                                        compatible = "fsl,anatop-regulator";
                                        regulator-name = "cpu";
                                        regulator-min-microvolt = <725000>;
                                        regulator-max-microvolt = <1300000>;
                                        regulator-always-on;
-                                       reg = <0x140>;
+                                       anatop-reg-offset = <0x140>;
                                        anatop-vol-bit-shift = <0>;
                                        anatop-vol-bit-width = <5>;
                                        anatop-min-bit-val = <1>;
@@ -377,13 +375,13 @@
                                        anatop-max-voltage = <1300000>;
                                };

-                               regulator-vddsoc@140 {
+                               regulator-vddsoc {
                                        compatible = "fsl,anatop-regulator";
                                        regulator-name = "vddsoc";
                                        regulator-min-microvolt = <725000>;
                                        regulator-max-microvolt = <1300000>;
                                        regulator-always-on;
-                                       reg = <0x140>;
+                                       anatop-reg-offset = <0x140>;
                                        anatop-vol-bit-shift = <18>;
                                        anatop-vol-bit-width = <5>;
                                        anatop-min-bit-val = <1>;
@@ -391,13 +389,13 @@
                                        anatop-max-voltage = <1300000>;
                                };

-                               regulator-2p5@130 {
+                               regulator-2p5 {
                                        compatible = "fsl,anatop-regulator";
                                        regulator-name = "vdd2p5";
                                        regulator-min-microvolt = <2000000>;
                                        regulator-max-microvolt = <2775000>;
                                        regulator-always-on;
-                                       reg = <0x130>;
+                                       anatop-reg-offset = <0x130>;
                                        anatop-vol-bit-shift = <8>;
                                        anatop-vol-bit-width = <5>;
                                        anatop-min-bit-val = <0>;
@@ -405,13 +403,13 @@
                                        anatop-max-voltage = <2775000>;
                                };

-                               regulator-1p1@110 {
+                               regulator-1p1 {
                                        compatible = "fsl,anatop-regulator";
                                        regulator-name = "vdd1p1";
                                        regulator-min-microvolt = <800000>;
                                        regulator-max-microvolt = <1400000>;
                                        regulator-always-on;
-                                       reg = <0x110>;
+                                       anatop-reg-offset = <0x110>;
                                        anatop-vol-bit-shift = <8>;
                                        anatop-vol-bit-width = <5>;
                                        anatop-min-bit-val = <4>;
@@ -419,13 +417,13 @@
                                        anatop-max-voltage = <1400000>;
                                };

-                               regulator-3p0@120 {
+                               regulator-3p0 {
                                        compatible = "fsl,anatop-regulator";
                                        regulator-name = "vdd3p0";
                                        regulator-min-microvolt = <2800000>;
                                        regulator-max-microvolt = <3150000>;
                                        regulator-always-on;
-                                       reg = <0x120>;
+                                       anatop-reg-offset = <0x120>;
                                        anatop-vol-bit-shift = <8>;
                                        anatop-vol-bit-width = <5>;
                                        anatop-min-bit-val = <7>;
diff --git a/drivers/regulator/anatop-regulator.c b/drivers/regulator/anatop-regulator.c
index 17499a5..632c087 100644
--- a/drivers/regulator/anatop-regulator.c
+++ b/drivers/regulator/anatop-regulator.c
@@ -138,9 +138,9 @@ static int __devinit anatop_regulator_probe(struct platform_device *pdev)
        rdesc->type = REGULATOR_VOLTAGE;
        rdesc->owner = THIS_MODULE;
        sreg->mfd = anatopmfd;
-       ret = of_property_read_u32(np, "reg", &sreg->control_reg);
+       ret = of_property_read_u32(np, "anatop-reg-offset", &sreg->control_reg);
        if (ret) {
-               dev_err(dev, "no reg property set\n");
+               dev_err(dev, "no anatop-reg-offset property set\n");
                goto anatop_probe_end;
        }
        ret = of_property_read_u32(np, "anatop-vol-bit-width",


-- 
Regards,
Shawn

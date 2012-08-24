Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848Ab2HXXkg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 19:40:36 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:62346 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755717Ab2HXXke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 19:40:34 -0400
Date: Sat, 25 Aug 2012 01:40:14 +0200
From: Rabin Vincent <rabin@rab.in>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: disable supply regulator if it is enabled for
 boot-on
Message-ID: <20120824233835.GA29178@ubuntu>
References: <1344938848-29606-1-git-send-email-ldewangan@nvidia.com>
 <5034AA28.5050306@nvidia.com>
 <20120823145308.GA28328@sirena.org.uk>
 <50364179.6070304@nvidia.com>
 <5037BF45.1070205@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5037BF45.1070205@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 11:22:05PM +0530, Laxman Dewangan wrote:
> I tried to reproduce the issue but could not able to do this.
> Can you please send me your board/dt files where you are porviding
> platform data for regulator?
> This will help me to reproduce the issue.

Here's a dts patch:

diff --git a/arch/arm/boot/dts/vexpress-v2m.dtsi b/arch/arm/boot/dts/vexpress-v2m.dtsi
index dba53fd..386eafa 100644
--- a/arch/arm/boot/dts/vexpress-v2m.dtsi
+++ b/arch/arm/boot/dts/vexpress-v2m.dtsi
@@ -207,5 +207,20 @@
 			regulator-max-microvolt = <3300000>;
 			regulator-always-on;
 		};
+
+		vbat: fixedregulator@1 {
+			compatible = "regulator-fixed";
+			regulator-name = "vbat";
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+		};
+
+		fixedregulator@2 {
+			compatible = "regulator-fixed";
+			regulator-name = "vtest1";
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+			vin-supply = <&vbat>;
+			regulator-boot-on;
+		};
 	};
 };

If you want to test it with fixed regulators, you'll need the hack below
to bypass the ops->disable check in regulator_init_complete(). 

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index 185468c..05f3028 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -129,9 +129,16 @@ static int fixed_voltage_list_voltage(struct regulator_dev *dev,
 	return data->microvolts;
 }
 
+static int fixed_enable(struct regulator_dev *dev)
+{
+	return 0;
+}
+
 static struct regulator_ops fixed_voltage_ops = {
 	.get_voltage = fixed_voltage_get_voltage,
 	.list_voltage = fixed_voltage_list_voltage,
+	.disable = fixed_enable,
+	.enable = fixed_enable,
 };
 
 static int __devinit reg_fixed_voltage_probe(struct platform_device *pdev)

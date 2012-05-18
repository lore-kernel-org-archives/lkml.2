Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965554Ab2ERQye (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:54:34 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16518 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965319Ab2ERQy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:54:29 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 18 May 2012 09:54:28 -0700
Message-ID: <4FB67D9C.2040909@nvidia.com>
Date: Fri, 18 May 2012 22:19:32 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Warren <swarren@nvidia.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: DT support for input-supply of regulator.
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,
When mapping the dts file for different regulator, observe that the 
input  input-supply is not getting correctly.


I have following structure in the dts file for registering the regulators:

        pmu: tps65910@d2 {
                 compatible = "ti,tps65910";
                 reg = <0xd2>;

                 #gpio-cells = <2>;
                 gpio-controller;
::::::::::

                 regulators {
                         vdd1_reg: vdd1 {
                                 regulator-min-microvolt = < 600000>;
                                 regulator-max-microvolt = <1500000>;
                         };
                         vdd2_reg: vdd2 {
                                 regulator-min-microvolt = < 600000>;
                                 regulator-max-microvolt = <1500000>;
                                 vin-supply = <&vdd1_reg>
                         };
                 };
     };


Now the regulator vdd1 get register properly, but when looking for the 
registration for vdd2, it is not able to identify the 
init_data->supply_regulator as we do not parse it.
So for this, I added the code in case on such
In function of_get_regulation_constraints()
         if (of_find_property(np, "vin-supply", NULL))
                 (*init_data)->supply_regulator = "vin";

So when vdd2 registration happen, it looks for the vin-supply.

But when it looks for the device node containing this regulator, it 
starts searching of the props from the dev_node of parent device i.e. 
pmu: tps65910@d2 and in search, it does not found the vin-supply 
property. It got property for compatible reg, gpio_cell, gpio-controller 
and then no more property.

Is there any issue in laying down the regulator structure?

Thanks,
Laxman






Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496Ab2ESVS1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 17:18:27 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6882 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756038Ab2ESVS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 17:18:26 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sat, 19 May 2012 14:18:26 -0700
Message-ID: <4FB80CEE.4050201@nvidia.com>
Date: Sun, 20 May 2012 02:43:18 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: core: use correct device for device supply
 lookup
References: <1337436846-30025-1-git-send-email-ldewangan@nvidia.com> <20120519164134.GT4039@opensource.wolfsonmicro.com> <4FB7D4D8.2050501@nvidia.com> <4FB7D676.9000609@nvidia.com> <20120519174052.GX4039@opensource.wolfsonmicro.com> <4FB7DEB0.3040001@nvidia.com> <20120519182658.GB4039@opensource.wolfsonmicro.com> <4FB7EE84.7090704@nvidia.com> <20120519205055.GA16590@opensource.wolfsonmicro.com>
In-Reply-To: <20120519205055.GA16590@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 May 2012 02:20 AM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Sun, May 20, 2012 at 12:33:32AM +0530, Laxman Dewangan wrote:
>
>> My board dts file is
>>        pmu: tps65910@d2 {
>>                  compatible = "ti,tps65910";
>>                  reg =<0xd2>;
>>                  interrupt-parent =<&intc>;
>>                  interrupts =<  0 118 0x04>;
>>
>>                  #gpio-cells =<2>;
>>                  gpio-controller;
>>
>>                  #interrupt-cells =<2>;
>>                  interrupt-controller;
>>
>>                  regulators {
>>                          vdd1_reg: vdd1 {
>>                                  regulator-min-microvolt =<  600000>;
>>                                  regulator-max-microvolt =<1500000>;
>>                                  regulator-always-on;
>>                                  regulator-boot-on;
>>                                  ti,regulator-ext-sleep-control =<0>;
>>                          };
>>                          vdd2_reg: vdd2 {
>>                                  regulator-min-microvolt =<  600000>;
>>                                  regulator-max-microvolt =<1500000>;
>>                                  regulator-always-on;
>>                                  regulator-boot-on;
>>                                  ti,regulator-ext-sleep-control =<4>;
>>                          };
>>              };
>>      };
> Supplies aren't specified for any of the regulators here...
Sorry, I missed this, I added the supply as
vdd2-supply = <&vdd1_reg>; in the vdd2-reg.


>> So currently, when regulator_register gets called in
>> tps65910-regulator.c, it sets the
>> config.dev = tps65910->dev;
>> config.of_node as
>>                  config.of_node =
>> of_find_node_by_name(tps65910->dev->of_node,
>>                                                          info->name);
>> So here config.of_node always shows NULL as the in
>> tps65910->dev->of_node does not have name same as info->name ie.
>> regulator name like vdd1, vdd2.
> Of course, this is just like any other supply - since you've not
> specified a mapping for it of course the framework isn't able to look it
> up.
>

For mapping, the node should start from "regulators", not from pmu on 
this example.
This is what we already did for regulator match
static struct tps65910_board *tps65910_parse_dt_reg_data(
                                     struct platform_device *pdev)
     {

         struct device_node *np = pdev->dev.parent->of_node;
         struct device_node *regulators;

         regulators = of_find_node_by_name(np, "regulators");
         ret = of_regulator_match(pdev->dev.parent, regulators, matches, 
count);
:::::::::::
}


Here my understanding is that config->of_node should contain the node 
information of the regulator being registered only. In DT case, it 
should not be null.

So here also we need to pass as
            config.of_node = of_find_node_by_name(regulators, info->name);

>>> If there is a change needed in the core you need to explain what you
>>> believe that change will do.
>> I though this is straight but seems it is becoming more complex now.
>> I will describe all this details if we agree to change require.
> I still don't see any change needed here, from the above it simply looks
> like the supplies aren't set up.
Unfortunately,
My regulator_get is failing if I dont correct the above logic to have 
proper config.of_node.

Also regulator registration failed if
- there is supply and if I dont use the config_of_node in lookup after 
fixing the config.of_node issue.

This is happening with pmu (tps65910) regulator only. Fixed regulators 
are working fine here if they dont depends on tps6510.  Input supply for 
fixed regulator from other fixed regulators are also working fine.
Each Fixed regulators are independent platform driver and hence there is 
no issue as dev->of_node is perfectly set/used.

> * Unknown Key
> * 0x6E30FDDD


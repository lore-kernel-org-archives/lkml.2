Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758940Ab2ESTIk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 15:08:40 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7797 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783Ab2ESTIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 15:08:39 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Sat, 19 May 2012 12:08:38 -0700
Message-ID: <4FB7EE84.7090704@nvidia.com>
Date: Sun, 20 May 2012 00:33:32 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: core: use correct device for device supply
 lookup
References: <1337436846-30025-1-git-send-email-ldewangan@nvidia.com> <20120519164134.GT4039@opensource.wolfsonmicro.com> <4FB7D4D8.2050501@nvidia.com> <4FB7D676.9000609@nvidia.com> <20120519174052.GX4039@opensource.wolfsonmicro.com> <4FB7DEB0.3040001@nvidia.com> <20120519182658.GB4039@opensource.wolfsonmicro.com>
In-Reply-To: <20120519182658.GB4039@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 May 2012 11:56 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Sat, May 19, 2012 at 11:26:00PM +0530, Laxman Dewangan wrote:
>
>> At the time of registration,  as becasue there is valid
>> reg_desc->supply_name and hence it tries to lookup the entry for
>> <name>-supply i.e. v2-supply in this case for getting regulator_dev.
>> regulator_register() {
>> static struct regulator_dev *regulator_dev_lookup(struct device *dev,
>>                                                    const char *supply,
>>                                                    int *ret)
>> {
>>          /* first do a dt based lookup */
>> ---->  Checked here, dev is not null but dev->of_node is null.
>>          if (dev&&  dev->of_node) {
>>
>> ------------>The issue is that I am not getting here as dev->node is
>> null here.
> But how is this related your patch?  What your patch does is change
> things so that instead of trying to look up the supply in the context of
> whatever device was passed in by the driver we try to look it up in the
> context of the class device we create.  I can't think of any situation
> where I'd expect that to make matters any better - the class device
> should certainly never appear in the device tree and isn't going to have
> a stable name for non-DT systems either.
>
> I'm just not seeing any problem in the core here.  It sounds to me like
> the problem might be either with the regulator driver doing something
> odd with the struct device it specifies when registering the regulator
> (though I'm guessing that it's the tps65910 which looks to be doing
> something sensible currently) or the device tree for the board being
> odd.  Looking at the changes you posted to tps65910 I suspect the issue
> is that you've changed the driver to pass in the platform device for the
> regulators as their device rather than the I2C device but it's the I2C
> device which appears in the device tree bindings.
>
My board dts file is
       pmu: tps65910@d2 {
                 compatible = "ti,tps65910";
                 reg = <0xd2>;
                 interrupt-parent = <&intc>;
                 interrupts = < 0 118 0x04 >;

                 #gpio-cells = <2>;
                 gpio-controller;

                 #interrupt-cells = <2>;
                 interrupt-controller;

                 regulators {
                         vdd1_reg: vdd1 {
                                 regulator-min-microvolt = < 600000>;
                                 regulator-max-microvolt = <1500000>;
                                 regulator-always-on;
                                 regulator-boot-on;
                                 ti,regulator-ext-sleep-control = <0>;
                         };
                         vdd2_reg: vdd2 {
                                 regulator-min-microvolt = < 600000>;
                                 regulator-max-microvolt = <1500000>;
                                 regulator-always-on;
                                 regulator-boot-on;
                                 ti,regulator-ext-sleep-control = <4>;
                         };
             };
     };

So currently, when regulator_register gets called in 
tps65910-regulator.c, it sets the
config.dev = tps65910->dev;
config.of_node as
                 config.of_node = 
of_find_node_by_name(tps65910->dev->of_node,
                                                         info->name);
So here config.of_node always shows NULL as the in 
tps65910->dev->of_node does not have name same as info->name ie. 
regulator name like vdd1, vdd2.

So I changed it to pass the node containing"regulators" for 
of_find_node_by_name() and then it got proper of_node like vdd1_reg or 
vdd2_reg as per info_name.

Now this node for vdd1_reg, vdd2_reg, is being passed to 
regulator_register. And for lookup of node, we should use the 
config.of_node which is set.

If we still want to use the parent device for lookup then other way to 
use the config.of_node is to take the parameter of device node in this api.

For this it is require to change the apis as

static struct regulator_dev *regulator_dev_lookup(struct device *dev,
                                                   const char *supply,
                                                   int *ret)

to
static struct regulator_dev *regulator_dev_lookup(struct device *dev, 
struct device_node *dev_node,
                                                   const char *supply,
                                                   int *ret)


and at the time of regulator registration, we should pass config->of_node.
In this way we can still pass parent device and of_node which is passed 
by  regulator driver.
         if (supply) {
                 struct regulator_dev *r;

                 r = regulator_dev_lookup(dev, config->of_node, supply, 
&ret);


> If there is a change needed in the core you need to explain what you
> believe that change will do.
>
I though this is straight but seems it is becoming more complex now.
I will describe all this details if we agree to change require.


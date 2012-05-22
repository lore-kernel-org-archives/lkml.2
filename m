Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822Ab2EVROq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 13:14:46 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7218 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab2EVROp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 13:14:45 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 22 May 2012 10:14:37 -0700
Message-ID: <4FBBC830.2060802@nvidia.com>
Date: Tue, 22 May 2012 22:39:04 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Stephen Warren <swarren@nvidia.com>, "olof@lixom.net" <olof@lixom.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 2/2] ARM: dt: tegra: cardhu: register core regulator tps65911
References: <1337691917-15040-1-git-send-email-ldewangan@nvidia.com> <1337691917-15040-2-git-send-email-ldewangan@nvidia.com> <4FBBC192.7030900@wwwdotorg.org>
In-Reply-To: <4FBBC192.7030900@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 May 2012 10:10 PM, Stephen Warren wrote:
> On 05/22/2012 07:05 AM, Laxman Dewangan wrote:
>> Add device info for the PMIC device tps65911 in tegra-cardhu
>> dts file. This device supports the multiple regulator rails,
>> gpio, interrupts.
> FYI, patch 1 in this series looks fine. Some comments below though:
>
>> diff --git a/arch/arm/boot/dts/tegra-cardhu.dts b/arch/arm/boot/dts/tegra-cardhu.dts
>> +		tps65911: tps65911@2d {
>> +			compatible = "ti,tps65911";
>> +			reg =<0x2d>;
>> +
>> +			#gpio-cells =<2>;
>> +			gpio-controller;
>> +
>> +			regulators {
> Please add the following properties here:
>
> 	#address-cells =<1>;
> 	#size-cells =<0>;
>
>> +				vdd1_reg: vdd1 {
> This node name should be "regulator", since nodes are generally named
> after the class of object they represent. Since all the nodes will then
> have the same name, you'll need to add a unit address ("@nnnn") to the
> node name.
>

Nop, we can not do it. The node name should match with the name 
mentioned in driver otherwise the regulator node search will fail
Following is the excerpt of the code:
int of_regulator_match(struct device *dev, struct device_node *node,
                        struct of_regulator_match *matches,
                        unsigned int num_matches)
{

         for (i = 0; i < num_matches; i++) {
                 struct of_regulator_match *match = &matches[i];
                 struct device_node *child;

                 child = of_find_node_by_name(node, match->name);
                 if (!child)
                         continue;

:::::::::::
}

static struct of_regulator_match tps65911_matches[] = {
         { .name = "vrtc",       .driver_data = (void *) 
&tps65911_regs[0] },
         { .name = "vio",        .driver_data = (void *) 
&tps65911_regs[1] },
         { .name = "vdd1",       .driver_data = (void *) 
&tps65911_regs[2] },
         { .name = "vdd2",       .driver_data = (void *) 
&tps65911_regs[3] },
         { .name = "vddctrl",    .driver_data = (void *) 
&tps65911_regs[4] },
         { .name = "ldo1",       .driver_data = (void *) 
&tps65911_regs[5] },
         { .name = "ldo2",       .driver_data = (void *) 
&tps65911_regs[6] },
  :::::::::::::::::::::::::::::::::::::
         { .name = "ldo8",       .driver_data = (void *) 
&tps65911_regs[12] },
};



So only we can do it as
     reg_vdd1: vdd1 {
                 reg = <0>;
             :::::::::
     };

     reg_vdd2: vdd2 {
             reg = < 1>;
             :::::::::::
     };

> Nitpicky, but the labels might be more logical as reg_vdd1 rather than
> vdd1_reg, but not a big deal.
>
> So, please replace the line above with:
>
> 	reg_vdd1: regulator@0 {
> 		reg =<0>;
>

Why do we really require the reg at all?
I dont think any usage of doing this.



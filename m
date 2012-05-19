Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab2ESSBI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 14:01:08 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5904 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932Ab2ESSBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 14:01:06 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sat, 19 May 2012 10:59:53 -0700
Message-ID: <4FB7DEB0.3040001@nvidia.com>
Date: Sat, 19 May 2012 23:26:00 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: core: use correct device for device supply
 lookup
References: <1337436846-30025-1-git-send-email-ldewangan@nvidia.com> <20120519164134.GT4039@opensource.wolfsonmicro.com> <4FB7D4D8.2050501@nvidia.com> <4FB7D676.9000609@nvidia.com> <20120519174052.GX4039@opensource.wolfsonmicro.com>
In-Reply-To: <20120519174052.GX4039@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 May 2012 11:10 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Sat, May 19, 2012 at 10:50:54PM +0530, Laxman Dewangan wrote:
>
>> Am I missing anything here in understanding?
> I certainly am.  Please go back to square one: what's the problem you
> are seeing here?  Then go forward and step by step relate it to the code
> change.

Sorry again for not clearing the things.
Here is my connection:
There is two rail V1 and V2. V2 is supplied by V1. There is some devices 
on V1 and V2.
V1---->V2-----device-v2-1
      |------------------device-v1-1

Now I make the dts as:
v1_reg: v1@0 {
     regulator-name="v1";
   :::::::::::
};

v2_reg: v2@1 {
     regulator-name="v2";
     v2-supply=<&v1_reg>;
::::::::::::::
}


Now when registering the v1, I am setting init_data->input_supply = NULL 
and reg_desc->supply_name = NULL;
Config->of_node is the node for v1_reg;
dev->of_node is NULL as it is mfd sub device driver tps65910-pmic.

So registration went fine.

When registering the V2, I am setting init_data->input_supply = NULL and 
reg_desc->supply_name = v2.
config->of_node is node for v2_reg;
dev->of_node is NULL as it is mfd sub device driver tps65910-pmic.

At the time of registration,  as becasue there is valid 
reg_desc->supply_name and hence it tries to lookup the entry for 
<name>-supply i.e. v2-supply in this case for getting regulator_dev.
regulator_register() {
:::::::::::
       if (init_data && init_data->supply_regulator)
                 supply = init_data->supply_regulator;
         else if (regulator_desc->supply_name)
                 supply = regulator_desc->supply_name;

         if (supply) {
                 struct regulator_dev *r;

                 r = regulator_dev_lookup(dev, supply, &ret);
::::::::::::::::::::::::
}

static struct regulator_dev *regulator_dev_lookup(struct device *dev,
                                                   const char *supply,
                                                   int *ret)
{
         /* first do a dt based lookup */
----> Checked here, dev is not null but dev->of_node is null.
         if (dev && dev->of_node) {

------------>The issue is that I am not getting here as dev->node is 
null here.

                 node = of_get_regulator(dev, supply);
                 if (node) {

         }



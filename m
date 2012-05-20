Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920Ab2ETHjS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 03:39:18 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6644 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab2ETHjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 03:39:16 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 20 May 2012 00:38:02 -0700
Message-ID: <4FB89E6D.7000206@nvidia.com>
Date: Sun, 20 May 2012 13:04:05 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: core: use correct device for device supply
 lookup
References: <1337436846-30025-1-git-send-email-ldewangan@nvidia.com> <20120519164134.GT4039@opensource.wolfsonmicro.com> <4FB7D4D8.2050501@nvidia.com> <4FB7D676.9000609@nvidia.com> <20120519174052.GX4039@opensource.wolfsonmicro.com> <4FB7DEB0.3040001@nvidia.com> <20120519182658.GB4039@opensource.wolfsonmicro.com> <4FB7EE84.7090704@nvidia.com> <20120519205055.GA16590@opensource.wolfsonmicro.com> <4FB80CEE.4050201@nvidia.com> <20120519231347.GD16590@opensource.wolfsonmicro.com>
In-Reply-To: <20120519231347.GD16590@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 May 2012 04:43 AM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Sun, May 20, 2012 at 02:43:18AM +0530, Laxman Dewangan wrote:
>
>> For mapping, the node should start from "regulators", not from pmu
>> on this example.
> What makes you say this?  I'm really not even sure what it means.
> How does a node "start" from something?  Supply mappings are direct
> links between consumers and regulators.
>
Sorry for long mail:
This is the issue in the tps65910-regulator.c where config.of_node is 
not being passed correctly.

The flow for my debugging the issue is as follows:

The dts file looks like:

tps65911: tps65911@2d {
     reg = <0x2d>
     #gpio_cells = <2>
     gpio_controller;
     :::::::::
     regulator {
         ldo1_reg: ldo1 {
             ::::::::
             /** regulator entry */
             ::::::::::::
             ::::::::::::
             /* There is NO input supply on this node */
         };
         ldo2_reg: ldo2 {
             ::::::::
             /** regulator entry */
             ::::::::::::
             /* There is NO input supply on this node */
         };
     };
};

Now in the driver, when we register ldo1, the config.of_node should 
contain the node of "ldo1_reg" and when we register ldo2 then 
config.of_node should contain the node of "ldo2_reg".

In the tps65910-regulator.c, the parent device node is containing node 
of "tps65911" i.e. pdev->dev.parent->of_node.
The same is also accessed by tps65910->dev->of_node as tps65910->dev is 
pdev->dev.parent.
By executing the following code in tps65910-regulator.c, ptobe(),
                config.of_node = 
of_find_node_by_name(tps65910->dev->of_node,
                                                         info->name);
is always returning NULL.
This is because the info->name which are "ldo1" or "ldo2" are looked on 
the parent node i.e. pdev->dev.parent->of_node, not inside child node 
"regulator" of pdev->dev.parent->of_node.  The function 
of_find_node_by_name() only looked for props on that node ("tps65911"), 
does not search from child node "regulator".

So for fixing this,
The search for info->name should start from the child node "regulator" 
of the "tps65911" to get proper regulator of_node for for regulator 
being register.
So I first searched for child node "regulator" from parent node 
"tps65911" and then search for info->name ("ldo1" or "ldo2") from this 
child node "regulator":

          struct device_node *np = pdev->dev.parent->of_node;
          struct device_node *regulators;

          regulators = of_find_node_by_name(np, "regulators");
          if (regulators)
          config.of_node = of_find_node_by_name(regulators, info->name);

After fixing this piece of code, regulator_get() from any driver get 
success.

This particular change should be in tps65910-regulator.c file. I fixed 
this in my yesterday's patch 2/5 but lack of explanation on the change 
log, it was unclear.

 From consumer perspecive:

when ldo1_reg get registerd, the config.of_node should contain the node 
handle for ldo1_reg and so it will get stored in rdev->dev.of_node as 
ldo1_reg.
Similarly for ldo2_reg, config.of_node should contain node for ldo2_reg 
and so will get stored in the rdev->dev.of_node as ldo2_reg;

ldo1 and ldo2 are get added in the regulator_list after successfully 
registration for regualtors.

The consumer defines the supply on the dts file as
    xyz_dev: xyz {
     :::::::::::::::
     vmmc-supply = <&ldo1_reg>;
     ::::::::::::
}

consumer driver calls the regulator_get as
regulator_get(dev, "vmmc");

Here dev->of_node contains the node for device" xyz_dev".
The "vmmc-supply" is being searched in xyz_dev and so it founds the 
regulator node as ldo1_reg.
This node get compared from all regulaors's of_node available in 
regulator_list as:
                 node = of_get_regulator(dev, supply);
                 if (node) {
                         list_for_each_entry(r, &regulator_list, list)
                                 if (r->dev.parent &&
                                         node == r->dev.of_node)
                                         return r;
         }

So to get this search success, the r->dev.of_node should contain the 
regulator specific nodes i.e. ldo1_reg or ldo2_reg.
So after fixing the above code,it worked fine.


> | context of the class device we create.  I can't think of any situation
> | where I'd expect that to make matters any better - the class device
> | should certainly never appear in the device tree and isn't going to have
> | a stable name for non-DT systems either.
>
> *Please* engage with this, especially the non-DT part.  You need to
> explain how what you're saying is related to the patch you posted, you
> keep talking about a "proper" config.of_node and saying this happens to
> make your system work but this isn't visibily related to the patch you
> posted.
>
> What is not "proper" about the of_node that was supplied for the
> regulator being registered?  In what way is this related to the device
> used by the regulator functioning as a consumer to request a supply?

This is the issue arise when regulator being registered have the input 
supply.
I am assuming the above fix is there in tps65910-regulator.c.
The dts file looks as

tps65911: tps65911@2d {
     reg = <0x2d>
     #gpio_cells = <2>
     gpio_controller;
     :::::::::
     regulator {
         ldo1_reg: ldo1 {
             ::::::::
             /** regulatr entry */
             ::::::::::::
             ::::::::::::
             /* There is NO input supply on this node */
         };
         ldo2_reg: ldo2 {
             ::::::::
             /** regulatr entry */
             ::::::::::::
             ldo2-supply = <&ldo1_reg>; /* So ldo1 supply the ldo2. */
         };
     };
};

ldo1 registration went fine.
During ldo2 registration, I passed the regulator_desc->supply_name as ldo2.

Here we are passing the config.dev = pdev->dev.parent.
And hence the config.dev.of_node is containing the node of "tps6511".
As I have fixed in tps65911-regulator.c, config.of_node contains the 
node i.e. "ldo1_reg" or "ldo2_reg" for regulator being registered.
In regulator_register(), following piece of code actually fails in the 
case config.of_node is not same as the dev->of_node and in my case it is 
not same. For fixed regulator case it is same and hence it is passing.


         if (supply) {
                 struct regulator_dev *r;

                 r = regulator_dev_lookup(dev, supply, &ret);


Here dev->of_node is containing the node of "tps65911" and so search of 
property "ldo1-supply" failed.

Does following change in core.c make sense to handle the case where 
config->of_node and dev->of_node is not same? Here we still use the dev 
which is passed by config->dev and make use of config->of_node.


-                r = regulator_dev_lookup(dev, supply, &ret);
+               r = regulator_dev_lookup(dev, config->of_node, supply, 
&ret);

  and regulator_dev_lookup() should look for of_node which is passed 
rather than the dev->of_node.

  static struct regulator_dev *regulator_dev_lookup(struct device *dev,
+                         struct device_node *of_node,
                                                    const char *supply,
                                                    int *ret)
  {
          struct regulator_dev *r;
          struct device_node *node;

          /* first do a dt based lookup */
-         if (dev && dev->of_node) {
-                 node = of_get_regulator(dev, supply);
+         if (dev && of_node) {
+                 node = of_get_regulator(dev, of_node, supply);

  :::::::::::
  }

- static struct device_node *of_get_regulator(struct device *dev, const 
char *supply)
+ static struct device_node *of_get_regulator(struct device *dev, struct 
device_node *of_node, const char *supply)
  {
          struct device_node *regnode = NULL;
          char prop_name[32]; /* 32 is max size of property name */

          snprintf(prop_name, 32, "%s-supply", supply);
-         regnode = of_parse_phandle(dev->of_node, prop_name, 0);
+         regnode = of_parse_phandle(of_node, prop_name, 0);
  :::::::::

}

static struct regulator *_regulator_get(struct device *dev, const char *id,
                                         int exclusive)
{
         struct regulator_dev *rdev;
         struct regulator *regulator = ERR_PTR(-EPROBE_DEFER);
         const char *devname = NULL;
+        struct device_node *of_node = NULL;
         int ret;

         if (id == NULL) {
                 pr_err("get() with no identifier\n");
                 return regulator;
         }

         if (dev) {
                 devname = dev_name(dev);
+                of_node = dev->of_node;
     }
         mutex_lock(&regulator_list_mutex);

-        rdev = regulator_dev_lookup(dev, id, &ret);
+        rdev = regulator_dev_lookup(dev, of_node, id, &ret);
         if (rdev)
                 goto found;

:::::::::::
}


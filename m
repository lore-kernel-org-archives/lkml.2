Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276Ab2INNGh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 09:06:37 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:49179 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751816Ab2INNGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 09:06:33 -0400
MIME-Version: 1.0
In-Reply-To: <505322E3.4090806@pengutronix.de>
References: <1347623899-14485-1-git-send-email-kishon@ti.com>
	<505322E3.4090806@pengutronix.de>
Date: Fri, 14 Sep 2012 18:36:30 +0530
Message-ID: <CAAe_U6JVE40aOfP+8y51J=LazQf5pbdvO8GxQBc-78Pv2hCBbA@mail.gmail.com>
Subject: Re: [RFC PATCH] drivers: phy: add generic PHY framework
From: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: balbi@ti.com, arnd@arndb.de, gregkh@linuxfoundation.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, richard.zhao@freescale.com,
        B29397@freescale.com, alexander.shishkin@linux.intel.com,
        marex@denx.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Sep 14, 2012 at 5:58 PM, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 09/14/2012 01:58 PM, Kishon Vijay Abraham I wrote:
>> The PHY framework provides a set of API's for the PHY drivers to
>> create/remove a PHY and the PHY users to obtain a reference to the PHY
>> using or without using phandle. If the PHY users has to obtain a reference to
>> the PHY without using phandle, the platform specfic intialization code (say
>> from board file) should have already called phy_bind with the binding
>> information. The binding information consists of phy's device name, phy
>> user device name and an index. The index is used when the same phy user
>> binds to mulitple phys.
>>
>> PHY drivers should create the PHY by passing phy_descriptor that has
>> information about the PHY and ops like init, exit, suspend, resume,
>> poweron, shutdown.
>
> Some comments inside.
>
> While looking over the code, I was thinking why not abstract the phy
> with a "bus" in the linux kernel. The ethernet phys are on the mdio_bus,
> see /sys/bus/mdio_bus. This saves you hand crafting devices, drivers and
> bindings,

well... have to think about it.
>
> Marc
>
>>
>> Nyet-signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> ---
>> This framework is actually intended to be used by all the PHY drivers in the
>> kernel. Though it's going to take a while for that, I intend to migrate
>> existing USB/OTG phy drivers to use this framework as we align on the design
>> of this framework. Once I migrate these phy drivers, I'll be able to test this
>> framework (I haven't tested this framework so far). I sent this patch early
>> so as to get review comments and align on the design. Thanks :-)
>>
>>  drivers/Kconfig         |    2 +
>>  drivers/Makefile        |    2 +
>>  drivers/phy/Kconfig     |   13 ++
>>  drivers/phy/Makefile    |    5 +
>>  drivers/phy/phy-core.c  |  437 +++++++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/phy/phy.h |  181 ++++++++++++++++++++
>>  6 files changed, 640 insertions(+)
>>  create mode 100644 drivers/phy/Kconfig
>>  create mode 100644 drivers/phy/Makefile
>>  create mode 100644 drivers/phy/phy-core.c
>>  create mode 100644 include/linux/phy/phy.h
>>
>> diff --git a/drivers/Kconfig b/drivers/Kconfig
>> index ece958d..8488818 100644
>> --- a/drivers/Kconfig
>> +++ b/drivers/Kconfig
>> @@ -152,4 +152,6 @@ source "drivers/vme/Kconfig"
>>
>>  source "drivers/pwm/Kconfig"
>>
>> +source "drivers/phy/Kconfig"
>> +
>>  endmenu
>> diff --git a/drivers/Makefile b/drivers/Makefile
>> index 5b42184..63d6bbe 100644
>> --- a/drivers/Makefile
>> +++ b/drivers/Makefile
>> @@ -38,6 +38,8 @@ obj-y                               += char/
>>  # gpu/ comes after char for AGP vs DRM startup
>>  obj-y                                += gpu/
>>
>> +obj-y                                += phy/
>> +
>>  obj-$(CONFIG_CONNECTOR)              += connector/
>>
>>  # i810fb and intelfb depend on char/agp/
>> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
>> new file mode 100644
>> index 0000000..34f7077
>> --- /dev/null
>> +++ b/drivers/phy/Kconfig
>> @@ -0,0 +1,13 @@
>> +#
>> +# PHY
>> +#
>> +
>> +menuconfig GENERIC_PHY
>> +     tristate "Generic PHY Support"
>> +     help
>> +       Generic PHY support.
>> +
>> +       This framework is designed to provide a generic interface for PHY
>> +       devices present in the kernel. This layer will have the generic
>> +       API by which phy drivers can create PHY using the phy framework and
>> +       phy users can obtain reference to the PHY.
>> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
>> new file mode 100644
>> index 0000000..9e9560f
>> --- /dev/null
>> +++ b/drivers/phy/Makefile
>> @@ -0,0 +1,5 @@
>> +#
>> +# Makefile for the phy drivers.
>> +#
>> +
>> +obj-$(CONFIG_GENERIC_PHY)    += phy-core.o
>> diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
>> new file mode 100644
>> index 0000000..c55446a
>> --- /dev/null
>> +++ b/drivers/phy/phy-core.c
>> @@ -0,0 +1,437 @@
>> +/*
>> + * phy-core.c  --  Generic Phy framework.
>> + *
>> + * Copyright (C) 2012 Texas Instruments
>> + *
>> + * Author: Kishon Vijay Abraham I <kishon@ti.com>
>> + *
>> + * This program is free software; you can redistribute  it and/or modify it
>> + * under  the terms of  the GNU General  Public License as published by the
>> + * Free Software Foundation;  either version 2 of the  License, or (at your
>> + * option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>> + */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/export.h>
>> +#include <linux/module.h>
>> +#include <linux/err.h>
>> +#include <linux/device.h>
>> +#include <linux/slab.h>
>> +#include <linux/of.h>
>> +#include <linux/phy/phy.h>
>> +
>> +static struct class *phy_class;
>> +static LIST_HEAD(phy_list);
>> +static DEFINE_MUTEX(phy_list_mutex);
>> +static LIST_HEAD(phy_bind_list);
>> +
>> +static void devm_phy_release(struct device *dev, void *res)
>> +{
>> +     struct phy *phy = *(struct phy **)res;
>
> What about adding a struct phy_res, doing so,m you don't need these
> casts, and it's easier to add more pointers if needed.

Wont we still need to do the cast since you get only a void pointer.
Maybe I'm not getting you.
>
>> +
>> +     phy_put(phy);
>> +}
>> +
>> +static int devm_phy_match(struct device *dev, void *res, void *match_data)
>> +{
>> +     return res == match_data;
>> +}
>> +
>> +static struct phy *phy_lookup(struct device *dev, u8 index)
>> +{
>> +     struct phy_bind *phy_bind = NULL;
>> +
>> +     list_for_each_entry(phy_bind, &phy_bind_list, list) {
>> +             if (!(strcmp(phy_bind->dev_name, dev_name(dev))) &&
>> +                             phy_bind->index == index)
>> +                     return phy_bind->phy;
>> +     }
>> +
>> +     return ERR_PTR(-ENODEV);
>> +}
>> +
>> +static struct phy *of_phy_lookup(struct device *dev, struct device_node *node)
>> +{
>> +     int index = 0;
>> +     struct phy  *phy;
>                   ^^
>
> Please remove that stray space.

Sure.
>
>> +     struct phy_bind *phy_map = NULL;
>> +
>> +     list_for_each_entry(phy_map, &phy_bind_list, list)
>> +             if (!(strcmp(phy_map->dev_name, dev_name(dev))))
>> +                     index++;
>> +
>> +     list_for_each_entry(phy, &phy_list, head) {
>> +             if (node != phy->desc->of_node)
>> +                     continue;
>> +
>> +             phy_map = phy_bind(dev_name(dev), index, dev_name(&phy->dev));
>> +             if (!IS_ERR(phy_map)) {
>> +                     phy_map->phy = phy;
>> +                     phy_map->auto_bind = true;
>> +             }
>> +
>> +             return phy;
>> +     }
>> +
>> +     return ERR_PTR(-ENODEV);
>> +}
>> +
>> +/**
>> + * devm_phy_get - lookup and obtain a reference to a phy.
>> + * @dev: device that requests this phy
>> + * @index: the index of the phy
>> + *
>> + * Gets the phy using phy_get(), and associates a device with it using
>> + * devres. On driver detach, release function is invoked on the devres data,
>> + * then, devres data is freed.
>> + */
>> +struct phy *devm_phy_get(struct device *dev, u8 index)
>> +{
>> +     struct phy **ptr, *phy;
>> +
>> +     ptr = devres_alloc(devm_phy_release, sizeof(*ptr), GFP_KERNEL);
>> +     if (!ptr)
>> +             return NULL;
>> +
>> +     phy = phy_get(dev, index);
>> +     if (!IS_ERR(phy)) {
>> +             *ptr = phy;
>> +             devres_add(dev, ptr);
>> +     } else
>> +             devres_free(ptr);
>
> nitpick: when when if has { }, else should have, too.

Sure.
>
>> +
>> +     return phy;
>> +}
>> +EXPORT_SYMBOL_GPL(devm_phy_get);
>> +
>> +/**
>> + * devm_phy_put - release the PHY
>> + * @dev: device that wants to release this phy
>> + * @phy: the phy returned by devm_phy_get()
>> + *
>> + * destroys the devres associated with this phy and invokes phy_put
>> + * to release the phy.
>> + */
>> +void devm_phy_put(struct device *dev, struct phy *phy)
>> +{
>> +     int r;
>> +
>> +     r = devres_destroy(dev, devm_phy_release, devm_phy_match, phy);
>> +     dev_WARN_ONCE(dev, r, "couldn't find PHY resource\n");
>> +}
>> +EXPORT_SYMBOL_GPL(devm_phy_put);
>> +
>> +/**
>> + * devm_of_phy_get - lookup and obtain a reference to a phy by phandle
>> + * @dev: device that requests this phy
>> + * @phandle: name of the property holding the phy phandle value
>> + *
>> + * Returns the phy driver associated with the given phandle value,
>> + * after getting a refcount to it or -ENODEV if there is no such phy.
>> + * While at that, it also associates the device with the phy using devres.
>> + * On driver detach, release function is invoked on the devres data,
>> + * then, devres data is freed.
>> + */
>> +struct phy *devm_of_phy_get(struct device *dev, const char *phandle)
>
> We should discuss first how the DT binding for a phy should look like. I
> don't like that you hardcode the index (in of_parse_phandle()) to "0".
> Then we have the problem with USB2 and USB3 phys for the same usb device.

I think then we should modify this API to take *index* which should be
used when we have a single controller using multiple phys. By that
we'll make both dt and non-dt similar in that, both of them will take
this index.
>
>> +{
>> +     struct phy      *phy = NULL, **ptr;
>> +     struct device_node *node;
>> +
>> +     if (!dev->of_node) {
>> +             dev_dbg(dev, "device does not have a device node entry\n");
>> +             return ERR_PTR(-EINVAL);
>> +     }
>> +
>> +     node = of_parse_phandle(dev->of_node, phandle, 0);
>> +     if (!node) {
>> +             dev_dbg(dev, "failed to get %s phandle in %s node\n", phandle,
>> +                     dev->of_node->full_name);
>> +             return ERR_PTR(-ENODEV);
>> +     }
>> +
>> +     ptr = devres_alloc(devm_phy_release, sizeof(*ptr), GFP_KERNEL);
>> +     if (!ptr) {
>> +             dev_dbg(dev, "failed to allocate memory for devres\n");
>> +             return ERR_PTR(-ENOMEM);
>> +     }
>> +
>> +     mutex_lock(&phy_list_mutex);
>> +
>> +     phy = of_phy_lookup(dev, node);
>> +     if (IS_ERR(phy) || !try_module_get(phy->dev.driver->owner)) {
>> +             devres_free(ptr);
>> +             goto err0;
>> +     }
>
> Please return -EPROBE_DEFER is the phy is not yet registered.

I really dont prefer to return -EPROBE_DEFER from the *framework*.
IMHO, it's up-to the caller of this API to return *probe* errors.
>
>> +
>> +     *ptr = phy;
>> +     devres_add(dev, ptr);
>> +
>> +     get_device(&phy->dev);
>> +
>> +err0:
>> +     mutex_unlock(&phy_list_mutex);
>> +
>> +     return phy;
>> +}
>> +EXPORT_SYMBOL_GPL(devm_of_phy_get);
>> +
>> +/**
>> + * phy_get - lookup and obtain a reference to a phy.
>> + * @dev: device that requests this phy
>> + * @index: the index of the phy
>> + *
>> + * Returns the phy driver, after getting a refcount to it; or
>> + * -ENODEV if there is no such phy.  The caller is responsible for
>> + * calling phy_put() to release that count.
>> + */
>> +struct phy *phy_get(struct device *dev, u8 index)
>> +{
>> +     struct phy      *phy = NULL;
>> +
>> +     mutex_lock(&phy_list_mutex);
>> +
>> +     phy = phy_lookup(dev, index);
>> +     if (IS_ERR(phy)) {
>> +             pr_err("unable to find phy\n");
>
> dev_err()

Sure.
>
>> +             goto err0;
>> +     }
>> +
>> +     get_device(&phy->dev);
>> +
>> +err0:
>> +     mutex_unlock(&phy_list_mutex);
>> +
>> +     return phy;
>> +}
>> +EXPORT_SYMBOL_GPL(phy_get);
>> +
>> +/**
>> + * phy_put - release the PHY
>> + * @phy: the phy returned by phy_get()
>> + *
>> + * Releases a refcount the caller received from phy_get().
>> + */
>> +void phy_put(struct phy *phy)
>> +{
>> +     if (phy)
>> +             put_device(&phy->dev);
>> +}
>> +EXPORT_SYMBOL_GPL(phy_put);
>> +
>> +/**
>> + * create_phy - create a new phy
>> + * @dev: device that is creating the new phy
>> + * @desc: descriptor of the phy
>> + *
>> + * Called to create a phy using phy framework.
>> + */
>> +struct phy *create_phy(struct device *dev, struct phy_descriptor *desc)
>
> All other functions are named phy_*, please rename this, too.

Sure.

Thanks
Kishon

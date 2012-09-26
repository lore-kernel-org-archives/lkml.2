Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab2IZJU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 05:20:26 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:36085 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753513Ab2IZJUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 05:20:24 -0400
MIME-Version: 1.0
In-Reply-To: <5056EE58.50104@pengutronix.de>
References: <1347623899-14485-1-git-send-email-kishon@ti.com>
	<505322E3.4090806@pengutronix.de>
	<CAAe_U6JVE40aOfP+8y51J=LazQf5pbdvO8GxQBc-78Pv2hCBbA@mail.gmail.com>
	<5056EE58.50104@pengutronix.de>
Date: Wed, 26 Sep 2012 14:50:20 +0530
Message-ID: <CAAe_U6LhLhe1+1pcFOxAH0UrWPFzOXx3p-i=sfw8P75kH8uJPQ@mail.gmail.com>
Subject: Re: [RFC PATCH] drivers: phy: add generic PHY framework
From: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>, Felipe Balbi <balbi@ti.com>
Cc: arnd@arndb.de, gregkh@linuxfoundation.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        richard.zhao@freescale.com, B29397@freescale.com,
        alexander.shishkin@linux.intel.com, marex@denx.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Sep 17, 2012 at 3:03 PM, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 09/14/2012 03:06 PM, ABRAHAM, KISHON VIJAY wrote:
>
> [...]
>
>>>> diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
>>>> new file mode 100644
>>>> index 0000000..c55446a
>>>> --- /dev/null
>>>> +++ b/drivers/phy/phy-core.c
>>>> @@ -0,0 +1,437 @@
>>>> +/*
>>>> + * phy-core.c  --  Generic Phy framework.
>>>> + *
>>>> + * Copyright (C) 2012 Texas Instruments
>>>> + *
>>>> + * Author: Kishon Vijay Abraham I <kishon@ti.com>
>>>> + *
>>>> + * This program is free software; you can redistribute  it and/or modify it
>>>> + * under  the terms of  the GNU General  Public License as published by the
>>>> + * Free Software Foundation;  either version 2 of the  License, or (at your
>>>> + * option) any later version.
>>>> + *
>>>> + * This program is distributed in the hope that it will be useful,
>>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>>> + * GNU General Public License for more details.
>>>> + *
>>>> + * You should have received a copy of the GNU General Public License
>>>> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>>>> + */
>>>> +
>>>> +#include <linux/kernel.h>
>>>> +#include <linux/export.h>
>>>> +#include <linux/module.h>
>>>> +#include <linux/err.h>
>>>> +#include <linux/device.h>
>>>> +#include <linux/slab.h>
>>>> +#include <linux/of.h>
>>>> +#include <linux/phy/phy.h>
>>>> +
>>>> +static struct class *phy_class;
>>>> +static LIST_HEAD(phy_list);
>>>> +static DEFINE_MUTEX(phy_list_mutex);
>>>> +static LIST_HEAD(phy_bind_list);
>>>> +
>>>> +static void devm_phy_release(struct device *dev, void *res)
>>>> +{
>>>> +     struct phy *phy = *(struct phy **)res;
>>>
>>> What about adding a struct phy_res, doing so,m you don't need these
>>> casts, and it's easier to add more pointers if needed.
>>
>> Wont we still need to do the cast since you get only a void pointer.
>> Maybe I'm not getting you.
>
> As "res" is a void pointer, no need to hast to to a "struct phy_res"
> pointer, if you think that's unclean code, you can still cast it. But
> IMHO the code is far more readable.
>
>>>> +
>>>> +     phy_put(phy);
>>>> +}
>>>> +
>>>> +static int devm_phy_match(struct device *dev, void *res, void *match_data)
>>>> +{
>>>> +     return res == match_data;
>>>> +}
>>>> +
>>>> +static struct phy *phy_lookup(struct device *dev, u8 index)
>>>> +{
>>>> +     struct phy_bind *phy_bind = NULL;
>>>> +
>>>> +     list_for_each_entry(phy_bind, &phy_bind_list, list) {
>>>> +             if (!(strcmp(phy_bind->dev_name, dev_name(dev))) &&
>>>> +                             phy_bind->index == index)
>>>> +                     return phy_bind->phy;
>>>> +     }
>>>> +
>>>> +     return ERR_PTR(-ENODEV);
>>>> +}
>>>> +
>>>> +static struct phy *of_phy_lookup(struct device *dev, struct device_node *node)
>>>> +{
>>>> +     int index = 0;
>>>> +     struct phy  *phy;
>>>                   ^^
>>>
>>> Please remove that stray space.
>>
>> Sure.
>>>
>>>> +     struct phy_bind *phy_map = NULL;
>>>> +
>>>> +     list_for_each_entry(phy_map, &phy_bind_list, list)
>>>> +             if (!(strcmp(phy_map->dev_name, dev_name(dev))))
>>>> +                     index++;
>>>> +
>>>> +     list_for_each_entry(phy, &phy_list, head) {
>>>> +             if (node != phy->desc->of_node)
>>>> +                     continue;
>>>> +
>>>> +             phy_map = phy_bind(dev_name(dev), index, dev_name(&phy->dev));
>>>> +             if (!IS_ERR(phy_map)) {
>>>> +                     phy_map->phy = phy;
>>>> +                     phy_map->auto_bind = true;
>>>> +             }
>>>> +
>>>> +             return phy;
>>>> +     }
>>>> +
>>>> +     return ERR_PTR(-ENODEV);
>>>> +}
>>>> +
>>>> +/**
>>>> + * devm_phy_get - lookup and obtain a reference to a phy.
>>>> + * @dev: device that requests this phy
>>>> + * @index: the index of the phy
>>>> + *
>>>> + * Gets the phy using phy_get(), and associates a device with it using
>>>> + * devres. On driver detach, release function is invoked on the devres data,
>>>> + * then, devres data is freed.
>>>> + */
>>>> +struct phy *devm_phy_get(struct device *dev, u8 index)
>>>> +{
>>>> +     struct phy **ptr, *phy;
>>>> +
>>>> +     ptr = devres_alloc(devm_phy_release, sizeof(*ptr), GFP_KERNEL);
>>>> +     if (!ptr)
>>>> +             return NULL;
>>>> +
>>>> +     phy = phy_get(dev, index);
>>>> +     if (!IS_ERR(phy)) {
>>>> +             *ptr = phy;
>>>> +             devres_add(dev, ptr);
>>>> +     } else
>>>> +             devres_free(ptr);
>>>
>>> nitpick: when when if has { }, else should have, too.
>>
>> Sure.
>>>
>>>> +
>>>> +     return phy;
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(devm_phy_get);
>>>> +
>>>> +/**
>>>> + * devm_phy_put - release the PHY
>>>> + * @dev: device that wants to release this phy
>>>> + * @phy: the phy returned by devm_phy_get()
>>>> + *
>>>> + * destroys the devres associated with this phy and invokes phy_put
>>>> + * to release the phy.
>>>> + */
>>>> +void devm_phy_put(struct device *dev, struct phy *phy)
>>>> +{
>>>> +     int r;
>>>> +
>>>> +     r = devres_destroy(dev, devm_phy_release, devm_phy_match, phy);
>>>> +     dev_WARN_ONCE(dev, r, "couldn't find PHY resource\n");
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(devm_phy_put);
>>>> +
>>>> +/**
>>>> + * devm_of_phy_get - lookup and obtain a reference to a phy by phandle
>>>> + * @dev: device that requests this phy
>>>> + * @phandle: name of the property holding the phy phandle value
>>>> + *
>>>> + * Returns the phy driver associated with the given phandle value,
>>>> + * after getting a refcount to it or -ENODEV if there is no such phy.
>>>> + * While at that, it also associates the device with the phy using devres.
>>>> + * On driver detach, release function is invoked on the devres data,
>>>> + * then, devres data is freed.
>>>> + */
>>>> +struct phy *devm_of_phy_get(struct device *dev, const char *phandle)
>>>
>>> We should discuss first how the DT binding for a phy should look like. I
>>> don't like that you hardcode the index (in of_parse_phandle()) to "0".
>>> Then we have the problem with USB2 and USB3 phys for the same usb device.
>>
>> I think then we should modify this API to take *index* which should be
>> used when we have a single controller using multiple phys. By that
>> we'll make both dt and non-dt similar in that, both of them will take
>> this index.
>
> That would be a plus.
>
>>>
>>>> +{
>>>> +     struct phy      *phy = NULL, **ptr;
>
> nitpick: stray spaces
>
>>>> +     struct device_node *node;
>>>> +
>>>> +     if (!dev->of_node) {
>>>> +             dev_dbg(dev, "device does not have a device node entry\n");
>>>> +             return ERR_PTR(-EINVAL);
>>>> +     }
>>>> +
>>>> +     node = of_parse_phandle(dev->of_node, phandle, 0);
>
> BTW: Is the node freed somewhere?
>
>>>> +     if (!node) {
>>>> +             dev_dbg(dev, "failed to get %s phandle in %s node\n", phandle,
>>>> +                     dev->of_node->full_name);
>>>> +             return ERR_PTR(-ENODEV);
>>>> +     }
>>>> +
>>>> +     ptr = devres_alloc(devm_phy_release, sizeof(*ptr), GFP_KERNEL);
>>>> +     if (!ptr) {
>>>> +             dev_dbg(dev, "failed to allocate memory for devres\n");
>>>> +             return ERR_PTR(-ENOMEM);
>>>> +     }
>>>> +
>>>> +     mutex_lock(&phy_list_mutex);
>>>> +
>>>> +     phy = of_phy_lookup(dev, node);
>>>> +     if (IS_ERR(phy) || !try_module_get(phy->dev.driver->owner)) {
>
> Where's the corresponding module_put? You should add module_get to the
> non dt function, too.

Do you think try_module_get() is necessary here? And just figured out
*this* phy device does not have a associated driver (so
phy->dev.driver will be NULL).

Thanks
Kishon

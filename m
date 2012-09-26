Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab2IZJhu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 05:37:50 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40178 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306Ab2IZJhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 05:37:48 -0400
Message-ID: <5062CCDE.3000701@pengutronix.de>
Date: Wed, 26 Sep 2012 11:37:34 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix e.K.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
CC: Felipe Balbi <balbi@ti.com>, arnd@arndb.de, gregkh@linuxfoundation.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, richard.zhao@freescale.com,
        B29397@freescale.com, alexander.shishkin@linux.intel.com,
        marex@denx.de
Subject: Re: [RFC PATCH] drivers: phy: add generic PHY framework
References: <1347623899-14485-1-git-send-email-kishon@ti.com> <505322E3.4090806@pengutronix.de> <CAAe_U6JVE40aOfP+8y51J=LazQf5pbdvO8GxQBc-78Pv2hCBbA@mail.gmail.com> <5056EE58.50104@pengutronix.de> <CAAe_U6LhLhe1+1pcFOxAH0UrWPFzOXx3p-i=sfw8P75kH8uJPQ@mail.gmail.com>
In-Reply-To: <CAAe_U6LhLhe1+1pcFOxAH0UrWPFzOXx3p-i=sfw8P75kH8uJPQ@mail.gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA53A8FF121A922DF5B87D77E"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA53A8FF121A922DF5B87D77E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 09/26/2012 11:20 AM, ABRAHAM, KISHON VIJAY wrote:
> Hi,
>=20
> On Mon, Sep 17, 2012 at 3:03 PM, Marc Kleine-Budde <mkl@pengutronix.de>=
 wrote:
>> On 09/14/2012 03:06 PM, ABRAHAM, KISHON VIJAY wrote:
>>
>> [...]
>>
>>>>> diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
>>>>> new file mode 100644
>>>>> index 0000000..c55446a
>>>>> --- /dev/null
>>>>> +++ b/drivers/phy/phy-core.c
>>>>> @@ -0,0 +1,437 @@
>>>>> +/*
>>>>> + * phy-core.c  --  Generic Phy framework.
>>>>> + *
>>>>> + * Copyright (C) 2012 Texas Instruments
>>>>> + *
>>>>> + * Author: Kishon Vijay Abraham I <kishon@ti.com>
>>>>> + *
>>>>> + * This program is free software; you can redistribute  it and/or =
modify it
>>>>> + * under  the terms of  the GNU General  Public License as publish=
ed by the
>>>>> + * Free Software Foundation;  either version 2 of the  License, or=
 (at your
>>>>> + * option) any later version.
>>>>> + *
>>>>> + * This program is distributed in the hope that it will be useful,=

>>>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>>>> + * GNU General Public License for more details.
>>>>> + *
>>>>> + * You should have received a copy of the GNU General Public Licen=
se
>>>>> + * along with this program.  If not, see <http://www.gnu.org/licen=
ses/>.
>>>>> + */
>>>>> +
>>>>> +#include <linux/kernel.h>
>>>>> +#include <linux/export.h>
>>>>> +#include <linux/module.h>
>>>>> +#include <linux/err.h>
>>>>> +#include <linux/device.h>
>>>>> +#include <linux/slab.h>
>>>>> +#include <linux/of.h>
>>>>> +#include <linux/phy/phy.h>
>>>>> +
>>>>> +static struct class *phy_class;
>>>>> +static LIST_HEAD(phy_list);
>>>>> +static DEFINE_MUTEX(phy_list_mutex);
>>>>> +static LIST_HEAD(phy_bind_list);
>>>>> +
>>>>> +static void devm_phy_release(struct device *dev, void *res)
>>>>> +{
>>>>> +     struct phy *phy =3D *(struct phy **)res;
>>>>
>>>> What about adding a struct phy_res, doing so,m you don't need these
>>>> casts, and it's easier to add more pointers if needed.
>>>
>>> Wont we still need to do the cast since you get only a void pointer.
>>> Maybe I'm not getting you.
>>
>> As "res" is a void pointer, no need to hast to to a "struct phy_res"
>> pointer, if you think that's unclean code, you can still cast it. But
>> IMHO the code is far more readable.
>>
>>>>> +
>>>>> +     phy_put(phy);
>>>>> +}
>>>>> +
>>>>> +static int devm_phy_match(struct device *dev, void *res, void *mat=
ch_data)
>>>>> +{
>>>>> +     return res =3D=3D match_data;
>>>>> +}
>>>>> +
>>>>> +static struct phy *phy_lookup(struct device *dev, u8 index)
>>>>> +{
>>>>> +     struct phy_bind *phy_bind =3D NULL;
>>>>> +
>>>>> +     list_for_each_entry(phy_bind, &phy_bind_list, list) {
>>>>> +             if (!(strcmp(phy_bind->dev_name, dev_name(dev))) &&
>>>>> +                             phy_bind->index =3D=3D index)
>>>>> +                     return phy_bind->phy;
>>>>> +     }
>>>>> +
>>>>> +     return ERR_PTR(-ENODEV);
>>>>> +}
>>>>> +
>>>>> +static struct phy *of_phy_lookup(struct device *dev, struct device=
_node *node)
>>>>> +{
>>>>> +     int index =3D 0;
>>>>> +     struct phy  *phy;
>>>>                   ^^
>>>>
>>>> Please remove that stray space.
>>>
>>> Sure.
>>>>
>>>>> +     struct phy_bind *phy_map =3D NULL;
>>>>> +
>>>>> +     list_for_each_entry(phy_map, &phy_bind_list, list)
>>>>> +             if (!(strcmp(phy_map->dev_name, dev_name(dev))))
>>>>> +                     index++;
>>>>> +
>>>>> +     list_for_each_entry(phy, &phy_list, head) {
>>>>> +             if (node !=3D phy->desc->of_node)
>>>>> +                     continue;
>>>>> +
>>>>> +             phy_map =3D phy_bind(dev_name(dev), index, dev_name(&=
phy->dev));
>>>>> +             if (!IS_ERR(phy_map)) {
>>>>> +                     phy_map->phy =3D phy;
>>>>> +                     phy_map->auto_bind =3D true;
>>>>> +             }
>>>>> +
>>>>> +             return phy;
>>>>> +     }
>>>>> +
>>>>> +     return ERR_PTR(-ENODEV);
>>>>> +}
>>>>> +
>>>>> +/**
>>>>> + * devm_phy_get - lookup and obtain a reference to a phy.
>>>>> + * @dev: device that requests this phy
>>>>> + * @index: the index of the phy
>>>>> + *
>>>>> + * Gets the phy using phy_get(), and associates a device with it u=
sing
>>>>> + * devres. On driver detach, release function is invoked on the de=
vres data,
>>>>> + * then, devres data is freed.
>>>>> + */
>>>>> +struct phy *devm_phy_get(struct device *dev, u8 index)
>>>>> +{
>>>>> +     struct phy **ptr, *phy;
>>>>> +
>>>>> +     ptr =3D devres_alloc(devm_phy_release, sizeof(*ptr), GFP_KERN=
EL);
>>>>> +     if (!ptr)
>>>>> +             return NULL;
>>>>> +
>>>>> +     phy =3D phy_get(dev, index);
>>>>> +     if (!IS_ERR(phy)) {
>>>>> +             *ptr =3D phy;
>>>>> +             devres_add(dev, ptr);
>>>>> +     } else
>>>>> +             devres_free(ptr);
>>>>
>>>> nitpick: when when if has { }, else should have, too.
>>>
>>> Sure.
>>>>
>>>>> +
>>>>> +     return phy;
>>>>> +}
>>>>> +EXPORT_SYMBOL_GPL(devm_phy_get);
>>>>> +
>>>>> +/**
>>>>> + * devm_phy_put - release the PHY
>>>>> + * @dev: device that wants to release this phy
>>>>> + * @phy: the phy returned by devm_phy_get()
>>>>> + *
>>>>> + * destroys the devres associated with this phy and invokes phy_pu=
t
>>>>> + * to release the phy.
>>>>> + */
>>>>> +void devm_phy_put(struct device *dev, struct phy *phy)
>>>>> +{
>>>>> +     int r;
>>>>> +
>>>>> +     r =3D devres_destroy(dev, devm_phy_release, devm_phy_match, p=
hy);
>>>>> +     dev_WARN_ONCE(dev, r, "couldn't find PHY resource\n");
>>>>> +}
>>>>> +EXPORT_SYMBOL_GPL(devm_phy_put);
>>>>> +
>>>>> +/**
>>>>> + * devm_of_phy_get - lookup and obtain a reference to a phy by pha=
ndle
>>>>> + * @dev: device that requests this phy
>>>>> + * @phandle: name of the property holding the phy phandle value
>>>>> + *
>>>>> + * Returns the phy driver associated with the given phandle value,=

>>>>> + * after getting a refcount to it or -ENODEV if there is no such p=
hy.
>>>>> + * While at that, it also associates the device with the phy using=
 devres.
>>>>> + * On driver detach, release function is invoked on the devres dat=
a,
>>>>> + * then, devres data is freed.
>>>>> + */
>>>>> +struct phy *devm_of_phy_get(struct device *dev, const char *phandl=
e)
>>>>
>>>> We should discuss first how the DT binding for a phy should look lik=
e. I
>>>> don't like that you hardcode the index (in of_parse_phandle()) to "0=
".
>>>> Then we have the problem with USB2 and USB3 phys for the same usb de=
vice.
>>>
>>> I think then we should modify this API to take *index* which should b=
e
>>> used when we have a single controller using multiple phys. By that
>>> we'll make both dt and non-dt similar in that, both of them will take=

>>> this index.
>>
>> That would be a plus.
>>
>>>>
>>>>> +{
>>>>> +     struct phy      *phy =3D NULL, **ptr;
>>
>> nitpick: stray spaces
>>
>>>>> +     struct device_node *node;
>>>>> +
>>>>> +     if (!dev->of_node) {
>>>>> +             dev_dbg(dev, "device does not have a device node entr=
y\n");
>>>>> +             return ERR_PTR(-EINVAL);
>>>>> +     }
>>>>> +
>>>>> +     node =3D of_parse_phandle(dev->of_node, phandle, 0);
>>
>> BTW: Is the node freed somewhere?
>>
>>>>> +     if (!node) {
>>>>> +             dev_dbg(dev, "failed to get %s phandle in %s node\n",=
 phandle,
>>>>> +                     dev->of_node->full_name);
>>>>> +             return ERR_PTR(-ENODEV);
>>>>> +     }
>>>>> +
>>>>> +     ptr =3D devres_alloc(devm_phy_release, sizeof(*ptr), GFP_KERN=
EL);
>>>>> +     if (!ptr) {
>>>>> +             dev_dbg(dev, "failed to allocate memory for devres\n"=
);
>>>>> +             return ERR_PTR(-ENOMEM);
>>>>> +     }
>>>>> +
>>>>> +     mutex_lock(&phy_list_mutex);
>>>>> +
>>>>> +     phy =3D of_phy_lookup(dev, node);
>>>>> +     if (IS_ERR(phy) || !try_module_get(phy->dev.driver->owner)) {=

>>
>> Where's the corresponding module_put? You should add module_get to the=

>> non dt function, too.
>=20
> Do you think try_module_get() is necessary here? And just figured out
> *this* phy device does not have a associated driver (so
> phy->dev.driver will be NULL).

If your phy driver is a loadable module, it is needed. Otherweise the
module use counter is 0, you can unload the module and the kernel will
oops when someone will access the driver.

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enigA53A8FF121A922DF5B87D77E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iEYEARECAAYFAlBizN4ACgkQjTAFq1RaXHMVrgCfX44BZ/nN/pScrfvfOFgg0qxC
stUAnjDFBis7jkLnMdJorLJHuTo1sqO3
=8vdz
-----END PGP SIGNATURE-----

--------------enigA53A8FF121A922DF5B87D77E--

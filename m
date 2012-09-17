Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab2IQJdl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 05:33:41 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35624 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049Ab2IQJdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 05:33:36 -0400
Message-ID: <5056EE58.50104@pengutronix.de>
Date: Mon, 17 Sep 2012 11:33:12 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix e.K.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
CC: balbi@ti.com, arnd@arndb.de, gregkh@linuxfoundation.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, richard.zhao@freescale.com,
        B29397@freescale.com, alexander.shishkin@linux.intel.com,
        marex@denx.de
Subject: Re: [RFC PATCH] drivers: phy: add generic PHY framework
References: <1347623899-14485-1-git-send-email-kishon@ti.com> <505322E3.4090806@pengutronix.de> <CAAe_U6JVE40aOfP+8y51J=LazQf5pbdvO8GxQBc-78Pv2hCBbA@mail.gmail.com>
In-Reply-To: <CAAe_U6JVE40aOfP+8y51J=LazQf5pbdvO8GxQBc-78Pv2hCBbA@mail.gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig477E5C09B5851EB582CAAFAC"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig477E5C09B5851EB582CAAFAC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 09/14/2012 03:06 PM, ABRAHAM, KISHON VIJAY wrote:

[...]

>>> diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
>>> new file mode 100644
>>> index 0000000..c55446a
>>> --- /dev/null
>>> +++ b/drivers/phy/phy-core.c
>>> @@ -0,0 +1,437 @@
>>> +/*
>>> + * phy-core.c  --  Generic Phy framework.
>>> + *
>>> + * Copyright (C) 2012 Texas Instruments
>>> + *
>>> + * Author: Kishon Vijay Abraham I <kishon@ti.com>
>>> + *
>>> + * This program is free software; you can redistribute  it and/or mo=
dify it
>>> + * under  the terms of  the GNU General  Public License as published=
 by the
>>> + * Free Software Foundation;  either version 2 of the  License, or (=
at your
>>> + * option) any later version.
>>> + *
>>> + * This program is distributed in the hope that it will be useful,
>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>> + * GNU General Public License for more details.
>>> + *
>>> + * You should have received a copy of the GNU General Public License=

>>> + * along with this program.  If not, see <http://www.gnu.org/license=
s/>.
>>> + */
>>> +
>>> +#include <linux/kernel.h>
>>> +#include <linux/export.h>
>>> +#include <linux/module.h>
>>> +#include <linux/err.h>
>>> +#include <linux/device.h>
>>> +#include <linux/slab.h>
>>> +#include <linux/of.h>
>>> +#include <linux/phy/phy.h>
>>> +
>>> +static struct class *phy_class;
>>> +static LIST_HEAD(phy_list);
>>> +static DEFINE_MUTEX(phy_list_mutex);
>>> +static LIST_HEAD(phy_bind_list);
>>> +
>>> +static void devm_phy_release(struct device *dev, void *res)
>>> +{
>>> +     struct phy *phy =3D *(struct phy **)res;
>>
>> What about adding a struct phy_res, doing so,m you don't need these
>> casts, and it's easier to add more pointers if needed.
>=20
> Wont we still need to do the cast since you get only a void pointer.
> Maybe I'm not getting you.

As "res" is a void pointer, no need to hast to to a "struct phy_res"
pointer, if you think that's unclean code, you can still cast it. But
IMHO the code is far more readable.

>>> +
>>> +     phy_put(phy);
>>> +}
>>> +
>>> +static int devm_phy_match(struct device *dev, void *res, void *match=
_data)
>>> +{
>>> +     return res =3D=3D match_data;
>>> +}
>>> +
>>> +static struct phy *phy_lookup(struct device *dev, u8 index)
>>> +{
>>> +     struct phy_bind *phy_bind =3D NULL;
>>> +
>>> +     list_for_each_entry(phy_bind, &phy_bind_list, list) {
>>> +             if (!(strcmp(phy_bind->dev_name, dev_name(dev))) &&
>>> +                             phy_bind->index =3D=3D index)
>>> +                     return phy_bind->phy;
>>> +     }
>>> +
>>> +     return ERR_PTR(-ENODEV);
>>> +}
>>> +
>>> +static struct phy *of_phy_lookup(struct device *dev, struct device_n=
ode *node)
>>> +{
>>> +     int index =3D 0;
>>> +     struct phy  *phy;
>>                   ^^
>>
>> Please remove that stray space.
>=20
> Sure.
>>
>>> +     struct phy_bind *phy_map =3D NULL;
>>> +
>>> +     list_for_each_entry(phy_map, &phy_bind_list, list)
>>> +             if (!(strcmp(phy_map->dev_name, dev_name(dev))))
>>> +                     index++;
>>> +
>>> +     list_for_each_entry(phy, &phy_list, head) {
>>> +             if (node !=3D phy->desc->of_node)
>>> +                     continue;
>>> +
>>> +             phy_map =3D phy_bind(dev_name(dev), index, dev_name(&ph=
y->dev));
>>> +             if (!IS_ERR(phy_map)) {
>>> +                     phy_map->phy =3D phy;
>>> +                     phy_map->auto_bind =3D true;
>>> +             }
>>> +
>>> +             return phy;
>>> +     }
>>> +
>>> +     return ERR_PTR(-ENODEV);
>>> +}
>>> +
>>> +/**
>>> + * devm_phy_get - lookup and obtain a reference to a phy.
>>> + * @dev: device that requests this phy
>>> + * @index: the index of the phy
>>> + *
>>> + * Gets the phy using phy_get(), and associates a device with it usi=
ng
>>> + * devres. On driver detach, release function is invoked on the devr=
es data,
>>> + * then, devres data is freed.
>>> + */
>>> +struct phy *devm_phy_get(struct device *dev, u8 index)
>>> +{
>>> +     struct phy **ptr, *phy;
>>> +
>>> +     ptr =3D devres_alloc(devm_phy_release, sizeof(*ptr), GFP_KERNEL=
);
>>> +     if (!ptr)
>>> +             return NULL;
>>> +
>>> +     phy =3D phy_get(dev, index);
>>> +     if (!IS_ERR(phy)) {
>>> +             *ptr =3D phy;
>>> +             devres_add(dev, ptr);
>>> +     } else
>>> +             devres_free(ptr);
>>
>> nitpick: when when if has { }, else should have, too.
>=20
> Sure.
>>
>>> +
>>> +     return phy;
>>> +}
>>> +EXPORT_SYMBOL_GPL(devm_phy_get);
>>> +
>>> +/**
>>> + * devm_phy_put - release the PHY
>>> + * @dev: device that wants to release this phy
>>> + * @phy: the phy returned by devm_phy_get()
>>> + *
>>> + * destroys the devres associated with this phy and invokes phy_put
>>> + * to release the phy.
>>> + */
>>> +void devm_phy_put(struct device *dev, struct phy *phy)
>>> +{
>>> +     int r;
>>> +
>>> +     r =3D devres_destroy(dev, devm_phy_release, devm_phy_match, phy=
);
>>> +     dev_WARN_ONCE(dev, r, "couldn't find PHY resource\n");
>>> +}
>>> +EXPORT_SYMBOL_GPL(devm_phy_put);
>>> +
>>> +/**
>>> + * devm_of_phy_get - lookup and obtain a reference to a phy by phand=
le
>>> + * @dev: device that requests this phy
>>> + * @phandle: name of the property holding the phy phandle value
>>> + *
>>> + * Returns the phy driver associated with the given phandle value,
>>> + * after getting a refcount to it or -ENODEV if there is no such phy=
=2E
>>> + * While at that, it also associates the device with the phy using d=
evres.
>>> + * On driver detach, release function is invoked on the devres data,=

>>> + * then, devres data is freed.
>>> + */
>>> +struct phy *devm_of_phy_get(struct device *dev, const char *phandle)=

>>
>> We should discuss first how the DT binding for a phy should look like.=
 I
>> don't like that you hardcode the index (in of_parse_phandle()) to "0".=

>> Then we have the problem with USB2 and USB3 phys for the same usb devi=
ce.
>=20
> I think then we should modify this API to take *index* which should be
> used when we have a single controller using multiple phys. By that
> we'll make both dt and non-dt similar in that, both of them will take
> this index.

That would be a plus.

>>
>>> +{
>>> +     struct phy      *phy =3D NULL, **ptr;

nitpick: stray spaces

>>> +     struct device_node *node;
>>> +
>>> +     if (!dev->of_node) {
>>> +             dev_dbg(dev, "device does not have a device node entry\=
n");
>>> +             return ERR_PTR(-EINVAL);
>>> +     }
>>> +
>>> +     node =3D of_parse_phandle(dev->of_node, phandle, 0);

BTW: Is the node freed somewhere?

>>> +     if (!node) {
>>> +             dev_dbg(dev, "failed to get %s phandle in %s node\n", p=
handle,
>>> +                     dev->of_node->full_name);
>>> +             return ERR_PTR(-ENODEV);
>>> +     }
>>> +
>>> +     ptr =3D devres_alloc(devm_phy_release, sizeof(*ptr), GFP_KERNEL=
);
>>> +     if (!ptr) {
>>> +             dev_dbg(dev, "failed to allocate memory for devres\n");=

>>> +             return ERR_PTR(-ENOMEM);
>>> +     }
>>> +
>>> +     mutex_lock(&phy_list_mutex);
>>> +
>>> +     phy =3D of_phy_lookup(dev, node);
>>> +     if (IS_ERR(phy) || !try_module_get(phy->dev.driver->owner)) {

Where's the corresponding module_put? You should add module_get to the
non dt function, too.

>>> +             devres_free(ptr);
>>> +             goto err0;
>>> +     }
>>
>> Please return -EPROBE_DEFER is the phy is not yet registered.
>=20
> I really dont prefer to return -EPROBE_DEFER from the *framework*.
> IMHO, it's up-to the caller of this API to return *probe* errors.

If we leave it to the caller, you have to proper design your return
values. There is a difference betweeen:
a) the phandle + index point to a non existing device node
b) the device node cannot be found in the list of phys (yet)

Error a) is permanent (in case of a static DT). Case b) indeed can be
solved by deferring the probe. Why should the framework not return
-EPROBE_DEFER in this case?

>>
>>> +
>>> +     *ptr =3D phy;
>>> +     devres_add(dev, ptr);
>>> +
>>> +     get_device(&phy->dev);
>>> +
>>> +err0:
>>> +     mutex_unlock(&phy_list_mutex);
>>> +
>>> +     return phy;
>>> +}
>>> +EXPORT_SYMBOL_GPL(devm_of_phy_get);
>>> +

[...]

> Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig477E5C09B5851EB582CAAFAC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iEYEARECAAYFAlBW7lwACgkQjTAFq1RaXHOzjQCdE1MCQWADlfAmUApGNAaNVsrn
QLAAnjTmrLYobMNH43V51IvaJ4CAPWzL
=2W1O
-----END PGP SIGNATURE-----

--------------enig477E5C09B5851EB582CAAFAC--

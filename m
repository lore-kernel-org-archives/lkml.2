Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab1D0HaO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 03:30:14 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51426 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763Ab1D0HaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 03:30:12 -0400
Message-ID: <4DB7C5F7.3080103@pengutronix.de>
Date: Wed, 27 Apr 2011 09:29:59 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Subhasish Ghosh <subhasish@mistralsolutions.com>
CC: davinci-linux-open-source@linux.davincidsp.com, sachi@mistralsolutions.com,
        Samuel Ortiz <sameo@linux.intel.com>, nsekhar@ti.com,
        open list <linux-kernel@vger.kernel.org>, m-watkins@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 01/11] mfd: add pruss mfd driver.
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com> <1303474109-6212-2-git-send-email-subhasish@mistralsolutions.com> <4DB1A603.2090208@pengutronix.de> <EDC1056430EF4DA8A0D850CE1DEA28FC@subhasishg>
In-Reply-To: <EDC1056430EF4DA8A0D850CE1DEA28FC@subhasishg>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8EC2FB2A10FB96FBA90C2EF6"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8EC2FB2A10FB96FBA90C2EF6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/27/2011 08:39 AM, Subhasish Ghosh wrote:
> Hi Mark,

I'm Marc.

> - Is it ok to have u32 etc for __iomem cookie ?

no - "void __iomem *" is "void __iomem *"


>> +s32 pruss_disable(struct device *dev, u8 pruss_num)
> make it a int function
>=20
> SG -- Ok will do
>=20
>> +
>> +    /* Reset PRU */
>> +    iowrite32(PRUCORE_CONTROL_RESETVAL,
>> +                &h_pruss->control);
>> +    spin_unlock(&pruss->lock);
>> +
>> +    return 0;
>=20
> make it a void function?
>=20
> SG -- This should be int, in case of invalid pru num, we ret an error.

Yes - Sorry.

>> +}
>> +EXPORT_SYMBOL_GPL(pruss_disable);
>> +
>> +s32 pruss_enable(struct device *dev, u8 pruss_num)
> int?
>=20
> SG -- Ok will do
>=20
>=20
>> +
>> +    if ((pruss_num !=3D PRUCORE_0) && (pruss_num !=3D PRUCORE_1))
>> +        return -EINVAL;
>> +
>> +    h_pruss =3D &pruss_mmap->core[pruss_num];
>> +
>> +    /* Reset PRU  */
>> +    spin_lock(&pruss->lock);
>> +    iowrite32(PRUCORE_CONTROL_RESETVAL, &h_pruss->control);
>=20
> no need to lock the ram reset below?
>=20
> SG -- I don't think its required. We just reset the RAM during init and=

> since each pru can only be attached to only one device, the access
>        will be already serialized based upon the pru num.

In the other function you lock the access to the ram, but not here.

>> +    /* Reset any garbage in the ram */
>> +    if (pruss_num =3D=3D PRUCORE_0)
>> +        for (i =3D 0; i < PRUSS_PRU0_RAM_SZ; i++)
>> +            iowrite32(0x0, &pruss_mmap->dram0[i]);
>> +    else if (pruss_num =3D=3D PRUCORE_1)
>> +        for (i =3D 0; i < PRUSS_PRU1_RAM_SZ; i++)
>> +            iowrite32(0x0, &pruss_mmap->dram1[i]);
> if you make a array for these
> +struct pruss_map {
> +    u8 dram0[512];
> +    u8 res1[7680];
>=20
> +    u8 dram1[512];
> +    u8 res2[7680];
> ..}
> you don't need the if..else..
>=20
> SG - The dram/iram is not contiguous, there is a reserved space in
> between, how do I declare an array for it.

This is the struct you have:

struct pruss_map {
	u8 dram0[512];
	u8 res1[7680];

	u8 dram1[512];
	u8 res2[7680];
=2E..
}

If you want to describe the ram with an array it translates to:

struct pruss_dram {
	u8 dram[512];
	u8 res[7680];
};

struct pruss_map {
	struct pruss_dram[2];
=2E..
};

BTW: Why do you declare the dram as "u8" "u32" seems more natural to me.

>> +/* Load the specified PRU with code */
>> +s32 pruss_load(struct device *dev, u8 pruss_num,
>> +            u32 *pruss_code, u32 code_size_in_words)
>> +{
>> +    struct pruss_priv *pruss =3D dev_get_drvdata(dev->parent);
>> +    struct pruss_map __iomem *pruss_mmap =3D pruss->ioaddr;
>> +    u32 __iomem *pruss_iram;
>> +    u32 i;
>> +
>> +    if (pruss_num =3D=3D PRUCORE_0)
>> +        pruss_iram =3D (u32 __iomem *)&pruss_mmap->iram0;
>> +    else if (pruss_num =3D=3D PRUCORE_1)
>> +        pruss_iram =3D (u32 __iomem *)&pruss_mmap->iram1;
>> +    else
> same here
>=20
> SG - same here.

same here :)

>> +s32 pruss_run(struct device *dev, u8 pruss_num)
> int?
>=20
> SG - Ok, Will do.
>=20
>=20
>> +    while (cnt--) {
>> +        temp_reg =3D ioread32(&h_pruss->control);
>> +        if (((temp_reg & PRUCORE_CONTROL_RUNSTATE_MASK) >>
>> +                PRUCORE_CONTROL_RUNSTATE_SHIFT) =3D=3D
>> +                PRUCORE_CONTROL_RUNSTATE_HALT)
>> +            break;
> how long might this take? what about some delay, sleep, or reschedule?
>=20
> SG - This does not take more than 10 to 20 counts,

Does it make sense, that the timeout is a parameter to that function?

>=20
>=20
>> +s32 pruss_writeb(struct device *dev, u32 offset, u8 pdatatowrite)
>> +{
>> +    struct pruss_priv *pruss =3D dev_get_drvdata(dev->parent);
>> +    void __iomem *paddresstowrite;
> we usually don't use "p" variable names for pointers
>=20
> SG - Ok, will remove.
>=20
>=20
>> +s32 pruss_rmwb(struct device *dev, u32 offset, u8 mask, u8 val)
> void function?
>=20
> SG - Ok, will do.
>=20
>> +
>> +s32 pruss_readb(struct device *dev, u32 offset, u8 *pdatatoread)
> void?
>=20
> SG - Ok, will do.
>=20
>> +{
>> +    struct pruss_priv *pruss =3D dev_get_drvdata(dev->parent);
>> +    void __iomem *paddresstoread;
>> +
>> +    paddresstoread =3D pruss->ioaddr + offset ;
>> +    *pdatatoread =3D ioread8(paddresstoread);
>> +
>> +    return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(pruss_readb);
>> +
>> +s32 pruss_readb_multi(struct device *dev, u32 offset,
>> +        u8 *pdatatoread, u16 bytestoread)
> viod?
>=20
> SG - Ok, will do.
>=20
>> +{
>> +    struct pruss_priv *pruss =3D dev_get_drvdata(dev->parent);
>> +    u8 __iomem *paddresstoread;
>> +    u16 i;
> int?
>=20
> SG - Ok, will do.
>=20
>=20
>=20
>> +    return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(pruss_readb_multi);
>> +
>> +s32 pruss_writel(struct device *dev, u32 offset,
>> +        u32 pdatatowrite)
> void?
>=20
> SG - Ok, will do.
>=20
>=20
>> +    return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(pruss_writel);
>> +
>> +s32 pruss_writel_multi(struct device *dev, u32 offset,
>> +        u32 *pdatatowrite, u16 wordstowrite)
> void?
>=20
> SG - Ok, will do.
>=20
>> +{
>> +    struct pruss_priv *pruss =3D dev_get_drvdata(dev->parent);
>> +    u32 __iomem *paddresstowrite;
>> +    u16 i;
>> +
>> +    paddresstowrite =3D pruss->ioaddr + offset;
>> +
>> +    for (i =3D 0; i < wordstowrite; i++)
>> +        iowrite32(*pdatatowrite++, paddresstowrite++);
> memcopy_to_iomem?
>=20
> SG -- I did not understand, could you please elaborate.

You could use memcpy_toio() - although it seems it does copy bytes
internally.

http://lxr.linux.no/linux+v2.6.38/arch/arm/include/asm/io.h#L222
>=20
>=20
>> +
>> +s32 pruss_rmwl(struct device *dev, u32 offset, u32 mask, u32 val)
> void?
>=20
> SG - Ok, will do.
>=20
>=20
>> +}
>> +EXPORT_SYMBOL_GPL(pruss_rmwl);
>> +
>> +s32 pruss_readl(struct device *dev, u32 offset, u32 *pdatatoread)
> void? or return the read value
>=20
> SG - Ok, will do.
>=20
>=20
>=20

regards,
Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig8EC2FB2A10FB96FBA90C2EF6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk23xfoACgkQjTAFq1RaXHNd8ACcCb5IsUFvSUUaQEizv8y8fsU3
TZ0An3FNINiiBltN1UhGuTvsHVUBQRmA
=xiDC
-----END PGP SIGNATURE-----

--------------enig8EC2FB2A10FB96FBA90C2EF6--

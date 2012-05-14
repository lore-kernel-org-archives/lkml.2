Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab2ENIw2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 04:52:28 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50600 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754803Ab2ENIw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 04:52:27 -0400
Date: Mon, 14 May 2012 09:52:24 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Graeme Gregory <gg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com, lrg@ti.com,
        b-cousson@ti.com, linux-omap@vger.kernel.org
Subject: Re: [PATCH 3/4] REGULATOR: regulator driver for Palmas series chips
Message-ID: <20120514085223.GH31985@opensource.wolfsonmicro.com>
References: <1336960712-2812-1-git-send-email-gg@slimlogic.co.uk>
 <1336960712-2812-4-git-send-email-gg@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xQmOcGOVkeO43v2v"
Content-Disposition: inline
In-Reply-To: <1336960712-2812-4-git-send-email-gg@slimlogic.co.uk>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xQmOcGOVkeO43v2v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 14, 2012 at 10:58:31AM +0900, Graeme Gregory wrote:

Looks good, quite a few of the things below are updates for very
recently introduced APIs.

> +static int palmas_smps_read(struct palmas *palmas, unsigned int reg,
> +		unsigned int *dest)
> +{
> +	int slave;
> +	unsigned int addr;
> +
> +	slave = PALMAS_BASE_TO_SLAVE(PALMAS_SMPS_BASE);
> +	addr = PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE, reg);
> +
> +	return regmap_read(palmas->regmap[slave], addr, dest);
> +}

Looks like the LDO and SPMS regulators both use the same regmap?

> +	.get_voltage		= palmas_get_voltage_smps,

Why not get_voltage_sel?

> +	.set_voltage_sel	= palmas_set_voltage_smps_sel,
> +	.list_voltage		= palmas_list_voltage_smps,

Implementing map_voltage() too would be nice.

> +static int palmas_is_enabled_smps10(struct regulator_dev *dev)
> +{
> +	struct palmas_pmic *pmic = rdev_get_drvdata(dev);
> +	unsigned int reg;
> +
> +	palmas_smps_read(pmic->palmas, PALMAS_SMPS10_STATUS, &reg);
> +
> +	reg &= SMPS10_BOOST_EN;
> +

Should be able to use regulator_is_enabled_regmap() and friends.

> +static int palmas_list_voltage_smps10(struct regulator_dev *dev,
> +					unsigned selector)
> +{
> +	if (selector)
> +		return 5000000;
> +
> +	return 3750000;

This could be written a little more transparently!

> +static int palmas_get_voltage_smps10(struct regulator_dev *dev)
> +{
> +	struct palmas_pmic *pmic = rdev_get_drvdata(dev);
> +	int selector;
> +	unsigned int reg;
> +
> +	palmas_smps_read(pmic->palmas, PALMAS_SMPS10_CTRL, &reg);
> +
> +	selector = (reg & SMPS10_VSEL) >> 3;
> +
> +	return palmas_list_voltage_smps10(dev, selector);

Should be get_voltage_sel() really, or beter still should be using
regulator_set_voltage_sel_regmap().  Similarly for the set (which is
already using _sel()).

> +static int palmas_enable_ldo(struct regulator_dev *dev)
> +{
> +	struct palmas_pmic *pmic = rdev_get_drvdata(dev);
> +	int id = rdev_get_id(dev);
> +	unsigned int reg;
> +
> +	palmas_ldo_read(pmic->palmas, palmas_regs_info[id].ctrl_addr, &reg);
> +
> +	reg |= LDO1_CTRL_MODE_ACTIVE;
> +
> +	palmas_ldo_write(pmic->palmas, palmas_regs_info[id].ctrl_addr, reg);

Could use the core regmap stuff for the LDOs too.

> +	/* Adjust selector to match list_voltage ranges */
> +	if (selector > 49)
> +		selector = 49;
> +
> +	return palmas_list_voltage_ldo(dev, selector);

get_voltage_sel().

> +	if (!pdata)
> +		return -EINVAL;
> +	if (!pdata->reg_data)
> +		return -EINVAL;

I'd expect the driver to be able to register the regulators with no
platform data at all.

> +	pmic = kzalloc(sizeof(*pmic), GFP_KERNEL);
> +	if (!pmic)
> +		return -ENOMEM;

devm_kzalloc()

> +	pmic->desc = kcalloc(PALMAS_NUM_REGS,
> +			sizeof(struct regulator_desc), GFP_KERNEL);
> +	if (!pmic->desc) {
> +		ret = -ENOMEM;
> +		goto err_free_pmic;
> +	}

Just embed this in the pmic struct?  It's always the same size.

> +	pmic->rdev = kcalloc(PALMAS_NUM_REGS,
> +			sizeof(struct regulator_dev *), GFP_KERNEL);

Similarly heere.

--xQmOcGOVkeO43v2v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPsMerAAoJEBus8iNuMP3dfgIP/jdZxY/1TOqRx1iYnb6EQt8O
ZxW4/8fSIEYHWXLLTNgUGcZ9Im19rlIK1WaF6nY9pc5/JENQUhh2Iusd5jz3ddub
5+/rYoEUvKhd8QjyAwOWFva3UfSeLcJzxJlvm3faZXQZC4vs9h5RiIspIjOQwBjA
7keWwD9vGg94QDMnk4Povi9JSCRFIEi5huTV47Ii4kKirBPXoR/0C8o2QJxxVkZl
aTYuPbdThj8XKgdwoejaX2zm3+V1e62iZloJmgoRwu/IJwXVXOpRO/KPKtFCmuPX
Rk6zwJpnXUNzVNnC0ETLplfpUitgpbLnttlLLX5SAGKIFA/w3svGRzc3oQIxZhUV
vGTpjEsXUwalfNYbehn0SHZoZjIhaWPZ7dIO6zWFbIRjX65Rp9i141j7qJtpMiof
NkEcwIl8S6Qmz3tDczQoKOhN9peZHL6diqGMs4H5ShyevKVABZlY3IcpjhJSyfPV
/T+CRND0hK6xwUnjjSgs3JeNMVNDvAkGb4ePzZgHKEgZ7aGYDywdBjQOAskbleA5
rkyVnVHxDtE7JpksvExLNBFwKPz5bK65uclfh0Rd75sBuMFmxoVc45vokBWyFdpT
rdWdA3PCYNzhM74VN+oCAjeWFDYqy1rq33N93Zznbb79GODca9kPByo1Tm+uQaVO
JEyfX5oth+/bDtBRowsb
=nav4
-----END PGP SIGNATURE-----

--xQmOcGOVkeO43v2v--

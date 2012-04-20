Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038Ab2DTJUS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 05:20:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:32768 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750814Ab2DTJUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 05:20:14 -0400
Date: Fri, 20 Apr 2012 10:20:08 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Robin Gong <B38343@freescale.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH 1/2] mfd: Add Freescale's PMIC MC34708 support
Message-ID: <20120420092007.GA3892@opensource.wolfsonmicro.com>
References: <1334853521-23792-1-git-send-email-paul.liu@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
In-Reply-To: <1334853521-23792-1-git-send-email-paul.liu@linaro.org>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 20, 2012 at 12:38:40AM +0800, Ying-Chun Liu (PaulLiu) wrote:

> +Sub-nodes:
> +- regulators : Contain the regulator nodes.  The MC34708 regulators are
> +  bound using their names as listed below for enabling.
> +
> +    mc34708__sw1a    : regulator SW1A
> +    mc34708__sw1b    : regulator SW1B

There's no point in including the chip name in the properties - the
device has already been bound at the device level, this is just noise
at this level.

> +	int ret;
> +	int i;
> +
> +	memset(buf, 0, 3);
> +	for (i = 0; i < PMIC_I2C_RETRY_TIMES; i++) {
> +		ret = i2c_smbus_read_i2c_block_data(client, offset, 3, buf);

The I2C layer already has a retry mechanism, and obviously if I2C is
failing at all the board generally has serious problems.

In general I'm not 100% sure why you're not using the regmap API here -
it looks like the 24 bit I/O is just a block I/O.  Alternatively you
could use regmap for the register I/O and then open code the 24 bit
access if they really are different.  This would let you
make much more use of framework support.

> +	return mc34708_reg_write(mc_pmic, offmask, mask | irqbit);
> +}
> +EXPORT_SYMBOL(mc34708_irq_mask);

You shouldn't be open coding stuff like this, you should be implementing
it using genirq.  This again gives you better framework support.

> +static const struct i2c_device_id *i2c_match_id(const struct i2c_device_id *id,
> +						const struct i2c_client *client)
> +{
> +	while (id->name[0]) {
> +		if (strcmp(client->name, id->name) == 0)
> +			return id;
> +		id++;
> +	}
> +
> +	return NULL;
> +}
> +
> +static const struct i2c_device_id *i2c_get_device_id(const struct i2c_client
> +						     *idev)
> +{
> +	const struct i2c_driver *idrv = to_i2c_driver(idev->dev.driver);
> +
> +	return i2c_match_id(idrv->id_table, idev);
> +}

This stuff should be added as generic I2C helpers if it's useful.

> +	if (pdata && pdata->flags & MC34708_USE_REGULATOR) {
> +		struct mc34708_regulator_platform_data regulator_pdata = {
> +			.num_regulators = pdata->num_regulators,
> +			.regulators = pdata->regulators,
> +		};
> +
> +		mc34708_add_subdevice_pdata(mc_pmic, "%s-regulator",
> +					    &regulator_pdata,
> +					    sizeof(regulator_pdata));
> +	} else if (of_find_node_by_name(np, "regulators")) {
> +		mc34708_add_subdevice(mc_pmic, "%s-regulator");
> +	}

This shouldn't be conditional, the regulators are always physically
present and even if they're not actively managed we can look at their
setup.

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPkSo/AAoJEBus8iNuMP3d4d4P/2fclmh5tiFVkRfTUWNnY9sg
spgbXJHHdCqFWvTuEcNkb+dVq7+QXggXZRkVzZrGzbAcKw8gFyKOToYHhO4hDWhU
uivpOzOYUOgcicjIFVX3kR7pJAAxXHMdp8AqJDkxeUZBzrppvuHW0CQoUn1bhOhy
+A6ieCWGKy+WVOG6Dm2nnkkuS14CBLe7fBhUuyPmFuqFTuYgSDbzDlWxm/OK3UFi
cpsXUS4jyF3hGQ+ADSNareEK5jq2gXZaQEveZGvU8gMXl1gBidlCEaEYnBpzLPw7
1Fd6oZT8uTyeuWthPoPwmnwITZ7g1kwz/99VR/8M9GJ0Kzdcg8yIefIX69itzr0G
odJYX476hmv3yQaME4DnhSgmF2Cv61RfJb70zRcl4sytSJD2JYY+Z7RvNJOyV4mF
+2uU4ZXH3ecN3lVxZ1Qo9RUogZdswHFp6oeRnYaxwyFBws1wpzNfZI45GtS02y67
N+WT5AcqlY4qQcbAJfuD09688Pm6unf53GZAdlnazEvT1eAPOo+IwZ+i+Kl38YMc
U3DqEI6dqEk+kqx1hoMVS8YhkyQA/I9gyswH82zOEYoxd3dK1NWmy7+qadkPzWYy
IWWka+9ny6jwZeYKiONAUSr8Hreq3Hj88F+7wKXpolXd0IaI6J+FIvhw8Omilb0d
i9SBUCdgvGps7Uvx/UkV
=Ox3z
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--

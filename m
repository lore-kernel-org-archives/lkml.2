Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759223Ab2EKM1a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 08:27:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36024 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759091Ab2EKM1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 08:27:25 -0400
Date: Fri, 11 May 2012 13:27:20 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Krystian Garbaciak <dd.diasemi@gmail.com>
Cc: linux-kernel@vger.kernel.org, Anthony Olech <Anthony.Olech@diasemi.com>,
        gg@slimlogic.co.uk, Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] regmap: Add support for register paging
Message-ID: <20120511122719.GA3960@opensource.wolfsonmicro.com>
References: <1336733724.5950.3.camel@sw-eng-lt-dc-vm2>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline
In-Reply-To: <1336733724.5950.3.camel@sw-eng-lt-dc-vm2>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 11, 2012 at 12:55:24PM +0200, Krystian Garbaciak wrote:

> Devices, having register map split into pages, can initialize regmap to
> switch between pages automatically. This simply makes the total number
> of registers to be virtually expanded and multiplied by number of pages.

Adding some people I believe work with devices that have paged registers
(I don't really myself).  I'm not deleting any text for their benefit.

> When driver defines non-zero number of bits for page selection, register
> address passed for read or write should consist of total number of page
> bits and register bits to form an address, where page bits are the most
> significant ones.

> In order to make page switching efficient, register used for page
> selection should be declared as cacheable (when possible). Driver can
> define pageable and non-pageable (page independent) registers, so that
> page switching will be carried out for pageable registers only.

In terms of framework I think this is broadly OK, though it'd probably
be clearer and easier to understand all round if it were unconditional;
right now the diff is pretty hard to read so I may have missed some
issues and I'm also reluctant to add any additional combinations of
build options that aren't actually needed.

The only thing that concerns me is that it flattens the register range
by muxing the paging into the register address.  This isn't how most of
the existing paged register users I've seen have handled things and it
does mean that we're running the risk of the number of pages interfering
with the register space.  On the other hand it hides the fact that we're
doing paging from the rest of the kernel which is very nice for anything
doing generic infrastructure on top of regmap.

One other fun thing which just occurred to me is that I've got a bunch
of chips which have several independantly paged regions.  I'm not sure
that's really worth handling here, though.

> Signed-off-by: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
> ---
> diff --git a/drivers/base/regmap/Kconfig b/drivers/base/regmap/Kconfig
> index 0f6c7fb..590d72c 100644
> --- a/drivers/base/regmap/Kconfig
> +++ b/drivers/base/regmap/Kconfig
> @@ -16,3 +16,6 @@ config REGMAP_SPI
> =20
>  config REGMAP_IRQ
>  	bool
> +
> +config REGMAP_PAGING
> +	bool

> diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/interna=
l.h
> index fcafc5b..b7931e1 100644
> --- a/drivers/base/regmap/internal.h
> +++ b/drivers/base/regmap/internal.h
> @@ -31,6 +31,18 @@ struct regmap_format {
>  	unsigned int (*parse_val)(void *buf);
>  };
> =20
> +#ifdef CONFIG_REGMAP_PAGING
> +struct regmap_paging {
> +	unsigned int page_mask;
> +	unsigned int reg_mask;
> +	unsigned int reg_bits;
> +	bool (*pageable_reg)(struct device *dev, unsigned int reg);
> +	unsigned int sel_reg;
> +	int sel_shift;
> +	unsigned int sel_mask;
> +};
> +#endif

It'd be good to have a way of enumerating the pages for the debugfs
interface.  Should we have a max_page as well?

> +
>  struct regmap {
>  	struct mutex lock;
> =20
> @@ -79,6 +91,10 @@ struct regmap {
> =20
>  	struct reg_default *patch;
>  	int patch_regs;
> +
> +#ifdef CONFIG_REGMAP_PAGING
> +	struct regmap_paging page;
> +#endif
>  };
> =20
>  struct regcache_ops {
> diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
> index 7a3f535..45794cc 100644
> --- a/drivers/base/regmap/regmap.c
> +++ b/drivers/base/regmap/regmap.c
> @@ -80,6 +80,24 @@ static bool regmap_volatile_range(struct regmap *map, =
unsigned int reg,
>  	return true;
>  }
> =20
> +#ifdef CONFIG_REGMAP_PAGING
> +static bool regmap_pageable_range(struct regmap *map, unsigned int reg,
> +				  unsigned int num)
> +{
> +	if (map->page.pageable_reg) {
> +		unsigned int i;
> +
> +		for (i =3D 0; i < num; i++)
> +			if (map->page.pageable_reg(map->dev, reg))
> +				return true;
> +
> +		return false;

Hrm.  I see where you're going with this test ("is any register in the
range pageable") but you could also read the function name as "is this
range of registers pageable".  Can we rename the function to
"has_pageable" instead to avoid confusion.

> +	}
> +
> +	return true;
> +}
> +#endif
> +
>  static void regmap_format_2_6_write(struct regmap *map,
>  				     unsigned int reg, unsigned int val)
>  {
> @@ -199,6 +217,17 @@ struct regmap *regmap_init(struct device *dev,
>  	map->volatile_reg =3D config->volatile_reg;
>  	map->precious_reg =3D config->precious_reg;
>  	map->cache_type =3D config->cache_type;
> +#ifdef CONFIG_REGMAP_PAGING
> +	map->page.page_mask =3D ((1 << config->page_bits) - 1) << config->reg_b=
its;
> +	map->page.reg_mask =3D (1 << config->reg_bits) - 1;
> +	map->page.reg_bits =3D config->reg_bits;
> +	map->page.pageable_reg =3D config->pageable_reg;
> +	map->page.sel_reg =3D config->page_sel_reg;
> +	map->page.sel_shift =3D config->page_sel_shift;
> +	map->page.sel_mask =3D ((1 << config->page_bits) - 1) <<
> +			     config->page_sel_shift;
> +#endif
> +
> =20
>  	if (config->read_flag_mask || config->write_flag_mask) {
>  		map->read_flag_mask =3D config->read_flag_mask;
> @@ -396,41 +425,66 @@ void regmap_exit(struct regmap *map)
>  }
>  EXPORT_SYMBOL_GPL(regmap_exit);
> =20
> -static int _regmap_raw_write(struct regmap *map, unsigned int reg,
> -			     const void *val, size_t val_len)
> -{
> -	u8 *u8 =3D map->work_buf;
> -	void *buf;
> -	int ret =3D -ENOTSUPP;
> -	size_t len;
> -	int i;
> +static int _regmap_update_bits(struct regmap *map, unsigned int reg,
> +			       unsigned int mask, unsigned int val,
> +			       bool *change);
> =20
> -	/* Check for unwritable registers before we start */
> -	if (map->writeable_reg)
> -		for (i =3D 0; i < val_len / map->format.val_bytes; i++)
> -			if (!map->writeable_reg(map->dev, reg + i))
> -				return -EINVAL;

Hrm.  diff has done something really odd here which makes things hard to
read...

> +#ifdef CONFIG_REGMAP_PAGING
> +static int _regmap_paged_access(struct regmap *map,
> +		int (*regmap_bus_access)(struct regmap *map, unsigned int reg,
> +					 void *val, unsigned int val_len),
> +		unsigned int reg, void *val, unsigned int val_len)
> +{
> +	unsigned int val_num =3D val_len / map->format.val_bytes;
> +	u8 *_val =3D val;
> +	unsigned int _reg =3D reg & map->page.reg_mask;
> +	unsigned int _page =3D reg >> map->page.reg_bits;
> +	unsigned int _num;
> +	size_t _len;
> +	bool change;
> +	int ret;
> =20
> -	if (!map->cache_bypass && map->format.parse_val) {
> -		unsigned int ival;
> -		int val_bytes =3D map->format.val_bytes;
> -		for (i =3D 0; i < val_len / val_bytes; i++) {
> -			memcpy(map->work_buf, val + (i * val_bytes), val_bytes);
> -			ival =3D map->format.parse_val(map->work_buf);
> -			ret =3D regcache_write(map, reg + i, ival);
> -			if (ret) {
> -				dev_err(map->dev,
> -				   "Error in caching of register: %u ret: %d\n",
> -					reg + i, ret);
> +	/* Split write into separate blocks, one for each page */
> +	while (val_num) {
> +		if ((_reg + val_num  - 1) >> map->page.reg_bits !=3D 0)
> +			_num =3D (map->page.reg_mask - _reg + 1);
> +		else
> +			_num =3D val_num;
> +
> +		if (regmap_pageable_range(map, _reg, _num)) {
> +			/* Update page selector, try to use cache.
> +			   Page selector is in nonpageable register, so it is
> +			   safe to reenter update function here. */
> +			ret =3D _regmap_update_bits(map,
> +						  map->page.sel_reg,
> +						  map->page.sel_mask,
> +						  _page << map->page.sel_shift,
> +						  &change);
> +			if (ret < 0)
>  				return ret;
> -			}
> -		}
> -		if (map->cache_only) {
> -			map->cache_dirty =3D true;
> -			return 0;
>  		}
> +
> +		_len =3D _num * map->format.val_bytes;
> +		ret =3D regmap_bus_access(map, _reg, _val, _len);
> +		if (ret < 0)
> +			return ret;
> +
> +		val_num -=3D _num;
> +		_val +=3D _len;
> +		_reg =3D 0;
> +		_page++;
>  	}
> =20
> +	return 0;
> +}
> +#endif /* CONFIG_REGMAP_PAGING */
> +
> +static int _regmap_bus_write(struct regmap *map, unsigned int reg,
> +			     void *val, size_t val_len)
> +{
> +	u8 *u8 =3D map->work_buf;
> +	int ret =3D -ENOTSUPP;
> +
>  	map->format.format_reg(map->work_buf, reg);
> =20
>  	u8[0] |=3D map->write_flag_mask;
> @@ -456,6 +510,9 @@ static int _regmap_raw_write(struct regmap *map, unsi=
gned int reg,
> =20
>  	/* If that didn't work fall back on linearising by hand. */
>  	if (ret =3D=3D -ENOTSUPP) {
> +		void *buf;
> +		size_t len;
> +
>  		len =3D map->format.reg_bytes + map->format.pad_bytes + val_len;
>  		buf =3D kzalloc(len, GFP_KERNEL);
>  		if (!buf)
> @@ -475,6 +532,52 @@ static int _regmap_raw_write(struct regmap *map, uns=
igned int reg,
>  	return ret;
>  }
> =20
> +static int _regmap_raw_write(struct regmap *map, unsigned int reg,
> +			     const void *val, size_t val_len)
> +{
> +	void *_val =3D (void *)val;
> +	int i;
> +	int ret;
> +
> +	/* Check for unwritable registers before we start */
> +	if (map->writeable_reg)
> +		for (i =3D 0; i < val_len / map->format.val_bytes; i++)
> +			if (!map->writeable_reg(map->dev, reg + i))
> +				return -EINVAL;
> +
> +	if (!map->cache_bypass && map->format.parse_val) {
> +		unsigned int ival;
> +		int val_bytes =3D map->format.val_bytes;
> +		for (i =3D 0; i < val_len / map->format.val_bytes; i++) {
> +			memcpy(map->work_buf, val + (i * val_bytes), val_bytes);
> +			ival =3D map->format.parse_val(map->work_buf);
> +			ret =3D regcache_write(map, reg + i, ival);
> +			if (ret) {
> +				dev_err(map->dev,
> +				   "Error in caching of register: %u ret: %d\n",
> +					reg + i, ret);
> +				return ret;
> +			}
> +		}
> +		if (map->cache_only) {
> +			map->cache_dirty =3D true;
> +			return 0;
> +		}
> +	}
> +
> +#ifdef CONFIG_REGMAP_PAGING
> +	/* Maintain paging, if enabled and register is page dependent */
> +	if (map->page.page_mask &&
> +	    !(map->page.sel_reg =3D=3D reg &&
> +	      val_len =3D=3D map->format.val_bytes)) {
> +		return _regmap_paged_access(map, &_regmap_bus_write,
> +					    reg, _val, val_len);
> +	}
> +#endif /* CONFIG_REGMAP_PAGING */
> +
> +	return _regmap_bus_write(map, reg, _val, val_len);
> +}
> +
>  int _regmap_write(struct regmap *map, unsigned int reg,
>  		  unsigned int val)
>  {
> @@ -494,6 +597,28 @@ int _regmap_write(struct regmap *map, unsigned int r=
eg,
>  	trace_regmap_reg_write(map->dev, reg, val);
> =20
>  	if (map->format.format_write) {
> +#ifdef CONFIG_REGMAP_PAGING
> +		/* Maintain paging, if enabled and register is page dependent */
> +		if (map->page.page_mask &&
> +		    map->page.sel_reg !=3D reg &&
> +		    (!map->page.pageable_reg ||
> +		     map->page.pageable_reg(map->dev, reg))) {
> +			unsigned int page =3D reg >> map->page.reg_bits;
> +			bool change;
> +
> +			/* Update page selector, when needed.
> +			   Page selector is in nonpageable register, so it is
> +			   safe to reenter for its update in here. */
> +			ret =3D _regmap_update_bits(map,
> +						  map->page.sel_reg,
> +						  map->page.sel_mask,
> +						  page << map->page.sel_shift,
> +						  &change);
> +			if (ret < 0)
> +				return ret;
> +		}
> +#endif
> +
>  		map->format.format_write(map, reg, val);
> =20
>  		trace_regmap_hw_write_start(map->dev, reg, 1);
> @@ -620,7 +745,7 @@ out:
>  }
>  EXPORT_SYMBOL_GPL(regmap_bulk_write);
> =20
> -static int _regmap_raw_read(struct regmap *map, unsigned int reg, void *=
val,
> +static int _regmap_bus_read(struct regmap *map, unsigned int reg, void *=
val,
>  			    unsigned int val_len)
>  {
>  	u8 *u8 =3D map->work_buf;
> @@ -649,6 +774,21 @@ static int _regmap_raw_read(struct regmap *map, unsi=
gned int reg, void *val,
>  	return ret;
>  }
> =20
> +static int _regmap_raw_read(struct regmap *map, unsigned int reg, void *=
val,
> +			    unsigned int val_len)
> +{
> +#ifdef CONFIG_REGMAP_PAGING
> +	/* Maintain paging, if enabled and register is page dependent */
> +	if (map->page.page_mask &&
> +	    !(map->page.sel_reg =3D=3D reg &&
> +	      val_len =3D=3D map->format.val_bytes))
> +		return _regmap_paged_access(map, &_regmap_bus_read,
> +					    reg, val, val_len);
> +#endif /* CONFIG_REGMAP_PAGING */
> +
> +	return _regmap_bus_read(map, reg, val, val_len);
> +}
> +
>  static int _regmap_read(struct regmap *map, unsigned int reg,
>  			unsigned int *val)
>  {
> @@ -792,11 +932,9 @@ static int _regmap_update_bits(struct regmap *map, u=
nsigned int reg,
>  	int ret;
>  	unsigned int tmp, orig;
> =20
> -	mutex_lock(&map->lock);
> -
>  	ret =3D _regmap_read(map, reg, &orig);
>  	if (ret !=3D 0)
> -		goto out;
> +		return ret;
> =20
>  	tmp =3D orig & ~mask;
>  	tmp |=3D val & mask;
> @@ -808,9 +946,6 @@ static int _regmap_update_bits(struct regmap *map, un=
signed int reg,
>  		*change =3D false;
>  	}
> =20
> -out:
> -	mutex_unlock(&map->lock);
> -
>  	return ret;
>  }
> =20
> @@ -828,7 +963,12 @@ int regmap_update_bits(struct regmap *map, unsigned =
int reg,
>  		       unsigned int mask, unsigned int val)
>  {
>  	bool change;
> -	return _regmap_update_bits(map, reg, mask, val, &change);
> +	int ret;
> +
> +	mutex_lock(&map->lock);
> +	ret =3D _regmap_update_bits(map, reg, mask, val, &change);
> +	mutex_unlock(&map->lock);
> +	return ret;
>  }
>  EXPORT_SYMBOL_GPL(regmap_update_bits);
> =20
> @@ -848,7 +988,12 @@ int regmap_update_bits_check(struct regmap *map, uns=
igned int reg,
>  			     unsigned int mask, unsigned int val,
>  			     bool *change)
>  {
> -	return _regmap_update_bits(map, reg, mask, val, change);
> +	int ret;
> +
> +	mutex_lock(&map->lock);
> +	ret =3D _regmap_update_bits(map, reg, mask, val, change);
> +	mutex_unlock(&map->lock);
> +	return ret;
>  }
>  EXPORT_SYMBOL_GPL(regmap_update_bits_check);
> =20
> diff --git a/include/linux/regmap.h b/include/linux/regmap.h
> index a90abb6..e4f9db0 100644
> --- a/include/linux/regmap.h
> +++ b/include/linux/regmap.h
> @@ -50,6 +50,14 @@ struct reg_default {
>   * @pad_bits: Number of bits of padding between register and value.
>   * @val_bits: Number of bits in a register value, mandatory.
>   *
> + * @page_bits: Number of address top-most bits designated to be page num=
ber.
> + *             These bits will be written to page selector, for page swi=
tch.
> + * @page_sel_reg: Register to update selected page in (available on any =
page).
> + * @page_sel_shift: Bit shift for page selector inside the register.
> + * @pageable_reg: Optional callback returning true, if a register needs
> + *                page switching (ie. it is page dependent). Register
> + *                in page_sel_reg is always considered as page independe=
nt.
> + *
>   * @writeable_reg: Optional callback returning true if the register
>   *                 can be written to.
>   * @readable_reg: Optional callback returning true if the register
> @@ -81,6 +89,13 @@ struct regmap_config {
>  	int pad_bits;
>  	int val_bits;
> =20
> +#ifdef CONFIG_REGMAP_PAGING
> +	int page_bits;
> +	unsigned int page_sel_reg;
> +	int page_sel_shift;
> +	bool (*pageable_reg)(struct device *dev, unsigned int reg);
> +#endif
> +
>  	bool (*writeable_reg)(struct device *dev, unsigned int reg);
>  	bool (*readable_reg)(struct device *dev, unsigned int reg);
>  	bool (*volatile_reg)(struct device *dev, unsigned int reg);


--wac7ysb48OaltWcw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPrQWeAAoJEBus8iNuMP3dyDwP/AxjdZYzHEDv5XaPSWjB/v0f
949ACue8Mn5cNMohDQidqDyBpwEWA69PXmJFcpwfjXb4YjFisEVa0lDbnVXQmws1
2I92pdcSpAvJN9SKvNvU9okcLi8WIMtCRefhWyOZfUwuLqEc7mcSO6ZulGoNhqR0
dD04N2KwEZcSbEt+TeX3NHhqVBoZimPea8Ab3uMfk5JjVuYq9N0LuHCaqHNRoED3
kyDIT8IAlmP3rNSD8nqXlu5tTc2o5oY3H4pYHSPdC2sCcNOrvj8riicciRbh7Kj+
U23iKlOz0/prFiM1NTCUzfARO8miuJTYJuCmPidc59sxnMKezD7k5CZLbsKUbJt4
oGiIFb1zyavwJg5+Qu2iwKCoY+rbkpI58N5H8RrDCxyhnon3sOWDOKpKXobSu/uo
C1l85Mjd1UBNGn4p1kCRpK3v1Vv1lHcwRiW5BUU9883++v2C7WJwTLeN5Q+sI9A6
QK6mRRc/0ACZuevHTGsxN9Kfc4OQYtFAgzMTARDuXCVdpZ3ALMJg/Nomx61UjHq8
SgAoMPOXATVTrIFCrKoMVcJHceQ7lx3GCONHQ5gfyRV1i7zsvrOTF8pbld7vFCkx
eKnz6EJmOS/1HQWon87Sg2igM9Pg0jTP+r6tLi9r3CC7mfTkTYRok2EjSg8upKu0
Q7VwRtReKv4NpwVgI62J
=ddBz
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--

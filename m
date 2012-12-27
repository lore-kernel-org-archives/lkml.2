Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab2L0SYH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 13:24:07 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51644 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751765Ab2L0SYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 13:24:04 -0500
Date: Thu, 27 Dec 2012 18:24:02 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: andrey.smirnov@convergeddevices.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Add "no-bus" option for regmap API
Message-ID: <20121227182401.GA6306@opensource.wolfsonmicro.com>
References: <1356083238-6932-1-git-send-email-andrew.smirnov@gmail.com>
 <1356083238-6932-4-git-send-email-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
In-Reply-To: <1356083238-6932-4-git-send-email-andrew.smirnov@gmail.com>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 21, 2012 at 01:47:18AM -0800, Andrey Smirnov wrote:

This looks really good, the issues and questions I have below are pretty
detailed.

> -	int (*reg_read)(struct regmap *map, unsigned int reg, unsigned int *val);
> -	int (*reg_write)(struct regmap *map, unsigned int reg, unsigned int val);
> +	int (*reg_read)(void *context, unsigned int reg, unsigned int *val);
> +	int (*reg_write)(void *context, unsigned int reg, unsigned int val);

I'd be inclined to just do this in the initial refectoring patches
rather than rerefactoring here.

> +	if (!bus || !bus->fast_io) {
>  		mutex_init(&map->mutex);
>  		map->lock = regmap_lock_mutex;
>  		map->unlock = regmap_unlock_mutex;
> +	} else {
> +		spin_lock_init(&map->spinlock);
> +		map->lock = regmap_lock_spinlock;
> +		map->unlock = regmap_unlock_spinlock;

It's not immediately obvious to me that no-bus should be forced to use
mutexes - is there any great reason for tying the two together?  I'd add
a flag to allow no-bus devices to choose, possibly as part of a separate
"bus" configuration thing that gets configured with a separate init
function.

> +	if (!bus) {
> +		map->cache_registers = true;
> +		goto skip_format_initialization;
> +	} else {
> +		map->reg_read = _regmap_bus_read;
> +	}

Not sure I understand cache_registers here.  Why has this flag been
added?

> + * @reg_read: Optional callback that if filled will be used to perform
> + *            all the reads from the registers.
> + * @reg_write: Optional callback that if filled will be used to perform
> + *             all the writes to the registers.

I'd probably add some comment about not using this in conjunction with
SPI or I2C.

--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ3JI7AAoJELSic+t+oim9TDIP/0PC4R1OvMVzCTmktiTKPKrR
J5yb+w9HI00H2ZUYhODr/04TbSi6A9txDjNZVPnIYI3Up0fih4n38kkVc5qkbgqX
1565fq0JezugJD+C65oK1mUjPkkOk7eXAozg0Z8QO9QxvvxII6q6YhZe+iy9h+wH
29cmB++/7w8dBPraqvhDPoI5f+ES/P68jdW+lFe61nC+Qizt4LI278NPTt/Dy2+t
y54i8zfWkBlF5rQFWbPLZob25l36sYCYmOEePYgBKri4crLPCw8PoYKu0JYv0lTn
a7s19AqppHb5AlFqPX5riCY4+mlKTCFTV0+zGXrp+6514/Ld5allKcug3vp+3eb0
V6VREOb0lRzxNFZokkh5154kAcYSsT5x0SikI8NSt1Nmtxvq+FqFJi6LtmTsDNTf
AMVeQNJcInnlhhWUgZK+7L9r5RGosuNSahXaoehjpCDN9t3RDCip01tx8EbndPvf
IDV+vHQMJtxieELnWUx6hpPhvh2v1gn/7TINOpkCU7bclY0SMNSw0bMABy/dSpQ0
SkIS24I0Nue9rF6A1jKrNpKii08tieJq8tHzSm0xt/eBo0GzUDcW/JiEGXx909jx
TZAa6FIEPiKuEQ3zPhd++fU5ceWCvPV/+PdCfgzjiI9pBFrMzvvBqCfBjGEmjUUr
Cb9wK563/SvpviFzxEpc
=V1rQ
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--

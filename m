Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab2EaRZp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 13:25:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39789 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753837Ab2EaRZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 13:25:44 -0400
Date: Thu, 31 May 2012 18:25:42 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Anthony Olech <Anthony.Olech@diasemi.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Javier Martin <javier.martin@vista-silicon.com>
Subject: Re: [PATCH 3/4] regmap: Add support for register indirect addressing.
Message-ID: <20120531172541.GM2666@opensource.wolfsonmicro.com>
References: <201205311619.q4VGJ8S2014801@sw-eng-lt-dc-vm2>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EE8jvUPYYQjJtG7J"
Content-Disposition: inline
In-Reply-To: <201205311619.q4VGJ8S2014801@sw-eng-lt-dc-vm2>
X-Cookie: You are fairminded, just and loving.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EE8jvUPYYQjJtG7J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 31, 2012 at 04:47:20PM +0200, Krystian Garbaciak wrote:

Adding people who've got some chips with paging, please keep them in the
CCs on this unless they complain (though since I'm cutting context...  :/ )

> +       /* Partition all accessible registers on address ranges,
> +          either to be accessed directly or indirectly. Arrange range
> +          list by ascending addresses. */

Wouldn't something naturally sorted like a rbtree be a more direct way
of doing this?

> +		range_cfg = NULL;
> +		for (n = 0, min_base = UINT_MAX; n < config->n_ranges; n++)
> +			if (range_base <= config->ranges[n].base_reg &&
> +			    config->ranges[n].base_reg <= min_base)
> +				range_cfg = &config->ranges[n];
> +

I've stared at this for a little while and I'm really not sure what it's
supposed to do.  The whole thing with min_base is just a bit odd, we're
doing comparisons against it but we never update it so why aren't we
using a constant, and in fact the comparison is always going to be true
since we're comparing against UINT_MAX.

I suspect it's supposed to pick the range with the lowest base but I'm
not convinced it does that.

> +		if (!range_cfg || range_cfg->base_reg > range_base) {
> +			/* Range of registers for direct access */
> +			range = kzalloc(sizeof(*range), GFP_KERNEL);
> +			if (range == NULL) {
> +				ret = -ENOMEM;
> +				goto err_range;
> +			}
> +			range->base_reg = range_base;
> +			if (range_cfg)
> +				range->max_reg = range_cfg->base_reg - 1;
> +			else
> +				range->max_reg = UINT_MAX;
> +			list_add_tail(&range->list, &map->range_list);
> +		}

This is making my head hurt too, possibly because of the lack of clarity
in the above.

> +static int _regmap_update_bits(struct regmap *map, unsigned int reg,
> +			       unsigned int mask, unsigned int val,
> +			       bool *change);

Put this up at the top of the file.

> +static int
> +_regmap_range_access(int (*regmap_bus_access)(struct regmap *map,
> +					      unsigned int reg,
> +					      void *val, unsigned int val_len),

eew, typedef this!

> +       unsigned int _page, _p;
> +       unsigned int _reg, _r;
> +       unsigned int _num;

These _s aren't helping legibility here.

> +	/* Bulk write should not cross single range boundaries */
> +	if (val_num != 0 &&
> +	    reg + val_num - 1 > range->max_reg)
> +		return -EINVAL;

When would val_num ever be zero?

> +			/* Update page register (may use caching) */
> +			ret = _regmap_update_bits(map, range->page_sel_reg,
> +						range->page_sel_mask,
> +						_page << range->page_sel_shift,
> +						&change);
> +			if (ret < 0)
> +				return ret;

Why the comment about the cache - why would this go wrong?

> +			/* There is no point to pass cache for data
> +			   registers, as they should be volatile anyway */
> +			ret = _regmap_range_access(regmap_bus_access,
> +						   map, _reg, _val, _num);
> +			if (ret < 0)
> +				return ret;

That comment needs some clarification too...

> +/**
> + * Configuration for indirect accessed register range.
> + * Indirect or paged registers, can be defined with one or more structures.

No , here.

> + * @translate_reg: Function should return indirect address/page number and
> + *                 register number (out of this range) matching virtual_reg.

Why does the user need to specify this?  Shouldn't we just specify a
size for the underlying window and then have a default which does the
obvious translations?  I'd imagine an *overwhelming* proportion of users
will want to do that.  Allowing an override is fine but requiring code
seems wrong for something like this.

--EE8jvUPYYQjJtG7J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPx6mPAAoJEBus8iNuMP3djwEP+QGRTqiO46klhSHwIbrzVP3b
YOR7NS1KR9oOXUrA63K/Tsio8zDP6wb9koO4fniuzFUwQSuZT+LYeM4KCKwptMn0
1Fv9OGG/kQ2GSb796MkuWqdVVrLgu7kI44cnGlra/qpFS1YiKeOoqnB4na9dxOrt
zNIOZ21Q6EREdmdeaW90JsYTcCWSMe8dkx8ldD1hC5lv7qBs9srp8wfcJIp93ZHG
godERCOhFRqJXRWIIvtGarbwNyuzSUhue0kNRxKGqLctm5nyDC7ZR6peeSq3KBlr
IEU+j4ryv46/gWjLdigcff7a/s3fa5iVBWmTHqMokqJyqrCM1MVEyQVrbGkf1EBC
ETYsoTQZmh+1ALQ4oIyUvMGfpTqpfIG/ChRqdZmE+DiuA09RIst5IOXCFJm2EOTk
rElV10oRcjkbWE7AZYSp6IsDw99RSMNROC192rOacoOF+2UePeiWiCdLapMyEFiD
V9taoDxmjsG7Qq2LEY5OjRKYVehrQDj8xI6QfGSycwkIZ601qn+36TYoreFcYC1E
lOGBoRXgbK9Jxh1eGw3xGKOBEewPS/jqBwdj3tOv0xItRcZJCQGrcdJsvO3/2lKv
1tMBvsNhC4sEF5gzUranyI18i1n3BooR0cSk/9bJNusEyPvH9SAN0aqmgYr5TcVW
DEHWR7bsCyuStyMdf/bi
=moTq
-----END PGP SIGNATURE-----

--EE8jvUPYYQjJtG7J--

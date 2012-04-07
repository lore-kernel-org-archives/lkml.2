Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab2DGJQl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 05:16:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55372 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751933Ab2DGJQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 05:16:40 -0400
Date: Sat, 7 Apr 2012 10:16:36 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] gpiolib: Implement devm_gpio_request_one()
Message-ID: <20120407091636.GD3099@opensource.wolfsonmicro.com>
References: <1333552489-27694-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1333552489-27694-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20120406044832.7C80D3E0ED5@localhost>
 <20120406144917.GE19424@opensource.wolfsonmicro.com>
 <20120407022512.2C65C3E1B12@localhost>
 <20120407090018.GC3099@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gE7i1rD7pdK0Ng3j"
Content-Disposition: inline
In-Reply-To: <20120407090018.GC3099@opensource.wolfsonmicro.com>
X-Cookie: Your ignorance cramps my conversation.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gE7i1rD7pdK0Ng3j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Apr 07, 2012 at 10:00:18AM +0100, Mark Brown wrote:
> On Fri, Apr 06, 2012 at 07:25:12PM -0700, Grant Likely wrote:

> > Actually, I looked at it again, and the _one version behaves subtly
> > different from the non-_one version.  That may be irrelevant though.

> It always does a direction set, yes.  This will make a difference if the
> direction call either fails or blocks future reconfigurations, what was
> puzzling me was if this was an issue or not and like I say I decided to
> assume it was and stick with the same pattern.

Just after sending this (isn't that always the way?) I realised there is
one important case where it makes a difference: if the code does this:

	gpio_request(foo, "bar");
	gpio_direction_output(foo, 1);

then if the GPIO was already driving out high we will maintain steady
state.  If, however, we were to do:

	gpio_request(foo, "bar");
	gpio_direction_input();
	gpio_direction_output(foo, 1);

where the first two calls are the natural result of implementing
gpio_request() in terms of gpio_request_one() then the GPIO would glitch
high Z during the process which might have unfortunate consequences for
whatever the GPIO is controlling.

I think instead of redoing the implementation we need start a campaign
to convert gpio_request() users to gpio_request_one() - coccinelle can
probably take a large chunk of the work but it'll need some manual help
I expect.

--gE7i1rD7pdK0Ng3j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPgAVzAAoJEBus8iNuMP3deooP/3VjlMMrOYrNwp+ZvR7OcWa+
pCnQSgsyjQSt3QmecYoa/v3xjfCnkXglKaoVIDa8/Zac9YFHhwJdWHXKBFy2+KBL
mOSX7sHCuRTj9Rt4yRgtI5CBRva1Bh33ZfyPHKeUSnKV5UNqaYeb2BYbx7rDtaI/
WHek48nN3GveoziTTd1dVcvcAPiDno+D6c2BZ7LMl8KyVJtf0uII+xvfxCwM+7KC
tmEs80PpPxfTpBcg6NmhJg5PgJRKUHB/7uvl3s7Ncphw9XRgm9vtWIxJsphRFBdG
P5X+YXZtl34zaN0+vrY/AalVmDDkOO1PbqhLAwn4pVK4UHYl0zxc8Ln3Fn+il0+o
vf5BBmnFByYGIlF6Q4ESu8Gbbl6yInFni+VbtBm6sQaX7AJxGkxu/T5I3pQDNeMJ
5F5K+xkewVpAak0bX9fZWd1JLS27b2h7lEmAbR0SX0zG0hYOgOkgHgGMdeLw3o1E
aQih+WMuYCLnjaBSpAyNwPuWPh2ADvwwuuLqNqsNK9oo21GGRwBf1cziO23mZkmK
7THuA41PnKFsae2GdmfQafCL74gYE3Cny0W4RFrHQNbSJthMfk4QBw9qef9O+rye
VwcexGDa+ZDOIv/+Ke5fVJgI7d2DFyqu6LM5ph8BADB+Oa10pW4aK+1Zy/8oThxe
xmdUAm9I6qdiWgXOEdcb
=OoUz
-----END PGP SIGNATURE-----

--gE7i1rD7pdK0Ng3j--

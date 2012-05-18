Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965698Ab2ERIps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 04:45:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53667 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932852Ab2ERIpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 04:45:30 -0400
Date: Fri, 18 May 2012 09:45:25 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Greg Kroah-Hartman <gregkh@suse.de>,
        Kevin Hilman <khilman@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] gpiolib: Defer failed gpio requests by default
Message-ID: <20120518084525.GG4073@opensource.wolfsonmicro.com>
References: <1335959380-8209-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20120518043219.740113E062C@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XStn23h1fwudRqtG"
Content-Disposition: inline
In-Reply-To: <20120518043219.740113E062C@localhost>
X-Cookie: The time is right to make new friends.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XStn23h1fwudRqtG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 17, 2012 at 10:32:19PM -0600, Grant Likely wrote:

> be done is to move the device to the end of the list.  The agreement
> when this was last discussed on the ML was to make the drivers do an
> explicit move immediately after it has validated all its dependencies.
> That is why it doesn't work to return -EPROBE_DEFER by default from
> helpers; because it becomes really hard to audit if the drivers are
> doing the right thing.

Ah, oh dear - I missed that bit of the discussion I'm afraid and had
thought we'd gone with your option 2 below.  This means that the ASoC
usage is currently not helping anything (though it's no worse than what
we had before), and the regulator framework usage won't do the right
thing (though in practice I don't expect it to actually go off and
there's fun and games associated with that if we actually need to
suspend regulators from software anyway).

> I see two solutions to this though;
> 1) add a new .preprobe hook to device drivers that will respect
>    -EPROBE_DEFER and ignore -EPROBE_DEFER on the regular .probe.
>    Probing a driver will call both, but if the .preprobe hook is
>    populated, then it will also reorder dpm_list between the two
>    calls.
>    - This still requires modifying drivers, but at least it is
>      auditable by mere-mortal reviewers.
>    - It also means all bus_type code has to add a new hook.  Blech.

Yeah, this seems very painful, especially the bit where we have to
change a good selection of buses and drivers to implement and use it.

> 2) simply force devices to the end of dpm_list before each probe
>    attempt (provided that it doesn't have any children).
>    - I've avoided this because it adds a claim of the dpm_list_mtx
>      mutex on every single probe call and adds a lot more manipulation
>      of the list....
>    - However, it should make your patch here actually safe.  If a
>      device gets deferred, it will be guaranteed to be at the end of
>      the list because it gets moved there on every probe attempt.
>    - also after reading through the code (see my notes below; I'm a
>      bit frustrated with the whole thing) I think it is probably the
>      right thing to do.

This does feel much more robust to me than manually reordering in
drivers, we'll have to see if it causes a performance problem though and
if it does perhaps we can handle it.

I guess the other thing is that if we get a lot of drivers implementing
deferral and we stop playing around with initcall stuff then we'll loose
a reasonable proportion of the advantage of not taking the mutex and
reordering.

Either of these options would avoid the surprise that currently exists
with the API.

> Will you be at Connect?  I could use some time sitting in a room with
> smart people to dig through this code and talk out what it should be
> doing.

I won't be unfortunately.

--XStn23h1fwudRqtG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPtgweAAoJEBus8iNuMP3dZHQP/1tuS1mFvt4mMV4WeZ2QbyJP
uCwU1rFiCz9+CF6y1eBad/6yP1dFQq3WnI0Ffv+cC5TYlwOhdeN3pdR9hbj4o76z
Qt0iIkPOWRxgza4nvuQu+j/IbM5kHDfh9e10fSmhrJ9UB1J7CBNH859or67QGxYY
MAv4V/hd4/K6QoZjXt6pSf4i9adwk4qx6dkPK3Edm4IyhPYQl5DqnV+P5dMCuZjO
JycIJ8FBBkgkxY2YEaDHI3ltB3R43gCXg7FoJ9C5tAl/uYh5YxgksiFnZzmOzJ9n
9pryaXoK8qDJHxPHiI7STSkconDvhAW/ncZyH0WtPorcklwGqMRg5/RZeZ9A4kXQ
rHKPr7wCXWkVYfHNYhC7D0NeO2ahFbZy1l6rkN0naJRzmTLDQx6Jissr3fKca+FN
6z4tRq54LWj3oLF3Iq/IiURmskEdQlUwgHwOwe+vCoSlVfTg+EfhPpgpKpYuZiey
Bxjv11U9C85DGnVwhcVIMFfad/5jbu0A+vRl1dog4zFUSD54/5d1KBc0m17452Us
uKdtPp5ap2UHEaHr25+qpKaIFYXWJMch5QgW1Wm1+P6EXfcxnjHN5gqWoi3qLnit
DCzaAjIOLs2pICPd+HTOxW0IGwgXd7sZsdpAtEK8MQaIRYUGBN1qXXyoH3PM2Evz
ZrVFKJRvXoLS0kqaIFLv
=16IX
-----END PGP SIGNATURE-----

--XStn23h1fwudRqtG--

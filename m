Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896Ab0GWSVb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 14:21:31 -0400
Received: from piggy.rz.tu-ilmenau.de ([141.24.4.8]:44058 "EHLO
	piggy.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341Ab0GWSVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 14:21:30 -0400
Date: Fri, 23 Jul 2010 20:21:16 +0200
From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: b43 wireless driver inhibits access to /dev/hwrng
Message-ID: <20100723182116.GB12795@darkside.kls.lan>
Mail-Followup-To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-kernel@vger.kernel.org
References: <20100722225212.GA19361@darkside.kls.lan>
 <20100723143219.GA2426@tuxdriver.com>
 <20100723153101.GA12795@darkside.kls.lan>
 <20100723173246.GC2426@tuxdriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cvVnyQ+4j833TQvp"
Content-Disposition: inline
In-Reply-To: <20100723173246.GC2426@tuxdriver.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cvVnyQ+4j833TQvp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 23, 2010 at 01:32:46PM -0400, John W. Linville wrote:
> Alright, sorry I overlooked that.  Although it still looks to me like
> your current_rng must be the b43-provided one, or else you wouldn't
> be experiencing this issue.

Yes. Unfortunately, the b43 module is loaded earlier than the via-rng
module: the former gets loaded via udev autodetection, the latter gets
loaded via my /etc/modules. Thus, the rng core selects b43 as the
"current" RNG.

> > I guess, b43 just stops delivering data through b43_rng_read() when the
> > hardware is shut down and instead returns ENODEV (which is btw. what I
> > get when I'm trying to read /dev/hwrng while b43 is down), and the rng
> Yes, I believe this is what the b43 hwrng is doing.  I suspect you
> need/want a way to influence current_rng to favor via-rng.  You may

Yes, once knowing what happens it was easy to find a work-around:

root@ideapad ~ # cat /etc/modprobe.d/local-b43-workaround.conf
# Work-around: b43 provides a Hardware RNG as well, but returns ENODEV
# on read() when the BCM4312 hardware is down.
# Ensure via-rng is loaded before this module. This way hw_random/core
# delivers read()s on /dev/hwrng to via-rng.
install b43 modprobe via-rng; modprobe --ignore-install b43 $CMDLINE_OPTS

> want to reference Documentation/hw_random.txt for further information.

Indeed, setting /sys/devices/virtual/misc/hw_random/rng_current would
probably be a cleaner solution :) Thanks for that.

However, I still somehow feel like this is a bug - either in the rng
core or in b43. One of both should IMHO be changed: either the rng core
to respect drivers not currently delivering data or (probably cleaner)
to provide an interface to suspend a driver, or the b43 driver to
unregister its rng when the hardware is shut down (or power it up when
the rng is accessed? probably a bit oversized :)).

Unfortunately, Documentation/hw_random.txt has no usage guidelines for
the rng core, i.e. how drivers should behave when no data is available.
It talks about a `hardware "has-data" flag', but I cannot find such a
thing in the code.


Thanks for your help and patience
   Mario
--=20
File names are infinite in length where infinity is set to 255 characters.
                                -- Peter Collinson, "The Unix File System"

--cvVnyQ+4j833TQvp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTEndnBS+e2HeSPbpAQLNZwf+O0vyBcWKRTA2IdwiHUG8BCWiW/2WO87b
mqbdcDHGs8mhMh+g0wf3/Lz+5M3GUhlYuyp1n+QxeriOe7g0Q5AglQQmTlU6tWoi
U2veOqPtPRGNrM6W/fxZjx3eNW37QF05AfsDFrZt1zF944Vc8AT524PC7z3/VHgE
lxq5KGbr0n6thrua1sEo92Ivk8gmqXpEdP5ScA03janwkZRTPFZuaKc4l5zJOPcn
2ul4jsKMaavMz8n4ze467+IRNzmcHfdSAtbT+UWR5ZfjISRz0gUWSJhwUWrglEQI
tjFPTIEoDTAthOq/UBOi7wZC5fOPDc9ul/GondvKmJtABwdU4DXAGw==
=84C9
-----END PGP SIGNATURE-----

--cvVnyQ+4j833TQvp--

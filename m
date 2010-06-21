Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab0FUHhu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 03:37:50 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53708 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab0FUHhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 03:37:46 -0400
Date: Mon, 21 Jun 2010 09:37:36 +0200
From: Luotao Fu <l.fu@pengutronix.de>
To: Martin Fuzzey <mfuzzey@gmail.com>
Cc: Luotao Fu <l.fu@pengutronix.de>, Sascha Hauer <kernel@pengutronix.de>,
       linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] imxfb: add flag to avoid disabling clk multiple times
Message-ID: <20100621073736.GA24817@pengutronix.de>
Mail-Followup-To: Martin Fuzzey <mfuzzey@gmail.com>,
	Luotao Fu <l.fu@pengutronix.de>,
	Sascha Hauer <kernel@pengutronix.de>, linux-fbdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1275561288-20661-1-git-send-email-l.fu@pengutronix.de> <4C1CE6B8.4090504@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
In-Reply-To: <4C1CE6B8.4090504@gmail.com>
X-PGP-Key-ID: 0xE5325261
X-URL: http://www.pengutronix.de/
X-Sent-From: Pengutronix Hildesheim
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:20:43 up 13 days, 23:48, 31 users,  load average: 0.44, 0.81,
	0.69
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Martin,

On Sat, Jun 19, 2010 at 05:48:08PM +0200, Martin Fuzzey wrote:
> Hi Luotao,
>=20
> Luotao Fu wrote:
> > while the imxfb driver blanks the screen. The clock supply to the frame=
buffer
> > controller is disabled. The same callback to disable the fb is, however=
, also
> > used the remove and shutdown hooks of the imxfb platform driver. This m=
eans that
> > the imxfb driver can run into a WARN in clock_disable while unloading or
> > rebooting, if the screen is blanked previously, since the same clock wi=
ll be
> > than eventually disabled multiple times.  This patch adds a flag to mak=
e sure
> > that the clock will only be disabled, if it was not already disabled be=
fore.
> >
> >  =20
> Actually it's worse than that - you don't need to unload the
> driver or reboot to run into this problem because imxfb_blank()
> calls imxfb_disable_controller() for cases
>     case FB_BLANK_POWERDOWN:
>     case FB_BLANK_VSYNC_SUSPEND:
>     case FB_BLANK_HSYNC_SUSPEND:
>     case FB_BLANK_NORMAL:
>=20
> Often an X server will call these after successive timeouts
> (eg Normal, Suspend, Powerdown) so you can get into the
> multiple suspend problem you describe just by waiting long
> enough for at least two blank levels to be activated.
>=20
> Furthermore once this happens, not only does a WARN occur
> in clock_disable but the clock usage counter will actually become
> negative so it will require multiple wake up requests to switch
> the display back on.
>=20
> I was just about to post a patch for this but I see you beat
> me to it :).
>=20
> Your patch fixes the clock_disable problem but fbi->backlight_power()
> and fbi->lcd_power() can still be called multiple times.
> Not sure if that is really a problem - they should be idempotent.
>=20

Multiple calling of the backlight_power and lcd_power function hooks
should be no trouble on most platforms since they mostly control some
PWM or GPIO lines, which won't complain to be turned on or off again.
Never the less I agree with you that this is quite unneccessary.

> I did it by making all of imxfb_disable_controller() do nothing if the
> disable was already done like this  (just for illustration not submission,
> lines may be mangled):
>=20

This solution looks better and more clear than mine, which only concentrate
on clock. Only nitpickings: I'd probably defined "enabled" as a bool. Furth=
er
it might be nice to change pr_debug so that one would see a failed
enable/disable call. some like
pr_debug("Disabling LCD controller ... ");

if (!fbi->enabled) {
	pr_debug("already disabled\n");
	return;
} else
		pr_debug("\n");

Applied and tested on my board here. (consolefb only, no X running.)
so far:
Acked-by: Luotao Fu <l.fu@pengutronix.de>

=20
thanks
and
cheers

Luotao Fu
--=20
Pengutronix e.K.                           | Dipl.-Ing. Luotao Fu        |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkwfFsAACgkQkLuxfMCkDTbl2wCfVsonYgBg2tOto4CdifufIwGD
bUIAn2KRo1r9NsAABc8K7sRQC7zjIFjM
=UEKx
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--

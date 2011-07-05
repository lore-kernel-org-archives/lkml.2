Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488Ab1GEMwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 08:52:39 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:43997 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932106Ab1GEMwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 08:52:37 -0400
Date: Tue, 5 Jul 2011 15:52:29 +0300
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Felipe Balbi <balbi@ti.com>, Partha Basak <p-basak2@ti.com>,
        Keshava Munegowda <keshava_mgowda@ti.com>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anand Gadiyar <gadiyar@ti.com>, sameo@linux.intel.com,
        parthab@india.ti.com, tony@atomide.com, Kevin Hilman <khilman@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, paul@pwsan.com, johnstul@us.ibm.com,
        Vishwanath Sripathy <vishwanath.bs@ti.com>
Subject: Re: [PATCH 6/6 v2] arm: omap: usb: global Suspend and resume support
 of ehci and ohci
Message-ID: <20110705125227.GI2820@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20110704093056.GD25295@legolas.emea.dhcp.ti.com>
 <Pine.LNX.4.44L0.1107041157360.12242-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hvDi6/M7gW6JbuLr"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1107041157360.12242-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hvDi6/M7gW6JbuLr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jul 04, 2011 at 12:01:24PM -0400, Alan Stern wrote:
> On Mon, 4 Jul 2011, Felipe Balbi wrote:
>=20
> > sounds to me like a bug on pm runtime ? If you're calling
> > pm_runtime_*_sync() family, shouldn't all calls be _sync() too ?
>=20
> No.  This was a deliberate design decision.  It minimizes stack usage=20
> and it gives a chance for some other child to resume before the parent=20
> is powered down.

fair enough.

> > > 		spin_unlock(&parent->power.lock);
> > >=20
> > > 		spin_lock(&dev->power.lock);
> > > 	}
> > > This is the reason of directly calling the parent Runtime PM calls fr=
om
> > > the children.
> > > If directly calling Runtime PM APIs with parent dev-pointer isn't
> > > acceptable,
> > > this can be achieved by exporting wrapper APIs from the
> > > parent and calling them from the chidren .suspend/.resume routines.
> >=20
> > Still no good, IMHO.
>=20
> The real problem here is that you guys are trying to use the runtime PM
> framework to carry out activities during system suspend.  That won't
> work; it's just a bad idea all round.  Use the proper callbacks to do
> what you want.

then what's the point in even having runtime PM if we will still have to
implement the same functionality on the other callbacks ? Well, of
course runtime PM will conserve power on runtime, but system suspend
should be no different other than an "always deepest sleep state"
decision.

The thing now is that pm_runtime was done so that drivers would stop
caring about clocks, which is a big plus, but if we still have to handle
->suspend()/->resume() differently, we will still need to clk_get();
clk_enable(); clk_disable(); Then what was the big deal with runtime PM?

IMHO, we should have only one PM layer. System suspend/resume should be
implemented so that core PM "forcefully" calls
->runtime_suspend()/->runtime_resume() of call drivers, all
synchronously. Maybe we need an extra
RPM_STATIC_SUSPEND_PLEASE_HANDLE_IT_ALL_SYNCHRONOUSLY flag, but that's
another detail.

If drivers are really supposed to stop handling clocks directly, then
runtime PM is THE framework to do that, but if we still have system
suspend/resume the old way, I don't see the benefit for the driver
(other than the uAmps saved during runtime, which is great, don't get me
wrong ;-) that this will bring. Having two PM layers which, in fact, are
doing the same thing - reducing power consumption - is just too much
IMO.

--=20
balbi

--hvDi6/M7gW6JbuLr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOEwkLAAoJEAv8Txj19kN1wtkH/RYY1tnz0ow0ZQMKqm/R8Fzs
R8xGWUGwFRW4Aw13gZgpM56uGwItP9T7yhkHCS3fCUoNXFsU+cRUUs3tjJY7rQbd
bzpXN4qw4U0Jjy1o7m/Smo9G4urcM6T2Uw0KLnWY2jSP6b+EnKVfmkScE/tZjIc8
cHq0D3/FjNS+jij0Fr2F+Zav+t5pXWzFuCVrttbDRkLcWMl5XBFFKNBJ68UWCVw2
f+oLFQ4ZAlIah0kzF9tI28Zn7BWEqxNeIM00nu+wx8UjnQoVJOca7uaRapecaK19
kB95F5dWuSIRff8ZbwgvXM1x2I977wYLDzVmnZBA0SDwP48YhmXbMnYiWmfqd7E=
=VQRv
-----END PGP SIGNATURE-----

--hvDi6/M7gW6JbuLr--

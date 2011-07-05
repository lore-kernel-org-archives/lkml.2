Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab1GEPxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 11:53:25 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:49248 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751031Ab1GEPxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 11:53:24 -0400
Date: Tue, 5 Jul 2011 18:53:14 +0300
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Felipe Balbi <balbi@ti.com>, Partha Basak <p-basak2@ti.com>,
        Keshava Munegowda <keshava_mgowda@ti.com>,
        USB list <linux-usb@vger.kernel.org>, linux-omap@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Anand Gadiyar <gadiyar@ti.com>, sameo@linux.intel.com,
        parthab@india.ti.com, tony@atomide.com, Kevin Hilman <khilman@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, paul@pwsan.com, johnstul@us.ibm.com,
        Vishwanath Sripathy <vishwanath.bs@ti.com>
Subject: Re: [PATCH 6/6 v2] arm: omap: usb: global Suspend and resume support
 of ehci and ohci
Message-ID: <20110705155312.GQ2820@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20110705125227.GI2820@legolas.emea.dhcp.ti.com>
 <Pine.LNX.4.44L0.1107050958090.2060-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AGgF02x1jLHCLk2P"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1107050958090.2060-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AGgF02x1jLHCLk2P
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 05, 2011 at 10:17:14AM -0400, Alan Stern wrote:
> On Tue, 5 Jul 2011, Felipe Balbi wrote:
>=20
> > > The real problem here is that you guys are trying to use the runtime =
PM
> > > framework to carry out activities during system suspend.  That won't
> > > work; it's just a bad idea all round.  Use the proper callbacks to do
> > > what you want.
> >=20
> > then what's the point in even having runtime PM if we will still have to
> > implement the same functionality on the other callbacks ?
>=20
> You don't have to duplicate the functionality.  You can use exactly the
> same functions for both sets of callbacks if you want; just make sure
> the callbacks point to them.

true, good point.

> >  Well, of
> > course runtime PM will conserve power on runtime, but system suspend
> > should be no different other than an "always deepest sleep state"
> > decision.
>=20
> No, it is significantly different for several reasons.  Some of the
> most important differences are concerned with freezing userspace and
> deciding what events should be allowed to wake up the system.  Also,=20
> there are systems which can achieve greater power savings by system=20
> sleep than they can by runtime PM + cpuidle.

I remember we've been through this discussion before and it's just
nonsensical to make such statement. What does freezing userspace have to
do with power consumption ? If you can't reach lower power consumption
with runtime PM it only means userspace is waking the system too much.

> > The thing now is that pm_runtime was done so that drivers would stop
> > caring about clocks, which is a big plus, but if we still have to handle
> > ->suspend()/->resume() differently, we will still need to clk_get();
> > clk_enable(); clk_disable(); Then what was the big deal with runtime PM?
>=20
> I don't know about that.  Clock usage has always been internal to the
> implementation you guys have been working on, and I haven't followed
> it.  If your implementation was designed incorrectly, well, that's a
> shame but it's understandable.  Things like that happen.  It shouldn't
> be too hard to fix.
>=20
> But first you do need to understand that system suspend really _is_=20
> different from runtime suspend.  Sure, you may be able to share some=20
> code between them, but you should not expect to be able to use one in=20
> place of the other.

I really fail to see why not, and maybe it's only my fault and I need to
read the Documentation/ more carefully :-s

> > IMHO, we should have only one PM layer. System suspend/resume should be
> > implemented so that core PM "forcefully" calls
> > ->runtime_suspend()/->runtime_resume() of call drivers, all
> > synchronously. Maybe we need an extra
> > RPM_STATIC_SUSPEND_PLEASE_HANDLE_IT_ALL_SYNCHRONOUSLY flag, but that's
> > another detail.
>=20
> Statements like this should be posted to linux-pm where they can be=20
> discussed properly.  It certainly isn't fair to make such claims=20
> without even CC-ing the PM maintainer.
>=20
> Besides, handling runtime PM synchronously won't do you any good if the=
=20
> user has disabled runtime PM via sysfs or not enabled=20
> CONFIG_PM_RUNTIME in the first place.  Have you forgotten about those=20
> possibilities?

I thought that the "we should have only one PM layer" already carried
the idea that CONFIG_PM and CONFIG_PM_RUNTIME would be combined into
one, and sysfs would need a little re-factoring...

> Furthermore, from what I've gathered so far from this thread, the
> _real_ problem is that nobody has written suspend and resume callbacks
> for the parent device.  You're relying on runtime PM to do things with
> the parent, but instead you should make use of the usual system sleep
> mechanism: Parents are always suspended after their children and
> awakened before.  Have the parent's suspend routine disable the clocks=20
> and have the resume routine enable them.  Problem solved, no changes=20
> needed in the child's driver code.

that's currently hidden on the omap rutime pm support. No driver is to
talk to clk API directly anymore. Granted, now that I read what I just
wrote it does sound like it's a limitation, although it's really nice
not to have to remember all the numerous clocks needed for a particular
device to work properly. So, if there would be a way, other than
pm_runtime_resume(), to enable all clocks a particular device has
without really having to clk_get(); clk_enable() each one of them, fine,
this would be solved. But as of today, we only have pm_runtime_resume()
to achieve that, unless I'm missing something.

--=20
balbi

--AGgF02x1jLHCLk2P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOEzNoAAoJEAv8Txj19kN18bwH/iJYhNwdFImykIxMFtrUh2gN
2iIwbEIYMaZZFClQFsyunW3uoLrSS7bhXAu1lzqgfMTEwe9TSeCYutZ6nnf7v/q1
LI0jhx6u+9AilxIbSg48y3BDK+bqNKNehdS5W8JthXI07g2rqDIEAcInOgAgoJuk
zgqfpQ6VayjWZufWQ87vkHbYqj/g+e5hYDlyeOGCxbUV8C9ZbluQd4VMPbVWb+dr
zc6jisoNLbBXCyvrFMDsuAWuCdgtfiG+xBkJ0TBSP+u4joMYxwp4uMYswokW3JFf
i+EaSD7Waa6SN6/PgJsZEH0FN8SjFB6akCUKGzgSIzBlif/QS9InY9mq0Wg6UzI=
=3yuM
-----END PGP SIGNATURE-----

--AGgF02x1jLHCLk2P--

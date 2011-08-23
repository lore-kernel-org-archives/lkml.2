Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab1HWPF5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 11:05:57 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:35035 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754966Ab1HWPFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 11:05:52 -0400
Date: Tue, 23 Aug 2011 18:05:48 +0300
From: Felipe Balbi <balbi@ti.com>
To: Michal Nazarewicz <mnazarewicz@google.com>
Cc: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yang Rui Rui <ruirui.r.yang@tieto.com>,
        Dave Young <hidave.darkstar@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/4] usb: gadget: replace "is_dualspeed" with
 "max_speed"
Message-ID: <20110823150547.GN1341@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <cover.1313791722.git.mina86@mina86.com>
 <accba3196fa1fe04f6110b350c03488acb785abe.1313791722.git.mina86@mina86.com>
 <20110819232805.GC13317@legolas.emea.dhcp.ti.com>
 <op.v0n5y4o0vgw7ix@mnazarewicz-glaptop>
 <20110823135817.GJ1341@legolas.emea.dhcp.ti.com>
 <op.v0n67imkvgw7ix@mnazarewicz-glaptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1VtFtf1bAEcuptAG"
Content-Disposition: inline
In-Reply-To: <op.v0n67imkvgw7ix@mnazarewicz-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1VtFtf1bAEcuptAG
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Aug 23, 2011 at 04:15:08PM +0200, Michal Nazarewicz wrote:
> On Tue, 23 Aug 2011 15:58:17 +0200, Felipe Balbi <balbi@ti.com> wrote:
>=20
> >>On Sat, 20 Aug 2011 01:28:06 +0200, Felipe Balbi <balbi@ti.com> wrote:
> >>>IMHO the logic is inverted here. It should start from the function
> >>>drivers. They should say which USB speeds they support, that
> >>>would go up to composite layer and composite would call e.g.
> >>>usb_gadget_set_speed(gadget, maximum_speed);
> >>
> >>This is actually not how composite works at the moment.  Currently,
> >
> >my suggestion was exactly to change that :-) Speed is something
> >functions support. composite.c shouldn't dictate which speed functions
> >should use, rather composite.c should use the maximum speed which all
> >functions support.
>=20
> Strictly speaking, composite.c does not dictate anything.   It just copies
> what the composite gadget driver declared as maximum speed.

true.

> My understanding was that one could consciously create a composite gadget
> such that not all of the functions support all of the speeds.

of course, but if he puts FS function and SS function on the same
configuration, SS function will have to come down to FS, no ?

> >>a composite gadget can declare a maximum speed of say =E2=80=9Chigh=E2=
=80=9D even if
> >>all the functions do not support that speed.  Of course when host asks
> >>about descriptors for given speed, only functions that support that
> >>speed will be returned (and hence only configurations that have at
> >>least one function supporting that speed).
> >>
> >>Whether the behaviour should be changed is, in my opinion, issue
> >>separate from the patchset that I'm sending.
> >
> >I wouldn't say that, actually. Just replacing is_dualspeed with
> >max_speed isn't changing much and if you want to make that part of the
> >code better, why not doing The Right Thing(TM) ?
>=20
> I'm just saying that the main reason for this patchset is to get rid of
> the USB_GADGET_DUALSPEED and USB_GADGET_SUPERSPEED Kconfig options.  So

yes, but for removing USB_GADGET_DUALSPEED there's no requirement, per
se, to remove is_dualspeed, am I right ? I could be missing something.

> the purpose of changing is_dualspeed with max_speed is to be able to
> check if gadget is super speed at run-time so that gadget_is_superspeed()
> can be implemented.

I understand. It does sound better than adding is_superspeed flag.

> So I would like to just get this done and then figure out what to do with
> composite.c.  How does that sound?

When you put it that way, I guess I must agree ;-)

> >All of the speed negotiation between composite.c and f_*.c should happen
> >before even connecting to host
>=20
> Yep, obviously.  The usb_gadget_probe_driver() is called at the very and
> once all the functions and everything is added so composite.c can do all
> the analysis it wants and figure out the maximum speed.
>=20
> >(before attaching data pullups, enabling IRQs, etc), that's exactly why
> >me and Sebastian have decided (at that time off list) to add
> >udc_start()/udc_stop() methods.
>=20
> I don't really follow why those would be needed...

Ok, I guess I need to give the full picture here, my bad.

Let's say you have a SuperSpeed controller, but you know that this
particular gadget driver can only support fullspeed, so why do you need
to go through RX detection, HS chirp sequence and whatnot if you can
decide the maximum_speed before kickstarting the UDC's state machine ?

most controllers (or at least the ones I have seen) have ways to set the
maximum_speed we are going to support. As of today, we always, blindly,
set the maximum supported by the controller, but that can change
overtime.

This might (and I never tested) mean we would be saving a few uA in the
sense that unused HW blocks wouldn't even be powered up (at the least
the more recent cores have quite a fine grain control over what powers
up and what doesn't).

> >One of the reason was that it would be a quite intrusive change to
> >all UDC drivers, second we wanted to give maintainers/authors of
> >those UDC drivers some grace period for the change, third  when
> >all UDCs are converted, it allow us to do the speed negotiation
> >before connecting to host.
>=20
> Again, I don't follow.  We can figure out the max_speed before calling
> usb_gadget_probe_driver() just fine.  We don't even have to have UDC
> to figure that out (ie. gadget driver's max_speed does not change
> depending on UDC, right?).

it doesn't change depending on UDC, but UDC can take certain decisions
depending on the maximum_speed current gadget driver supports ;-)

> >you already maximum_speed (below) and speed alone looses some extra
> >hint of what kind of information will be there. I think it's better to
> >change this to current_speed and make a symbolic link called 'speed'
> >which we can keep for the next 5 years and remove it in e.g. Linux v5.0
>=20
> OK, I'll do that (as soon as I figure out/recall how to make symlinks that
> is ;) ).

yeah, I would have to go through the same re-education ;-)

(please add a note on feature-removal-schedule too)

--=20
balbi

--1VtFtf1bAEcuptAG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOU8HLAAoJEAv8Txj19kN1ys0IAKF82XEkZbeavx98BL7vLcLx
FSEegsfFYYkYEtvHwmFxXeBw2fxekqADijUz29lu+T6VP3u3le1oW+1hb3dS8fOI
oA1567RbFiqYuYPqlRMQ2JSNtI/tB6T6W6ZqfiRqwcUPSOjYNipuagNmQ42KhmE2
2PpSWYiaVDdy2zaVE/0ZNyBY8xhVsEs/fMY8gMcb0qGI4YlekCoezY9gQJ3zGhXW
FBNvOZKkHkOw0ZUNctim2ueJAC0/NIHtJESl1h5xm1WuzVy1cdz18bjaNrhoZhrn
aQWqYZ8VpGGUHc9XpPytIRr/yRRL1GH6w0JynYmvxO/MhlyNTifr8Zr/bRVCZmE=
=a8Bh
-----END PGP SIGNATURE-----

--1VtFtf1bAEcuptAG--

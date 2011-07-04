Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab1GDJbI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 05:31:08 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:54582 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754177Ab1GDJbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 05:31:05 -0400
Date: Mon, 4 Jul 2011 12:30:57 +0300
From: Felipe Balbi <balbi@ti.com>
To: Partha Basak <p-basak2@ti.com>
Cc: balbi@ti.com, Alan Stern <stern@rowland.harvard.edu>,
        Keshava Munegowda <keshava_mgowda@ti.com>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anand Gadiyar <gadiyar@ti.com>, sameo@linux.intel.com,
        parthab@india.ti.com, tony@atomide.com, Kevin Hilman <khilman@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, paul@pwsan.com, johnstul@us.ibm.com,
        Vishwanath Sripathy <vishwanath.bs@ti.com>
Subject: Re: [PATCH 6/6 v2] arm: omap: usb: global Suspend and resume support
 of ehci and ohci
Message-ID: <20110704093056.GD25295@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1309546474-15363-7-git-send-email-keshava_mgowda@ti.com>
 <Pine.LNX.4.44L0.1107011504530.1624-100000@iolanthe.rowland.org>
 <11640ef76f97628579e457b5c6a74cc3@mail.gmail.com>
 <20110704082553.GH15044@legolas.emea.dhcp.ti.com>
 <99b22453092fc32b751c3e7d0223c7eb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DiL7RhKs8rK9YGuF"
Content-Disposition: inline
In-Reply-To: <99b22453092fc32b751c3e7d0223c7eb@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DiL7RhKs8rK9YGuF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jul 04, 2011 at 02:56:30PM +0530, Partha Basak wrote:
> >> Both for EHCI & OHCI, the clocks are owned by the parent (uhh-tll).
> >>
> >> Calling pm_runtime_put_sync(dev->parent) within omap_ehci_suspend will
> >> turn-off the parent clocks in the Suspend path.
> >>
> >> Similarly, calling pm_runtime_get_sync(dev->parent) within
> >> omap_ehci_resume will turn-on the parent clocks in the resume path.
> >>
> >> This way, all reference counting are implicit within the Runtime PM
> >> layer and takes care of all combinations of only EHCI insmoded, OHCI
> >> insmoded, both insmoded etc.
> >>
> >> When both EHCI & OHCI are suspended, parent clocks will actually be
> >> turned OFF and vice-versa.
> >
> >not sure this is necessary. I would expect:
> >
> >pm_runtime_get_sync(dev) to propagate up the parent tree and enable all
> >necessary resources to get the child in a working state. IOW, you
> >shouldn't need to manuall access the parent device.
> >
> Refer to the description in Patch(5/6)
> <snip>
> In fact, the runtime framework takes care the get sync and put sync of the
> child
> in turn call the get sync and put sync of parent too; but calling get sync
> and
> put sync of parent is by ASYNC mode;
> This mode queues the work item in runtime pm work queue,
> which not getting scheduled in case of global suspend path.
> <snip>
> This approach was tried, but did not work in the Suspend path

sounds to me like a bug on pm runtime ? If you're calling
pm_runtime_*_sync() family, shouldn't all calls be _sync() too ?

> static int rpm_suspend(struct device *dev, int rpmflags)
> 	__releases(&dev->power.lock) __acquires(&dev->power.lock)
> {
> .
> .
> .
> no_callback:
> .
> .
> .
> 	/* Maybe the parent is now able to suspend. */
> 	if (parent && !parent->power.ignore_children &&
> !dev->power.irq_safe) {
> 		spin_unlock(&dev->power.lock);
>=20
> 		spin_lock(&parent->power.lock);
> 		rpm_idle(parent, RPM_ASYNC);

to me this is bogus, if you called pm_runtime_put_sync() should should
be sync too. Shouldn't it ?

> 		spin_unlock(&parent->power.lock);
>=20
> 		spin_lock(&dev->power.lock);
> 	}
> This is the reason of directly calling the parent Runtime PM calls from
> the children.
> If directly calling Runtime PM APIs with parent dev-pointer isn't
> acceptable,
> this can be achieved by exporting wrapper APIs from the
> parent and calling them from the chidren .suspend/.resume routines.

Still no good, IMHO.

--=20
balbi

--DiL7RhKs8rK9YGuF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOEYhQAAoJEAv8Txj19kN1/UIH/127HFZWPHj+eerNxAGfhuNh
Lc6DDE7q6H/09qlPEPUl0MLwtNmchh1SRsCRgjZJ4GwJdR28nmuuxShvSQ8vwK2f
5ZF3FWdDKsvOtovrZBcEi45lsWvbaQ/CCGoAEb2lmsqFPSGOymngXDnKbKIpWQJW
+zVI3xHyYyBLzfZkjNds1JDMZHQHfJAyxOcu0UIaNdAADdHHhFulBLxWiSbhT26a
FFUGbWL8Tam7zk4Mrye5o4DWENRZkqBEOj8KswMd4pvp83yDO78/T8NYIIxqGv3I
gb4IPcpOZ2xpw3kPw1vZY/lDA4NTjP3/YYuI+gVGrTKNVz6vGaTwVbZPFYbfyes=
=PIdr
-----END PGP SIGNATURE-----

--DiL7RhKs8rK9YGuF--

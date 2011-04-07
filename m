Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab1DGV60 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 17:58:26 -0400
Received: from liberdade2.minaslivre.org ([74.50.53.203]:40635 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab1DGV6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 17:58:25 -0400
Date: Thu, 7 Apr 2011 18:58:17 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Ilkka Koskinen <ikoskine@nokia.com>
Cc: Ilkka Koskinen <ilkka.koskinen@nokia.com>, eric.piel@tremplin-utc.net,
        mjg@redhat.com, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, samu.p.onkalo@nokia.com,
        linux-input@vger.kernel.org
Subject: Re: [RFC PATCHv2 4/5] hwmon: lis3: Remove the referencies to the
 global variable in core driver
Message-ID: <20110407215817.GB5065@nautilus.holoscopio.com>
References: <1302014714-7334-1-git-send-email-ilkka.koskinen@nokia.com>
 <1302014714-7334-5-git-send-email-ilkka.koskinen@nokia.com>
 <20110405155007.GB2454@nautilus.holoscopio.com>
 <alpine.DEB.2.00.1104071448290.9511@tumpelo.nmp.nokia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NDin8bjvE/0mNLFQ"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1104071448290.9511@tumpelo.nmp.nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NDin8bjvE/0mNLFQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 07, 2011 at 02:59:48PM +0300, Ilkka Koskinen wrote:
>=20
> Hi,
>=20
> Thanks for the comments!
>=20
> On Tue, 5 Apr 2011, ext Thadeu Lima de Souza Cascardo wrote:
> >On Tue, Apr 05, 2011 at 05:45:13PM +0300, Ilkka Koskinen wrote:
> >>Signed-off-by: Ilkka Koskinen <ilkka.koskinen@nokia.com>
> >>---
> >> drivers/misc/lis3lv02d/lis3lv02d.c |  237 ++++++++++++++++++++--------=
--------
> >> drivers/misc/lis3lv02d/lis3lv02d.h |    3 +
> >> 2 files changed, 135 insertions(+), 105 deletions(-)
>=20
> >>@@ -980,14 +1003,18 @@ int lis3lv02d_init_device(struct lis3lv02d *lis3)
> >> 				thread_fn,
> >> 				IRQF_TRIGGER_RISING | IRQF_ONESHOT |
> >> 				irq_flags,
> >>-				DRIVER_NAME, &lis3_dev);
> >>+				DRIVER_NAME, lis3);
> >>
> >> 	if (err < 0) {
> >> 		pr_err("Cannot get IRQ\n");
> >> 		goto out;
> >> 	}
> >>
> >>-	if (misc_register(&lis3lv02d_misc_device))
> >>+	lis3->miscdev.minor	=3D MISC_DYNAMIC_MINOR;
> >>+	lis3->miscdev.name	=3D "freefall";
> >>+	lis3->miscdev.fops	=3D &lis3lv02d_misc_fops;
> >>+
> >>+	if (misc_register(&lis3->miscdev))
> >> 		pr_err("misc_register failed\n");
> >
> >You should not use miscdevice in case there will be multiple devices.
> >First, it will fail. There cannot be more than one device with the same
> >name. Second, current dynamic minor devices is restricted to 64 devices.
> >Since this is reserved to one-shot devices, freefall was OK as a misc
> >device until you fixed it to allow multiple freefall devices.  :-)
>=20
> Ah, true :)
>=20
> >So, I'd recommend switching to a new device class, and have freefall0,
> >freefall1, etc.
>=20
> I wonder if introducing a new class makes sense. I mean, I can
> figure out use cases for several accelerometers but for several free
> fall sensors? :/
>=20
> Would it be better to add a mechanism to tell to the core module if
> the particular device is used for free fall detection or not?
>=20
> Cheers, Ilkka
>=20

I would suggest an input handler or just letting userspace handle that
using input events. Then, I checked out the code and realized that this
is done by the hardware, using an interrupt. Should we handle said
interrupt as a particular kind of event (perhaps a new misc event)?

I've written classmate-laptop driver, which has an accelerometer too
(using ACPI). Should we start documenting how accelerometer drivers
should be written? Input event devices are the best class, but I've seen
cases where drivers use sysfs files. In fact, I've just checked and seen
that lis3lv02d does that too, in the file position. But I've seen
drivers out there that use one file per axis. I guess that's the way
hwmon drivers usually do things, creating sysfs files.

Should we start standardizing these drivers? I think input devices are
good enough to report the data, including for 2-axis devices (I have one
SPI "inclinometer" here - how those should be distinguished?). sysfs
files would be nice for setting parameters. classmate-laptop, for
example, has a sensitivity parameter. Besides freefall, lis3 seems to
have a selftest function and a rate setting.

One last email in linux-input and pdx lists has requested a new MISC
event to report a change in direction for some devices. Although I think
freefall and change in direction could be computed using the
accelerometer values in userspace, these devices do it directly. How
should we handle them in a standard way?

I would like to gather some opinions before writing a draft of
recommendations for writing such drivers. Is linux-input the best forum
for this?

Regards,
Cascardo.


> >Anyway, good job on this.
> >
> >Regards,
> >Cascardo.
>=20

--NDin8bjvE/0mNLFQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJNnjN4AAoJEEWxSg7udFZIRKYP/2nM5A3mdEhj5sDm30K4Kzeh
4QYIvtIXERa1p+Vg1yjlOgfwNGrVwLuQAzA4yXfR6qaGcwjq1ftAwjAgUHZMsHBA
F9zMAnk/HBtA/vh9dM2vZx+ubtpADzZ1RG9VtLnXs+kqku58L9cEjyl5G6HB1xDu
YVSdTKW6V8nFdEET5LI5iMNpwypXJaQIpbJUYUvjqWGSFdk6+/4gZeCUaJtS59VZ
SL35g25y7SdDjOSqStHIJViHzdF+ySy4nhi3MNYtvVcW1+YEdWYI+PE4bN3eiq+6
D9OTv1lF9lpGdx86zj4eN+8KOkNWX4amRoG8CExITHEqyigPHOKw3tlHzBrj7j5K
pN1pKPfeMSCeGUh/ttolajj5+QAUMqfCRXaiyMUzo3urSOkDseYzvMqRHZ923nXu
wSqu4e246f2c241e8f9Wnq5GUdmxZNxKbUb9OKNu96MnJUvCQcW3dGJ0ck+rCGeI
4xGu4vgNITpPmKwRx9Pnl4UoYzAd2iYRnzOI6tugC560gdcmrUhvzgD9JiMShq07
WDYawulg8ixyxuaL/TY7X23Oq1fLlo3ZIEEANoUPeYeC8WbqO5uPbN15ZCAiIjVD
Bdv9NZaHrMfWxfsG4bk+SABc9hOWPqyT9RV1Q+OjPoScFHi6gfUVQVij9vVDywNi
YeYDbeOGBV9ozfLXypXJ
=lKky
-----END PGP SIGNATURE-----

--NDin8bjvE/0mNLFQ--

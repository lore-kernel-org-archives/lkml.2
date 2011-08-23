Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab1HWN6a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 09:58:30 -0400
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:56908 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751384Ab1HWN6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 09:58:23 -0400
Date: Tue, 23 Aug 2011 16:58:17 +0300
From: Felipe Balbi <balbi@ti.com>
To: Michal Nazarewicz <mnazarewicz@google.com>
Cc: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yang Rui Rui <ruirui.r.yang@tieto.com>,
        Dave Young <hidave.darkstar@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/4] usb: gadget: replace "is_dualspeed" with
 "max_speed"
Message-ID: <20110823135817.GJ1341@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <cover.1313791722.git.mina86@mina86.com>
 <accba3196fa1fe04f6110b350c03488acb785abe.1313791722.git.mina86@mina86.com>
 <20110819232805.GC13317@legolas.emea.dhcp.ti.com>
 <op.v0n5y4o0vgw7ix@mnazarewicz-glaptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="crFW2+mWrWMXeHsA"
Content-Disposition: inline
In-Reply-To: <op.v0n5y4o0vgw7ix@mnazarewicz-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--crFW2+mWrWMXeHsA
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Aug 23, 2011 at 03:48:30PM +0200, Michal Nazarewicz wrote:
> Sorry, I somehow missed this mail before.

np

> >On Sat, Aug 20, 2011 at 12:33:00AM +0200, Michal Nazarewicz wrote:
> >>This commit replaces usb_gadget's is_dualspeed field with
> >>a max_speed field.
> >>
> >>This change is made so that one will be able to check at
> >>run-time if given gadget supports super speed.
>=20
> On Sat, 20 Aug 2011 01:28:06 +0200, Felipe Balbi <balbi@ti.com> wrote:
> >IMHO the logic is inverted here. It should start from the function
> >drivers. They should say which USB speeds they support, that would go up
> >to composite layer and composite would call e.g.
> >usb_gadget_set_speed(gadget, maximum_speed);
>=20
> This is actually not how composite works at the moment.  Currently,

my suggestion was exactly to change that :-) Speed is something
functions support. composite.c shouldn't dictate which speed functions
should use, rather composite.c should use the maximum speed which all
functions support.

> a composite gadget can declare a maximum speed of say =E2=80=9Chigh=E2=80=
=9D even if
> all the functions do not support that speed.  Of course when host asks
> about descriptors for given speed, only functions that support that
> speed will be returned (and hence only configurations that have at
> least one function supporting that speed).
>=20
> Whether the behaviour should be changed is, in my opinion, issue
> separate from the patchset that I'm sending.

I wouldn't say that, actually. Just replacing is_dualspeed with
max_speed isn't changing much and if you want to make that part of the
code better, why not doing The Right Thing(TM) ?

All of the speed negotiation between composite.c and f_*.c should happen
before even connecting to host (before attaching data pullups, enabling
IRQs, etc), that's exactly why me and Sebastian have decided (at that
time off list) to add udc_start()/udc_stop() methods. One of the reason
was that it would be a quite intrusive change to all UDC drivers, second
we wanted to give maintainers/authors of those UDC drivers some grace
period for the change, third  when all UDCs are converted, it allow us
to do the speed negotiation before connecting to host.

> >>diff --git a/drivers/usb/gadget/udc-core.c
> >>b/drivers/usb/gadget/udc-core.c
> >>index e1ecdbc..25058b4 100644
> >>--- a/drivers/usb/gadget/udc-core.c
> >>+++ b/drivers/usb/gadget/udc-core.c
> >>@@ -371,14 +371,28 @@ static ssize_t
> >>usb_udc_softconn_store(struct device *dev,
> >> }
> >> static DEVICE_ATTR(soft_connect, S_IWUSR, NULL,
> >>usb_udc_softconn_store);
> >>
> >>-static ssize_t usb_udc_speed_show(struct device *dev,
> >>+#define USB_UDC_SPEED_ATTR(name)					\
> >>+ssize_t usb_udc_##name##_show(struct device *dev,			\
> >>+		struct device_attribute *attr, char *buf)		\
> >>+{									\
> >>+	struct usb_udc *udc =3D container_of(dev, struct usb_udc, dev);	\
> >>+	return snprintf(buf, PAGE_SIZE, "%s\n",				\
> >>+			usb_device_speed_name(udc->gadget->name));	\
> >>+}									\
> >>+static DEVICE_ATTR(name, S_IRUSR, usb_udc_##name##_show, NULL)
> >>+
> >>+static USB_UDC_SPEED_ATTR(speed);
> >
> >how about "current_speed" ?
>=20
> Is there a big advantage?  That would change external interface and I don=
't
> see reason to do so.  Of course, udc class is quite recent so if you
> feel we can
> ignore this issue I can go forward with that change.

you already maximum_speed (below) and speed alone looses some extra
hint of what kind of information will be there. I think it's better to
change this to current_speed and make a symbolic link called 'speed'
which we can keep for the next 5 years and remove it in e.g. Linux v5.0

> >>+/* Provide "is_dualspeed" for backward compatibility. */
> >>+static ssize_t usb_udc_is_dualspeed_show(struct device *dev,
> >> 		struct device_attribute *attr, char *buf)
> >> {
> >>-	struct usb_udc		*udc =3D container_of(dev, struct usb_udc, dev);
> >>-	return snprintf(buf, PAGE_SIZE, "%s\n",
> >>-			usb_device_speed_name(udc->gadget->speed));
> >>+	struct usb_udc *udc =3D container_of(dev, struct usb_udc, dev);
> >>+	return snprintf(buf, PAGE_SIZE, "%d\n",
> >>+			gadget_is_dualspeed(udc->gadget));
> >> }
> >>-static DEVICE_ATTR(speed, S_IRUSR, usb_udc_speed_show, NULL);
> >>+static DEVICE_ATTR(is_dualspeed, S_IRUSR,
> >>usb_udc_is_dualspeed_show, NULL);
> >
> >maybe deprecate this one on feature-removal-schedule ??
>=20
> Sure.
>=20
> Also, if we decide to change =E2=80=9Cspeed=E2=80=9D to =E2=80=9Ccurrent_=
speed=E2=80=9D, we could just drop
> this without the announcement.

I rather have the announcement. See above that you can make a symbolic
link with the name 'speed' for the time being.

--=20
balbi

--crFW2+mWrWMXeHsA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOU7H5AAoJEAv8Txj19kN1N4MH/1vi5QiqWksLFKmCMvowQmmV
2lLI+KpuLJsSt4vmxBPQiipov0O28FskT3tod4xgAIXvMDVUQy0dwwBZHJff8EAV
gEuEP5fAs8CyCV/6CysUt8QdskGOYnft/cwv1ceH6KJSzcxuDGo+OJx7iC3Ic8L+
HEz2PnHU+ELYxBSGtGgqaSSJ5mxrKeGGwGJXWH42MPWMgrsqOd5RaC7RKchnzWut
6btwRdmyExwDh6Uc6yONPYNzLUjMu9Jq2hQ/J4pQFl+N1+lXtaMHXFwG2dqGJ+er
9KF1DIydZumKV8zL48+EGzeRQ0IQQUhkTRrtfosCXrOFz0aSAI9wlqJSkt7R0Ng=
=jTEn
-----END PGP SIGNATURE-----

--crFW2+mWrWMXeHsA--

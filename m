Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848Ab1K1Bbh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 20:31:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52932 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752499Ab1K1Bbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 20:31:36 -0500
Date: Mon, 28 Nov 2011 12:31:14 +1100
From: NeilBrown <neilb@suse.de>
To: Greg KH <gregkh@suse.de>
Cc: Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        myungjoo.ham@gmail.com, linux-kernel@vger.kernel.org,
        Mike Lockwood <lockwood@android.com>,
        Arve =?ISO-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kalle Komierowski <karl.komierowski@stericsson.com>,
        Johan PALSSON <johan.palsson@stericsson.com>,
        Daniel WILLERUD <daniel.willerud@stericsson.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [RFC PATCH 0/3] introduce: Multistate Switch Class
Message-ID: <20111128123114.2601bd7c@notabene.brown>
In-Reply-To: <20111127230836.GA29728@suse.de>
References: <CAJ0PZbQBXF1f7F27bkkT_ezFFtFi7kRVbF5WZXn+ZenZj2hT7w@mail.gmail.com>
	<201111251402.28016.arnd@arndb.de>
	<CACRpkdZSQcdK5ndSThQPRFAvp=sNMNDgBo5S6+H=t+0AYtJhOw@mail.gmail.com>
	<20111127230836.GA29728@suse.de>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/GSXO=qLG+z.fTzEYbfw2rCx"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/GSXO=qLG+z.fTzEYbfw2rCx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 28 Nov 2011 08:08:36 +0900 Greg KH <gregkh@suse.de> wrote:

> On Sun, Nov 27, 2011 at 11:43:39PM +0100, Linus Walleij wrote:
> > Hi MyungJoo, Arnd
> >=20
> > On Fri, Nov 25, 2011 at 3:02 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > > On Thursday 24 November 2011, MyungJoo Ham wrote:
> > >> For switch ports, which may have different types of cables
> > >> (USB, TA, HDMI, Analog A/V, and others), we often have seperated dev=
ice
> > >> drivers that detect the state changes at the port and device drivers=
 that
> > >> do something according to the state changes.
> > >>
> > >> For example, when MAX8997-MUIC detects a Charger cable insertion, an=
other
> > >> device driver (such as MAX8903 charger, MAX8997 charger, Charger Man=
ager,
> > >> or board file) needs to set charger current limit accordingly and wh=
en
> > >> MAX8997-MUIC detects a HDMI cable insertion, multimedia device drive=
rs
> > >> need to do some operations accordingly.
> > >>
> > >> This patchset supports the usage of notifier for passing such inform=
ation
> > >> between device drivers.
> > >>
> > >> Another issue is that at a single switch port, there might be multip=
le
> > >> and heterogeneous cables attached at the same time. Besides, the sta=
te
> > >> (Attached or Detached) of each cable may alter independently.
> > >>
> > >> In order to address such issues, Android kernel's "Switch" class see=
ms to
> > >> be a good basis and we have implemented "Multistate Switch Class" ba=
sed on
> > >> it. The "Switch" class code of Android kernel is GPL as well.
> > >
> > > How does this relate to the new "pinmux" subsystem that Linus Walleij
> > > maintains? Would it be useful to integrate your driver into pinmux
> > > instead of starting a new subsystem?
> >=20
> > Looks unrelated to pinmux but very useful.
> >=20
> > And the uevent scheme from Arve seems like it's doing the
> > right thing to me, but see below on relation to <linux/input.h>.
> >=20
> > The GPIO part has to be reviewed by Grant though.
> >=20
> > Our charger code also needs to
> > know when the USB cable is inserted, currently we have a simple
> > cross-call in a header file:
> > static void ab8500_charger_usb_state_changed(u8 bm_usb_state, u16 mA);
> >=20
> > So there is certainly a growing need of subsystems that
> > need to notify each other about things that are happening,
> > the need comes naturally from mobile ICs I think, and
> > I also think they all have one or another custom mechanism
> > in place already.
> >=20
> > But - and now we need Dmitry to check the concepts:
> >=20
> > Some use this stuff from <linux/input.h> to talk to userspace
> > though the input subsystem:
> >=20
> > /*
> >  * Switch events
> >  */
> >=20
> > #define SW_LID                  0x00  /* set =3D lid shut */
> > #define SW_TABLET_MODE          0x01  /* set =3D tablet mode */
> > #define SW_HEADPHONE_INSERT     0x02  /* set =3D inserted */
> > #define SW_RFKILL_ALL           0x03  /* rfkill master switch, type "an=
y"
> >                                          set =3D radio enabled */
> > #define SW_RADIO                SW_RFKILL_ALL   /* deprecated */
> > #define SW_MICROPHONE_INSERT    0x04  /* set =3D inserted */
> > #define SW_DOCK                 0x05  /* set =3D plugged into dock */
> > #define SW_LINEOUT_INSERT       0x06  /* set =3D inserted */
> > #define SW_JACK_PHYSICAL_INSERT 0x07  /* set =3D mechanical switch set =
*/
> > #define SW_VIDEOOUT_INSERT      0x08  /* set =3D inserted */
> > #define SW_CAMERA_LENS_COVER    0x09  /* set =3D lens covered */
> > #define SW_KEYPAD_SLIDE         0x0a  /* set =3D keypad slide out */
> > #define SW_FRONT_PROXIMITY      0x0b  /* set =3D front proximity sensor=
 active */
> > #define SW_ROTATE_LOCK          0x0c  /* set =3D rotate locked/disabled=
 */
> > #define SW_LINEIN_INSERT        0x0d  /* set =3D inserted */
> > #define SW_MAX                  0x0f
> > #define SW_CNT                  (SW_MAX+1)
> >=20
> > These are *also* switches. You could very well add USB
> > cable insertion to the list above.
> >=20
> > So for the userspace part it seems to me that we need to make
> > up our mind about this stuff: is it going to be through input or
> > uevent like in this patch? Or ?both??
>=20
> Input please, uevent is not for things like switches that are "common",
> but for things that are "uncommon" and don't happen often.

Hi Greg,

 I don't find that argument at all convincing.  "common" is not an objective
 measure that we can all see the same way, and I don't even think it is
 relevant.

 Consider the difference between plugging in a USB-headphone set and an
 analogue mini-phone headphone set.  To the user they are the same thing.
 They should be assumed to be as common as each other.  Yet plugging in the
 USB headphone set will create a new Audio device while and so generate a
 uevent, while plugging in the analogue headset (currently) won't and will
 just send an input event.

 So they are different, not because of expected usage but simply because of
 internal implementation details.

 I think you could make a case that plugging in an analogue headset is in
 fact adding a new audio device (or enabling one that was present but
 inactive) and so deserves a uevent.
 Similarly plugging in a USB-charge makes a significant capability-change to
 the usb-gadget device so an 'change' uevent seems appropriate.

 If a switch enables or disables a device, then the state-change of the
 switch itself doesn't deserve a uevent, but the device that it
 enables/disables/changes-capability-of does.

 How the signal gets from the switch to the device when they are separate
 things is less clear, and I think it is the main focus of the proposed pat=
ch.

 Input might be a suitable vehicle for switch signalling, but if it was I
 would argue against trying to list every possible switch with its own swit=
ch
 code.  Rather there should be a generic 'SW_SWITCH' and different input
 devices each had a single switch but each did different things.  So an
 action would not be guided by the name of the switch event, but by the name
 of the device that the switch event came from.

 My own thought is that this deserves a new device class which allows easy
 hook-up of in-kernel signalling using notifications and which can be
 exported as input devices in much the same way the 'gpio' devices can be
 exported via gpio_keys.  The switch could also optionally be exported thro=
ugh
 sysfs much like gpio can be exported through sysfs.

 So I think I agree with your conclusion, but not with your argument :-)

NeilBrown

--Sig_/GSXO=qLG+z.fTzEYbfw2rCx
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTtLkYjnsnt1WYoG5AQK5vhAAml3AjFfdJPI+xKRuFJDOW3irE0mirALD
O8jxeZ7H1zvlj1zex8r9Hlmu0vtJwwh5xsHW85uX0fwLqIrwWZiE8JXe7Kw5ZbzB
Sy/kphzbmgQFuokFXVWpx1crC18wIwkHdfTo9BL2UmmgCjpX+jquZdb7dpGLpq9v
jiC+YbobZBvjDsBcORQhZufvCt83+msgmpD2AiF2LBH5LgnUvVT4DWGewlrgkD56
GEF9OkiarJ1WIbztHgv/Kmei7yD/aAKjBctt4M+Onmb37ZmQOJ607GgSIgakLdZv
Srp61pgqjCVexGwrRxfXmhTCLkXuXmM0ynFAic2A+jUmpeC2M5fnwvx9l5MMLuNN
D2MvdNzS992sVIJPWGtg5xl4JZ5wRzRddCbiOrxD5c5L438dkrpnfFLsctqQC9aO
nk4iDpNdfPAN1rMEKZNyTGWRPJJlUvoJ97Urg3cfCh7eK4Jm4BKaOI3RPP4TeOdn
pRCR1iCM1DHY679ixckmTk1TRpt5/ZoI/lko0CylIsT26iiwdhoPeMoHP2cfePLF
yWhG0H1E7bVSdlrKT1G/2LFgAs3RMB/PvpzXntAaL71ft2K8eh5PxoGvOC8eqN8P
J6L1Bwx+fgGu3Cr+VvEvTpT+2la58uFZ7UlaFmbedifqi1+Qis3bWlb92cPo6pOh
fo9XWfJVR6g=
=IRbZ
-----END PGP SIGNATURE-----

--Sig_/GSXO=qLG+z.fTzEYbfw2rCx--

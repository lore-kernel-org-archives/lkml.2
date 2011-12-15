Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759483Ab1LOUVL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 15:21:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55598 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523Ab1LOUVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 15:21:10 -0500
Date: Fri, 16 Dec 2011 07:20:51 +1100
From: NeilBrown <neilb@suse.de>
To: myungjoo.ham@gmail.com
Cc: myungjoo.ham@samsung.com, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH v2 0/3] introduce External Connector Class (extcon)
Message-ID: <20111216072051.6014557b@notabene.brown>
In-Reply-To: <CAJ0PZbQHjtit8bUyJx996PD5eBzd3SHapHQ0qjhMfTUmn0Q+0Q@mail.gmail.com>
References: <1323858508-27198-1-git-send-email-myungjoo.ham@samsung.com>
	<20111215133229.20e7f0f2@notabene.brown>
	<CAJ0PZbQHjtit8bUyJx996PD5eBzd3SHapHQ0qjhMfTUmn0Q+0Q@mail.gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/fegMxbN/Nc3hOr5teHPh4_j"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/fegMxbN/Nc3hOr5teHPh4_j
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 15 Dec 2011 15:36:15 +0900 MyungJoo Ham <myungjoo.ham@samsung.com>
wrote:

> On Thu, Dec 15, 2011 at 11:32 AM, NeilBrown <neilb@suse.de> wrote:
> > On Wed, 14 Dec 2011 19:28:25 +0900 MyungJoo Ham <myungjoo.ham@samsung.c=
om>
> > wrote:
> >
> >> Note that previously, the patchset has been submitted as
> >> "Multistate Switch Class".
> >>
> >> For external connectors, which may have different types of cables atta=
ched
> >> (USB, TA, HDMI, Analog A/V, and others), we often have seperated device
> >> drivers that detect the state changes at the port and device drivers t=
hat
> >> do something according to the state changes.
> >>
> >> For example, when MAX8997-MUIC detects a Charger cable insertion, anot=
her
> >> device driver (such as MAX8903 charger, MAX8997 charger, Charger Manag=
er,
> >> or board file) needs to set charger current limit accordingly and when
> >> MAX8997-MUIC detects a HDMI cable insertion, multimedia device drivers
> >> need to do some operations accordingly.
> >
> > Hi,
> > =C2=A0a few comments...
> >
> > 1/ I still don't understand why this needs to a single device which can
> > =C2=A0 report multiple cables, rather than simply having multiple devic=
es each
> > =C2=A0 of which reports a single cable at a time.
> >
> > =C2=A0 i.e. A physical 32 bit port might be represented as several 'ext=
con'
> > =C2=A0 devices each of which reports a different function: USB, HDMI, C=
harger,
> > =C2=A0 etc.
> >
>=20
> Implementing what you've suggested would require another device driver
> or framework to relay notifications from the physical 32 bit port to
> several 'extcon' devices unless the physical 32 bit port has 32 IRQ
> lines or addresses. If it is implemented in a device driver, we will
> reimplement the same feature in every multi-port device drivers. If we
> make another framework, we are simply seperating extcon framework into
> two seperated frameworks.
>=20
> It is because the "report" comes from a single device ("notifier":
> implementing extcon device) and multiple cables and devices using the
> cables need to listen to the "report" ("notifiee": registering
> notifier block to the extcon device). With the FSA9480 USB Switch,
> MAX8997 MUIC, or MAX77693 MUIC representing an external connector with
> multiple cables possible, it is impossible to create one device to
> handle events from one cable. We simply have only one GPIO for the
> interrupt and one I2C slave address for them. Even when we implement
> one device for one cable, we need something working as a "network
> router" between the connector(WAN port) and cables (LAN ports), which
> is "extcon" in this case.
>=20
> If we implement an extcon-like device to handle each possible cable
> state and notify devices according to every cable state, then, it
> would like implementing extcon class code at each extcon-like device
> driver. We would need to implement this method (registering cable
> interest) in every extcon-like device (MUIC / USB Switch / ...)

I don't think this is nearly as complicated as you seem to be presenting it.

It is perfectly normal for a device to register multiple sub-devices.
Possibly of the same class, possibly different.  And then to manage them al=
l.

So in your case you would have an i2c device which is the whole port and it
would register a collection of extcon devices and send notifications through
them as needed.

Some other port might be implemented by an spi device and it would register=
 a
different set of extcon devices.  The only code overlap between the two wou=
ld
be a simple 'for' loop.

Consider for example a typical 'led' driver, say leds-adp5520.c
It manages multiple LEDs.  But that doesn't mean we need a multi-led class.
We just have a 'led' class and adp5520_led_probe has a for loop to register
all the different led devices that it needs.
It holds these in an array and can do something to them whenever it needs.
(It only needs to do something to everything when shutting down, so it isn't
a perfect example but it will have to do).

So your one device driver would register a set of extcon devices, keep them
in an array and whenever something changes it would use a for loop to walk
the array and send a notification on each device.

Client ("notifiee") devices would register just with the particular
function(s) they are interested in.


>=20
> > =C2=A0 The fact that the devices are related can be made clear by the c=
hoice of
> > =C2=A0 port names.
> >
> > =C2=A0 If these is a good reason, it needs to be included in the patch
> > =C2=A0 somewhere, possibly in a file in Documentation, so that when som=
eone comes
> > =C2=A0 along to use this class in a year or two they can understand all=
 the
> > =C2=A0 consequences of any decision they make (and so that I stop askin=
g now:-)
>=20
> With the current patchset,
>=20
> extcon_register_interest(null_obj, "max8997-muic.0", "HDMI", nb_callback);
>=20
> registers the notifier-block callback for a specific cable "HDMI" of
> max8997-muic.0
>=20
> Do you mean to include a usage description like above in
> Documentation? If so, I'll make one under linux/Documentation/extcon/
> later.

I'm not exactly sure what I meant... Just that the justification for your
design choices weren't obvious, so I felt they needed to be documented
somehow.  I'm still hoping to change your design choices :-)


>=20
> >
> > 2/ When you have multiple cable options, the 'state' sysfs file looks
> > =C2=A0 like e.g.
> > =C2=A0 =C2=A0 =C2=A0USB 0, HDMI 1, DVI 1
> >
> > =C2=A0 Having list values in sysfs files is generally frowned upon but =
sometimes
> > =C2=A0 is necessary. =C2=A0However I'm not sure this is a good format t=
o use.
> > =C2=A0 There aren't a whole lot of examples to follow (because it is so=
 frowned
> > =C2=A0 upon) but one option is
> >
> > =C2=A0 =C2=A0 =C2=A0USB =C2=A0[HDMI] [DVI]
> >
> > =C2=A0 where the selected option(s) are in square brackets.
> > =C2=A0 Another might be
> >
> > =C2=A0 =C2=A0USB=3D0
> > =C2=A0 =C2=A0HDMI=3D1
> > =C2=A0 =C2=A0DVI=3D1
> >
> > =C2=A0 with newlines - just like in the 'uevent' file.
>=20
> Yes. This looks much better. Thanks.
>=20
> >
> > =C2=A0 Also I think that some pairs of cables are mutually exclusive wh=
ile others
> > =C2=A0 aren't. =C2=A0This fact isn't made apparent in the 'state' file.=
 =C2=A0Maybe it
> > =C2=A0 should be.
> >
>=20
> I think as long as the notifier (extcon class device) is the only one
> who is supposed to have the right to write and userspace cannot write
> state value, I don't think this is required. Such relation should be
> dealt in the notifier device and all the others who are "readers" do
> not need to know such detail.

It is always best to provide complete information - you never know when it
might be handy.

Suppose I wanted to write a little widget that displays an image on my
display of what sort of cable was attached.  Knowing that some were mutually
exclusive would allow for a more meaningful display.

>=20
> > =C2=A0 Whatever format is used should be documented in the
> > =C2=A0 Documentation/ABI file.
>=20
> Yes, I will add that one.
>=20
> >
> > =C2=A0 Of course this problem would go away if you didn't allow multiple
> > =C2=A0 concurrent cables per port.
> >
> > 3/ The use of extcon_get_extcon_dev() requires that the port device be
> > =C2=A0 registered before the device that wants to be notified by it. =
=C2=A0Ensuring
> > =C2=A0 correct ordering of device discovery is (I believe) not always e=
asy -
> > =C2=A0 particularly with module loading.
> >
> > =C2=A0 Would it make sense to instead have one device register as a
> > =C2=A0 switch-provider and the other device register as a switch-listen=
er and as
> > =C2=A0 soon as they both exist they get connected: a bit like how 'devi=
ces' and
> > =C2=A0 'drivers' can be registered in any order.
> > =C2=A0 Maybe the same device/driver infrastructure could be reused (an =
extcon
> > =C2=A0 bus maybe?) but I'm not really familiar enough with it to say (G=
reg??).
> >
> > =C2=A0 What I do know is that I have repeatedly tripped over the fact t=
hat you
> > =C2=A0 cannot use a GPIO line until the gpiochip has been registered and
> > =C2=A0 sometimes the device that needs it is registered before the devi=
ce which
> > =C2=A0 provides it. =C2=A0I wouldn't like to see that happening here to=
o.
> >
> > =C2=A0 Are there other examples of inter-device dependencies that can b=
e used as
> > =C2=A0 a model?
>=20
> Yes, this has been sometimes a problem for me as well.
>=20
> What if let "extcon_register_interest" returns <0 for errors, "1" if
> successfully registered, and "0" if the extcon name does not exists
> (probably will be "probed" later?) and register the requested interest
> later when the corresponding extcon is probed?
>=20
> Then, I'll need to add "bool effective" in the struct
> extcon_specific_cable_nb so that the notifee (caller of
> extcon_register_interest()) my know if the interest is effectively
> registered or still pending.
>=20
> Also, I may need to add an option to extcon_register_interest stating
> whether it is ok to be "pending" if extcon_name does not exist or is
> should return error if extcon_name does not exist.
>=20
> Anyway, it seems that extcon_register_interest is the only one that
> needs to care this inter-device dependencies because
> extcon_register/unregister_interest are the only ones supposed to be
> called by notifee (depending devices).

I think that extcon_register_interest should never fail (except maybe with
-ENOMEM).

The "interest" can be registered even if the port doesn't exist yet.
Every time an extcon device is registered, the extcon module looks through
the list of pending registrations and completes any connection that matches.

When the connection is completed I suspect it would be appropriate to send a
notification with the initial state - that is the only way the client would
find out that the registration was complete.

It might be good to eventually make a generic library for this so that other
resource providers can support async registration.

NeilBrown


--Sig_/fegMxbN/Nc3hOr5teHPh4_j
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTupWoznsnt1WYoG5AQIa+Q/8CBe/K1opCmNBEBN9sfyTev/uaZ235xJm
W5XHC0fNaGsdvWeIk6OSrTxcgyYybc8Fp9LS36TvfG7FmirONQahRtfBQT7GPwwn
AvgDqLdId7xLxi2RK7n58rV5LdydR9thvTR93rVLqovsRqR/ZXxV4hoxb5t72MvN
xIfab64ObvV+MlDuseje1S+oMMdEez40LkSVCw3TXvCTtp8oQcIE8pdLum+8T69K
iA/xRTt9YuqKrw7zjlaZwQdtkEKoOkfpESVRs8oOZZum+duasqGFwwLg/Mz7G65h
5A0tTMijTHQAjAh+gCpDIegQLlS9z6zuaTzsgz1a6ZHNiyiF0m4/SyYtxBd29UzS
N71YuyXiBI6qfyWxFaK/Ez3VScYQisiIEfNW8npuV4d/oz06wnJNKSwzTgJFhMDX
U5SPHqzwjmIt48g4h/OfcibhOCBCwyagr9ff0oAnEvMAjJI8p/jL+T8isOOlkJt7
NNWiftrSKBFCjoBFg1ILpE87XEeMLprUqLDCKlFN0lBRHLvoq5Nls7U0jAqQ5fz8
elzXfb/fsUhDo8tNkEvxeYAISmmBtgtotQRgGPhTAwjhCbyy0Z8XwftwBi/UE/5A
4LSrOKv3P/k5KL8zEqucg5gj3x8qHHVBmcnMwOhkIfSWZILo8OdiJ2L0pG2hYpep
oINW5L/rQZE=
=0Hjb
-----END PGP SIGNATURE-----

--Sig_/fegMxbN/Nc3hOr5teHPh4_j--

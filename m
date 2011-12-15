Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205Ab1LOCcu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 21:32:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51593 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758618Ab1LOCcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 21:32:46 -0500
Date: Thu, 15 Dec 2011 13:32:29 +1100
From: NeilBrown <neilb@suse.de>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Arnd Bergmann <arnd@arndb.de>, MyungJoo Ham <myungjoo.ham@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH v2 0/3] introduce External Connector Class (extcon)
Message-ID: <20111215133229.20e7f0f2@notabene.brown>
In-Reply-To: <1323858508-27198-1-git-send-email-myungjoo.ham@samsung.com>
References: <1323858508-27198-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/3VA8Rp6gLdnJK=/+Ge9wJjt"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/3VA8Rp6gLdnJK=/+Ge9wJjt
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 14 Dec 2011 19:28:25 +0900 MyungJoo Ham <myungjoo.ham@samsung.com>
wrote:

> Note that previously, the patchset has been submitted as
> "Multistate Switch Class".
>=20
> For external connectors, which may have different types of cables attached
> (USB, TA, HDMI, Analog A/V, and others), we often have seperated device
> drivers that detect the state changes at the port and device drivers that
> do something according to the state changes.
>=20
> For example, when MAX8997-MUIC detects a Charger cable insertion, another
> device driver (such as MAX8903 charger, MAX8997 charger, Charger Manager,
> or board file) needs to set charger current limit accordingly and when
> MAX8997-MUIC detects a HDMI cable insertion, multimedia device drivers
> need to do some operations accordingly.

Hi,
 a few comments...

1/ I still don't understand why this needs to a single device which can
   report multiple cables, rather than simply having multiple devices each
   of which reports a single cable at a time.

   i.e. A physical 32 bit port might be represented as several 'extcon'
   devices each of which reports a different function: USB, HDMI, Charger,
   etc.

   The fact that the devices are related can be made clear by the choice of
   port names.
  =20
   If these is a good reason, it needs to be included in the patch
   somewhere, possibly in a file in Documentation, so that when someone com=
es
   along to use this class in a year or two they can understand all the
   consequences of any decision they make (and so that I stop asking now:-)

2/ When you have multiple cable options, the 'state' sysfs file looks
   like e.g.
      USB 0, HDMI 1, DVI 1

   Having list values in sysfs files is generally frowned upon but sometimes
   is necessary.  However I'm not sure this is a good format to use.
   There aren't a whole lot of examples to follow (because it is so frowned
   upon) but one option is

      USB  [HDMI] [DVI]

   where the selected option(s) are in square brackets.
   Another might be

    USB=3D0
    HDMI=3D1
    DVI=3D1

   with newlines - just like in the 'uevent' file.

   Also I think that some pairs of cables are mutually exclusive while othe=
rs
   aren't.  This fact isn't made apparent in the 'state' file.  Maybe it
   should be.

   Whatever format is used should be documented in the
   Documentation/ABI file.

   Of course this problem would go away if you didn't allow multiple
   concurrent cables per port.

3/ The use of extcon_get_extcon_dev() requires that the port device be
   registered before the device that wants to be notified by it.  Ensuring
   correct ordering of device discovery is (I believe) not always easy -
   particularly with module loading.

   Would it make sense to instead have one device register as a
   switch-provider and the other device register as a switch-listener and as
   soon as they both exist they get connected: a bit like how 'devices' and
   'drivers' can be registered in any order.
   Maybe the same device/driver infrastructure could be reused (an extcon
   bus maybe?) but I'm not really familiar enough with it to say (Greg??).

   What I do know is that I have repeatedly tripped over the fact that you
   cannot use a GPIO line until the gpiochip has been registered and
   sometimes the device that needs it is registered before the device which
   provides it.  I wouldn't like to see that happening here too.

   Are there other examples of inter-device dependencies that can be used as
   a model?



>=20
> This patchset supports the usage of notifier for passing such information
> between device drivers.
>=20
> Another issue is that at a single switch port, there might be multiple
> and heterogeneous cables attached at the same time. Besides the state
> (Attached or Detached) of each cable may alter independently.
>=20
> In order to address such issues, Android kernel's "Switch" class seems to
> be a good basis and we have implemented "Multistate Switch Class" based on
> it. The "Switch" class code of Android kernel is GPL as well.

Do you need to update this text to remove "Multistate Switch Class" ??

Thanks,
NeilBrown


--Sig_/3VA8Rp6gLdnJK=/+Ge9wJjt
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTulcPTnsnt1WYoG5AQLGFQ//fmD1OnWt2mF1SPvcyPPf6DbStyH7iiEn
Th+8wyEN2XQyji4wr+LfEzxG+WJ7/JEOgzziz+E2/Uv3dBfwHeYfRMhHqu0WTNzq
alaX4I9tbJDlbnawx4ejobkFGfTycKSsYAMs05LvDl9K1mUqO9CNdwVxROqqKzVS
Ih/ZcllHOzkPTDoBZWYpFs/Uv3BJXgHaag+7EmMD5cSrOPIg3C4VPllGuCNUiPXY
15PyfiP/QBHo35sZPUIli+LgJ0BEyrjDUBCno9vzzKMz1nKF8ykZsHdm8dJwQUyr
Uy8h4m4PxVdx9HLJX2JjzCXy/71aSg3z7552z99eBh+qr63y1fUclXJcUjBMe2vs
wel3LKbcIuL5iGucURdf/afVGosjM8zY8vl7v4TAf1GPOlupQcyd0VKFT1dNWNe3
2MSnXa5pMH2sWtXXTC37KNsAPhwsj6Wk1phz5zgXt7KHr0JAhUPXagqRn1+tqHC3
LOuZYFt8v5UpzmXqZxWN9Z1w8Nhbq4LdAuAcojcFLzd9wf7D6Ty4G5GxcKevR/r4
tOjNlLgxX1+e0YEBRokjMf+U+8QUPMlO7zfnMGvKNS4XweSR9pkSq5aqMX3cjvLo
N3RvRaHZsdMnEGKICUsL2kystXNhE8LuYhtbmcObYbHiIhvkqiaKKpuhd6EAn1jg
DpKhjsytcsg=
=Toyo
-----END PGP SIGNATURE-----

--Sig_/3VA8Rp6gLdnJK=/+Ge9wJjt--

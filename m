Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab2ACBCV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 20:02:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43879 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753461Ab2ACBCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 20:02:19 -0500
Date: Tue, 3 Jan 2012 12:02:06 +1100
From: NeilBrown <neilb@suse.de>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Grazvydas Ignotas <notasas@gmail.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Anton Vorontsov <cbouatmailru@gmail.com>
Subject: Re: [PATCH 5/5] bq27x00 - don't report power-supply change so
 often.
Message-ID: <20120103120206.7f4ead54@notabene.brown>
In-Reply-To: <4EFEF1AF.9060001@metafoo.de>
References: <20111230004947.11559.81184.stgit@notabene.brown>
 <20111230005849.11559.78948.stgit@notabene.brown>
 <CANOLnOM7QbF5aMb1iW0W2t6B1q1J+cROMU8SpD185DyC33w4kA@mail.gmail.com>
 <4EFEF1AF.9060001@metafoo.de>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Lt8_Zioh8vogmhogkBx9BJt"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Lt8_Zioh8vogmhogkBx9BJt
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 31 Dec 2011 12:27:43 +0100 Lars-Peter Clausen <lars@metafoo.de> wro=
te:

> On 12/30/2011 12:13 PM, Grazvydas Ignotas wrote:
> > CCing Lars who added this. I vaguely recall something about generating
> > events to make some battery monitors update but I forget the details
> > now, maybe it was about something else. Also CCing Anton (the
> > maintainer).
> >=20
> > On Fri, Dec 30, 2011 at 2:58 AM, NeilBrown <neilb@suse.de> wrote:
> >> A power_supply_changed should only be reported on significant changes
> >> such as transition between charging and not.  Incremental changes
> >> such as charge increasing should not be reported - that can easily
> >> be polled for.
>=20
> Well, you can also poll for those "significant" changes, too. The point of
> adding this was to have a centralized point where polling takes place ins=
tead
> of letting each battery monitor do this on its own. Though if, as you wro=
te in
> the cover letter, the some properties change every time the values are re=
ad it
> might makes sense to exclude these from the comparison. On the other hand=
 one
> event every 6 minutes doesn't really sound harmful and I would suspect th=
at
> battery monitors will use a similar interval when manually polling the de=
vice.

Hi,

 That is a very good point.  user-space could poll for all of the changes a=
nd
 polling the kernel provides no real benefit.

 I don't really see the problem with each battery monitor doing their own
 polling.  At least that way they would have control over when polling
 happens.

 Polling every 6 minutes does not really seem like a lot - except that
 polling at all in the kernel should be avoided.  If the system is idle and
 has managed to get into a lower power state, waking up just to check on the
 battery would be the wrong thing to do.

 A battery monitor could notice that no-one cared (e.g. A X11 client not
 getting any 'expose' events) and could stop polling.  The kernel cannot do
 that.

 However the part of the current code that really bothered me was that a
 'change' event is generated every time anyone polls the battery status - b=
ut
 at most every 5 seconds.  These extra change events really aren't wanted.

 I think we should always be cautious of adding change events.  They are
 not there just to report when any detail changed, else a 'keyboard' device
 would report a 'change' event on every keystroke.
 The main purpose of uevents are to report 'add' and 'remove' of devices.
 'change' is for situations where a device changes in a way that is very
 similar to an 'add' or a 'remove' but isn't implemented as a new device.
 A simple example is inserting a CD into a CD drive.  Before the device
 couldn't do anything useful, now it can.  It is a new medium, which is
 almost like a new device but just not implemented that way.  So it deserve=
s a
 change event.
 Or when a power supply gets plugged in.  We really have a new thing here -
 we have added power.  But as the power isn't a device we cannot have an
 'add' uevent, so we have a 'change' uevent on the power supply.

 So I would be in favour of removing the in-kernel polling altogether.
 That puts complete control where it belongs: is the app that is monitoring
 the battery.

 Thoughts??

Thanks,
NeilBrown


>=20
> - Lars
>=20
> >>
> >> Signed-off-by: NeilBrown <neilb@suse.de>
> >> ---
> >>
> >>  drivers/power/bq27x00_battery.c |   15 ++++++++++++---
> >>  1 files changed, 12 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_b=
attery.c
> >> index bb16f5b..7993a17 100644
> >> --- a/drivers/power/bq27x00_battery.c
> >> +++ b/drivers/power/bq27x00_battery.c
> >> @@ -57,11 +57,15 @@
> >>  #define BQ27000_FLAG_CHGS              BIT(7)
> >>  #define BQ27000_FLAG_FC                        BIT(5)
> >>
> >> +#define BQ27000_FLAGS_IMPORTANT                (BQ27000_FLAG_FC|BQ270=
00_FLAG_CHGS|BIT(31))
> >> +
> >>  #define BQ27500_REG_SOC                        0x2C
> >>  #define BQ27500_REG_DCAP               0x3C /* Design capacity */
> >>  #define BQ27500_FLAG_DSC               BIT(0)
> >>  #define BQ27500_FLAG_FC                        BIT(9)
> >>
> >> +#define BQ27500_FLAGS_IMPORTANT                (BQ27500_FLAG_FC|BQ275=
00_FLAG_DSC|BIT(31))
> >> +
> >>  #define BQ27000_RS                     20 /* Resistor sense */
> >>
> >>  struct bq27x00_device_info;
> >> @@ -259,6 +263,7 @@ static void bq27x00_update(struct bq27x00_device_i=
nfo *di)
> >>  {
> >>        struct bq27x00_reg_cache cache =3D {0, };
> >>        bool is_bq27500 =3D di->chip =3D=3D BQ27500;
> >> +       int flags_changed;
> >>
> >>        cache.flags =3D bq27x00_read(di, BQ27x00_REG_FLAGS, is_bq27500);
> >>        if (cache.flags >=3D 0) {
> >> @@ -280,10 +285,14 @@ static void bq27x00_update(struct bq27x00_device=
_info *di)
> >>
> >>        /* Ignore current_now which is a snapshot of the current batter=
y state
> >>         * and is likely to be different even between two consecutive r=
eads */
> >> -       if (memcmp(&di->cache, &cache, sizeof(cache) - sizeof(int)) !=
=3D 0) {
> >> -               di->cache =3D cache;
> >> +       flags_changed =3D di->cache.flags ^ cache.flags;
> >> +       di->cache =3D cache;
> >> +       if (is_bq27500)
> >> +               flags_changed &=3D BQ27500_FLAGS_IMPORTANT;
> >> +       else
> >> +               flags_changed &=3D BQ27000_FLAGS_IMPORTANT;
> >> +       if (flags_changed)
> >>                power_supply_changed(&di->bat);
> >> -       }
> >>
> >>        di->last_update =3D jiffies;
> >>  }


--Sig_/Lt8_Zioh8vogmhogkBx9BJt
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTwJTjjnsnt1WYoG5AQKhaw//WoHHOWc9SSsTKsFKhmH8PnRy6c44T7QW
fwIPAGLfcEUKvP6gAuyCt4ImcgPBlhQ4F1sjDpm8PGfcN4QDsWbfNOEbpWtVoKR7
IzdZFExARJGWXCOv9kBmJ8VbLHCk5UKh8HlFYtqQ+iMhU4XeLkTe8Pvnpn0P8H9o
zibjvhYT4JYWmTUjQH2hEAQ0YmWT5cd8u1O4AbgJm+ROa4ziCGXgJm+wmRkqAaYN
hGgm/WlVx0akdN9bgc1lLQJlBEfBlAqWdXpZuIIhdCSNzoLWFu24jTQBaSIPfdgU
EmGM4OMPk6kQE55OEtwD522ZZi8TJxXqlKH+XGSrbQ9aQVBjruju1YyVHg33GOh5
1ez+0S7Tq/xeNC1VumNuk9pQnY6K6rFzFcshxx1I7VQ+jXsRHAkScVYR4RgSUY9z
TByCz8OxkYwrH8ThtOaLIH+XaRYujL0+yXOPoHKVyAmdHgd1FPd3oaKtAzVI+gK3
jgcjFwTH+jMqqk7ipSVCeJ0pcSuBtiAGbbMISuysO8G9KWZyJ+4JUxoXZdgI/Wim
0M1P672dxGV0snvOnJFD4mdpfGNkX7p4+hoRSgPtoRLz1Bcv+XRraj6EeO6FHMW7
KwpyIrIAOe5mGp9MP+KVesVC0HbYR71uTNv9grmi6A5HllU9/pP7+DRJ7+cpUnxh
2kiAGmrOEgI=
=CHmO
-----END PGP SIGNATURE-----

--Sig_/Lt8_Zioh8vogmhogkBx9BJt--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab2BELfa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 06:35:30 -0500
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:41390 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754193Ab2BELf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 06:35:28 -0500
Date: Sun, 5 Feb 2012 13:35:22 +0200
From: Felipe Balbi <balbi@ti.com>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Cc: balbi@ti.com, "Varadarajan, Charulatha" <charu@ti.com>,
        Kevin Hilman <khilman@ti.com>, "Cousson, Benoit" <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Tarun Kanti DebBarma <tarun.kanti@ti.com>, linux-omap@vger.kernel.org,
        tony@atomide.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v9 01/25] gpio/omap: remove dependency on gpio_bank_count
Message-ID: <20120205113521.GA13533@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <4F2AF68D.1000505@ti.com>
 <20120202214907.GA22888@legolas.emea.dhcp.ti.com>
 <20120202215350.GB22888@legolas.emea.dhcp.ti.com>
 <4F2B078B.1040709@ti.com>
 <20120202220744.GA23092@legolas.emea.dhcp.ti.com>
 <87liojajs4.fsf@ti.com>
 <20120204160802.GA10818@legolas.emea.dhcp.ti.com>
 <CA+HSevqvHAgA+PPLm8BH5vfWkc8yY8W+fRpqjT2urq2EWtSYiA@mail.gmail.com>
 <20120205090805.GA13300@legolas.emea.dhcp.ti.com>
 <CAMQu2gyNhEJ3vr7_o_xYAQOYKaRofJViobKtfH2HoxwgU7nUpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
In-Reply-To: <CAMQu2gyNhEJ3vr7_o_xYAQOYKaRofJViobKtfH2HoxwgU7nUpw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Feb 05, 2012 at 02:46:19PM +0530, Shilimkar, Santosh wrote:
> >> bank->mod_usage check is used to take care of doing pm_runtime_get*/pu=
t* only
> >> if all the GPIOs in a particular bank are enabled or disabled respecti=
vely.
> >
> > and why should you care about that ? The first get will enable the
> > resources you need, the second get will just increase a counter and so
> > on. So if you have 32 gets, you will disable the module when you have 32
> > puts.
> >
> Am not sure if it is clear to you that the GPIO resources like clock,
> debounce clk are per bank wise and not per GPIO line. So doing 32

this is just one more reason to have usage counters.

> get/put per bank is stupid. runtime pm is for managing pm

what's stupid is trying to use the pm usage counters as a binary flag,
see below.

> resources and if the pm resource is per bank, it has to be
> handled per bank.

hehe, what are you talking about Santosh ? That's the whole point of
reference counting. If there are 32 users for 1 resource, you want to
make sure that you only free the resources (clocks, or whatever resource
you want) after all 32 users are done with it.

Trying to use the pm usage counter as a binary flag, that's the stupid
part of the OMAP GPIO driver.

Instead of adding checks such as:

if (module_isnt_used())
	enable_clocks();

on get and:

if (module_isnt_needed_anymore())
	disable_clcoks()

on put is the most useless piece of code on that driver. Because such
checks are already available on PM core through usage counters. The way
that part of the code works is as follow:

get() {
	if (pm_counter_is_zero(dev)) {
		atomic_inc();

		rpm_resume();
	}
}

put() {
	atomic_dec();

	if (pm_counter_is_zero(dev)) {
		rpm_suspend();
	}
}

Do you not see that you're duplicating functionality by trying to use
the pm counter a binary flag ?

> >> With the above change, pm_runtime_put*/get* would be called for every
> >> gpio_request()
> >> /_free() (that is, for upto 32 pins in OMAP3/4) in a bank irrespective
> >> of whether other
> >
> > so ?
> It's useless.

no, it's not.

> >> GPIO pins are enabled or disabled in the same bank. Hence it is
> >> required to have a
> >> check based on mod_usage.
> >
> > unnecessary.
> >
> I don't think so.

then show that to me with code. Looking at the usage counters on pm
runtime, you're duplicating functionality with it and trying to use it
as a binary flag.

Preventing multiple gets/puts breaks the whole idea of _having_ usage
counters to start with.

--=20
balbi

--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPLml5AAoJEIaOsuA1yqREFrcP/iosgZQlpS81y05dT02nX4Ej
HklExfqez6c7RWmNr6ys3oxyUbc9ZCG3WoWlBQXlLmO7eQ475W73FjmnJjsLJjIt
9b3Goz6fotOzq8GPmfz4XwBHbWqdEn5blHt3G7KbxGx8Gx6PFfG6bLWugDzHEXRC
px2t7/RABvJQUDNkQxQaTaMaAkCC86pmKOaWgmnQR2VVIeOn42iDAp50ODgSVLgW
mZkypxAIBUBwRuX7xAtn5l6+x/GschBS5YFtU4f2DiBUu3WtXB33jhic/D84F2Q9
pWCtzGBZHiKzQsqRyqpe9KYgrlOn+StfLzLCLSIkYOuHZlvLCOGh/87WMNkzrLkb
T1UTkqYxedegeIsQny2aVaKkG3NeTZ7Oc2g35bsA31rSMcMAC24GvkjlIlJCa5+6
nLjEvn7NTUN+ysxsN2U3tAL/eQpg7fJHlxbYB4ZQOEmHprrQJICsXPdh+agJ8B6X
i8t8hnF4//p1HTtvTGng9dfv5torp4WfPlKY0cMUKv70S7K3NYjVvtHb1k21s2KH
0DjTZ+jdkUMLtrTRVfICa7YS307D8vsWotLVCie4naTQyaxq7z9ZV7C7YCBjuAPO
XRMbELnhbdf/gNPb/wKPYob3Bymfhv/sgNwoeBqTstNUkE6WCQUCv4US3BsT5gbv
DesQJjrLuurTb4fyuRrV
=9hKt
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--

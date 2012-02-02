Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933433Ab2BBWH4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 17:07:56 -0500
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:60217 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755966Ab2BBWHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 17:07:52 -0500
Date: Fri, 3 Feb 2012 00:07:45 +0200
From: Felipe Balbi <balbi@ti.com>
To: "Cousson, Benoit" <b-cousson@ti.com>
Cc: balbi@ti.com, khilman@ti.com, Grant Likely <grant.likely@secretlab.ca>,
        Tarun Kanti DebBarma <tarun.kanti@ti.com>, linux-omap@vger.kernel.org,
        tony@atomide.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Charulatha V <charu@ti.com>
Subject: Re: [PATCH v9 01/25] gpio/omap: remove dependency on gpio_bank_count
Message-ID: <20120202220744.GA23092@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
 <1328203851-20435-2-git-send-email-tarun.kanti@ti.com>
 <20120202184106.GC29215@legolas.emea.dhcp.ti.com>
 <20120202191630.GT15343@ponder.secretlab.ca>
 <20120202194545.GA29351@legolas.emea.dhcp.ti.com>
 <4F2AF68D.1000505@ti.com>
 <20120202214907.GA22888@legolas.emea.dhcp.ti.com>
 <20120202215350.GB22888@legolas.emea.dhcp.ti.com>
 <4F2B078B.1040709@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline
In-Reply-To: <4F2B078B.1040709@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Feb 02, 2012 at 11:00:43PM +0100, Cousson, Benoit wrote:
> On 2/2/2012 10:53 PM, Felipe Balbi wrote:
> >Hi again,
> >
> >On Thu, Feb 02, 2012 at 11:49:08PM +0200, Felipe Balbi wrote:
> >>>In fact the driver already handled the 6 GPIOS banks as individual dev=
ices:
> >>>
> >>>[    0.185638] gpiochip_add: registered GPIOs 0 to 31 on device: gpio
> >>>[    0.185882] OMAP GPIO hardware version 0.1
> >>>[    0.186767] gpiochip_add: registered GPIOs 32 to 63 on device: gpio
> >>>[    0.187744] gpiochip_add: registered GPIOs 64 to 95 on device: gpio
> >>>[    0.188751] gpiochip_add: registered GPIOs 96 to 127 on device: gpio
> >>>[    0.189819] gpiochip_add: registered GPIOs 128 to 159 on device: gp=
io
> >>>[    0.190917] gpiochip_add: registered GPIOs 160 to 191 on device: gp=
io
> >>
> >>yeah, but you can get all of that for free from driver core. Just add
> >>one platform_device for each bank and make the omap-gpio.c only
> >>understand one bank. No tricks.
> >>
> >>What I'm trying to say is to remove the Bank array or list_head and make
> >>probe() get called 6 times by creating 6 omap_gpio platform_devices.
> >>
> >> From probe you cann gpiochip_add() once and only once.
> >		^^^^
> >		 call
> >
> >I actually just took the time to go over the driver and that's what it
> >does. So the list_head is only there fo the nasty cpuidle stuff below:
>=20
> Yes, that was my point :-)

:-) my bad

> >>>That list is only used to iterate over all the instances during CPU id=
le:
> >>>
> >>>void omap2_gpio_prepare_for_idle(int pwr_mode)
> >>>{
> >>>	struct gpio_bank *bank;
> >>>
> >>>	list_for_each_entry(bank,&omap_gpio_list, node) {
> >>>		if (!bank->mod_usage || !bank->loses_context)
> >>>			continue;
> >>>
> >>>		bank->power_mode =3D pwr_mode;
> >>>
> >>>		pm_runtime_put_sync_suspend(bank->dev);
> >>>	}
> >>>}
> >>>
> >>>void omap2_gpio_resume_after_idle(void)
> >>>{
> >>>	struct gpio_bank *bank;
> >>>
> >>>	list_for_each_entry(bank,&omap_gpio_list, node) {
> >>>		if (!bank->mod_usage || !bank->loses_context)
> >>>			continue;
> >>>
> >>>		pm_runtime_get_sync(bank->dev);
> >>>	}
> >>>}
> >>
> >>that's the thing which is unnecessary, actually :-)
> >>
> >>Why do we even have this omap2_gpio_resume_after_idle() ? Can't the gpio
> >>driver handle its own PM or listen to cpuidle notificaitons for that ?
> >>
> >>I would like to understand why do we need this hack for pm runtime.
> >>Can't you just use ->prepare() and ->complete() from dev_pm_ops ?
> >
> >This question remains. Why do we need those funtions ?
>=20
> These functions are called from the CPUIdle path so outside the scope
> of the GPIO driver. These are part of a bunch of nasty PM hacks we
> are doing in the CPU idle loop. We are in the process of getting rid
> of most of them, but it looks like some are still needed.

Too bad. I can see that the gpio pm implementation seems a bit
"peculiar". I mean, pm does reference counting and yet the driver has
checks to prevent multiple gets and puts on a single bank (meaning that
pm counter will be either 0 or 1 at any point in time).

To me it looks like those functions are there in order to forcefully put
PER power domain in OFF because drivers are always holding a reference
to their gpios (drivers generally gpio_request() on probe() and
gpio_free() on remove()).

Looks like the entire pm implementation on OMAP gpio driver has always
considered only the fact that gpios can be requested and freed, but
never that we want the system to go to OFF even while gpios are
requested, because we have I/O PAD wakeups. At some point that has to be
sorted out because that HACK is quite ugly :-)

I'll see if I find some time to go over the interactions between
gpio-omap.c and pm24x.c and pm34xx.c any of these days, but I can't
promise anything ;-)

--=20
balbi

--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPKwkwAAoJEIaOsuA1yqREtywP/1jfDUYZGhx0hHw/S4n3mapD
PXSvoXgV6GIaj3WdMAT13yAiwCL++GuQYxNYYOpzenlPXYJRoC5X1i2v6TpIzjOQ
LLTabsTELPTDaZfGD6m2HNi0XJtB/K5d9Fl+RoY61J+88NtrK0Z5hBYYxS8cChso
881vsFxmG+AQ9THTVwqjdurhWuegskzjmugcM2ZZXb9SqkzA0AOF+tQ4LPdJBm6L
4lUQenlekFvZTVDnOsUwTL+HJYooDaphMae72OfCG+8Go1Oj3FQweXynSVT4wf2C
1cc2lH1DPiqDRntUPNcpeuTZMyJ6p6OoOZKCl4Aqu/l/71txJAgJa2Qzu/N5tWFM
kpGYncdFVLyIckzdKwv0T0R7Q7DyLU9mQLUMdakHvf7kfrki67c3EBJNWTgeMv1+
5p2L3FMXdY/ugIOkL0ibiJPo0kiYbukI2O2rFlC3cXQOkegbEr75k/wZqY7EhwkD
tR418M/0PLO6ebz7VyG+ZTtaNu76RL8gDji1+j/v92M+igJxv042Z5ijIf09bQry
ztavtHwcdP6dpDOKU7aZLPb3skG6FRNv9v5BDfmsli5qVExMc2qYgKaUtptjWfWd
dizbeXugChly4JZEDcIGL7u4c0XWYWi2P5TAt9QnoSFaGnM023IETrROZXG8liUQ
22CMPdXXAG9Nq/3CFzPY
=MVdn
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--

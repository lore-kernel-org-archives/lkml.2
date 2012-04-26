Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759405Ab2DZUkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 16:40:10 -0400
Received: from na3sys009aog136.obsmtp.com ([74.125.149.85]:51399 "EHLO
	na3sys009aog136.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759222Ab2DZUkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 16:40:07 -0400
Date: Thu, 26 Apr 2012 23:38:48 +0300
From: Felipe Balbi <balbi@ti.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: balbi@ti.com, Hiroshi DOYU <hdoyu@nvidia.com>, swarren@nvidia.com,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Jamie Iles <jamie@jamieiles.com>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/4] ARM: tegra: Add SMMU enabler in AHB
Message-ID: <20120426203847.GC30690@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1335352072-4001-1-git-send-email-hdoyu@nvidia.com>
 <1335352072-4001-2-git-send-email-hdoyu@nvidia.com>
 <4F99A821.2040406@wwwdotorg.org>
 <20120426202610.GA30690@arwen.pp.htv.fi>
 <4F99B0F8.4040308@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZmUaFz6apKcXQszQ"
Content-Disposition: inline
In-Reply-To: <4F99B0F8.4040308@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZmUaFz6apKcXQszQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Apr 26, 2012 at 02:32:56PM -0600, Stephen Warren wrote:
> On 04/26/2012 02:26 PM, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Thu, Apr 26, 2012 at 01:55:13PM -0600, Stephen Warren wrote:
> >> On 04/25/2012 05:07 AM, Hiroshi DOYU wrote:
> >>> Add extern func, "tegra_ahb_enable_smmu()" to inform AHB that SMMU is
> >>> ready.
> >>
> >>> +#ifdef CONFIG_ARCH_TEGRA_3x_SOC
> >>> +static int __tegra_ahb_enable_smmu(struct device *dev, void *data)
> >> ...
> >>> +int tegra_ahb_enable_smmu(void)
> >>> +{
> >>> +	return driver_for_each_device(&tegra_ahb_driver.driver, NULL, NULL,
> >>> +				      __tegra_ahb_enable_smmu);
> >>> +}
> >>> +EXPORT_SYMBOL(tegra_ahb_enable_smmu);
> >>> +#endif
> >>
> >> That looks like a neat solution to avoid having a global device object.
> >=20
> > except that it won't work always. If you happen to have two AHB bridges,
> > each using a separate smmu but only one smmu is ready, this will set
> > SMMU_INIT_DONE on both bridges.
>=20
> There is only 1.

that's why there's a "if you happen to have" statement. If you stick to
this "there is only 1" argument, why do you even make this into a
platform driver ? Just stick the entire code hidden on the
machine_init() code. Drivers a supposed to be able to instantiated
multiple times and always work, this method won't work if tegra99999
ends up with two AHB bridges/SMMUs

> >> However, if that driver_for_each_device finds no devices, the function
> >> still succeeds. That doesn't seem right, and doesn't allow e.g. the SM=
MU
> >> to defer its probe until the AHB driver has completed.
> >>
> >> Perhaps add a local int variable to tegra_ahb_enable_smmu(), pass the
> >> address to __tegra_ahb_enable_smmu, and have it increment the int. The=
n,
> >> after calling driver_for_each_device,:
> >>
> >> if (!ahb_device_count)
> >>     return -EPROBE_DEFER
> >> if (WARN_ON(ahb_device_count !=3D 1))
> >>     return -EINVAL;
> >> return 0;
> >=20
> > that would look, well, weird. Why don't you just different initcall
> > leves for this ? Maybe smmu goes into postcore_initcall() and tegra_ahb
> > goes into postcore_initcall_sync() ?? then you know that SMMU will be
> > ready by the time you call tegra_ahb probe. Well, unless smmu's probe
> > fail, but then again, IIUC it won't work anyway...
>=20
> Uggh. I'd rather all these devices just got instantiated from device
> tree and relied on deferred probe to manage any ordering, rather than
> playing complex games with multiple initcall levels (and in the end
> probably having to invent more and more initcall levels to correctly
> represent all the dependencies).

then do that... it'll be better than current trickery with
driver_for_each_device() and my initcall trickery ;-)

--=20
balbi

--ZmUaFz6apKcXQszQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPmbJXAAoJEIaOsuA1yqREPP4P/1i+vnYhVRr3u9C7Jq/c653V
yO9oxIC3/DTwcLe7uLzBs1SrVQFLn8vc9KC6lLV8C8JZkDEM74w6+8e21hAiYytR
j1F0A1zTBcAChGivFO4wCXUwcyQxOsTx4Bpjh6B7PQhOt/qYr9zBQs8/AFo0eYYa
qJVTENZCr4bD2h21zlKtZcfSOoTAAdOcKW5UJL2L5vpYy/58NEGjWZzO3Ok1WCh3
CpL0AgsVLuoYO8uqxgacyWS8EChwlDK54jKu+0x8KUayWsCWlzNUz+6QxufgdgcB
iScZp0o6Bew/QkYvT+n8QekaHuHQ8FJ5gZOPG7SaoFv88PdH0L1VBw/3hGZCnveh
o4dLl1zNAqtICFI2RU/hATu3jf6a9LlNCRhhtWgJmeoShD1zum1wqJR3d85Xvmbe
ry+FvyZc7ZXH2UFOb9MGTWIA5wklRMxEv4G8zMIqbQ1FZ4R1rgKx3aCQZmD1I8um
KtNprat8SFbCtTaJVhqanSY+6NxeDZSH9n9bGiueC0GhrWuQoJ4iDlJdVw1CPUR7
gYzz9S8qq558jUclWIiV/JRw03Jm0rPrCvJsH7Dn+L0bPMbW2Xt/1dE+JgYboyX9
1o7/j4XS7MsIJHJ04YEbZp2XER356m2qy1ic7qNQyQVZ5gqOgyl6vdzn86SzSS+D
ETkcN3bzBxoctjOuCJX8
=96kl
-----END PGP SIGNATURE-----

--ZmUaFz6apKcXQszQ--

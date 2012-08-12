Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab2HLOD6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 10:03:58 -0400
Received: from mail.gw90.de ([188.40.100.199]:56425 "EHLO mail.gw90.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040Ab2HLODy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 10:03:54 -0400
Message-ID: <1344780214.4275.14.camel@mattotaupa>
Subject: Re: [PATCH] sp5100_tco: Add SB8x0 chipset support
From: Paul Menzel <paulepanter@users.sourceforge.net>
To: Takahisa Tanaka <mc74hc00@gmail.com>
Cc: linux-watchdog@vger.kernel.org, wim@iguana.be, stable@kernel.org,
        post+kernel@ralfj.de, linux-kernel@vger.kernel.org
Date: Sun, 12 Aug 2012 16:03:34 +0200
In-Reply-To: <1344772669-2872-1-git-send-email-mc74hc00@gmail.com>
References: <1344772669-2872-1-git-send-email-mc74hc00@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Xv/a4n6PnvouBlM6mhJj"
X-Mailer: Evolution 3.2.2-1+b1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Xv/a4n6PnvouBlM6mhJj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Am Sonntag, den 12.08.2012, 20:57 +0900 schrieb Takahisa Tanaka:
> The current sp5100_tco driver only supports SP5100/SB7x0 chipset, doesn't
> support SB8x0 chipset, because current sp5100_tco driver doesn't know tha=
t the
> offset address for watchdog timer was changed from SB8x0 chipset.
>=20
> The offset address of SP5100 and SB7x0 chipsets are as follows, quote fro=
m the
> AMD SB700/710/750 Register Reference Guide(Page 164) and the AMD SP5100
> Register Reference Guide(Page 166).
>=20
>   WatchDogTimerControl 69h
>   WatchDogTimerBase0   6Ch
>   WatchDogTimerBase1   6Dh
>   WatchDogTimerBase2   6Eh
>   WatchDogTimerBase3   6Fh
>=20
> In contrast, the offset address of SB8x0 chipset is as follows, quote fro=
m
> AMD SB800-Series Southbridges Register Reference Guide(Page 147).
>=20
>   WatchDogTimerEn      48h
>   WatchDogTimerConfig  4Ch
>=20
> So, In the case of SB8x0 chipset, sp5100_tco reads meaningless MMIO
> address(for example, 0xbafe00) from wrong offset address, and the followi=
ng
> message is logged.
>=20
>    SP5100 TCO timer: mmio address 0xbafe00 already in use
>=20
> With this patch, sp5100_tco driver supports SB8x0 chipset, and can avoid
> iomem resource conflict. The processing of this patch is as follows.
>=20
>  Step 1) Attempt to get the watchdog base address from indirect I/O(0xCD6
>          and 0xCD7).
>   - Go to the step 7 if obtained address hasn't conflicted with other
>     resource. But, currently, the address(0xfec000f0) conflicts with the
>     IOAPIC MMIO address, and the following message is logged.
>=20
>        SP5100 TCO timer: mmio address 0xfec000f0 already in use
>=20
>     0xfec000f0 is recommended by AMD BIOS Developer's Guide. So, go to th=
e
>     next step.
>=20
>  Step 2) Attempt to get the SBResource_MMIO base address from AcpiMmioEN(=
for
>          SB8x0,  PM_Reg:24h) or SBResource_MMIO(SP5100/SB7x0, PCI_Reg:9Ch=
)
>          register.
>   - Go to the step 7 if these register has enabled by BIOS, and obtained
>     address hasn't conflicted with other resource.
>   - If above condition isn't true, go to the next step.
>=20
>  Step 3) Attempt to get the free MMIO address from allocate_resource().
>   - Go to the step 7 if these register has enabled by BIOS, and obtained
>     address hasn't conflicted with other resource.
>   - Driver initialization has failed if obtained address has conflicted
>     with other resource, and no 'force_addr' parameter is specified.
>=20
>  Step 4) Use the specified address If 'force_addr' parameter is specified=
.
>   - allocate_resource() function may fail, when the PCI bridge device occ=
upies
>     iomem resource from 0xf0000000 to 0xffffffff. To handle such a case,
>     I added 'force_addr' parameter to sp5100_tco driver. With 'force_addr=
'
>     parameter, sp5100_tco driver directly can assign MMIO address for wat=
chdog
>     timer from free iomem region. Note that It's dangerous to specify wro=
ng
>     address in the 'force_addr' parameter.
>=20
>       Example of force_addr parameter use
>         # cat /proc/iomem
>         ...snip...
>         fec00000-fec003ff : IOAPIC 0
>                                       <--- free MMIO region
>         fec10000-fec1001f : pnp 00:0b
>         fec20000-fec203ff : IOAPIC 1
>         ...snip...
>         # cat /etc/modprobe.d/sp5100_tco.conf
>         options sp5100_tco force_addr=3D0xfec00800
>         # modprobe sp5100_tco
>         # cat /proc/iomem
>         ...snip...
>         fec00000-fec003ff : IOAPIC 0
>         fec00800-fec00807 : SP5100 TCO  <--- watchdog timer MMIO address
>         fec10000-fec1001f : pnp 00:0b
>         fec20000-fec203ff : IOAPIC 1
>         ...snip...
>         #
>=20
>   - Driver initialization has failed if specified address has conflicted
>     with other resource.
>=20
>  Step 5) Disable the watchdog timer
>   - To rewrite the watchdog timer register of the chipset, absolutely
>     guarantee that the watchdog timer is disabled.
>=20
>  Step 6) Re-program the watchdog timer MMIO address to chipset.
>   - Re-program the obtained MMIO address in Step 3 or Step 4 to chipset v=
ia
>     indirect I/O(0xCD6 and 0xCD7).
>=20
>  Step 7) Enable and setup the watchdog timer
>=20
> This patch has worked fine on my test environment(ASUS M4A89GTD-PRO/USB3 =
and
> DL165G7). therefore I believe that it's no problem to re-program the MMIO
> address for watchdog timer to chipset during disabled watchdog. However,
> I'm not sure about it, because I don't know much about chipset programmin=
g.
>=20
> So, any comments will be welcome.
>=20
> Tested-by: Paul Menzel <paulepanter@users.sourceforge.net>

ASRock A780FullHD <http://www.asrock.com/mb/overview.asp?model=3Da780fullhd=
>

> CC: stable@kernel.org

I am sorry. This should have been <stable@vger.kernel.org>.

> Signed-off-by: Takahisa Tanaka <mc74hc00@gmail.com>

After review from the maintainers, please also add

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=3D43176

when sending `PATCH v2` (`--subject-prefix` [1]).

[1] http://wireless.kernel.org/en/developers/Documentation/git-guide#Annota=
ting_new_revision

> ---
>  drivers/watchdog/sp5100_tco.c | 291 ++++++++++++++++++++++++++++++++++++=
------
>  drivers/watchdog/sp5100_tco.h |  46 +++++--
>  2 files changed, 286 insertions(+), 51 deletions(-)
>=20
> diff --git a/drivers/watchdog/sp5100_tco.c b/drivers/watchdog/sp5100_tco.=
c
> index ae5e82c..36e917f 100644
> --- a/drivers/watchdog/sp5100_tco.c
> +++ b/drivers/watchdog/sp5100_tco.c
> @@ -13,7 +13,9 @@
>   *	as published by the Free Software Foundation; either version
>   *	2 of the License, or (at your option) any later version.
>   *
> - *	See AMD Publication 43009 "AMD SB700/710/750 Register Reference Guide=
"
> + *	See AMD Publication 43009 "AMD SB700/710/750 Register Reference Guide=
",
> + *	    AMD Publication 45482 "AMD SB800-Series Sourthbridges Register

Sou*thbridges

> + *	                                                      Reference Guide=
"
>   */
> =20
>  /*
> @@ -38,18 +40,23 @@
>  #include "sp5100_tco.h"
> =20
>  /* Module and version information */
> -#define TCO_VERSION "0.01"
> +#define TCO_VERSION "0.03"
>  #define TCO_MODULE_NAME "SP5100 TCO timer"
>  #define TCO_DRIVER_NAME   TCO_MODULE_NAME ", v" TCO_VERSION
> =20
>  /* internal variables */
>  static u32 tcobase_phys;
> +static u32 resbase_phys;
>  static void __iomem *tcobase;
>  static unsigned int pm_iobase;
>  static DEFINE_SPINLOCK(tco_lock);	/* Guards the hardware */
>  static unsigned long timer_alive;
>  static char tco_expect_close;
>  static struct pci_dev *sp5100_tco_pci;
> +static struct resource wdt_res =3D {
> +	.name =3D "Watchdog Timer",
> +	.flags =3D IORESOURCE_MEM,
> +};
> =20
>  /* the watchdog platform device */
>  static struct platform_device *sp5100_tco_platform_device;
> @@ -67,6 +74,12 @@ module_param(nowayout, bool, 0);
>  MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started"
>  		" (default=3D" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
> =20
> +static unsigned int force_addr;
> +module_param(force_addr, uint, 0);
> +MODULE_PARM_DESC(force_addr, "Force the use of specified MMIO address, "
> +		"default is disabled. DON'T USE THIS PARAMETER ONLY "
> +		"IF YOU REALLY KNOW WHAT YOU ARE DOING");

ONLY USE THIS PARAMETER IF YOU REALLY KNOW WHAT YOU ARE DOING!

[=E2=80=A6]


Thanks,

Paul

--=-Xv/a4n6PnvouBlM6mhJj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlAnt7YACgkQPX1aK2wOHVj8WQCfbdE3bKxl6Hj0VAMJPBDvsBX4
LpUAnidJeGLh5q7HofuENEC5mIhza0XZ
=sCpy
-----END PGP SIGNATURE-----

--=-Xv/a4n6PnvouBlM6mhJj--


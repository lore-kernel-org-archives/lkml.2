Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab1LCBfw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 20:35:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54805 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753626Ab1LCBft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 20:35:49 -0500
Date: Sat, 3 Dec 2011 12:35:16 +1100
From: NeilBrown <neilb@suse.de>
To: Igor Grinberg <grinberg@compulab.co.il>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MFD: TWL: add power off functionality
Message-ID: <20111203123516.5ebb057b@notabene.brown>
In-Reply-To: <4ED205F9.3070908@compulab.co.il>
References: <1321177790-5886-1-git-send-email-grinberg@compulab.co.il>
	<4ED205F9.3070908@compulab.co.il>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/004Kf26VpFZjPWpWb8S_4PD"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/004Kf26VpFZjPWpWb8S_4PD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 27 Nov 2011 11:42:17 +0200 Igor Grinberg <grinberg@compulab.co.il>
wrote:

> ping!

pong ...


Hi,
 I've been trying this patch out on my GTA04 with 3.2-rc4 and it doesn't
 work :-(

 As soon as it tries to touch the i2c controller to send the power-down
 message I get:

[   96.130920] Unhandled fault: external abort on non-linefetch (0x1028) at=
 0xfa070008
[   96.138885] Internal error: : 1028 [#1] PREEMPT
[   96.143585] Modules linked in: bluetooth ipv6 g_ether hso rfkill
[   96.149841] CPU: 0    Not tainted  (3.2.0-rc4+ #145)
[   96.155029] PC is at omap_i2c_wait_for_bb+0xc4/0x100
[   96.160186] LR is at omap_i2c_wait_for_bb+0xac/0x100
[   96.165344] pc : [<c02e84d4>]    lr : [<c02e84bc>]    psr: 60000013
[   96.165344] sp : d4a1ddc0  ip : d4a1dd20  fp : 00000002
[   96.177246] r10: 00000002  r9 : c0d1f2c8  r8 : dbda9c00
[   96.182678] r7 : c05d2a88  r6 : dbda9c00  r5 : ffff9aa8  r4 : c0d1f458
[   96.189453] r3 : 00000008  r2 : 00000002  r1 : fa070000  r0 : 00000001
[   96.196228] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment=
 user
[   96.203643] Control: 10c5387d  Table: 8bdc8019  DAC: 00000015
[   96.209625] Process poweroff (pid: 722, stack limit =3D 0xd4a1c2f0)

The call trace is=20
[   96.373413] [<c02e84d4>] (omap_i2c_wait_for_bb+0xc4/0x100) from [<c02e8a=
a8>] (omap_i2c_xfer+0x34/0x4fc)
[   96.383178] [<c02e8aa8>] (omap_i2c_xfer+0x34/0x4fc) from [<c02e6978>] (i=
2c_transfer+0xac/0x130)
[   96.392211] [<c02e6978>] (i2c_transfer+0xac/0x130) from [<c0259d20>] (tw=
l_i2c_read+0xd8/0x12c)
[   96.401153] [<c0259d20>] (twl_i2c_read+0xd8/0x12c) from [<c025ba0c>] (tw=
l4030_power_off+0x34/0x124)
[   96.410583] [<c025ba0c>] (twl4030_power_off+0x34/0x124) from [<c000f130>=
] (machine_power_off+0x1c/0x28)
[   96.420349] [<c000f130>] (machine_power_off+0x1c/0x28) from [<c004ad94>]=
 (sys_reboot+0x124/0x1e0)
[   96.429565] [<c004ad94>] (sys_reboot+0x124/0x1e0) from [<c000e780>] (ret=
_fast_syscall+0x0/0x3c)


It has accessed this same address 0xfa070008 multiple times during normally
running, but here at shutdown it gets an external abort.
Presumably something is being turned of earlier in the shutdown sequence so
that i2c is no longer available, but I have no idea what.

Do you have any idea what might be being disabled/turned-off/unmapped/
cleared/whatever that could cause this?

I see:
[   96.029968] twl 1-0048: shutdown
[   96.038604] i2c i2c-1: shutdown

amongst the messages, but as far as I can tell there is no actual shutdown
method for these to call so they don't do anything.

Ideas?

Thanks,
NeilBrown


>=20
>=20
> On 11/13/11 11:49, Igor Grinberg wrote:
> > TWL family of PMICs, used in master mode, have a power off
> > functionality. The resulting power off sequence shuts down all the SoC
> > supplies, LDOs, etc. The sequence is described in the datasheets
> > chapter "Power-Off Sequence".
> > Note, that board must be wired correctly for the power off to work as
> > expected.
> >=20
> > Signed-off-by: Igor Grinberg <grinberg@compulab.co.il>
> > ---
> >  drivers/mfd/twl4030-power.c |   42 +++++++++++++++++++++++++++++++++++=
+++++--
> >  include/linux/i2c/twl.h     |    2 ++
> >  2 files changed, 42 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/drivers/mfd/twl4030-power.c b/drivers/mfd/twl4030-power.c
> > index a764676..d905f51 100644
> > --- a/drivers/mfd/twl4030-power.c
> > +++ b/drivers/mfd/twl4030-power.c
> > @@ -34,7 +34,8 @@
> >  static u8 twl4030_start_script_address =3D 0x2b;
> > =20
> >  #define PWR_P1_SW_EVENTS	0x10
> > -#define PWR_DEVOFF	(1<<0)
> > +#define PWR_DEVOFF		(1 << 0)
> > +#define SEQ_OFFSYNC		(1 << 0)
> > =20
> >  #define PHY_TO_OFF_PM_MASTER(p)		(p - 0x36)
> >  #define PHY_TO_OFF_PM_RECEIVER(p)	(p - 0x5b)
> > @@ -511,12 +512,27 @@ int twl4030_remove_script(u8 flags)
> >  	return err;
> >  }
> > =20
> > +/*
> > + * In master mode, start the power off sequence.
> > + * After a successful execution, TWL shuts down the power to the SoC
> > + * and all peripherals connected to it.
> > + */
> > +void twl4030_power_off(void)
> > +{
> > +	int err;
> > +
> > +	err =3D twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, PWR_DEVOFF,
> > +			       TWL4030_PM_MASTER_P1_SW_EVENTS);
> > +	if (err)
> > +		pr_err("TWL4030 Unable to power off\n");
> > +}
> > +
> >  void __init twl4030_power_init(struct twl4030_power_data *twl4030_scri=
pts)
> >  {
> >  	int err =3D 0;
> >  	int i;
> >  	struct twl4030_resconfig *resconfig;
> > -	u8 address =3D twl4030_start_script_address;
> > +	u8 val, address =3D twl4030_start_script_address;
> > =20
> >  	err =3D twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER,
> >  			TWL4030_PM_MASTER_KEY_CFG1,
> > @@ -548,6 +564,28 @@ void __init twl4030_power_init(struct twl4030_powe=
r_data *twl4030_scripts)
> >  		}
> >  	}
> > =20
> > +	/* Board has to be wired properly to use this feature */
> > +	if (twl4030_scripts->use_poweroff && !pm_power_off) {
> > +		/* Default for SEQ_OFFSYNC is set, lets ensure this */
> > +		err =3D twl_i2c_read_u8(TWL4030_MODULE_PM_MASTER, &val,
> > +				      TWL4030_PM_MASTER_CFG_P123_TRANSITION);
> > +		if (err) {
> > +			pr_warning("TWL4030 Unable to read registers\n");
> > +
> > +		} else if (!(val & SEQ_OFFSYNC)) {
> > +			val |=3D SEQ_OFFSYNC;
> > +			err =3D twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, val,
> > +					TWL4030_PM_MASTER_CFG_P123_TRANSITION);
> > +			if (err) {
> > +				pr_err("TWL4030 Unable to setup SEQ_OFFSYNC\n");
> > +				goto relock;
> > +			}
> > +		}
> > +
> > +		pm_power_off =3D twl4030_power_off;
> > +	}
> > +
> > +relock:
> >  	err =3D twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, 0,
> >  			TWL4030_PM_MASTER_PROTECT_KEY);
> >  	if (err)
> > diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
> > index 114c0f6..78d3465 100644
> > --- a/include/linux/i2c/twl.h
> > +++ b/include/linux/i2c/twl.h
> > @@ -652,10 +652,12 @@ struct twl4030_power_data {
> >  	unsigned num;
> >  	struct twl4030_resconfig *resource_config;
> >  #define TWL4030_RESCONFIG_UNDEF	((u8)-1)
> > +	bool use_poweroff;	/* Board is wired for TWL poweroff */
> >  };
> > =20
> >  extern void twl4030_power_init(struct twl4030_power_data *triton2_scri=
pts);
> >  extern int twl4030_remove_script(u8 flags);
> > +extern void twl4030_power_off(void);
> > =20
> >  struct twl4030_codec_data {
> >  	unsigned int digimic_delay; /* in ms */
>=20


--Sig_/004Kf26VpFZjPWpWb8S_4PD
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTtl82Tnsnt1WYoG5AQJYMRAAlIgLE4j9RCW4wSv/NLxUGOjwkQDivPKp
KWqY1Z//wxg82kUIXwz0AJc0RxpzN0JlmPOlK68FJONAJyUgdftPCaERSyLnbxXI
YxzOJTvyvgqNrIGEz0uAjBZwNxGDh/wl9WLQUG7s6nMcQmRkC4zuk40kuH/ETHNu
bBKsa5VQxeUfmke1yJ8mAFcNPNy6+d0SIxr0BvgGSNB0IAkPETjoVys1feCJ/i1u
4qQVWrBJiItpDHeY7PIywz30XzBSzC5JkZA6DnBxn79RyCFAShvormuZabeVTElM
Dge0CXbNntsoSkQ59E6rqvZvj4o//2Isge8a4UQRT3abt6J75vqKHvGZi2klIpDw
bYmR3JB3/a/kkapW1N03dNfIxiIuxRLd5bfh48pZGfmBdoKnQoOUBNQYkDdQ6YuN
Jfe4RurdgXBP9AyqFaB0l1i0ZGhzFcXS7NogfNmLWcx5FkfIMwnUPSTJngvbY+s1
FhtdHGSbm4T4Us6ycAAEqfVayDtKYLIyJZh3i13OG0rSJBdszepSVdGc1UTnwqsZ
NdaJ7jUMykxwC/S2dmEXaIZ4FKUlQ2LoZtzfLwAnFwqzS/R3nUglMdXWJIkYWnFO
cHQWMmkUHBVOC3D59ix9de78B0STTdtZLwtDBkoKqsH74oxh6Cj6UMlPT9azntmL
XZ5Ryg2Xl+0=
=EG+s
-----END PGP SIGNATURE-----

--Sig_/004Kf26VpFZjPWpWb8S_4PD--

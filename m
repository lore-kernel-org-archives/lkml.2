Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab0HTPGn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 11:06:43 -0400
Received: from fb1.tech.numericable.fr ([82.216.111.51]:35784 "EHLO
	fb1.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200Ab0HTPGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 11:06:40 -0400
Subject: Re: [PATCH 1/4] Smedia Glamo 3362 core/resource driver
From: Thibaut Girka <thib@sitedethib.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20100818133914.GC2608@sortiz-mobl>
References: <1278508326-7109-1-git-send-email-thib@sitedethib.com>
	 <1278508326-7109-2-git-send-email-thib@sitedethib.com>
	 <20100818133914.GC2608@sortiz-mobl>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-N982bTA/nS7oqUVOqUM6"
Date: Fri, 20 Aug 2010 17:05:46 +0200
Message-ID: <1282316746.3093.38.camel@debian-thib>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-N982bTA/nS7oqUVOqUM6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mercredi 18 ao=C3=BBt 2010 =C3=A0 15:39 +0200, Samuel Ortiz a =C3=A9crit=
 :=20
> Hi Thibaut,

Hi!

> On Wed, Jul 07, 2010 at 03:12:03PM +0200, Thibaut Girka wrote:
> > +#define GLAMO_IRQ_HOSTBUS	0
> > +#define GLAMO_IRQ_JPEG		1
> > +#define GLAMO_IRQ_MPEG		2
> > +#define GLAMO_IRQ_MPROC1	3
> > +#define GLAMO_IRQ_MPROC0	4
> > +#define GLAMO_IRQ_CMDQUEUE	5
> > +#define GLAMO_IRQ_2D		6
> > +#define GLAMO_IRQ_MMC		7
> > +#define GLAMO_IRQ_RISC		8
> This is conflicting with enum glamo_irq, please fix your namespaces.

Fixed.=20

> > +
> > +/*
> > + * Glamo internal settings
> > + *
> > + * We run the memory interface from the faster PLLB on 2.6.28 kernels =
and
> > + * above.  Couple of GTA02 users report trouble with memory bus when t=
hey
> > + * upgraded from 2.6.24.  So this parameter allows reversion to 2.6.24
> > + * scheme if their Glamo chip needs it.
> So you're saying that a couple users reported a bug on a specific kernel
> revision, with the same HW, but all other users haven't ?
> Couldnt that be related to a specific HW revision ?=20
> Also, this code should be scheduled for 2.6.37, and we're not going to
> carry code to allow it to run on 2.6.28.

Well, OpenMoko, the project behind this driver, has been carrying its
own linux tree for years, now, and "2.6.28" and "2.6.24" are referring
to the whole branch, glamo-core included.
So, it hasn't really something to do with the kernel version, but with
the version of the driver itself.
It is not here to allow the driver to run on a specific kernel version.

> > +static const struct reg_range reg_range[] =3D {
> > +	{ 0x0000, 0x76,		"General",	1 },
> > +	{ 0x0200, 0x18,		"Host Bus",	1 },
> > +	{ 0x0300, 0x38,		"Memory",	1 },
> > +/*	{ 0x0400, 0x100,	"Sensor",	0 }, */
> > +/*	{ 0x0500, 0x300,	"ISP",		0 }, */
> > +/*	{ 0x0800, 0x400,	"JPEG",		0 }, */
> > +/*	{ 0x0c00, 0xcc,		"MPEG",		0 }, */
> > +	{ 0x1100, 0xb2,		"LCD 1",	0 },
> > +	{ 0x1200, 0x64,		"LCD 2",	0 },
> > +	{ 0x1400, 0x42,		"MMC",		0 },
> > +/*	{ 0x1500, 0x080,	"MPU 0",	0 },
> > +	{ 0x1580, 0x080,	"MPU 1",	0 },
> > +	{ 0x1600, 0x080,	"Cmd Queue",	0 },
> > +	{ 0x1680, 0x080,	"RISC CPU",	0 },*/
> > +	{ 0x1700, 0x400,	"2D Unit",	0 },
> > +/*	{ 0x1b00, 0x900,	"3D Unit",	0 }, */
> > +};
> Please remove the commented code from this array.

Hm, well, that may be useful, for "documentation" and future work, but
we can remove it.

> > +static void glamo_irq_demux_handler(unsigned int irq, struct irq_desc =
*desc)
> > +{
> > +	struct glamo_core *glamo =3D get_irq_desc_data(desc);
> > +	desc->status &=3D ~(IRQ_REPLAY | IRQ_WAITING);
> > +
> > +	if (unlikely(desc->status & IRQ_INPROGRESS)) {
> > +		desc->status |=3D (IRQ_PENDING | IRQ_MASKED);
> > +		desc->chip->mask(irq);
> > +		desc->chip->ack(irq);
> > +		return;
> > +	}
> > +	kstat_incr_irqs_this_cpu(irq, desc);
> > +
> > +	desc->chip->ack(irq);
> > +	desc->status |=3D IRQ_INPROGRESS;
> > +
> > +	do {
> > +		uint16_t irqstatus;
> > +		int i;
> > +
> > +		if (unlikely((desc->status &
> > +				(IRQ_PENDING | IRQ_MASKED | IRQ_DISABLED)) =3D=3D
> > +				(IRQ_PENDING | IRQ_MASKED))) {
> > +			/* dealing with pending IRQ, unmasking */
> > +			desc->chip->unmask(irq);
> > +			desc->status &=3D ~IRQ_MASKED;
> > +		}
> > +
> > +		desc->status &=3D ~IRQ_PENDING;
> > +
> > +		/* read IRQ status register */
> > +		irqstatus =3D __reg_read(glamo, GLAMO_REG_IRQ_STATUS);
> > +		for (i =3D 0; i < 9; ++i) {
> > +			if (irqstatus & BIT(i))
> > +				generic_handle_irq(glamo->irq_base + i);
> > +		}
> > +
> > +	} while ((desc->status & (IRQ_PENDING | IRQ_DISABLED)) =3D=3D IRQ_PEN=
DING);
> So here you're busy looping in an interrupt handler, and that's not
> recommended.

Hm, ok... Not sure how to do that otherwise, but I'll have a look.

> > +#ifdef CONFIG_DEBUG_FS
> > [...]
> > +struct glamo_engine_reg_set {
> > +	uint16_t reg;
> > +	uint16_t mask_suspended;
> > +	uint16_t mask_enabled;
> > +};
> I think you want this definition outside of the DEBUGFS if.else.endif
> scope. Have you tried building this driver without DEBUGFS enabled ?

Yes, indeed, it should be outside of the DEBUGFS scope.
Fixed.


> > +static const struct glamo_engine_reg_set glamo_lcd_regs[] =3D {
> > +	{ GLAMO_REG_CLOCK_LCD,
> > +	GLAMO_CLOCK_LCD_EN_M5CLK |
> > +	GLAMO_CLOCK_LCD_DG_M5CLK |
> > +	GLAMO_CLOCK_LCD_EN_DMCLK,
> > +
> > +	GLAMO_CLOCK_LCD_EN_DHCLK |
> > +	GLAMO_CLOCK_LCD_EN_DCLK
> > +	},
> > +	{ GLAMO_REG_CLOCK_GEN5_1,
> > +	GLAMO_CLOCK_GEN51_EN_DIV_DMCLK,
> > +
> > +	GLAMO_CLOCK_GEN51_EN_DIV_DHCLK |
> > +	GLAMO_CLOCK_GEN51_EN_DIV_DCLK
> > +	}
> > +};
> Identation could be clearer here:
> static const struct glamo_engine_reg_set glamo_lcd_regs[] =3D {
> 	{
> 		GLAMO_REG_CLOCK_LCD,
>=20
> 		GLAMO_CLOCK_LCD_EN_M5CLK |
> 		GLAMO_CLOCK_LCD_DG_M5CLK |
> 		GLAMO_CLOCK_LCD_EN_DMCLK,
>=20
> 		GLAMO_CLOCK_LCD_EN_DHCLK |
> 		GLAMO_CLOCK_LCD_EN_DCLK
> 	},
> [...]

Done.

>=20
> > +/*********************************************************************=
**
> > + * script support
> > + *********************************************************************=
**/
> > +
> > +#define GLAMO_SCRIPT_END	0xffff
> > +#define GLAMO_SCRIPT_WAIT	0xfffe
> > +#define GLAMO_SCRIPT_LOCK_PLL	0xfffd
> > +
> > +/*
> > + * couple of people reported artefacts with 2.6.28 changes, this
> > + * allows reversion to 2.6.24 settings
> > +*/
> Same remark as with the module option: This is going to be a 2.6.37
> driver, and I'd like you to check if you're still seeing those issues
> before carrying these kind of hacks.

As stated before, it hasn't anything to do with kernel version.
Though, I'm not sure this module parameter is still being used.=20
I'll either get rid of that, or make it clear in the comments.

> > +static const struct glamo_script glamo_init_script[] =3D {
> > +	{ GLAMO_REG_CLOCK_HOST,		0x1000 },
> > +	{ GLAMO_SCRIPT_WAIT,		     2 },
> > +	{ GLAMO_REG_CLOCK_MEMORY,	0x1000 },
> > +	{ GLAMO_REG_CLOCK_MEMORY,	0x2000 },
> > +	{ GLAMO_REG_CLOCK_LCD,		0x1000 },
> > +	{ GLAMO_REG_CLOCK_MMC,		0x1000 },
> > +	{ GLAMO_REG_CLOCK_ISP,		0x1000 },
> > +	{ GLAMO_REG_CLOCK_ISP,		0x3000 },
> > +	{ GLAMO_REG_CLOCK_JPEG,		0x1000 },
> > +	{ GLAMO_REG_CLOCK_3D,		0x1000 },
> > +	{ GLAMO_REG_CLOCK_3D,		0x3000 },
> > +	{ GLAMO_REG_CLOCK_2D,		0x1000 },
> > +	{ GLAMO_REG_CLOCK_2D,		0x3000 },
> > +	{ GLAMO_REG_CLOCK_RISC1,	0x1000 },
> > +	{ GLAMO_REG_CLOCK_MPEG,		0x1000 },
> > +	{ GLAMO_REG_CLOCK_MPEG,		0x3000 },
> > +	{ GLAMO_REG_CLOCK_MPROC,	0x1000 /*0x100f*/ },
> > +	{ GLAMO_SCRIPT_WAIT,		     2 },
> > +	{ GLAMO_REG_CLOCK_HOST,		0x0000 },
> > +	{ GLAMO_REG_CLOCK_MEMORY,	0x0000 },
> > +	{ GLAMO_REG_CLOCK_LCD,		0x0000 },
> > +	{ GLAMO_REG_CLOCK_MMC,		0x0000 },
> > +	{ GLAMO_REG_PLL_GEN1,		0x05db },	/* 48MHz */
> > +	{ GLAMO_REG_PLL_GEN3,		0x0aba },	/* 90MHz */
> > +	{ GLAMO_SCRIPT_LOCK_PLL, 0 },
> > +	/*
> > +	 * b9 of this register MUST be zero to get any interrupts on INT#
> > +	 * the other set bits enable all the engine interrupt sources
> > +	 */
> > +	{ GLAMO_REG_IRQ_ENABLE,		0x0100 },
> > +	{ GLAMO_REG_CLOCK_GEN6,		0x2000 },
> > +	{ GLAMO_REG_CLOCK_GEN7,		0x0101 },
> > +	{ GLAMO_REG_CLOCK_GEN8,		0x0100 },
> > +	{ GLAMO_REG_CLOCK_HOST,		0x000d },
> > +	/*
> > +	 * b7..b4 =3D 0 =3D no wait states on read or write
> > +	 * b0 =3D 1 select PLL2 for Host interface, b1 =3D enable it
> > +	 */
> > +	{ GLAMO_REG_HOSTBUS(1),		0x0e03 /* this is replaced by script parser =
*/ },
> > +	{ GLAMO_REG_HOSTBUS(2),		0x07ff }, /* TODO: Disable all */
> > +	{ GLAMO_REG_HOSTBUS(10),	0x0000 },
> > +	{ GLAMO_REG_HOSTBUS(11),	0x4000 },
> > +	{ GLAMO_REG_HOSTBUS(12),	0xf00e },
> > +
> > +	/* S-Media recommended "set tiling mode to 512 mode for memory access
> > +	 * more efficiency when 640x480" */
> > +	{ GLAMO_REG_MEM_TYPE,		0x0c74 }, /* 8MB, 16 word pg wr+rd */
> > +	{ GLAMO_REG_MEM_GEN,		0xafaf }, /* 63 grants min + max */
> > +
> > +	{ GLAMO_REG_MEM_TIMING1,	0x0108 },
> > +	{ GLAMO_REG_MEM_TIMING2,	0x0010 }, /* Taa =3D 3 MCLK */
> > +	{ GLAMO_REG_MEM_TIMING3,	0x0000 },
> > +	{ GLAMO_REG_MEM_TIMING4,	0x0000 }, /* CE1# delay fall/rise */
> > +	{ GLAMO_REG_MEM_TIMING5,	0x0000 }, /* UB# LB# */
> > +	{ GLAMO_REG_MEM_TIMING6,	0x0000 }, /* OE# */
> > +	{ GLAMO_REG_MEM_TIMING7,	0x0000 }, /* WE# */
> > +	{ GLAMO_REG_MEM_TIMING8,	0x1002 }, /* MCLK delay, was 0x1000 */
> > +	{ GLAMO_REG_MEM_TIMING9,	0x6006 },
> > +	{ GLAMO_REG_MEM_TIMING10,	0x00ff },
> > +	{ GLAMO_REG_MEM_TIMING11,	0x0001 },
> > +	{ GLAMO_REG_MEM_POWER1,		0x0020 },
> > +	{ GLAMO_REG_MEM_POWER2,		0x0000 },
> > +	{ GLAMO_REG_MEM_DRAM1,		0x0000 },
> > +	{ GLAMO_SCRIPT_WAIT,		     1 },
> > +	{ GLAMO_REG_MEM_DRAM1,		0xc100 },
> > +	{ GLAMO_SCRIPT_WAIT,		     1 },
> > +	{ GLAMO_REG_MEM_DRAM1,		0xe100 },
> > +	{ GLAMO_REG_MEM_DRAM2,		0x01d6 },
> > +	{ GLAMO_REG_CLOCK_MEMORY,	0x000b },
> > +};
> Shouldnt those values be set by your platform bootloader ? They're obviou=
sly
> not, but I find it weird.

I'm not sure, I have to check.
There are at least two bootloader for the FreeRunner, and one of them is
meant to do as little as possible.
Furthermore, the code in the default bootloader is mostly based on a
copy of an old version of this driver.


> Please remove all #if 0 code from this driver.

Hm, ok, checking that, but again, it can be of help for future work
(some sort of documentation).

> Cheers,
> Samuel.


--=-N982bTA/nS7oqUVOqUM6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAABAgAGBQJMbpnFAAoJEOY0VNOn/l3WAnYP/3eEWSqzJYNHnpFt0mduj6uO
9C1/ubCzSr3GBaOlBBg/yskbvszvDzjcNKNy1peed6xrn/yYspSAkRTCt8rT2Vnu
99/AcsmxWpE7hXx16LoRQgREcmRObT5sqjU5qp5xm0piAxZ+DOmKHOxlhchIksxg
9gLQZAUPDzQ+X5oklldzIW8h/AwY50x6UzVr21Z2XN8VTE/055gKZOaYdUq5KKzW
wJf98UX+90n2xgK00qGSmHskEdNIro47cwkhUAj7E5iMOPAklLt0VhBbXBIKtBbf
pFXc1R8vQ9U934injHuWGXL7LJNPD1Se3l+HnY7XICIAuUNbLDAdiy0ulrhrELuO
3t//cv4S0ru2udwuBDxtiqEd73d+pROGFGYUlO+A2qF8MQnVGSJdoUBlRR1o0NXB
0PXLaGIAr5yqncU4BthglfKpgz1pNCWm0eXMzL+dFR3YfIUwfdA400sBNEz53xvD
lXrpGkvhIzys6PJhze17Et4zlSW8pNmB+wK89/rpLfjr4v6s26dazH7bfrfTiIoa
LPcasgaCgnhY86g3ahqK4FaMZvjt3zImna2KwBrpucAaBp8G0tCViH+UGwy9dd/2
hUKQJ1xxM8D4MUz+XcH9g1D+12txcHZ9BPkwf3AdLD6xKM8pG9MEArzQU/1XBQ2c
SPFHlMwui4m+iYjYAKIO
=51l0
-----END PGP SIGNATURE-----

--=-N982bTA/nS7oqUVOqUM6--


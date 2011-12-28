Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751046Ab1L1FYm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 00:24:42 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:53950 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab1L1FYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 00:24:40 -0500
Date: Wed, 28 Dec 2011 16:24:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <rmk@arm.linux.org.uk>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: linux-next: manual merge of the driver-core tree with the arm
 tree
Message-Id: <20111228162431.206d16c1671679526958bf7e@canb.auug.org.au>
In-Reply-To: <20111228161231.ff6448eb7f03120bd25b19dd@canb.auug.org.au>
References: <20111228161231.ff6448eb7f03120bd25b19dd@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__28_Dec_2011_16_24_31_+1100_Zp4eXlSNNUT9qI0A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Dec_2011_16_24_31_+1100_Zp4eXlSNNUT9qI0A
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi again,

On Wed, 28 Dec 2011 16:12:31 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the driver-core tree got a conflict in
> arch/arm/mach-s3c64xx/common.c between commit b024043b6d0d ("ARM: 7245/1:
> S3C64XX: introduce arch/arm/mach-s3c64xx/common.[ch]") from the arm tree
> and commit edbaa603eb80 ("driver-core: remove sysdev.h usage") from the
> driver-core tree (where it is called arch/arm/mach-s3c64xx/irq-eint.c).
>=20
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Actually, I the fix was more extensive (see below).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-s3c64xx/common.c
index 8ae5b16,e3e75d1..0000000
--- a/arch/arm/mach-s3c64xx/common.c
+++ b/arch/arm/mach-s3c64xx/common.c
@@@ -15,182 -13,21 +15,183 @@@
   */
 =20
  #include <linux/kernel.h>
 +#include <linux/init.h>
 +#include <linux/module.h>
  #include <linux/interrupt.h>
 +#include <linux/ioport.h>
- #include <linux/sysdev.h>
+ #include <linux/device.h>
 -#include <linux/gpio.h>
 -#include <linux/irq.h>
 +#include <linux/serial_core.h>
 +#include <linux/platform_device.h>
  #include <linux/io.h>
 +#include <linux/dma-mapping.h>
 +#include <linux/irq.h>
 +#include <linux/gpio.h>
 =20
 +#include <asm/mach/arch.h>
 +#include <asm/mach/map.h>
  #include <asm/hardware/vic.h>
 =20
 -#include <plat/regs-irqtype.h>
 +#include <mach/map.h>
 +#include <mach/hardware.h>
  #include <mach/regs-gpio.h>
 -#include <plat/gpio-cfg.h>
 =20
 -#include <mach/map.h>
  #include <plat/cpu.h>
 +#include <plat/clock.h>
 +#include <plat/devs.h>
  #include <plat/pm.h>
 +#include <plat/gpio-cfg.h>
 +#include <plat/irq-uart.h>
 +#include <plat/irq-vic-timer.h>
 +#include <plat/regs-irqtype.h>
 +#include <plat/regs-serial.h>
 +
 +#include "common.h"
 +
 +/* uart registration process */
 +
 +void __init s3c64xx_init_uarts(struct s3c2410_uartcfg *cfg, int no)
 +{
 +	s3c24xx_init_uartdevs("s3c6400-uart", s3c64xx_uart_resources, cfg, no);
 +}
 +
 +/* table of supported CPUs */
 +
 +static const char name_s3c6400[] =3D "S3C6400";
 +static const char name_s3c6410[] =3D "S3C6410";
 +
 +static struct cpu_table cpu_ids[] __initdata =3D {
 +	{
 +		.idcode		=3D S3C6400_CPU_ID,
 +		.idmask		=3D S3C64XX_CPU_MASK,
 +		.map_io		=3D s3c6400_map_io,
 +		.init_clocks	=3D s3c6400_init_clocks,
 +		.init_uarts	=3D s3c64xx_init_uarts,
 +		.init		=3D s3c6400_init,
 +		.name		=3D name_s3c6400,
 +	}, {
 +		.idcode		=3D S3C6410_CPU_ID,
 +		.idmask		=3D S3C64XX_CPU_MASK,
 +		.map_io		=3D s3c6410_map_io,
 +		.init_clocks	=3D s3c6410_init_clocks,
 +		.init_uarts	=3D s3c64xx_init_uarts,
 +		.init		=3D s3c6410_init,
 +		.name		=3D name_s3c6410,
 +	},
 +};
 +
 +/* minimal IO mapping */
 +
 +/* see notes on uart map in arch/arm/mach-s3c64xx/include/mach/debug-macr=
o.S */
 +#define UART_OFFS (S3C_PA_UART & 0xfffff)
 +
 +static struct map_desc s3c_iodesc[] __initdata =3D {
 +	{
 +		.virtual	=3D (unsigned long)S3C_VA_SYS,
 +		.pfn		=3D __phys_to_pfn(S3C64XX_PA_SYSCON),
 +		.length		=3D SZ_4K,
 +		.type		=3D MT_DEVICE,
 +	}, {
 +		.virtual	=3D (unsigned long)S3C_VA_MEM,
 +		.pfn		=3D __phys_to_pfn(S3C64XX_PA_SROM),
 +		.length		=3D SZ_4K,
 +		.type		=3D MT_DEVICE,
 +	}, {
 +		.virtual	=3D (unsigned long)(S3C_VA_UART + UART_OFFS),
 +		.pfn		=3D __phys_to_pfn(S3C_PA_UART),
 +		.length		=3D SZ_4K,
 +		.type		=3D MT_DEVICE,
 +	}, {
 +		.virtual	=3D (unsigned long)VA_VIC0,
 +		.pfn		=3D __phys_to_pfn(S3C64XX_PA_VIC0),
 +		.length		=3D SZ_16K,
 +		.type		=3D MT_DEVICE,
 +	}, {
 +		.virtual	=3D (unsigned long)VA_VIC1,
 +		.pfn		=3D __phys_to_pfn(S3C64XX_PA_VIC1),
 +		.length		=3D SZ_16K,
 +		.type		=3D MT_DEVICE,
 +	}, {
 +		.virtual	=3D (unsigned long)S3C_VA_TIMER,
 +		.pfn		=3D __phys_to_pfn(S3C_PA_TIMER),
 +		.length		=3D SZ_16K,
 +		.type		=3D MT_DEVICE,
 +	}, {
 +		.virtual	=3D (unsigned long)S3C64XX_VA_GPIO,
 +		.pfn		=3D __phys_to_pfn(S3C64XX_PA_GPIO),
 +		.length		=3D SZ_4K,
 +		.type		=3D MT_DEVICE,
 +	}, {
 +		.virtual	=3D (unsigned long)S3C64XX_VA_MODEM,
 +		.pfn		=3D __phys_to_pfn(S3C64XX_PA_MODEM),
 +		.length		=3D SZ_4K,
 +		.type		=3D MT_DEVICE,
 +	}, {
 +		.virtual	=3D (unsigned long)S3C_VA_WATCHDOG,
 +		.pfn		=3D __phys_to_pfn(S3C64XX_PA_WATCHDOG),
 +		.length		=3D SZ_4K,
 +		.type		=3D MT_DEVICE,
 +	}, {
 +		.virtual	=3D (unsigned long)S3C_VA_USB_HSPHY,
 +		.pfn		=3D __phys_to_pfn(S3C64XX_PA_USB_HSPHY),
 +		.length		=3D SZ_1K,
 +		.type		=3D MT_DEVICE,
 +	},
 +};
 +
- struct sysdev_class s3c64xx_sysclass =3D {
- 	.name	=3D "s3c64xx-core",
++struct bus_type s3c64xx_subsys =3D {
++	.name		=3D "s3c64xx-core",
++	.dev_name	=3D "s3c64xx-core",
 +};
 +
- static struct sys_device s3c64xx_sysdev =3D {
- 	.cls	=3D &s3c64xx_sysclass,
++static struct device s3c64xx_dev =3D {
++	.bus	=3D &s3c64xx_subsys,
 +};
 +
 +/* read cpu identification code */
 +
 +void __init s3c64xx_init_io(struct map_desc *mach_desc, int size)
 +{
 +	/* initialise the io descriptors we need for initialisation */
 +	iotable_init(s3c_iodesc, ARRAY_SIZE(s3c_iodesc));
 +	iotable_init(mach_desc, size);
 +	init_consistent_dma_size(SZ_8M);
 +
 +	/* detect cpu id */
 +	s3c64xx_init_cpu();
 +
 +	s3c_init_cpu(samsung_cpu_id, cpu_ids, ARRAY_SIZE(cpu_ids));
 +}
 +
- static __init int s3c64xx_sysdev_init(void)
++static __init int s3c64xx_dev_init(void)
 +{
- 	sysdev_class_register(&s3c64xx_sysclass);
- 	return sysdev_register(&s3c64xx_sysdev);
++	subsys_system_register(&s3c64xx_subsys, NULL);
++	return device(&s3c64xx_dev);
 +}
- core_initcall(s3c64xx_sysdev_init);
++core_initcall(s3c64xx_dev_init);
 +
 +/*
 + * setup the sources the vic should advertise resume
 + * for, even though it is not doing the wake
 + * (set_irq_wake needs to be valid)
 + */
 +#define IRQ_VIC0_RESUME (1 << (IRQ_RTC_TIC - IRQ_VIC0_BASE))
 +#define IRQ_VIC1_RESUME (1 << (IRQ_RTC_ALARM - IRQ_VIC1_BASE) |	\
 +			 1 << (IRQ_PENDN - IRQ_VIC1_BASE) |	\
 +			 1 << (IRQ_HSMMC0 - IRQ_VIC1_BASE) |	\
 +			 1 << (IRQ_HSMMC1 - IRQ_VIC1_BASE) |	\
 +			 1 << (IRQ_HSMMC2 - IRQ_VIC1_BASE))
 +
 +void __init s3c64xx_init_irq(u32 vic0_valid, u32 vic1_valid)
 +{
 +	printk(KERN_DEBUG "%s: initialising interrupts\n", __func__);
 +
 +	/* initialise the pair of VICs */
 +	vic_init(VA_VIC0, IRQ_VIC0_BASE, vic0_valid, IRQ_VIC0_RESUME);
 +	vic_init(VA_VIC1, IRQ_VIC1_BASE, vic1_valid, IRQ_VIC1_RESUME);
 +
 +	/* add the timer sub-irqs */
 +	s3c_init_vic_timer_irq(5, IRQ_TIMER0);
 +}
 =20
  #define eint_offset(irq)	((irq) - IRQ_EINT(0))
  #define eint_irq_to_bit(irq)	((u32)(1 << eint_offset(irq)))

--Signature=_Wed__28_Dec_2011_16_24_31_+1100_Zp4eXlSNNUT9qI0A
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO+qgPAAoJEECxmPOUX5FEay0P/3WOydcsjrm1eVTnXYkheWxM
iCthVPrXnj7AW4GeLL8MDgnxOshSQjuPBnt4KmyIiMPfyb+9st1ZYcVvkb6xG9si
eQr9MEJhZLBuwwBtej7JOIfa2d/9eG2c3SkbixkNsjiQjdQxi3+7b2oERqlWyoep
iNVCWhxVzoAOilogH4W7MUH5UurkRI0o3qhKlCC1p8z/Mk9BWHOPKvS9qhWyhF/9
ymQyJwMv11PUfVIlbmKaq2iioPCZLD2UmOZTttSWqxUm6CduZApgPwnezk9basIn
hv9ydWY7aAE7m8wrrN3QgacaHNEVENuDHlOaRsUrmywm2Aj+l8kPyoiSgMmZalTm
+yh18BO508EV0Yb2L1uHI3YvCI7o/OKlits/GHUQevcJft/E7K0j1Z0+IFGk2JEI
x9LV70XtdqFTVwjiOe+Igz+GBGDGFdTCIZp5YPJOhGcn+X8aJ5Hw6nmitLGIEkj9
A8hU8WZVACMRvu5Gkg4xgMm7CesECTah4csRnAyhkjkDk61oLufkwZkYea7LNWuF
+gtU23cbhyB5lF4p1Bmj/y5oFvfF7SnJYm+3BsJ3tDG8OOzGQOfYrx6uoq+VccbZ
nhujbWgufKa5i8Sq821AnuV7XnPfYy9Ei1tmOM6ALeaKArDDvjWGCg2Tn2iBR3Me
0/GjhfbVDb0XSYb/oeUj
=FzkM
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Dec_2011_16_24_31_+1100_Zp4eXlSNNUT9qI0A--

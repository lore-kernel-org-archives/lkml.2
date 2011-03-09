Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177Ab1CIL5W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 06:57:22 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59718 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871Ab1CIL5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 06:57:20 -0500
Message-ID: <4D776B05.4010506@pengutronix.de>
Date: Wed, 09 Mar 2011 12:56:53 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Subhasish Ghosh <subhasish@mistralsolutions.com>
CC: davinci-linux-open-source@linux.davincidsp.com, sachi@mistralsolutions.com,
        Samuel Ortiz <sameo@linux.intel.com>, nsekhar@ti.com,
        open list <linux-kernel@vger.kernel.org>, m-watkins@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 1/7] mfd: add pruss mfd driver.
References: <1299592667-21367-1-git-send-email-subhasish@mistralsolutions.com> <1299592667-21367-2-git-send-email-subhasish@mistralsolutions.com>
In-Reply-To: <1299592667-21367-2-git-send-email-subhasish@mistralsolutions.com>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7AA372E66890AD387447D8FD"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7AA372E66890AD387447D8FD
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 03/08/2011 02:57 PM, Subhasish Ghosh wrote:
> This patch adds the pruss MFD driver and associated include files.
> For details regarding the PRUSS please refer the folowing link:
> http://processors.wiki.ti.com/index.php/Programmable_Realtime_Unit_Subs=
ystem
>=20
> The rational behind the MFD driver being the fact that multiple devices=
 can
> be implemented on the cores independently. This is determined by the na=
ture
> of the program which is loaded into the PRU's instruction memory.
> A device may be de-initialized and another loaded or two different devi=
ces
> can be run simultaneously on the two cores.
> It's also possible, as in our case, to implement a single device on bot=
h
> the PRU's resulting in improved load sharing.

Make you driver compile with sparse "make C=3D1", you cast way too much
when accessing io mem. Use void __iomem * instead of u32 *.

See more comments inline.

>=20
> Signed-off-by: Subhasish Ghosh <subhasish@mistralsolutions.com>
> ---
>  drivers/mfd/Kconfig                     |   10 +
>  drivers/mfd/Makefile                    |    1 +
>  drivers/mfd/da8xx_pru.c                 |  560 +++++++++++++++++++++++=
++++++++
>  include/linux/mfd/da8xx/da8xx_pru.h     |  135 ++++++++
>  include/linux/mfd/da8xx/da8xx_prucore.h |  129 +++++++
>  5 files changed, 835 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/mfd/da8xx_pru.c
>  create mode 100644 include/linux/mfd/da8xx/da8xx_pru.h
>  create mode 100644 include/linux/mfd/da8xx/da8xx_prucore.h
>=20
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index fd01836..6c437df 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -81,6 +81,16 @@ config MFD_DM355EVM_MSP
>  	  boards.  MSP430 firmware manages resets and power sequencing,
>  	  inputs from buttons and the IR remote, LEDs, an RTC, and more.
> =20
> +config MFD_DA8XX_PRUSS
> +	tristate "Texas Instruments DA8XX PRUSS support"
> +	depends on ARCH_DAVINCI && ARCH_DAVINCI_DA850
> +	select MFD_CORE
> +	help
> +	  This driver provides support api's for the programmable
> +	  realtime unit (PRU) present on TI's da8xx processors. It
> +	  provides basic read, write, config, enable, disable
> +	  routines to facilitate devices emulated on it.
> +
>  config HTC_EGPIO
>  	bool "HTC EGPIO support"
>  	depends on GENERIC_HARDIRQS && GPIOLIB && ARM
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index a54e2c7..670d6b0 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -13,6 +13,7 @@ obj-$(CONFIG_HTC_PASIC3)	+=3D htc-pasic3.o
>  obj-$(CONFIG_HTC_I2CPLD)	+=3D htc-i2cpld.o
> =20
>  obj-$(CONFIG_MFD_DAVINCI_VOICECODEC)	+=3D davinci_voicecodec.o
> +obj-$(CONFIG_MFD_DA8XX_PRUSS)	+=3D da8xx_pru.o
>  obj-$(CONFIG_MFD_DM355EVM_MSP)	+=3D dm355evm_msp.o
> =20
>  obj-$(CONFIG_MFD_STMPE)		+=3D stmpe.o
> diff --git a/drivers/mfd/da8xx_pru.c b/drivers/mfd/da8xx_pru.c
> new file mode 100644
> index 0000000..0fd9bb2
> --- /dev/null
> +++ b/drivers/mfd/da8xx_pru.c
> @@ -0,0 +1,560 @@
> +/*
> + * Copyright (C) 2011 Texas Instruments Incorporated
> + *
> + * This program is free software; you can redistribute it and/or modif=
y it
> + * under the terms of the GNU General Public License as  published by =
the
> + * Free Software Foundation version 2.
> + *
> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any kin=
d,
> + * whether express or implied; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/types.h>
> +#include <linux/module.h>
> +#include <linux/bitops.h>
> +#include <linux/interrupt.h>
> +#include <linux/spinlock.h>
> +#include <linux/errno.h>
> +#include <linux/platform_device.h>
> +#include <linux/clk.h>
> +#include <linux/mfd/da8xx/da8xx_prucore.h>
> +#include <linux/mfd/da8xx/da8xx_pru.h>
> +#include <linux/mfd/core.h>
> +#include <linux/io.h>
> +#include <mach/da8xx.h>
> +
> +struct da8xx_pruss {
> +	struct device *dev;
> +	spinlock_t lock;
> +	struct resource *res;
> +	struct clk *clk;
> +	u32 clk_freq;
> +	void __iomem *ioaddr;
> +};
> +
> +u32 pruss_get_clk_freq(struct device *dev)
> +{
> +	struct da8xx_pruss *pruss =3D dev_get_drvdata(dev->parent);
> +
> +	return pruss->clk_freq;
> +}
> +EXPORT_SYMBOL(pruss_get_clk_freq);
> +
> +s32 pruss_disable(struct device *dev, u8 pruss_num)
> +{
> +	struct da8xx_pruss *pruss =3D dev_get_drvdata(dev->parent);
> +	struct da8xx_prusscore_regs *h_pruss;
> +	struct pruss_map *pruss_mmap =3D (struct pruss_map *)pruss->ioaddr;
> +	u32 temp_reg;
> +	u32 delay_cnt;
> +
> +	if ((pruss_num !=3D DA8XX_PRUCORE_0) && (pruss_num !=3D DA8XX_PRUCORE=
_1))
> +		return -EINVAL;
> +
> +	spin_lock(&pruss->lock);
> +	if (pruss_num =3D=3D DA8XX_PRUCORE_0) {
> +		/* pruss deinit */
> +		__raw_writel(0xFFFFFFFF, (PRUSS_INTC_STATCLRINT0 & 0xFFFF));
> +		/* Disable PRU0  */
> +		h_pruss =3D (struct da8xx_prusscore_regs *)
> +			&pruss_mmap->core[DA8XX_PRUCORE_0];
> +
> +		temp_reg =3D __raw_readl(&h_pruss->CONTROL);
> +		temp_reg =3D (temp_reg &
> +				~DA8XX_PRUCORE_CONTROL_COUNTENABLE_MASK) |
> +				((DA8XX_PRUCORE_CONTROL_COUNTENABLE_DISABLE <<
> +				DA8XX_PRUCORE_CONTROL_COUNTENABLE_SHIFT) &
> +				DA8XX_PRUCORE_CONTROL_COUNTENABLE_MASK);
> +		__raw_writel(temp_reg, &h_pruss->CONTROL);
> +
> +		for (delay_cnt =3D 0x10000; delay_cnt > 0; delay_cnt--) {
> +
> +			temp_reg =3D __raw_readl(&h_pruss->CONTROL);
> +			temp_reg =3D (temp_reg &
> +				~DA8XX_PRUCORE_CONTROL_ENABLE_MASK) |
> +				((DA8XX_PRUCORE_CONTROL_ENABLE_DISABLE <<
> +				DA8XX_PRUCORE_CONTROL_ENABLE_SHIFT) &
> +				DA8XX_PRUCORE_CONTROL_ENABLE_MASK);
> +			__raw_writel(temp_reg, &h_pruss->CONTROL);
> +		}
> +
> +		/* Reset PRU0 */
> +		for (delay_cnt =3D 0x10000; delay_cnt > 0; delay_cnt--)
> +			__raw_writel(DA8XX_PRUCORE_CONTROL_RESETVAL,
> +					&h_pruss->CONTROL);
> +
> +	} else if (pruss_num =3D=3D DA8XX_PRUCORE_1) {
> +		/* pruss deinit */
> +		__raw_writel(0xFFFFFFFF, (PRUSS_INTC_STATCLRINT1 & 0xFFFF));
> +		/* Disable PRU1 */
> +		h_pruss =3D (struct da8xx_prusscore_regs *)
> +			&pruss_mmap->core[DA8XX_PRUCORE_1];
> +		temp_reg =3D __raw_readl(&h_pruss->CONTROL);
> +		temp_reg =3D (temp_reg &
> +				~DA8XX_PRUCORE_CONTROL_COUNTENABLE_MASK) |
> +				((DA8XX_PRUCORE_CONTROL_COUNTENABLE_DISABLE <<
> +				DA8XX_PRUCORE_CONTROL_COUNTENABLE_SHIFT) &
> +				DA8XX_PRUCORE_CONTROL_COUNTENABLE_MASK);
> +		__raw_writel(temp_reg, &h_pruss->CONTROL);
> +
> +		for (delay_cnt =3D 0x10000; delay_cnt > 0; delay_cnt--) {
> +
> +			temp_reg =3D __raw_readl(&h_pruss->CONTROL);
> +			temp_reg =3D (temp_reg &
> +				~DA8XX_PRUCORE_CONTROL_ENABLE_MASK) |
> +				((DA8XX_PRUCORE_CONTROL_ENABLE_DISABLE <<
> +				DA8XX_PRUCORE_CONTROL_ENABLE_SHIFT) &
> +				DA8XX_PRUCORE_CONTROL_ENABLE_MASK);
> +			__raw_writel(temp_reg, &h_pruss->CONTROL);
> +		}
> +
> +		/* Reset PRU1 */
> +		for (delay_cnt =3D 0x10000; delay_cnt > 0; delay_cnt--)
> +			__raw_writel(DA8XX_PRUCORE_CONTROL_RESETVAL,
> +							&h_pruss->CONTROL);
> +	}

unneeded code duplication

> +	spin_unlock(&pruss->lock);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(pruss_disable);
> +
> +s32 pruss_enable(struct device *dev, u8 pruss_num)
> +{
> +	struct da8xx_pruss *pruss =3D dev_get_drvdata(dev->parent);
> +	struct da8xx_prusscore_regs *h_pruss;
> +	struct pruss_map *pruss_mmap =3D (struct pruss_map *)pruss->ioaddr;
> +
> +	if ((pruss_num !=3D DA8XX_PRUCORE_0) && (pruss_num !=3D DA8XX_PRUCORE=
_1))
> +		return -EINVAL;
> +
> +	spin_lock(&pruss->lock);

just use pruss_num in &pruss_mmap->core[DA8XX_PRUCORE_0], then remove
the "if..else if"

> +	if (pruss_num =3D=3D DA8XX_PRUCORE_0) {
> +		/* Reset PRU0 */
> +		h_pruss =3D (struct da8xx_prusscore_regs *)
> +			&pruss_mmap->core[DA8XX_PRUCORE_0];
> +		__raw_writel(DA8XX_PRUCORE_CONTROL_RESETVAL,
> +			&h_pruss->CONTROL);
> +	} else if (pruss_num =3D=3D DA8XX_PRUCORE_1) {
> +		/* Reset PRU1  */
> +		h_pruss =3D (struct da8xx_prusscore_regs *)
> +			&pruss_mmap->core[DA8XX_PRUCORE_1];
> +		__raw_writel(DA8XX_PRUCORE_CONTROL_RESETVAL,
> +			&h_pruss->CONTROL);
> +	}
> +	spin_unlock(&pruss->lock);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(pruss_enable);
> +
> +/* Load the specified PRU with code */
> +s32 pruss_load(struct device *dev, u8 pruss_num,
> +			u32 *pruss_code, u32 code_size_in_words)
> +{
> +	struct da8xx_pruss *pruss =3D dev_get_drvdata(dev->parent);
> +	struct pruss_map *pruss_mmap =3D (struct pruss_map *)pruss->ioaddr;
> +	u32 *pruss_iram;
> +	u32 i;
> +
> +	if (pruss_num =3D=3D DA8XX_PRUCORE_0)
> +		pruss_iram =3D (u32 *)&pruss_mmap->iram0;
> +	else if (pruss_num =3D=3D DA8XX_PRUCORE_1)
> +		pruss_iram =3D (u32 *)&pruss_mmap->iram1;

u32 * looks fishy, should be probavly a void __iomem
also make pruss_mmap->iram0,1 an array

> +	else
> +		return -EINVAL;
> +
> +	pruss_enable(dev, pruss_num);
> +
> +	spin_lock(&pruss->lock);
> +	/* Copy dMAX code to its instruction RAM  */
> +	for (i =3D 0; i < code_size_in_words; i++)
> +		__raw_writel(pruss_code[i], (pruss_iram + i));
> +
> +	spin_unlock(&pruss->lock);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(pruss_load);
> +
> +s32 pruss_run(struct device *dev, u8 pruss_num)
> +{
> +	struct da8xx_pruss *pruss =3D dev_get_drvdata(dev->parent);
> +	struct da8xx_prusscore_regs *h_pruss;
> +	struct pruss_map *pruss_mmap =3D (struct pruss_map *)pruss->ioaddr;
> +	u32 temp_reg;
> +
> +	if (pruss_num =3D=3D DA8XX_PRUCORE_0) {
> +		/* DA8XX_PRUCORE_0_REGS; */
> +		h_pruss =3D (struct da8xx_prusscore_regs *)
> +			&pruss_mmap->core[DA8XX_PRUCORE_0];
> +	} else if (pruss_num =3D=3D DA8XX_PRUCORE_1) {
> +		/* DA8XX_PRUCORE_1_REGS; */
> +		h_pruss =3D (struct da8xx_prusscore_regs *)
> +			&pruss_mmap->core[DA8XX_PRUCORE_1];

if you first check if pruss_num is correct, then you can just use
pruss_num in "pruss_mmap->core[DA8XX_PRUCORE_1]"

> +	} else
> +		return -EINVAL;
> +
> +	/* Enable dMAX, let it execute the code we just copied */

is it possible to use the _rmw function you defined later?

> +	spin_lock(&pruss->lock);
> +	temp_reg =3D __raw_readl(&h_pruss->CONTROL);
> +	temp_reg =3D (temp_reg &
> +			~DA8XX_PRUCORE_CONTROL_COUNTENABLE_MASK) |
> +			((DA8XX_PRUCORE_CONTROL_COUNTENABLE_ENABLE <<
> +			DA8XX_PRUCORE_CONTROL_COUNTENABLE_SHIFT) &
> +			DA8XX_PRUCORE_CONTROL_COUNTENABLE_MASK);
> +	__raw_writel(temp_reg, &h_pruss->CONTROL);
> +
> +	temp_reg =3D __raw_readl(&h_pruss->CONTROL);
> +	temp_reg =3D (temp_reg &
> +			~DA8XX_PRUCORE_CONTROL_ENABLE_MASK) |
> +			((DA8XX_PRUCORE_CONTROL_ENABLE_ENABLE <<
> +			DA8XX_PRUCORE_CONTROL_ENABLE_SHIFT) &
> +			DA8XX_PRUCORE_CONTROL_ENABLE_MASK);
> +	__raw_writel(temp_reg, &h_pruss->CONTROL);
> +	 spin_unlock(&pruss->lock);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(pruss_run);
> +
> +s32 pruss_wait_for_halt(struct device *dev, u8 pruss_num, u32 timeout)=

> +{
> +	struct da8xx_pruss *pruss =3D dev_get_drvdata(dev->parent);
> +	struct da8xx_prusscore_regs *h_pruss;
> +	struct pruss_map *pruss_mmap =3D (struct pruss_map *)pruss->ioaddr;
> +	u32 temp_reg;
> +	u32 cnt =3D timeout;
> +
> +	if (pruss_num =3D=3D DA8XX_PRUCORE_0) {
> +		/* DA8XX_PRUCORE_0_REGS; */
> +		h_pruss =3D (struct da8xx_prusscore_regs *)
> +			&pruss_mmap->core[DA8XX_PRUCORE_0];
> +	} else if (pruss_num =3D=3D DA8XX_PRUCORE_1) {
> +		/* DA8XX_PRUCORE_1_REGS; */
> +		h_pruss =3D (struct da8xx_prusscore_regs *)
> +			&pruss_mmap->core[DA8XX_PRUCORE_1];

dito

> +	} else
> +		return -EINVAL;
> +
> +	while (cnt--) {
> +		temp_reg =3D __raw_readl(&h_pruss->CONTROL);
> +		if (((temp_reg & DA8XX_PRUCORE_CONTROL_RUNSTATE_MASK) >>
> +				DA8XX_PRUCORE_CONTROL_RUNSTATE_SHIFT) =3D=3D
> +					DA8XX_PRUCORE_CONTROL_RUNSTATE_HALT)
> +			break;
> +	}
> +	if (cnt =3D=3D 0)
> +		return -EBUSY;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(pruss_wait_for_halt);
> +
> +s32 pruss_writeb(struct device *dev, u32 offset,
> +		u8 *pdatatowrite, u16 bytestowrite)
> +{
> +	struct da8xx_pruss *pruss =3D dev_get_drvdata(dev->parent);
> +	u8 *paddresstowrite;
> +	u16 loop;
> +	offset =3D (u32)pruss->ioaddr + offset;
> +	paddresstowrite =3D (u8 *) (offset);

Why all this casing? Checck your driver with sparse, please compile your
driver with "make C=3D1".

> +
> +	for (loop =3D 0; loop < bytestowrite; loop++)
> +		__raw_writeb(*pdatatowrite++, paddresstowrite++);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(pruss_writeb);
> +
> +s32 pruss_rmwb(struct device *dev, u32 offset, u8 mask, u8 val)
> +{
> +	struct da8xx_pruss *pruss =3D dev_get_drvdata(dev->parent);
> +	u32 *paddress;
> +	u32 preg_data;
> +
> +	paddress =3D (u32 *)((u32)pruss->ioaddr + offset);
same here
> +
> +	spin_lock(&pruss->lock);
> +	preg_data =3D __raw_readb(paddress);
> +	preg_data &=3D ~mask;
> +	preg_data |=3D val;
> +	__raw_writeb(preg_data, paddress);
> +	spin_unlock(&pruss->lock);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(pruss_rmwb);
> +
> +s32 pruss_readb(struct device *dev, u32 offset,
> +		u8 *pdatatoread, u16 bytestoread)
> +{
> +	struct da8xx_pruss *pruss =3D dev_get_drvdata(dev->parent);
> +	u8 *paddresstoread;
> +	u16 loop;
> +	offset =3D (u32)pruss->ioaddr + offset;
> +	paddresstoread =3D (u8 *) (offset);
same here
> +
> +	for (loop =3D 0; loop < bytestoread; loop++)
> +		*pdatatoread++ =3D __raw_readb(paddresstoread++);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(pruss_readb);
> +
> +s32 pruss_writel(struct device *dev, u32 offset,
> +		u32 *pdatatowrite, s16 wordstowrite)
> +{
> +	struct da8xx_pruss *pruss =3D dev_get_drvdata(dev->parent);
> +	u32 *paddresstowrite;
> +	s16 loop;
> +
> +	offset =3D (u32)pruss->ioaddr + offset;
> +	paddresstowrite =3D (u32 *)(offset);
dito
> +
> +	for (loop =3D 0; loop < wordstowrite; loop++)
> +		__raw_writel(*pdatatowrite++, paddresstowrite++);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(pruss_writel);
> +
> +s32 pruss_rmwl(struct device *dev, u32 offset, u32 mask, u32 val)
> +{
> +	struct da8xx_pruss *pruss =3D dev_get_drvdata(dev->parent);
> +	u32 *paddress;
> +	u32 preg_data;
> +
> +	paddress =3D (u32 *)((u32)pruss->ioaddr + offset);
dito
> +
> +	spin_lock(&pruss->lock);
> +	preg_data =3D __raw_readl(paddress);
> +	preg_data &=3D ~mask;
> +	preg_data |=3D val;
> +	__raw_writel(preg_data, paddress);
> +	spin_unlock(&pruss->lock);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(pruss_rmwl);
> +
> +s32 pruss_readl(struct device *dev, u32 offset,
> +		u32 *pdatatoread, s16 wordstoread)
> +{
> +	struct da8xx_pruss *pruss =3D dev_get_drvdata(dev->parent);
> +	u32 *paddresstoread;
> +	s16 loop;
> +
> +	offset =3D (u32)pruss->ioaddr + offset;
> +	paddresstoread =3D (u32 *)(offset);

dito

> +
> +	for (loop =3D 0; loop < wordstoread; loop++)
> +		*pdatatoread++ =3D __raw_readl(paddresstoread++);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(pruss_readl);
> +
> +s32 pruss_writew(struct device *dev, u32 offset,
> +		u16 *pdatatowrite, s16 wordstowrite)
> +{
> +	struct da8xx_pruss *pruss =3D dev_get_drvdata(dev->parent);
> +	u32 *paddresstowrite;
> +	s16 loop;
> +
> +	offset =3D (u32)pruss->ioaddr + offset;
> +	paddresstowrite =3D (u32 *)(offset);

dito

> +
> +	for (loop =3D 0; loop < wordstowrite; loop++)
> +		__raw_writew(*(pdatatowrite++), (paddresstowrite++));
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(pruss_writew);
> +
> +s32 pruss_rmww(struct device *dev, u32 offset, u16 mask, u16 val)
> +{
> +	struct da8xx_pruss *pruss =3D dev_get_drvdata(dev->parent);
> +	u32 *paddress;
> +	u32 preg_data;
> +
> +	paddress =3D (u32 *)((u32)pruss->ioaddr + offset);

dito

> +
> +	spin_lock(&pruss->lock);
> +	preg_data =3D __raw_readw(paddress);
> +	preg_data &=3D ~mask;
> +	preg_data |=3D val;
> +	__raw_writew(preg_data, paddress);
> +	spin_unlock(&pruss->lock);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(pruss_rmww);
> +
> +s32 pruss_readw(struct device *dev, u32 offset,
> +			u16 *pdatatoread, s16 wordstoread)
> +{
> +	struct da8xx_pruss *pruss =3D dev_get_drvdata(dev->parent);
> +	u32 *paddresstoread;
> +	s16 loop;
> +
> +	offset =3D (u32)pruss->ioaddr + offset;
> +	paddresstoread =3D (u32 *)(offset);
> +

dito

> +	for (loop =3D 0; loop < wordstoread; loop++)
use "i" as loop variable
> +		*pdatatoread++ =3D __raw_readw(paddresstoread++);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(pruss_readw);
> +
> +s32 pruss_idx_writel(struct device *dev, u32 offset, u32 value)
> +{
> +	struct da8xx_pruss *pruss =3D dev_get_drvdata(dev->parent);
> +	u32 *paddresstowrite;
> +
> +	paddresstowrite =3D (u32 *)(pruss->ioaddr + offset);

dito
> +	__raw_writel(value, paddresstowrite);



> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(pruss_idx_writel);
> +
> +static int pruss_mfd_add_devices(struct platform_device *pdev)
> +{
> +	struct da8xx_pruss_devices *dev_data =3D pdev->dev.platform_data;
> +	struct device *dev =3D &pdev->dev;
> +	struct mfd_cell cell;
> +	u32 err, count;
> +
> +	for (count =3D 0; dev_data[count].dev_name !=3D NULL; count++) {

nitpick:
we usually use "i" as counter variable

> +		memset(&cell, 0, sizeof(struct mfd_cell));
> +		cell.id			=3D count;
> +		cell.name		=3D dev_data[count].dev_name;
> +		cell.platform_data	=3D dev_data[count].pdata;
> +		cell.data_size		=3D dev_data[count].pdata_size;
> +		cell.resources		=3D dev_data[count].resources;
> +		cell.num_resources	=3D dev_data[count].num_resources;
> +
> +		err =3D mfd_add_devices(dev, 0, &cell, 1, NULL, 0);
> +		if (err) {
> +			dev_err(dev, "cannot add mfd cells\n");
> +			return err;

you forget to clean up already registered mfd devices. I suggest to
rearrange your code so that you can use mfd_add_devices() to register
all of your devices at once.

> +		}
> +		dev_info(dev, "mfd: added %s device\n",
> +				dev_data[count].dev_name);
> +	}
> +
> +	return err;
> +}
> +
> +static int __devinit da8xx_pruss_probe(struct platform_device *pdev)
> +{
> +	struct da8xx_pruss *pruss_dev =3D NULL;
> +	u32 err;
> +
> +	pruss_dev =3D kzalloc(sizeof(struct da8xx_pruss), GFP_KERNEL);
> +	if (!pruss_dev)
> +		return -ENOMEM;
> +
> +	pruss_dev->res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!pruss_dev->res) {
> +		dev_err(&pdev->dev,
> +		"unable to get pruss memory resources!\n");
> +		err =3D -ENODEV;
> +		goto probe_exit_kfree;
> +	}
> +
> +	if (!request_mem_region(pruss_dev->res->start,
> +		resource_size(pruss_dev->res), dev_name(&pdev->dev))) {
> +		dev_err(&pdev->dev, "pruss memory region already claimed!\n");
> +		err =3D -EBUSY;
> +		goto probe_exit_kfree;
> +	}
> +
> +	pruss_dev->ioaddr =3D ioremap(pruss_dev->res->start,
> +	resource_size(pruss_dev->res));
> +	if (!pruss_dev->ioaddr) {
> +		dev_err(&pdev->dev, "ioremap failed\n");
> +		err =3D -ENOMEM;
> +		goto probe_exit_free_region;
> +	}
> +
> +	pruss_dev->clk =3D clk_get(NULL, "pruss");
> +	if (IS_ERR(pruss_dev->clk)) {
> +		dev_err(&pdev->dev, "no clock available: pruss\n");
> +		err =3D -ENODEV;
> +		pruss_dev->clk =3D NULL;
> +		goto probe_exit_iounmap;c
> +	}
> +	spin_lock_init(&pruss_dev->lock);
> +
> +	clk_enable(pruss_dev->clk);
> +	pruss_dev->clk_freq =3D clk_get_rate(pruss_dev->clk);

pruss_dev->clk_freq in an u32, but clk_get_rate returns an unsigned long

> +
> +	err =3D pruss_mfd_add_devices(pdev);
> +	if (err)
> +		goto probe_exit_clock;
> +
> +	platform_set_drvdata(pdev, pruss_dev);
> +	pruss_dev->dev =3D &pdev->dev;
> +	return 0;
> +
> +probe_exit_clock:
> +	clk_put(pruss_dev->clk);
> +	clk_disable(pruss_dev->clk);
> +probe_exit_iounmap:
> +	iounmap(pruss_dev->ioaddr);
> +probe_exit_free_region:
> +	release_mem_region(pruss_dev->res->start,
> +			resource_size(pruss_dev->res));
> +probe_exit_kfree:
> +	kfree(pruss_dev);
> +	return err;
> +}
> +
> +static int __devexit da8xx_pruss_remove(struct platform_device *pdev)
> +{
> +	struct device *dev =3D &pdev->dev;
> +	struct da8xx_pruss *pruss =3D dev_get_drvdata(dev);
> +
> +	mfd_remove_devices(dev);
> +	pruss_disable(dev, DA8XX_PRUCORE_0);
> +	pruss_disable(dev, DA8XX_PRUCORE_1);
> +	clk_disable(pruss->clk);
> +	clk_put(pruss->clk);
> +	iounmap(pruss->ioaddr);
> +	release_mem_region(pruss->res->start, resource_size(pruss->res));
> +	kfree(pruss);
> +	dev_set_drvdata(dev, NULL);
> +	return 0;
> +}
> +
> +static struct platform_driver da8xx_pruss_driver =3D {
> +	.probe	=3D da8xx_pruss_probe,
> +	.remove	=3D __devexit_p(da8xx_pruss_remove),
> +	.driver	=3D {
> +		.name	=3D "pruss_mfd",
> +		.owner	=3D THIS_MODULE,
> +	}
> +};
> +
> +static int __init da8xx_pruss_init(void)
> +{
> +	return platform_driver_register(&da8xx_pruss_driver);
> +}
> +module_init(da8xx_pruss_init);
> +
> +static void __exit da8xx_pruss_exit(void)
> +{
> +	platform_driver_unregister(&da8xx_pruss_driver);
> +}
> +module_exit(da8xx_pruss_exit);
> +
> +MODULE_DESCRIPTION("Programmable Realtime Unit (PRU) Driver");
> +MODULE_AUTHOR("Subhasish Ghosh");
> +MODULE_LICENSE("GPL");
> diff --git a/include/linux/mfd/da8xx/da8xx_pru.h b/include/linux/mfd/da=
8xx/da8xx_pru.h
> new file mode 100644
> index 0000000..ba65ec0
> --- /dev/null
> +++ b/include/linux/mfd/da8xx/da8xx_pru.h
> @@ -0,0 +1,135 @@
> +/*
> + * Copyright (C) 2010 Texas Instruments Incorporated
> + * Author: Jitendra Kumar <jitendra@mistralsolutions.com>
> + *
> + * This program is free software; you can redistribute it and/or modif=
y it
> + * under the terms of the GNU General Public License as  published by =
the
> + * Free Software Foundation version 2.
> + *
> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any kin=
d,
> + * whether express or implied; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + */
> +
> +#ifndef _PRUSS_H_
> +#define _PRUSS_H_
> +
> +#include <linux/types.h>
> +#include <linux/platform_device.h>
> +#include "da8xx_prucore.h"
> +
> +#define PRUSS_NUM0			DA8XX_PRUCORE_0
> +#define PRUSS_NUM1			DA8XX_PRUCORE_1
> +
> +#define PRUSS_PRU0_BASE_ADDRESS		0
> +#define PRUSS_INTC_BASE_ADDRESS		(PRUSS_PRU0_BASE_ADDRESS + 0x4000)
> +#define PRUSS_INTC_GLBLEN		(PRUSS_INTC_BASE_ADDRESS + 0x10)
> +#define PRUSS_INTC_GLBLNSTLVL		(PRUSS_INTC_BASE_ADDRESS + 0x1C)
> +#define PRUSS_INTC_STATIDXSET		(PRUSS_INTC_BASE_ADDRESS + 0x20)
> +#define PRUSS_INTC_STATIDXCLR		(PRUSS_INTC_BASE_ADDRESS + 0x24)
> +#define PRUSS_INTC_ENIDXSET		(PRUSS_INTC_BASE_ADDRESS + 0x28)
> +#define PRUSS_INTC_ENIDXCLR		(PRUSS_INTC_BASE_ADDRESS + 0x2C)
> +#define PRUSS_INTC_HSTINTENIDXSET	(PRUSS_INTC_BASE_ADDRESS + 0x34)
> +#define PRUSS_INTC_HSTINTENIDXCLR	(PRUSS_INTC_BASE_ADDRESS + 0x38)
> +#define PRUSS_INTC_GLBLPRIIDX		(PRUSS_INTC_BASE_ADDRESS + 0x80)
> +#define PRUSS_INTC_STATSETINT0		(PRUSS_INTC_BASE_ADDRESS + 0x200)
> +#define PRUSS_INTC_STATSETINT1		(PRUSS_INTC_BASE_ADDRESS + 0x204)
> +#define PRUSS_INTC_STATCLRINT0		(PRUSS_INTC_BASE_ADDRESS + 0x280)
> +#define PRUSS_INTC_STATCLRINT1		(PRUSS_INTC_BASE_ADDRESS + 0x284)
> +#define PRUSS_INTC_ENABLESET0		(PRUSS_INTC_BASE_ADDRESS + 0x300)
> +#define PRUSS_INTC_ENABLESET1		(PRUSS_INTC_BASE_ADDRESS + 0x304)
> +#define PRUSS_INTC_ENABLECLR0		(PRUSS_INTC_BASE_ADDRESS + 0x380)
> +#define PRUSS_INTC_ENABLECLR1		(PRUSS_INTC_BASE_ADDRESS + 0x384)
> +#define PRUSS_INTC_CHANMAP0		(PRUSS_INTC_BASE_ADDRESS + 0x400)
> +#define PRUSS_INTC_CHANMAP1		(PRUSS_INTC_BASE_ADDRESS + 0x404)
> +#define PRUSS_INTC_CHANMAP2		(PRUSS_INTC_BASE_ADDRESS + 0x408)
> +#define PRUSS_INTC_CHANMAP3		(PRUSS_INTC_BASE_ADDRESS + 0x40C)
> +#define PRUSS_INTC_CHANMAP4		(PRUSS_INTC_BASE_ADDRESS + 0x410)
> +#define PRUSS_INTC_CHANMAP5		(PRUSS_INTC_BASE_ADDRESS + 0x414)
> +#define PRUSS_INTC_CHANMAP6		(PRUSS_INTC_BASE_ADDRESS + 0x418)
> +#define PRUSS_INTC_CHANMAP7		(PRUSS_INTC_BASE_ADDRESS + 0x41C)
> +#define PRUSS_INTC_CHANMAP8		(PRUSS_INTC_BASE_ADDRESS + 0x420)
> +#define PRUSS_INTC_CHANMAP9		(PRUSS_INTC_BASE_ADDRESS + 0x424)
> +#define PRUSS_INTC_CHANMAP10		(PRUSS_INTC_BASE_ADDRESS + 0x428)
> +#define PRUSS_INTC_CHANMAP11		(PRUSS_INTC_BASE_ADDRESS + 0x42C)
> +#define PRUSS_INTC_CHANMAP12		(PRUSS_INTC_BASE_ADDRESS + 0x430)
> +#define PRUSS_INTC_CHANMAP13		(PRUSS_INTC_BASE_ADDRESS + 0x434)
> +#define PRUSS_INTC_CHANMAP14		(PRUSS_INTC_BASE_ADDRESS + 0x438)
> +#define PRUSS_INTC_CHANMAP15		(PRUSS_INTC_BASE_ADDRESS + 0x43C)
> +#define PRUSS_INTC_HOSTMAP0		(PRUSS_INTC_BASE_ADDRESS + 0x800)
> +#define PRUSS_INTC_HOSTMAP1		(PRUSS_INTC_BASE_ADDRESS + 0x804)
> +#define PRUSS_INTC_HOSTMAP2		(PRUSS_INTC_BASE_ADDRESS + 0x808)
> +#define PRUSS_INTC_POLARITY0		(PRUSS_INTC_BASE_ADDRESS + 0xD00)
> +#define PRUSS_INTC_POLARITY1		(PRUSS_INTC_BASE_ADDRESS + 0xD04)
> +#define PRUSS_INTC_TYPE0		(PRUSS_INTC_BASE_ADDRESS + 0xD80)
> +#define PRUSS_INTC_TYPE1		(PRUSS_INTC_BASE_ADDRESS + 0xD84)
> +#define PRUSS_INTC_HOSTINTEN		(PRUSS_INTC_BASE_ADDRESS + 0x1500)
> +#define PRUSS_INTC_HOSTINTLVL_MAX	9
> +
> +#define PRU_INTC_HOSTMAP0_CHAN			(0x03020100)
> +#define PRU_INTC_HOSTMAP1_CHAN			(0x07060504)
> +#define PRU_INTC_HOSTMAP2_CHAN			(0x00000908)
> +
> +#define PRU_INTC_CHANMAP7_SYS_EVT31		(0x00000000)
> +#define PRU_INTC_CHANMAP8_FULL			(0x02020100)
> +#define PRU_INTC_CHANMAP9_FULL			(0x04040303)
> +#define PRU_INTC_CHANMAP10_FULL			(0x06060505)
> +#define PRU_INTC_CHANMAP11_FULL			(0x08080707)
> +#define PRU_INTC_CHANMAP12_FULL			(0x00010909)
> +#define PRU_INTC_CHANMAP8_HALF			(0x03020100)
> +#define PRU_INTC_CHANMAP9_HALF			(0x07060504)
> +#define PRU_INTC_CHANMAP10_HALF			(0x03020908)
> +#define PRU_INTC_CHANMAP11_HALF			(0x07060504)
> +#define PRU_INTC_CHANMAP12_HALF			(0x00010908)
> +
> +#define PRU_INTC_REGMAP_MASK			(0xFFFFFFFF)
> +
> +struct da8xx_pruss_devices {
> +	const char *dev_name;
> +	void *pdata;
> +	size_t pdata_size;
> +	int (*setup)(void);
> +	u32 num_resources;
> +	struct resource *resources;
> +};
> +
> +u32 pruss_get_(struct device *dev);
> +
> +s32 pruss_enable(struct device *dev, u8 pruss_num);
> +
> +s32 pruss_load(struct device *dev, u8 pruss_num,
> +	u32 *pruss_code, u32 code_size_in_words);
> +
> +s32 pruss_run(struct device *dev, u8 pruss_num);
> +
> +s32 pruss_wait_for_halt(struct device *dev, u8 pruss_num, u32 timeout)=
;
> +
> +s32 pruss_disable(struct device *dev, u8 pruss_num);
> +
> +s32 pruss_writeb(struct device *dev, u32 offset,
> +		u8 *pdatatowrite, u16 wordstowrite);
> +
> +s32 pruss_rmwb(struct device *dev, u32 offset, u8 mask, u8 val);
> +
> +s32 pruss_readb(struct device *dev, u32 offset,
> +		u8 *pdatatoread, u16 wordstoread);
> +
> +s32 pruss_readl(struct device *dev, u32 offset,
> +		u32 *pdatatoread, s16 wordstoread);
> +
> +s32 pruss_writel(struct device *dev, u32 offset,
> +		u32 *pdatatoread, s16 wordstoread);
> +
> +s32 pruss_rmwl(struct device *dev, u32 offset, u32 mask, u32 val);
> +
> +s32 pruss_idx_writel(struct device *dev, u32 offset, u32 value);
> +
> +s32 pruss_writew(struct device *dev, u32 offset,
> +		u16 *datatowrite, s16 wordstowrite);
> +
> +s32 pruss_rmww(struct device *dev, u32 offset, u16 mask, u16 val);
> +
> +s32 pruss_readw(struct device *dev, u32 offset,
> +		u16 *pdatatoread, s16 wordstoread);
> +#endif	/* End _PRUSS_H_ */
> diff --git a/include/linux/mfd/da8xx/da8xx_prucore.h b/include/linux/mf=
d/da8xx/da8xx_prucore.h
> new file mode 100644
> index 0000000..913d56f
> --- /dev/null
> +++ b/include/linux/mfd/da8xx/da8xx_prucore.h
> @@ -0,0 +1,129 @@
> +/*
> + * Copyright (C) 2010 Texas Instruments Incorporated
> + * Author: Jitendra Kumar <jitendra@mistralsolutions.com>
> + *
> + * This program is free software; you can redistribute it and/or modif=
y it
> + * under the terms of the GNU General Public License as  published by =
the
> + * Free Software Foundation version 2.
> + *
> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any kin=
d,
> + * whether express or implied; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + */
> +
> +#ifndef _DA8XX_PRUCORE_H_
> +#define _DA8XX_PRUCORE_H_
> +
> +#include <linux/types.h>
> +
> +#define DA8XX_PRUCORE_0		(0)
> +#define DA8XX_PRUCORE_1		(1)
> +
> +#define DA8XX_PRUCORE_CONTROL_PCRESETVAL_MASK			(0xFFFF0000u)
> +#define DA8XX_PRUCORE_CONTROL_PCRESETVAL_SHIFT			(0x00000010u)
> +#define DA8XX_PRUCORE_CONTROL_PCRESETVAL_RESETVAL		(0x00000000u)
> +#define DA8XX_PRUCORE_CONTROL_RUNSTATE_MASK			(0x00008000u)
> +#define DA8XX_PRUCORE_CONTROL_RUNSTATE_SHIFT			(0x0000000Fu)
> +#define DA8XX_PRUCORE_CONTROL_RUNSTATE_RESETVAL			(0x00000000u)
> +#define DA8XX_PRUCORE_CONTROL_RUNSTATE_HALT			(0x00000000u)
> +#define DA8XX_PRUCORE_CONTROL_RUNSTATE_RUN			(0x00000001u)
> +#define DA8XX_PRUCORE_CONTROL_SINGLESTEP_MASK			(0x00000100u)
> +#define DA8XX_PRUCORE_CONTROL_SINGLESTEP_SHIFT			(0x00000008u)
> +#define DA8XX_PRUCORE_CONTROL_SINGLESTEP_RESETVAL		(0x00000000u)
> +#define DA8XX_PRUCORE_CONTROL_SINGLESTEP_FREERUN		(0x00000000u)
> +#define DA8XX_PRUCORE_CONTROL_SINGLESTEP_SINGLE			(0x00000001u)
> +#define DA8XX_PRUCORE_CONTROL_COUNTENABLE_MASK			(0x00000008u)
> +#define DA8XX_PRUCORE_CONTROL_COUNTENABLE_SHIFT			(0x00000003u)
> +#define DA8XX_PRUCORE_CONTROL_COUNTENABLE_RESETVAL		(0x00000000u)
> +#define DA8XX_PRUCORE_CONTROL_COUNTENABLE_DISABLE		(0x00000000u)
> +#define DA8XX_PRUCORE_CONTROL_COUNTENABLE_ENABLE		(0x00000001u)
> +#define DA8XX_PRUCORE_CONTROL_SLEEPING_MASK			(0x00000004u)
> +#define DA8XX_PRUCORE_CONTROL_SLEEPING_SHIFT			(0x00000002u)
> +#define DA8XX_PRUCORE_CONTROL_SLEEPING_RESETVAL			(0x00000000u)
> +#define DA8XX_PRUCORE_CONTROL_SLEEPING_NOTASLEEP		(0x00000000u)
> +#define DA8XX_PRUCORE_CONTROL_SLEEPING_ASLEEP			(0x00000001u)
> +#define DA8XX_PRUCORE_CONTROL_ENABLE_MASK			(0x00000002u)
> +#define DA8XX_PRUCORE_CONTROL_ENABLE_SHIFT			(0x00000001u)
> +#define DA8XX_PRUCORE_CONTROL_ENABLE_RESETVAL			(0x00000000u)
> +#define DA8XX_PRUCORE_CONTROL_ENABLE_DISABLE			(0x00000000u)
> +#define DA8XX_PRUCORE_CONTROL_ENABLE_ENABLE			(0x00000001u)
> +#define DA8XX_PRUCORE_CONTROL_SOFTRESET_MASK			(0x00000001u)
> +#define DA8XX_PRUCORE_CONTROL_SOFTRESET_SHIFT			(0x00000000u)
> +#define DA8XX_PRUCORE_CONTROL_SOFTRESET_RESETVAL		(0x00000000u)
> +#define DA8XX_PRUCORE_CONTROL_SOFTRESET_RESET			(0x00000000u)
> +#define DA8XX_PRUCORE_CONTROL_SOFTRESET_OUT_OF_RESET		(0x00000001u)
> +#define DA8XX_PRUCORE_CONTROL_RESETVAL				(0x00000000u)
> +
> +struct da8xx_prusscore_regs {
> +	u32 CONTROL;
> +	u32 STATUS;
> +	u32 WAKEUP;
> +	u32 CYCLECNT;
> +	u32 STALLCNT;
> +	u8  RSVD0[12];
> +	u32 CONTABBLKIDX0;
> +	u32 CONTABBLKIDX1;
> +	u32 CONTABPROPTR0;
> +	u32 CONTABPROPTR1;
> +	u8  RSVD1[976];
> +	u32 INTGPR[32];
> +	u32 INTCTER[32];
> +	u8  RSVD2[768];
> +};

struct members are usually lowercase

> +
> +struct pruss_intc_regs {
> +	u32 REVID;
> +	u32 CONTROL;
> +	u8 RES1[8];
> +	u32 GLBLEN;
> +	u8 RES2[8];
> +	u32 GLBLNSTLVL;
> +	u32 STATIDXSET;
> +	u32 STATIDXCLR;
> +	u32 ENIDXSET;
> +	u32 ENIDXCLR;
> +	u8 RES3[4];
> +	u32 HOSTINTENIDXSET;
> +	u32 HOSTINTENIDXCLR;
> +	u8 RES4[68];
> +	u32 GLBLPRIIDX;
> +	u8 RES5[380];
> +	u32 STATSETINT[2];
> +	u8 RES6[120];
> +	u32 STATCLRINT[2];
> +	u8 RES7[120];
> +	u32 ENABLESET[2];
> +	u8 RES8[120];
> +	u32 ENABLECLR[2];
> +	u8 RES9[120];
> +	u32 CHANMAP[16];
> +	u8 RES10[960];
> +	u32 HOSTMAP[2];
> +	u8 RES11[248];
> +	u32 HOSTINTPRIIDX[10];
> +	u8 RES12[984];
> +	u32 POLARITY[2];
> +	u8 RES13[120];
> +	u32 TYPE[2];
> +	u8 RES14[888];
> +	u32 HOSTINTNSTLVL[10];
> +	u8 RES15[984];
> +	u32 HOSTINTEN;
> +	u8 RES16[6907];
> +};
> +
> +struct pruss_map {
> +	u8 dram0[512];
> +	u8 res1[7680];
> +	u8 dram1[512];
> +	u8 res2[7680];
> +	struct pruss_intc_regs intc;
> +	struct da8xx_prusscore_regs core[2];
> +	u8 iram0[4096];
> +	u8 res3[12288];
> +	u8 iram1[4096];
> +	u8 res4[12288];
> +};
> +
> +#endif


--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig7AA372E66890AD387447D8FD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk13awgACgkQjTAFq1RaXHO21wCfdHls2CJxpx87qCx0uciyRSQU
ICkAn2wqWEBYvyEiOVIwdcHKKf6fxIL/
=oNrB
-----END PGP SIGNATURE-----

--------------enig7AA372E66890AD387447D8FD--

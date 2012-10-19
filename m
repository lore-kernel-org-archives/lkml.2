Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640Ab2JSKhm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 06:37:42 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:40370 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176Ab2JSKhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 06:37:41 -0400
Date: Fri, 19 Oct 2012 13:32:05 +0300
From: Felipe Balbi <balbi@ti.com>
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: <stern@rowland.harvard.edu>, <gregkh@linuxfoundation.org>, <balbi@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 resend] USB: PHY: Re-organize Tegra USB PHY driver
Message-ID: <20121019103205.GG11191@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1350642806-27111-1-git-send-email-vbyravarasu@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YH9Qf6Fh2G5kB/85"
Content-Disposition: inline
In-Reply-To: <1350642806-27111-1-git-send-email-vbyravarasu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--YH9Qf6Fh2G5kB/85
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Oct 19, 2012 at 04:03:26PM +0530, Venu Byravarasu wrote:
> NVIDIA produces several Tegra SoCs viz Tegra20, Tegra30 etc.
> In order to support USB PHY drivers on these SoCs, existing
> PHY driver is split into SoC agnostic common USB PHY driver
> and Tegra20-specific USB phy driver. This will facilitate
> easy addition and deletion of phy drivers for Tegra SoCs.
>=20
> Signed-off-by: Venu Byravarasu <vbyravarasu@xxxxxxxxxx>

you mail ID is wrong here...

> ---
> delta from v3:
>=20
> Rebased the v3 changes on top of xceiv branch.
>=20
> delta from v2:
>=20
> Added an if condition to check for device_node to be not NULL,
> before dereferencing it.
> ---
>  drivers/usb/host/ehci-tegra.c                      |   20 +-
>  drivers/usb/phy/Makefile                           |    1 +
>  .../usb/phy/{tegra_usb_phy.c =3D> tegra2_usb_phy.c}  |  372 ++---------
>  drivers/usb/phy/tegra2_usb_phy.h                   |  178 +++++
>  drivers/usb/phy/tegra_usb_phy.c                    |  725 +-------------=
------
>  include/linux/usb/tegra_usb_phy.h                  |   34 +-
>  6 files changed, 304 insertions(+), 1026 deletions(-)
>  copy drivers/usb/phy/{tegra_usb_phy.c =3D> tegra2_usb_phy.c} (57%)
>  create mode 100644 drivers/usb/phy/tegra2_usb_phy.h
>=20
> diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
> index 6223d17..e08aea3 100644
> --- a/drivers/usb/host/ehci-tegra.c
> +++ b/drivers/usb/host/ehci-tegra.c
> @@ -618,6 +618,9 @@ static int tegra_ehci_probe(struct platform_device *p=
dev)
>  	int err =3D 0;
>  	int irq;
>  	int instance =3D pdev->id;
> +	struct device_node *np =3D pdev->dev.of_node;
> +	struct phy_params params;
> +	int phy_type;
> =20
>  	pdata =3D pdev->dev.platform_data;
>  	if (!pdata) {
> @@ -706,9 +709,22 @@ static int tegra_ehci_probe(struct platform_device *=
pdev)
>  		}
>  	}
> =20
> +	phy_type =3D of_property_match_string(np, "phy_type", "utmi");
> +	if (phy_type >=3D 0)
> +		params.type =3D TEGRA_USB_PHY_TYPE_UTMI;
> +	else {
> +		phy_type =3D of_property_match_string(np, "phy_type", "ulpi");
> +		if (phy_type >=3D 0)
> +			params.type =3D TEGRA_USB_PHY_TYPE_ULPI;
> +		else
> +			params.type =3D TEGRA_USB_PHY_TYPE_INVALID;
> +	}
> +
> +	params.mode =3D TEGRA_USB_PHY_MODE_HOST;
> +	params.config =3D pdata->phy_config;
> +
>  	tegra->phy =3D tegra_usb_phy_open(&pdev->dev, instance, hcd->regs,
> -					pdata->phy_config,
> -					TEGRA_USB_PHY_MODE_HOST);
> +		&params);
>  	if (IS_ERR(tegra->phy)) {
>  		dev_err(&pdev->dev, "Failed to open USB phy\n");
>  		err =3D -ENXIO;

Alan, if you're ok with the ehci-tegra changes, I can carry this patch
by myself.

> diff --git a/drivers/usb/phy/Makefile b/drivers/usb/phy/Makefile
> index b069f29..21872e1 100644
> --- a/drivers/usb/phy/Makefile
> +++ b/drivers/usb/phy/Makefile
> @@ -8,3 +8,4 @@ obj-$(CONFIG_OMAP_USB2)			+=3D omap-usb2.o
>  obj-$(CONFIG_USB_ISP1301)		+=3D isp1301.o
>  obj-$(CONFIG_MV_U3D_PHY)		+=3D mv_u3d_phy.o
>  obj-$(CONFIG_USB_EHCI_TEGRA)	+=3D tegra_usb_phy.o
> +obj-$(CONFIG_USB_EHCI_TEGRA)	+=3D tegra2_usb_phy.o
> diff --git a/drivers/usb/phy/tegra_usb_phy.c b/drivers/usb/phy/tegra2_usb=
_phy.c
> similarity index 57%
> copy from drivers/usb/phy/tegra_usb_phy.c
> copy to drivers/usb/phy/tegra2_usb_phy.c
> index 9d13c81..2ff6dcb 100644
> --- a/drivers/usb/phy/tegra_usb_phy.c
> +++ b/drivers/usb/phy/tegra2_usb_phy.c
> @@ -1,9 +1,11 @@
>  /*
>   * Copyright (C) 2010 Google, Inc.
> + * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
>   *
>   * Author:
>   *	Erik Gilling <konkers@google.com>
>   *	Benoit Goby <benoit@android.com>
> + *	Venu Byravarasu <vbyravarasu@nvidia.com>
>   *
>   * This software is licensed under the terms of the GNU General Public
>   * License version 2, as published by the Free Software Foundation, and
> @@ -29,191 +31,20 @@
>  #include <linux/usb/ulpi.h>
>  #include <asm/mach-types.h>
>  #include <linux/usb/tegra_usb_phy.h>
> +#include <mach/iomap.h>
> =20
> -#define TEGRA_USB_BASE		0xC5000000
> -#define TEGRA_USB_SIZE		SZ_16K
> -
> -#define ULPI_VIEWPORT		0x170
> -
> -#define USB_PORTSC1		0x184
> -#define   USB_PORTSC1_PTS(x)	(((x) & 0x3) << 30)
> -#define   USB_PORTSC1_PSPD(x)	(((x) & 0x3) << 26)
> -#define   USB_PORTSC1_PHCD	(1 << 23)
> -#define   USB_PORTSC1_WKOC	(1 << 22)
> -#define   USB_PORTSC1_WKDS	(1 << 21)
> -#define   USB_PORTSC1_WKCN	(1 << 20)
> -#define   USB_PORTSC1_PTC(x)	(((x) & 0xf) << 16)
> -#define   USB_PORTSC1_PP	(1 << 12)
> -#define   USB_PORTSC1_SUSP	(1 << 7)
> -#define   USB_PORTSC1_PE	(1 << 2)
> -#define   USB_PORTSC1_CCS	(1 << 0)
> -
> -#define USB_SUSP_CTRL		0x400
> -#define   USB_WAKE_ON_CNNT_EN_DEV	(1 << 3)
> -#define   USB_WAKE_ON_DISCON_EN_DEV	(1 << 4)
> -#define   USB_SUSP_CLR		(1 << 5)
> -#define   USB_PHY_CLK_VALID	(1 << 7)
> -#define   UTMIP_RESET			(1 << 11)
> -#define   UHSIC_RESET			(1 << 11)
> -#define   UTMIP_PHY_ENABLE		(1 << 12)
> -#define   ULPI_PHY_ENABLE	(1 << 13)
> -#define   USB_SUSP_SET		(1 << 14)
> -#define   USB_WAKEUP_DEBOUNCE_COUNT(x)	(((x) & 0x7) << 16)
> -
> -#define USB1_LEGACY_CTRL	0x410
> -#define   USB1_NO_LEGACY_MODE			(1 << 0)
> -#define   USB1_VBUS_SENSE_CTL_MASK		(3 << 1)
> -#define   USB1_VBUS_SENSE_CTL_VBUS_WAKEUP	(0 << 1)
> -#define   USB1_VBUS_SENSE_CTL_AB_SESS_VLD_OR_VBUS_WAKEUP \
> -						(1 << 1)
> -#define   USB1_VBUS_SENSE_CTL_AB_SESS_VLD	(2 << 1)
> -#define   USB1_VBUS_SENSE_CTL_A_SESS_VLD	(3 << 1)
> -
> -#define ULPI_TIMING_CTRL_0	0x424
> -#define   ULPI_OUTPUT_PINMUX_BYP	(1 << 10)
> -#define   ULPI_CLKOUT_PINMUX_BYP	(1 << 11)
> -
> -#define ULPI_TIMING_CTRL_1	0x428
> -#define   ULPI_DATA_TRIMMER_LOAD	(1 << 0)
> -#define   ULPI_DATA_TRIMMER_SEL(x)	(((x) & 0x7) << 1)
> -#define   ULPI_STPDIRNXT_TRIMMER_LOAD	(1 << 16)
> -#define   ULPI_STPDIRNXT_TRIMMER_SEL(x)	(((x) & 0x7) << 17)
> -#define   ULPI_DIR_TRIMMER_LOAD		(1 << 24)
> -#define   ULPI_DIR_TRIMMER_SEL(x)	(((x) & 0x7) << 25)
> -
> -#define UTMIP_PLL_CFG1		0x804
> -#define   UTMIP_XTAL_FREQ_COUNT(x)		(((x) & 0xfff) << 0)
> -#define   UTMIP_PLLU_ENABLE_DLY_COUNT(x)	(((x) & 0x1f) << 27)
> -
> -#define UTMIP_XCVR_CFG0		0x808
> -#define   UTMIP_XCVR_SETUP(x)			(((x) & 0xf) << 0)
> -#define   UTMIP_XCVR_LSRSLEW(x)			(((x) & 0x3) << 8)
> -#define   UTMIP_XCVR_LSFSLEW(x)			(((x) & 0x3) << 10)
> -#define   UTMIP_FORCE_PD_POWERDOWN		(1 << 14)
> -#define   UTMIP_FORCE_PD2_POWERDOWN		(1 << 16)
> -#define   UTMIP_FORCE_PDZI_POWERDOWN		(1 << 18)
> -#define   UTMIP_XCVR_HSSLEW_MSB(x)		(((x) & 0x7f) << 25)
> -
> -#define UTMIP_BIAS_CFG0		0x80c
> -#define   UTMIP_OTGPD			(1 << 11)
> -#define   UTMIP_BIASPD			(1 << 10)
> -
> -#define UTMIP_HSRX_CFG0		0x810
> -#define   UTMIP_ELASTIC_LIMIT(x)	(((x) & 0x1f) << 10)
> -#define   UTMIP_IDLE_WAIT(x)		(((x) & 0x1f) << 15)
> -
> -#define UTMIP_HSRX_CFG1		0x814
> -#define   UTMIP_HS_SYNC_START_DLY(x)	(((x) & 0x1f) << 1)
> -
> -#define UTMIP_TX_CFG0		0x820
> -#define   UTMIP_FS_PREABMLE_J		(1 << 19)
> -#define   UTMIP_HS_DISCON_DISABLE	(1 << 8)
> -
> -#define UTMIP_MISC_CFG0		0x824
> -#define   UTMIP_DPDM_OBSERVE		(1 << 26)
> -#define   UTMIP_DPDM_OBSERVE_SEL(x)	(((x) & 0xf) << 27)
> -#define   UTMIP_DPDM_OBSERVE_SEL_FS_J	UTMIP_DPDM_OBSERVE_SEL(0xf)
> -#define   UTMIP_DPDM_OBSERVE_SEL_FS_K	UTMIP_DPDM_OBSERVE_SEL(0xe)
> -#define   UTMIP_DPDM_OBSERVE_SEL_FS_SE1 UTMIP_DPDM_OBSERVE_SEL(0xd)
> -#define   UTMIP_DPDM_OBSERVE_SEL_FS_SE0 UTMIP_DPDM_OBSERVE_SEL(0xc)
> -#define   UTMIP_SUSPEND_EXIT_ON_EDGE	(1 << 22)
> -
> -#define UTMIP_MISC_CFG1		0x828
> -#define   UTMIP_PLL_ACTIVE_DLY_COUNT(x)	(((x) & 0x1f) << 18)
> -#define   UTMIP_PLLU_STABLE_COUNT(x)	(((x) & 0xfff) << 6)
> -
> -#define UTMIP_DEBOUNCE_CFG0	0x82c
> -#define   UTMIP_BIAS_DEBOUNCE_A(x)	(((x) & 0xffff) << 0)
> -
> -#define UTMIP_BAT_CHRG_CFG0	0x830
> -#define   UTMIP_PD_CHRG			(1 << 0)
> -
> -#define UTMIP_SPARE_CFG0	0x834
> -#define   FUSE_SETUP_SEL		(1 << 3)
> -
> -#define UTMIP_XCVR_CFG1		0x838
> -#define   UTMIP_FORCE_PDDISC_POWERDOWN	(1 << 0)
> -#define   UTMIP_FORCE_PDCHRP_POWERDOWN	(1 << 2)
> -#define   UTMIP_FORCE_PDDR_POWERDOWN	(1 << 4)
> -#define   UTMIP_XCVR_TERM_RANGE_ADJ(x)	(((x) & 0xf) << 18)
> -
> -#define UTMIP_BIAS_CFG1		0x83c
> -#define   UTMIP_BIAS_PDTRK_COUNT(x)	(((x) & 0x1f) << 3)
> +#include "tegra2_usb_phy.h"
> =20
>  static DEFINE_SPINLOCK(utmip_pad_lock);
>  static int utmip_pad_count;
> =20
> -struct tegra_xtal_freq {
> -	int freq;
> -	u8 enable_delay;
> -	u8 stable_count;
> -	u8 active_delay;
> -	u8 xtal_freq_count;
> -	u16 debounce;
> -};
> -
> -static const struct tegra_xtal_freq tegra_freq_table[] =3D {
> -	{
> -		.freq =3D 12000000,
> -		.enable_delay =3D 0x02,
> -		.stable_count =3D 0x2F,
> -		.active_delay =3D 0x04,
> -		.xtal_freq_count =3D 0x76,
> -		.debounce =3D 0x7530,
> -	},
> -	{
> -		.freq =3D 13000000,
> -		.enable_delay =3D 0x02,
> -		.stable_count =3D 0x33,
> -		.active_delay =3D 0x05,
> -		.xtal_freq_count =3D 0x7F,
> -		.debounce =3D 0x7EF4,
> -	},
> -	{
> -		.freq =3D 19200000,
> -		.enable_delay =3D 0x03,
> -		.stable_count =3D 0x4B,
> -		.active_delay =3D 0x06,
> -		.xtal_freq_count =3D 0xBB,
> -		.debounce =3D 0xBB80,
> -	},
> -	{
> -		.freq =3D 26000000,
> -		.enable_delay =3D 0x04,
> -		.stable_count =3D 0x66,
> -		.active_delay =3D 0x09,
> -		.xtal_freq_count =3D 0xFE,
> -		.debounce =3D 0xFDE8,
> -	},
> -};
> -
> -static struct tegra_utmip_config utmip_default[] =3D {
> -	[0] =3D {
> -		.hssync_start_delay =3D 9,
> -		.idle_wait_delay =3D 17,
> -		.elastic_limit =3D 16,
> -		.term_range_adj =3D 6,
> -		.xcvr_setup =3D 9,
> -		.xcvr_lsfslew =3D 1,
> -		.xcvr_lsrslew =3D 1,
> -	},
> -	[2] =3D {
> -		.hssync_start_delay =3D 9,
> -		.idle_wait_delay =3D 17,
> -		.elastic_limit =3D 16,
> -		.term_range_adj =3D 6,
> -		.xcvr_setup =3D 9,
> -		.xcvr_lsfslew =3D 2,
> -		.xcvr_lsrslew =3D 2,
> -	},
> -};
> -
>  static inline bool phy_is_ulpi(struct tegra_usb_phy *phy)
>  {
> -	return (phy->instance =3D=3D 1);
> +	return (phy->type =3D=3D TEGRA_USB_PHY_TYPE_ULPI);
>  }
> =20
> -static int utmip_pad_open(struct tegra_usb_phy *phy)
> +
> +static int tegra2_utmip_pad_open(struct tegra_usb_phy *phy)
>  {
>  	phy->pad_clk =3D clk_get_sys("utmip-pad", NULL);
>  	if (IS_ERR(phy->pad_clk)) {
> @@ -234,14 +65,14 @@ static int utmip_pad_open(struct tegra_usb_phy *phy)
>  	return 0;
>  }
> =20
> -static void utmip_pad_close(struct tegra_usb_phy *phy)
> +static void tegra2_utmip_pad_close(struct tegra_usb_phy *phy)
>  {
>  	if (phy->instance !=3D 0)
>  		iounmap(phy->pad_regs);
>  	clk_put(phy->pad_clk);
>  }
> =20
> -static void utmip_pad_power_on(struct tegra_usb_phy *phy)
> +static void tegra2_utmip_pad_power_on(struct tegra_usb_phy *phy)
>  {
>  	unsigned long val, flags;
>  	void __iomem *base =3D phy->pad_regs;
> @@ -261,7 +92,7 @@ static void utmip_pad_power_on(struct tegra_usb_phy *p=
hy)
>  	clk_disable_unprepare(phy->pad_clk);
>  }
> =20
> -static int utmip_pad_power_off(struct tegra_usb_phy *phy)
> +static int tegra2_utmip_pad_power_off(struct tegra_usb_phy *phy)
>  {
>  	unsigned long val, flags;
>  	void __iomem *base =3D phy->pad_regs;
> @@ -291,6 +122,7 @@ static int utmip_pad_power_off(struct tegra_usb_phy *=
phy)
>  static int utmi_wait_register(void __iomem *reg, u32 mask, u32 result)
>  {
>  	unsigned long timeout =3D 2000;
> +
>  	do {
>  		if ((readl(reg) & mask) =3D=3D result)
>  			return 0;
> @@ -300,7 +132,7 @@ static int utmi_wait_register(void __iomem *reg, u32 =
mask, u32 result)
>  	return -1;
>  }
> =20
> -static void utmi_phy_clk_disable(struct tegra_usb_phy *phy)
> +static void tegra2_utmi_phy_clk_disable(struct tegra_usb_phy *phy)
>  {
>  	unsigned long val;
>  	void __iomem *base =3D phy->regs;
> @@ -327,7 +159,7 @@ static void utmi_phy_clk_disable(struct tegra_usb_phy=
 *phy)
>  		pr_err("%s: timeout waiting for phy to stabilize\n", __func__);
>  }
> =20
> -static void utmi_phy_clk_enable(struct tegra_usb_phy *phy)
> +static void tegra2_utmi_phy_clk_enable(struct tegra_usb_phy *phy)
>  {
>  	unsigned long val;
>  	void __iomem *base =3D phy->regs;
> @@ -355,7 +187,7 @@ static void utmi_phy_clk_enable(struct tegra_usb_phy =
*phy)
>  		pr_err("%s: timeout waiting for phy to stabilize\n", __func__);
>  }
> =20
> -static int utmi_phy_power_on(struct tegra_usb_phy *phy)
> +static int tegra2_utmi_phy_power_on(struct tegra_usb_phy *phy)
>  {
>  	unsigned long val;
>  	void __iomem *base =3D phy->regs;
> @@ -413,7 +245,7 @@ static int utmi_phy_power_on(struct tegra_usb_phy *ph=
y)
>  		writel(val, base + USB_SUSP_CTRL);
>  	}
> =20
> -	utmip_pad_power_on(phy);
> +	tegra2_utmip_pad_power_on(phy);
> =20
>  	val =3D readl(base + UTMIP_XCVR_CFG0);
>  	val &=3D ~(UTMIP_FORCE_PD_POWERDOWN | UTMIP_FORCE_PD2_POWERDOWN |
> @@ -470,7 +302,7 @@ static int utmi_phy_power_on(struct tegra_usb_phy *ph=
y)
>  		writel(val, base + USB_SUSP_CTRL);
>  	}
> =20
> -	utmi_phy_clk_enable(phy);
> +	tegra2_utmi_phy_clk_enable(phy);
> =20
>  	if (phy->instance =3D=3D 2) {
>  		val =3D readl(base + USB_PORTSC1);
> @@ -481,12 +313,12 @@ static int utmi_phy_power_on(struct tegra_usb_phy *=
phy)
>  	return 0;
>  }
> =20
> -static int utmi_phy_power_off(struct tegra_usb_phy *phy)
> +static int tegra2_utmi_phy_power_off(struct tegra_usb_phy *phy)
>  {
>  	unsigned long val;
>  	void __iomem *base =3D phy->regs;
> =20
> -	utmi_phy_clk_disable(phy);
> +	tegra2_utmi_phy_clk_disable(phy);
> =20
>  	if (phy->mode =3D=3D TEGRA_USB_PHY_MODE_DEVICE) {
>  		val =3D readl(base + USB_SUSP_CTRL);
> @@ -513,10 +345,10 @@ static int utmi_phy_power_off(struct tegra_usb_phy =
*phy)
>  	       UTMIP_FORCE_PDDR_POWERDOWN;
>  	writel(val, base + UTMIP_XCVR_CFG1);
> =20
> -	return utmip_pad_power_off(phy);
> +	return tegra2_utmip_pad_power_off(phy);
>  }
> =20
> -static void utmi_phy_preresume(struct tegra_usb_phy *phy)
> +static void tegra2_utmi_phy_preresume(struct tegra_usb_phy *phy)
>  {
>  	unsigned long val;
>  	void __iomem *base =3D phy->regs;
> @@ -526,7 +358,7 @@ static void utmi_phy_preresume(struct tegra_usb_phy *=
phy)
>  	writel(val, base + UTMIP_TX_CFG0);
>  }
> =20
> -static void utmi_phy_postresume(struct tegra_usb_phy *phy)
> +static void tegra2_utmi_phy_postresume(struct tegra_usb_phy *phy)
>  {
>  	unsigned long val;
>  	void __iomem *base =3D phy->regs;
> @@ -536,7 +368,7 @@ static void utmi_phy_postresume(struct tegra_usb_phy =
*phy)
>  	writel(val, base + UTMIP_TX_CFG0);
>  }
> =20
> -static void utmi_phy_restore_start(struct tegra_usb_phy *phy,
> +static void tegra2_utmi_phy_restore_start(struct tegra_usb_phy *phy,
>  				   enum tegra_usb_phy_port_speed port_speed)
>  {
>  	unsigned long val;
> @@ -557,7 +389,7 @@ static void utmi_phy_restore_start(struct tegra_usb_p=
hy *phy,
>  	udelay(10);
>  }
> =20
> -static void utmi_phy_restore_end(struct tegra_usb_phy *phy)
> +static void tegra2_utmi_phy_restore_end(struct tegra_usb_phy *phy)
>  {
>  	unsigned long val;
>  	void __iomem *base =3D phy->regs;
> @@ -568,7 +400,7 @@ static void utmi_phy_restore_end(struct tegra_usb_phy=
 *phy)
>  	udelay(10);
>  }
> =20
> -static int ulpi_phy_power_on(struct tegra_usb_phy *phy)
> +static int tegra2_ulpi_phy_power_on(struct tegra_usb_phy *phy)
>  {
>  	int ret;
>  	unsigned long val;
> @@ -637,7 +469,7 @@ static int ulpi_phy_power_on(struct tegra_usb_phy *ph=
y)
>  	return 0;
>  }
> =20
> -static int ulpi_phy_power_off(struct tegra_usb_phy *phy)
> +static int tegra2_ulpi_phy_power_off(struct tegra_usb_phy *phy)
>  {
>  	unsigned long val;
>  	void __iomem *base =3D phy->regs;
> @@ -654,9 +486,8 @@ static int ulpi_phy_power_off(struct tegra_usb_phy *p=
hy)
>  	return gpio_direction_output(config->reset_gpio, 0);
>  }
> =20
> -static int	tegra_phy_init(struct usb_phy *x)
> +static int	tegra2_usb_phy_open(struct tegra_usb_phy *phy)
>  {
> -	struct tegra_usb_phy *phy =3D container_of(x, struct tegra_usb_phy, u_p=
hy);
>  	struct tegra_ulpi_config *ulpi_config;
>  	int err;
> =20
> @@ -683,7 +514,7 @@ static int	tegra_phy_init(struct usb_phy *x)
>  		phy->ulpi =3D otg_ulpi_create(&ulpi_viewport_access_ops, 0);
>  		phy->ulpi->io_priv =3D phy->regs + ULPI_VIEWPORT;
>  	} else {
> -		err =3D utmip_pad_open(phy);
> +		err =3D tegra2_utmip_pad_open(phy);
>  		if (err < 0)
>  			goto err1;
>  	}
> @@ -694,147 +525,36 @@ err1:
>  	return err;
>  }
> =20
> -static void tegra_usb_phy_close(struct usb_phy *x)
> +static void tegra2_usb_phy_close(struct tegra_usb_phy *phy)
>  {
> -	struct tegra_usb_phy *phy =3D container_of(x, struct tegra_usb_phy, u_p=
hy);
> -
>  	if (phy_is_ulpi(phy))
>  		clk_put(phy->clk);
>  	else
> -		utmip_pad_close(phy);
> +		tegra2_utmip_pad_close(phy);
>  	clk_disable_unprepare(phy->pll_u);
>  	clk_put(phy->pll_u);
> -	kfree(phy);
>  }
> =20
> -static int tegra_usb_phy_power_on(struct tegra_usb_phy *phy)
> +int tegra2_usb_phy_init(struct tegra_usb_phy *phy)
>  {
> -	if (phy_is_ulpi(phy))
> -		return ulpi_phy_power_on(phy);
> -	else
> -		return utmi_phy_power_on(phy);
> -}
> +	if ((phy->type !=3D TEGRA_USB_PHY_TYPE_ULPI) &&
> +		(phy->type !=3D TEGRA_USB_PHY_TYPE_UTMI))
> +			return -EINVAL;
> =20
> -static int tegra_usb_phy_power_off(struct tegra_usb_phy *phy)
> -{
> -	if (phy_is_ulpi(phy))
> -		return ulpi_phy_power_off(phy);
> -	else
> -		return utmi_phy_power_off(phy);
> -}
> +	phy->ops.open =3D tegra2_usb_phy_open;
> +	phy->ops.close =3D tegra2_usb_phy_close;
> =20
> -static int	tegra_usb_phy_suspend(struct usb_phy *x, int suspend)
> -{
> -	struct tegra_usb_phy *phy =3D container_of(x, struct tegra_usb_phy, u_p=
hy);
> -	if (suspend)
> -		return tegra_usb_phy_power_off(phy);
> -	else
> -		return tegra_usb_phy_power_on(phy);
> -}
> -
> -struct tegra_usb_phy *tegra_usb_phy_open(struct device *dev, int instanc=
e,
> -	void __iomem *regs, void *config, enum tegra_usb_phy_mode phy_mode)
> -{
> -	struct tegra_usb_phy *phy;
> -	unsigned long parent_rate;
> -	int i;
> -	int err;
> -
> -	phy =3D kmalloc(sizeof(struct tegra_usb_phy), GFP_KERNEL);
> -	if (!phy)
> -		return ERR_PTR(-ENOMEM);
> -
> -	phy->instance =3D instance;
> -	phy->regs =3D regs;
> -	phy->config =3D config;
> -	phy->mode =3D phy_mode;
> -	phy->dev =3D dev;
> -
> -	if (!phy->config) {
> -		if (phy_is_ulpi(phy)) {
> -			pr_err("%s: ulpi phy configuration missing", __func__);
> -			err =3D -EINVAL;
> -			goto err0;
> -		} else {
> -			phy->config =3D &utmip_default[instance];
> -		}
> -	}
> -
> -	phy->pll_u =3D clk_get_sys(NULL, "pll_u");
> -	if (IS_ERR(phy->pll_u)) {
> -		pr_err("Can't get pll_u clock\n");
> -		err =3D PTR_ERR(phy->pll_u);
> -		goto err0;
> -	}
> -	clk_prepare_enable(phy->pll_u);
> -
> -	parent_rate =3D clk_get_rate(clk_get_parent(phy->pll_u));
> -	for (i =3D 0; i < ARRAY_SIZE(tegra_freq_table); i++) {
> -		if (tegra_freq_table[i].freq =3D=3D parent_rate) {
> -			phy->freq =3D &tegra_freq_table[i];
> -			break;
> -		}
> -	}
> -	if (!phy->freq) {
> -		pr_err("invalid pll_u parent rate %ld\n", parent_rate);
> -		err =3D -EINVAL;
> -		goto err1;
> +	if (phy_is_ulpi(phy)) {
> +		phy->ops.power_on =3D tegra2_ulpi_phy_power_on;
> +		phy->ops.power_off =3D tegra2_ulpi_phy_power_off;
> +	} else if (phy->type =3D=3D TEGRA_USB_PHY_TYPE_UTMI) {
> +		phy->ops.postresume =3D tegra2_utmi_phy_postresume;
> +		phy->ops.power_off =3D tegra2_utmi_phy_power_off;
> +		phy->ops.power_on =3D tegra2_utmi_phy_power_on;
> +		phy->ops.preresume =3D tegra2_utmi_phy_preresume;
> +		phy->ops.restore_end =3D tegra2_utmi_phy_restore_end;
> +		phy->ops.restore_start =3D tegra2_utmi_phy_restore_start;
>  	}
> =20
> -	phy->u_phy.init =3D tegra_phy_init;
> -	phy->u_phy.shutdown =3D tegra_usb_phy_close;
> -	phy->u_phy.set_suspend =3D tegra_usb_phy_suspend;
> -
> -	return phy;
> -
> -err1:
> -	clk_disable_unprepare(phy->pll_u);
> -	clk_put(phy->pll_u);
> -err0:
> -	kfree(phy);
> -	return ERR_PTR(err);
> -}
> -EXPORT_SYMBOL_GPL(tegra_usb_phy_open);
> -
> -void tegra_usb_phy_preresume(struct tegra_usb_phy *phy)
> -{
> -	if (!phy_is_ulpi(phy))
> -		utmi_phy_preresume(phy);
> -}
> -EXPORT_SYMBOL_GPL(tegra_usb_phy_preresume);
> -
> -void tegra_usb_phy_postresume(struct tegra_usb_phy *phy)
> -{
> -	if (!phy_is_ulpi(phy))
> -		utmi_phy_postresume(phy);
> -}
> -EXPORT_SYMBOL_GPL(tegra_usb_phy_postresume);
> -
> -void tegra_ehci_phy_restore_start(struct tegra_usb_phy *phy,
> -				 enum tegra_usb_phy_port_speed port_speed)
> -{
> -	if (!phy_is_ulpi(phy))
> -		utmi_phy_restore_start(phy, port_speed);
> -}
> -EXPORT_SYMBOL_GPL(tegra_ehci_phy_restore_start);
> -
> -void tegra_ehci_phy_restore_end(struct tegra_usb_phy *phy)
> -{
> -	if (!phy_is_ulpi(phy))
> -		utmi_phy_restore_end(phy);
> -}
> -EXPORT_SYMBOL_GPL(tegra_ehci_phy_restore_end);
> -
> -void tegra_usb_phy_clk_disable(struct tegra_usb_phy *phy)
> -{
> -	if (!phy_is_ulpi(phy))
> -		utmi_phy_clk_disable(phy);
> -}
> -EXPORT_SYMBOL_GPL(tegra_usb_phy_clk_disable);
> -
> -void tegra_usb_phy_clk_enable(struct tegra_usb_phy *phy)
> -{
> -	if (!phy_is_ulpi(phy))
> -		utmi_phy_clk_enable(phy);
> +	return 0;
>  }
> -EXPORT_SYMBOL_GPL(tegra_usb_phy_clk_enable);
> diff --git a/drivers/usb/phy/tegra2_usb_phy.h b/drivers/usb/phy/tegra2_us=
b_phy.h
> new file mode 100644
> index 0000000..32b0c03
> --- /dev/null
> +++ b/drivers/usb/phy/tegra2_usb_phy.h
> @@ -0,0 +1,178 @@
> +/*
> + * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
> + *
> + * Author: Venu Byravarasu <vbyravarasu@nvidia.com>
> + *
> + * This program is free software; you can redistribute it and/or modify =
it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License=
 for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#ifndef _TEGRA2_USB_PHY_H
> +#define _TEGRA2_USB_PHY_H
> +
> +#define TEGRA_USB_BASE		0xC5000000
> +#define TEGRA_USB_SIZE		SZ_16K
> +
> +#define ULPI_VIEWPORT		0x170
> +
> +#define USB_PORTSC1		0x184
> +#define   USB_PORTSC1_PTS(x)	(((x) & 0x3) << 30)
> +#define   USB_PORTSC1_PSPD(x)	(((x) & 0x3) << 26)
> +#define   USB_PORTSC1_PHCD	(1 << 23)
> +#define   USB_PORTSC1_WKOC	(1 << 22)
> +#define   USB_PORTSC1_WKDS	(1 << 21)
> +#define   USB_PORTSC1_WKCN	(1 << 20)
> +#define   USB_PORTSC1_PTC(x)	(((x) & 0xf) << 16)
> +#define   USB_PORTSC1_PP	(1 << 12)
> +#define   USB_PORTSC1_SUSP	(1 << 7)
> +#define   USB_PORTSC1_PE	(1 << 2)
> +#define   USB_PORTSC1_CCS	(1 << 0)
> +
> +#define USB_SUSP_CTRL		0x400
> +#define   USB_WAKE_ON_CNNT_EN_DEV	(1 << 3)
> +#define   USB_WAKE_ON_DISCON_EN_DEV	(1 << 4)
> +#define   USB_SUSP_CLR		(1 << 5)
> +#define   USB_PHY_CLK_VALID	(1 << 7)
> +#define   UTMIP_RESET			(1 << 11)
> +#define   UHSIC_RESET			(1 << 11)
> +#define   UTMIP_PHY_ENABLE		(1 << 12)
> +#define   ULPI_PHY_ENABLE	(1 << 13)
> +#define   USB_SUSP_SET		(1 << 14)
> +#define   USB_WAKEUP_DEBOUNCE_COUNT(x)	(((x) & 0x7) << 16)
> +
> +#define USB1_LEGACY_CTRL	0x410
> +#define   USB1_NO_LEGACY_MODE			(1 << 0)
> +#define   USB1_VBUS_SENSE_CTL_MASK		(3 << 1)
> +#define   USB1_VBUS_SENSE_CTL_VBUS_WAKEUP	(0 << 1)
> +#define   USB1_VBUS_SENSE_CTL_AB_SESS_VLD_OR_VBUS_WAKEUP \
> +						(1 << 1)
> +#define   USB1_VBUS_SENSE_CTL_AB_SESS_VLD	(2 << 1)
> +#define   USB1_VBUS_SENSE_CTL_A_SESS_VLD	(3 << 1)
> +
> +#define ULPI_TIMING_CTRL_0	0x424
> +#define   ULPI_OUTPUT_PINMUX_BYP	(1 << 10)
> +#define   ULPI_CLKOUT_PINMUX_BYP	(1 << 11)
> +
> +#define ULPI_TIMING_CTRL_1	0x428
> +#define   ULPI_DATA_TRIMMER_LOAD	(1 << 0)
> +#define   ULPI_DATA_TRIMMER_SEL(x)	(((x) & 0x7) << 1)
> +#define   ULPI_STPDIRNXT_TRIMMER_LOAD	(1 << 16)
> +#define   ULPI_STPDIRNXT_TRIMMER_SEL(x)	(((x) & 0x7) << 17)
> +#define   ULPI_DIR_TRIMMER_LOAD		(1 << 24)
> +#define   ULPI_DIR_TRIMMER_SEL(x)	(((x) & 0x7) << 25)
> +
> +#define UTMIP_PLL_CFG1		0x804
> +#define   UTMIP_XTAL_FREQ_COUNT(x)		(((x) & 0xfff) << 0)
> +#define   UTMIP_PLLU_ENABLE_DLY_COUNT(x)	(((x) & 0x1f) << 27)
> +
> +#define UTMIP_XCVR_CFG0		0x808
> +#define   UTMIP_XCVR_SETUP(x)			(((x) & 0xf) << 0)
> +#define   UTMIP_XCVR_LSRSLEW(x)			(((x) & 0x3) << 8)
> +#define   UTMIP_XCVR_LSFSLEW(x)			(((x) & 0x3) << 10)
> +#define   UTMIP_FORCE_PD_POWERDOWN		(1 << 14)
> +#define   UTMIP_FORCE_PD2_POWERDOWN		(1 << 16)
> +#define   UTMIP_FORCE_PDZI_POWERDOWN		(1 << 18)
> +#define   UTMIP_XCVR_HSSLEW_MSB(x)		(((x) & 0x7f) << 25)
> +
> +#define UTMIP_BIAS_CFG0		0x80c
> +#define   UTMIP_OTGPD			(1 << 11)
> +#define   UTMIP_BIASPD			(1 << 10)
> +
> +#define UTMIP_HSRX_CFG0		0x810
> +#define   UTMIP_ELASTIC_LIMIT(x)	(((x) & 0x1f) << 10)
> +#define   UTMIP_IDLE_WAIT(x)		(((x) & 0x1f) << 15)
> +
> +#define UTMIP_HSRX_CFG1		0x814
> +#define   UTMIP_HS_SYNC_START_DLY(x)	(((x) & 0x1f) << 1)
> +
> +#define UTMIP_TX_CFG0		0x820
> +#define   UTMIP_FS_PREABMLE_J		(1 << 19)
> +#define   UTMIP_HS_DISCON_DISABLE	(1 << 8)
> +
> +#define UTMIP_MISC_CFG0		0x824
> +#define   UTMIP_DPDM_OBSERVE		(1 << 26)
> +#define   UTMIP_DPDM_OBSERVE_SEL(x)	(((x) & 0xf) << 27)
> +#define   UTMIP_DPDM_OBSERVE_SEL_FS_J	UTMIP_DPDM_OBSERVE_SEL(0xf)
> +#define   UTMIP_DPDM_OBSERVE_SEL_FS_K	UTMIP_DPDM_OBSERVE_SEL(0xe)
> +#define   UTMIP_DPDM_OBSERVE_SEL_FS_SE1 UTMIP_DPDM_OBSERVE_SEL(0xd)
> +#define   UTMIP_DPDM_OBSERVE_SEL_FS_SE0 UTMIP_DPDM_OBSERVE_SEL(0xc)
> +#define   UTMIP_SUSPEND_EXIT_ON_EDGE	(1 << 22)
> +
> +#define UTMIP_MISC_CFG1		0x828
> +#define   UTMIP_PLL_ACTIVE_DLY_COUNT(x)	(((x) & 0x1f) << 18)
> +#define   UTMIP_PLLU_STABLE_COUNT(x)	(((x) & 0xfff) << 6)
> +
> +#define UTMIP_DEBOUNCE_CFG0	0x82c
> +#define   UTMIP_BIAS_DEBOUNCE_A(x)	(((x) & 0xffff) << 0)
> +
> +#define UTMIP_BAT_CHRG_CFG0	0x830
> +#define   UTMIP_PD_CHRG			(1 << 0)
> +
> +#define UTMIP_SPARE_CFG0	0x834
> +#define   FUSE_SETUP_SEL		(1 << 3)
> +
> +#define UTMIP_XCVR_CFG1		0x838
> +#define   UTMIP_FORCE_PDDISC_POWERDOWN	(1 << 0)
> +#define   UTMIP_FORCE_PDCHRP_POWERDOWN	(1 << 2)
> +#define   UTMIP_FORCE_PDDR_POWERDOWN	(1 << 4)
> +#define   UTMIP_XCVR_TERM_RANGE_ADJ(x)	(((x) & 0xf) << 18)
> +
> +#define UTMIP_BIAS_CFG1		0x83c
> +#define   UTMIP_BIAS_PDTRK_COUNT(x)	(((x) & 0x1f) << 3)
> +
> +struct tegra_xtal_freq {
> +	int freq;
> +	u8 enable_delay;
> +	u8 stable_count;
> +	u8 active_delay;
> +	u8 xtal_freq_count;
> +	u16 debounce;
> +};
> +
> +static const struct tegra_xtal_freq tegra_freq_table[] =3D {
> +	{
> +		.freq =3D 12000000,
> +		.enable_delay =3D 0x02,
> +		.stable_count =3D 0x2F,
> +		.active_delay =3D 0x04,
> +		.xtal_freq_count =3D 0x76,
> +		.debounce =3D 0x7530,
> +	},
> +	{
> +		.freq =3D 13000000,
> +		.enable_delay =3D 0x02,
> +		.stable_count =3D 0x33,
> +		.active_delay =3D 0x05,
> +		.xtal_freq_count =3D 0x7F,
> +		.debounce =3D 0x7EF4,
> +	},
> +	{
> +		.freq =3D 19200000,
> +		.enable_delay =3D 0x03,
> +		.stable_count =3D 0x4B,
> +		.active_delay =3D 0x06,
> +		.xtal_freq_count =3D 0xBB,
> +		.debounce =3D 0xBB80,
> +	},
> +	{
> +		.freq =3D 26000000,
> +		.enable_delay =3D 0x04,
> +		.stable_count =3D 0x66,
> +		.active_delay =3D 0x09,
> +		.xtal_freq_count =3D 0xFE,
> +		.debounce =3D 0xFDE8,
> +	},
> +};
> +
> +int tegra2_usb_phy_init(struct tegra_usb_phy *phy);
> +
> +#endif /* _TEGRA2_USB_PHY_H */
> diff --git a/drivers/usb/phy/tegra_usb_phy.c b/drivers/usb/phy/tegra_usb_=
phy.c
> index 9d13c81..60334d8 100644
> --- a/drivers/usb/phy/tegra_usb_phy.c
> +++ b/drivers/usb/phy/tegra_usb_phy.c
> @@ -29,163 +29,7 @@
>  #include <linux/usb/ulpi.h>
>  #include <asm/mach-types.h>
>  #include <linux/usb/tegra_usb_phy.h>
> -
> -#define TEGRA_USB_BASE		0xC5000000
> -#define TEGRA_USB_SIZE		SZ_16K
> -
> -#define ULPI_VIEWPORT		0x170
> -
> -#define USB_PORTSC1		0x184
> -#define   USB_PORTSC1_PTS(x)	(((x) & 0x3) << 30)
> -#define   USB_PORTSC1_PSPD(x)	(((x) & 0x3) << 26)
> -#define   USB_PORTSC1_PHCD	(1 << 23)
> -#define   USB_PORTSC1_WKOC	(1 << 22)
> -#define   USB_PORTSC1_WKDS	(1 << 21)
> -#define   USB_PORTSC1_WKCN	(1 << 20)
> -#define   USB_PORTSC1_PTC(x)	(((x) & 0xf) << 16)
> -#define   USB_PORTSC1_PP	(1 << 12)
> -#define   USB_PORTSC1_SUSP	(1 << 7)
> -#define   USB_PORTSC1_PE	(1 << 2)
> -#define   USB_PORTSC1_CCS	(1 << 0)
> -
> -#define USB_SUSP_CTRL		0x400
> -#define   USB_WAKE_ON_CNNT_EN_DEV	(1 << 3)
> -#define   USB_WAKE_ON_DISCON_EN_DEV	(1 << 4)
> -#define   USB_SUSP_CLR		(1 << 5)
> -#define   USB_PHY_CLK_VALID	(1 << 7)
> -#define   UTMIP_RESET			(1 << 11)
> -#define   UHSIC_RESET			(1 << 11)
> -#define   UTMIP_PHY_ENABLE		(1 << 12)
> -#define   ULPI_PHY_ENABLE	(1 << 13)
> -#define   USB_SUSP_SET		(1 << 14)
> -#define   USB_WAKEUP_DEBOUNCE_COUNT(x)	(((x) & 0x7) << 16)
> -
> -#define USB1_LEGACY_CTRL	0x410
> -#define   USB1_NO_LEGACY_MODE			(1 << 0)
> -#define   USB1_VBUS_SENSE_CTL_MASK		(3 << 1)
> -#define   USB1_VBUS_SENSE_CTL_VBUS_WAKEUP	(0 << 1)
> -#define   USB1_VBUS_SENSE_CTL_AB_SESS_VLD_OR_VBUS_WAKEUP \
> -						(1 << 1)
> -#define   USB1_VBUS_SENSE_CTL_AB_SESS_VLD	(2 << 1)
> -#define   USB1_VBUS_SENSE_CTL_A_SESS_VLD	(3 << 1)
> -
> -#define ULPI_TIMING_CTRL_0	0x424
> -#define   ULPI_OUTPUT_PINMUX_BYP	(1 << 10)
> -#define   ULPI_CLKOUT_PINMUX_BYP	(1 << 11)
> -
> -#define ULPI_TIMING_CTRL_1	0x428
> -#define   ULPI_DATA_TRIMMER_LOAD	(1 << 0)
> -#define   ULPI_DATA_TRIMMER_SEL(x)	(((x) & 0x7) << 1)
> -#define   ULPI_STPDIRNXT_TRIMMER_LOAD	(1 << 16)
> -#define   ULPI_STPDIRNXT_TRIMMER_SEL(x)	(((x) & 0x7) << 17)
> -#define   ULPI_DIR_TRIMMER_LOAD		(1 << 24)
> -#define   ULPI_DIR_TRIMMER_SEL(x)	(((x) & 0x7) << 25)
> -
> -#define UTMIP_PLL_CFG1		0x804
> -#define   UTMIP_XTAL_FREQ_COUNT(x)		(((x) & 0xfff) << 0)
> -#define   UTMIP_PLLU_ENABLE_DLY_COUNT(x)	(((x) & 0x1f) << 27)
> -
> -#define UTMIP_XCVR_CFG0		0x808
> -#define   UTMIP_XCVR_SETUP(x)			(((x) & 0xf) << 0)
> -#define   UTMIP_XCVR_LSRSLEW(x)			(((x) & 0x3) << 8)
> -#define   UTMIP_XCVR_LSFSLEW(x)			(((x) & 0x3) << 10)
> -#define   UTMIP_FORCE_PD_POWERDOWN		(1 << 14)
> -#define   UTMIP_FORCE_PD2_POWERDOWN		(1 << 16)
> -#define   UTMIP_FORCE_PDZI_POWERDOWN		(1 << 18)
> -#define   UTMIP_XCVR_HSSLEW_MSB(x)		(((x) & 0x7f) << 25)
> -
> -#define UTMIP_BIAS_CFG0		0x80c
> -#define   UTMIP_OTGPD			(1 << 11)
> -#define   UTMIP_BIASPD			(1 << 10)
> -
> -#define UTMIP_HSRX_CFG0		0x810
> -#define   UTMIP_ELASTIC_LIMIT(x)	(((x) & 0x1f) << 10)
> -#define   UTMIP_IDLE_WAIT(x)		(((x) & 0x1f) << 15)
> -
> -#define UTMIP_HSRX_CFG1		0x814
> -#define   UTMIP_HS_SYNC_START_DLY(x)	(((x) & 0x1f) << 1)
> -
> -#define UTMIP_TX_CFG0		0x820
> -#define   UTMIP_FS_PREABMLE_J		(1 << 19)
> -#define   UTMIP_HS_DISCON_DISABLE	(1 << 8)
> -
> -#define UTMIP_MISC_CFG0		0x824
> -#define   UTMIP_DPDM_OBSERVE		(1 << 26)
> -#define   UTMIP_DPDM_OBSERVE_SEL(x)	(((x) & 0xf) << 27)
> -#define   UTMIP_DPDM_OBSERVE_SEL_FS_J	UTMIP_DPDM_OBSERVE_SEL(0xf)
> -#define   UTMIP_DPDM_OBSERVE_SEL_FS_K	UTMIP_DPDM_OBSERVE_SEL(0xe)
> -#define   UTMIP_DPDM_OBSERVE_SEL_FS_SE1 UTMIP_DPDM_OBSERVE_SEL(0xd)
> -#define   UTMIP_DPDM_OBSERVE_SEL_FS_SE0 UTMIP_DPDM_OBSERVE_SEL(0xc)
> -#define   UTMIP_SUSPEND_EXIT_ON_EDGE	(1 << 22)
> -
> -#define UTMIP_MISC_CFG1		0x828
> -#define   UTMIP_PLL_ACTIVE_DLY_COUNT(x)	(((x) & 0x1f) << 18)
> -#define   UTMIP_PLLU_STABLE_COUNT(x)	(((x) & 0xfff) << 6)
> -
> -#define UTMIP_DEBOUNCE_CFG0	0x82c
> -#define   UTMIP_BIAS_DEBOUNCE_A(x)	(((x) & 0xffff) << 0)
> -
> -#define UTMIP_BAT_CHRG_CFG0	0x830
> -#define   UTMIP_PD_CHRG			(1 << 0)
> -
> -#define UTMIP_SPARE_CFG0	0x834
> -#define   FUSE_SETUP_SEL		(1 << 3)
> -
> -#define UTMIP_XCVR_CFG1		0x838
> -#define   UTMIP_FORCE_PDDISC_POWERDOWN	(1 << 0)
> -#define   UTMIP_FORCE_PDCHRP_POWERDOWN	(1 << 2)
> -#define   UTMIP_FORCE_PDDR_POWERDOWN	(1 << 4)
> -#define   UTMIP_XCVR_TERM_RANGE_ADJ(x)	(((x) & 0xf) << 18)
> -
> -#define UTMIP_BIAS_CFG1		0x83c
> -#define   UTMIP_BIAS_PDTRK_COUNT(x)	(((x) & 0x1f) << 3)
> -
> -static DEFINE_SPINLOCK(utmip_pad_lock);
> -static int utmip_pad_count;
> -
> -struct tegra_xtal_freq {
> -	int freq;
> -	u8 enable_delay;
> -	u8 stable_count;
> -	u8 active_delay;
> -	u8 xtal_freq_count;
> -	u16 debounce;
> -};
> -
> -static const struct tegra_xtal_freq tegra_freq_table[] =3D {
> -	{
> -		.freq =3D 12000000,
> -		.enable_delay =3D 0x02,
> -		.stable_count =3D 0x2F,
> -		.active_delay =3D 0x04,
> -		.xtal_freq_count =3D 0x76,
> -		.debounce =3D 0x7530,
> -	},
> -	{
> -		.freq =3D 13000000,
> -		.enable_delay =3D 0x02,
> -		.stable_count =3D 0x33,
> -		.active_delay =3D 0x05,
> -		.xtal_freq_count =3D 0x7F,
> -		.debounce =3D 0x7EF4,
> -	},
> -	{
> -		.freq =3D 19200000,
> -		.enable_delay =3D 0x03,
> -		.stable_count =3D 0x4B,
> -		.active_delay =3D 0x06,
> -		.xtal_freq_count =3D 0xBB,
> -		.debounce =3D 0xBB80,
> -	},
> -	{
> -		.freq =3D 26000000,
> -		.enable_delay =3D 0x04,
> -		.stable_count =3D 0x66,
> -		.active_delay =3D 0x09,
> -		.xtal_freq_count =3D 0xFE,
> -		.debounce =3D 0xFDE8,
> -	},
> -};
> +#include "tegra2_usb_phy.h"
> =20
>  static struct tegra_utmip_config utmip_default[] =3D {
>  	[0] =3D {
> @@ -208,550 +52,54 @@ static struct tegra_utmip_config utmip_default[] =
=3D {
>  	},
>  };
> =20
> -static inline bool phy_is_ulpi(struct tegra_usb_phy *phy)
> -{
> -	return (phy->instance =3D=3D 1);
> -}
> -
> -static int utmip_pad_open(struct tegra_usb_phy *phy)
> -{
> -	phy->pad_clk =3D clk_get_sys("utmip-pad", NULL);
> -	if (IS_ERR(phy->pad_clk)) {
> -		pr_err("%s: can't get utmip pad clock\n", __func__);
> -		return PTR_ERR(phy->pad_clk);
> -	}
> -
> -	if (phy->instance =3D=3D 0) {
> -		phy->pad_regs =3D phy->regs;
> -	} else {
> -		phy->pad_regs =3D ioremap(TEGRA_USB_BASE, TEGRA_USB_SIZE);
> -		if (!phy->pad_regs) {
> -			pr_err("%s: can't remap usb registers\n", __func__);
> -			clk_put(phy->pad_clk);
> -			return -ENOMEM;
> -		}
> -	}
> -	return 0;
> -}
> -
> -static void utmip_pad_close(struct tegra_usb_phy *phy)
> -{
> -	if (phy->instance !=3D 0)
> -		iounmap(phy->pad_regs);
> -	clk_put(phy->pad_clk);
> -}
> -
> -static void utmip_pad_power_on(struct tegra_usb_phy *phy)
> -{
> -	unsigned long val, flags;
> -	void __iomem *base =3D phy->pad_regs;
> -
> -	clk_prepare_enable(phy->pad_clk);
> -
> -	spin_lock_irqsave(&utmip_pad_lock, flags);
> -
> -	if (utmip_pad_count++ =3D=3D 0) {
> -		val =3D readl(base + UTMIP_BIAS_CFG0);
> -		val &=3D ~(UTMIP_OTGPD | UTMIP_BIASPD);
> -		writel(val, base + UTMIP_BIAS_CFG0);
> -	}
> -
> -	spin_unlock_irqrestore(&utmip_pad_lock, flags);
> -
> -	clk_disable_unprepare(phy->pad_clk);
> -}
> -
> -static int utmip_pad_power_off(struct tegra_usb_phy *phy)
> -{
> -	unsigned long val, flags;
> -	void __iomem *base =3D phy->pad_regs;
> -
> -	if (!utmip_pad_count) {
> -		pr_err("%s: utmip pad already powered off\n", __func__);
> -		return -EINVAL;
> -	}
> -
> -	clk_prepare_enable(phy->pad_clk);
> -
> -	spin_lock_irqsave(&utmip_pad_lock, flags);
> -
> -	if (--utmip_pad_count =3D=3D 0) {
> -		val =3D readl(base + UTMIP_BIAS_CFG0);
> -		val |=3D UTMIP_OTGPD | UTMIP_BIASPD;
> -		writel(val, base + UTMIP_BIAS_CFG0);
> -	}
> -
> -	spin_unlock_irqrestore(&utmip_pad_lock, flags);
> -
> -	clk_disable_unprepare(phy->pad_clk);
> -
> -	return 0;
> -}
> -
> -static int utmi_wait_register(void __iomem *reg, u32 mask, u32 result)
> -{
> -	unsigned long timeout =3D 2000;
> -	do {
> -		if ((readl(reg) & mask) =3D=3D result)
> -			return 0;
> -		udelay(1);
> -		timeout--;
> -	} while (timeout);
> -	return -1;
> -}
> -
> -static void utmi_phy_clk_disable(struct tegra_usb_phy *phy)
> -{
> -	unsigned long val;
> -	void __iomem *base =3D phy->regs;
> -
> -	if (phy->instance =3D=3D 0) {
> -		val =3D readl(base + USB_SUSP_CTRL);
> -		val |=3D USB_SUSP_SET;
> -		writel(val, base + USB_SUSP_CTRL);
> -
> -		udelay(10);
> -
> -		val =3D readl(base + USB_SUSP_CTRL);
> -		val &=3D ~USB_SUSP_SET;
> -		writel(val, base + USB_SUSP_CTRL);
> -	}
> -
> -	if (phy->instance =3D=3D 2) {
> -		val =3D readl(base + USB_PORTSC1);
> -		val |=3D USB_PORTSC1_PHCD;
> -		writel(val, base + USB_PORTSC1);
> -	}
> -
> -	if (utmi_wait_register(base + USB_SUSP_CTRL, USB_PHY_CLK_VALID, 0) < 0)
> -		pr_err("%s: timeout waiting for phy to stabilize\n", __func__);
> -}
> -
> -static void utmi_phy_clk_enable(struct tegra_usb_phy *phy)
> -{
> -	unsigned long val;
> -	void __iomem *base =3D phy->regs;
> -
> -	if (phy->instance =3D=3D 0) {
> -		val =3D readl(base + USB_SUSP_CTRL);
> -		val |=3D USB_SUSP_CLR;
> -		writel(val, base + USB_SUSP_CTRL);
> -
> -		udelay(10);
> -
> -		val =3D readl(base + USB_SUSP_CTRL);
> -		val &=3D ~USB_SUSP_CLR;
> -		writel(val, base + USB_SUSP_CTRL);
> -	}
> -
> -	if (phy->instance =3D=3D 2) {
> -		val =3D readl(base + USB_PORTSC1);
> -		val &=3D ~USB_PORTSC1_PHCD;
> -		writel(val, base + USB_PORTSC1);
> -	}
> -
> -	if (utmi_wait_register(base + USB_SUSP_CTRL, USB_PHY_CLK_VALID,
> -						     USB_PHY_CLK_VALID))
> -		pr_err("%s: timeout waiting for phy to stabilize\n", __func__);
> -}
> -
> -static int utmi_phy_power_on(struct tegra_usb_phy *phy)
> -{
> -	unsigned long val;
> -	void __iomem *base =3D phy->regs;
> -	struct tegra_utmip_config *config =3D phy->config;
> -
> -	val =3D readl(base + USB_SUSP_CTRL);
> -	val |=3D UTMIP_RESET;
> -	writel(val, base + USB_SUSP_CTRL);
> -
> -	if (phy->instance =3D=3D 0) {
> -		val =3D readl(base + USB1_LEGACY_CTRL);
> -		val |=3D USB1_NO_LEGACY_MODE;
> -		writel(val, base + USB1_LEGACY_CTRL);
> -	}
> -
> -	val =3D readl(base + UTMIP_TX_CFG0);
> -	val &=3D ~UTMIP_FS_PREABMLE_J;
> -	writel(val, base + UTMIP_TX_CFG0);
> -
> -	val =3D readl(base + UTMIP_HSRX_CFG0);
> -	val &=3D ~(UTMIP_IDLE_WAIT(~0) | UTMIP_ELASTIC_LIMIT(~0));
> -	val |=3D UTMIP_IDLE_WAIT(config->idle_wait_delay);
> -	val |=3D UTMIP_ELASTIC_LIMIT(config->elastic_limit);
> -	writel(val, base + UTMIP_HSRX_CFG0);
> -
> -	val =3D readl(base + UTMIP_HSRX_CFG1);
> -	val &=3D ~UTMIP_HS_SYNC_START_DLY(~0);
> -	val |=3D UTMIP_HS_SYNC_START_DLY(config->hssync_start_delay);
> -	writel(val, base + UTMIP_HSRX_CFG1);
> -
> -	val =3D readl(base + UTMIP_DEBOUNCE_CFG0);
> -	val &=3D ~UTMIP_BIAS_DEBOUNCE_A(~0);
> -	val |=3D UTMIP_BIAS_DEBOUNCE_A(phy->freq->debounce);
> -	writel(val, base + UTMIP_DEBOUNCE_CFG0);
> -
> -	val =3D readl(base + UTMIP_MISC_CFG0);
> -	val &=3D ~UTMIP_SUSPEND_EXIT_ON_EDGE;
> -	writel(val, base + UTMIP_MISC_CFG0);
> -
> -	val =3D readl(base + UTMIP_MISC_CFG1);
> -	val &=3D ~(UTMIP_PLL_ACTIVE_DLY_COUNT(~0) | UTMIP_PLLU_STABLE_COUNT(~0)=
);
> -	val |=3D UTMIP_PLL_ACTIVE_DLY_COUNT(phy->freq->active_delay) |
> -		UTMIP_PLLU_STABLE_COUNT(phy->freq->stable_count);
> -	writel(val, base + UTMIP_MISC_CFG1);
> -
> -	val =3D readl(base + UTMIP_PLL_CFG1);
> -	val &=3D ~(UTMIP_XTAL_FREQ_COUNT(~0) | UTMIP_PLLU_ENABLE_DLY_COUNT(~0));
> -	val |=3D UTMIP_XTAL_FREQ_COUNT(phy->freq->xtal_freq_count) |
> -		UTMIP_PLLU_ENABLE_DLY_COUNT(phy->freq->enable_delay);
> -	writel(val, base + UTMIP_PLL_CFG1);
> -
> -	if (phy->mode =3D=3D TEGRA_USB_PHY_MODE_DEVICE) {
> -		val =3D readl(base + USB_SUSP_CTRL);
> -		val &=3D ~(USB_WAKE_ON_CNNT_EN_DEV | USB_WAKE_ON_DISCON_EN_DEV);
> -		writel(val, base + USB_SUSP_CTRL);
> -	}
> -
> -	utmip_pad_power_on(phy);
> -
> -	val =3D readl(base + UTMIP_XCVR_CFG0);
> -	val &=3D ~(UTMIP_FORCE_PD_POWERDOWN | UTMIP_FORCE_PD2_POWERDOWN |
> -		 UTMIP_FORCE_PDZI_POWERDOWN | UTMIP_XCVR_SETUP(~0) |
> -		 UTMIP_XCVR_LSFSLEW(~0) | UTMIP_XCVR_LSRSLEW(~0) |
> -		 UTMIP_XCVR_HSSLEW_MSB(~0));
> -	val |=3D UTMIP_XCVR_SETUP(config->xcvr_setup);
> -	val |=3D UTMIP_XCVR_LSFSLEW(config->xcvr_lsfslew);
> -	val |=3D UTMIP_XCVR_LSRSLEW(config->xcvr_lsrslew);
> -	writel(val, base + UTMIP_XCVR_CFG0);
> -
> -	val =3D readl(base + UTMIP_XCVR_CFG1);
> -	val &=3D ~(UTMIP_FORCE_PDDISC_POWERDOWN | UTMIP_FORCE_PDCHRP_POWERDOWN |
> -		 UTMIP_FORCE_PDDR_POWERDOWN | UTMIP_XCVR_TERM_RANGE_ADJ(~0));
> -	val |=3D UTMIP_XCVR_TERM_RANGE_ADJ(config->term_range_adj);
> -	writel(val, base + UTMIP_XCVR_CFG1);
> -
> -	val =3D readl(base + UTMIP_BAT_CHRG_CFG0);
> -	val &=3D ~UTMIP_PD_CHRG;
> -	writel(val, base + UTMIP_BAT_CHRG_CFG0);
> -
> -	val =3D readl(base + UTMIP_BIAS_CFG1);
> -	val &=3D ~UTMIP_BIAS_PDTRK_COUNT(~0);
> -	val |=3D UTMIP_BIAS_PDTRK_COUNT(0x5);
> -	writel(val, base + UTMIP_BIAS_CFG1);
> -
> -	if (phy->instance =3D=3D 0) {
> -		val =3D readl(base + UTMIP_SPARE_CFG0);
> -		if (phy->mode =3D=3D TEGRA_USB_PHY_MODE_DEVICE)
> -			val &=3D ~FUSE_SETUP_SEL;
> -		else
> -			val |=3D FUSE_SETUP_SEL;
> -		writel(val, base + UTMIP_SPARE_CFG0);
> -	}
> -
> -	if (phy->instance =3D=3D 2) {
> -		val =3D readl(base + USB_SUSP_CTRL);
> -		val |=3D UTMIP_PHY_ENABLE;
> -		writel(val, base + USB_SUSP_CTRL);
> -	}
> -
> -	val =3D readl(base + USB_SUSP_CTRL);
> -	val &=3D ~UTMIP_RESET;
> -	writel(val, base + USB_SUSP_CTRL);
> -
> -	if (phy->instance =3D=3D 0) {
> -		val =3D readl(base + USB1_LEGACY_CTRL);
> -		val &=3D ~USB1_VBUS_SENSE_CTL_MASK;
> -		val |=3D USB1_VBUS_SENSE_CTL_A_SESS_VLD;
> -		writel(val, base + USB1_LEGACY_CTRL);
> -
> -		val =3D readl(base + USB_SUSP_CTRL);
> -		val &=3D ~USB_SUSP_SET;
> -		writel(val, base + USB_SUSP_CTRL);
> -	}
> -
> -	utmi_phy_clk_enable(phy);
> -
> -	if (phy->instance =3D=3D 2) {
> -		val =3D readl(base + USB_PORTSC1);
> -		val &=3D ~USB_PORTSC1_PTS(~0);
> -		writel(val, base + USB_PORTSC1);
> -	}
> -
> -	return 0;
> -}
> -
> -static int utmi_phy_power_off(struct tegra_usb_phy *phy)
> -{
> -	unsigned long val;
> -	void __iomem *base =3D phy->regs;
> -
> -	utmi_phy_clk_disable(phy);
> -
> -	if (phy->mode =3D=3D TEGRA_USB_PHY_MODE_DEVICE) {
> -		val =3D readl(base + USB_SUSP_CTRL);
> -		val &=3D ~USB_WAKEUP_DEBOUNCE_COUNT(~0);
> -		val |=3D USB_WAKE_ON_CNNT_EN_DEV | USB_WAKEUP_DEBOUNCE_COUNT(5);
> -		writel(val, base + USB_SUSP_CTRL);
> -	}
> -
> -	val =3D readl(base + USB_SUSP_CTRL);
> -	val |=3D UTMIP_RESET;
> -	writel(val, base + USB_SUSP_CTRL);
> -
> -	val =3D readl(base + UTMIP_BAT_CHRG_CFG0);
> -	val |=3D UTMIP_PD_CHRG;
> -	writel(val, base + UTMIP_BAT_CHRG_CFG0);
> -
> -	val =3D readl(base + UTMIP_XCVR_CFG0);
> -	val |=3D UTMIP_FORCE_PD_POWERDOWN | UTMIP_FORCE_PD2_POWERDOWN |
> -	       UTMIP_FORCE_PDZI_POWERDOWN;
> -	writel(val, base + UTMIP_XCVR_CFG0);
> -
> -	val =3D readl(base + UTMIP_XCVR_CFG1);
> -	val |=3D UTMIP_FORCE_PDDISC_POWERDOWN | UTMIP_FORCE_PDCHRP_POWERDOWN |
> -	       UTMIP_FORCE_PDDR_POWERDOWN;
> -	writel(val, base + UTMIP_XCVR_CFG1);
> -
> -	return utmip_pad_power_off(phy);
> -}
> -
> -static void utmi_phy_preresume(struct tegra_usb_phy *phy)
> -{
> -	unsigned long val;
> -	void __iomem *base =3D phy->regs;
> -
> -	val =3D readl(base + UTMIP_TX_CFG0);
> -	val |=3D UTMIP_HS_DISCON_DISABLE;
> -	writel(val, base + UTMIP_TX_CFG0);
> -}
> -
> -static void utmi_phy_postresume(struct tegra_usb_phy *phy)
> -{
> -	unsigned long val;
> -	void __iomem *base =3D phy->regs;
> -
> -	val =3D readl(base + UTMIP_TX_CFG0);
> -	val &=3D ~UTMIP_HS_DISCON_DISABLE;
> -	writel(val, base + UTMIP_TX_CFG0);
> -}
> -
> -static void utmi_phy_restore_start(struct tegra_usb_phy *phy,
> -				   enum tegra_usb_phy_port_speed port_speed)
> -{
> -	unsigned long val;
> -	void __iomem *base =3D phy->regs;
> -
> -	val =3D readl(base + UTMIP_MISC_CFG0);
> -	val &=3D ~UTMIP_DPDM_OBSERVE_SEL(~0);
> -	if (port_speed =3D=3D TEGRA_USB_PHY_PORT_SPEED_LOW)
> -		val |=3D UTMIP_DPDM_OBSERVE_SEL_FS_K;
> -	else
> -		val |=3D UTMIP_DPDM_OBSERVE_SEL_FS_J;
> -	writel(val, base + UTMIP_MISC_CFG0);
> -	udelay(1);
> -
> -	val =3D readl(base + UTMIP_MISC_CFG0);
> -	val |=3D UTMIP_DPDM_OBSERVE;
> -	writel(val, base + UTMIP_MISC_CFG0);
> -	udelay(10);
> -}
> -
> -static void utmi_phy_restore_end(struct tegra_usb_phy *phy)
> -{
> -	unsigned long val;
> -	void __iomem *base =3D phy->regs;
> -
> -	val =3D readl(base + UTMIP_MISC_CFG0);
> -	val &=3D ~UTMIP_DPDM_OBSERVE;
> -	writel(val, base + UTMIP_MISC_CFG0);
> -	udelay(10);
> -}
> -
> -static int ulpi_phy_power_on(struct tegra_usb_phy *phy)
> -{
> -	int ret;
> -	unsigned long val;
> -	void __iomem *base =3D phy->regs;
> -	struct tegra_ulpi_config *config =3D phy->config;
> -
> -	gpio_direction_output(config->reset_gpio, 0);
> -	msleep(5);
> -	gpio_direction_output(config->reset_gpio, 1);
> -
> -	clk_prepare_enable(phy->clk);
> -	msleep(1);
> -
> -	val =3D readl(base + USB_SUSP_CTRL);
> -	val |=3D UHSIC_RESET;
> -	writel(val, base + USB_SUSP_CTRL);
> -
> -	val =3D readl(base + ULPI_TIMING_CTRL_0);
> -	val |=3D ULPI_OUTPUT_PINMUX_BYP | ULPI_CLKOUT_PINMUX_BYP;
> -	writel(val, base + ULPI_TIMING_CTRL_0);
> -
> -	val =3D readl(base + USB_SUSP_CTRL);
> -	val |=3D ULPI_PHY_ENABLE;
> -	writel(val, base + USB_SUSP_CTRL);
> -
> -	val =3D 0;
> -	writel(val, base + ULPI_TIMING_CTRL_1);
> -
> -	val |=3D ULPI_DATA_TRIMMER_SEL(4);
> -	val |=3D ULPI_STPDIRNXT_TRIMMER_SEL(4);
> -	val |=3D ULPI_DIR_TRIMMER_SEL(4);
> -	writel(val, base + ULPI_TIMING_CTRL_1);
> -	udelay(10);
> -
> -	val |=3D ULPI_DATA_TRIMMER_LOAD;
> -	val |=3D ULPI_STPDIRNXT_TRIMMER_LOAD;
> -	val |=3D ULPI_DIR_TRIMMER_LOAD;
> -	writel(val, base + ULPI_TIMING_CTRL_1);
> -
> -	/* Fix VbusInvalid due to floating VBUS */
> -	ret =3D usb_phy_io_write(phy->ulpi, 0x40, 0x08);
> -	if (ret) {
> -		pr_err("%s: ulpi write failed\n", __func__);
> -		return ret;
> -	}
> -
> -	ret =3D usb_phy_io_write(phy->ulpi, 0x80, 0x0B);
> -	if (ret) {
> -		pr_err("%s: ulpi write failed\n", __func__);
> -		return ret;
> -	}
> -
> -	val =3D readl(base + USB_PORTSC1);
> -	val |=3D USB_PORTSC1_WKOC | USB_PORTSC1_WKDS | USB_PORTSC1_WKCN;
> -	writel(val, base + USB_PORTSC1);
> -
> -	val =3D readl(base + USB_SUSP_CTRL);
> -	val |=3D USB_SUSP_CLR;
> -	writel(val, base + USB_SUSP_CTRL);
> -	udelay(100);
> -
> -	val =3D readl(base + USB_SUSP_CTRL);
> -	val &=3D ~USB_SUSP_CLR;
> -	writel(val, base + USB_SUSP_CTRL);
> -
> -	return 0;
> -}
> -
> -static int ulpi_phy_power_off(struct tegra_usb_phy *phy)
> -{
> -	unsigned long val;
> -	void __iomem *base =3D phy->regs;
> -	struct tegra_ulpi_config *config =3D phy->config;
> -
> -	/* Clear WKCN/WKDS/WKOC wake-on events that can cause the USB
> -	 * Controller to immediately bring the ULPI PHY out of low power
> -	 */
> -	val =3D readl(base + USB_PORTSC1);
> -	val &=3D ~(USB_PORTSC1_WKOC | USB_PORTSC1_WKDS | USB_PORTSC1_WKCN);
> -	writel(val, base + USB_PORTSC1);
> -
> -	clk_disable(phy->clk);
> -	return gpio_direction_output(config->reset_gpio, 0);
> -}
> -
> -static int	tegra_phy_init(struct usb_phy *x)
> +static int tegra_phy_init(struct usb_phy *x)
>  {
>  	struct tegra_usb_phy *phy =3D container_of(x, struct tegra_usb_phy, u_p=
hy);
> -	struct tegra_ulpi_config *ulpi_config;
> -	int err;
> =20
> -	if (phy_is_ulpi(phy)) {
> -		ulpi_config =3D phy->config;
> -		phy->clk =3D clk_get_sys(NULL, ulpi_config->clk);
> -		if (IS_ERR(phy->clk)) {
> -			pr_err("%s: can't get ulpi clock\n", __func__);
> -			err =3D -ENXIO;
> -			goto err1;
> -		}
> -		if (!gpio_is_valid(ulpi_config->reset_gpio))
> -			ulpi_config->reset_gpio =3D
> -				of_get_named_gpio(phy->dev->of_node,
> -						  "nvidia,phy-reset-gpio", 0);
> -		if (!gpio_is_valid(ulpi_config->reset_gpio)) {
> -			pr_err("%s: invalid reset gpio: %d\n", __func__,
> -			       ulpi_config->reset_gpio);
> -			err =3D -EINVAL;
> -			goto err1;
> -		}
> -		gpio_request(ulpi_config->reset_gpio, "ulpi_phy_reset_b");
> -		gpio_direction_output(ulpi_config->reset_gpio, 0);
> -		phy->ulpi =3D otg_ulpi_create(&ulpi_viewport_access_ops, 0);
> -		phy->ulpi->io_priv =3D phy->regs + ULPI_VIEWPORT;
> -	} else {
> -		err =3D utmip_pad_open(phy);
> -		if (err < 0)
> -			goto err1;
> -	}
> -	return 0;
> -err1:
> -	clk_disable_unprepare(phy->pll_u);
> -	clk_put(phy->pll_u);
> -	return err;
> +	return phy->ops.open(phy);
>  }
> =20
>  static void tegra_usb_phy_close(struct usb_phy *x)
>  {
>  	struct tegra_usb_phy *phy =3D container_of(x, struct tegra_usb_phy, u_p=
hy);
> =20
> -	if (phy_is_ulpi(phy))
> -		clk_put(phy->clk);
> -	else
> -		utmip_pad_close(phy);
> -	clk_disable_unprepare(phy->pll_u);
> -	clk_put(phy->pll_u);
> -	kfree(phy);
> -}
> -
> -static int tegra_usb_phy_power_on(struct tegra_usb_phy *phy)
> -{
> -	if (phy_is_ulpi(phy))
> -		return ulpi_phy_power_on(phy);
> -	else
> -		return utmi_phy_power_on(phy);
> -}
> -
> -static int tegra_usb_phy_power_off(struct tegra_usb_phy *phy)
> -{
> -	if (phy_is_ulpi(phy))
> -		return ulpi_phy_power_off(phy);
> -	else
> -		return utmi_phy_power_off(phy);
> +	phy->ops.close(phy);
>  }
> =20
>  static int	tegra_usb_phy_suspend(struct usb_phy *x, int suspend)
>  {
>  	struct tegra_usb_phy *phy =3D container_of(x, struct tegra_usb_phy, u_p=
hy);
> -	if (suspend)
> -		return tegra_usb_phy_power_off(phy);
> -	else
> -		return tegra_usb_phy_power_on(phy);
> +
> +	if (suspend) {
> +		if (phy->ops.power_off)
> +			return phy->ops.power_off(phy);
> +	} else if (phy->ops.power_on)
> +		return phy->ops.power_on(phy);
> +
> +	return 0;
>  }
> =20
>  struct tegra_usb_phy *tegra_usb_phy_open(struct device *dev, int instanc=
e,
> -	void __iomem *regs, void *config, enum tegra_usb_phy_mode phy_mode)
> +	void __iomem *regs, struct phy_params *params)
>  {
>  	struct tegra_usb_phy *phy;
>  	unsigned long parent_rate;
>  	int i;
>  	int err;
> =20
> -	phy =3D kmalloc(sizeof(struct tegra_usb_phy), GFP_KERNEL);
> +	phy =3D devm_kzalloc(dev, sizeof(struct tegra_usb_phy), GFP_KERNEL);
>  	if (!phy)
>  		return ERR_PTR(-ENOMEM);
> =20
>  	phy->instance =3D instance;
>  	phy->regs =3D regs;
> -	phy->config =3D config;
> -	phy->mode =3D phy_mode;
> +	phy->config =3D params->config;
> +	phy->mode =3D params->mode;
>  	phy->dev =3D dev;
> +	phy->type =3D params->type;
> =20
>  	if (!phy->config) {
> -		if (phy_is_ulpi(phy)) {
> +		if (params->type =3D=3D TEGRA_USB_PHY_TYPE_ULPI) {
>  			pr_err("%s: ulpi phy configuration missing", __func__);
>  			err =3D -EINVAL;
>  			goto err0;
> @@ -781,6 +129,12 @@ struct tegra_usb_phy *tegra_usb_phy_open(struct devi=
ce *dev, int instance,
>  		goto err1;
>  	}
> =20
> +	err =3D tegra2_usb_phy_init(phy);
> +	if (err < 0) {
> +		pr_err("phy type %d is not supported\n", phy->type);
> +		goto err1;
> +	}
> +
>  	phy->u_phy.init =3D tegra_phy_init;
>  	phy->u_phy.shutdown =3D tegra_usb_phy_close;
>  	phy->u_phy.set_suspend =3D tegra_usb_phy_suspend;
> @@ -791,50 +145,35 @@ err1:
>  	clk_disable_unprepare(phy->pll_u);
>  	clk_put(phy->pll_u);
>  err0:
> -	kfree(phy);
>  	return ERR_PTR(err);
>  }
>  EXPORT_SYMBOL_GPL(tegra_usb_phy_open);
> =20
>  void tegra_usb_phy_preresume(struct tegra_usb_phy *phy)
>  {
> -	if (!phy_is_ulpi(phy))
> -		utmi_phy_preresume(phy);
> +	if (phy->ops.preresume)
> +		phy->ops.preresume(phy);
>  }
>  EXPORT_SYMBOL_GPL(tegra_usb_phy_preresume);
> =20
>  void tegra_usb_phy_postresume(struct tegra_usb_phy *phy)
>  {
> -	if (!phy_is_ulpi(phy))
> -		utmi_phy_postresume(phy);
> +	if (phy->ops.postresume)
> +		phy->ops.postresume(phy);
>  }
>  EXPORT_SYMBOL_GPL(tegra_usb_phy_postresume);
> =20
>  void tegra_ehci_phy_restore_start(struct tegra_usb_phy *phy,
>  				 enum tegra_usb_phy_port_speed port_speed)
>  {
> -	if (!phy_is_ulpi(phy))
> -		utmi_phy_restore_start(phy, port_speed);
> +	if (phy->ops.restore_start)
> +		phy->ops.restore_start(phy, port_speed);
>  }
>  EXPORT_SYMBOL_GPL(tegra_ehci_phy_restore_start);
> =20
>  void tegra_ehci_phy_restore_end(struct tegra_usb_phy *phy)
>  {
> -	if (!phy_is_ulpi(phy))
> -		utmi_phy_restore_end(phy);
> +	if (phy->ops.restore_end)
> +		phy->ops.restore_end(phy);
>  }
>  EXPORT_SYMBOL_GPL(tegra_ehci_phy_restore_end);
> -
> -void tegra_usb_phy_clk_disable(struct tegra_usb_phy *phy)
> -{
> -	if (!phy_is_ulpi(phy))
> -		utmi_phy_clk_disable(phy);
> -}
> -EXPORT_SYMBOL_GPL(tegra_usb_phy_clk_disable);
> -
> -void tegra_usb_phy_clk_enable(struct tegra_usb_phy *phy)
> -{
> -	if (!phy_is_ulpi(phy))
> -		utmi_phy_clk_enable(phy);
> -}
> -EXPORT_SYMBOL_GPL(tegra_usb_phy_clk_enable);
> diff --git a/include/linux/usb/tegra_usb_phy.h b/include/linux/usb/tegra_=
usb_phy.h
> index 176b1ca..c27705b 100644
> --- a/include/linux/usb/tegra_usb_phy.h
> +++ b/include/linux/usb/tegra_usb_phy.h
> @@ -44,8 +44,34 @@ enum tegra_usb_phy_mode {
>  	TEGRA_USB_PHY_MODE_HOST,
>  };
> =20
> +enum tegra_usb_phy_type {
> +	TEGRA_USB_PHY_TYPE_UTMI =3D 0,
> +	TEGRA_USB_PHY_TYPE_ULPI,
> +	TEGRA_USB_PHY_TYPE_INVALID,
> +};
> +
> +struct tegra_usb_phy;
> +
> +struct usb_phy_ops {
> +	int (*open)(struct tegra_usb_phy *phy);
> +	void (*close)(struct tegra_usb_phy *phy);
> +	int (*power_on)(struct tegra_usb_phy *phy);
> +	int (*power_off)(struct tegra_usb_phy *phy);
> +	void (*preresume)(struct tegra_usb_phy *phy);
> +	void (*postresume)(struct tegra_usb_phy *phy);
> +	void (*restore_start)(struct tegra_usb_phy *phy,
> +				   enum tegra_usb_phy_port_speed port_speed);
> +	void (*restore_end)(struct tegra_usb_phy *phy);
> +};
> +
>  struct tegra_xtal_freq;
> =20
> +struct phy_params {
> +	void *config;
> +	enum tegra_usb_phy_mode mode;
> +	enum tegra_usb_phy_type type;
> +};
> +
>  struct tegra_usb_phy {
>  	int instance;
>  	const struct tegra_xtal_freq *freq;
> @@ -58,15 +84,13 @@ struct tegra_usb_phy {
>  	void *config;
>  	struct usb_phy *ulpi;
>  	struct usb_phy u_phy;
> +	struct usb_phy_ops ops;
> +	enum tegra_usb_phy_type type;
>  	struct device *dev;
>  };
> =20
>  struct tegra_usb_phy *tegra_usb_phy_open(struct device *dev, int instanc=
e,
> -	void __iomem *regs, void *config, enum tegra_usb_phy_mode phy_mode);
> -
> -void tegra_usb_phy_clk_disable(struct tegra_usb_phy *phy);
> -
> -void tegra_usb_phy_clk_enable(struct tegra_usb_phy *phy);
> +	void __iomem *regs, struct phy_params *params);
> =20
>  void tegra_usb_phy_preresume(struct tegra_usb_phy *phy);
> =20
> --=20
> 1.7.0.4
>=20

--=20
balbi

--YH9Qf6Fh2G5kB/85
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQgSwlAAoJEIaOsuA1yqREk5QP/jcisSS3temYTwldfNjnxT05
s8komcMBRpSXiagU6t5XwkbM8Z9voJ7qu6yndzXsWgS1pb5J0pvHFndrgnr9eYO0
jAw+5+E9dX6MKr34+XfzI83il2fjDMiMs1heFTHNc+WW3o5DaK0pngiPQx7U5AaV
TyN01GEMOvm1JRk/3T10uoxaawJWfVRG/MZyVjo/tKYXznvgnCcTdXrUOO06ZLZE
kRAwpaLbcjmWJfGUmRTtRxeV9uRxrs5ULMfAPFr+efPrKfJm8J7tocb04TlxOb5b
nY01+DFR8JVBs1Uep4WHBFjQp+XG+bPbYJlIVtUuNIiCgflrxGQuQXNUf5tky3qR
7AHTGvr7/L2g9wPnzoaOi0k9Zgr94/Jf5HgVf548+/Mq7EVQMV9cCq9/gF9el3Vr
ihhQuLPPXKdVJcgCFGPSQQ41nIdhpCCY6M6cFkujrEqQFkn9OMemWLGo+9tIQ3SR
taq2UtslglhU/ZMkgCt8/zczpOCK8yz1yQRnLkalxvT6AYSMR2W2YDCaAb3sBQZ9
NkVV16S38ZS4NDu8XWgMkwYMRr0+M6DIGdNDHKnsYF6V6FaI0LloPOK/G3oCEtGu
VOzDWt5dPmb6CssjzR1kgkJcumuBRIOtM0s//FQMSV4omzhJrvfNG1bO/hA2W3mm
duaj7moXZACGfylptqF+
=aiSp
-----END PGP SIGNATURE-----

--YH9Qf6Fh2G5kB/85--

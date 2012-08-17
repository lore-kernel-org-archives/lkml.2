Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349Ab2HQPdz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 11:33:55 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59530 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932205Ab2HQPdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 11:33:45 -0400
Message-ID: <502E6453.7010500@gmail.com>
Date: Fri, 17 Aug 2012 10:33:39 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Mark Langsdorf <mark.langsdorf@calxeda.com>
CC: jgarzik@pobox.com, linux-ide@vger.kernel.org, probinson@gmail.com,
        jonathon@jonmasters.org, dmarlin@redhat.com,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ahci_platform: add custom hard reset for Calxeda
 ahci ctrlr
References: <1345215111-11051-1-git-send-email-mark.langsdorf@calxeda.com> <1345215111-11051-3-git-send-email-mark.langsdorf@calxeda.com>
In-Reply-To: <1345215111-11051-3-git-send-email-mark.langsdorf@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+devicetree-discuss and lkml

On 08/17/2012 09:51 AM, Mark Langsdorf wrote:
> Calxeda highbank SATA phy has intermittent problems bringing up a link
> with Gen3 drives. Retrying the phy hard reset can work-around this issue,
> but each reset also disables spread spectrum support. The reset function
> also needs to reprogram the phy to enable spread spectrum support.
> 
> Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> ---
>  .../devicetree/bindings/arm/calxeda/combophy.txt   |   17 ++
>  .../devicetree/bindings/ata/ahci-platform.txt      |    8 +
>  arch/arm/boot/dts/highbank.dts                     |   17 ++

New bindings need to go to devicetree-discuss/lkml...

One comment below

>  drivers/ata/Makefile                               |    1 +
>  drivers/ata/ahci.h                                 |   17 ++
>  drivers/ata/ahci_platform.c                        |   88 ++++++++-
>  drivers/ata/sata_highbank.c                        |  199 ++++++++++++++++++++
>  7 files changed, 339 insertions(+), 8 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/arm/calxeda/combophy.txt
>  create mode 100644 drivers/ata/sata_highbank.c
> 
> diff --git a/Documentation/devicetree/bindings/arm/calxeda/combophy.txt b/Documentation/devicetree/bindings/arm/calxeda/combophy.txt
> new file mode 100644
> index 0000000..6622bdb
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/calxeda/combophy.txt
> @@ -0,0 +1,17 @@
> +Calxeda Highbank Combination Phys for SATA
> +
> +Properties:
> +- compatible : Should be "calxeda,hb-combophy"
> +- #phy-cells: Should be 1.
> +- reg : Address and size for Combination Phy registers.
> +- phydev: device ID for programming the combophy.
> +
> +Example:
> +
> +	combophy5: combo-phy@fff5d000 {
> +		compatible = "calxeda,hb-combophy";
> +		#phy-cells = <1>;
> +		reg = <0xfff5d000 0x1000>;
> +		phydev = <31>;
> +	};
> +
> diff --git a/Documentation/devicetree/bindings/ata/ahci-platform.txt b/Documentation/devicetree/bindings/ata/ahci-platform.txt
> index 8bb8a76..147c1f6 100644
> --- a/Documentation/devicetree/bindings/ata/ahci-platform.txt
> +++ b/Documentation/devicetree/bindings/ata/ahci-platform.txt
> @@ -8,9 +8,17 @@ Required properties:
>  - interrupts        : <interrupt mapping for SATA IRQ>
>  - reg               : <registers mapping>
>  
> +Optional properties:
> +- calxeda,port-phys: phandle-combophy and lane assignment, which maps each
> +			SATA port to a combophy and a lane within that
> +			combophy
> +
>  Example:
>          sata@ffe08000 {
>  		compatible = "calxeda,hb-ahci";
>                  reg = <0xffe08000 0x1000>;
>                  interrupts = <115>;
> +		calxeda,port-phys = <&combophy5 0 &combophy0 0 &combophy0 1
> +					&combophy0 2 &combophy0 3>;
> +
>          };
> diff --git a/arch/arm/boot/dts/highbank.dts b/arch/arm/boot/dts/highbank.dts
> index 9fecf1a..5204cf7 100644
> --- a/arch/arm/boot/dts/highbank.dts
> +++ b/arch/arm/boot/dts/highbank.dts
> @@ -121,6 +121,9 @@
>  			compatible = "calxeda,hb-ahci";
>  			reg = <0xffe08000 0x10000>;
>  			interrupts = <0 83 4>;
> +			calxeda,port-phys = <&combophy5 0 &combophy0 0
> +					     &combophy0 1 &combophy0 2
> +					     &combophy0 3>;
>  		};
>  
>  		sdhci@ffe0e000 {
> @@ -306,5 +309,19 @@
>  			reg = <0xfff51000 0x1000>;
>  			interrupts = <0 80 4  0 81 4  0 82 4>;
>  		};
> +
> +		combophy0: combo-phy@fff58000 {
> +			compatible = "calxeda,hb-combophy";
> +			#phy-cells = <1>;
> +			reg = <0xfff58000 0x1000>;
> +			phydev = <5>;
> +		};
> +
> +		combophy5: combo-phy@fff5d000 {
> +			compatible = "calxeda,hb-combophy";
> +			#phy-cells = <1>;
> +			reg = <0xfff5d000 0x1000>;
> +			phydev = <31>;
> +		};
>  	};
>  };
> diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
> index a454a13..1e57f10 100644
> --- a/drivers/ata/Makefile
> +++ b/drivers/ata/Makefile
> @@ -9,6 +9,7 @@ obj-$(CONFIG_SATA_FSL)		+= sata_fsl.o
>  obj-$(CONFIG_SATA_INIC162X)	+= sata_inic162x.o
>  obj-$(CONFIG_SATA_SIL24)	+= sata_sil24.o
>  obj-$(CONFIG_SATA_DWC)		+= sata_dwc_460ex.o
> +obj-$(CONFIG_ARCH_HIGHBANK)	+= sata_highbank.o
>  
>  # SFF w/ custom DMA
>  obj-$(CONFIG_PDC_ADMA)		+= pdc_adma.o
> diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
> index 57eb1c2..8a9a702 100644
> --- a/drivers/ata/ahci.h
> +++ b/drivers/ata/ahci.h
> @@ -364,4 +364,21 @@ static inline int ahci_nr_ports(u32 cap)
>  	return (cap & 0x1f) + 1;
>  }
>  
> +#ifdef CONFIG_ARCH_HIGHBANK
> +void calxeda_cphy_override_lane(u8 sata_port);
> +void calxeda_cphy_disable_overrides(u8 sata_port);
> +int calxeda_initialize_phys(struct device *dev, void __iomem *addr);
> +#else
> +void calxeda_cphy_override_lane(u8 sata_port)
> +{
> +}
> +void calxeda_cphy_disable_overrides(u8 sata_port)
> +{
> +}
> +int calxeda_initialize_phys(struct device *dev, void __iomem *addr)
> +{
> +	return 0;
> +}
> +#endif
> +
>  #endif /* _AHCI_H */
> diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
> index 09728e0..25abb08 100644
> --- a/drivers/ata/ahci_platform.c
> +++ b/drivers/ata/ahci_platform.c
> @@ -19,6 +19,7 @@
>  #include <linux/init.h>
>  #include <linux/interrupt.h>
>  #include <linux/device.h>
> +#include <linux/of_device.h>
>  #include <linux/platform_device.h>
>  #include <linux/libata.h>
>  #include <linux/ahci_platform.h>
> @@ -27,6 +28,7 @@
>  enum ahci_type {
>  	AHCI,		/* standard platform ahci */
>  	IMX53_AHCI,	/* ahci on i.mx53 */
> +	CALXEDA_AHCI,
>  	STRICT_AHCI,	/* delayed DMA engine start */
>  };
>  
> @@ -38,6 +40,9 @@ static struct platform_device_id ahci_devtype[] = {
>  		.name = "imx53-ahci",
>  		.driver_data = IMX53_AHCI,
>  	}, {
> +		.name = "hb-ahci",
> +		.driver_data = CALXEDA_AHCI,
> +	}, {
>  		.name = "strict-ahci",
>  		.driver_data = STRICT_AHCI,
>  	}, {
> @@ -46,6 +51,52 @@ static struct platform_device_id ahci_devtype[] = {
>  };
>  MODULE_DEVICE_TABLE(platform, ahci_devtype);
>  
> +static int ahci_calxeda_hardreset(struct ata_link *link, unsigned int *class,
> +				unsigned long deadline)
> +{
> +	const unsigned long *timing = sata_ehc_deb_timing(&link->eh_context);
> +	struct ata_port *ap = link->ap;
> +	struct ahci_port_priv *pp = ap->private_data;
> +	u8 *d2h_fis = pp->rx_fis + RX_FIS_D2H_REG;
> +	struct ata_taskfile tf;
> +	bool online;
> +	u32 sstatus;
> +	int rc;
> +	int retry = 10;
> +
> +	ahci_stop_engine(ap);
> +
> +	/* clear D2H reception area to properly wait for D2H FIS */
> +	ata_tf_init(link->device, &tf);
> +	tf.command = 0x80;
> +	ata_tf_to_fis(&tf, 0, 0, d2h_fis);
> +
> +	do {
> +		calxeda_cphy_disable_overrides(link->ap->port_no);
> +		rc = sata_link_hardreset(link, timing, deadline, &online, NULL);
> +		calxeda_cphy_override_lane(link->ap->port_no);
> +
> +		/* If the status is 1, we are connected, but the link did not
> +		 * come up. So retry resetting the link again.
> +		 */
> +		if (sata_scr_read(link, SCR_STATUS, &sstatus))
> +			break;
> +		if (!(sstatus & 0x3))
> +			break;
> +	} while (!online && retry--);
> +
> +	ahci_start_engine(ap);
> +
> +	if (online)
> +		*class = ahci_dev_classify(ap);
> +
> +	return rc;
> +}
> +
> +static struct ata_port_operations ahci_calxeda_ops = {
> +	.inherits		= &ahci_ops,
> +	.hardreset		= ahci_calxeda_hardreset,
> +};
>  
>  static const struct ata_port_info ahci_port_info[] = {
>  	/* by features */
> @@ -61,6 +112,12 @@ static const struct ata_port_info ahci_port_info[] = {
>  		.udma_mask	= ATA_UDMA6,
>  		.port_ops	= &ahci_pmp_retry_srst_ops,
>  	},
> +	[CALXEDA_AHCI] = {
> +		.flags          = AHCI_FLAG_COMMON,
> +		.pio_mask       = ATA_PIO4,
> +		.udma_mask      = ATA_UDMA6,
> +		.port_ops       = &ahci_calxeda_ops,
> +	},
>  	[STRICT_AHCI] = {
>  		AHCI_HFLAGS	(AHCI_HFLAG_DELAY_ENGINE),
>  		.flags		= AHCI_FLAG_COMMON,
> @@ -70,25 +127,47 @@ static const struct ata_port_info ahci_port_info[] = {
>  	},
>  };
>  
> +static struct ahci_platform_data calxeda_platdata = {
> +	.init = calxeda_initialize_phys,
> +	.ata_port_info = &ahci_port_info[CALXEDA_AHCI],
> +};
> +
> +
>  static struct scsi_host_template ahci_platform_sht = {
>  	AHCI_SHT("ahci_platform"),
>  };
>  
> +static const struct of_device_id ahci_of_match[] = {
> +	{ .compatible = "calxeda,hb-ahci",
> +	  .data = &calxeda_platdata, },
> +	{ .compatible = "snps,spear-ahci", },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, ahci_of_match);
> +
>  static int __init ahci_probe(struct platform_device *pdev)
>  {
>  	struct device *dev = &pdev->dev;
>  	struct ahci_platform_data *pdata = dev_get_platdata(dev);
>  	const struct platform_device_id *id = platform_get_device_id(pdev);
> -	struct ata_port_info pi = ahci_port_info[id ? id->driver_data : 0];
> +	struct ata_port_info pi;
>  	const struct ata_port_info *ppi[] = { &pi, NULL };
>  	struct ahci_host_priv *hpriv;
>  	struct ata_host *host;
>  	struct resource *mem;
> +	const struct of_device_id *match;
>  	int irq;
>  	int n_ports;
>  	int i;
>  	int rc;
>  
> +	match = of_match_device(ahci_of_match, dev);
> +	if (match && match->data) {
> +			pdata = (struct ahci_platform_data *) match->data;
> +			pi = *((struct ata_port_info *) pdata->ata_port_info);
> +	} else
> +		pi = ahci_port_info[id ? id->driver_data : 0];
> +
>  	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (!mem) {
>  		dev_err(dev, "no mmio space\n");
> @@ -276,13 +355,6 @@ static int ahci_resume(struct device *dev)
>  
>  SIMPLE_DEV_PM_OPS(ahci_pm_ops, ahci_suspend, ahci_resume);
>  
> -static const struct of_device_id ahci_of_match[] = {
> -	{ .compatible = "calxeda,hb-ahci", },
> -	{ .compatible = "snps,spear-ahci", },
> -	{},
> -};
> -MODULE_DEVICE_TABLE(of, ahci_of_match);
> -
>  static struct platform_driver ahci_driver = {
>  	.remove = __devexit_p(ahci_remove),
>  	.driver = {
> diff --git a/drivers/ata/sata_highbank.c b/drivers/ata/sata_highbank.c
> new file mode 100644
> index 0000000..8266e4b
> --- /dev/null
> +++ b/drivers/ata/sata_highbank.c
> @@ -0,0 +1,199 @@
> +/*
> + * Copyright 2012 Calxeda, Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +#include <linux/kernel.h>
> +#include <linux/gfp.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/types.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/spinlock.h>
> +#include <linux/device.h>
> +#include <linux/of_device.h>
> +#include <linux/of_address.h>
> +#include <linux/ahci_platform.h>
> +#include <linux/interrupt.h>
> +#include <linux/delay.h>
> +#include <linux/export.h>
> +#include "ahci.h"
> +
> +#define CPHY_MAP(dev, addr) ((((dev) & 0x1f) << 7) | (((addr) >> 9) & 0x7f))
> +#define CPHY_ADDR(addr) (((addr) & 0x1ff) << 2)
> +#define SERDES_CR_CTL			0x80a0
> +#define SERDES_CR_ADDR			0x80a1
> +#define SERDES_CR_DATA			0x80a2
> +#define CR_BUSY				0x0001
> +#define CR_START			0x0001
> +#define CR_WR_RDN			0x0002
> +#define CPHY_RX_INPUT_STS		0x2002
> +#define CPHY_SATA_OVERRIDE	 	0x4000
> +#define CPHY_OVERRIDE			0x2005
> +#define SPHY_LANE			0x100
> +#define SPHY_HALF_RATE			0x0001
> +#define CPHY_SATA_DPLL_MODE		0x0700
> +#define CPHY_SATA_DPLL_SHIFT		8
> +#define CPHY_SATA_DPLL_RESET		(1 << 11)
> +#define CPHY_PHY_COUNT			6
> +#define CPHY_LANE_COUNT			4
> +#define CPHY_PORT_COUNT			(CPHY_PHY_COUNT * CPHY_LANE_COUNT)
> +
> +static DEFINE_SPINLOCK(cphy_lock);
> +/* Each of the 6 phys can have up to 4 sata ports attached to i. Map 0-based
> + * sata ports to their phys and then to their lanes within the phys
> + */
> +struct phy_lane_info {
> +	void __iomem *phy_base;
> +	u8 lane_mapping;
> +	u8 phy_devs;
> +};
> +static struct phy_lane_info port_data[CPHY_PORT_COUNT];
> +
> +static u32 __combo_phy_reg_read(u8 sata_port, u32 addr)
> +{
> +	u32 data;
> +	u8 dev = port_data[sata_port].phy_devs;
> +	spin_lock(&cphy_lock);
> +	writel(CPHY_MAP(dev, addr), port_data[sata_port].phy_base + 0x800);
> +	data = readl(port_data[sata_port].phy_base + CPHY_ADDR(addr));
> +	spin_unlock(&cphy_lock);
> +	return data;
> +}
> +
> +static void __combo_phy_reg_write(u8 sata_port, u32 addr, u32 data)
> +{
> +	u8 dev = port_data[sata_port].phy_devs;
> +	spin_lock(&cphy_lock);
> +	writel(CPHY_MAP(dev, addr), port_data[sata_port].phy_base + 0x800);
> +	writel(data, port_data[sata_port].phy_base + CPHY_ADDR(addr));
> +	spin_unlock(&cphy_lock);
> +}
> +
> +static void combo_phy_wait_for_ready(u8 sata_port) 
> +{
> +	while (__combo_phy_reg_read(sata_port, SERDES_CR_CTL) & CR_BUSY)
> +		udelay(5);
> +}
> +
> +static u32 combo_phy_read(u8 sata_port, u32 addr)
> +{
> +	combo_phy_wait_for_ready(sata_port);
> +	__combo_phy_reg_write(sata_port, SERDES_CR_ADDR, addr);
> +	udelay(25);
> +	__combo_phy_reg_write(sata_port, SERDES_CR_CTL, CR_START);
> +	udelay(25);
> +	combo_phy_wait_for_ready(sata_port);
> +	return __combo_phy_reg_read(sata_port, SERDES_CR_DATA);
> +}
> +
> +static void combo_phy_write(u8 sata_port, u32 addr, u32 data)
> +{
> +	combo_phy_wait_for_ready(sata_port);
> +	__combo_phy_reg_write(sata_port, SERDES_CR_ADDR, addr);
> +	udelay(25);
> +	__combo_phy_reg_write(sata_port, SERDES_CR_DATA, data);
> +	udelay(25);
> +	__combo_phy_reg_write(sata_port, SERDES_CR_CTL, CR_WR_RDN | CR_START);
> +}
> +
> +void calxeda_cphy_disable_overrides(u8 sata_port)
> +{
> +	u8 lane = port_data[sata_port].lane_mapping;
> +	u32 tmp;
> +	if (unlikely(port_data[sata_port].phy_base == NULL))
> +		return;
> +	tmp = combo_phy_read(sata_port, CPHY_RX_INPUT_STS + lane * SPHY_LANE);
> +	tmp &= ~CPHY_SATA_OVERRIDE;
> +	combo_phy_write(sata_port, CPHY_OVERRIDE + lane * SPHY_LANE, tmp);
> +}
> +EXPORT_SYMBOL(calxeda_cphy_disable_overrides);
> +
> +static void cphy_override_rx_mode(u8 sata_port, u32 val)
> +{
> +	u8 lane = port_data[sata_port].lane_mapping;
> +	u32 tmp;
> +	tmp = combo_phy_read(sata_port, CPHY_RX_INPUT_STS + lane * SPHY_LANE);
> +	tmp &= ~CPHY_SATA_OVERRIDE;
> +	combo_phy_write(sata_port, CPHY_OVERRIDE + lane * SPHY_LANE, tmp);
> +
> +	tmp |= CPHY_SATA_OVERRIDE;
> +	combo_phy_write(sata_port, CPHY_OVERRIDE + lane * SPHY_LANE, tmp);
> +
> +	tmp &= ~CPHY_SATA_DPLL_MODE;
> +	tmp |= val << CPHY_SATA_DPLL_SHIFT;
> +	combo_phy_write(sata_port, CPHY_OVERRIDE + lane * SPHY_LANE, tmp);
> +
> +	tmp |= CPHY_SATA_DPLL_RESET;
> +	combo_phy_write(sata_port, CPHY_OVERRIDE + lane * SPHY_LANE, tmp);
> +
> +	tmp &= ~CPHY_SATA_DPLL_RESET;
> +	combo_phy_write(sata_port, CPHY_OVERRIDE + lane * SPHY_LANE, tmp);
> +
> +	msleep(15);
> +}
> +
> +void calxeda_cphy_override_lane(u8 sata_port)
> +{
> +	u8 lane = port_data[sata_port].lane_mapping;
> +	u32 tmp, k = 0;
> +	if (unlikely(port_data[sata_port].phy_base == NULL))
> +		return;
> +	do {
> +		tmp = combo_phy_read(sata_port, CPHY_RX_INPUT_STS +
> +						lane * SPHY_LANE);
> +	} while ((tmp & SPHY_HALF_RATE) && (k++ < 1000));
> +	cphy_override_rx_mode(sata_port, 3);
> +}
> +EXPORT_SYMBOL(calxeda_cphy_override_lane);
> +
> +int calxeda_initialize_phys(struct device *dev, void __iomem *addr)
> +{
> +	struct device_node *sata_node;
> +	int phy_count = 0, phy, port = 0;
> +	void __iomem *cphy_base[CPHY_PHY_COUNT];
> +	struct device_node *phy_nodes[CPHY_PHY_COUNT];
> +	memset(port_data, 0, sizeof(struct phy_lane_info) * CPHY_PORT_COUNT);
> +	memset(phy_nodes, 0, sizeof(struct device_node*) * CPHY_PHY_COUNT);
> +
> +	for_each_compatible_node(sata_node, NULL, "calxeda,hb-ahci") {

This is not needed. This function is called for each controller already.
You should already have dev->of_node set.

Rob

> +		do {
> +			u32 tmp;
> +			struct of_phandle_args phy_data;
> +			if (of_parse_phandle_with_args(sata_node,
> +					"calxeda,port-phys", "#phy-cells",
> +					port, &phy_data))
> +				break;
> +			for (phy = 0; phy < phy_count; phy++) {
> +				if (phy_nodes[phy] == phy_data.np)
> +					break;
> +			}
> +			if (phy_nodes[phy] == NULL) {
> +				phy_nodes[phy] = phy_data.np;
> +				cphy_base[phy] = of_iomap(phy_nodes[phy], 0);
> +				if (cphy_base[phy] == NULL)
> +					return 0;
> +				phy_count += 1;
> +			}
> +			port_data[port].lane_mapping = phy_data.args[0];
> +			of_property_read_u32(phy_nodes[phy], "phydev", &tmp);
> +			port_data[port].phy_devs = tmp;
> +			port_data[port].phy_base = cphy_base[phy];
> +			of_node_put(phy_data.np);
> +			port += 1;
> +		} while (port < CPHY_PORT_COUNT);
> +	}
> +	return 0;
> +}
> +EXPORT_SYMBOL(calxeda_initialize_phys);
> 

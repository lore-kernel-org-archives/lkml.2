Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab1G1NTo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 09:19:44 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55028 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab1G1NTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 09:19:42 -0400
Date: Thu, 28 Jul 2011 14:19:19 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tommy Lin <tommy.lin.1101@gmail.com>
Cc: Anton Vorontsov <avorontsov@mvista.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] arch: arm: mach-cns3xxx: Add gpiolib support
Message-ID: <20110728131918.GF31473@n2100.arm.linux.org.uk>
References: <1311873401-26075-1-git-send-email-tommy.lin.1101@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311873401-26075-1-git-send-email-tommy.lin.1101@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 01:16:41AM +0800, Tommy Lin wrote:
> +/* The CNS3XXX GPIO pins are shard with special functions which is described in
> + * the following table. "none" in this table represent the corresponding pins
> + * are dedicate GPIO.
> + */
> +const char *sharepin_desc[] = {

static ?

> +	/* GPIOA group */
> +/*  0 */ "none",	"none",		"SD_PWR_ON",	"OTG_DRV_VBUS",
> +/*  4 */ "Don't use",	"none",		"none",		"none",
> +/*  8 */ "CIM_nOE",	"LCD_Power",	"SMI_nCS3",	"SMI_nCS2",
> +/* 12 */ "SMI_Clk",	"SMI_nADV",	"SMI_CRE",	"SMI_Addr[26]",
> +/* 16 */ "SD_nCD",	"SD_nWP",	"SD_CLK",	"SD_CMD",
> +/* 20 */ "SD_DT[7]",	"SD_DT[6]",	"SD_DT[5]",	"SD_DT[4]",
> +/* 24 */ "SD_DT[3]",	"SD_DT[2]",	"SD_DT[1]",	"SD_DT[0]",
> +/* 28 */ "SD_LED",	"UR_RXD1",	"UR_TXD1",	"UR_RTS2",
> +	/* GPIOB group */
> +/*  0 */ "UR_CTS2",	"UR_RXD2",	"UR_TXD2",	"PCMCLK",
> +/*  4 */ "PCMFS",	"PCMDT",	"PCMDR",	"SPInCS1",
> +/*  8 */ "SPInCS2",	"SPICLK",	"SPIDT",	"SPIDR",
> +/* 12 */ "SCL",		"SDA",		"GMII2_CRS",	"GMII2_COL",
> +/* 16 */ "RGMII1_CRS",	"RGMII1_COL",	"RGMII0_CRS",	"RGMII0_COL",
> +/* 20 */ "MDC",		"MDIO",		"I2SCLK",	"I2SFS",
> +/* 24 */ "I2SDT",	"I2SDR",	"ClkOut",	"Ext_Intr2",
> +/* 28 */ "Ext_Intr1",	"Ext_Intr0",	"SATA_LED1",	"SATA_LED0",
> +};
> +
> +struct cns3xxx_regs {
> +	char *name;
> +	void __iomem *addr;
> +	u32 offset;
> +};
> +
> +struct cns3xxx_regs gpio_regs[] =  {

static?

> +	{"Data Out",			0, GPIO_OUTPUT_OFFSET},
> +	{"Data In",			0, GPIO_INPUT_OFFSET},
> +	{"Direction",			0, GPIO_DIR_OFFSET},
> +	{"Interrupt Enable",		0, GPIO_INTR_ENABLE_OFFSET},
> +	{"Interrupt Raw Status",	0, GPIO_INTR_RAW_STATUS_OFFSET},
> +	{"Interrupt Masked Status",	0, GPIO_INTR_MASKED_STATUS_OFFSET},
> +	{"Interrupt Level Trigger",	0, GPIO_INTR_TRIGGER_METHOD_OFFSET},
> +	{"Interrupt Both Edge",		0, GPIO_INTR_TRIGGER_BOTH_EDGES_OFFSET},
> +	{"Interrupt Falling Edge",	0, GPIO_INTR_TRIGGER_TYPE_OFFSET},
> +	{"Interrupt MASKED",		0, GPIO_INTR_MASK_OFFSET},
> +	{"GPIO Bounce Enable",		0, GPIO_BOUNCE_ENABLE_OFFSET},
> +	{"GPIO Bounce Prescale",	0, GPIO_BOUNCE_PRESCALE_OFFSET},
> +};
> +
> +struct cns3xxx_regs misc_regs[] =  {

static?

> +	{"Drive Strength Register A",	MISC_IO_PAD_DRIVE_STRENGTH_CTRL_A},
> +	{"Drive Strength Register B",	MISC_IO_PAD_DRIVE_STRENGTH_CTRL_B},
> +	{"Pull Up/Down Ctrl A[15:0]",	MISC_GPIOA_15_0_PULL_CTRL_REG},
> +	{"Pull Up/Down Ctrl A[31:16]",	MISC_GPIOA_16_31_PULL_CTRL_REG},
> +	{"Pull Up/Down Ctrl B[15:0]",	MISC_GPIOB_15_0_PULL_CTRL_REG},
> +	{"Pull Up/Down Ctrl B[31:16]",	MISC_GPIOB_16_31_PULL_CTRL_REG},
> +};
> +
> +
> +static int cns3xxx_request(struct gpio_chip *chip, unsigned offset)
> +{
> +	/* GPIOA4 is reserved for chip bonding configuration. Please don't use
> +	 * and configure GPIOA4.
> +	 */
> +	if ((strcmp(chip->label, "GPIOA") == 0) && (offset == 4))
> +		return -EINVAL;
> +	return 0;
> +}
> +
> +/*
> + * Configure the GPIO line as an input.
> + */
> +static int cns3xxx_direction_in(struct gpio_chip *chip, unsigned offset)
> +{
> +	struct chog_gpio_chip *cns3xxx_gpio = to_chog_gpio_chip(chip);
> +	u32 reg;
> +
> +	/* Clear corresponding register bit to set as input pin. */
> +	reg = readl(cns3xxx_gpio->reg_base + GPIO_DIR_OFFSET);
> +	reg &= ~(1 << offset);
> +	writel(reg, cns3xxx_gpio->reg_base + GPIO_DIR_OFFSET);
> +
> +	return 0;
> +}
> +
> +/*
> + * Set the state of an output GPIO line.
> + */
> +static void cns3xxx_set(struct gpio_chip *chip, unsigned offset, int value)
> +{
> +	struct chog_gpio_chip *cns3xxx_gpio = to_chog_gpio_chip(chip);
> +
> +	if (value)
> +		/* Write 1 to set corresponding bit output "HIGH"
> +		 * Multi-bit write is allowed. Write 0 makes no change.
> +		 */
> +		writel(1 << offset,
> +				cns3xxx_gpio->reg_base + GPIO_BIT_SET_OFFSET);
> +	else
> +		/* Write 1 to set corresponding bit output "LOW"
> +		 * Multi-bit write is allowed. Write 0 makes no change.
> +		 */
> +		writel(1 << offset,
> +				cns3xxx_gpio->reg_base + GPIO_BIT_CLEAR_OFFSET);
> +}
> +
> +/*
> + * Configure the GPIO line as an output, with default state.
> + */
> +static int cns3xxx_direction_out(struct gpio_chip *chip,
> +		unsigned offset, int value)
> +{
> +	struct chog_gpio_chip *cns3xxx_gpio = to_chog_gpio_chip(chip);
> +	u32 reg;
> +
> +	/* Set corresponding register bit to set as output pin. */
> +	reg = readl(cns3xxx_gpio->reg_base + GPIO_DIR_OFFSET);
> +	reg |= 1 << offset;
> +	writel(reg, cns3xxx_gpio->reg_base + GPIO_DIR_OFFSET);
> +
> +	cns3xxx_set(chip, offset, value);

It is considered good form to set the bit state first before setting it
as an output to avoid unintentional glitches.  Please check whether your
hardware can do this and if so modify the code to do so.  That's why we
don't have a 'direction' function and a separate 'set_value' function...

> +
> +	return 0;
> +}
> +
> +/*
> + * Read the state of a GPIO line.
> + */
> +static int cns3xxx_get(struct gpio_chip *chip, unsigned offset)
> +{
> +	struct chog_gpio_chip *cns3xxx_gpio = to_chog_gpio_chip(chip);
> +	u32 reg;
> +	int ret;
> +
> +	reg = readl(cns3xxx_gpio->reg_base + GPIO_INPUT_OFFSET);
> +	ret = reg & (1 << offset);
> +
> +	return ret;
> +}
> +
> +/*
> + * GPIO interrtups are remapped to unused irq number.
> + * The remapped GPIO IRQ number start from NR_IRQS_CNS3XXX (96). Here is the
> + * table of GPIO to irq mapping table.
> + *
> + *	GPIOA	GPIOB	|	GPIOA	GPIOB
> + * No.	IRQ	IRQ	|  No.	IRQ	IRQ
> + *  0	 96	128	|  16	112	144
> + *  1	 97	129	|  17	113	145
> + *  2	 98	130	|  18	114	146
> + *  3	 99	131	|  19	115	147
> + *  4	100	132	|  20	116	148
> + *  5	101	133	|  21	117	149
> + *  6	102	134	|  22	118	150
> + *  7	103	135	|  23	119	151
> + *  8	104	136	|  24	120	152
> + *  9	105	137	|  25	121	153
> + * 10	106	138	|  26	122	154
> + * 11	107	139	|  27	123	155
> + * 12	108	140	|  28	124	156
> + * 13	109	141	|  29	125	157
> + * 14	110	142	|  30	126	158
> + * 15	111	143	|  31	127	159
> + */
> +static int cns3xxx_to_irq(struct gpio_chip *chip, unsigned offset)
> +{
> +	struct chog_gpio_chip *cns3xxx_gpio = to_chog_gpio_chip(chip);
> +
> +	return offset + NR_IRQS_CNS3XXX + cns3xxx_gpio->chip.base;
> +}
> +
> +static unsigned cns3xxx_irq_to_gpio_offset(struct gpio_chip *chip, int irq)
> +{
> +	struct chog_gpio_chip *cns3xxx_gpio = to_chog_gpio_chip(chip);
> +
> +	return irq - NR_IRQS_CNS3XXX - cns3xxx_gpio->chip.base;
> +}
> +
> +int cns3xxx_gpio_set_irq_type(struct irq_data *data, unsigned int type)
> +{
> +	struct gpio_chip *chip = data->chip_data;
> +	void __iomem *base = to_chog_gpio_chip(chip)->reg_base;
> +	unsigned offset;
> +	u32 reg_level, reg_both, reg_low, index;
> +
> +	offset = cns3xxx_irq_to_gpio_offset(chip, data->irq);
> +	index = 1 << offset;
> +
> +	reg_level = readl(base + GPIO_INTR_TRIGGER_METHOD_OFFSET);
> +	reg_both = readl(base + GPIO_INTR_TRIGGER_BOTH_EDGES_OFFSET);
> +	reg_low = readl(base + GPIO_INTR_TRIGGER_TYPE_OFFSET);
> +
> +	switch (type) {
> +	case IRQ_TYPE_EDGE_RISING:
> +		reg_level &= ~index;
> +		reg_both &= ~index;
> +		reg_low &= ~index;
> +		break;
> +	case IRQ_TYPE_EDGE_FALLING:
> +		reg_level &= ~index;
> +		reg_both &= ~index;
> +		reg_low |= index;
> +		break;
> +	case IRQ_TYPE_EDGE_BOTH:
> +		reg_level &= ~index;
> +		reg_both |= index;
> +		break;
> +	case IRQ_TYPE_LEVEL_LOW:
> +		reg_level |= index;
> +		reg_low |= index;
> +		break;
> +	case IRQ_TYPE_LEVEL_HIGH:
> +		reg_level |= index;
> +		reg_low &= ~index;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	cns3xxx_direction_in(chip, offset);
> +	writel(reg_level, base + GPIO_INTR_TRIGGER_METHOD_OFFSET);
> +	writel(reg_both, base + GPIO_INTR_TRIGGER_BOTH_EDGES_OFFSET);
> +	writel(reg_low, base + GPIO_INTR_TRIGGER_TYPE_OFFSET);
> +
> +	return 0;
> +}
> +
> +static void cns3xxx_irq_enable(struct irq_data *data)
> +{
> +	struct gpio_chip *chip = data->chip_data;
> +	void __iomem *base = to_chog_gpio_chip(chip)->reg_base;
> +	unsigned offset = cns3xxx_irq_to_gpio_offset(chip, data->irq);
> +	u32 reg;
> +
> +	reg = readl(base + GPIO_INTR_ENABLE_OFFSET);
> +	reg |= (1 << offset);
> +	writel(reg, base + GPIO_INTR_ENABLE_OFFSET);
> +}
> +
> +static void cns3xxx_irq_disable(struct irq_data *data)
> +{
> +	struct gpio_chip *chip = data->chip_data;
> +	void __iomem *base = to_chog_gpio_chip(chip)->reg_base;
> +	unsigned offset = cns3xxx_irq_to_gpio_offset(chip, data->irq);
> +	u32 reg;
> +
> +	reg = readl(base + GPIO_INTR_ENABLE_OFFSET);
> +	reg &= ~(1 << offset);
> +	writel(reg, base + GPIO_INTR_ENABLE_OFFSET);
> +}
> +
> +static void cns3xxx_gpio_mask(struct irq_data *data)
> +{
> +	struct gpio_chip *chip = data->chip_data;
> +	void __iomem *base = to_chog_gpio_chip(chip)->reg_base;
> +	unsigned offset = cns3xxx_irq_to_gpio_offset(chip, data->irq);
> +	u32 reg;
> +
> +	reg = readl(base + GPIO_INTR_MASK_OFFSET);
> +	reg |= (1 << offset);
> +	writel(reg, base + GPIO_INTR_MASK_OFFSET);
> +}
> +
> +static void cns3xxx_gpio_unmask(struct irq_data *data)
> +{
> +	struct gpio_chip *chip = data->chip_data;
> +	void __iomem *base = to_chog_gpio_chip(chip)->reg_base;
> +	unsigned offset = cns3xxx_irq_to_gpio_offset(chip, data->irq);
> +	u32 reg;
> +
> +	reg = readl(base + GPIO_INTR_MASK_OFFSET);
> +	reg &= ~(1 << offset);
> +	writel(reg, base + GPIO_INTR_MASK_OFFSET);
> +}
> +
> +static struct irq_chip cns3xxx_gpio_irq_chip = {
> +	.name = "GPIO",
> +	.irq_enable = cns3xxx_irq_enable,
> +	.irq_disable = cns3xxx_irq_disable,
> +	.irq_mask = cns3xxx_gpio_mask,
> +	.irq_unmask = cns3xxx_gpio_unmask,
> +	.irq_set_type = cns3xxx_gpio_set_irq_type,
> +};
> +
> +static struct chog_gpio_chip cns3xxx_gchip[] = {
> +			  /* label,  base,	   ngpio */
> +	INIT_CHOG_GPIO_CHIP("GPIOA", 0x00,	   MAX_GPIOA_NO),
> +	INIT_CHOG_GPIO_CHIP("GPIOB", MAX_GPIOA_NO, MAX_GPIOB_NO),
> +};
> +
> +
> +static int cns3xxx_gpio_read_proc(char *page, char **start,  off_t off,
> +		int count, int *eof, void *data)
> +{
> +	int num = 0, i, nr_regs;
> +
> +	nr_regs = sizeof(gpio_regs)/sizeof(struct cns3xxx_regs);

ARRAY_SIZE(gpio_regs)

> +	num += sprintf(page + num,
> +			"Register Description        GPIOA     GPIOB\n"
> +			"====================        =====     =====\n");
> +	num += sprintf(page + num, "%-26.26s: %08x  %08x\n", "GPIO Disable",
> +		readl(cns3xxx_gchip[0].reg_sharepin_en),
> +		readl(cns3xxx_gchip[1].reg_sharepin_en));
> +	for (i = 0; i < nr_regs; i++) {
> +		num += sprintf(page + num, "%-26.26s: %08x  %08x\n",
> +			gpio_regs[i].name,
> +			readl(cns3xxx_gchip[0].reg_base + gpio_regs[i].offset),
> +			readl(cns3xxx_gchip[1].reg_base + gpio_regs[i].offset));
> +	}
> +
> +	num += sprintf(page + num, "\n"
> +			"Register Description        Value\n"
> +			"====================        =====\n");
> +	nr_regs = sizeof(misc_regs)/sizeof(struct cns3xxx_regs);

ARRAY_SIZE(misc_regs)

> +	for (i = 0; i < nr_regs; i++) {
> +		num += sprintf(page + num, "%-26.26s: %08x\n",
> +			misc_regs[i].name,
> +			readl(misc_regs[i].addr));
> +	}
> +
> +	return num;
> +}
...
> +static int __devinit gpio_probe(struct platform_device *pdev)
> +{
> +	int i, j, nr_gpios = 0, irq = 0;
> +	struct resource *res;
> +	void __iomem *misc_reg;
> +
> +	cns3xxx_pwr_clk_en(0x1 << PM_CLK_GATE_REG_OFFSET_GPIO);
> +	cns3xxx_pwr_soft_rst(0x1 << PM_CLK_GATE_REG_OFFSET_GPIO);
> +
> +	if (cns3xxx_proc_dir) {
> +		proc_cns3xxx_gpio = create_proc_entry(GPIO_PROC_NAME,
> +				S_IFREG | S_IRUGO, cns3xxx_proc_dir) ;
> +		if (proc_cns3xxx_gpio)
> +			proc_cns3xxx_gpio->read_proc = cns3xxx_gpio_read_proc;
> +	}
> +
> +	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "MISC");
> +	if (res)
> +		misc_reg = (void __iomem *)res->start;

That cast says in a big way "I'm doing something wrong".  Casts normally
mean that.  Resources are, by fact, bus or physical addresses.  They
live in a unique namespace.  Putting virtual addresses in them corrupts
that namespace, and can potentially cause unexpected failures.

> +	else
> +		return -ENODEV;
> +
> +	/* Scan and match GPIO resources */
> +	for (i = 0; i < nr_banks; i++) {
> +		/* Fetech GPIO base address */
> +		res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
> +				cns3xxx_gchip[i].chip.label);
> +		if (!res)
> +			continue;
> +		cns3xxx_gchip[i].reg_base = (void __iomem *)res->start;

Ditto.

> +
> +		/* Fetech GPIO interrupt number */
> +		res = platform_get_resource_byname(pdev, IORESOURCE_IRQ,
> +				cns3xxx_gchip[i].chip.label);
> +		if (!res)
> +			continue;
> +		irq = res->start;
> +		cns3xxx_gchip[i].irq = irq;
> +		__pr_debug("%s base=0x%08x, irq=%d",
> +				cns3xxx_gchip[i].chip.label,
> +				(u32)cns3xxx_gchip[i].reg_base, irq);
> +
> +		cns3xxx_gchip[i].chip.dev = &pdev->dev;
> +		cns3xxx_gchip[i].reg_sharepin_en = misc_reg + 0x14 + i * 4;
> +
> +		gpiochip_add(&cns3xxx_gchip[i].chip);
> +
> +		/* Clear All Interrupt Status */
> +		writel(0xFFFFFFFF, cns3xxx_gchip[i].reg_base +
> +				GPIO_INTR_CLEAR_OFFSET);
> +
> +		/* Initial irq_chip to handle virtual GPIO irqs. */
> +		for (j = 0; j < cns3xxx_gchip[i].chip.ngpio; j++) {
> +			irq = cns3xxx_to_irq(&cns3xxx_gchip[i].chip, j);
> +			irq_set_chip_and_handler(irq, &cns3xxx_gpio_irq_chip,
> +				handle_simple_irq);
> +			set_irq_flags(irq, IRQF_VALID);
> +			irq_set_chip_data(irq, &cns3xxx_gchip[i]);
> +		}
> +		irq_set_chained_handler(cns3xxx_gchip[i].irq,
> +				chained_gpio_irq_handler);
> +		irq_set_handler_data(cns3xxx_gchip[i].irq,
> +				&cns3xxx_gchip[i]);
> +
> +		nr_gpios += cns3xxx_gchip[i].chip.ngpio;
> +		if (nr_gpios >= MAX_GPIO_NO)
> +			break;
> +	}
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM
> +static int gpio_cns3xxx_suspend(struct platform_device *dev, pm_message_t state)
> +{
> +	__pr_debug("%s,%s,%d\n", __FILE__, __func__, __LINE__);
> +
> +	return 0;
> +}
> +
> +static int gpio_cns3xxx_resume(struct platform_device *dev)
> +{
> +	__pr_debug("%s,%s,%d\n", __FILE__, __func__, __LINE__);
> +
> +	return 0;
> +}
> +#endif /* CONFIG_PM */

If no suspend/resume is implemented, then don't provide these functions
at all.

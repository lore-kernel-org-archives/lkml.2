Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146Ab1G1KVc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 06:21:32 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63604 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab1G1KV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 06:21:29 -0400
Date: Thu, 28 Jul 2011 11:15:23 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Tommy Lin <tommy.lin.1101@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Anton Vorontsov <avorontsov@mvista.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/3] arch: arm: mach-cns3xxx: Add gpiolib support
Message-ID: <20110728101523.GA2690@pulham.picochip.com>
References: <1311873401-26075-1-git-send-email-tommy.lin.1101@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311873401-26075-1-git-send-email-tommy.lin.1101@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tommy,

A few comments inline.

Jamie

On Fri, Jul 29, 2011 at 01:16:41AM +0800, Tommy Lin wrote:
> This patch makes CNS3XXX platform support gpiolib. Users can
> configure GPIO via gpiolib APIs easily on CNS3XXX platform.
> 
> Signed-off-by: Tommy Lin <tommy.lin.1101@gmail.com>
> ---
[...]
> +#define CONFIG_GPIO_CNS3XXX_DEBUG
> +
> +#ifdef CONFIG_GPIO_CNS3XXX_DEBUG
> +#define __pr_debug(fmt, args...)	printk(KERN_ERR fmt, ##args)
> +#else
> +#define __pr_debug(fmt, args...)
> +#endif

Could you use the kernel debug infrastructure for this? #define DEBUG 
and pr_debug()?

> +#ifdef CONFIG_DEBUG_FS
> +static void cns3xxx_dbg_show(struct seq_file *s, struct gpio_chip *chip);
> +#else
> +#define cns3xxx_dbg_show	NULL
> +#endif
> +
> +#define GPIO_PROC_NAME		"gpio"
> +static struct proc_dir_entry	*proc_cns3xxx_gpio;
> +static struct irq_chip		cns3xxx_gpio_irq_chip;

I think debugfs would be preferred for this rather than proc.

> +struct chog_gpio_chip {
> +	struct gpio_chip	chip;
> +	int			irq;
> +	void __iomem		*reg_base;
> +	void __iomem		*reg_sharepin_en;
> +};
> +
> +#define INIT_CHOG_GPIO_CHIP(name, base_no, nr_gpio)			\
> +	{								\
> +		.chip = {						\
> +			.label			= name,			\
> +			.owner			= THIS_MODULE,		\
> +			.request		= cns3xxx_request,	\
> +			.direction_input	= cns3xxx_direction_in,	\
> +			.direction_output	= cns3xxx_direction_out,\
> +			.get			= cns3xxx_get,		\
> +			.set			= cns3xxx_set,		\
> +			.to_irq			= cns3xxx_to_irq,	\
> +			.dbg_show		= cns3xxx_dbg_show,	\
> +			.base			= base_no,		\
> +			.ngpio			= nr_gpio,		\
> +			.can_sleep		= 0,			\
> +		},							\
> +	}
> +
> +
> +#define to_chog_gpio_chip(c)	container_of(c, struct chog_gpio_chip, chip)
> +#define nr_banks	(sizeof(cns3xxx_gchip)/sizeof(struct chog_gpio_chip))
> +
> +/* The CNS3XXX GPIO pins are shard with special functions which is described in
> + * the following table. "none" in this table represent the corresponding pins
> + * are dedicate GPIO.
> + */
> +const char *sharepin_desc[] = {
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

The generic gpio (include/linux/basic_mmio_gpio.h) driver will support 
all of these accessors and provide all of the value caching too.  You 
can add your .request method in to make sure you can't access the bond 
option pins but still use the other default accessors.

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

Thomas provided a generic irq chip infrastructure for this sort of thing 
(struct irq_chip_generic) that would be useful here.

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
> +	for (i = 0; i < nr_regs; i++) {
> +		num += sprintf(page + num, "%-26.26s: %08x\n",
> +			misc_regs[i].name,
> +			readl(misc_regs[i].addr));
> +	}
> +
> +	return num;
> +}
> +
> +/*
> + * Turn on corresponding shared pin function.
> + * Turn on shared pin function will also disable GPIO function. Related GPIO
> + * control registers are still accessable but not reflect to pin.
> + */
> +int cns3xxx_sharepin_request(unsigned gpio, const char *label)
> +{
> +	struct gpio_chip *chip;
> +	int i, reg, ret, offset = gpio;
> +
> +	ret = gpio_request(gpio, label);
> +	if (ret) {
> +		__pr_debug("gpio%d(%s) already in use! Err=%d\n",
> +				gpio, label, ret);
> +		return ret;
> +	}
> +
> +	for (i = 0; i < nr_banks; i++) {
> +		chip = &cns3xxx_gchip[i].chip;
> +		if (offset > chip->ngpio) {
> +			offset -= chip->ngpio;
> +			continue;
> +		}
> +		reg = readl(cns3xxx_gchip[i].reg_sharepin_en);
> +		reg |= (1 << offset);
> +		writel(reg, cns3xxx_gchip[i].reg_sharepin_en);
> +		__pr_debug("%s[%d] is occupied by %s function!\n",
> +				chip->label, offset, sharepin_desc[gpio]);
> +		break;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(cns3xxx_sharepin_request);
> +
> +/*
> + * Turn off corresponding share pin function.
> + */
> +void cns3xxx_sharepin_free(unsigned gpio)
> +{
> +	struct gpio_chip *chip;
> +	int i, reg, offset = gpio;
> +
> +	gpio_free(gpio);
> +
> +	for (i = 0; i < nr_banks; i++) {
> +		chip = &cns3xxx_gchip[i].chip;
> +		if (offset > chip->ngpio) {
> +			offset -= chip->ngpio;
> +			continue;
> +		}
> +		reg = readl(cns3xxx_gchip[i].reg_sharepin_en);
> +		reg &= ~(1 << offset);
> +		writel(reg, cns3xxx_gchip[i].reg_sharepin_en);
> +		printk(KERN_INFO "%s[%d] share pin function (%s) disabled!\n",
> +				chip->label, offset, sharepin_desc[gpio]);
> +		break;
> +	}
> +}
> +EXPORT_SYMBOL(cns3xxx_sharepin_free);
> +
> +
> +#ifdef CONFIG_DEBUG_FS
> +
> +#include <linux/debugfs.h>
> +#include <linux/seq_file.h>
> +
> +static void cns3xxx_dbg_show(struct seq_file *s, struct gpio_chip *chip)
> +{
> +	struct chog_gpio_chip *cns3xxx_gpio = to_chog_gpio_chip(chip);
> +	int i, is_out;
> +	unsigned gpio;
> +	const char *gpio_label;
> +
> +	for (i = 0; i < chip->ngpio; i++) {
> +		gpio = chip->base + i;
> +		gpio_label = gpiochip_is_requested(chip, i);
> +		if (!gpio_label)
> +			continue;
> +		is_out = test_bit(i, cns3xxx_gpio->reg_base + GPIO_DIR_OFFSET);
> +		seq_printf(s, " gpio-%-3d [%-20.20s] %s %s (%s%-2d)\n",
> +			gpio, gpio_label,
> +			is_out ? "out" : "in ",
> +			chip->get(chip, i) ? "hi" : "lo",
> +			chip->label, i);
> +	}
> +}
> +
> +static int cns3xxx_dbg_gpio_show_all(struct seq_file *s, void *unused)
> +{
> +	int i, j, is_out, disabled;
> +	unsigned gpio;
> +	const char *gpio_label;
> +	struct gpio_chip *chip;
> +
> +	for (j = 0; j < nr_banks; j++) {
> +		chip = &cns3xxx_gchip[j].chip;
> +		seq_printf(s, "           Label                 Mode      Dir Value Note\n");
> +		seq_printf(s, " ============================================================\n");
> +		for (i = 0; i < chip->ngpio; i++) {
> +			gpio = chip->base + i;
> +			disabled = test_bit(i, cns3xxx_gchip[j].reg_sharepin_en);
> +			gpio_label = gpiochip_is_requested(chip, i);
> +			if (!gpio_label) {
> +				if (disabled)
> +					gpio_label = sharepin_desc[gpio];
> +				else
> +					gpio_label = "Not requested";
> +			}
> +			is_out = test_bit(i, cns3xxx_gchip[j].reg_base + GPIO_DIR_OFFSET);
> +			seq_printf(s, " gpio-%-3d [%-20.20s] %-10.10s%s %s   (%s%-2d)\n",
> +				gpio, gpio_label,
> +				disabled ? "Function" : "GPIO",
> +				is_out ? "out" : "in ",
> +				chip->get(chip, i) ? "hi" : "lo",
> +				chip->label, i);
> +		}
> +		seq_printf(s, "\n");
> +	}
> +
> +	return 0;
> +}
> +
> +static int dbg_gpio_open(struct inode *inode, struct file *file)
> +{
> +	return single_open(file, cns3xxx_dbg_gpio_show_all, &inode->i_private);
> +}
> +
> +static const struct file_operations debug_fops = {
> +	.open		= dbg_gpio_open,
> +	.read		= seq_read,
> +	.llseek		= seq_lseek,
> +	.release	= single_release,
> +};
> +
> +static int __init cns3xxx_gpio_debuginit(void)
> +{
> +	(void) debugfs_create_file("gpio-cns3xxx", S_IRUGO,
> +			NULL, NULL, &debug_fops);
> +	return 0;
> +}
> +late_initcall(cns3xxx_gpio_debuginit);
> +
> +#endif /* CONFIG_DEBUG_FS */
> +
> +static void chained_gpio_irq_handler(unsigned irq, struct irq_desc *desc)
> +{
> +	struct chog_gpio_chip *chip = irq_get_handler_data(irq);
> +	struct irq_chip *ichip = irq_desc_get_chip(desc);
> +	unsigned i;
> +	int target_irq;
> +	u32 status;
> +
> +	chained_irq_enter(ichip, desc);
> +
> +	status = readl(chip->reg_base + GPIO_INTR_MASKED_STATUS_OFFSET);
> +
> +	/* Clean System irq status */
> +	writel(status, chip->reg_base + GPIO_INTR_CLEAR_OFFSET);
> +
> +	for (i = 0; i < chip->chip.ngpio; i++) {
> +		if (status & (1 << i)) {
> +			target_irq = cns3xxx_to_irq(&chip->chip, i);
> +			printk(KERN_INFO "Invoke cascaded irq %d from irq %d\n",
> +					target_irq, chip->irq);
> +			generic_handle_irq(target_irq);
> +		}
> +	}
> +
> +	chained_irq_exit(ichip, desc);
> +}
> +
> +static int __devinit gpio_probe(struct platform_device *pdev)
> +{
> +	int i, j, nr_gpios = 0, irq = 0;
> +	struct resource *res;
> +	void __iomem *misc_reg;
> +
> +	cns3xxx_pwr_clk_en(0x1 << PM_CLK_GATE_REG_OFFSET_GPIO);

Should this be using the clk framework (clk_get() + clk_enable())?

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

request_mem_region() and ioremap().  IORESOURCE_MEM resources should be 
physical addresses.

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

The same here.

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
> +
> +static struct platform_driver gpio_driver = {
> +	.probe		= gpio_probe,
> +#ifdef CONFIG_PM
> +	.suspend	= gpio_cns3xxx_suspend,
> +	.resume		= gpio_cns3xxx_resume,
> +#endif /* CONFIG_PM */

You can put the power management operations in .dev_pm_ops, but as they 
don't do anything you can just remove them.

> +	.driver		= {
> +		.owner	= THIS_MODULE,
> +		.name	= "cns3xxx-gpio",
> +	},
> +};
> +
> +int __init cns3xxx_gpio_init(void)
> +{
> +	return platform_driver_probe(&gpio_driver, gpio_probe);
> +}
> +
> +void __exit cns3xxx_gpio_exit(void)
> +{
> +	if (proc_cns3xxx_gpio)
> +		remove_proc_entry(GPIO_PROC_NAME, cns3xxx_proc_dir);
> +}
> +
> +module_init(cns3xxx_gpio_init);
> +module_exit(cns3xxx_gpio_exit);
> +
> +MODULE_LICENSE("GPL");
> +
> diff --git a/arch/arm/mach-cns3xxx/include/mach/cns3xxx.h b/arch/arm/mach-cns3xxx/include/mach/cns3xxx.h
> index 191c8e5..217bb4d 100644
> --- a/arch/arm/mach-cns3xxx/include/mach/cns3xxx.h
> +++ b/arch/arm/mach-cns3xxx/include/mach/cns3xxx.h
> @@ -624,9 +624,15 @@ int cns3xxx_cpu_clock(void);
>  
>  #define NR_IRQS_CNS3XXX			(IRQ_TC11MP_GIC_START + 64)
>  
> -#if !defined(NR_IRQS) || (NR_IRQS < NR_IRQS_CNS3XXX)
> +#define MAX_GPIOA_NO			32
> +#define MAX_GPIOB_NO			32
> +#define MAX_GPIO_NO			(MAX_GPIOA_NO + MAX_GPIOB_NO)
> +
> +#if !defined(NR_IRQS) || (NR_IRQS < (NR_IRQS_CNS3XXX + MAX_GPIO_NO))
>  #undef NR_IRQS
> -#define NR_IRQS				NR_IRQS_CNS3XXX
> +#define NR_IRQS				(NR_IRQS_CNS3XXX + MAX_GPIO_NO)
>  #endif
>  
> +extern struct proc_dir_entry *cns3xxx_proc_dir;
> +
>  #endif	/* __MACH_BOARD_CNS3XXX_H */
> diff --git a/arch/arm/mach-cns3xxx/include/mach/gpio.h b/arch/arm/mach-cns3xxx/include/mach/gpio.h
> new file mode 100644
> index 0000000..22efca8
> --- /dev/null
> +++ b/arch/arm/mach-cns3xxx/include/mach/gpio.h
> @@ -0,0 +1,63 @@
> +/*******************************************************************************
> + *
> + *  Copyright (c) 2011 Cavium
> + *
> + *  This file is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License, Version 2, as
> + *  published by the Free Software Foundation.
> + *
> + *  This file is distributed in the hope that it will be useful,
> + *  but AS-IS and WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE, TITLE, or
> + *  NONINFRINGEMENT.  See the GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this file; if not, write to the Free Software
> + *  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA or
> + *  visit http://www.gnu.org/licenses/.
> + *
> + *  This file may also be available under a different license from Cavium.
> + *  Contact Cavium for more information
> + *
> + ******************************************************************************/
> +
> +#ifndef	_CNS3XXX_GPIO_H_
> +#define	_CNS3XXX_GPIO_H_
> +
> +#include <mach/cns3xxx.h>
> +
> +#define ARCH_NR_GPIOS				MAX_GPIO_NO
> +
> +#include <asm-generic/gpio.h>
> +
> +#define GPIO_OUTPUT_OFFSET			0x00
> +#define GPIO_INPUT_OFFSET			0x04
> +#define GPIO_DIR_OFFSET				0x08
> +#define GPIO_BIT_SET_OFFSET			0x10
> +#define GPIO_BIT_CLEAR_OFFSET			0x14
> +#define GPIO_INTR_ENABLE_OFFSET			0x20
> +#define GPIO_INTR_RAW_STATUS_OFFSET		0x24
> +#define GPIO_INTR_MASKED_STATUS_OFFSET		0x28
> +#define GPIO_INTR_MASK_OFFSET			0x2C
> +#define GPIO_INTR_CLEAR_OFFSET			0x30
> +#define GPIO_INTR_TRIGGER_METHOD_OFFSET		0x34
> +#define GPIO_INTR_TRIGGER_BOTH_EDGES_OFFSET	0x38
> +#define GPIO_INTR_TRIGGER_TYPE_OFFSET		0x3C
> +#define GPIO_BOUNCE_ENABLE_OFFSET		0x40
> +#define GPIO_BOUNCE_PRESCALE_OFFSET		0x44
> +
> +
> +#define gpio_get_value				__gpio_get_value
> +#define gpio_set_value				__gpio_set_value
> +#define gpio_cansleep				__gpio_cansleep
> +#define gpio_to_irq				__gpio_to_irq
> +
> +#define GPIOA(n)				n
> +#define GPIOB(n)				(MAX_GPIOA_NO + n)
> +
> +/* Function prototype */
> +int cns3xxx_sharepin_request(unsigned gpio, const char *label);
> +void cns3xxx_sharepin_free(unsigned gpio);
> +
> +#endif
> +
> -- 
> 1.7.6
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

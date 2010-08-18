Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab0HRNjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 09:39:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:10292 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951Ab0HRNjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 09:39:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,227,1280732400"; 
   d="scan'208";a="597773994"
Date: Wed, 18 Aug 2010 15:39:16 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Thibaut Girka <thib@sitedethib.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] Smedia Glamo 3362 core/resource driver
Message-ID: <20100818133914.GC2608@sortiz-mobl>
References: <1278508326-7109-1-git-send-email-thib@sitedethib.com>
 <1278508326-7109-2-git-send-email-thib@sitedethib.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278508326-7109-2-git-send-email-thib@sitedethib.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thibaut,

On Wed, Jul 07, 2010 at 03:12:03PM +0200, Thibaut Girka wrote:
> +#define GLAMO_IRQ_HOSTBUS	0
> +#define GLAMO_IRQ_JPEG		1
> +#define GLAMO_IRQ_MPEG		2
> +#define GLAMO_IRQ_MPROC1	3
> +#define GLAMO_IRQ_MPROC0	4
> +#define GLAMO_IRQ_CMDQUEUE	5
> +#define GLAMO_IRQ_2D		6
> +#define GLAMO_IRQ_MMC		7
> +#define GLAMO_IRQ_RISC		8
This is conflicting with enum glamo_irq, please fix your namespaces.


> +
> +/*
> + * Glamo internal settings
> + *
> + * We run the memory interface from the faster PLLB on 2.6.28 kernels and
> + * above.  Couple of GTA02 users report trouble with memory bus when they
> + * upgraded from 2.6.24.  So this parameter allows reversion to 2.6.24
> + * scheme if their Glamo chip needs it.
So you're saying that a couple users reported a bug on a specific kernel
revision, with the same HW, but all other users haven't ?
Couldnt that be related to a specific HW revision ? 
Also, this code should be scheduled for 2.6.37, and we're not going to
carry code to allow it to run on 2.6.28.


> +static const struct reg_range reg_range[] = {
> +	{ 0x0000, 0x76,		"General",	1 },
> +	{ 0x0200, 0x18,		"Host Bus",	1 },
> +	{ 0x0300, 0x38,		"Memory",	1 },
> +/*	{ 0x0400, 0x100,	"Sensor",	0 }, */
> +/*	{ 0x0500, 0x300,	"ISP",		0 }, */
> +/*	{ 0x0800, 0x400,	"JPEG",		0 }, */
> +/*	{ 0x0c00, 0xcc,		"MPEG",		0 }, */
> +	{ 0x1100, 0xb2,		"LCD 1",	0 },
> +	{ 0x1200, 0x64,		"LCD 2",	0 },
> +	{ 0x1400, 0x42,		"MMC",		0 },
> +/*	{ 0x1500, 0x080,	"MPU 0",	0 },
> +	{ 0x1580, 0x080,	"MPU 1",	0 },
> +	{ 0x1600, 0x080,	"Cmd Queue",	0 },
> +	{ 0x1680, 0x080,	"RISC CPU",	0 },*/
> +	{ 0x1700, 0x400,	"2D Unit",	0 },
> +/*	{ 0x1b00, 0x900,	"3D Unit",	0 }, */
> +};
Please remove the commented code from this array.


> +static void glamo_irq_demux_handler(unsigned int irq, struct irq_desc *desc)
> +{
> +	struct glamo_core *glamo = get_irq_desc_data(desc);
> +	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
> +
> +	if (unlikely(desc->status & IRQ_INPROGRESS)) {
> +		desc->status |= (IRQ_PENDING | IRQ_MASKED);
> +		desc->chip->mask(irq);
> +		desc->chip->ack(irq);
> +		return;
> +	}
> +	kstat_incr_irqs_this_cpu(irq, desc);
> +
> +	desc->chip->ack(irq);
> +	desc->status |= IRQ_INPROGRESS;
> +
> +	do {
> +		uint16_t irqstatus;
> +		int i;
> +
> +		if (unlikely((desc->status &
> +				(IRQ_PENDING | IRQ_MASKED | IRQ_DISABLED)) ==
> +				(IRQ_PENDING | IRQ_MASKED))) {
> +			/* dealing with pending IRQ, unmasking */
> +			desc->chip->unmask(irq);
> +			desc->status &= ~IRQ_MASKED;
> +		}
> +
> +		desc->status &= ~IRQ_PENDING;
> +
> +		/* read IRQ status register */
> +		irqstatus = __reg_read(glamo, GLAMO_REG_IRQ_STATUS);
> +		for (i = 0; i < 9; ++i) {
> +			if (irqstatus & BIT(i))
> +				generic_handle_irq(glamo->irq_base + i);
> +		}
> +
> +	} while ((desc->status & (IRQ_PENDING | IRQ_DISABLED)) == IRQ_PENDING);
So here you're busy looping in an interrupt handler, and that's not
recommended.


> +#ifdef CONFIG_DEBUG_FS
> +static ssize_t debugfs_regs_write(struct file *file,
> +				  const char __user *user_buf,
> +				  size_t count, loff_t *ppos)
> +{
> +	struct glamo_core *glamo = ((struct seq_file *)file->private_data)->private;
> +	char buf[14];
> +	unsigned int reg;
> +	unsigned int val;
> +	int buf_size;
> +
> +	buf_size = min(count, sizeof(buf) - 1);
> +	if (copy_from_user(buf, user_buf, buf_size))
> +		return -EFAULT;
> +	if (sscanf(buf, "%x %x", &reg, &val) != 2)
> +		return -EFAULT;
> +
> +	dev_info(&glamo->pdev->dev, "reg %#02x <-- %#04x\n", reg, val);
> +
> +	glamo_reg_write(glamo, reg, val);
> +
> +	return count;
> +}
> +
> +static int glamo_show_regs(struct seq_file *s, void *pos)
> +{
> +	struct glamo_core *glamo = s->private;
> +	int i, n;
> +	const struct reg_range *rr = reg_range;
> +
> +	spin_lock(&glamo->lock);
> +	for (i = 0; i < ARRAY_SIZE(reg_range); ++i, ++rr) {
> +		if (!rr->dump)
> +			continue;
> +		seq_printf(s, "\n%s\n", rr->name);
> +		for (n = rr->start; n < rr->start + rr->count; n += 2) {
> +			if ((n & 15) == 0)
> +				seq_printf(s, "\n%04X:  ", n);
> +			seq_printf(s, "%04x ", __reg_read(glamo, n));
> +		}
> +		seq_printf(s, "\n");
> +	}
> +	spin_unlock(&glamo->lock);
> +
> +	return 0;
> +}
> +
> +static int debugfs_open_file(struct inode *inode, struct file *file)
> +{
> +	return single_open(file, glamo_show_regs, inode->i_private);
> +}
> +
> +static const struct file_operations debugfs_regs_ops = {
> +	.open = debugfs_open_file,
> +	.read = seq_read,
> +	.llseek = seq_lseek,
> +	.write = debugfs_regs_write,
> +	.release	= single_release,
> +};
> +
> +struct glamo_engine_reg_set {
> +	uint16_t reg;
> +	uint16_t mask_suspended;
> +	uint16_t mask_enabled;
> +};
I think you want this definition outside of the DEBUGFS if.else.endif
scope. Have you tried building this driver without DEBUGFS enabled ?


> +static const struct glamo_engine_reg_set glamo_lcd_regs[] = {
> +	{ GLAMO_REG_CLOCK_LCD,
> +	GLAMO_CLOCK_LCD_EN_M5CLK |
> +	GLAMO_CLOCK_LCD_DG_M5CLK |
> +	GLAMO_CLOCK_LCD_EN_DMCLK,
> +
> +	GLAMO_CLOCK_LCD_EN_DHCLK |
> +	GLAMO_CLOCK_LCD_EN_DCLK
> +	},
> +	{ GLAMO_REG_CLOCK_GEN5_1,
> +	GLAMO_CLOCK_GEN51_EN_DIV_DMCLK,
> +
> +	GLAMO_CLOCK_GEN51_EN_DIV_DHCLK |
> +	GLAMO_CLOCK_GEN51_EN_DIV_DCLK
> +	}
> +};
Identation could be clearer here:
static const struct glamo_engine_reg_set glamo_lcd_regs[] = {
	{
		GLAMO_REG_CLOCK_LCD,

		GLAMO_CLOCK_LCD_EN_M5CLK |
		GLAMO_CLOCK_LCD_DG_M5CLK |
		GLAMO_CLOCK_LCD_EN_DMCLK,

		GLAMO_CLOCK_LCD_EN_DHCLK |
		GLAMO_CLOCK_LCD_EN_DCLK
	},
[...]



> +/***********************************************************************
> + * script support
> + ***********************************************************************/
> +
> +#define GLAMO_SCRIPT_END	0xffff
> +#define GLAMO_SCRIPT_WAIT	0xfffe
> +#define GLAMO_SCRIPT_LOCK_PLL	0xfffd
> +
> +/*
> + * couple of people reported artefacts with 2.6.28 changes, this
> + * allows reversion to 2.6.24 settings
> +*/
Same remark as with the module option: This is going to be a 2.6.37
driver, and I'd like you to check if you're still seeing those issues
before carrying these kind of hacks.


> +static const struct glamo_script glamo_init_script[] = {
> +	{ GLAMO_REG_CLOCK_HOST,		0x1000 },
> +	{ GLAMO_SCRIPT_WAIT,		     2 },
> +	{ GLAMO_REG_CLOCK_MEMORY,	0x1000 },
> +	{ GLAMO_REG_CLOCK_MEMORY,	0x2000 },
> +	{ GLAMO_REG_CLOCK_LCD,		0x1000 },
> +	{ GLAMO_REG_CLOCK_MMC,		0x1000 },
> +	{ GLAMO_REG_CLOCK_ISP,		0x1000 },
> +	{ GLAMO_REG_CLOCK_ISP,		0x3000 },
> +	{ GLAMO_REG_CLOCK_JPEG,		0x1000 },
> +	{ GLAMO_REG_CLOCK_3D,		0x1000 },
> +	{ GLAMO_REG_CLOCK_3D,		0x3000 },
> +	{ GLAMO_REG_CLOCK_2D,		0x1000 },
> +	{ GLAMO_REG_CLOCK_2D,		0x3000 },
> +	{ GLAMO_REG_CLOCK_RISC1,	0x1000 },
> +	{ GLAMO_REG_CLOCK_MPEG,		0x1000 },
> +	{ GLAMO_REG_CLOCK_MPEG,		0x3000 },
> +	{ GLAMO_REG_CLOCK_MPROC,	0x1000 /*0x100f*/ },
> +	{ GLAMO_SCRIPT_WAIT,		     2 },
> +	{ GLAMO_REG_CLOCK_HOST,		0x0000 },
> +	{ GLAMO_REG_CLOCK_MEMORY,	0x0000 },
> +	{ GLAMO_REG_CLOCK_LCD,		0x0000 },
> +	{ GLAMO_REG_CLOCK_MMC,		0x0000 },
> +	{ GLAMO_REG_PLL_GEN1,		0x05db },	/* 48MHz */
> +	{ GLAMO_REG_PLL_GEN3,		0x0aba },	/* 90MHz */
> +	{ GLAMO_SCRIPT_LOCK_PLL, 0 },
> +	/*
> +	 * b9 of this register MUST be zero to get any interrupts on INT#
> +	 * the other set bits enable all the engine interrupt sources
> +	 */
> +	{ GLAMO_REG_IRQ_ENABLE,		0x0100 },
> +	{ GLAMO_REG_CLOCK_GEN6,		0x2000 },
> +	{ GLAMO_REG_CLOCK_GEN7,		0x0101 },
> +	{ GLAMO_REG_CLOCK_GEN8,		0x0100 },
> +	{ GLAMO_REG_CLOCK_HOST,		0x000d },
> +	/*
> +	 * b7..b4 = 0 = no wait states on read or write
> +	 * b0 = 1 select PLL2 for Host interface, b1 = enable it
> +	 */
> +	{ GLAMO_REG_HOSTBUS(1),		0x0e03 /* this is replaced by script parser */ },
> +	{ GLAMO_REG_HOSTBUS(2),		0x07ff }, /* TODO: Disable all */
> +	{ GLAMO_REG_HOSTBUS(10),	0x0000 },
> +	{ GLAMO_REG_HOSTBUS(11),	0x4000 },
> +	{ GLAMO_REG_HOSTBUS(12),	0xf00e },
> +
> +	/* S-Media recommended "set tiling mode to 512 mode for memory access
> +	 * more efficiency when 640x480" */
> +	{ GLAMO_REG_MEM_TYPE,		0x0c74 }, /* 8MB, 16 word pg wr+rd */
> +	{ GLAMO_REG_MEM_GEN,		0xafaf }, /* 63 grants min + max */
> +
> +	{ GLAMO_REG_MEM_TIMING1,	0x0108 },
> +	{ GLAMO_REG_MEM_TIMING2,	0x0010 }, /* Taa = 3 MCLK */
> +	{ GLAMO_REG_MEM_TIMING3,	0x0000 },
> +	{ GLAMO_REG_MEM_TIMING4,	0x0000 }, /* CE1# delay fall/rise */
> +	{ GLAMO_REG_MEM_TIMING5,	0x0000 }, /* UB# LB# */
> +	{ GLAMO_REG_MEM_TIMING6,	0x0000 }, /* OE# */
> +	{ GLAMO_REG_MEM_TIMING7,	0x0000 }, /* WE# */
> +	{ GLAMO_REG_MEM_TIMING8,	0x1002 }, /* MCLK delay, was 0x1000 */
> +	{ GLAMO_REG_MEM_TIMING9,	0x6006 },
> +	{ GLAMO_REG_MEM_TIMING10,	0x00ff },
> +	{ GLAMO_REG_MEM_TIMING11,	0x0001 },
> +	{ GLAMO_REG_MEM_POWER1,		0x0020 },
> +	{ GLAMO_REG_MEM_POWER2,		0x0000 },
> +	{ GLAMO_REG_MEM_DRAM1,		0x0000 },
> +	{ GLAMO_SCRIPT_WAIT,		     1 },
> +	{ GLAMO_REG_MEM_DRAM1,		0xc100 },
> +	{ GLAMO_SCRIPT_WAIT,		     1 },
> +	{ GLAMO_REG_MEM_DRAM1,		0xe100 },
> +	{ GLAMO_REG_MEM_DRAM2,		0x01d6 },
> +	{ GLAMO_REG_CLOCK_MEMORY,	0x000b },
> +};
Shouldnt those values be set by your platform bootloader ? They're obviously
not, but I find it weird.


> +#ifdef CONFIG_PM
> +#if 0
> +static struct glamo_script glamo_resume_script[] = {
> +
> +	{ GLAMO_REG_PLL_GEN1,		0x05db },	/* 48MHz */
> +	{ GLAMO_REG_PLL_GEN3,		0x0aba },	/* 90MHz */
> +	{ GLAMO_REG_DFT_GEN6, 1 },
> +		{ 0xfffe, 100 },
> +		{ 0xfffd, 0 },
> +	{ 0x200,	0x0e03 },
> +
> +	/*
> +	 * b9 of this register MUST be zero to get any interrupts on INT#
> +	 * the other set bits enable all the engine interrupt sources
> +	 */
> +	{ GLAMO_REG_IRQ_ENABLE,		0x01ff },
> +	{ GLAMO_REG_CLOCK_HOST,		0x0018 },
> +	{ GLAMO_REG_CLOCK_GEN5_1, 0x18b1 },
> +
> +	{ GLAMO_REG_MEM_DRAM1,		0x0000 },
> +		{ 0xfffe, 1 },
> +	{ GLAMO_REG_MEM_DRAM1,		0xc100 },
> +		{ 0xfffe, 1 },
> +	{ GLAMO_REG_MEM_DRAM1,		0xe100 },
> +	{ GLAMO_REG_MEM_DRAM2,		0x01d6 },
> +	{ GLAMO_REG_CLOCK_MEMORY,	0x000b },
> +};
> +#endif
Please remove all #if 0 code from this driver.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

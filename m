Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab0FGO4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 10:56:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57911 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750881Ab0FGO4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 10:56:52 -0400
Date: Mon, 7 Jun 2010 16:05:15 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Masayuki Ohtak <masa-korg@dsn.okisemi.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew <andrew.chih.howe.khor@intel.com>,
       Intel OTC <joel.clark@intel.com>, "Wang, Qi" <qi.wang@intel.com>,
       "Wang, Yong Y" <yong.y.wang@intel.com>
Subject: Re: [PATCH] Topcliff PHUB: Generate PacketHub driver
Message-ID: <20100607160515.5cb00150@lxorguk.ukuu.org.uk>
In-Reply-To: <4C0CE88C.9050708@dsn.okisemi.com>
References: <4C0CE88C.9050708@dsn.okisemi.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O> +/* Status Register offset */
> +#define PHUB_STATUS (0x00)
> +/* Control Register offset */
> +#define PHUB_CONTROL (0x04)
> +/* Time out value for Status Register */
> +#define PHUB_TIMEOUT (0x05)
> +/* Enabling for writing ROM */
> +#define PCH_PHUB_ROM_WRITE_ENABLE (0x01)
> +/* Disabling for writing ROM */
> +#define PCH_PHUB_ROM_WRITE_DISABLE (0x00)
> +/* ROM data area start address offset */
> +#define PCH_PHUB_ROM_START_ADDR (0x14)
> +/* MAX number of INT_REDUCE_CONTROL registers */
> +#define MAX_NUM_INT_REDUCE_CONTROL_REG (128)
> +
> +#define PCI_DEVICE_ID_PCH1_PHUB (0x8801)
> +
> +#define PCH_MINOR_NOS (1)
> +#define CLKCFG_CAN_50MHZ (0x12000000)
> +#define CLKCFG_CANCLK_MASK (0xFF000000)

Style: constants don't need brackets - might also look more Linux like
tabbed out a bit

> +#define PCH_READ_REG(a)	ioread32((pch_phub_base_address + a))
> +
> +#define PCH_WRITE_REG(a, b)	iowrite32(a, (pch_phub_base_address + b))

These on the other hand do - but not where they are now

	iowrite32((a), pcb_phub_base_address + (b))

(so that if a or b are expressions they are evaluated first)


> +struct pch_phub_reg {
> +	u32 phub_id_reg;		/* PHUB_ID register val */
> +	u32 q_pri_val_reg;		/* QUEUE_PRI_VAL register val */
> +	u32 rc_q_maxsize_reg;	/* RC_QUEUE_MAXSIZE register val */
> +	u32 bri_q_maxsize_reg;	/* BRI_QUEUE_MAXSIZE register val */
> +	u32 comp_resp_timeout_reg;	/* COMP_RESP_TIMEOUT register val */
> +	u32 bus_slave_control_reg;	/* BUS_SLAVE_CONTROL_REG register val */
> +	u32 deadlock_avoid_type_reg; /* DEADLOCK_AVOID_TYPE register val */
> +	u32 intpin_reg_wpermit_reg0; /* INTPIN_REG_WPERMIT register 0 val */
> +	u32 intpin_reg_wpermit_reg1; /* INTPIN_REG_WPERMIT register 1 val */
> +	u32 intpin_reg_wpermit_reg2; /* INTPIN_REG_WPERMIT register 2 val */
> +	u32 intpin_reg_wpermit_reg3; /* INTPIN_REG_WPERMIT register 3 val */
> +	/* INT_REDUCE_CONTROL registers val */
> +	u32 int_reduce_control_reg[MAX_NUM_INT_REDUCE_CONTROL_REG];
> +#ifdef PCH_CAN_PCLK_50MHZ
> +	u32 clkcfg_reg;		/* CLK CFG register val */
> +#endif
> +} g_pch_phub_reg;

Stylewise the kernel doesn't use the g_ convention that many Windows
people do, so lose the g_

> +s32 pch_phub_opencount;	/* check whether opened or not */
> +u32 pch_phub_base_address;
> +u32 pch_phub_extrom_base_address;
> +s32 pch_phub_suspended;

Any reason these can't be in the struct ?
> +
> +struct device *dev_dbg;

Not a good name for a global variable as it will clash with others 

> +DEFINE_SPINLOCK(pch_phub_lock);	/* for spin lock */

Can this be static or in the struct ?

> +
> +/**
> + * file_operations structure initialization
> + */
> +const struct file_operations pch_phub_fops = {
> +	.owner = THIS_MODULE,
> +	.open = pch_phub_open,
> +	.release = pch_phub_release,
> +	.ioctl = pch_phub_ioctl,
> +};

static const ?

> +/*--------------------------------------------
> +	exported function prototypes
> +--------------------------------------------*/

They start 'static' I don't think they are exportdd !

> +static int __devinit pch_phub_probe(struct pci_dev *pdev, const
> +				       struct pci_device_id *id);
> +static void __devexit pch_phub_remove(struct pci_dev *pdev);
> +static int pch_phub_suspend(struct pci_dev *pdev, pm_message_t state);
> +static int pch_phub_resume(struct pci_dev *pdev);

> +static struct pci_driver pch_phub_driver = {
> +	.name = "pch_phub",
> +	.id_table = pch_phub_pcidev_id,
> +	.probe = pch_phub_probe,
> +	.remove = __devexit_p(pch_phub_remove),
> +#ifdef CONFIG_PM
> +	.suspend = pch_phub_suspend,
> +	.resume = pch_phub_resume
> +#endif
> +};
> +
> +static int __init pch_phub_pci_init(void);
> +static void __exit pch_phub_pci_exit(void);
> +
> +MODULE_DESCRIPTION("PCH PACKET HUB PCI Driver");
> +MODULE_LICENSE("GPL");
> +module_init(pch_phub_pci_init);
> +module_exit(pch_phub_pci_exit);
> +module_param(pch_phub_major_no, int, S_IRUSR | S_IWUSR);

If you migrated the module registration/PCI registration to the bottom of
the file you could avoid the forward declations and make the code easier
to follow ?

> +void pch_phub_read_modify_write_reg(unsigned long reg_addr_offset,
> +				       unsigned long data, unsigned long mask)
> +{
> +	unsigned long reg_addr = pch_phub_base_address + reg_addr_offset;
> +	iowrite32(((ioread32((void __iomem *)reg_addr) & ~mask)) | data,
> +			(void __iomem *)reg_addr);

When you have that many casts in a line it's perhaps a hint you have the
types wrong initially. At the very least reg_addr should be void __iomem,
and probably pch_phub_base_address should be 

It would probably make sense to pass a pointer to your struct pch_hub_reg
and use that to hold the base address. Then if you ever get a box with
two in some future design it won't be a disaster

> +void pch_phub_save_reg_conf(void)

Ditto 

> +#ifdef PCH_CAN_PCLK_50MHZ
> +	/* save clk cfg register */
> +	g_pch_phub_reg.clkcfg_reg = PCH_READ_REG(CLKCFG_REG_OFFSET);
> +#endif

This makes it hard to build one kernel for everything

> +	return;
> +}

> +void pch_phub_restore_reg_conf(void)
> +{
> +	u32 i = 0;

Why = 0, if you do that here you may hide initialisation errors from
future changes ?

> +/** pch_phub_read_serial_rom - Implements the functionality of reading Serial
> + *  									 ROM.
> + *  @offset_address: Contains the Serial ROM address offset value
> + *  @data: Contains the Serial ROM value
> + */
> +int pch_phub_read_serial_rom(unsigned long offset_address, unsigned char *data)
> +{
> +	unsigned long mem_addr = pch_phub_extrom_base_address + offset_address;
> +
> +	dev_dbg(dev_dbg,
> +		"pch_phub_read_serial_rom:mem_addr=0x%08x\n", (u32)mem_addr);
> +	*data = ioread8((void __iomem *)mem_addr);

Same comments about casts



> +int pch_phub_ioctl(struct inode *inode, struct file *file,
> +			unsigned int cmd, unsigned long arg)
> +{
> +	int ret_value = 0;
> +	struct pch_phub_reqt *p_pch_phub_reqt;
> +	unsigned long addr_offset;

This will change size on 32/64bit boxes makign your copy a bit
problematic 

> +	p_pch_phub_reqt = (struct pch_phub_reqt *)arg;
> +	ret_value = copy_from_user((void *)&addr_offset,
> +				(void *)&p_pch_phub_reqt->addr_offset,
> +				sizeof(addr_offset));
> +	if (ret_value) {

> +	/* End of Access area check */

Remember here ioctl isn't single threaded so you may want to double check
some of these

> +struct pch_phub_reqt {
> +	unsigned long addr_offset;	/*specifies the register address
> +								 offset */
> +	unsigned long data;	/*specifies the data */
> +	unsigned long mask;	/*specifies the mask */

If they may need to be long make them u64. That way 32 and 64bit systems
get the same ioctl structure and life is good.

> +};
> +
> +/* exported function prototypes */
> +int pch_phub_open(struct inode *inode, struct file *file);
> +int pch_phub_release(struct inode *inode, struct file *file);
> +int pch_phub_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
> +		      unsigned long arg);

You have various other functions that are not static - if they should be
then make them static

Alan

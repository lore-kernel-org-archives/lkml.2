Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab0HRNO3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 09:14:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46921 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120Ab0HRNO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 09:14:26 -0400
Date: Wed, 18 Aug 2010 06:14:01 -0700
From: Greg KH <gregkh@suse.de>
To: Masayuki Ohtak <masa-korg@dsn.okisemi.com>
Cc: meego-dev@meego.com, LKML <linux-kernel@vger.kernel.org>,
        yong.y.wang@intel.com, qi.wang@intel.com,
        andrew.chih.howe.khor@intel.com, arjan@linux.intel.com,
        alan@linux.intel.com, margie.foster@intel.com
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_PHUB driver to 2.6.35
Message-ID: <20100818131401.GA5861@suse.de>
References: <4C6BA385.80409@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C6BA385.80409@dsn.okisemi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 06:10:29PM +0900, Masayuki Ohtak wrote:
> Hi Greg,
> 
> We have modified our phub driver with sysfs I/F.

What is "I/F"?

The driver is a lot better, thanks for doing this.  It's also simpler,
right?

> Please check below.
> 
> Best Regards, Ohtake(OKISEMI).
> 
> ---
> Packet hub driver of Topcliff PCH
> 
> Topcliff PCH is the platform controller hub that is going to be used in
> Intel's upcoming general embedded platform. All IO peripherals in
> Topcliff PCH are actually devices sitting on AMBA bus. Packet hub is
> a special converter device in Topcliff PCH that translate AMBA transactions
> to PCI Express transactions and vice versa. Thus packet hub helps present
> all IO peripherals in Topcliff PCH as PCIE devices to IA system.
> Topcliff PCH has MAC address and Option ROM data.
> These data are in SROM which is connected to PCIE bus.
> Packet hub driver of Topcliff PCH can access MAC address and Option ROM data in
> SROM via sysfs I/F.
> The driver creates a character device /dev/pch_phub. That device file
> supports the following operations:
> 

What operations?

> Signed-off-by: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>

I don't think that Arnd has "acked" this version, right?

> ---
>  drivers/misc/Kconfig    |    9 +
>  drivers/misc/Makefile   |    1 +
>  drivers/misc/pch_phub.c |  722 +++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 732 insertions(+), 0 deletions(-)
>  create mode 100755 drivers/misc/pch_phub.c

You forgot to add documentation for your sysfs files in
Documentation/ABI/ which is a requiremend when you add new ones.

> 
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index 26386a9..c998521 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -353,6 +353,15 @@ config VMWARE_BALLOON
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called vmware_balloon.
>  
> +config PCH_PHUB
> +	tristate "PCH Packet Hub of Intel Topcliff"
> +	depends on PCI
> +	help
> +	  This driver is for PCH PHUB of Topcliff which is an IOH for x86
> +	  embedded processor.

Please spell out what "PCH" "PHUB" and "IOH" is.


> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/types.h>
> +#include <linux/fs.h>
> +#include <linux/uaccess.h>
> +#include <linux/string.h>
> +#include <linux/pci.h>
> +#include <linux/io.h>
> +#include <linux/delay.h>
> +#include <linux/cdev.h>

This isn't needed anymore.

> +#include <linux/device.h>

pci.h already includes this.

> +#include <linux/mutex.h>
> +#include <linux/if_ether.h>
> +#include <linux/ctype.h>
> +
> +#define PHUB_STATUS 0x00		/* Status Register offset */
> +#define PHUB_CONTROL 0x04		/* Control Register offset */
> +#define PHUB_TIMEOUT 0x05		/* Time out value for Status Register */
> +#define PCH_PHUB_ROM_WRITE_ENABLE 0x01	/* Enabling for writing ROM */
> +#define PCH_PHUB_ROM_WRITE_DISABLE 0x00	/* Disabling for writing ROM */
> +#define PCH_PHUB_ROM_START_ADDR 0x14	/* ROM data area start address offset */
> +
> +/* MAX number of INT_REDUCE_CONTROL registers */
> +#define MAX_NUM_INT_REDUCE_CONTROL_REG 128
> +#define PCI_DEVICE_ID_PCH1_PHUB 0x8801
> +#define PCH_MINOR_NOS 1
> +#define CLKCFG_CAN_50MHZ 0x12000000
> +#define CLKCFG_CANCLK_MASK 0xFF000000
> +#define MODULE_NAME "pch_phub"

This isn't needed, right?  The kernel provides this to you in the build
service automatically.

> +
> +#define PHUB_IOCTL_MAGIC		0xf7
> +
> +/* Read GbE MAC address */
> +#define IOCTL_PHUB_READ_MAC_ADDR (_IOR(PHUB_IOCTL_MAGIC, 1, __u8[ETH_ALEN]))
> +
> +/* Write GbE MAC address */
> +#define IOCTL_PHUB_WRITE_MAC_ADDR (_IOW(PHUB_IOCTL_MAGIC, 2, __u8[ETH_ALEN]))

These 3 things are no longer needed, right?


> +
> +/* SROM ACCESS Macro */
> +#define PCH_WORD_ADDR_MASK (~((1 << 2) - 1))
> +
> +/* Registers address offset */
> +#define PCH_PHUB_ID_REG				0x0000
> +#define PCH_PHUB_QUEUE_PRI_VAL_REG		0x0004
> +#define PCH_PHUB_RC_QUEUE_MAXSIZE_REG		0x0008
> +#define PCH_PHUB_BRI_QUEUE_MAXSIZE_REG		0x000C
> +#define PCH_PHUB_COMP_RESP_TIMEOUT_REG		0x0010
> +#define PCH_PHUB_BUS_SLAVE_CONTROL_REG		0x0014
> +#define PCH_PHUB_DEADLOCK_AVOID_TYPE_REG	0x0018
> +#define PCH_PHUB_INTPIN_REG_WPERMIT_REG0	0x0020
> +#define PCH_PHUB_INTPIN_REG_WPERMIT_REG1	0x0024
> +#define PCH_PHUB_INTPIN_REG_WPERMIT_REG2	0x0028
> +#define PCH_PHUB_INTPIN_REG_WPERMIT_REG3	0x002C
> +#define PCH_PHUB_INT_REDUCE_CONTROL_REG_BASE	0x0040
> +#define CLKCFG_REG_OFFSET			0x500
> +
> +#define PCH_PHUB_OROM_SIZE 15360
> +
> +/**
> + * struct pch_phub_reg - PHUB register structure
> + * @phub_id_reg:			PHUB_ID register val
> + * @q_pri_val_reg:			QUEUE_PRI_VAL register val
> + * @rc_q_maxsize_reg:			RC_QUEUE_MAXSIZE register val
> + * @bri_q_maxsize_reg:			BRI_QUEUE_MAXSIZE register val
> + * @comp_resp_timeout_reg:		COMP_RESP_TIMEOUT register val
> + * @bus_slave_control_reg:		BUS_SLAVE_CONTROL_REG register val
> + * @deadlock_avoid_type_reg:		DEADLOCK_AVOID_TYPE register val
> + * @intpin_reg_wpermit_reg0:		INTPIN_REG_WPERMIT register 0 val
> + * @intpin_reg_wpermit_reg1:		INTPIN_REG_WPERMIT register 1 val
> + * @intpin_reg_wpermit_reg2:		INTPIN_REG_WPERMIT register 2 val
> + * @intpin_reg_wpermit_reg3:		INTPIN_REG_WPERMIT register 3 val
> + * @int_reduce_control_reg:		INT_REDUCE_CONTROL registers val
> + * @clkcfg_reg:				CLK CFG register val
> + * @pch_phub_base_address:		Register base address
> + * @pch_phub_extrom_base_address:	external rom base address
> + * @pch_phub_suspended:			PHUB status val
> + */
> +struct pch_phub_reg {
> +	u32 phub_id_reg;
> +	u32 q_pri_val_reg;
> +	u32 rc_q_maxsize_reg;
> +	u32 bri_q_maxsize_reg;
> +	u32 comp_resp_timeout_reg;
> +	u32 bus_slave_control_reg;
> +	u32 deadlock_avoid_type_reg;
> +	u32 intpin_reg_wpermit_reg0;
> +	u32 intpin_reg_wpermit_reg1;
> +	u32 intpin_reg_wpermit_reg2;
> +	u32 intpin_reg_wpermit_reg3;
> +	u32 int_reduce_control_reg[MAX_NUM_INT_REDUCE_CONTROL_REG];
> +	u32 clkcfg_reg;
> +	void __iomem *pch_phub_base_address;
> +	void __iomem *pch_phub_extrom_base_address;
> +	int pch_phub_suspended;

You only ever set this value, not read it, so you can delete it.

> +};
> +
> +/* SROM SPEC for MAC address assignment offset */
> +static const int pch_phub_mac_offset[ETH_ALEN] = {0x3, 0x2, 0x1, 0x0, 0xb, 0xa};
> +
> +static DEFINE_MUTEX(pch_phub_mutex);
> +static struct pch_phub_reg pch_phub_reg;

So you can only have one of these devices in a system at the same time?
What happens when a machine ships with two of them?

> +
> +/**
> + * pch_phub_read_modify_write_reg() - Reading modifying and writing register
> + * @reg_addr_offset:	Register offset address value.
> + * @data:		Writing value.
> + * @mask:		Mask value.
> + */
> +static void pch_phub_read_modify_write_reg(unsigned int reg_addr_offset,
> +					   unsigned int data, unsigned int mask)
> +{
> +	void __iomem *reg_addr = pch_phub_reg.pch_phub_base_address +
> +					 reg_addr_offset;
> +	iowrite32(((ioread32(reg_addr) & ~mask)) | data, reg_addr);
> +}
> +
> +/* pch_phub_save_reg_conf - saves register configuration */
> +static void pch_phub_save_reg_conf(struct pci_dev *pdev)
> +{
> +	unsigned int i;
> +	void __iomem *p = pch_phub_reg.pch_phub_base_address;
> +
> +	pch_phub_reg.phub_id_reg = ioread32(p + PCH_PHUB_ID_REG);
> +	pch_phub_reg.q_pri_val_reg = ioread32(p + PCH_PHUB_QUEUE_PRI_VAL_REG);
> +	pch_phub_reg.rc_q_maxsize_reg =
> +	    ioread32(p + PCH_PHUB_RC_QUEUE_MAXSIZE_REG);
> +	pch_phub_reg.bri_q_maxsize_reg =
> +	    ioread32(p + PCH_PHUB_BRI_QUEUE_MAXSIZE_REG);
> +	pch_phub_reg.comp_resp_timeout_reg =
> +	    ioread32(p + PCH_PHUB_COMP_RESP_TIMEOUT_REG);
> +	pch_phub_reg.bus_slave_control_reg =
> +	    ioread32(p + PCH_PHUB_BUS_SLAVE_CONTROL_REG);
> +	pch_phub_reg.deadlock_avoid_type_reg =
> +	    ioread32(p + PCH_PHUB_DEADLOCK_AVOID_TYPE_REG);
> +	pch_phub_reg.intpin_reg_wpermit_reg0 =
> +	    ioread32(p + PCH_PHUB_INTPIN_REG_WPERMIT_REG0);
> +	pch_phub_reg.intpin_reg_wpermit_reg1 =
> +	    ioread32(p + PCH_PHUB_INTPIN_REG_WPERMIT_REG1);
> +	pch_phub_reg.intpin_reg_wpermit_reg2 =
> +	    ioread32(p + PCH_PHUB_INTPIN_REG_WPERMIT_REG2);
> +	pch_phub_reg.intpin_reg_wpermit_reg3 =
> +	    ioread32(p + PCH_PHUB_INTPIN_REG_WPERMIT_REG3);
> +	dev_dbg(&pdev->dev, "%s : "
> +		"pch_phub_reg.phub_id_reg=%x, "
> +		"pch_phub_reg.q_pri_val_reg=%x, "
> +		"pch_phub_reg.rc_q_maxsize_reg=%x, "
> +		"pch_phub_reg.bri_q_maxsize_reg=%x, "
> +		"pch_phub_reg.comp_resp_timeout_reg=%x, "
> +		"pch_phub_reg.bus_slave_control_reg=%x, "
> +		"pch_phub_reg.deadlock_avoid_type_reg=%x, "
> +		"pch_phub_reg.intpin_reg_wpermit_reg0=%x, "
> +		"pch_phub_reg.intpin_reg_wpermit_reg1=%x, "
> +		"pch_phub_reg.intpin_reg_wpermit_reg2=%x, "
> +		"pch_phub_reg.intpin_reg_wpermit_reg3=%x\n", __func__,
> +		pch_phub_reg.phub_id_reg,
> +		pch_phub_reg.q_pri_val_reg,
> +		pch_phub_reg.rc_q_maxsize_reg,
> +		pch_phub_reg.bri_q_maxsize_reg,
> +		pch_phub_reg.comp_resp_timeout_reg,
> +		pch_phub_reg.bus_slave_control_reg,
> +		pch_phub_reg.deadlock_avoid_type_reg,
> +		pch_phub_reg.intpin_reg_wpermit_reg0,
> +		pch_phub_reg.intpin_reg_wpermit_reg1,
> +		pch_phub_reg.intpin_reg_wpermit_reg2,
> +		pch_phub_reg.intpin_reg_wpermit_reg3);
> +	for (i = 0; i < MAX_NUM_INT_REDUCE_CONTROL_REG; i++) {
> +		pch_phub_reg.int_reduce_control_reg[i] =
> +		    ioread32(p + PCH_PHUB_INT_REDUCE_CONTROL_REG_BASE + 4 * i);
> +		dev_dbg(&pdev->dev, "%s : "
> +			"pch_phub_reg.int_reduce_control_reg[%d]=%x\n",
> +			__func__, i, pch_phub_reg.int_reduce_control_reg[i]);
> +	}
> +	pch_phub_reg.clkcfg_reg = ioread32(p + CLKCFG_REG_OFFSET);
> +}
> +
> +/* pch_phub_restore_reg_conf - restore register configuration */
> +static void pch_phub_restore_reg_conf(struct pci_dev *pdev)
> +{
> +	unsigned int i;
> +	void __iomem *p = pch_phub_reg.pch_phub_base_address;
> +
> +	iowrite32(pch_phub_reg.phub_id_reg, p + PCH_PHUB_ID_REG);
> +	iowrite32(pch_phub_reg.q_pri_val_reg, p + PCH_PHUB_QUEUE_PRI_VAL_REG);
> +	iowrite32(pch_phub_reg.rc_q_maxsize_reg,
> +					p + PCH_PHUB_RC_QUEUE_MAXSIZE_REG);
> +	iowrite32(pch_phub_reg.bri_q_maxsize_reg,
> +					p + PCH_PHUB_BRI_QUEUE_MAXSIZE_REG);
> +	iowrite32(pch_phub_reg.comp_resp_timeout_reg,
> +					p + PCH_PHUB_COMP_RESP_TIMEOUT_REG);
> +	iowrite32(pch_phub_reg.bus_slave_control_reg,
> +					p + PCH_PHUB_BUS_SLAVE_CONTROL_REG);
> +	iowrite32(pch_phub_reg.deadlock_avoid_type_reg,
> +					p + PCH_PHUB_DEADLOCK_AVOID_TYPE_REG);
> +	iowrite32(pch_phub_reg.intpin_reg_wpermit_reg0,
> +					p + PCH_PHUB_INTPIN_REG_WPERMIT_REG0);
> +	iowrite32(pch_phub_reg.intpin_reg_wpermit_reg1,
> +					p + PCH_PHUB_INTPIN_REG_WPERMIT_REG1);
> +	iowrite32(pch_phub_reg.intpin_reg_wpermit_reg2,
> +					p + PCH_PHUB_INTPIN_REG_WPERMIT_REG2);
> +	iowrite32(pch_phub_reg.intpin_reg_wpermit_reg3,
> +					p + PCH_PHUB_INTPIN_REG_WPERMIT_REG3);
> +	dev_dbg(&pdev->dev, "%s : "
> +		"pch_phub_reg.phub_id_reg=%x, "
> +		"pch_phub_reg.q_pri_val_reg=%x, "
> +		"pch_phub_reg.rc_q_maxsize_reg=%x, "
> +		"pch_phub_reg.bri_q_maxsize_reg=%x, "
> +		"pch_phub_reg.comp_resp_timeout_reg=%x, "
> +		"pch_phub_reg.bus_slave_control_reg=%x, "
> +		"pch_phub_reg.deadlock_avoid_type_reg=%x, "
> +		"pch_phub_reg.intpin_reg_wpermit_reg0=%x, "
> +		"pch_phub_reg.intpin_reg_wpermit_reg1=%x, "
> +		"pch_phub_reg.intpin_reg_wpermit_reg2=%x, "
> +		"pch_phub_reg.intpin_reg_wpermit_reg3=%x\n", __func__,
> +		pch_phub_reg.phub_id_reg,
> +		pch_phub_reg.q_pri_val_reg,
> +		pch_phub_reg.rc_q_maxsize_reg,
> +		pch_phub_reg.bri_q_maxsize_reg,
> +		pch_phub_reg.comp_resp_timeout_reg,
> +		pch_phub_reg.bus_slave_control_reg,
> +		pch_phub_reg.deadlock_avoid_type_reg,
> +		pch_phub_reg.intpin_reg_wpermit_reg0,
> +		pch_phub_reg.intpin_reg_wpermit_reg1,
> +		pch_phub_reg.intpin_reg_wpermit_reg2,
> +		pch_phub_reg.intpin_reg_wpermit_reg3);
> +	for (i = 0; i < MAX_NUM_INT_REDUCE_CONTROL_REG; i++) {
> +		iowrite32(pch_phub_reg.int_reduce_control_reg[i],
> +			p + PCH_PHUB_INT_REDUCE_CONTROL_REG_BASE + 4 * i);
> +		dev_dbg(&pdev->dev, "%s : "
> +			"pch_phub_reg.int_reduce_control_reg[%d]=%x\n",
> +			__func__, i, pch_phub_reg.int_reduce_control_reg[i]);
> +	}
> +
> +	iowrite32(pch_phub_reg.clkcfg_reg, p + CLKCFG_REG_OFFSET);
> +}
> +
> +/**
> + * pch_phub_read_serial_rom() - Reading Serial ROM
> + * @offset_address:	Serial ROM offset address to read.
> + * @data:		Read buffer for specified Serial ROM value.
> + */
> +static void pch_phub_read_serial_rom(unsigned int offset_address, u8 *data)
> +{
> +	void __iomem *mem_addr = pch_phub_reg.pch_phub_extrom_base_address +
> +					 offset_address;
> +
> +	*data = ioread8(mem_addr);
> +}
> +
> +/**
> + * pch_phub_write_serial_rom() - Writing Serial ROM
> + * @offset_address:	Serial ROM offset address.
> + * @data:		Serial ROM value to write.
> + */
> +static int pch_phub_write_serial_rom(unsigned int offset_address, u8 data)
> +{
> +	void __iomem *mem_addr = pch_phub_reg.pch_phub_extrom_base_address +
> +					(offset_address & PCH_WORD_ADDR_MASK);
> +	int i;
> +	unsigned int word_data;
> +	unsigned int pos;
> +	unsigned int mask;
> +	pos = (offset_address % 4) * 8;
> +	mask = ~(0xFF << pos);
> +
> +	iowrite32(PCH_PHUB_ROM_WRITE_ENABLE,
> +			pch_phub_reg.pch_phub_extrom_base_address +
> +			PHUB_CONTROL);
> +
> +	word_data = ioread32(mem_addr);
> +	iowrite32((word_data & mask) | (u32)data << pos, mem_addr);
> +
> +	i = 0;
> +	while (ioread8(pch_phub_reg.pch_phub_extrom_base_address +
> +						PHUB_STATUS) != 0x00) {
> +		msleep(1);
> +		if (PHUB_TIMEOUT == i)

Switch this the other way around.  Linux usually puts the constants on
the right side of the if statement, not the left.

> +			return -EPERM;

Not -ETIMEDOUT?

> +		i++;
> +	}
> +
> +	iowrite32(PCH_PHUB_ROM_WRITE_DISABLE,
> +			pch_phub_reg.pch_phub_extrom_base_address +
> +			PHUB_CONTROL);
> +
> +	return 0;
> +}
> +
> +/**
> + * pch_phub_read_serial_rom_val() - Read Serial ROM value
> + * @offset_address:	Serial ROM address offset value.
> + * @data:		Serial ROM value to read.
> + */
> +static void pch_phub_read_serial_rom_val(unsigned int offset_address, u8 *data)
> +{
> +	unsigned int mem_addr;
> +
> +	mem_addr = PCH_PHUB_ROM_START_ADDR +
> +			pch_phub_mac_offset[offset_address];
> +
> +	pch_phub_read_serial_rom(mem_addr, data);
> +}
> +
> +/**
> + * pch_phub_write_serial_rom_val() - writing Serial ROM value
> + * @offset_address:	Serial ROM address offset value.
> + * @data:		Serial ROM value.
> + */
> +static int pch_phub_write_serial_rom_val(unsigned int offset_address, u8 data)
> +{
> +	int retval;
> +	unsigned int mem_addr;
> +
> +	mem_addr = PCH_PHUB_ROM_START_ADDR +
> +			pch_phub_mac_offset[offset_address];
> +
> +	retval = pch_phub_write_serial_rom(mem_addr, data);
> +
> +	return retval;
> +}
> +
> +/* pch_phub_gbe_serial_rom_conf - makes Serial ROM header format configuration
> + * for Gigabit Ethernet MAC address
> + */
> +static int pch_phub_gbe_serial_rom_conf(void)
> +{
> +	int retval;
> +
> +	retval = pch_phub_write_serial_rom(0x0b, 0xbc);
> +	retval |= pch_phub_write_serial_rom(0x0a, 0x10);
> +	retval |= pch_phub_write_serial_rom(0x09, 0x01);
> +	retval |= pch_phub_write_serial_rom(0x08, 0x02);
> +
> +	retval |= pch_phub_write_serial_rom(0x0f, 0x00);
> +	retval |= pch_phub_write_serial_rom(0x0e, 0x00);
> +	retval |= pch_phub_write_serial_rom(0x0d, 0x00);
> +	retval |= pch_phub_write_serial_rom(0x0c, 0x80);
> +
> +	retval |= pch_phub_write_serial_rom(0x13, 0xbc);
> +	retval |= pch_phub_write_serial_rom(0x12, 0x10);
> +	retval |= pch_phub_write_serial_rom(0x11, 0x01);
> +	retval |= pch_phub_write_serial_rom(0x10, 0x18);
> +
> +	retval |= pch_phub_write_serial_rom(0x1b, 0xbc);
> +	retval |= pch_phub_write_serial_rom(0x1a, 0x10);
> +	retval |= pch_phub_write_serial_rom(0x19, 0x01);
> +	retval |= pch_phub_write_serial_rom(0x18, 0x19);
> +
> +	retval |= pch_phub_write_serial_rom(0x23, 0xbc);
> +	retval |= pch_phub_write_serial_rom(0x22, 0x10);
> +	retval |= pch_phub_write_serial_rom(0x21, 0x01);
> +	retval |= pch_phub_write_serial_rom(0x20, 0x3a);
> +
> +	retval |= pch_phub_write_serial_rom(0x27, 0x01);
> +	retval |= pch_phub_write_serial_rom(0x26, 0x00);
> +	retval |= pch_phub_write_serial_rom(0x25, 0x00);
> +	retval |= pch_phub_write_serial_rom(0x24, 0x00);
> +
> +	return retval;
> +}
> +
> +/**
> + * pch_phub_read_gbe_mac_addr() - Read Gigabit Ethernet MAC address
> + * @offset_address:	Gigabit Ethernet MAC address offset value.
> + * @data:		Buffer of the Gigabit Ethernet MAC address value.
> + */
> +static void pch_phub_read_gbe_mac_addr(u8 *data)
> +{
> +	int i;
> +	for (i = 0; i < ETH_ALEN; i++)
> +		pch_phub_read_serial_rom_val(i, &data[i]);
> +}
> +
> +/**
> + * pch_phub_write_gbe_mac_addr() - Write MAC address
> + * @offset_address:	Gigabit Ethernet MAC address offset value.
> + * @data:		Gigabit Ethernet MAC address value.
> + */
> +static int pch_phub_write_gbe_mac_addr(u8 *data)
> +{
> +	int retval;
> +	int i;
> +
> +	retval = pch_phub_gbe_serial_rom_conf();
> +	if (retval)
> +		return retval;
> +
> +	for (i = 0; i < ETH_ALEN; i++) {
> +		retval = pch_phub_write_serial_rom_val(i, data[i]);
> +		if (retval)
> +			return retval;
> +	}
> +
> +	return retval;
> +}
> +
> +static ssize_t pch_phub_bin_read(struct kobject *kobj,
> +				 struct bin_attribute *attr, char *buf,
> +				 loff_t off, size_t count)
> +{
> +	unsigned int rom_signature;
> +	unsigned char rom_length;
> +	unsigned int tmp;
> +	unsigned char data;
> +	unsigned int addr_offset;
> +	unsigned int orom_size;
> +	int ret;
> +	int err;
> +	int cnt;
> +
> +	ret = mutex_lock_interruptible(&pch_phub_mutex);
> +	if (ret) {
> +		err = -ERESTARTSYS;
> +		goto return_err_nomutex;
> +	}
> +
> +	/* Get Rom signature */
> +	pch_phub_read_serial_rom(0x80, (unsigned char *)&rom_signature);
> +	rom_signature &= 0xff;
> +	pch_phub_read_serial_rom(0x81, (unsigned char *)&tmp);
> +	rom_signature |= (tmp & 0xff) << 8;
> +	if (rom_signature == 0xAA55) {

What is 0xAA55 for?

> +		pch_phub_read_serial_rom(0x82, &rom_length);
> +		orom_size = rom_length * 512;
> +		if (orom_size < off) {
> +			addr_offset = 0;
> +			goto return_ok;
> +		}

Nice that you check, but you can still read more data than you mean to
here, right?  Shouldn't you be checking "count" as well?

> +
> +		for (addr_offset = 0; addr_offset < count; addr_offset++) {
> +			pch_phub_read_serial_rom(0x80 + addr_offset + off,
> +									 &data);
> +			cnt += sprintf(buf+addr_offset, "%c", data);

Why not just:
	buf[addr_offset] = data;
	cnt++;

No need to call sprintf, right?

Or even better yet, do:
	pch_phub_read_serial_rom(0x80 + addr_offset + off, &buf[addr_offset]);
	cnt++;
to save a step.

And what's the "0x80" offset for?


> +		}
> +	} else {
> +		err = -ENODATA;
> +		goto return_err;
> +	}
> +return_ok:
> +	mutex_unlock(&pch_phub_mutex);
> +	return count;
> +
> +return_err:
> +	mutex_unlock(&pch_phub_mutex);
> +return_err_nomutex:
> +	return err;
> +}
> +
> +static ssize_t pch_phub_bin_write(struct kobject *kobj,
> +				  struct bin_attribute *attr,
> +				  char *buf, loff_t off, size_t count)
> +{
> +	int ret_value2;
> +	int err;
> +	unsigned int addr_offset;
> +	int ret;
> +
> +	ret = mutex_lock_interruptible(&pch_phub_mutex);
> +	if (ret) {
> +		err = -ERESTARTSYS;
> +		goto return_err_nomutex;
> +	}

You forgot to check count and off here also.

> +
> +	for (addr_offset = 0; addr_offset < count; addr_offset++) {
> +		if (PCH_PHUB_OROM_SIZE < off + addr_offset)
> +			goto return_ok;
> +
> +		ret_value2 = pch_phub_write_serial_rom(0x80 + addr_offset + off,
> +						       buf[addr_offset]);
> +		if (ret_value2) {
> +			err = ret_value2;
> +			goto return_err;

You can use 'ret' instead of 'ret_value2' here, no need to have another
variable.

> +		}
> +	}
> +
> +return_ok:
> +	mutex_unlock(&pch_phub_mutex);
> +	return addr_offset;
> +
> +return_err:
> +	mutex_unlock(&pch_phub_mutex);
> +return_err_nomutex:
> +	return err;

This seems a bit complex, it can be cleaned up to not have 3 exit paths,
with two of them doing the unlocking.


> +}
> +
> +static ssize_t show_pch_mac(struct device *dev, struct device_attribute *attr,
> +			    char *buf)
> +{
> +	u8 mac[8];
> +
> +	pch_phub_read_gbe_mac_addr(mac);
> +
> +	return sprintf(buf, "%02x:%02x:%02x:%02x:%02x:%02x\n",
> +				mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);
> +}
> +
> +static ssize_t store_pch_mac(struct device *dev, struct device_attribute *attr,
> +			     const char *buf, size_t count)
> +
> +{
> +	u8 mac[6];
> +
> +	if (count != 18)
> +		return -1;

Why -1?

> +
> +	sscanf(buf, "%02x:%02x:%02x:%02x:%02x:%02x",
> +		(u32 *)&mac[0], (u32 *)&mac[1], (u32 *)&mac[2], (u32 *)&mac[3],
> +		(u32 *)&mac[4], (u32 *)&mac[5]);
> +
> +	pch_phub_write_gbe_mac_addr(mac);
> +
> +	return strlen(buf);

No, return the length you read, not the larger value, that's only going
to confuse userspace a lot.

> +}
> +
> +static DEVICE_ATTR(pch_mac, S_IRUGO | S_IWUSR, show_pch_mac, store_pch_mac);
> +
> +static struct attribute *pch_attrs[] = {
> +	&dev_attr_pch_mac.attr,
> +	NULL,
> +};
> +
> +static struct bin_attribute pch_bin_attr = {
> +	.attr = {
> +		.name = "pch_firmware",
> +		.mode = S_IRUGO | S_IWUSR,
> +	},
> +	.size = PCH_PHUB_OROM_SIZE + 1,
> +	.read = pch_phub_bin_read,
> +	.write = pch_phub_bin_write,
> +};
> +
> +static struct attribute_group pch_attr_group = {
> +	.attrs = pch_attrs,
> +};

You only have one file, why a whole group?

> +
> +static int __devinit pch_phub_probe(struct pci_dev *pdev,
> +				    const struct pci_device_id *id)
> +{
> +	int retval;
> +
> +	int ret;
> +	unsigned int rom_size;
> +
> +	ret = pci_enable_device(pdev);
> +	if (ret) {
> +		dev_err(&pdev->dev,
> +		"%s : pci_enable_device FAILED(ret=%d)", __func__, ret);
> +		goto err_pci_enable_dev;
> +	}
> +	dev_dbg(&pdev->dev, "%s : pci_enable_device returns %d\n", __func__,
> +		ret);
> +
> +	ret = pci_request_regions(pdev, MODULE_NAME);
> +	if (ret) {
> +		dev_err(&pdev->dev,
> +		"%s : pci_request_regions FAILED(ret=%d)", __func__, ret);
> +		goto err_req_regions;
> +	}
> +	dev_dbg(&pdev->dev, "%s : "
> +		"pci_request_regions returns %d\n", __func__, ret);
> +
> +	pch_phub_reg.pch_phub_base_address = pci_iomap(pdev, 1, 0);
> +
> +	if (pch_phub_reg.pch_phub_base_address == 0) {
> +		dev_err(&pdev->dev, "%s : pci_iomap FAILED", __func__);
> +		ret = -ENOMEM;
> +		goto err_pci_iomap;
> +	}
> +	dev_dbg(&pdev->dev, "%s : pci_iomap SUCCESS and value "
> +		"in pch_phub_base_address variable is 0x%08x\n", __func__,
> +		(unsigned int)pch_phub_reg.pch_phub_base_address);
> +
> +	pch_phub_reg.pch_phub_extrom_base_address =
> +						pci_map_rom(pdev, &rom_size);
> +	if (pch_phub_reg.pch_phub_extrom_base_address == 0) {
> +		dev_err(&pdev->dev, "%s : pci_map_rom FAILED", __func__);
> +		ret = -ENOMEM;
> +		goto err_pci_map;
> +	}
> +	dev_dbg(&pdev->dev, "%s : "
> +		"pci_map_rom SUCCESS and value in "
> +		"pch_phub_extrom_base_address variable is 0x%08x\n", __func__,
> +		(unsigned int)pch_phub_reg.pch_phub_extrom_base_address);
> +
> +	retval = sysfs_create_group(&pdev->dev.kobj, &pch_attr_group);
> +	if (retval)
> +		goto err_sysfs_create;
> +
> +	retval = sysfs_create_bin_file(&pdev->dev.kobj, &pch_bin_attr);
> +	if (retval)
> +		goto exit_bin_attr;
> +
> +	return 0;
> +
> +	pch_phub_read_modify_write_reg((unsigned int)CLKCFG_REG_OFFSET,
> +					CLKCFG_CAN_50MHZ, CLKCFG_CANCLK_MASK);
> +
> +	/* set the prefech value */
> +	iowrite32(0x000ffffa, pch_phub_reg.pch_phub_base_address + 0x14);
> +	/* set the interrupt delay value */
> +	iowrite32(0x25, pch_phub_reg.pch_phub_base_address + 0x44);
> +
> +	return 0;
> +exit_bin_attr:
> +	sysfs_remove_group(&pdev->dev.kobj, &pch_attr_group);
> +
> +err_sysfs_create:
> +	pci_unmap_rom(pdev, pch_phub_reg.pch_phub_extrom_base_address);
> +err_pci_map:
> +	pci_iounmap(pdev, pch_phub_reg.pch_phub_base_address);
> +err_pci_iomap:
> +	pci_release_regions(pdev);
> +err_req_regions:
> +	pci_disable_device(pdev);
> +err_pci_enable_dev:
> +	dev_err(&pdev->dev, "%s returns %d\n", __func__, ret);
> +	return ret;
> +}
> +
> +static void __devexit pch_phub_remove(struct pci_dev *pdev)
> +{
> +	pci_unmap_rom(pdev, pch_phub_reg.pch_phub_extrom_base_address);
> +	pci_iounmap(pdev, pch_phub_reg.pch_phub_base_address);
> +	pci_release_regions(pdev);
> +	pci_disable_device(pdev);
> +	sysfs_remove_bin_file(&pdev->dev.kobj, &pch_bin_attr);
> +	sysfs_remove_group(&pdev->dev.kobj, &pch_attr_group);
> +}
> +
> +#ifdef CONFIG_PM
> +
> +static int pch_phub_suspend(struct pci_dev *pdev, pm_message_t state)
> +{
> +	int ret;
> +
> +	pch_phub_reg.pch_phub_suspended = true;/* For blocking further IOCTLs */
> +	pch_phub_save_reg_conf(pdev);
> +	ret = pci_save_state(pdev);
> +	if (ret) {
> +		dev_err(&pdev->dev,
> +			" %s -pci_save_state returns %d\n", __func__, ret);
> +		return ret;
> +	}
> +	pci_enable_wake(pdev, PCI_D3hot, 0);
> +	pci_disable_device(pdev);
> +	pci_set_power_state(pdev, pci_choose_state(pdev, state));
> +
> +	return 0;
> +}
> +
> +static int pch_phub_resume(struct pci_dev *pdev)
> +{
> +	int ret;
> +
> +	pci_set_power_state(pdev, PCI_D0);
> +	pci_restore_state(pdev);
> +	ret = pci_enable_device(pdev);
> +	if (ret) {
> +		dev_err(&pdev->dev,
> +		"%s-pci_enable_device failed(ret=%d) ", __func__, ret);
> +		return ret;
> +	}
> +
> +	pci_enable_wake(pdev, PCI_D3hot, 0);
> +	pch_phub_restore_reg_conf(pdev);
> +	pch_phub_reg.pch_phub_suspended = false;
> +
> +	return 0;
> +}
> +#else
> +#define pch_phub_suspend NULL
> +#define pch_phub_resume NULL
> +#endif /* CONFIG_PM */
> +
> +static struct pci_device_id pch_phub_pcidev_id[] = {
> +	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_PCH1_PHUB)},
> +	{0,}
> +};
> +
> +static struct pci_driver pch_phub_driver = {
> +	.name = "pch_phub",
> +	.id_table = pch_phub_pcidev_id,
> +	.probe = pch_phub_probe,
> +	.remove = __devexit_p(pch_phub_remove),
> +	.suspend = pch_phub_suspend,
> +	.resume = pch_phub_resume
> +};
> +
> +static int __init pch_phub_pci_init(void)
> +{
> +	int ret;
> +	ret = pci_register_driver(&pch_phub_driver);
> +
> +	return ret;

How about:
	return pci_register_driver(&pch_phub_driver);
instead?


> +}
> +
> +static void __exit pch_phub_pci_exit(void)
> +{
> +	pci_unregister_driver(&pch_phub_driver);
> +}
> +
> +module_init(pch_phub_pci_init);
> +module_exit(pch_phub_pci_exit);
> +
> +MODULE_DESCRIPTION("PCH PACKET HUB PCI Driver");

Why is "PACKET" and "HUB" all uppercase?

thanks,

greg k-h

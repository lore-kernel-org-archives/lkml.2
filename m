Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626Ab0FVWMv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 18:12:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50875 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752540Ab0FVWMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 18:12:48 -0400
Date: Tue, 22 Jun 2010 15:12:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Masayuki Ohtak <masa-korg@dsn.okisemi.com>
Cc: Arnd Bergmann <arnd@arndb.de>, "Wang, Yong Y" <yong.y.wang@intel.com>,
       qi.wang@intel.com, joel.clark@intel.com,
       andrew.chih.howe.khor@intel.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Topcliff PHUB: Generate PacketHub driver
Message-Id: <20100622151223.2ce250e1.akpm@linux-foundation.org>
In-Reply-To: <4C20917E.9060708@dsn.okisemi.com>
References: <4C204B0D.2030201@dsn.okisemi.com>
	<4C20917E.9060708@dsn.okisemi.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jun 2010 19:33:34 +0900
Masayuki Ohtak <masa-korg@dsn.okisemi.com> wrote:

> Hi Arnd and Yong Y
> 
> We have updated phub patch about the following.
>  * Arnd's commnets
> 	 * Delete PCH_READ_REG/PCH_WRITE_REG
> 	 * Delete '_t' prefix
> 	 * Modify basic type
> 	 * Delete needless 'static' prefix
> 	 * Modify returned value
> 	 * Care returned value of get_user()
> 	 * Add .llseek line
> 
>  * Yong Y's comments
> 	 * Applying to the latest checkpatch(2.6.35)
> 	 * Delete unused 'DEBUG' macro in Makefile
> 	 * Delete IEEE1588 lines
> 	 * Delete 'PCH_CAN_PCLK_50MHZ'
> 
> Thanks, Ohtake.
> 
> Kernel=2.6.33.1
> Signed-off-by: Masayuki Ohtake <masa-korg@dsn.okisemi.com>

Please prepare a proper changelog for the patch - one which is suitabe
for inclusion in the kernel's permanent git record.  Include that
changelog with each version of the patch, perhaps after alterations.

Please describe the module parameters in that changelog.  Please
describe the major/minor number handling within the changelog -
permitting the major number to be specified on the modprobe command
line is unusual and should be fully described and justified, please.

Please ensure that the changelog tells us what the driver actually
does!  I don't even know what a "PCH packet hub" _is_ :(

>
> ...
>
> --- /dev/null
> +++ b/drivers/char/pch_phub/pch_phub.c
> @@ -0,0 +1,937 @@
> +/*!
> + * @file pch_phub.c
> + * @brief Provides all the implementation of the interfaces pertaining to
> + *		the Packet Hub module.
> + * @version 1.0.0.0
> + * @section

This appears to use a markup format whcih the kernel doesn't implement.

> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
> + */
>
> ...
>
> +/** pch_phub_read_modify_write_reg - Implements the functionality of reading,
> + *					 modifying and writing register.
> + *  @reg_addr_offset:  Contains the register offset address value
> + *  @data:             Contains the writing value
> + *  @mask:             Contains the mask value
> + */

kerneldoc comments are usually formatted as

/**
 *  foo() - do something
 *  @arg1 ...

I don't know whether the layout whcih this driver uses will be properly
handled by the kerneldoc tools, but I'd suggest that it all be
converted to the more usual style for consistency.

> +static void pch_phub_read_modify_write_reg(unsigned int reg_addr_offset,
> +				       unsigned int data, unsigned int mask)
> +{
> +	void __iomem *reg_addr = pch_phub_reg.pch_phub_base_address +\
> +							 reg_addr_offset;
> +	iowrite32(((ioread32(reg_addr) & ~mask)) | data, reg_addr);
> +	return;
> +}
> +
> +
> +/** pch_phub_save_reg_conf - saves register configuration
> + */

The driver has quite a lot of comments which use the kerneldoc toke
"/**" but which don't really look like they wre intended to be
kerneldoc comments.  So I'd suggest converting these to plain old comments:

/*
 * pch_phub_save_reg_conf - saves register configuration
 */

or

/* pch_phub_save_reg_conf - saves register configuration */


or finish off the kerneldoc work by documenting the arguments (and the
return values, please).

> +static void pch_phub_save_reg_conf(struct pci_dev *pdev)
> +{
> +	unsigned int i = 0;
> +	void __iomem *p = pch_phub_reg.pch_phub_base_address;
> +
> +	dev_dbg(&pdev->dev, "pch_phub_save_reg_conf ENTRY\n");
> +	/* to store contents of PHUB_ID register */
> +	pch_phub_reg.phub_id_reg = ioread32(p + PCH_PHUB_PHUB_ID_REG);
> +	/* to store contents of QUEUE_PRI_VAL register */
> +	pch_phub_reg.q_pri_val_reg = ioread32(p + PCH_PHUB_QUEUE_PRI_VAL_REG);
> +	/* to store contents of RC_QUEUE_MAXSIZE register */
> +	pch_phub_reg.rc_q_maxsize_reg =
> +	    ioread32(p + PCH_PHUB_RC_QUEUE_MAXSIZE_REG);
> +	/* to store contents of BRI_QUEUE_MAXSIZE register */
> +	pch_phub_reg.bri_q_maxsize_reg =
> +	    ioread32(p + PCH_PHUB_BRI_QUEUE_MAXSIZE_REG);
> +	/* to store contents of COMP_RESP_TIMEOUT register */
> +	pch_phub_reg.comp_resp_timeout_reg =
> +	    ioread32(p + PCH_PHUB_COMP_RESP_TIMEOUT_REG);
> +	/* to store contents of BUS_SLAVE_CONTROL_REG register */
> +	pch_phub_reg.bus_slave_control_reg =
> +	    ioread32(p + PCH_PHUB_BUS_SLAVE_CONTROL_REG);
> +	/* to store contents of DEADLOCK_AVOID_TYPE register */
> +	pch_phub_reg.deadlock_avoid_type_reg =
> +	    ioread32(p + PCH_PHUB_DEADLOCK_AVOID_TYPE_REG);
> +	/* to store contents of INTPIN_REG_WPERMIT register 0 */
> +	pch_phub_reg.intpin_reg_wpermit_reg0 =
> +	    ioread32(p + PCH_PHUB_INTPIN_REG_WPERMIT_REG0);
> +	/* to store contents of INTPIN_REG_WPERMIT register 1 */
> +	pch_phub_reg.intpin_reg_wpermit_reg1 =
> +	    ioread32(p + PCH_PHUB_INTPIN_REG_WPERMIT_REG1);
> +	/* to store contents of INTPIN_REG_WPERMIT register 2 */
> +	pch_phub_reg.intpin_reg_wpermit_reg2 =
> +	    ioread32(p + PCH_PHUB_INTPIN_REG_WPERMIT_REG2);
> +	/* to store contents of INTPIN_REG_WPERMIT register 3 */

s/to //g

> +	pch_phub_reg.intpin_reg_wpermit_reg3 =
> +	    ioread32(p + PCH_PHUB_INTPIN_REG_WPERMIT_REG3);
> +	dev_dbg(&pdev->dev, "pch_phub_save_reg_conf : "
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
> +		"pch_phub_reg.intpin_reg_wpermit_reg3=%x\n",
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
> +	/* to store contents of INT_REDUCE_CONTROL registers */
> +	for (i = 0; i < MAX_NUM_INT_REDUCE_CONTROL_REG; i++) {
> +		pch_phub_reg.int_reduce_control_reg[i] =
> +		    ioread32(p +
> +			PCH_PHUB_INT_REDUCE_CONTROL_REG_BASE + 4 * i);
> +		dev_dbg(&pdev->dev, "pch_phub_save_reg_conf : "
> +			"pch_phub_reg.int_reduce_control_reg[%d]=%x\n",
> +			i, pch_phub_reg.int_reduce_control_reg[i]);
> +	}
> +	/* save clk cfg register */
> +	pch_phub_reg.clkcfg_reg = ioread32(p + CLKCFG_REG_OFFSET);
> +
> +	return;
> +}
> +
>
> ...
>
> +static void pch_phub_restore_reg_conf(struct pci_dev *pdev)
> +{
> +	unsigned int i;
> +	void __iomem *p = pch_phub_reg.pch_phub_base_address;
> +
> +	dev_dbg(&pdev->dev, "pch_phub_restore_reg_conf ENTRY\n");
> +	/* to store contents of PHUB_ID register */
> +	iowrite32(pch_phub_reg.phub_id_reg, p + PCH_PHUB_PHUB_ID_REG);
> +	/* to store contents of QUEUE_PRI_VAL register */
> +	iowrite32(pch_phub_reg.q_pri_val_reg, p + PCH_PHUB_QUEUE_PRI_VAL_REG);
> +	/* to store contents of RC_QUEUE_MAXSIZE register */
> +	iowrite32(pch_phub_reg.rc_q_maxsize_reg,
> +					p + PCH_PHUB_RC_QUEUE_MAXSIZE_REG);
> +	/* to store contents of BRI_QUEUE_MAXSIZE register */
> +	iowrite32(pch_phub_reg.bri_q_maxsize_reg,
> +					p + PCH_PHUB_BRI_QUEUE_MAXSIZE_REG);
> +	/* to store contents of COMP_RESP_TIMEOUT register */
> +	iowrite32(pch_phub_reg.comp_resp_timeout_reg,
> +					p + PCH_PHUB_COMP_RESP_TIMEOUT_REG);
> +	/* to store contents of BUS_SLAVE_CONTROL_REG register */
> +	iowrite32(pch_phub_reg.bus_slave_control_reg,
> +					p + PCH_PHUB_BUS_SLAVE_CONTROL_REG);
> +	/* to store contents of DEADLOCK_AVOID_TYPE register */
> +	iowrite32(pch_phub_reg.deadlock_avoid_type_reg,
> +					p + PCH_PHUB_DEADLOCK_AVOID_TYPE_REG);
> +	/* to store contents of INTPIN_REG_WPERMIT register 0 */
> +	iowrite32(pch_phub_reg.intpin_reg_wpermit_reg0,
> +					p + PCH_PHUB_INTPIN_REG_WPERMIT_REG0);
> +	/* to store contents of INTPIN_REG_WPERMIT register 1 */
> +	iowrite32(pch_phub_reg.intpin_reg_wpermit_reg1,
> +					p + PCH_PHUB_INTPIN_REG_WPERMIT_REG1);
> +	/* to store contents of INTPIN_REG_WPERMIT register 2 */
> +	iowrite32(pch_phub_reg.intpin_reg_wpermit_reg2,
> +					p + PCH_PHUB_INTPIN_REG_WPERMIT_REG2);
> +	/* to store contents of INTPIN_REG_WPERMIT register 3 */
> +	iowrite32(pch_phub_reg.intpin_reg_wpermit_reg3,
> +					p + PCH_PHUB_INTPIN_REG_WPERMIT_REG3);
> +	dev_dbg(&pdev->dev, "pch_phub_save_reg_conf : "
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
> +		"pch_phub_reg.intpin_reg_wpermit_reg3=%x\n",
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
> +	/* to store contents of INT_REDUCE_CONTROL register */
> +	for (i = 0; i < MAX_NUM_INT_REDUCE_CONTROL_REG; i++) {
> +		iowrite32(pch_phub_reg.int_reduce_control_reg[i],
> +			p + PCH_PHUB_INT_REDUCE_CONTROL_REG_BASE + 4 * i);
> +		dev_dbg(&pdev->dev, "pch_phub_save_reg_conf : "
> +			"pch_phub_reg.int_reduce_control_reg[%d]=%x\n",
> +			i, pch_phub_reg.int_reduce_control_reg[i]);
> +	}
> +
> +	/*restore the clock config reg */

One space after the /*, please.

> +	iowrite32(pch_phub_reg.clkcfg_reg, p + CLKCFG_REG_OFFSET);
> +
> +	return;
> +}
> +
> +/** pch_phub_read_serial_rom - Implements the functionality of reading Serial
> + *									 ROM.
> + *  @offset_address: Contains the Serial ROM address offset value
> + *  @data: Contains the Serial ROM value
> + */
> +static int pch_phub_read_serial_rom(unsigned int offset_address,
> +							 unsigned char *data)
> +{
> +	void __iomem *mem_addr = pch_phub_reg.pch_phub_extrom_base_address +\
> +								 offset_address;

Unneeded \.  There are several instances of this in the driver.

> +	*data = ioread8(mem_addr);
> +
> +	return 0;
> +}
> +
> +/** pch_phub_write_serial_rom - Implements the functionality of writing Serial
> + *									 ROM.

Strange layout.  I don't know what this will look like after kerneldoc
processing - it might make a mess.  Conventional layout is

/**
 * pch_phub_write_serial_rom - Implements the functionality of writing Serial ROM.

or

/**
 * pch_phub_write_serial_rom - Implements the functionality of writing Serial
 * ROM.

(there are several instances of this).


> + *  @offset_address: Contains the Serial ROM address offset value
> + *  @data: Contains the Serial ROM value
> + */
> +static int pch_phub_write_serial_rom(unsigned int offset_address,
> +							 unsigned char data)
> +{
> +	int retval = 0;
> +	void __iomem *mem_addr = pch_phub_reg.pch_phub_extrom_base_address +\
> +						 (offset_address & 0xFFFFFFFC);
> +	int i = 0;
> +	unsigned int word_data = 0;
> +
> +	iowrite32(PCH_PHUB_ROM_WRITE_ENABLE,
> +			pch_phub_reg.pch_phub_extrom_base_address +\
> +								 PHUB_CONTROL);
> +
> +	word_data = ioread32(mem_addr);

The driver tends to do

	int foo = 0;

	...

	foo = ...

in quite a lot of places.  The initialisation to zero is harmless - the
compiler will take it out again.  But it's unusual and jsut adds noise.

The compiler will warn about use of uninitialised variables anyway.  In
fact this unnecessary initalisation will suppress compiler warnings
which might have revealed real bugs.  I'd suggest that they all be
removed (there are quite a lot in this driver).

> +	switch (offset_address % 4) {
> +	case 0:
> +		word_data &= 0xFFFFFF00;
> +		iowrite32((word_data | (unsigned int)data),
> +						mem_addr);
> +		break;
> +	case 1:
> +		word_data &= 0xFFFF00FF;
> +		iowrite32((word_data | ((unsigned int)data << 8)),
> +						mem_addr);
> +		break;
> +	case 2:
> +		word_data &= 0xFF00FFFF;
> +		iowrite32((word_data | ((unsigned int)data << 16)),
> +						mem_addr);
> +		break;
> +	case 3:
> +		word_data &= 0x00FFFFFF;
> +		iowrite32((word_data | ((unsigned int)data << 24)),
> +						mem_addr);
> +		break;
> +	}
> +	while (0x00 !=
> +	       ioread8(pch_phub_reg.pch_phub_extrom_base_address +\
> +							 PHUB_STATUS)) {
> +		msleep(1);
> +		if (PHUB_TIMEOUT == i) {
> +			retval = -EPERM;
> +			break;
> +		}
> +		i++;
> +	}
> +
> +	iowrite32(PCH_PHUB_ROM_WRITE_DISABLE,
> +			pch_phub_reg.pch_phub_extrom_base_address +\
> +								 PHUB_CONTROL);
> +
> +	return retval;
> +}
> +
>
> ...
>
> +static ssize_t pch_phub_read(struct file *file, char __user *buf, size_t size,
> +								 loff_t *ppos)
> +{
> +	unsigned int rom_signature = 0;
> +	unsigned char rom_length;
> +	int ret_value;
> +	unsigned int tmp;
> +	unsigned char data;
> +	unsigned int addr_offset = 0;
> +	unsigned int orom_size;
> +	loff_t pos = *ppos;
> +
> +	if (pos < 0)
> +		return -EINVAL;

I think vfs_read() -> rw_verify_area() already did that, so indovidual
->read() implementations don't need to check for negative offset.

> +	/*Get Rom signature*/

Spaces after /* and before */, please.

> +	pch_phub_read_serial_rom(0x80, (unsigned char *)&rom_signature);
> +	pch_phub_read_serial_rom(0x81, (unsigned char *)&tmp);
> +	rom_signature |= (tmp & 0xff) << 8;
> +	if (rom_signature == 0xAA55) {
> +		pch_phub_read_serial_rom(0x82, &rom_length);
> +		orom_size = rom_length * 512;
> +		if (orom_size < pos)
> +			return 0;
> +
> +		for (addr_offset = 0; addr_offset < size; addr_offset++) {
> +			pch_phub_read_serial_rom(0x80 + addr_offset + pos,
> +									 &data);
> +			ret_value = copy_to_user(&buf[addr_offset], &data, 1);
> +			if (ret_value)
> +				return -EFAULT;
> +
> +			if (orom_size < pos + addr_offset) {
> +				*ppos += addr_offset;
> +				return addr_offset;
> +			}
> +
> +		}
> +	} else {
> +		return -ENOEXEC;

ENOEXEC means "your executable file doesn't have suitable contents". 
If this error gets propagated to userspace the poor user will be
wondering who corrupted his ELF files and would be surprised to find
out that the error in fact came from his packethub driver.

So please use a more appropriate errno here.

> +	}
> +	*ppos += addr_offset;
> +	return addr_offset;
> +}
> +
> +/** pch_phub_write - Implements the write functionality of the Packet Hub
> + *									 module.
> + *  @file: Contains the reference of the file structure
> + *  @buf: Usermode buffer pointer
> + *  @size: Usermode buffer size
> + *  @ppos: Contains the reference of the file structure
> + */
> +static ssize_t pch_phub_write(struct file *file, const char __user *buf,
> +						 size_t size, loff_t *ppos)
> +{
> +	unsigned int data;
> +	int ret_value;
> +	unsigned int addr_offset = 0;
> +	loff_t pos = *ppos;
> +
> +	if (pos < 0)
> +		return -EINVAL;

vfs_write() already did that.

> +	for (addr_offset = 0; addr_offset < size; addr_offset++) {
> +		ret_value = get_user(data, &buf[addr_offset]);
> +		if (ret_value)
> +			return -EFAULT;
> +
> +		ret_value = pch_phub_write_serial_rom(0x80 + addr_offset + pos,
> +								 data);
> +		if (ret_value)
> +			return -EIO;

This overwrites the pch_phub_write_serial_rom() return value.  it's
generally better to propagate error return values instead of replacing
them with different ones.

otoh pch_phub_write_serial_rom() can return -EPERM.  "Operation not
permitted.  An attempt was made to perform an operation limited to
processes with appropriate privileges or to the owner of a file or
other resource.".  That doesn't sound like an appropriate errno for a
driver to use?

> +		if (PCH_PHUB_OROM_SIZE < pos + addr_offset) {
> +			*ppos += addr_offset;
> +			return addr_offset;
> +		}
> +
> +	}
> +
> +	*ppos += addr_offset;
> +	return addr_offset;
> +}
> +
> +
> +/** pch_phub_ioctl - Implements the various ioctl functionalities of the Packet
> + *								 Hub module.
> + *  @inode: Contains the reference of the inode structure
> + *  @file: Contains the reference of the file structure
> + *  @cmd: Contains the command value
> + *  @arg: Contains the command argument value
> + */
> +
> +
> +static long pch_phub_ioctl(struct file *file, unsigned int cmd,
> +							 unsigned long arg)
> +{
> +	int ret_value = 0;
> +	__u8 mac_addr[6];
> +	int ret;
> +	unsigned int i;
> +	void __user *varg = (void __user *)arg;
> +
> +	ret = mutex_lock_interruptible(&pch_phub_ioctl_mutex);
> +	if (ret) {
> +		ret_value = -ERESTARTSYS;
> +		goto return_nomutex;
> +	}

A plain old `return -ERESTARTSYS' is OK here.

> +	if (pch_phub_reg.pch_phub_suspended == true) {
> +		ret_value = -EPERM;

EPERM?

> +		goto return_ioctrl;
> +	}
> +
> +	switch (cmd) {
> +	case IOCTL_PHUB_READ_MAC_ADDR:
> +		for (i = 0; i < 6; i++)
> +			pch_phub_read_gbe_mac_addr(i, &mac_addr[i]);
> +
> +		ret_value = copy_to_user(varg,
> +					 mac_addr, sizeof(mac_addr));
> +		if (ret_value) {
> +			ret_value = -EFAULT;
> +			goto return_ioctrl;
> +		}

The goto is unneeded.

> +		break;
> +
> +	case IOCTL_PHUB_WRITE_MAC_ADDR:
> +		ret_value = copy_from_user(mac_addr, varg, sizeof(mac_addr));
> +
> +		if (ret_value) {
> +			ret_value = -EFAULT;
> +			goto return_ioctrl;
> +		}

Could do a `break'.

> +		for (i = 0; i < 6; i++)
> +			pch_phub_write_gbe_mac_addr(i, mac_addr[i]);
> +		break;
> +
> +	default:
> +		ret_value = -EINVAL;
> +		break;
> +	}
> +return_ioctrl:
> +	mutex_unlock(&pch_phub_ioctl_mutex);
> +return_nomutex:
> +	return ret_value;
> +}
> +
> +
> +/**
> + * file_operations structure initialization
> + */

That's not a kerneldoc comment, but it has the /** kerneldoc token.

> +static const struct file_operations pch_phub_fops = {
> +	.owner = THIS_MODULE,
> +	.read = pch_phub_read,
> +	.write = pch_phub_write,
> +	.unlocked_ioctl = pch_phub_ioctl,
> +	.llseek = default_llseek
> +};
> +
> +
> +/** pch_phub_probe - Implements the probe functionality of the module.
> + *  @pdev: Contains the reference of the pci_dev structure
> + *  @id: Contains the reference of the pci_device_id structure
> + */
> +static int __devinit pch_phub_probe(struct pci_dev *pdev,
> +				       const struct pci_device_id *id)
> +{
> +	char *DRIVER_NAME = "pch_phub";

hm, why was that upper case?

Maybe use MODULE_NAME instead?  Or

	static const char driver_name[] = "pch_phub";

> +	int ret;
> +	unsigned int rom_size;
> +
> +	pch_phub_major_no = (pch_phub_major_no < 0 || pch_phub_major_no > 254) ?
> +				0 : pch_phub_major_no;

This looks odd - should be explained in code comments and/or changelog.

> +	ret = pci_enable_device(pdev);
> +	if (ret) {
> +		dev_dbg(&pdev->dev,
> +				"\npch_phub_probe : pci_enable_device FAILED");
> +		goto err_probe;
> +	}
> +	dev_dbg(&pdev->dev, "pch_phub_probe : "
> +			"pci_enable_device returns %d\n", ret);
> +
> +	ret = pci_request_regions(pdev, DRIVER_NAME);
> +	if (ret) {
> +		dev_dbg(&pdev->dev,
> +				"pch_phub_probe : pci_request_regions FAILED");
> +		pci_disable_device(pdev);
> +		goto err_probe;
> +	}
> +	dev_dbg(&pdev->dev, "pch_phub_probe : "
> +		"pci_request_regions returns %d\n", ret);
> +
> +	pch_phub_reg.pch_phub_base_address = \
> +					(void __iomem *)pci_iomap(pdev, 1, 0);

Unneeded and undesirable typeast.

> +	if (pch_phub_reg.pch_phub_base_address == 0) {
> +		dev_dbg(&pdev->dev, "pch_phub_probe : pci_iomap FAILED");
> +		pci_release_regions(pdev);
> +		pci_disable_device(pdev);
> +		ret = -ENOMEM;
> +		goto err_probe;
> +	}
> +	dev_dbg(&pdev->dev, "pch_phub_probe : pci_iomap SUCCESS and value "
> +		"in pch_phub_base_address variable is 0x%08x\n",
> +		(unsigned int)pch_phub_reg.pch_phub_base_address);
> +
> +	pch_phub_reg.pch_phub_extrom_base_address =
> +	    (void __iomem *)pci_map_rom(pdev, &rom_size);

Ditto

> +	if (pch_phub_reg.pch_phub_extrom_base_address == 0) {
> +		dev_dbg(&pdev->dev, "pch_phub_probe : pci_map_rom FAILED");
> +		pci_iounmap(pdev, (void *)pch_phub_reg.pch_phub_base_address);
> +		pci_release_regions(pdev);
> +		pci_disable_device(pdev);

This is getting painful.  I'd suggest removal of the duplicated code
via the standard `goto out_iounmap' unwinding approach.

> +		ret = -ENOMEM;
> +		goto err_probe;
> +	}
> +	dev_dbg(&pdev->dev, "pch_phub_probe : "
> +		"pci_map_rom SUCCESS and value in "
> +		"pch_phub_extrom_base_address variable is 0x%08x\n",
> +		(unsigned int)pch_phub_reg.pch_phub_extrom_base_address);
> +
> +	if (pch_phub_major_no) {
> +		pch_phub_dev_no = MKDEV(pch_phub_major_no, 0);
> +		ret = register_chrdev_region(pch_phub_dev_no,
> +					   PCH_MINOR_NOS, DRIVER_NAME);
> +		if (ret) {
> +			dev_dbg(&pdev->dev, "pch_phub_probe : "
> +				"register_chrdev_region FAILED");
> +			pci_unmap_rom(pdev,
> +			(void *)pch_phub_reg.pch_phub_extrom_base_address);
> +			pci_iounmap(pdev,
> +				(void *)pch_phub_reg.pch_phub_base_address);

More unneeded typecasts.

> +			pci_release_regions(pdev);
> +			pci_disable_device(pdev);
> +			goto err_probe;
> +		}
> +		dev_dbg(&pdev->dev, "pch_phub_probe : "
> +				"register_chrdev_region returns %d\n", ret);
> +	} else {
> +		ret = alloc_chrdev_region(&pch_phub_dev_no, 0,
> +						PCH_MINOR_NOS, DRIVER_NAME);
> +		if (ret) {
> +			dev_dbg(&pdev->dev, "pch_phub_probe : "
> +					"alloc_chrdev_region FAILED");
> +			pci_unmap_rom(pdev,
> +			(void *)pch_phub_reg.pch_phub_extrom_base_address);
> +			pci_iounmap(pdev,
> +				    (void *)pch_phub_reg.pch_phub_base_address);

more..

> +			pci_release_regions(pdev);
> +			pci_disable_device(pdev);
> +			goto err_probe;
> +		}
> +		dev_dbg(&pdev->dev, "pch_phub_probe : "
> +			"alloc_chrdev_region returns %d\n", ret);
> +	}
> +
> +	cdev_init(&pch_phub_dev, &pch_phub_fops);
> +	dev_dbg(&pdev->dev,
> +			"pch_phub_probe :  cdev_init invoked successfully\n");
> +
> +	pch_phub_dev.owner = THIS_MODULE;
> +	pch_phub_dev.ops = &pch_phub_fops;
> +
> +	ret = cdev_add(&pch_phub_dev, pch_phub_dev_no, PCH_MINOR_NOS);
> +	if (ret) {
> +		dev_dbg(&pdev->dev, "pch_phub_probe :  cdev_add FAILED");
> +		unregister_chrdev_region(pch_phub_dev_no, PCH_MINOR_NOS);
> +		pci_unmap_rom(pdev,
> +			(void *)pch_phub_reg.pch_phub_extrom_base_address);
> +		pci_iounmap(pdev, (void *)pch_phub_reg.pch_phub_base_address);
> +		pci_release_regions(pdev);
> +		pci_disable_device(pdev);
> +		goto err_probe;
> +	}
> +	dev_dbg(&pdev->dev, "pch_phub_probe :  cdev_add returns %d\n", ret);
> +
> +	/*set the clock config reg if CAN clock is 50Mhz */
> +	dev_dbg(&pdev->dev, "pch_phub_probe : invoking "
> +		"pch_phub_read_modify_write_reg "
> +		"to set CLKCFG reg for CAN clk 50Mhz\n");
> +	pch_phub_read_modify_write_reg((unsigned int)CLKCFG_REG_OFFSET,
> +					  CLKCFG_CAN_50MHZ, CLKCFG_CANCLK_MASK);
> +
> +	/* set the prefech value */
> +	iowrite32(0x000ffffa, pch_phub_reg.pch_phub_base_address + 0x14);
> +	/* set the interrupt delay value */
> +	iowrite32(0x25, pch_phub_reg.pch_phub_base_address + 0x44);
> +	return 0;
> +
> +err_probe:
> +	dev_dbg(&pdev->dev, "pch_phub_probe returns %d\n", ret);
> +	return ret;
> +}
> +
>
> ...
>
> +#ifdef CONFIG_PM
> +
> +/** pch_phub_suspend - Implements the suspend functionality of the module.
> + *  @pdev: Contains the reference of the pci_dev structure
> + *  @state: Contains the reference of the pm_message_t structure
> + */
> +static int pch_phub_suspend(struct pci_dev *pdev, pm_message_t state)
> +{
> +	int ret;
> +
> +	pch_phub_reg.pch_phub_suspended = true;/* For blocking further IOCTLs */
> +
> +	pch_phub_save_reg_conf(pdev);
> +	dev_dbg(&pdev->dev, "pch_phub_suspend - "
> +		"pch_phub_save_reg_conf Invoked successfully\n");
> +
> +	ret = pci_save_state(pdev);
> +	if (ret) {
> +		dev_dbg(&pdev->dev,
> +			" pch_phub_suspend -pci_save_state returns-%d\n", ret);
> +		return ret;
> +	}
> +	dev_dbg(&pdev->dev,
> +			"pch_phub_suspend - pci_save_state returns %d\n", ret);
> +	pci_enable_wake(pdev, PCI_D3hot, 0);
> +	dev_dbg(&pdev->dev, "pch_phub_suspend - "
> +			"pci_enable_wake Invoked successfully\n");
> +
> +	pci_disable_device(pdev);
> +	dev_dbg(&pdev->dev, "pch_phub_suspend - "
> +			"pci_disable_device Invoked successfully\n");
> +
> +	pci_set_power_state(pdev, pci_choose_state(pdev, state));
> +	dev_dbg(&pdev->dev, "pch_phub_suspend - "
> +			"pci_set_power_state Invoked successfully   "
> +			"return = %d\n", 0);
> +
> +	return 0;
> +}
> +
> +/** pch_phub_resume - Implements the resume functionality of the module.
> + *  @pdev: Contains the reference of the pci_dev structure
> + */
> +static int pch_phub_resume(struct pci_dev *pdev)
> +{
> +
> +	int ret;
> +
> +	pci_set_power_state(pdev, PCI_D0);
> +	dev_dbg(&pdev->dev, "pch_phub_resume - "
> +		"pci_set_power_state Invoked successfully\n");
> +
> +	pci_restore_state(pdev);
> +	dev_dbg(&pdev->dev, "pch_phub_resume - "
> +		"pci_restore_state Invoked successfully\n");
> +
> +	ret = pci_enable_device(pdev);
> +	if (ret) {
> +		dev_dbg(&pdev->dev,
> +				"pch_phub_resume-pci_enable_device failed ");
> +		return ret;
> +	}
> +
> +	dev_dbg(&pdev->dev, "pch_phub_resume - "
> +			"pci_enable_device returns -%d\n", ret);
> +
> +	pci_enable_wake(pdev, PCI_D3hot, 0);
> +	dev_dbg(&pdev->dev, "pch_phub_resume - "
> +			"pci_enable_wake Invoked successfully\n");
> +
> +	pch_phub_restore_reg_conf(pdev);
> +	dev_dbg(&pdev->dev, "pch_phub_resume - "
> +		"pch_phub_restore_reg_conf Invoked successfully\n");
> +
> +	pch_phub_reg.pch_phub_suspended = false;
> +
> +	dev_dbg(&pdev->dev, "pch_phub_resume  returns- %d\n", 0);
> +	return 0;
> +}

Here you can put

#else
#define pch_phub_suspend NULL
#define pch_phub_resume NULL

> +#endif /* CONFIG_PM */
> +
> +static struct pci_device_id pch_phub_pcidev_id[] = {
> +
> +	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_PCH1_PHUB)},
> +	{0,}
> +};
> +
> +
> +static struct pci_driver pch_phub_driver = {
> +	.name = "pch_phub",
> +	.id_table = pch_phub_pcidev_id,
> +	.probe = pch_phub_probe,
> +	.remove = __devexit_p(pch_phub_remove),
> +#ifdef CONFIG_PM
> +	.suspend = pch_phub_suspend,
> +	.resume = pch_phub_resume
> +#endif

and then remove this ifdef.

>
> ...
>
> --- /dev/null
> +++ b/drivers/char/pch_phub/pch_phub.h
> @@ -0,0 +1,58 @@
> +#ifndef __PCH_PHUB_H__
> +#define __PCH_PHUB_H__
> +/*!
> + * @file pch_phub.h
> + * @brief Provides all the interfaces pertaining to the Packet Hub module.
> + * @version 1.0.0.0
> + * @section

?

> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
> + */
> +
> +/*
> + * History:
> + * Copyright (C) 2010 OKI SEMICONDUCTOR Co., LTD.
> + *
> + * created:
> + *	OKI SEMICONDUCTOR 04/14/2010
> + * modified:
> + *
> + */
> +
> +#define PHUB_IOCTL_MAGIC		(0xf7)
> +
> +/*Outlines the read mac address function signature. */

Space after /*, please (check the whole patch)

> +#define IOCTL_PHUB_READ_MAC_ADDR (_IOR(PHUB_IOCTL_MAGIC, 6, __u8[6]))
> +
> +/*brief Outlines the write mac address function signature. */
> +#define IOCTL_PHUB_WRITE_MAC_ADDR (_IOW(PHUB_IOCTL_MAGIC, 7, __u8[6]))

"brief"?

I didn't notice any documentation for these ioctls anywhere?

> +
> +/* Registers address offset */
> +#define PCH_PHUB_PHUB_ID_REG			0x0000
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
> +#endif


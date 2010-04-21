Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358Ab0DUUQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 16:16:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33786 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754858Ab0DUUQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 16:16:48 -0400
Date: Wed, 21 Apr 2010 13:16:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@linux.intel.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Sreedhara DS <sreedhara.ds@intel.com>
Subject: Re: [PATCH] IPC driver for Intel Mobile Internet Device (MID)
 platforms
Message-Id: <20100421131615.d8430a50.akpm@linux-foundation.org>
In-Reply-To: <20100409102629.22832.30883.stgit@localhost.localdomain>
References: <20100409102629.22832.30883.stgit@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Apr 2010 11:29:23 +0100
Alan Cox <alan@linux.intel.com> wrote:

> It would be nice to get this into the tree in some form as a pile of the
> driver stuff pending from Intel depends upon it. It's currently slotted into
> arch/x86 as the IPC interface is very much part of the hardware, so don't
> be fooled by its apparent PCI interface.
> 
> --
> 
> From: Sreedhara DS <sreedhara.ds@intel.com>
> 
> The IPC is used to bridge the communications between kernel and SCU on
> some embedded Intel x86 platforms.
> 
> (Some API tweaking Alan Cox)

It's be nice to have some words or a link describing what an IPC
actually _is_.

>
> ...
> 
> +struct battery_property {
> +	u32 capacity;	/* Charger capacity */
> +	u8  crnt;	/* Quick charge current value*/
> +	u8  volt;	/* Fine adjustment of constant charge voltage */
> +	u8  prot;	/* CHRGPROT register value */
> +	u8  prot2;	/* CHRGPROT1 register value */
> +	u8 timer;	/* Charging timer */
> +} __attribute__((packed));

__packed, please.  (I've requested that this be added to checkpatch,
but Mr Checkpatch is asleep).

>
> ...
> 
> +struct intel_scu_ipc_dev {
> +	struct pci_dev *pdev;
> +	void __iomem *ipc_base;
> +	void __iomem *i2c_base;
> +	void __iomem *pci_base;
> +};
> +
> +static struct intel_scu_ipc_dev  ipcdev; /* Only one for now */

Could do

static struct intel_scu_ipc_dev {
	...
} ipcdev;

if so inclined.

> +static int platform = 1;
> +module_param(platform, int, 0);
> +MODULE_PARM_DESC(platform, "1 for moorestown platform");
> +
> +/*
> + * Command Register (Write Only):
> + * A write to this register results in an interrupt to the SCU core processor
> + * Format:
> + * |rfu2(8) | size(8) | command id(4) | rfu1(3) | ioc(1) | command(8)|
> + */
> +#define IPC_COMMAND_REG		ipcdev.ipc_base
>
> +/*
> + * Status Register (Read Only):
> + * Driver will read this register to get the ready/busy status of the IPC
> + * block and error status of the IPC command that was just processed by SCU
> + * Format:
> + * |rfu3(8)|error code(8)|initiator id(8)|cmd id(4)|rfu1(2)|error(1)|busy(1)|
> + */
> +#define IPC_STATUS_REG		(ipcdev.ipc_base + 0x04)
> +
> +/*
> + * IPC Source Pointer (Write Only):
> + * Use content as pointer for read location
> +*/
> +#define IPC_SPTR_REG		(ipcdev.ipc_base + 0x08)
> +
> +/*
> + * IPC destination Pointer (Write Only):
> + * Use content as pointer for destination write
> +*/
> +#define IPC_DPTR_REG		(ipcdev.ipc_base + 0x0C)
> +
> +/*
> + * IPC Write Buffer (Write Only):
> + * 16-byte buffer for sending data associated with IPC command to
> + * SCU. Size of the data is specified in the IPC_COMMAND_REG register
> +*/
> +#define IPC_WRITE_BUFFER	(ipcdev.ipc_base + 0x80)
> +
> +/*
> + * IPC Read Buffer (Read Only):
> + * 16 byte buffer for receiving data from SCU, if IPC command
> + * processing results in response data
> +*/
> +#define IPC_READ_BUFFER		(ipcdev.ipc_base + 0x90)
> +
> +#define IPC_I2C_CNTRL_ADDR	ipcdev.i2c_base
> +#define I2C_DATA_ADDR		(ipcdev.i2c_base + 0x04)

Do we actually need these aliases?  Why not open-code
`ipcdev.ipc_base', etc in the very few places where these macros are
used?

>
> ...
> 
> +static inline int busy_loop(void) /* Wait till scu status is busy */
> +{
> +	u32 status = 0;
> +	u32 loop_count = 0;
> +
> +	status = __raw_readl(IPC_STATUS_REG);
> +	while (status & 1) {
> +		udelay(1); /* scu processing time is in few u secods */
> +		status = __raw_readl(IPC_STATUS_REG);
> +		loop_count++;
> +		/* break if scu doesn't reset busy bit after huge retry */
> +		if (loop_count > 100000)
> +			return -ETIMEDOUT;

I'd suggest adding a printk if this failure happens.  Otherwise the
results will be pretty mysterious.

> +	}
> +	return (status >> 1) & 1;
> +}

This function has seven-odd callsites and is waaaaaaaay to fat and slow
to be inlined.

> +/* Read/Write power control(PMIC in Langwell, MSIC in PenWell) registers */
> +static int pwr_reg_rdwr(u16 *addr, u8 *data, u32 count, u32 op, u32 id)
> +{
> +	int nc;
> +	u32 offset = 0;
> +	u32 err = 0;
> +	u8 cbuf[IPC_WWBUF_SIZE] = { '\0' };

Actually, `= { }' will suffice.

> +	u32 *wbuf = (u32 *)&cbuf;
> +
> +	mutex_lock(&ipclock);
> +	if (ipcdev.pdev == NULL) {
> +		mutex_unlock(&ipclock);
> +		return -ENODEV;
> +	}
> +
> +	if (platform == 1) {
> +		/* Entry is 4 bytes for read/write, 5 bytes for read modify */
> +		for (nc = 0; nc < count; nc++) {
> +			cbuf[offset] = addr[nc];
> +			cbuf[offset + 1] = addr[nc] >> 8;
> +			if (id != IPC_CMD_PCNTRL_R)
> +				cbuf[offset + 2] = data[nc];
> +			if (id == IPC_CMD_PCNTRL_M) {
> +				cbuf[offset + 3] = data[nc + 1];
> +				offset += 1;
> +			}
> +			offset += 3;
> +		}
> +		for (nc = 0, offset = 0; nc < count; nc++, offset += 4)
> +			ipc_write(wbuf[nc], offset); /* Write wbuff */
> +
> +	} else {
> +		for (nc = 0, offset = 0; nc < count; nc++, offset += 2)
> +			ipc_write(addr[nc], offset); /* Write addresses */
> +		if (id != IPC_CMD_PCNTRL_R) {
> +			for (nc = 0; nc < count; nc++, offset++)
> +				ipc_write(data[nc], offset); /* Write data */
> +			if (id == IPC_CMD_PCNTRL_M)
> +				ipc_write(data[nc + 1], offset); /* Mask value*/
> +		}
> +	}
> +
> +	if (id != IPC_CMD_PCNTRL_M)
> +		ipc_command((count*3) << 16 |  id << 12 | 0 << 8 | op);
> +	else
> +		ipc_command((count*4) << 16 |  id << 12 | 0 << 8 | op);
> +
> +	err = busy_loop();
> +
> +	if (id == IPC_CMD_PCNTRL_R) { /* Read rbuf */
> +		/* Workaround: values are read as 0 without memcpy_fromio */
> +		memcpy_fromio(cbuf, IPC_READ_BUFFER, 16);

Should we still be doing this if busy_loop() failed?

(Lots of dittoes on this question)

> +		if (platform == 1) {
> +			for (nc = 0, offset = 2; nc < count; nc++, offset += 3)
> +				data[nc] = ipc_readb(offset);
> +		} else {
> +			for (nc = 0; nc < count; nc++)
> +				data[nc] = ipc_readb(nc);
> +		}
> +	}
> +	mutex_unlock(&ipclock);
> +	return err;
> +}

I wonder if this function would look better if cbuf had type u16[],

>
> ...
> 
> +int intel_scu_ipc_register_read(u32 addr, u32 *value)
> +{
> +	u32 err = 0;
> +
> +	mutex_lock(&ipclock);
> +	if (ipcdev.pdev == NULL) {

This check happens a lot.  Can it really happen?

> +		mutex_unlock(&ipclock);
> +		return -ENODEV;
> +	}
> +	ipc_write_sptr(addr);
> +	ipc_command(4 << 16 | IPC_CMD_INDIRECT_RD);
> +	err = busy_loop();
> +	*value = ipc_readl(0);
> +	mutex_unlock(&ipclock);
> +	return err;
> +}
> +EXPORT_SYMBOL(intel_scu_ipc_register_read);
> +
>
> ...
> 
> +int intel_scu_ipc_i2c_cntrl(u32 addr, u32 *data)
> +{
> +	u32 cmd = 0;
> +
> +	mutex_lock(&ipclock);
> +	cmd = (addr >> 24) & 0xFF;
> +	if (cmd == IPC_I2C_READ) {
> +		writel(addr, IPC_I2C_CNTRL_ADDR);
> +		mdelay(1);/*Write Not getting updated without delay*/

Odd commenting layout.

> +		*data = readl(I2C_DATA_ADDR);
> +	} else if (cmd == IPC_I2C_WRITE) {
> +		writel(addr, I2C_DATA_ADDR);
> +		mdelay(1);
> +		writel(addr, IPC_I2C_CNTRL_ADDR);
> +	} else {
> +		dev_err(&ipcdev.pdev->dev,
> +			"intel_scu_ipc: I2C INVALID_CMD = 0x%x\n", cmd);
> +
> +		mutex_unlock(&ipclock);
> +		return -1;
> +	}
> +	mutex_unlock(&ipclock);
> +	return 0;
> +}
>
> ...
> 
> +int intel_scu_ipc_fw_update(u8 *buffer, u32 length)
> +{
> +	void __iomem *fw_update_base;
> +	void __iomem *mailbox_base;
> +	int retry_cnt = 0;
> +
> +	struct fw_update_mailbox *mailbox = NULL;

Nuke random newline.

> +	mutex_lock(&ipclock);
> +	fw_update_base = ioremap_nocache(IPC_FW_LOAD_ADDR, (128*1024));
> +	if (fw_update_base == NULL) {
> +		mutex_unlock(&ipclock);
> +		return -ENOMEM;
> +	}
> +	mailbox_base = ioremap_nocache(IPC_FW_UPDATE_MBOX_ADDR,
> +					sizeof(struct fw_update_mailbox));
> +	if (mailbox_base == NULL) {
> +		iounmap(fw_update_base);
> +		mutex_unlock(&ipclock);
> +		return -ENOMEM;
> +	}
> +
> +	mailbox = (struct fw_update_mailbox *)mailbox_base;

I think mailbox_base could/should have had type `struct
fw_update_mailbox __iomem *'.  ioremap_nocache() should handle that
cleanly, and this cast goes away.

Otherwise, this cast is missing an __iomem.

And shouldn't `mailbox' have a __iomem too?  It's all a bit confuddled.

> +	ipc_command(IPC_CMD_FW_UPDATE_READY);
> +
> +	/* Intitialize mailbox */
> +	mailbox->status = 0;
> +	mailbox->scu_flag = 0;
> +	mailbox->driver_flag = 0;

So this is driectly writing into iomem.

> +	/* Driver copies the 2KB MIP header to SRAM at 0xFFFC0000*/
> +	memcpy_toio((u8 *)(fw_update_base), buffer, 0x800);
> +
> +	/* Driver sends "FW Update" IPC command (CMD_ID 0xFE; MSG_ID 0x02).
> +	* Upon receiving this command, SCU will write the 2K MIP header
> +	* from 0xFFFC0000 into NAND.
> +	* SCU will write a status code into the Mailbox, and then set scu_flag.
> +	*/

Do we need to do something here to ensure that all the above writes
have landed?

> +	ipc_command(IPC_CMD_FW_UPDATE_GO);
> +
> +	/*Driver stalls until scu_flag is set */

Odd comment layout.

> +	while (mailbox->scu_flag != 1) {
> +		rmb();
> +		mdelay(1);
> +	}
> +
> +	/* Driver checks Mailbox status.
> +	 * If the status is 'BADN', then abort (bad NAND).
> +	 * If the status is 'IPC_FW_TXLOW', then continue.
> +	 */
> +	while (mailbox->status != IPC_FW_TXLOW) {
> +		rmb();
> +		mdelay(10);
> +	}
> +	mdelay(10);

Would be nice to explain the mysterious mdelay()s to the reader. 
What's it for?  Why 10?

> +update_retry:
> +	if (retry_cnt > 5)
> +		goto update_end;
> +
> +	if (mailbox->status != IPC_FW_TXLOW)
> +		goto update_end;
> +	buffer = buffer+0x800;
> +	memcpy_toio((u8 *)(fw_update_base), buffer, 0x20000);
> +	mailbox->driver_flag = 0x1;
> +	while (mailbox->scu_flag == 1) {
> +		rmb();
> +		mdelay(1);
> +	}
> +
> +	/* check for 'BADN' */
> +	if (mailbox->status == IPC_FW_UPDATE_BADN)
> +		goto update_end;
> +
> +	while (mailbox->status != IPC_FW_TXHIGH) {
> +		rmb();
> +		mdelay(10);
> +	}
> +	mdelay(10);
> +
> +	if (mailbox->status != IPC_FW_TXHIGH)
> +		goto update_end;
> +	buffer = buffer+0x20000;
> +	memcpy_toio((u8 *)(fw_update_base), buffer, 0x20000);
> +	mailbox->driver_flag = 0;
> +	while (mailbox->scu_flag == 0) {

Is there anything to prevent the compiler (or hardware?) from caching
->scu_flag from the previous read?

> +		rmb();
> +		mdelay(1);
> +	}
> +
> +	/* check for 'BADN' */
> +	if (mailbox->status == IPC_FW_UPDATE_BADN)
> +		goto update_end;
> +
> +	if (mailbox->status == IPC_FW_TXLOW) {
> +		++retry_cnt;
> +		goto update_retry;
> +	}
> +
> +update_end:
> +	iounmap(fw_update_base);
> +	iounmap(mailbox_base);
> +	mutex_unlock(&ipclock);
> +	if (mailbox->status == IPC_FW_UPDATE_SUCCESS)

Confused.  `mailbox' equals `mailbox_base', and `mailbox_base' just got
iounmapped.  Shouldn't this oops?

> +		return 0;
> +	return -1;
> +}
> +EXPORT_SYMBOL(intel_scu_ipc_fw_update);
>
> ...
> 


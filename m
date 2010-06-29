Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707Ab0F2XbN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 19:31:13 -0400
Received: from straum.hexapodia.org ([207.7.131.186]:50887 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab0F2XbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 19:31:11 -0400
Date: Tue, 29 Jun 2010 16:31:11 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: Masayuki Ohtak <masa-korg@dsn.okisemi.com>
Cc: Arnd Bergmann <arnd@arndb.de>, "Wang, Yong Y" <yong.y.wang@intel.com>,
       Wang Qi <qi.wang@intel.com>, Intel OTC <joel.clark@intel.com>,
       Andrew <andrew.chih.howe.khor@intel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Topcliff PHUB: Generate PacketHub driver
Message-ID: <20100629233111.GA6357@hexapodia.org>
References: <4C204B0D.2030201@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C204B0D.2030201@dsn.okisemi.com>
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 22, 2010 at 02:33:01PM +0900, Masayuki Ohtak wrote:
> +config PCH_PHUB
> +	tristate "PCH PHUB"
> +	depends on PCI
> +	help
> +	  If you say yes to this option, support will be included for the
> +	  PCH Packet Hub Host controller.
> +	  This driver is for PCH Packet hub driver for Topcliff.

"Topcliff" is probably some kind of internal codename; please use a name
that will be visible to customers of this product.  References to what
kind of device (IEEE standards it implements, what systems it might be
present on, etc) are also appropriate.

> +	  This driver is integrated as built-in.

This sentence doesn't parse to me.  What are you trying to say?

> +	  This driver can access GbE MAC address.
> +	  This driver can access HW register.

I think you mean something more like "This driver allows access to the
GbE MAC address and HW registers of the PCH Packet Hub."

If this is a driver for an Ethernet MAC, what is it doing in
drivers/char/ ?

> +	  You can also be integrated as module.

Please look at any other tristate and copy the standard wording.

> +/*!
> + * @file pch_phub.c
> + * @brief Provides all the implementation of the interfaces pertaining to
> + *		the Packet Hub module.

We don't normally merge comment markup languages other than kernel-doc.
Please read Documentation/kernel-doc-nano-HOWTO.txt and follow it.  (Or,
provide a pointer to documentation and tools for this mysterious markup
language.)

> +/*
> + * History:
> + * Copyright (C) 2010 OKI SEMICONDUCTOR Co., LTD.
> + *
> + * created:
> + *	OKI SEMICONDUCTOR 04/14/2010
> + * modified:

No changelogs in comments, that's what git history is for.

> +/* includes */

Useless comment.

> +/*--------------------------------------------
> +	macros
> +--------------------------------------------*/

More useless comments.

> +/* Status Register offset */
> +#define PHUB_STATUS 0x00
> +/* Control Register offset */
> +#define PHUB_CONTROL 0x04

I would format this as:

#define PHUB_STATUS     0x00    /* Status Register offset */
#define PHUB_CONTROL    0x04    /* Control Register offset */

but it's up to you.

> +struct pch_phub_reg {
> +	unsigned int phub_id_reg;

Since these are used to hold HW-defined data, you should use fixed-size
types such as u32.  Also, you should consider whether they should be
marked little endian / big endian.

> +/* ToDo: major number allocation via module parameter */
> +static dev_t pch_phub_dev_no;
> +static int pch_phub_major_no;
> +static struct cdev pch_phub_dev;

If this is to remain a chardev, use register_chrdev().  You shouldn't
need a module parameter to configure your device numbers.

> +	void __iomem *reg_addr = pch_phub_reg.pch_phub_base_address +\
> +							 reg_addr_offset;

That \ is superfluous.  There are several of these in this file.

The indentation on the second line is too large, and the fact that
"a = b + c" spills onto a second line is a clue that your struct names
are too long.

> +	iowrite32(((ioread32(reg_addr) & ~mask)) | data, reg_addr);
> +	return;

The return is unneeded if this remains a void function.  (many more
occurrences.)

> +/** pch_phub_restore_reg_conf - restore register configuration
> + */

Don't use /** unless you're using kernel-doc.

> +	unsigned int i;
> +	void __iomem *p = pch_phub_reg.pch_phub_base_address;
> +
> +	dev_dbg(&pdev->dev, "pch_phub_restore_reg_conf ENTRY\n");
> +	/* to store contents of PHUB_ID register */
> +	iowrite32(pch_phub_reg.phub_id_reg, p + PCH_PHUB_PHUB_ID_REG);

Don't include comments that just duplicate the code.  Also, rename your
constants from PCH_PHUB_PHUB_ to, I dunno, PHUB_ or something.

> +/** pch_phub_read_serial_rom - Implements the functionality of reading Serial
> + *  									 ROM.
> + *  @offset_address: Contains the Serial ROM address offset value
> + *  @data: Contains the Serial ROM value
> + */

This comment is almost correctly formatted, but there are extra words
and some whitespace problems, and it doesn't document what actually
happens.

+/**
+ * pch_phub_read_serial_rom - read PHUB Serial ROM.
+ *  @offset_address:   serial ROM offset to read.
+ *  @data:             pointer at which to store value that was read.
+ */

is more correct.

Similar problems in several function comments below.

> +static int pch_phub_read_serial_rom(unsigned int offset_address,
> +							 unsigned char *data)

The second line is indented too far.  We use 8-space tabstops, so the
"u" of unsigned is all the way over under the "t" of offset_address.  It
should either be two tabstops indented, or lined up with the previous
argument.  (This applies to several functions below too.)

It should be "u8 *data".

> +	void __iomem *mem_addr = pch_phub_reg.pch_phub_extrom_base_address +\
> +								 offset_address;
> +
> +	*data = ioread8(mem_addr);
> +
> +	return 0;

If this can't fail, why not have it just return the value rather than
forcing the caller to provide a pointer?  (If you want to be futureproof
and support errorhandling in the future, that's OK.)

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
> +
> +	switch (offset_address % 4) {
> +	case 0:
> +		word_data &= 0xFFFFFF00;
> +		iowrite32((word_data | (unsigned int)data),
> +						mem_addr);
> +		break;

This function is much larger than need be.  Remove the 0xFFFFFFFC magic
number -- something like

#define PCH_WORD_ADDR_MASK (~((1 << 4) - 1))

and implement the byte masking as something like

    pos = (offset_address % 4) * 8;
    mask = ~(0xFF << pos);
    iowrite32((word_data & mask) | (u32)data << pos, mem_addr);

(You can keep the switch if there's a significant performance benefit to
doing so, but please provide measurements.)

This is a read-modify-write cycle -- where is the locking if two users
try to update the serial ROM simultaneously?  Any required locking
should be documented in the kernel-doc comment.

> +	while (0x00 !=
> +	       ioread8(pch_phub_reg.pch_phub_extrom_base_address +\
> +							 PHUB_STATUS)) {
> +		msleep(1);
> +		if (PHUB_TIMEOUT == i) {
> +			retval = -EPERM;
> +			break;
> +		}
> +		i++;

Rewrite this as a for loop (and remove the initialization from the
declaration of i at the top of this function).  I am not sure if
msleep() is safe here -- what context will this be called from?

> +/** pch_phub_read_serial_rom_val - Implements the functionality of reading
> + *  							 Serial ROM value.
> + *  @offset_address: Contains the Serial ROM address offset value
> + *  @data: Contains the Serial ROM value
> + */
> +static int pch_phub_read_serial_rom_val(unsigned int offset_address,
> +							 unsigned char *data)
> +{
> +	int retval = 0;
> +	unsigned int mem_addr;
> +
> +	mem_addr = (offset_address / 4 * 8) + 3 -
> +			(offset_address % 4) + PCH_PHUB_ROM_START_ADDR;

Is that formula correct?   It is very suprising.

If it is correct, the formula is bizarre enough to warrant a long
comment explaining the theory of operation and/or pointing to hardware
docs.

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
> +
> +	/*Get Rom signature*/
> +	pch_phub_read_serial_rom(0x80, (unsigned char *)&rom_signature);
> +	pch_phub_read_serial_rom(0x81, (unsigned char *)&tmp);

I seriously doubt that your device is special enough to warrant a custom
/dev node with proprietary semantics.  If this is just part of an
Ethernet driver, please implement it in drivers/net/; if this is a
generic PROM accessor, there must be some semi-standardized EPROM access
interface but I don't know what it is offhand.

-andy

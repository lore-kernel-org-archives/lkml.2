Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168Ab1DTPRt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 11:17:49 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52100 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755140Ab1DTPRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 11:17:48 -0400
Date: Wed, 20 Apr 2011 16:18:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Li Jianyun <jianyunff@gmail.com>
Cc: James.Bottomley@suse.de, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH] Add Marvell UMI driver
Message-ID: <20110420161846.6bd7a3d1@lxorguk.ukuu.org.uk>
In-Reply-To: <4daee9cb.04558f0a.76dc.4776@mx.google.com>
References: <4daee9cb.04558f0a.76dc.4776@mx.google.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +#include <asm/uaccess.h>

linux/uaccess.h

[scripts/checkpatch.pl --file whatever is your friend]


> +static int mvumi_map_pci_addr(struct pci_dev *dev, void **addr_array)
> +{
> +	int i;
> +	unsigned long addr, range;
> +
> +	for (i = 0; i < MAX_BASE_ADDRESS; i++) {
> +		addr = pci_resource_start(dev, i);
> +		range = pci_resource_len(dev, i);
> +
> +		if (pci_resource_flags(dev, i) & IORESOURCE_MEM) {
> +			addr_array[i] = (void *) ioremap_nocache(addr, range);
> +			if (!addr_array[i]) {
> +				dev_printk(KERN_ERR, &dev->dev,

dev_err is a bit easier

> +					"Failed to map IO mem\n");
> +				return -1;
> +			}
> +		} else
> +			addr_array[i] = (void *) addr;
> +
> +		dev_printk(KERN_INFO, &dev->dev,
> +			"BAR %d : %p.\n", i, addr_array[i]);
> +	}
> +	return 0;
> +}

See pci_iomap/ioread32/iowrite32/etc you appear to be reinventing the
wheel.

> +static struct mvumi_res_mgnt *mvumi_alloc_mem_resource(struct mvumi_hba *mhba,
> +				enum resource_type type, unsigned int size)
> +{
> +	struct mvumi_res_mgnt *res_mgnt =
> +			vmalloc(sizeof(struct mvumi_res_mgnt));

Unless it's a very large object (> 2 pages) use kmalloc - on 32bit
machines kmalloc resources are much more freely available

This whole abstraction appears to be overkill though. You know what sort
of resource you allocated anyway so this seems to be excessive and
confusing



> +static struct mvumi_cmd *mvumi_create_internal_cmd(struct mvumi_hba *mhba,
> +				unsigned int buf_size)
> +{
> +	struct mvumi_cmd *cmd;
> +
> +	cmd = kmalloc(sizeof(struct mvumi_cmd), GFP_KERNEL);
> +	if (cmd == NULL) {
> +		dev_printk(KERN_ERR, &mhba->pdev->dev,
> +			"failed to create a internal cmd\n");
> +		return NULL;
> +	}
> +	memset(cmd, 0, sizeof(struct mvumi_cmd));

kzalloc


> +static unsigned char mvumi_send_ib_list_entry(struct mvumi_hba *mhba)
> +{
> +	void *regs = mhba->mmio;
> +	writel((unsigned int) 0xfff, mhba->ib_shadow);

Don't think you need some of these casts either


> +	dev_printk(KERN_INFO, &mhba->pdev->dev, "start firmware handshake.\n");

dev_info etc as well as dev_err


> +	dev_printk(KERN_INFO, &mhba->pdev->dev, "CLA_INB_LIST_BASEL=0x%x.\n",
> +					mvumi_mr32(CLA_INB_LIST_BASEL));
> +	dev_printk(KERN_INFO, &mhba->pdev->dev, "CLA_INB_LIST_BASEH=0x%x.\n",
> +					mvumi_mr32(CLA_INB_LIST_BASEH));
> +	dev_printk(KERN_INFO, &mhba->pdev->dev, "CLA_OUTB_LIST_BASEL=0x%x.\n",
> +					mvumi_mr32(CLA_OUTB_LIST_BASEL));
> +	dev_printk(KERN_INFO, &mhba->pdev->dev, "CLA_OUTB_LIST_BASEH=0x%x.\n",
> +					mvumi_mr32(CLA_OUTB_LIST_BASEH));
> +	dev_printk(KERN_INFO, &mhba->pdev->dev, "firmware handshake ok.\n");

A lot of this looks like it should be dev_dbg()



> +static void dwordcpy(void *to, const void *from, size_t n)
> +{
> +	unsigned int *p_dst = (unsigned int *) to;
> +	unsigned int *p_src = (unsigned int *) from;
> +
> +	WARN_ON(n & 0x3);
> +	n >>= 2;
> +	while (n--)
> +		*p_dst++ = *p_src++;
> +}

Why not use memcpy ?

> +static enum MV_QUEUE_COMMAND_RESULT mvumi_send_command(struct mvumi_hba *mhba,
> +						struct mvumi_cmd *cmd)

Please dont use CAPITAL_LETTER_SIZED_GIANT_TYPE_NAMING, Linux reserves
shouting for defines in general


> +	pci_read_config_word(pdev, 0x0A,  &class_code);

The class is available in the pci_dev already is it not ?

> +	dev_printk(KERN_INFO, &pdev->dev,
> +			" %#4.04x:%#4.04x:%#4.04x:%#4.04x: ",
> +			pdev->vendor, pdev->device, pdev->subsystem_vendor,
> +			pdev->subsystem_device);
> +	dev_printk(KERN_INFO, &pdev->dev,
> +			"bus %d:slot %d:func %d:class_code:%#4.04x\n",
> +			pdev->bus->number, PCI_SLOT(pdev->devfn),
> +			PCI_FUNC(pdev->devfn), class_code);

Like most of the printk stuff this should be debug level


> +struct mv_sgl {
> +	unsigned int	baseaddr_l;
> +	unsigned int	baseaddr_h;
> +	unsigned int	flags;
> +	unsigned int	size;
> +};

In general if you want these to be a given size (ie they are shared) use
u32/u64/u8/u16 etc and make it explicit.

> +
> +#define sgd_getsz(sgd, sz)  do {	\
> +	(sz) = (sgd)->size;		\
> +} while (0)
> +
> +#define sgd_setsz(sgd, sz) do {			\
> +	(sgd)->size = (sz);			\
> +} while (0)
> +
> +
> +#define sgd_inc(sgd) do {					\
> +	sgd = (struct mv_sgl *) (((unsigned char *) (sgd)) + 16);\
> +} while (0)

These really shouldn't be magic macros, and all the casting actually
makes them messier than just using C pointer increment rules like normal
drivers.

If struct foo is 16 bytes then ++ moves a struct foo * on to the next
struct so you don't need all the gunge anyway



> +static inline struct list_head *list_get_first(struct list_head *head)

I'm not sure hiding your only subtly different list handling in a header
is going to help everyone understand the code either !


> +#define list_get_first_entry(head, type, member)	\
> +	list_entry(list_get_first(head), type, member)
> +
> +#define list_get_last_entry(head, type, member)	\
> +	list_entry(list_get_last(head), type, member)
> +

> +extern struct timezone sys_tz;

Umm why ???


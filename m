Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750944Ab0JMJhF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 05:37:05 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:44520 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab0JMJhD convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:7:1>);
	Wed, 13 Oct 2010 05:37:03 -0400
Message-Id: <4CB599DB020000780001CC60@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 13 Oct 2010 10:36:59 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "Ryan Wilson" <hap9@darnok.org>,
        "Stefano Stabellini" <stefano.stabellini@eu.citrix.com>,
        "Jeremy Fitzhardinge" <jeremy@goop.org>,
        "Konrad Rzeszutek Wilk" <konrad@kernel.org>,
        <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 20/23] xen-pcifront: Xen PCI frontend driver.
References: <1286898271-32018-1-git-send-email-konrad.wilk@oracle.com>
 <1286898271-32018-21-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1286898271-32018-21-git-send-email-konrad.wilk@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 12.10.10 at 17:44, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> --- a/drivers/pci/Kconfig
> +++ b/drivers/pci/Kconfig
> @@ -40,6 +40,21 @@ config PCI_STUB
>  
>  	  When in doubt, say N.
>  
> +config XEN_PCIDEV_FRONTEND
> +        tristate "Xen PCI Frontend"
> +        depends on PCI && X86 && XEN
> +        select HOTPLUG
> +        select PCI_XEN
> +        default y
> +        help
> +          The PCI device frontend driver allows the kernel to import 
> arbitrary
> +          PCI devices from a PCI backend to support PCI driver domains.
> +
> +config XEN_PCIDEV_FE_DEBUG
> +        bool
> +        depends on PCI_DEBUG
> +        default n

A bool without prompt, (pointlessly) defaulting to 'n', and without
getting selected anywhere has no way to get set to 'y'...

> +
>  config HT_IRQ
>  	bool "Interrupts on hypertransport devices"
>  	default y
> --- /dev/null
> +++ b/drivers/pci/xen-pcifront.c
> @@ -0,0 +1,1157 @@
> +/*
> + * Xen PCI Frontend.
> + *
> + *   Author: Ryan Wilson <hap9@epoch.ncsc.mil>
> + */
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/mm.h>
> +#include <xen/xenbus.h>
> +#include <xen/events.h>
> +#include <xen/grant_table.h>
> +#include <xen/page.h>
> +#include <linux/spinlock.h>
> +#include <linux/pci.h>
> +#include <linux/msi.h>
> +#include <xen/xenbus.h>
> +#include <xen/interface/io/pciif.h>
> +#include <asm/xen/pci.h>
> +#include <linux/interrupt.h>
> +#include <asm/atomic.h>
> +#include <linux/workqueue.h>
> +#include <linux/bitops.h>
> +#include <linux/time.h>
> +
> +
> +#ifndef __init_refok
> +#define __init_refok
> +#endif

???

> +
> +#define INVALID_GRANT_REF (0)
> +#define INVALID_EVTCHN    (-1)
> +
> +
> +struct pci_bus_entry {
> +	struct list_head list;
> +	struct pci_bus *bus;
> +};
> +
> +#define _PDEVB_op_active		(0)
> +#define PDEVB_op_active			(1 << (_PDEVB_op_active))
> +
> +struct pcifront_device {
> +	struct xenbus_device *xdev;
> +	struct list_head root_buses;
> +
> +	int evtchn;
> +	int gnt_ref;
> +
> +	int irq;
> +
> +	/* Lock this when doing any operations in sh_info */
> +	spinlock_t sh_info_lock;
> +	struct xen_pci_sharedinfo *sh_info;
> +	struct work_struct op_work;
> +	unsigned long flags;
> +
> +};
> +
> +struct pcifront_sd {
> +	int domain;
> +	struct pcifront_device *pdev;
> +};
> +
> +static inline struct pcifront_device *
> +pcifront_get_pdev(struct pcifront_sd *sd)
> +{
> +	return sd->pdev;
> +}
> +
> +static inline void pcifront_init_sd(struct pcifront_sd *sd,
> +				    unsigned int domain, unsigned int bus,
> +				    struct pcifront_device *pdev)
> +{
> +	sd->domain = domain;
> +	sd->pdev = pdev;
> +}
> +
> +static inline void pcifront_setup_root_resources(struct pci_bus *bus,
> +						 struct pcifront_sd *sd)
> +{
> +}

???

> +
> +
> +DEFINE_SPINLOCK(pcifront_dev_lock);

static?

>...
> +void pcifront_do_aer(struct work_struct *data)

static?

>...
> +irqreturn_t pcifront_handler_aer(int irq, void *dev)

static?

>...
> +int pcifront_connect(struct pcifront_device *pdev)

static?

>...
> +void pcifront_disconnect(struct pcifront_device *pdev)

static?

>...
> +static void free_pdev(struct pcifront_device *pdev)
> +{
> +	dev_dbg(&pdev->xdev->dev, "freeing pdev @ 0x%p\n", pdev);
> +
> +	pcifront_free_roots(pdev);
> +
> +	/*For PCIE_AER error handling job*/
> +	flush_scheduled_work();

	if (pdev->irq > 0)

> +	unbind_from_irqhandler(pdev->irq, pdev);
> +
> +	if (pdev->evtchn != INVALID_EVTCHN)
> +		xenbus_free_evtchn(pdev->xdev, pdev->evtchn);
> +
> +	if (pdev->gnt_ref != INVALID_GRANT_REF)
> +		gnttab_end_foreign_access(pdev->gnt_ref, 0 /* r/w page */,
> +					  (unsigned long)pdev->sh_info);

	else
		free_page((unsigned long)pdev->sh_info);

> +
> +	dev_set_drvdata(&pdev->xdev->dev, NULL);
> +
> +	kfree(pdev);
> +}
> +
> +static int pcifront_publish_info(struct pcifront_device *pdev)
> +{
> +	int err = 0;
> +	struct xenbus_transaction trans;
> +
> +	err = xenbus_grant_ring(pdev->xdev, virt_to_mfn(pdev->sh_info));
> +	if (err < 0)
> +		goto out;
> +
> +	pdev->gnt_ref = err;
> +
> +	err = xenbus_alloc_evtchn(pdev->xdev, &pdev->evtchn);
> +	if (err)
> +		goto out;
> +
> +	err = bind_evtchn_to_irqhandler(pdev->evtchn, pcifront_handler_aer,
> +		0, "pcifront", pdev);
> +	if (err < 0) {
> +		xenbus_free_evtchn(pdev->xdev, pdev->evtchn);

You're leaking the grant ref here. I think it's better to not do any
cleanup here, and instead call free_pdev() on error in
pcifront_xenbus_probe() (see below).

> +		xenbus_dev_fatal(pdev->xdev, err, "Failed to bind evtchn to "
> +				 "irqhandler.\n");
> +		return err;
> +	}
> +	pdev->irq = err;
>...
> +static int __devinit pcifront_try_connect(struct pcifront_device *pdev)
> +{
> +	int err = -EFAULT;
> +	int i, num_roots, len;
> +	char str[64];
> +	unsigned int domain, bus;
> +

The original code had a per-device lock here and in subsequent
functions. Is this being dropped due to implicit serialization through
only running in the context of the single xenbus thread?

>...
> +static int pcifront_xenbus_probe(struct xenbus_device *xdev,
> +				 const struct xenbus_device_id *id)
> +{
> +	int err = 0;
> +	struct pcifront_device *pdev = alloc_pdev(xdev);
> +
> +	if (pdev == NULL) {
> +		err = -ENOMEM;
> +		xenbus_dev_fatal(xdev, err,
> +				 "Error allocating pcifront_device struct");
> +		goto out;
> +	}
> +
> +	err = pcifront_publish_info(pdev);

	if (err)
		free_pdev(pdev);

> +
> +out:
> +	return err;
> +}
>...

Jan

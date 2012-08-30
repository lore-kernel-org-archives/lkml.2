Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab2H3VEG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 17:04:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40883 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab2H3VEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 17:04:04 -0400
Date: Thu, 30 Aug 2012 14:04:00 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: George Zhang <georgezhang@vmware.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 04/11] vmci_driver.patch: VMCI device driver.
Message-ID: <20120830210400.GB3276@kroah.com>
References: <20120824171042.4775.36871.stgit@promb-2n-dhcp175.eng.vmware.com>
 <20120824171607.4775.41134.stgit@promb-2n-dhcp175.eng.vmware.com>
 <15333E71B3DDCB48A90165AD57993F285685DB43DA@exch-mbx-114.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15333E71B3DDCB48A90165AD57993F285685DB43DA@exch-mbx-114.vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 09:40:34AM -0700, George Zhang wrote:
> +struct vmci_device {
> +       struct mutex lock; /* Device access mutex */
> +
> +       unsigned int ioaddr;
> +       unsigned int ioaddr_size;
> +       unsigned int irq;
> +       unsigned int intr_type;
> +       bool exclusive_vectors;
> +       struct msix_entry msix_entries[VMCI_MAX_INTRS];
> +
> +       bool enabled;
> +       spinlock_t dev_spinlock; /* Lock for datagram access synchronization */
> +       atomic_t datagrams_allowed;
> +};

Why are you ignoring the driver model with this code, and the rest of
your infractructure?  Please don't, that's just rude.  Hint, you should
have a "struct device dev" in this structure if you are doing things
right.

> +static long drv_driver_unlocked_ioctl(struct file *filp,
> +                                     u_int iocmd,
> +                                     unsigned long ioarg)
> +{

Ah, a new syscall.  Why not just create a real syscall instead of
multiplexing here?  Are you _sure_ all of these ioctls really are needed
(hint, I know they aren't...)

> +static int __devinit drv_probe_device(struct pci_dev *pdev,
> +                                     const struct pci_device_id *id)
> +{
> +       unsigned int ioaddr;
> +       unsigned int ioaddr_size;
> +       unsigned int capabilities;
> +       int result;
> +
> +       pr_info("Probing for vmci/PCI.");

This is pointless, why are you being noisy?

> +       result = pci_enable_device(pdev);
> +       if (result) {
> +               pr_err("Cannot enable VMCI device %s: error %d",
> +                      pci_name(pdev), result);

Ick, please use dev_err() here, and other dev_* printk functions where
you can (hint, it's quite often in this file.)

> +               return result;
> +       }
> +       pci_set_master(pdev);   /* To enable QueuePair functionality. */
> +       ioaddr = pci_resource_start(pdev, 0);
> +       ioaddr_size = pci_resource_len(pdev, 0);
> +
> +       /*
> +        * Request I/O region with adjusted base address and size. The
> +        * adjusted values are needed and used if we release the
> +        * region in case of failure.
> +        */
> +       if (!request_region(ioaddr, ioaddr_size, MODULE_NAME)) {
> +               pr_info(MODULE_NAME ": Another driver already loaded " \
> +                       "for device in slot %s.", pci_name(pdev));
> +               goto pci_disable;
> +       }
> +
> +       pr_info("Found VMCI PCI device at %#x, irq %u.", ioaddr, pdev->irq);

Ick, noisy, you should NEVER print anything out if all goes well, that's
pointless.

greg k-h

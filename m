Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab2EFPe1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 11:34:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753706Ab2EFPe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 11:34:26 -0400
Message-ID: <4FA699F6.9010605@redhat.com>
Date: Sun, 06 May 2012 18:34:14 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Xudong Hao <xudong.hao@linux.intel.com>
CC: mtosatti@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        xiantao.zhang@intel.com, xudong.hao@intel.com,
        Alex Williamson <Alex.Williamson@redhat.com>
Subject: Re: [PATCH] kvm: Enable device LTR/OBFF capibility before doing guest
 device assignment
References: <20120506152405.GA14009@hp-xd.sh.intel.com>
In-Reply-To: <20120506152405.GA14009@hp-xd.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2012 06:24 PM, Xudong Hao wrote:
> Enable device LTR/OBFF capibility before do device assignment, so that guest can benefit from them.

cc += Alex

> @@ -166,6 +166,10 @@ int kvm_assign_device(struct kvm *kvm,
>     if (pdev == NULL)
>         return -ENODEV;
>
> +   /* Enable some device capibility before do device assignment,
> +    * so that guest can benefit from them.
> +    */
> +   kvm_iommu_enable_dev_caps(pdev);
>     r = iommu_attach_device(domain, &pdev->dev);

Suppose we fail here.  Do we need to disable_dev_caps()?

>     if (r) {
>         printk(KERN_ERR "assign device %x:%x:%x.%x failed",
> @@ -228,6 +232,7 @@ int kvm_deassign_device(struct kvm *kvm,
>         PCI_SLOT(assigned_dev->host_devfn),
>         PCI_FUNC(assigned_dev->host_devfn));
>
> +   kvm_iommu_disable_dev_caps(pdev);
>     return 0;
>  }
>
> @@ -351,3 +356,30 @@ int kvm_iommu_unmap_guest(struct kvm *kvm)
>     iommu_domain_free(domain);
>     return 0;
>  }
> +
> +static void kvm_iommu_enable_dev_caps(struct pci_dev *pdev)
> +{
> +   /* set default value */
> +   unsigned long type = PCI_EXP_OBFF_SIGNAL_ALWAYS;
> +   int snoop_lat_ns = 1024, nosnoop_lat_ns = 1024;

Where does this magic number come from?

> +
> +   /* LTR(Latency tolerance reporting) allows devices to send
> +    * messages to the root complex indicating their latency
> +    * tolerance for snooped & unsnooped memory transactions.
> +    */
> +   pci_enable_ltr(pdev);
> +   pci_set_ltr(pdev, snoop_lat_ns, nosnoop_lat_ns);
> +
> +   /* OBFF (optimized buffer flush/fill), where supported,
> +    * can help improve energy efficiency by giving devices
> +    * information about when interrupts and other activity
> +    * will have a reduced power impact.
> +    */
> +   pci_enable_obff(pdev, type);
> +}
> +
> +static void kvm_iommu_disable_dev_caps(struct pci_dev *pdev)
> +{
> +   pci_disble_obff(pdev);
> +   pci_disble_ltr(pdev);
> +}

Do we need to communicate something about these capabilities to the guest?

-- 
error compiling committee.c: too many arguments to function


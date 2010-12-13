Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779Ab0LMT2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 14:28:13 -0500
Received: from claw.goop.org ([74.207.240.146]:32839 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753708Ab0LMT2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 14:28:11 -0500
Message-ID: <4D0673C9.2050601@goop.org>
Date: Mon, 13 Dec 2010 11:28:09 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: xen-devel@lists.xensource.com, Jan Beulich <JBeulich@novell.com>,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH 2/9] xen/pci: Add xen_[find|register|unregister]_device_domain_owner
 functions.
References: <1292263303-31680-1-git-send-email-konrad.wilk@oracle.com> <1292263303-31680-3-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1292263303-31680-3-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2010 10:01 AM, Konrad Rzeszutek Wilk wrote:
> Xen PCI backend performs ownership (MSI/MSI-X) changes on the behalf of
> the guest. This means we need some mechanism to find, set and unset
> the domain id of the guest.

Clarify this a little?  "Guest" is ambigious in this context; do you
mean set the owning domain of the device?

> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/include/asm/xen/pci.h |   16 +++++++++
>  arch/x86/pci/xen.c             |   73 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 89 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/include/asm/xen/pci.h b/arch/x86/include/asm/xen/pci.h
> index 2329b3e..8474b4b 100644
> --- a/arch/x86/include/asm/xen/pci.h
> +++ b/arch/x86/include/asm/xen/pci.h
> @@ -15,10 +15,26 @@ static inline int pci_xen_hvm_init(void)
>  #endif
>  #if defined(CONFIG_XEN_DOM0)
>  void __init xen_setup_pirqs(void);
> +int xen_find_device_domain_owner(struct pci_dev *dev);
> +int xen_register_device_domain_owner(struct pci_dev *dev, uint16_t domain);
> +int xen_unregister_device_domain_owner(struct pci_dev *dev);
>  #else
>  static inline void __init xen_setup_pirqs(void)
>  {
>  }
> +static inline int xen_find_device_domain_owner(struct pci_dev *dev)
> +{
> +	return -1;
> +}
> +static inline int xen_register_device_domain_owner(struct pci_dev *dev,
> + 						   uint16_t domain)
> +{
> +	return -1;
> +}
> +static inline int xen_unregister_device_domain_owner(struct pci_dev *dev)
> +{
> +	return -1;
> +}
>  #endif
>  
>  #if defined(CONFIG_PCI_MSI)
> diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
> index 117f5b8..6d2a986 100644
> --- a/arch/x86/pci/xen.c
> +++ b/arch/x86/pci/xen.c
> @@ -412,3 +412,76 @@ void __init xen_setup_pirqs(void)
>  	}
>  }
>  #endif
> +
> +struct xen_device_domain_owner {
> +	domid_t domain;
> +	struct pci_dev *dev;
> +	struct list_head list;
> +};
> +
> +static DEFINE_SPINLOCK(dev_domain_list_spinlock);
> +static struct list_head dev_domain_list = LIST_HEAD_INIT(dev_domain_list);
> +
> +static struct xen_device_domain_owner *find_device(struct pci_dev *dev)
> +{
> +	struct xen_device_domain_owner *owner;
> +
> +	list_for_each_entry(owner, &dev_domain_list, list) {
> +		if (owner->dev == dev)
> +			return owner;
> +	}
> +	return NULL;
> +}
> +
> +int xen_find_device_domain_owner(struct pci_dev *dev)
> +{
> +	struct xen_device_domain_owner *owner;
> +	int domain = -ENODEV;

ENODEV seems odd.  ENOENT?

> +
> +	spin_lock(&dev_domain_list_spinlock);
> +	owner = find_device(dev);
> +	if (owner)
> +		domain = owner->domain;
> +	spin_unlock(&dev_domain_list_spinlock);
> +	return domain;
> +}
> +EXPORT_SYMBOL(xen_find_device_domain_owner);
> +
> +int xen_register_device_domain_owner(struct pci_dev *dev, uint16_t domain)

uint16_t seems like an odd type to use.  You return "int" for the domain
id above.  Xen may use a 16-bit domain identifier, but I think that if
you want to express that here there should be a xen_domid_t or
something.  But just an ordinary integer type would be just as good.

> +{
> +	struct xen_device_domain_owner *owner;
> +
> +	owner = kzalloc(sizeof(struct xen_device_domain_owner), GFP_KERNEL);
> +	if (!owner)
> +		return -ENODEV;
> +
> +	spin_lock(&dev_domain_list_spinlock);
> +	if (find_device(dev)) {
> +		spin_unlock(&dev_domain_list_spinlock);
> +		kfree(owner);
> +		return -EEXIST;

Not that its really a big deal, but I really prefer the single-exit pattern:

	if (find_device(dev)) {
		err = -EEXIST;
		goto out;
	}
...

out:
	spin_unlock(&dev_domain_list_spinlock);
	return err;
}

so that the lock/unlock can be easily matched by eye.

(Same below.)

    J

> +	}
> +	owner->domain = domain;
> +	owner->dev = dev;
> +	list_add_tail(&owner->list, &dev_domain_list);
> +	spin_unlock(&dev_domain_list_spinlock);
> +	return 0;
> +}
> +EXPORT_SYMBOL(xen_register_device_domain_owner);
> +
> +int xen_unregister_device_domain_owner(struct pci_dev *dev)
> +{
> +	struct xen_device_domain_owner *owner;
> +
> +	spin_lock(&dev_domain_list_spinlock);
> +	owner = find_device(dev);
> +	if (!owner) {
> +		spin_unlock(&dev_domain_list_spinlock);
> +		return -ENODEV;
> +	}
> +	list_del(&owner->list);
> +	spin_unlock(&dev_domain_list_spinlock);
> +	kfree(owner);
> +	return 0;
> +}
> +EXPORT_SYMBOL(xen_unregister_device_domain_owner);


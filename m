Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965586Ab2CBQ3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 11:29:41 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:38721 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964972Ab2CBQ3j convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 11:29:39 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of bhelgaas@google.com designates 10.152.114.35 as permitted sender) smtp.mail=bhelgaas@google.com; dkim=pass header.i=bhelgaas@google.com
MIME-Version: 1.0
In-Reply-To: <4f50b540.6AzyOmpHR+z7jLk1%tadeusz.struk@intel.com>
References: <4f50b540.6AzyOmpHR+z7jLk1%tadeusz.struk@intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 2 Mar 2012 09:29:17 -0700
Message-ID: <CAErSpo6JaNXvJf_KEkRUYLed8ET4vSunfCAq9BWq3yd3+dZQpA@mail.gmail.com>
Subject: Re: [PATCH v2] Dynamically add and remove device specific reset functions
To: tadeusz.struk@intel.com
Cc: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks!

You didn't fix the subject line :)  It should contain "PCI: ".  Thanks
for including the "v2" inside "[PATCH]".  That helps keep things
straight.

On Fri, Mar 2, 2012 at 4:55 AM,  <tadeusz.struk@intel.com> wrote:
> Hi,
> Reworked according to comments.

All the text here becomes part of the changelog, so you don't need to
include the stuff that's only relevant during review, e.g., "Hi,
Reworked..."  That sort of stuff can either go in a separate "cover"
email ([0/1], with the patch itself being [1/1]), or after the "---"
along with the diffstat (text after the "---" doesn't go in the
changelog).

> I have a use case where I need to cleanup resource allocated for Virtual
> Functions after a guest OS that used it crashed. This cleanup needs to
> be done before the VF is being FLRed. The only possible way to do this
> seems to be by using pci_dev_specific_reset() function. Unfortunately
> this function only works for devices defined in a static table in the
> drivers/pci/quirks.c file. This patch changes it so that specific reset
> functions can be added and deleted dynamically.
>
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
>
> ---
>  drivers/pci/pci.h    |   14 +++++++++++
>  drivers/pci/quirks.c |   61 +++++++++++++++++++++++++++++++++++++++++--------
>  2 files changed, 65 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
> index 1009a5e..3e95df6 100644
> --- a/drivers/pci/pci.h
> +++ b/drivers/pci/pci.h
> @@ -312,6 +312,7 @@ static inline resource_size_t pci_resource_alignment(struct pci_dev *dev,
>  extern void pci_enable_acs(struct pci_dev *dev);
>
>  struct pci_dev_reset_methods {
> +       struct list_head list;
>        u16 vendor;
>        u16 device;
>        int (*reset)(struct pci_dev *dev, int probe);
> @@ -319,11 +320,24 @@ struct pci_dev_reset_methods {
>
>  #ifdef CONFIG_PCI_QUIRKS
>  extern int pci_dev_specific_reset(struct pci_dev *dev, int probe);
> +extern int pci_dev_specific_reset_add(struct pci_dev_reset_methods
> +                                       *reset_method);
> +extern int pci_dev_specific_reset_remove(struct pci_dev_reset_methods
> +                                       *reset_method);
>  #else
>  static inline int pci_dev_specific_reset(struct pci_dev *dev, int probe)
>  {
>        return -ENOTTY;
>  }
> +int pci_dev_specific_reset_add(struct pci_dev_reset_methods *reset_method)
> +{
> +       return 0;
> +}
> +int
> +pci_dev_specific_reset_remove(struct pci_dev_reset_methods *reset_method)
> +{
> +       return 0;
> +}
>  #endif
>
>  #endif /* DRIVERS_PCI_H */
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 6476547..a0152fd 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -3070,26 +3070,67 @@ static int reset_intel_82599_sfp_virtfn(struct pci_dev *dev, int probe)
>  }
>
>  #define PCI_DEVICE_ID_INTEL_82599_SFP_VF   0x10ed
> -
> -static const struct pci_dev_reset_methods pci_dev_reset_methods[] = {
> -       { PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82599_SFP_VF,
> -                reset_intel_82599_sfp_virtfn },
> -       { PCI_VENDOR_ID_INTEL, PCI_ANY_ID,
> +static struct pci_dev_reset_methods pci_dev_reset_methods[] = {
> +       { {NULL, NULL}, PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82599_SFP_VF,

I don't think you need the "{NULL, NULL}" initializers here.  In fact,
it encodes knowledge of the struct list_head implementation that
should not be here.  If you needed to intialize a list_head in a
structure like this, you would use "LIST_HEAD_INIT," but I don't think
you need it here.

I guess you probably would have to add "list" to the end, not the
beginning, of struct pci_dev_reset_methods for this to work.  But
putting it at the end should be fine.

> +               reset_intel_82599_sfp_virtfn },
> +       { {NULL, NULL}, PCI_VENDOR_ID_INTEL, PCI_ANY_ID,
>                reset_intel_generic_dev },
> -       { 0 }
>  };
>
> +static DEFINE_SPINLOCK(reset_list_lock);
> +static LIST_HEAD(reset_list);
> +
> +static int __init pci_dev_specific_reset_init(void)
> +{
> +       int i;

Add a blank line here.

> +       for (i = 0; i < ARRAY_SIZE(pci_dev_reset_methods); i++) {

Linux style omits the curly brackets around simple single-line blocks like this:

> +               pci_dev_specific_reset_add(&pci_dev_reset_methods[i]);
> +       }
> +       return 0;
> +}
> +
> +late_initcall(pci_dev_specific_reset_init);
> +
> +int pci_dev_specific_reset_add(struct pci_dev_reset_methods *reset_method)
> +{
> +       WARN_ON(!reset_method->reset);
> +       INIT_LIST_HEAD(&reset_method->list);
> +       spin_lock(&reset_list_lock);
> +       list_add(&reset_method->list, &reset_list);
> +       spin_unlock(&reset_list_lock);
> +       return 0;
> +}
> +EXPORT_SYMBOL(pci_dev_specific_reset_add);
> +
> +int pci_dev_specific_reset_remove(struct pci_dev_reset_methods *reset_method)
> +{
> +       spin_lock(&reset_list_lock);
> +       list_del(&reset_method->list);
> +       spin_unlock(&reset_list_lock);
> +       return 0;
> +}
> +EXPORT_SYMBOL(pci_dev_specific_reset_remove);
> +
>  int pci_dev_specific_reset(struct pci_dev *dev, int probe)
>  {
>        const struct pci_dev_reset_methods *i;
> +       spin_lock(&reset_list_lock);
> +       list_for_each_entry(i, &reset_list, list) {
> +               if (i->vendor == dev->vendor &&
> +                   i->device == dev->device) {
> +                       spin_unlock(&reset_list_lock);
> +                       return i->reset(dev, probe);

Where do you plan to add calls to pci_dev_specific_reset_add()?  In
drivers?  Did you consider adding a "reset" function pointer to struct
pci_driver?  That might be more natural -- the reset function is right
with all the other code that knows about the device, and there's no
issue with looking up the correct reset function.

With this patch, we sort of have two different ways to map
vendor/device IDs to code: the usual pci_register_driver() approach,
and this one using reset_list.  If pci_driver had a "reset" pointer,
that would be used most of the time.  You might still need the
reset_list for generic things, e.g., the reset_intel_generic_dev()
function, but it would be a fallback.  It might look something like:

    struct pci_driver *drv = dev->driver;

    if (drv && drv->reset) {
        drv->reset(dev);
        return;
    }

    list_for_each_entry(i, &reset_list, list) {
        ...

In that case, you might not even need the ability to dynamically add
things to the list, since the only things to add would be "generic"
things that would be more static.

Perhaps this approach was previously discussed and discarded; if so, I
missed it.

Bjorn

> +               }
> +       }
>
> -       for (i = pci_dev_reset_methods; i->reset; i++) {
> +       list_for_each_entry(i, &reset_list, list) {
>                if ((i->vendor == dev->vendor ||
>                     i->vendor == (u16)PCI_ANY_ID) &&
> -                   (i->device == dev->device ||
> -                    i->device == (u16)PCI_ANY_ID))
> +                    i->device == (u16)PCI_ANY_ID) {
> +                       spin_unlock(&reset_list_lock);
>                        return i->reset(dev, probe);
> +               }
>        }
> -
> +       spin_unlock(&reset_list_lock);
>        return -ENOTTY;
>  }
> --
> 1.7.7.6
>
> --------------------------------------------------------------
> Intel Shannon Limited
> Registered in Ireland
> Registered Office: Collinstown Industrial Park, Leixlip, County Kildare
> Registered Number: 308263
> Business address: Dromore House, East Park, Shannon, Co. Clare
>
> This e-mail and any attachments may contain confidential material for the sole use of the intended recipient(s). Any review or distribution by others is strictly prohibited. If you are not the intended recipient, please contact the sender and delete all copies.
>
>

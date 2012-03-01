Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729Ab2CASMW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 13:12:22 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:35536 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755560Ab2CASMU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 13:12:20 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of bhelgaas@google.com designates 10.152.124.77 as permitted sender) smtp.mail=bhelgaas@google.com; dkim=pass header.i=bhelgaas@google.com
MIME-Version: 1.0
In-Reply-To: <4f4faf56.55WpOIn/0L6OUf5o%tadeusz.struk@intel.com>
References: <4f4faf56.55WpOIn/0L6OUf5o%tadeusz.struk@intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 1 Mar 2012 11:11:58 -0700
Message-ID: <CAErSpo4RKXjS+998m=pU44RWCO6s4mk6vvEPXg9-HCQ1sP+PNA@mail.gmail.com>
Subject: Re: [PATCH] Added functionality that allows dynamically add and
 remove device specific reset functions
To: tadeusz.struk@intel.com
Cc: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 1, 2012 at 10:18 AM,  <tadeusz.struk@intel.com> wrote:
> From b4cf24d5987475862de799c78773f13f25ed2af8 Mon Sep 17 00:00:00 2001
> From: Tadeusz Struk <tadeusz.struk@intel.com>
> Date: Tue, 17 Jan 2012 16:45:46 +0000
> Subject: [PATCH] Added functionality that allows dynamically add and remove
>  device specific reset functions

The subject line (after removing "[PATCH"]) becomes part of the
permanent changelog, so please choose one that follows the typical
style for the file.  A good trick is to use "git log --oneline
drivers/pci/pci.h" and make yours look like the others.

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
>  drivers/pci/pci.h    |   19 ++++++++++++++-
>  drivers/pci/quirks.c |   63 ++++++++++++++++++++++++++++++++++++++++++--------
>  2 files changed, 71 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
> index 1009a5e..10929d8 100644
> --- a/drivers/pci/pci.h
> +++ b/drivers/pci/pci.h
> @@ -312,18 +312,35 @@ static inline resource_size_t pci_resource_alignment(struct pci_dev *dev,
>  extern void pci_enable_acs(struct pci_dev *dev);
>
>  struct pci_dev_reset_methods {
> +       struct list_head list;
>        u16 vendor;
>        u16 device;
>        int (*reset)(struct pci_dev *dev, int probe);
>  };
>
>  #ifdef CONFIG_PCI_QUIRKS
> -extern int pci_dev_specific_reset(struct pci_dev *dev, int probe);
> +extern int
> +pci_dev_specific_reset(struct pci_dev *dev, int probe);
> +extern int
> +pci_dev_specific_reset_add(const struct pci_dev_reset_methods *reset_method);
> +extern int
> +pci_dev_specific_reset_remove(const struct pci_dev_reset_methods *reset_method);

Please keep the existing code style, namely, function return type,
name, and arguments all on the same line (broken as needed to stay in
80 columns).  The "extern" is superfluous but most of the rest of the
file does use it, so this patch should, too.  It would be nice if you
added a second patch to remove *all* the "externs" in this file.

> +
>  #else
>  static inline int pci_dev_specific_reset(struct pci_dev *dev, int probe)
>  {
>        return -ENOTTY;
>  }
> +int
> +pci_dev_specific_reset_add(const struct pci_dev_reset_methods *reset_method)

Function name on same line as return type (several more instances below).

> +{
> +       return 0;
> +}
> +int
> +pci_dev_specific_reset_remove(const struct pci_dev_reset_methods *reset_method)
> +{
> +       return 0;
> +}
>  #endif
>
>  #endif /* DRIVERS_PCI_H */
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 6476547..963e527 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -3070,26 +3070,69 @@ static int reset_intel_82599_sfp_virtfn(struct pci_dev *dev, int probe)
>  }
>
>  #define PCI_DEVICE_ID_INTEL_82599_SFP_VF   0x10ed
> +static struct pci_dev_reset_methods intel_82599_sfp_vf_reset = {
> +       .vendor = PCI_VENDOR_ID_INTEL,
> +       .device = PCI_DEVICE_ID_INTEL_82599_SFP_VF,
> +       .reset = reset_intel_82599_sfp_virtfn,
> +       .list = LIST_HEAD_INIT(intel_82599_sfp_vf_reset.list)

I don't think you need to initialize the .list member here.  You
should be able to do that when linking the method into the list.

> +} ;
>
> -static const struct pci_dev_reset_methods pci_dev_reset_methods[] = {
> -       { PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82599_SFP_VF,
> -                reset_intel_82599_sfp_virtfn },
> -       { PCI_VENDOR_ID_INTEL, PCI_ANY_ID,
> -               reset_intel_generic_dev },
> -       { 0 }
> -};
> +static struct pci_dev_reset_methods intel_generic_reset = {
> +       .vendor = PCI_VENDOR_ID_INTEL,
> +       .device = PCI_ANY_ID,
> +       .reset = reset_intel_generic_dev,
> +       .list = LIST_HEAD_INIT(intel_generic_reset.list)
> +} ;
> +
> +static DEFINE_SPINLOCK(reset_list_lock);
> +static LIST_HEAD(reset_list);
> +
> +
> +static int __init pci_dev_specific_reset_init(void)
> +{
> +       pci_dev_specific_reset_add(&intel_82599_sfp_vf_reset);
> +       pci_dev_specific_reset_add(&intel_generic_reset);

I think this would be better as:

    for (i = 0; i < ARRAY_SIZE(pci_dev_reset_methods); i++)
        pci_dev_specific_reset_add(&pci_dev_reset_methods[i]);

That way, new statically included methods could be added without
touching this function.  Also, I don't think the
pci_dev_reset_methods[] definition would need to be changed at all for
this patch (though I think you could remove the trailing "{ 0 }"
sentinel).

> +       return 0;
> +}
> +
> +late_initcall(pci_dev_specific_reset_init);
> +
> +int
> +pci_dev_specific_reset_add(const struct pci_dev_reset_methods *reset_method)
> +{
> +       if (reset_method && reset_method->reset) {

I don't think we should test for "reset_method" here.  If it's NULL,
that means the caller screwed up, and I want to learn about it
immediately, with a nice "null pointer dereference" backtrace, rather
than returning -EINVAL, which probably won't be checked.  I don't
think I would check reset_method->reset, either, but you could add a
"WARN_ON(!reset_method->reset)" or something if you want to.

> +               spin_lock(&reset_list_lock);
> +               list_add((struct list_head *)&reset_method->list,
> +                        &reset_list);

The cast shouldn't be necessary, and it looks like this should all fit
on one line.

> +               spin_unlock(&reset_list_lock);
> +               return 0;
> +       }
> +       return -EINVAL;
> +}
> +EXPORT_SYMBOL(pci_dev_specific_reset_add);
> +
> +int
> +pci_dev_specific_reset_remove(const struct pci_dev_reset_methods *reset_method)
> +{
> +       if (reset_method) {
> +               spin_lock(&reset_list_lock);
> +               list_del((struct list_head *)(&reset_method->list));

Same "reset_method" and cast comments apply here.

> +               spin_unlock(&reset_list_lock);
> +               return 0;
> +       }
> +       return -EINVAL;
> +}
> +EXPORT_SYMBOL(pci_dev_specific_reset_remove);
>
>  int pci_dev_specific_reset(struct pci_dev *dev, int probe)
>  {
>        const struct pci_dev_reset_methods *i;
> -
> -       for (i = pci_dev_reset_methods; i->reset; i++) {
> +       list_for_each_entry(i, &reset_list, list) {

Traversing this list without holding the lock isn't safe; another CPU
could be removing a method while you're looking for one.

>                if ((i->vendor == dev->vendor ||
>                     i->vendor == (u16)PCI_ANY_ID) &&
>                    (i->device == dev->device ||
>                     i->device == (u16)PCI_ANY_ID))
>                        return i->reset(dev, probe);

You now have an interesting ambiguity that you didn't have before: the
reset method selection depends on the order things are added to the
list.  As written, I think it's impossible for a module to add a new
reset method for a specific Intel device, because we'll always match
intel_generic_reset() before getting to the new one.

I doubt this is what you want, so you might have to scan the list
twice, looking for a specific match first, then again looking for
wildcard matches.

Bjorn

>        }
> -
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

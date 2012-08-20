Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab2HTURX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 16:17:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63713 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab2HTURU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 16:17:20 -0400
MIME-Version: 1.0
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D413805C42@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D413805C42@USINDEM103.corp.hds.com>
From: Mike Waychison <mikew@google.com>
Date: Mon, 20 Aug 2012 13:09:51 -0700
Message-ID: <CAGTjWtBXCWi+gHJHO+_CO7mbTaruS0E2NfDCYPEY4gW2hBK9aA@mail.gmail.com>
Subject: Re: [RFC][PATCH v2 2/3] efi_pstore: Introducing workqueue updating
 sysfs entries
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 12:15 PM, Seiji Aguchi <seiji.aguchi@hds.com> wrote:
> [Problem]
>   efi_pstore creates sysfs entries ,which enable users to access to NVRAM,
>   in a write callback. If a kernel panic happens in interrupt contexts, pstore may
>   fail because it could sleep due to dynamic memory allocations during creating sysfs entries.
>
> [Patch Description]
>  This patch removes sysfs operations from write callback by introducing a workqueue
>  updating sysfs entries which is scheduled after a write callback of efi_pstore is called.
>  efi_pstore will be robust against a kernel panic in an interrupt context with it.
>
> Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
> ---
>  drivers/firmware/efivars.c |  111 +++++++++++++++++++++++++++++++++++++++----
>  include/linux/efi.h        |    3 +-
>  2 files changed, 102 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
> index 25d6d35..8717ea9 100644
> --- a/drivers/firmware/efivars.c
> +++ b/drivers/firmware/efivars.c
> @@ -146,6 +146,13 @@ efivar_create_sysfs_entry(struct efivars *efivars,
>                           efi_char16_t *variable_name,
>                           efi_guid_t *vendor_guid);
>
> +/*
> + * Prototype for workqueue functions updating sysfs entry
> + */
> +
> +static void efivar_update_sysfs_entry(struct work_struct *);
> +static DECLARE_WORK(efivar_work, efivar_update_sysfs_entry);
> +
>  /* Return the number of unicode characters in data */
>  static unsigned long
>  utf16_strnlen(efi_char16_t *s, size_t maxlength)
> @@ -732,9 +739,6 @@ static int efi_pstore_write(enum pstore_type_id type,
>                                            0, NULL);
>         }
>
> -       if (found)
> -               list_del(&found->list);
> -
>         for (i = 0; i < DUMP_NAME_LEN; i++)
>                 efi_name[i] = name[i];
>
> @@ -743,14 +747,7 @@ static int efi_pstore_write(enum pstore_type_id type,
>
>         spin_unlock_irqrestore(&efivars->lock, flags);
>
> -       if (found)
> -               efivar_unregister(found);
> -
> -       if (size)
> -               ret = efivar_create_sysfs_entry(efivars,
> -                                         utf16_strsize(efi_name,
> -                                                       DUMP_NAME_LEN * 2),
> -                                         efi_name, &vendor);
> +       schedule_work(&efivar_work);
>
>         *id = part;
>         return ret;
> @@ -1204,6 +1201,97 @@ EXPORT_SYMBOL_GPL(register_efivars);
>  static struct efivars __efivars;
>  static struct efivar_operations ops;
>
> +static void delete_sysfs_entry(void)
> +{
> +       struct efivars *efivars = &__efivars;
> +       struct efivar_entry *entry, *n;
> +       efi_status_t status;
> +       unsigned long flags;
> +
> +       list_for_each_entry_safe(entry, n, &efivars->list, list) {

This ->lock here is protecting this list, so it isn't correct to grab
the lock within iteration.  The lock should instead be grabbed before
iterating through the list, dropped if we need to unregister and
iteration should restart completely if the lock was dropped.

> +               spin_lock_irqsave(&efivars->lock, flags);
> +               status = get_var_data_locked(efivars, &entry->var);
> +               if (status != EFI_SUCCESS) {
> +                       list_del(&entry->list);
> +                       spin_unlock_irqrestore(&efivars->lock, flags);
> +                       efivar_unregister(entry);
> +               } else
> +                       spin_unlock_irqrestore(&efivars->lock, flags);
> +       }
> +}
> +
> +static bool variable_is_present(efi_char16_t *variable_name, efi_guid_t *vendor)
> +{
> +       struct efivar_entry *entry, *n;
> +       struct efivars *efivars = &__efivars;
> +       unsigned long strsize1, strsize2;
> +       bool found = false;
> +
> +       strsize1 = utf16_strsize(variable_name, 1024);
> +       list_for_each_entry_safe(entry, n, &efivars->list, list) {
> +               strsize2 = utf16_strsize(entry->var.VariableName, 1024);
> +               if (strsize1 == strsize2 &&
> +                       !memcmp(variable_name, &(entry->var.VariableName),
> +                               strsize2) &&
> +                       !efi_guidcmp(entry->var.VendorGuid,
> +                               *vendor)) {
> +                       found = true;
> +                       break;
> +               }
> +       }
> +       return found;
> +}
> +
> +static void efivar_update_sysfs_entry(struct work_struct *work)
> +{
> +       struct efivars *efivars = &__efivars;
> +       efi_guid_t vendor;
> +       efi_char16_t *variable_name;
> +       unsigned long variable_name_size = 1024, flags;
> +       efi_status_t status = EFI_NOT_FOUND;
> +       bool found;
> +
> +       /* Delete unavailable sysfs entries */
> +       delete_sysfs_entry();

This method needs a better name that reflects what it is doing.
delete_all_stale_sysfs_entries ?

> +
> +       /* Add new sysfs entries */
> +       while (1) {
> +               variable_name = kzalloc(variable_name_size, GFP_KERNEL);
> +               if (!variable_name) {
> +                       pr_err("efivars: Memory allocation failed.\n");
> +                       return;
> +               }
> +
> +               spin_lock_irqsave(&efivars->lock, flags);
> +               found = false;
> +               while (1) {
> +                       variable_name_size = 1024;
> +                       status = efivars->ops->get_next_variable(
> +                                                       &variable_name_size,
> +                                                       variable_name,
> +                                                       &vendor);
> +                       if (status != EFI_SUCCESS) {
> +                               break;
> +                       } else {
> +                               if (!variable_is_present(variable_name,
> +                                   &vendor)) {
> +                                       found = true;
> +                                       break;
> +                               }
> +                       }
> +               }
> +               spin_unlock_irqrestore(&efivars->lock, flags);
> +
> +               if (!found) {
> +                       kfree(variable_name);
> +                       break;
> +               } else
> +                       efivar_create_sysfs_entry(efivars,
> +                                                 variable_name_size,
> +                                                 variable_name, &vendor);
> +       }
> +}
> +
>  /*
>   * For now we register the efi subsystem with the firmware subsystem
>   * and the vars subsystem with the efi subsystem.  In the future, it
> @@ -1259,6 +1347,7 @@ static void __exit
>  efivars_exit(void)
>  {
>         if (efi_enabled) {
> +               cancel_work_sync(&efivar_work);
>                 unregister_efivars(&__efivars);
>                 kobject_put(efi_kobj);
>         }
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 103adc6..cecdf58 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -641,7 +641,8 @@ struct efivars {
>          * 1) ->list - adds, removals, reads, writes
>          * 2) ops.[gs]et_variable() calls.
>          * It must not be held when creating sysfs entries or calling kmalloc.
> -        * ops.get_next_variable() is only called from register_efivars(),
> +        * ops.get_next_variable() is only called from register_efivars()
> +        * or efivar_update_sysfs_entry(),
>          * which is protected by the BKL, so that path is safe.
>          */
>         spinlock_t lock;
> -- 1.7.1

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932448Ab2HQUe0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 16:34:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56958 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411Ab2HQUeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 16:34:18 -0400
MIME-Version: 1.0
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D413800090@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D413800090@USINDEM103.corp.hds.com>
From: Mike Waychison <mikew@google.com>
Date: Fri, 17 Aug 2012 13:33:56 -0700
Message-ID: <CAGTjWtA-zE-UCsqC5H4VvLfz94J_5bjYzMwF5RaHLdr9O_MoRA@mail.gmail.com>
Subject: Re: [RFC][PATCH 2/2] efi_pstore: Introducing workqueue updating sysfs entries
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

On Fri, Aug 17, 2012 at 12:43 PM, Seiji Aguchi <seiji.aguchi@hds.com> wrote:
> [Problem]
>  efi_pstore creates sysfs entries ,which enable users to access to NVRAM,
>  in a write callback. If a kernel panic happens in interrupt contexts, pstore may
>  fail because it could sleep due to dynamic memory allocations during creating sysfs entries.
>
> [Patch Description]
>  This patch removes sysfs operations from write callback by introducing a workqueue
>  updating sysfs entries which is kicked after a write callback of efi_pstore is called.
>  efi_pstore will be robust against a kernel panic in an interrupt context with it.
>  The workqueue works as follows.
>
>  - A timer is registered during an initialization of efivars module.
>  - A flag, update_sysfs_entries, is checked periodically with the timer.
>  - The flag is set in a write callback, efi_pstore_write().
>  - Operation updating sysfs entries is kicked if the flag is set.
>
>  Any operations ,like registering a timer, should not be added in a write callback because it may run
>  in panic case and fail due to operations related to workqueue.

I'm not a fan of creating a periodic timer that wakes up here to check
for an event that should be considered very rare.

Can this just become scheduled work?  Scheduling work itself is a very
lightweight process and should be relatively safe to do from a pstore
write.

>
>  To make efi_pstore work in panic case, a write callback should just log to NVRAM.
>
> Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
> ---
>  drivers/firmware/efivars.c |  127 ++++++++++++++++++++++++++++++++++++++++----
>  include/linux/efi.h        |    3 +-
>  2 files changed, 118 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
> index b6a813e..9f27ef6 100644
> --- a/drivers/firmware/efivars.c
> +++ b/drivers/firmware/efivars.c
> @@ -146,6 +146,17 @@ efivar_create_sysfs_entry(struct efivars *efivars,
>                           efi_char16_t *variable_name,
>                           efi_guid_t *vendor_guid);
>
> +/*
> + * Prototype for workqueue functions updating sysfs entry
> + */
> +
> +static void efivar_update_sysfs_entry(struct work_struct *);
> +#define EFIVAR_INTERVAL (60 * HZ)
> +static void efivar_timefunc(unsigned long);
> +static DEFINE_TIMER(efivar_timer, efivar_timefunc, 0, 0);
> +static DECLARE_WORK(efivar_work, efivar_update_sysfs_entry);
> +static int update_sysfs_entries;
> +
>  /* Return the number of unicode characters in data */
>  static unsigned long
>  utf16_strnlen(efi_char16_t *s, size_t maxlength)
> @@ -739,9 +750,6 @@ static int efi_pstore_write(enum pstore_type_id type,
>                                            0, NULL);
>         }
>
> -       if (found)
> -               list_del(&found->list);
> -
>         for (i = 0; i < DUMP_NAME_LEN; i++)
>                 efi_name[i] = name[i];
>
> @@ -750,14 +758,7 @@ static int efi_pstore_write(enum pstore_type_id type,
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
> +       update_sysfs_entries = 1;
>
>         *id = part;
>         return ret;
> @@ -1201,6 +1202,8 @@ int register_efivars(struct efivars *efivars,
>                 pstore_register(&efivars->efi_pstore_info);
>         }
>
> +       add_timer(&efivar_timer);
> +
>  out:
>         kfree(variable_name);
>
> @@ -1211,6 +1214,107 @@ EXPORT_SYMBOL_GPL(register_efivars);
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
> +static void efivar_timefunc(unsigned long dummy)
> +{
> +       if (update_sysfs_entries) {
> +               update_sysfs_entries = 0;
> +               schedule_work(&efivar_work);
> +       }
> +
> +       mod_timer(&efivar_timer, jiffies + EFIVAR_INTERVAL);
> +}
> +
>  /*
>   * For now we register the efi subsystem with the firmware subsystem
>   * and the vars subsystem with the efi subsystem.  In the future, it
> @@ -1266,6 +1370,7 @@ static void __exit
>  efivars_exit(void)
>  {
>         if (efi_enabled) {
> +               del_timer_sync(&efivar_timer);
>                 unregister_efivars(&__efivars);
>                 kobject_put(efi_kobj);
>         }
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index f1f5703..3e0c37a 100644
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

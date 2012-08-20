Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab2HTUUa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 16:20:30 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37277 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821Ab2HTUUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 16:20:24 -0400
MIME-Version: 1.0
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D413805C50@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D413805C50@USINDEM103.corp.hds.com>
From: Mike Waychison <mikew@google.com>
Date: Mon, 20 Aug 2012 13:13:29 -0700
Message-ID: <CAGTjWtBN0Ai_H0u6ACVbTCKgRXJU7Ln9nhjeb9wdOFQ0GQpP3w@mail.gmail.com>
Subject: Re: [RFC][PATCH v2 3/3] efi_pstore: Skip scheduling a workqueue in
 cases other than oops
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
> efi_pstore creates sysfs files when logging kernel messages to NVRAM.
> Currently, the sysfs files are updated in a workqueue which is registered in a write callback.
>
> On the other hand, a situation which users need the sysfs files is just oops case because a system will
> be down and they can't access to sysfs files in other cases like panic, reboot or emergency_restart.
>
> Also, if kernel panics due to a bug of workqueue operations and a write callback of efi_pstore is called in
> panic case, efi_pstore may fail due to a failure of schedule_work().
> And panic_notifier_chain()/emergency_restart() is not kicked if efi_pstore fails.
> This may cause user's unwanted result.
>
> [Patch Description]
> This patch skips a registration of a workqueue in a write callback in cases other than oops.
>
> Also, a logic of erase callback is freshly created instead of sharing with a write callback because the sysfs
> operation is kicked in just oops case in a write callback and an erase callback doesn't work without any change.
> By separating a logic to a write callback, an erase callback works correctly.

I don't understand why this part of the patch is required.

>
> Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
> ---
>  drivers/firmware/efivars.c |   53 ++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 51 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
> index 8717ea9..4811abb 100644
> --- a/drivers/firmware/efivars.c
> +++ b/drivers/firmware/efivars.c
> @@ -747,7 +747,11 @@ static int efi_pstore_write(enum pstore_type_id type,
>
>         spin_unlock_irqrestore(&efivars->lock, flags);
>
> -       schedule_work(&efivar_work);
> +       /*
> +        * The user may want to see an entry for this write in sysfs.
> +        */
> +       if (reason == KMSG_DUMP_OOPS)
> +               schedule_work(&efivar_work);
>
>         *id = part;
>         return ret;
> @@ -756,7 +760,52 @@ static int efi_pstore_write(enum pstore_type_id type,
>  static int efi_pstore_erase(enum pstore_type_id type, u64 id,
>                             struct pstore_info *psi)
>  {
> -       efi_pstore_write(type, 0, &id, (unsigned int)id, 0, psi);
> +       char stub_name[DUMP_NAME_LEN];
> +       efi_char16_t efi_name[DUMP_NAME_LEN];
> +       efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
> +       struct efivars *efivars = psi->data;
> +       struct efivar_entry *entry, *found = NULL;
> +       int i;
> +       unsigned long flags;
> +
> +       sprintf(stub_name, "dump-type%u-%llu-", type, id);
> +
> +       spin_lock_irqsave(&efivars->lock, flags);
> +
> +       for (i = 0; i < DUMP_NAME_LEN; i++)
> +               efi_name[i] = stub_name[i];
> +
> +       /*
> +        * Clean up any entries with the same name
> +        */
> +
> +       list_for_each_entry(entry, &efivars->list, list) {
> +               get_var_data_locked(efivars, &entry->var);
> +
> +               if (efi_guidcmp(entry->var.VendorGuid, vendor))
> +                       continue;
> +               if (utf16_strncmp(entry->var.VariableName, efi_name,
> +                                 utf16_strlen(efi_name)))
> +                       continue;
> +               /* Needs to be a prefix */
> +               if (entry->var.VariableName[utf16_strlen(efi_name)] == 0)
> +                       continue;
> +
> +               /* found */
> +               found = entry;
> +               efivars->ops->set_variable(entry->var.VariableName,
> +                                          &entry->var.VendorGuid,
> +                                          PSTORE_EFI_ATTRIBUTES,
> +                                          0, NULL);
> +       }
> +
> +       if (found)
> +               list_del(&found->list);
> +
> +       spin_unlock_irqrestore(&efivars->lock, flags);
> +
> +       if (found)
> +               efivar_unregister(found);
>
>         return 0;
>  }
> -- 1.7.1

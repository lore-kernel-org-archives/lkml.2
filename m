Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030188Ab2JRXmO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 19:42:14 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58522 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757115Ab2JRXmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 19:42:10 -0400
MIME-Version: 1.0
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D41386D119@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D41386D119@USINDEM103.corp.hds.com>
From: Mike Waychison <mikew@google.com>
Date: Thu, 18 Oct 2012 16:41:49 -0700
Message-ID: <CAGTjWtDgrDGN-+yCqfFsfaA8Xjbhj8nherA+puoGVRs-8vXO5g@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/2] efi_pstore: hold multiple logs
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
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

Resending as text.  See below.

On Fri, Oct 5, 2012 at 12:01 PM, Seiji Aguchi <seiji.aguchi@hds.com> wrote:
> [Problem]
>
>   Currently, efi_pstore driver simply overwrites existing panic messages in NVRAM.
>   So, in the following scenario, we will lose 1st panic messages.
>
>     1. kernel panics.
>     2. efi_pstore is kicked and write panic messages to NVRAM.
>     3. system reboots.
>     4. kernel panics again before a user checks the 1st panic messages in NVRAM.
>
> [Solution]
>
>   This patch takes an approach just holding multiple logs to avoid overwriting existing
>   entries.
>
> [Patch Description]
>
>   This patch changes write/erase/read callbacks as follows.
>
>   - Write callback
>     - Check if there are enough spaces to write logs with QueryVariableInfo()
>       to avoid handling out of space situation. (It is suggested by Matthew Garrett.)
>

I would prefer to see the exposing query_variable_info callback as a
separate patch.  The check in the patch looks good.

>     - Remove a logic erasing existing entries.
>
>   - Erase callback
>     - Freshly create a logic rather than sharing it with a write callback because
>       erasing entries doesn't need in a write callback.
>

This sort of change is a lot easier to review if you copy and paste
the routine in a patch separate from this one.

>     - Add ctime to an argument.
>       Currently, a variable name, which is used to distinguish each log entry, consists of type,
>       id and ctime. But an erase callback does not use ctime.

I do not like the way this is plumbed. See below.

>
>       If efi_pstore supported just one log, type and id were enough.
>
>       On the other hand, in case of supporting multiple logs, ctime is needed to precisely
>       distinguish each entry at erasing time.
>       Therefore this patch adds ctime to an argument of an erase callback is needed.
>
>    - Read callback
>     - Add ctime to an argument.
>        This change is needed to identify the entry at reading time.
>
>   <Example>
>
>  As you can see below, we can distinguish first and second events with ctime.
>
>  a variable name of first event: dump-type0-1-12345678
>  a variable name of second event: dump-type0-1-23456789
>
>   type:0
>   id:1
>   ctime:12345678, 23456789
>
> Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
> ---
>  drivers/acpi/apei/erst.c   |    4 +-
>  drivers/firmware/efivars.c |   87 ++++++++++++++++++++++++++++----------------
>  fs/pstore/inode.c          |    3 +-
>  fs/pstore/ram.c            |    2 +-
>  include/linux/efi.h        |    1 +
>  include/linux/pstore.h     |    2 +-
>  6 files changed, 63 insertions(+), 36 deletions(-)
>
> diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
> index e4d9d24..0bd6ae4 100644
> --- a/drivers/acpi/apei/erst.c
> +++ b/drivers/acpi/apei/erst.c
> @@ -938,7 +938,7 @@ static int erst_writer(enum pstore_type_id type, enum kmsg_dump_reason reason,
>                        u64 *id, unsigned int part,
>                        size_t size, struct pstore_info *psi);
>  static int erst_clearer(enum pstore_type_id type, u64 id,
> -                       struct pstore_info *psi);
> +                       struct timespec time, struct pstore_info *psi);
>
>  static struct pstore_info erst_info = {
>         .owner          = THIS_MODULE,
> @@ -1102,7 +1102,7 @@ static int erst_writer(enum pstore_type_id type, enum kmsg_dump_reason reason,
>  }
>
>  static int erst_clearer(enum pstore_type_id type, u64 id,
> -                       struct pstore_info *psi)
> +                       struct timespec time, struct pstore_info *psi)
>  {
>         return erst_clear(id);
>  }
> diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
> index d10c987..0eaaba3 100644
> --- a/drivers/firmware/efivars.c
> +++ b/drivers/firmware/efivars.c
> @@ -701,23 +701,70 @@ static int efi_pstore_write(enum pstore_type_id type,
>                 unsigned int part, size_t size, struct pstore_info *psi)
>  {
>         char name[DUMP_NAME_LEN];
> -       char stub_name[DUMP_NAME_LEN];
>         efi_char16_t efi_name[DUMP_NAME_LEN];
>         efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
>         struct efivars *efivars = psi->data;
> -       struct efivar_entry *entry, *found = NULL;
>         int i, ret = 0;
> +       u64 storage_space, remaining_space, max_variable_size;
> +       efi_status_t status = EFI_NOT_FOUND;
> +
> +       spin_lock(&efivars->lock);
> +
> +       /*
> +        * Check if there is a space enough to log.
> +        * size: a size of logging data
> +        * DUMP_NAME_LEN * 2: a maximum size of variable name
> +        *

extra line

> +        */
> +       status = efivars->ops->query_variable_info(PSTORE_EFI_ATTRIBUTES,
> +                                                  &storage_space,
> +                                                  &remaining_space,
> +                                                  &max_variable_size);
> +       if (status || remaining_space < size + DUMP_NAME_LEN * 2) {
> +               spin_unlock(&efivars->lock);
> +               *id = part;
> +               return -ENOSPC;
> +       }
> +
> +       sprintf(name, "dump-type%u-%u-%lu", type, part, get_seconds());
> +
> +       for (i = 0; i < DUMP_NAME_LEN; i++)
> +               efi_name[i] = name[i];
> +
> +       efivars->ops->set_variable(efi_name, &vendor, PSTORE_EFI_ATTRIBUTES,
> +                                  size, psi->buf);
> +
> +       spin_unlock(&efivars->lock);
> +
> +       if (size)
> +               ret = efivar_create_sysfs_entry(efivars,
> +                                         utf16_strsize(efi_name,
> +                                                       DUMP_NAME_LEN * 2),
> +                                         efi_name, &vendor);

What is happening here?  Why is size checked for non-zero?

> +
> +       *id = part;
> +       return ret;
> +};
> +
> +static int efi_pstore_erase(enum pstore_type_id type, u64 id,
> +                           struct timespec time, struct pstore_info *psi)
> +{
> +       char name[DUMP_NAME_LEN];
> +       efi_char16_t efi_name[DUMP_NAME_LEN];
> +       efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
> +       struct efivars *efivars = psi->data;
> +       struct efivar_entry *entry, *found = NULL;
> +       int i;
>
> -       sprintf(stub_name, "dump-type%u-%u-", type, part);
> -       sprintf(name, "%s%lu", stub_name, get_seconds());
> +       sprintf(name, "dump-type%u-%llu-%lu", type, id, time.tv_sec);
>
>         spin_lock(&efivars->lock);
>
>         for (i = 0; i < DUMP_NAME_LEN; i++)
> -               efi_name[i] = stub_name[i];
> +               efi_name[i] = name[i];
>
>         /*
> -        * Clean up any entries with the same name
> +        * Clean up an entry with the same name
>          */
>
>         list_for_each_entry(entry, &efivars->list, list) {
> @@ -728,9 +775,6 @@ static int efi_pstore_write(enum pstore_type_id type,
>                 if (utf16_strncmp(entry->var.VariableName, efi_name,
>                                   utf16_strlen(efi_name)))
>                         continue;
> -               /* Needs to be a prefix */
> -               if (entry->var.VariableName[utf16_strlen(efi_name)] == 0)
> -                       continue;
>
>                 /* found */
>                 found = entry;
> @@ -738,37 +782,17 @@ static int efi_pstore_write(enum pstore_type_id type,
>                                            &entry->var.VendorGuid,
>                                            PSTORE_EFI_ATTRIBUTES,
>                                            0, NULL);
> +               break;
>         }
>
>         if (found)
>                 list_del(&found->list);
>
> -       for (i = 0; i < DUMP_NAME_LEN; i++)
> -               efi_name[i] = name[i];
> -
> -       efivars->ops->set_variable(efi_name, &vendor, PSTORE_EFI_ATTRIBUTES,
> -                                  size, psi->buf);
> -
>         spin_unlock(&efivars->lock);
>
>         if (found)
>                 efivar_unregister(found);
>
> -       if (size)
> -               ret = efivar_create_sysfs_entry(efivars,
> -                                         utf16_strsize(efi_name,
> -                                                       DUMP_NAME_LEN * 2),
> -                                         efi_name, &vendor);
> -
> -       *id = part;
> -       return ret;
> -};
> -
> -static int efi_pstore_erase(enum pstore_type_id type, u64 id,
> -                           struct pstore_info *psi)
> -{
> -       efi_pstore_write(type, 0, &id, (unsigned int)id, 0, psi);
> -
>         return 0;
>  }
>  #else
> @@ -797,7 +821,7 @@ static int efi_pstore_write(enum pstore_type_id type,
>  }
>
>  static int efi_pstore_erase(enum pstore_type_id type, u64 id,
> -                           struct pstore_info *psi)
> +                           struct timespec time, struct pstore_info *psi)
>  {
>         return 0;
>  }
> @@ -1237,6 +1261,7 @@ efivars_init(void)
>         ops.get_variable = efi.get_variable;
>         ops.set_variable = efi.set_variable;
>         ops.get_next_variable = efi.get_next_variable;
> +       ops.query_variable_info = efi.query_variable_info;
>         error = register_efivars(&__efivars, &ops, efi_kobj);
>         if (error)
>                 goto err_put;
> diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
> index 4ab572e..4300af6 100644
> --- a/fs/pstore/inode.c
> +++ b/fs/pstore/inode.c
> @@ -175,7 +175,8 @@ static int pstore_unlink(struct inode *dir, struct dentry *dentry)
>         struct pstore_private *p = dentry->d_inode->i_private;
>
>         if (p->psi->erase)
> -               p->psi->erase(p->type, p->id, p->psi);
> +               p->psi->erase(p->type, p->id, dentry->d_inode->i_ctime,
> +                             p->psi);

This doesn't look right.  What guarantees that the i_ctime means
anything across reboots?

>
>         return simple_unlink(dir, dentry);
>  }
> diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
> index 0b311bc..177b281 100644
> --- a/fs/pstore/ram.c
> +++ b/fs/pstore/ram.c
> @@ -237,7 +237,7 @@ static int ramoops_pstore_write_buf(enum pstore_type_id type,
>  }
>
>  static int ramoops_pstore_erase(enum pstore_type_id type, u64 id,
> -                               struct pstore_info *psi)
> +                               timespec time, struct pstore_info *psi)
>  {
>         struct ramoops_context *cxt = psi->data;
>         struct persistent_ram_zone *prz;
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 8670eb1..c47ec36 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -643,6 +643,7 @@ struct efivar_operations {
>         efi_get_variable_t *get_variable;
>         efi_get_next_variable_t *get_next_variable;
>         efi_set_variable_t *set_variable;
> +       efi_query_variable_info_t *query_variable_info;
>  };
>
>  struct efivars {
> diff --git a/include/linux/pstore.h b/include/linux/pstore.h
> index c892587..71f43e0 100644
> --- a/include/linux/pstore.h
> +++ b/include/linux/pstore.h
> @@ -60,7 +60,7 @@ struct pstore_info {
>                         unsigned int part, const char *buf, size_t size,
>                         struct pstore_info *psi);
>         int             (*erase)(enum pstore_type_id type, u64 id,
> -                       struct pstore_info *psi);
> +                       struct timespec time, struct pstore_info *psi);
>         void            *data;
>  };
>
> -- 1.7.1

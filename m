Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173Ab1LNWOv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 17:14:51 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:37478 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755547Ab1LNWOu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 17:14:50 -0500
MIME-Version: 1.0
In-Reply-To: <1323896791-10858-4-git-send-email-mjg@redhat.com>
References: <1323896791-10858-1-git-send-email-mjg@redhat.com> <1323896791-10858-4-git-send-email-mjg@redhat.com>
From: Mike Waychison <mikew@google.com>
Date: Wed, 14 Dec 2011 14:14:27 -0800
Message-ID: <CAGTjWtCpt_1h6XMwCFkx1TQnQbagtSuFBejcp6XNr4yhKgNuLg@mail.gmail.com>
Subject: Re: [PATCH 3/4] EFI: Add support for variables longer than 1024 bytes
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 1:06 PM, Matthew Garrett <mjg@redhat.com> wrote:
> The EFI variables code has a hard limit of 1024 bytes for variable length.
> This restriction only existed in version 0.99 of the EFI specification,
> and is not relevant on any existing hardware. Add support for a longer
> structure that incorporates the existing one, allowing old userspace to
> carry on working while allowing newer userspace to write larger variables
> via the same interface.
>
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> ---
>  drivers/firmware/efivars.c |  240 ++++++++++++++++++++++++++++----------------
>  1 files changed, 154 insertions(+), 86 deletions(-)
>
> diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
> index eb07f13..1bef80c 100644
> --- a/drivers/firmware/efivars.c
> +++ b/drivers/firmware/efivars.c
> @@ -92,13 +92,6 @@ MODULE_VERSION(EFIVARS_VERSION);
>
>  #define DUMP_NAME_LEN 52
>
> -/*
> - * The maximum size of VariableName + Data = 1024
> - * Therefore, it's reasonable to save that much
> - * space in each part of the structure,
> - * and we use a page for reading/writing.
> - */
> -
>  struct efi_variable {
>        efi_char16_t  VariableName[1024/sizeof(efi_char16_t)];
>        efi_guid_t    VendorGuid;
> @@ -108,10 +101,20 @@ struct efi_variable {
>        __u32         Attributes;
>  } __attribute__((packed));
>
> +/*
> + * Older versions of this driver had a fixed 1024-byte buffer. We need to
> + * maintain compatibility with old userspace, so we provide an extended
> + * structure to allow userspace to write larger variables
> + */
> +
> +struct extended_efi_variable {
> +       struct efi_variable header;
> +       __u8 Data[0];
> +} __attribute__((packed));
>
>  struct efivar_entry {
>        struct efivars *efivars;
> -       struct efi_variable var;
> +       struct extended_efi_variable *var;
>        struct list_head list;
>        struct kobject kobj;
>  };
> @@ -192,21 +195,41 @@ utf16_strncmp(const efi_char16_t *a, const efi_char16_t *b, size_t len)
>  }
>
>  static efi_status_t
> -get_var_data_locked(struct efivars *efivars, struct efi_variable *var)
> +get_var_data_locked(struct efivars *efivars, struct extended_efi_variable **var)
>  {
>        efi_status_t status;
> +       unsigned long length;
> +
> +       if (!*var)
> +               *var = kmalloc(sizeof(struct extended_efi_variable), GFP_KERNEL);

Aren't we holding a spinlock here?

> +
> +       (*var)->header.DataSize = 0;
> +       status = efivars->ops->get_variable((*var)->header.VariableName,
> +                                           &(*var)->header.VendorGuid,
> +                                           &(*var)->header.Attributes,
> +                                           &(*var)->header.DataSize,
> +                                           (*var)->Data);

This doesn't look right.  ->Data here is after the Data[1024] buffer
embedded in (*var)->header, and a read into this buffer will corrupt
the heap.

> +
> +       if (status == EFI_BUFFER_TOO_SMALL) {
> +               *var = krealloc(*var, sizeof(struct extended_efi_variable) +
> +                               (*var)->header.DataSize, GFP_KERNEL);
> +               status = efivars->ops->get_variable((*var)->header.VariableName,
> +                                                   &(*var)->header.VendorGuid,
> +                                                   &(*var)->header.Attributes,
> +                                                   &(*var)->header.DataSize,
> +                                                   (*var)->Data);
> +       }
> +
> +       length = ((*var)->header.DataSize < 1024) ? (*var)->header.DataSize :
> +               1024;
> +
> +       memcpy(&(*var)->header.Data, &(*var)->Data, length);

This memcpy clobbers the header.Data with the corrupted data when we
didn't use the second path.

>
> -       var->DataSize = 1024;
> -       status = efivars->ops->get_variable(var->VariableName,
> -                                           &var->VendorGuid,
> -                                           &var->Attributes,
> -                                           &var->DataSize,
> -                                           var->Data);
>        return status;
>  }
>
>  static efi_status_t
> -get_var_data(struct efivars *efivars, struct efi_variable *var)
> +get_var_data(struct efivars *efivars, struct extended_efi_variable **var)
>  {
>        efi_status_t status;
>
> @@ -224,13 +247,13 @@ get_var_data(struct efivars *efivars, struct efi_variable *var)
>  static ssize_t
>  efivar_guid_read(struct efivar_entry *entry, char *buf)
>  {
> -       struct efi_variable *var = &entry->var;
> +       struct extended_efi_variable *var = entry->var;
>        char *str = buf;
>
>        if (!entry || !buf)
>                return 0;
>
> -       efi_guid_unparse(&var->VendorGuid, str);
> +       efi_guid_unparse(&var->header.VendorGuid, str);
>        str += strlen(str);
>        str += sprintf(str, "\n");
>
> @@ -240,22 +263,22 @@ efivar_guid_read(struct efivar_entry *entry, char *buf)
>  static ssize_t
>  efivar_attr_read(struct efivar_entry *entry, char *buf)
>  {
> -       struct efi_variable *var = &entry->var;
> +       struct extended_efi_variable *var = entry->var;
>        char *str = buf;
>        efi_status_t status;
>
>        if (!entry || !buf)
>                return -EINVAL;
>
> -       status = get_var_data(entry->efivars, var);
> +       status = get_var_data(entry->efivars, &var);
>        if (status != EFI_SUCCESS)
>                return -EIO;
>
> -       if (var->Attributes & 0x1)
> +       if (var->header.Attributes & 0x1)
>                str += sprintf(str, "EFI_VARIABLE_NON_VOLATILE\n");
> -       if (var->Attributes & 0x2)
> +       if (var->header.Attributes & 0x2)
>                str += sprintf(str, "EFI_VARIABLE_BOOTSERVICE_ACCESS\n");
> -       if (var->Attributes & 0x4)
> +       if (var->header.Attributes & 0x4)
>                str += sprintf(str, "EFI_VARIABLE_RUNTIME_ACCESS\n");
>        return str - buf;
>  }
> @@ -263,36 +286,36 @@ efivar_attr_read(struct efivar_entry *entry, char *buf)
>  static ssize_t
>  efivar_size_read(struct efivar_entry *entry, char *buf)
>  {
> -       struct efi_variable *var = &entry->var;
> +       struct extended_efi_variable *var = entry->var;
>        char *str = buf;
>        efi_status_t status;
>
>        if (!entry || !buf)
>                return -EINVAL;
>
> -       status = get_var_data(entry->efivars, var);
> +       status = get_var_data(entry->efivars, &var);
>        if (status != EFI_SUCCESS)
>                return -EIO;
>
> -       str += sprintf(str, "0x%lx\n", var->DataSize);
> +       str += sprintf(str, "0x%lx\n", var->header.DataSize);
>        return str - buf;
>  }
>
>  static ssize_t
>  efivar_data_read(struct efivar_entry *entry, char *buf)
>  {
> -       struct efi_variable *var = &entry->var;
> +       struct extended_efi_variable *var = entry->var;
>        efi_status_t status;
>
>        if (!entry || !buf)
>                return -EINVAL;
>
> -       status = get_var_data(entry->efivars, var);
> +       status = get_var_data(entry->efivars, &var);
>        if (status != EFI_SUCCESS)
>                return -EIO;
>
> -       memcpy(buf, var->Data, var->DataSize);
> -       return var->DataSize;
> +       memcpy(buf, var->Data, var->header.DataSize);
> +       return var->header.DataSize;
>  }
>  /*
>  * We allow each variable to be edited via rewriting the
> @@ -301,34 +324,46 @@ efivar_data_read(struct efivar_entry *entry, char *buf)
>  static ssize_t
>  efivar_store_raw(struct efivar_entry *entry, const char *buf, size_t count)
>  {
> -       struct efi_variable *new_var, *var = &entry->var;
> +       struct extended_efi_variable *new_var, *var = entry->var;
> +       struct efi_variable *tmp_var = NULL;
>        struct efivars *efivars = entry->efivars;
>        efi_status_t status = EFI_NOT_FOUND;
> +       int error = 0;
>
> -       if (count != sizeof(struct efi_variable))
> +       if (count == sizeof(struct efi_variable)) {
> +               tmp_var = (struct efi_variable *)buf;
> +               new_var = kmalloc(sizeof(struct efi_variable) +
> +                                 tmp_var->DataSize, GFP_KERNEL);
> +               memcpy(&new_var->header, tmp_var, sizeof(struct efi_variable));
> +               memcpy(&new_var->Data, tmp_var->Data, tmp_var->DataSize);
> +       } else if (count > sizeof(struct efi_variable)) {
> +               new_var = (struct extended_efi_variable *)buf;
> +       } else {
>                return -EINVAL;
> +       }

Ugh.  This is difficult to follow, and complicates the memory freeing path :(

We need to be careful here.  The store_raw ABI is broken, in the sense
that the ABI from compat mode differs from that in 32bit mode (there
is a long in the efi_variable structure which changes the offsets).  I
don't know how to fix it properly and still maintain proper ABI
compatibility.

What are your thoughts on _not_ wrapping efi_variable with
extended_efi_variable, and instead just using a
"internal_efi_variable" structure that we copy stuff into/outof.  I
think that would make the memory management for dealing with the
different sizes a lot easier to follow.

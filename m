Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760115Ab2JYS4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 14:56:37 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62883 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760082Ab2JYS4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 14:56:34 -0400
MIME-Version: 1.0
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D41388897F@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D41388897F@USINDEM103.corp.hds.com>
From: Mike Waychison <mikew@google.com>
Date: Thu, 25 Oct 2012 11:56:13 -0700
Message-ID: <CAGTjWtDMB6GXStq2uGc486hrjYoLejxd3TEWV0AX2BrK0GOnTA@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] efi_pstore: Check remaining space with
 QueryVariableInfo() before writing data
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
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

Acked-by: Mike Waychison <mikew@google.com>

On Wed, Oct 24, 2012 at 6:51 PM, Seiji Aguchi <seiji.aguchi@hds.com> wrote:
> [Issue]
>
> As discussed in a thread below, Running out of space in EFI isn't a well-tested scenario.
> And we wouldn't expect all firmware to handle it gracefully.
> http://marc.info/?l=linux-kernel&m=134305325801789&w=2
>
> On the other hand, current efi_pstore doesn't check a remaining space of storage at writing time.
> Therefore, efi_pstore may not work if it tries to write a large amount of data.
>
> [Patch Description]
>
> To avoid handling the situation above, this patch checks if there is a space enough to log with
> QueryVariableInfo() before writing data.
>
> Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
> ---
>  drivers/firmware/efivars.c |   18 ++++++++++++++++++
>  include/linux/efi.h        |    1 +
>  2 files changed, 19 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
> index d10c987..37ac21a 100644
> --- a/drivers/firmware/efivars.c
> +++ b/drivers/firmware/efivars.c
> @@ -707,12 +707,29 @@ static int efi_pstore_write(enum pstore_type_id type,
>         struct efivars *efivars = psi->data;
>         struct efivar_entry *entry, *found = NULL;
>         int i, ret = 0;
> +       u64 storage_space, remaining_space, max_variable_size;
> +       efi_status_t status = EFI_NOT_FOUND;
>
>         sprintf(stub_name, "dump-type%u-%u-", type, part);
>         sprintf(name, "%s%lu", stub_name, get_seconds());
>
>         spin_lock(&efivars->lock);
>
> +       /*
> +        * Check if there is a space enough to log.
> +        * size: a size of logging data
> +        * DUMP_NAME_LEN * 2: a maximum size of variable name
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
>         for (i = 0; i < DUMP_NAME_LEN; i++)
>                 efi_name[i] = stub_name[i];
>
> @@ -1237,6 +1254,7 @@ efivars_init(void)
>         ops.get_variable = efi.get_variable;
>         ops.set_variable = efi.set_variable;
>         ops.get_next_variable = efi.get_next_variable;
> +       ops.query_variable_info = efi.query_variable_info;
>         error = register_efivars(&__efivars, &ops, efi_kobj);
>         if (error)
>                 goto err_put;
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
> -- 1.7.1

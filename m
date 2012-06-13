Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab2FMUZR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 16:25:17 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:33988 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab2FMUZP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 16:25:15 -0400
MIME-Version: 1.0
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2E5A4DB2B8@USINDEVS01.corp.hds.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2E5A4DB2B8@USINDEVS01.corp.hds.com>
From: Mike Waychison <mikew@google.com>
Date: Wed, 13 Jun 2012 13:24:54 -0700
Message-ID: <CAGTjWtAb3XrsTtkvW=G0YN1RCVxYxcPksSh3jEogeEu4qWqv1Q@mail.gmail.com>
Subject: Re: [RFC][Patch]efi_pstore:Introduce an efi_pstore_overwrite
 parameter to avoid missing messages in NVRAM
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "rob@landley.net" <rob@landley.net>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 6:42 AM, Seiji Aguchi <seiji.aguchi@hds.com> wrote:
>
>    Currently, efi_pstore driver simply overwrites existing panic messages in NVRAM.
>    So, in the following scenario, we will lose 1st panic messages.
>
>    1. kernel panics.
>    2. efi_pstore is kicked and writes panic messages to NVRAM.
>    3. system shutdowns and boots up.
>    4. kernel panics again before a user checks the 1st panic messages in NVRAM.
>
>
>    To avoid missing 1st panic messages, this patch adds a new parameter ,efi_pstore_overwrite,
>    to efi_pstore so that we can specify whether efi_pstore overwrites existing entries in NVRAM or not.
>
>
>  Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>


Acked-by: Mike Waychison <mikew@google.com>

>
> ---
>  Documentation/kernel-parameters.txt |    6 ++++
>  drivers/firmware/efivars.c          |   55 +++++++++++++++++++---------------
>  2 files changed, 37 insertions(+), 24 deletions(-)
>
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index a92c5eb..990befa 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -786,6 +786,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>        edd=            [EDD]
>                        Format: {"off" | "on" | "skip[mbr]"}
>
> +       efivars.efi_pstore_overwrite=
> +                       Specify whether efi_pstore overwrites existing entries
> +                       in NVRAM
> +                       Format: <bool>  (1/Y/y=yes, 0/N/n=no)
> +                       default: yes
> +
>        eisa_irq_edge=  [PARISC,HW]
>                        See header of drivers/parisc/eisa.c.
>
> diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c index 47408e8..94fbd1d 100644
> --- a/drivers/firmware/efivars.c
> +++ b/drivers/firmware/efivars.c
> @@ -685,6 +685,10 @@ static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
>        return 0;
>  }
>
> +static bool efi_pstore_overwrite = 1;
> +module_param_named(efi_pstore_overwrite, efi_pstore_overwrite,
> +                  bool, S_IRUGO | S_IWUSR);
> +
>  static int efi_pstore_write(enum pstore_type_id type,
>                enum kmsg_dump_reason reason, u64 *id,
>                unsigned int part, size_t size, struct pstore_info *psi) @@ -705,33 +709,36 @@ static int efi_pstore_write(enum pstore_type_id type,
>        for (i = 0; i < DUMP_NAME_LEN; i++)
>                efi_name[i] = stub_name[i];
>
> -       /*
> -        * Clean up any entries with the same name
> -        */
> +       if (efi_pstore_overwrite) {
> +               /*
> +                * Clean up any entries with the same name
> +                */
> +
> +               list_for_each_entry(entry, &efivars->list, list) {
> +                       get_var_data_locked(efivars, &entry->var);
> +
> +                       if (efi_guidcmp(entry->var.VendorGuid, vendor))
> +                               continue;
> +                       if (utf16_strncmp(entry->var.VariableName, efi_name,
> +                                         utf16_strlen(efi_name)))
> +                               continue;
> +                       /* Needs to be a prefix */
> +                       if (entry->var.VariableName[utf16_strlen(efi_name)]
> +                           == 0)
> +                               continue;
> +
> +                       /* found */
> +                       found = entry;
> +                       efivars->ops->set_variable(entry->var.VariableName,
> +                                                  &entry->var.VendorGuid,
> +                                                  PSTORE_EFI_ATTRIBUTES,
> +                                                  0, NULL);
> +               }
>
> -       list_for_each_entry(entry, &efivars->list, list) {
> -               get_var_data_locked(efivars, &entry->var);
> -
> -               if (efi_guidcmp(entry->var.VendorGuid, vendor))
> -                       continue;
> -               if (utf16_strncmp(entry->var.VariableName, efi_name,
> -                                 utf16_strlen(efi_name)))
> -                       continue;
> -               /* Needs to be a prefix */
> -               if (entry->var.VariableName[utf16_strlen(efi_name)] == 0)
> -                       continue;
> -
> -               /* found */
> -               found = entry;
> -               efivars->ops->set_variable(entry->var.VariableName,
> -                                          &entry->var.VendorGuid,
> -                                          PSTORE_EFI_ATTRIBUTES,
> -                                          0, NULL);
> +               if (found)
> +                       list_del(&found->list);
>        }
>
> -       if (found)
> -               list_del(&found->list);
> -
>        for (i = 0; i < DUMP_NAME_LEN; i++)
>                efi_name[i] = name[i];
>
> --
> 1.7.1

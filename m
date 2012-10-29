Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760745Ab2J2UNY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 16:13:24 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:36529 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756150Ab2J2UNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 16:13:19 -0400
MIME-Version: 1.0
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D41388F045@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D41388F045@USINDEM103.corp.hds.com>
From: Mike Waychison <mikew@google.com>
Date: Mon, 29 Oct 2012 13:12:58 -0700
Message-ID: <CAGTjWtDO=Z9y-7XxE5YdFzWsiT3MZ8Jhb4hgywYCQiG+NGcMKA@mail.gmail.com>
Subject: Re: [PATCH v3 6/7] efi_pstore: Add a format check for an existing
 variable name at reading time
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

On Fri, Oct 26, 2012 at 2:43 PM, Seiji Aguchi <seiji.aguchi@hds.com> wrote:
> [Issue]
>
> A format of variable name has been updated to type, id, count and ctime
> to support holding multiple logs.
>
> Format of current variable name
>   dump-type0-1-2-12345678
>
>   type:0
>   id:1
>   count:2
>   ctime:12345678
>
> On the other hand, if an old variable name before being updated
> remains, users can't read it via /dev/pstore.
>
> Format of old variable name
>   dump-type0-1-12345678
>
>   type:0
>   id:1
>   ctime:12345678
>
> [Solution]
>
> This patch adds a format check for the old variable name in a read callback
> to make it readable.
>
> Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
> ---
>  drivers/firmware/efivars.c |   38 ++++++++++++++++++++++++++++----------
>  1 files changed, 28 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
> index dc69802..dd228d5 100644
> --- a/drivers/firmware/efivars.c
> +++ b/drivers/firmware/efivars.c
> @@ -681,17 +681,35 @@ static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
>                                 *count = cnt;
>                                 timespec->tv_sec = time;
>                                 timespec->tv_nsec = 0;
> -                               get_var_data_locked(efivars, &efivars->walk_entry->var);
> -                               size = efivars->walk_entry->var.DataSize;
> -                               *buf = kmalloc(size, GFP_KERNEL);
> -                               if (*buf == NULL)
> -                                       return -ENOMEM;
> -                               memcpy(*buf, efivars->walk_entry->var.Data,
> -                                      size);
> -                               efivars->walk_entry = list_entry(efivars->walk_entry->list.next,
> -                                                  struct efivar_entry, list);
> -                               return size;
> +                       } else if (sscanf(name, "dump-type%u-%u-%lu",
> +                                  type, &part, &time) == 3) {
> +                               /*
> +                                * Check if an old format,
> +                                * which doesn't support holding
> +                                * multiple logs, remains.
> +                                */
> +                               *id = part;
> +                               *count = 0;
> +                               timespec->tv_sec = time;
> +                               timespec->tv_nsec = 0;
> +                       } else {
> +                               efivars->walk_entry = list_entry(
> +                                       efivars->walk_entry->list.next,
> +                                        struct efivar_entry, list);

odd wrap.

> +                               continue;
>                         }
> +
> +                       get_var_data_locked(efivars, &efivars->walk_entry->var);
> +                       size = efivars->walk_entry->var.DataSize;
> +                       *buf = kmalloc(size, GFP_KERNEL);
> +                       if (*buf == NULL)
> +                               return -ENOMEM;
> +                       memcpy(*buf, efivars->walk_entry->var.Data,
> +                              size);
> +                       efivars->walk_entry = list_entry(
> +                                       efivars->walk_entry->list.next,
> +                                       struct efivar_entry, list);
> +                       return size;
>                 }
>                 efivars->walk_entry = list_entry(efivars->walk_entry->list.next,
>                                                  struct efivar_entry, list);
> -- 1.7.1

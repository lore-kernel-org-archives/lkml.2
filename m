Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162Ab1LNViU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 16:38:20 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41615 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505Ab1LNViT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 16:38:19 -0500
MIME-Version: 1.0
In-Reply-To: <1323896791-10858-3-git-send-email-mjg@redhat.com>
References: <1323896791-10858-1-git-send-email-mjg@redhat.com> <1323896791-10858-3-git-send-email-mjg@redhat.com>
From: Mike Waychison <mikew@google.com>
Date: Wed, 14 Dec 2011 13:32:24 -0800
Message-ID: <CAGTjWtCWUv9MsV0_LP_oxZy-8NuB97-6iqfj6Jp0QTbqdRSrLg@mail.gmail.com>
Subject: Re: [PATCH 2/4] efi: Only create sysfs entries while booting or running
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 1:06 PM, Matthew Garrett <mjg@redhat.com> wrote:
> There's no point in creating sysfs entries while the machine's on its way
> down. Skip it in that case in order to avoid complexity.
>
> Signed-off-by: Matthew Garrett <mjg@redhat.com>

Acked-by: Mike Waychison <mikew@google.com>

> ---
>  drivers/firmware/efivars.c |   17 ++++++++++++-----
>  1 files changed, 12 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
> index b0a8117..eb07f13 100644
> --- a/drivers/firmware/efivars.c
> +++ b/drivers/firmware/efivars.c
> @@ -552,11 +552,18 @@ static int efi_pstore_write(enum pstore_type_id type, u64 *id,
>        if (found)
>                efivar_unregister(found);
>
> -       if (size)
> -               ret = efivar_create_sysfs_entry(efivars,
> -                                         utf16_strsize(efi_name,
> -                                                       DUMP_NAME_LEN * 2),
> -                                         efi_name, &vendor);
> +       if (size) {
> +               switch (system_state) {
> +               case SYSTEM_BOOTING:
> +               case SYSTEM_RUNNING:
> +                       ret = efivar_create_sysfs_entry(efivars,
> +                                                       utf16_strsize(efi_name,
> +                                                           DUMP_NAME_LEN * 2),
> +                                                       efi_name, &vendor);
> +               default:
> +                       break;
> +               }
> +       }
>
>        *id = part;
>        return ret;
> --
> 1.7.7.1
>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab2FQXAr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 19:00:47 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:49682 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab2FQXAq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 19:00:46 -0400
MIME-Version: 1.0
X-Originating-IP: [2001:470:8656:0:a0c8:5db2:5dc3:f787]
In-Reply-To: <1339706851-10618-1-git-send-email-marko.kohtala@gmail.com>
References: <1339706851-10618-1-git-send-email-marko.kohtala@gmail.com>
Date: Sun, 17 Jun 2012 16:00:45 -0700
Message-ID: <CAOesGMi2nAecB4Lgti-JSrNTuV4MRA9GEQV1T=BrDxJ-QCq+cQ@mail.gmail.com>
Subject: Re: [PATCH] efivars: prevent Oops if efi_enabled but no EFI runtime
From: Olof Johansson <olof@lixom.net>
To: Marko Kohtala <marko.kohtala@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 1:47 PM, Marko Kohtala <marko.kohtala@gmail.com> wrote:
> Since v3.3-rc4-5-g1adbfa3, there has been an Oops in register_efivars
> calling ops->get_next_variable and ending up at EIP 0 during module init.
>
> I boot 32-bit x86 kernel from 64-bit EFI bootloader.
>
> The efi_enabled is true, but runtime is not available. The functions
> are NULL due to 32/64-bit mismatch between kernel and EFI.
>
> Signed-off-by: Marko Kohtala <marko.kohtala@gmail.com>
> ---
> I currently see this on v3.4.2.
>
> I could not figure out how I'm supposed to detect lack of runtime, so
> I ended up with this quick and overly precise check that all required
> functions are available. There may be other drivers that need to take
> this new condition into account, so maybe Olof wants to make a better
> fix.

I must not have tested with efivars enabled, or I would have seen this
when I did. Sigh.


> diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
> index 47408e8..612a097 100644
> --- a/drivers/firmware/efivars.c
> +++ b/drivers/firmware/efivars.c
> @@ -1223,12 +1223,16 @@ efivars_init(void)
>                return -ENOMEM;
>        }
>
> -       ops.get_variable = efi.get_variable;
> -       ops.set_variable = efi.set_variable;
> -       ops.get_next_variable = efi.get_next_variable;
> -       error = register_efivars(&__efivars, &ops, efi_kobj);
> -       if (error)
> -               goto err_put;
> +       /* We may have efi_enabled for systab, but no runtime for variables.
> +        * Check the functions we need before proceeding. */
> +       if (efi.get_variable && efi.set_variable && efi.get_next_variable) {
> +               ops.get_variable = efi.get_variable;
> +               ops.set_variable = efi.set_variable;
> +               ops.get_next_variable = efi.get_next_variable;
> +               error = register_efivars(&__efivars, &ops, efi_kobj);
> +               if (error)
> +                       goto err_put;
> +       }

I think it would make more sense to return -ENODEV when the function
pointers aren't set, that way the exit function won't ever be called
either, so no need to add the checks there.

So, instead of current efi_enabled check:

if (!efi_enabled ||
    !efi.get_variable ||
    !efi.set_variable ||
    !efi.get_next_variable) {
    return -ENODEV;
}

-Olof

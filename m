Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab2FRUGJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 16:06:09 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44002 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab2FRUGG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 16:06:06 -0400
MIME-Version: 1.0
In-Reply-To: <CAOesGMi2nAecB4Lgti-JSrNTuV4MRA9GEQV1T=BrDxJ-QCq+cQ@mail.gmail.com>
References: <1339706851-10618-1-git-send-email-marko.kohtala@gmail.com>
	<CAOesGMi2nAecB4Lgti-JSrNTuV4MRA9GEQV1T=BrDxJ-QCq+cQ@mail.gmail.com>
Date: Mon, 18 Jun 2012 23:06:05 +0300
Message-ID: <CAJ0yFaxO-ZU7d_RNbQ3y1cfB5EJL9wgvmgZk-nmkVOLoBRH88A@mail.gmail.com>
Subject: Re: [PATCH] efivars: prevent Oops if efi_enabled but no EFI runtime
From: Marko Kohtala <marko.kohtala@gmail.com>
To: Olof Johansson <olof@lixom.net>
Cc: Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/18 Olof Johansson <olof@lixom.net>:
> On Thu, Jun 14, 2012 at 1:47 PM, Marko Kohtala <marko.kohtala@gmail.com> wrote:
>> Since v3.3-rc4-5-g1adbfa3, there has been an Oops in register_efivars
>> calling ops->get_next_variable and ending up at EIP 0 during module init.
>>
>> I boot 32-bit x86 kernel from 64-bit EFI bootloader.
>>
>> The efi_enabled is true, but runtime is not available. The functions
>> are NULL due to 32/64-bit mismatch between kernel and EFI.
>>
>> Signed-off-by: Marko Kohtala <marko.kohtala@gmail.com>
>> ---
>> I currently see this on v3.4.2.
>>
>> I could not figure out how I'm supposed to detect lack of runtime, so
>> I ended up with this quick and overly precise check that all required
>> functions are available. There may be other drivers that need to take
>> this new condition into account, so maybe Olof wants to make a better
>> fix.
>
> I must not have tested with efivars enabled, or I would have seen this
> when I did. Sigh.

I looked around a little, and it seems there is drivers/scsi/isci
driver using get_variable. arch/x86/kernel/reboot.c also calls
efi.reset_system if reboot=efi is given on command line. Some RTC
drivers call EFI runtime but are only for IA64 and this problem should
not be there.

>
>
>> diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
>> index 47408e8..612a097 100644
>> --- a/drivers/firmware/efivars.c
>> +++ b/drivers/firmware/efivars.c
>> @@ -1223,12 +1223,16 @@ efivars_init(void)
>>                return -ENOMEM;
>>        }
>>
>> -       ops.get_variable = efi.get_variable;
>> -       ops.set_variable = efi.set_variable;
>> -       ops.get_next_variable = efi.get_next_variable;
>> -       error = register_efivars(&__efivars, &ops, efi_kobj);
>> -       if (error)
>> -               goto err_put;
>> +       /* We may have efi_enabled for systab, but no runtime for variables.
>> +        * Check the functions we need before proceeding. */
>> +       if (efi.get_variable && efi.set_variable && efi.get_next_variable) {
>> +               ops.get_variable = efi.get_variable;
>> +               ops.set_variable = efi.set_variable;
>> +               ops.get_next_variable = efi.get_next_variable;
>> +               error = register_efivars(&__efivars, &ops, efi_kobj);
>> +               if (error)
>> +                       goto err_put;
>> +       }
>
> I think it would make more sense to return -ENODEV when the function
> pointers aren't set, that way the exit function won't ever be called
> either, so no need to add the checks there.
>
> So, instead of current efi_enabled check:
>
> if (!efi_enabled ||
>    !efi.get_variable ||
>    !efi.set_variable ||
>    !efi.get_next_variable) {
>    return -ENODEV;
> }

This was the first thought I had. Looking more closely there is a
reason why efivars returns 0 if !efi_enabled. The module exports
functions to export other variables as well (used by
drivers/firmware/google). Also, it is loaded (bloated?) with a feature
to show /sys/firmware/efi/systab. Systab is there in case of
efi_enabled but no runtime.

So there are three modes to work with:
- !efi_enabled
- efi_enabled, but no runtime
- efi_enabled and runtime

I was wondering if you had some feelings for handling the difference
between the last two modes. I have no objection to checking the
pointers, but somehow it seems excessive checking many pointers when
really they are either all set or unset.

Maybe efi_enabled could have a third value for the new mode so other
modules like efivars can easily skip some useless initialization.

If there is no "final" solution quickly available, then maybe my patch
should be applied now to stable 3.4.y and replaced later with a better
solution for 3.5 or something.

>
> -Olof

Marko

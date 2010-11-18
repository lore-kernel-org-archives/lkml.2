Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab0KRHgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 02:36:00 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62328 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab0KRHf7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 02:35:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=L8EeDa5JBxfbqF/UW/pHFXto0SWE1E0EQgWLfOGJdlaB+M9JYIQMM0cPQ3mrKMiCqt
         HbfFMGcwkLcWs50f3xkFlM16QZv6O3MN+UBAtLl6Kc1HTj7G39+S2IJeN8oJ1WYA1bEH
         JVp1jB9Hcui2r//G0YfHUlOHOl71U/OrBL8xw=
MIME-Version: 1.0
In-Reply-To: <20101117212943.GA6661@core.coreip.homeip.net>
References: <1289977165-14802-1-git-send-email-ike.pan@canonical.com>
	<1289977238-15113-1-git-send-email-ike.pan@canonical.com>
	<20101117212943.GA6661@core.coreip.homeip.net>
Date: Thu, 18 Nov 2010 08:35:58 +0100
Message-ID: <AANLkTim1DKZkCqB1mLg5=7UTd2szCoSS_DSO8v3jHTmy@mail.gmail.com>
Subject: Re: [PATCH 3/3] ideapad: add hotkey support
From: Corentin Chary <corentin.chary@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Ike Panhc <ike.pan@canonical.com>, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 10:29 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Wed, Nov 17, 2010 at 03:00:38PM +0800, Ike Panhc wrote:
>> Hotkey enabled by this patch:
>>   Fn+F3: Video mode switch
>>   Fn+F5: software rfkill for wifi
>>
>> For some ideapad when push Fn+F3, hardware generates Super-P keys, those key
>> will not be enabled by this patch.
>>
>> Signed-off-by: Ike Panhc <ike.pan@canonical.com>
>> ---
>>  drivers/platform/x86/ideapad-laptop.c |   74 +++++++++++++++++++++++++++++++++
>>  1 files changed, 74 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
>> index d75c21f..d397034 100644
>> --- a/drivers/platform/x86/ideapad-laptop.c
>> +++ b/drivers/platform/x86/ideapad-laptop.c
>> @@ -28,6 +28,8 @@
>>  #include <acpi/acpi_drivers.h>
>>  #include <linux/rfkill.h>
>>  #include <linux/platform_device.h>
>> +#include <linux/input.h>
>> +#include <linux/input/sparse-keymap.h>
>>
>>  #define IDEAPAD_DEV_CAMERA   0
>>  #define IDEAPAD_DEV_WLAN     1
>> @@ -39,6 +41,7 @@ struct ideapad_private {
>>       acpi_handle handle;
>>       struct rfkill *rfk[5];
>>       struct platform_device *platform_device;
>> +     struct input_dev *inputdev;
>>  } *ideapad_priv;
>>
>>  static struct {
>> @@ -325,6 +328,68 @@ static void ideapad_platform_exit(void)
>>  }
>>  /* the above is platform device */
>>
>> +/*
>> + * input device
>> + */
>> +static const struct key_entry ideapad_keymap[] = {
>> +     { KE_KEY, 0x06, { KEY_SWITCHVIDEOMODE } },
>> +     { KE_KEY, 0x0D, { KEY_WLAN } },
>> +     { KE_END, 0 },
>> +};
>> +
>> +static int ideapad_input_init(void)
>
> __devinit?
>
>> +{
>> +     struct input_dev *inputdev;
>> +     int error;
>> +
>> +     inputdev = input_allocate_device();
>> +     if (!inputdev) {
>> +             pr_info("Unable to allocate input device\n");
>> +             return -ENOMEM;
>> +     }
>> +
>> +     inputdev->name = "Ideapad extra buttons";
>> +     inputdev->phys = "ideapad/input0";
>> +     inputdev->id.bustype = BUS_HOST;
>> +     inputdev->dev.parent = &ideapad_priv->platform_device->dev;
>> +
>> +     error = sparse_keymap_setup(inputdev, ideapad_keymap, NULL);
>> +     if (error) {
>> +             pr_err("Unable to setup input device keymap\n");
>> +             goto err_free_dev;
>> +     }
>> +
>> +     error = input_register_device(inputdev);
>> +     if (error) {
>> +             pr_err("Unable to register input device\n");
>> +             goto err_free_keymap;
>> +     }
>> +
>> +     ideapad_priv->inputdev = inputdev;
>
> Why don't you pass ideapad_priv in as an argument instead of relying on
> global. I know that there can only be one, but then why do you have a
> structure?

That may allow to remove the global later, like we did on
eeepc-laptop/asus-laptop.

>> +     return 0;
>> +
>> +err_free_keymap:
>> +     sparse_keymap_free(inputdev);
>> +err_free_dev:
>> +     input_free_device(inputdev);
>> +     return error;
>> +}
>> +
>> +static void ideapad_input_exit(void)
>
> __devexit? The rest of the driver might user these markups as well.
>
>> +{
>> +     if (ideapad_priv->inputdev) {
>> +             sparse_keymap_free(ideapad_priv->inputdev);
>> +             input_unregister_device(ideapad_priv->inputdev);
>> +     }
>> +     ideapad_priv->inputdev = NULL;
>
> You fail driver initialization when ideapad_input_init() fails so there
> is no point in checking whether ideapad_priv->inputdev is null or not.
>
> Otherwise looks good from input POV.
>
> Thanks.



-- 
Corentin Chary
http://xf.iksaif.net

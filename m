Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab0J0TYV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 15:24:21 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:59354 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756043Ab0J0TYQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 15:24:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jeL1oqlT2bVlXun4DbdHljTV4jCplVLRwcHg+7KS0exmbaoBENtJTJHjByGNWamfIU
         gda+W9nlEEkHwBtzyZUpBWt3Cl5YCW14na5tsunUoDoypfZQEq+nj8WO55R7MPqNDjIt
         lI95uKVrrvFbRbVcXhSnCsF5gI5s5Qnt4FSm8=
MIME-Version: 1.0
In-Reply-To: <20101026192028.GA17880@srcf.ucam.org>
References: <AANLkTikff5b9zhCLEmyoHZPTPaREuHE1qp21SLA0v=83@mail.gmail.com>
	<20101026192028.GA17880@srcf.ucam.org>
Date: Wed, 27 Oct 2010 13:24:15 -0600
Message-ID: <AANLkTinmsNzAkp_ZGcaNyVRVMu0Rc4-C+xPKuSOS5jRJ@mail.gmail.com>
Subject: Re: toshiba_acpi.c: Full TOS1900 device support
From: Azael Avalos <coproscefalo@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 26, 2010 at 1:20 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Tue, Oct 26, 2010 at 01:14:25PM -0600, Azael Avalos wrote:
>>
>> -     hci_read1(HCI_LCD_BRIGHTNESS, &value, &hci_result);
>> -     if (hci_result == HCI_SUCCESS) {
>> -             return (value >> HCI_LCD_BRIGHTNESS_SHIFT);
>> -     } else
>> -             return -EFAULT;
>> +     if (toshiba_acpi.spfc && toshiba_acpi.video_handle) {
>> +             status = acpi_evaluate_integer(toshiba_acpi.video_handle,
>> +                                            "_BQC", NULL, &val);
>> +             if (ACPI_SUCCESS(status))
>> +                     return val;
>
> This doesn't look right. Shouldn't _BQC indicate that it's an ACPI spec
> video device, and thus driven by the ACPI video driver?
>

Yes, actually the ACPI video driver does a better job of detecting the
video device,
so perhaps something like the following would be better IMHO for at least the
backlight:


	if (toshiba_acpi.spfc || !acpi_video_backlight_support()) {
		props.max_brightness = HCI_LCD_BRIGHTNESS_LEVELS - 1;
		toshiba_backlight_device = backlight_device_register("toshiba",
						    &toshiba_acpi.p_dev->dev,
						    NULL,
						    &toshiba_backlight_data,
						    &props);
		if (IS_ERR(toshiba_backlight_device)) {
			ret = PTR_ERR(toshiba_backlight_device);

			printk(KERN_ERR
			       "Could not register toshiba backlight device\n");
			toshiba_backlight_device = NULL;
			toshiba_acpi_exit();
			return ret;
		}
	}


Is there an ACPI function that let's us query the display brightness?
Because TOS1900 devices lack the HCI method to query the LCD status,
and thus the proc interface will be useless, that is, if a userland (or any
other) application is using it.



>> +static void toshiba_input_event(struct input_handle *handle, unsigned int type,
>> +                          unsigned int code, int value)
>>  {
>> -     struct key_entry *key;
>> -
>> -     for (key = toshiba_acpi_keymap; key->type != KE_END; key++)
>> -             if (code == key->code)
>> -                     return key;
>> -
>> -     return NULL;
>> +     if (type == EV_MSC && code == MSC_SCAN && value == TOSHIBA_FN_SCAN)
>> +             schedule_work(&((struct toshiba_acpi_dev *)handle->private)->hotkey_work);
>>  }
>
> Ugh. Use i8042_install_filter instead, and just look at the raw i8042
> stream. That'll avoid the ugly strncmp for the device names in order to
> find the right device.
>

Can you point me to some documents (if any) or even pieces of code
that I can look at.

I've tried using the i8042_install_filter function, but I haven't had
any luck so far,
or perhaps I'm using it in wrong, due to my limited kernel knowledge.


Saludos
Azael


-- 
-- El mundo apesta y vosotros apestais tambien --

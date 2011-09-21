Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab1IUHbh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 03:31:37 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36185 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab1IUHb0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 03:31:26 -0400
MIME-Version: 1.0
In-Reply-To: <1316557078.1903.11.camel@Joe-Laptop>
References: <1316555754-25949-1-git-send-email-seth.forshee@canonical.com>
	<1316555754-25949-2-git-send-email-seth.forshee@canonical.com>
	<1316557078.1903.11.camel@Joe-Laptop>
Date: Wed, 21 Sep 2011 09:31:24 +0200
Message-ID: <CAHR064g=vu2JXtqpNhdrNbyU6k5Wq5uvA7AYspxTPU6aSpn+rQ@mail.gmail.com>
Subject: Re: [PATCH 1/6] toshiba_acpi: Convert to use acpi_driver
From: Corentin Chary <corentin.chary@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Seth Forshee <seth.forshee@canonical.com>,
        Matthew Garrett <mjg@redhat.com>,
        Azael Avalos <coproscefalo@gmail.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 12:17 AM, Joe Perches <joe@perches.com> wrote:
> On Tue, 2011-09-20 at 16:55 -0500, Seth Forshee wrote:
>> Changes toshiba_acpi to register an acpi driver and eliminates the
>> platform device it was using.
>
> Just trivial comments...
>
>> diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
>> +static acpi_status hci_raw(struct toshiba_acpi_dev *dev,
>> +                        const u32 in[HCI_WORDS], u32 out[HCI_WORDS])
> []
>> @@ -237,85 +234,79 @@ static acpi_status hci_raw(const u32 in[HCI_WORDS], u32 out[HCI_WORDS])
>>   * may be useful (such as "not supported").
>>   */
>>
>> -static acpi_status hci_write1(u32 reg, u32 in1, u32 * result)
>> +static acpi_status hci_write1(struct toshiba_acpi_dev *dev, u32 reg,
>> +                           u32 in1, u32 *result)
>>  {
>>       u32 in[HCI_WORDS] = { HCI_SET, reg, in1, 0, 0, 0 };
>
> A lot of the in[HCI_WORDS] could be static const or const
>
>        static const u32 in[HCI_WORDS] etc...

Not static const ! see how reg and in1 are used. const is ok.

>
>> +static acpi_status hci_read1(struct toshiba_acpi_dev *dev, u32 reg,
>> +                          u32 *out1, u32 *result)
>>  {
>>       u32 in[HCI_WORDS] = { HCI_GET, reg, 0, 0, 0, 0 };
>
> here too.
>
>>       u32 out[HCI_WORDS];
>> -     acpi_status status = hci_raw(in, out);
>> +     acpi_status status = hci_raw(dev, in, out);
>>       *out1 = out[2];
>>       *result = (status == AE_OK) ? out[0] : HCI_FAILURE;
>>       return status;
>>  }
>>
>> -static acpi_status hci_write2(u32 reg, u32 in1, u32 in2, u32 *result)
>> +static acpi_status hci_write2(struct toshiba_acpi_dev *dev, u32 reg,
>> +                           u32 in1, u32 in2, u32 *result)
>>  {
>>       u32 in[HCI_WORDS] = { HCI_SET, reg, in1, in2, 0, 0 };
>
> const etc.
>
>> @@ -507,8 +486,13 @@ static int get_lcd(struct backlight_device *bd)
>>
>>  static int lcd_proc_show(struct seq_file *m, void *v)
>>  {
>> -     int value = get_lcd(NULL);
>> +     struct toshiba_acpi_dev *dev = m->private;
>> +     int value;
>> +
>> +     if (!dev->backlight_dev)
>> +             return -ENODEV;
>>
>> +     value = get_lcd(dev->backlight_dev);
>>       if (value >= 0) {
>>               seq_printf(m, "brightness:              %d\n", value);
>>               seq_printf(m, "brightness_levels:       %d\n",
>
> Some small amount space could be saved by using:
>
>                seq_printf(m, "%-24s %d\n", "brightness:", value);
>                seq_printf(m, "%-24s %d\n", "brightness_levels:", etc...
> []
>> @@ -675,13 +663,14 @@ static const struct file_operations video_proc_fops = {
>>
>>  static int fan_proc_show(struct seq_file *m, void *v)
>>  {
>> +     struct toshiba_acpi_dev *dev = m->private;
>>       u32 hci_result;
>>       u32 value;
>>
>> -     hci_read1(HCI_FAN, &value, &hci_result);
>> +     hci_read1(dev, HCI_FAN, &value, &hci_result);
>>       if (hci_result == HCI_SUCCESS) {
>>               seq_printf(m, "running:                 %d\n", (value > 0));
>
> Here too:
>
>                seq_printf(m, "%-24s %d\n", "running:", (value > 0);
>
>> -             seq_printf(m, "force_on:                %d\n", force_fan);
>> +             seq_printf(m, "force_on:                %d\n", dev->force_fan);
>
> etc.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe platform-driver-x86" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Corentin Chary
http://xf.iksaif.net

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab2DCN5e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 09:57:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53262 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab2DCN5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 09:57:32 -0400
Message-ID: <4F7B01C8.9050109@gmail.com>
Date: Tue, 03 Apr 2012 22:57:28 +0900
From: Akio Idehara <zbe64533@gmail.com>
MIME-Version: 1.0
To: seth.forshee@canonical.com
CC: mjg59@srcf.ucam.org, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] toshiba_acpi: Add support for transflective LCD
References: <1333120590-4868-1-git-send-email-zbe64533@gmail.com> <20120402193952.GD24020@thinkpad-t410>
In-Reply-To: <20120402193952.GD24020@thinkpad-t410>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Seth.

Thank you for reviewing my code again and again.
All your comments make sense.
I'll try to make the v3 patch.

Best Regards,
Akio

Seth Forshee wrote:

> On Sat, Mar 31, 2012 at 12:16:30AM +0900, Akio Idehara wrote:
>> +static int get_tr_backlight_status(struct toshiba_acpi_dev *dev, u32 *status)
>> +{
>> +	u32 hci_result;
>> +
>> +	hci_read1(dev, HCI_TR_BACKLIGHT, status, &hci_result);
>> +	return hci_result == HCI_SUCCESS ? 0 : -EIO;
>> +}
>> +
>> +static int set_tr_backlight_status(struct toshiba_acpi_dev *dev, int value)
>> +{
>> +	u32 hci_result;
>> +
>> +	hci_write1(dev, HCI_TR_BACKLIGHT, value, &hci_result);
>> +	return hci_result == HCI_SUCCESS ? 0 : -EIO;
>> +}
> 
> I think the code will be easier to read if you change both of these to
> use boolean arguments, since that's essentially how they're being used
> anyway. I.e.
> 
> static int get_tr_backlight_status(struct toshiba_acpi_dev *dev, boolean *enabled);
> static int set_tr_backlight_status(struct toshiba_acpi_dev *dev, boolean enable);
> 
>> @@ -497,15 +527,18 @@ static int lcd_proc_show(struct seq_file *m, void *v)
>>  {
>>  	struct toshiba_acpi_dev *dev = m->private;
>>  	int value;
>> +	int levels = HCI_LCD_BRIGHTNESS_LEVELS;
>>  
>>  	if (!dev->backlight_dev)
>>  		return -ENODEV;
>>  
>> +	if (dev->tr_backlight_supported)
>> +		levels++;
> 
> dev->backlight_dev->props.max_brightness + 1? That seems nicer than
> having to duplicate the "tr backlight gives me an additional brightness
> level" logic throughout the file.
> 
>> @@ -1104,8 +1148,15 @@ static int __devinit toshiba_acpi_add(struct acpi_device *acpi_dev)
>>  
>>  	mutex_init(&dev->mutex);
>>  
>> +	/* Determine whether or not BIOS supports transflective backlight */
>> +	ret = get_tr_backlight_status(dev, &dummy) ? false : true;
>> +	dev->tr_backlight_supported = ret;
> 
> I'd personally prefer
> 
> 	ret = get_tr_backlight_status(dev, &dummy);
> 	dev->tr_backlight_supported = !ret;
> 
> to be consistent with how this is done other places in the file.
> 
> Cheers,
> Seth
> 



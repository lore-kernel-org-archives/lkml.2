Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab0IRCrX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 22:47:23 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43132 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab0IRCrW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 22:47:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=D2AUYboiYa3SF8jgE7w4Dh38PrJ9jcY15Gmql3C9LBvSFu+fRoG+FE1IW5Iy6iuSd4
         cla6pe73BxhfPhqMaHMgDviaqvQxisuDL8hZD7tJ63UGbG1V90GbNyyF2/UGBvfBlYUX
         U6p3hAnjKlV9MAFi89w3O/g6nxFdg5C/bEgbw=
MIME-Version: 1.0
In-Reply-To: <20100917150731.f1f44f3c.akpm@linux-foundation.org>
References: <4C7CD95A.5040309@samsung.com>
	<20100917150731.f1f44f3c.akpm@linux-foundation.org>
Date: Sat, 18 Sep 2010 11:47:20 +0900
X-Google-Sender-Auth: Zf8IEj13p3c2rWHo7BDhhZAUI78
Message-ID: <AANLkTikH06HwxbmrxDkTNWuBaQgbZrFpGOoM_ocfZoCK@mail.gmail.com>
Subject: Re: [PATCH] misc: adds support the FSA9480 USB Switch
From: Kyungmin Park <kyungmin.park@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minkyu Kang <mk7.kang@samsung.com>, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 18, 2010 at 7:07 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> (catching up!)
>
> On Tue, 31 Aug 2010 19:28:42 +0900
> Minkyu Kang <mk7.kang@samsung.com> wrote:
>
>> The FSA9480 is a USB port accessory detector and switch.
>> This patch adds support the FSA9480 USB Switch.
>>
>
> What a strange device.
>
As Minkyu Kang is on holiday until 9/27. I reply it instead. he will
give more information when returned.
I just explain the how to work and what's the purpose to export functions.

> Is there a data sheet available?

It's difficult to find it at web, I'll check it but maybe difficult.

>
>> +config USB_SWITCH_FSA9480
>> +     tristate "FSA9480 USB Switch"
>> +     depends on I2C
>> +     help
>> +       The FSA9480 is a USB port accessory detector and switch.
>> +       The FSA9480 is fully controlled using I2C and enables USB data,
>> +       stereo and mono audio, video, microphone and UART data to use
>> +       a common connector port.
>
> So if I'm understanding it correctly, it's an i2c-controlled device
> which turns USB devices on and off, multiplexing them into a single USB
> port?  So if I switch from "USB data" over to "microphone", the USB
> subsystem will see the "USB data" device get unplugged and will see a
> "microphone" get plugged in?

When connect the usb cable, then read USB ID(?) or something and
switch the mux automatically.
e.g, when you connect the car kit then it switch the path to car kit.
Can't turn off the USB devices. only switch the USB path.

>
> Or something else.  Am I even vaguely understanding this thing?
>
> It would help if the changelog were to contain a paragraph
> describing the overall behaviour of this device.
>
>>
>> ...
>>
>> +void fsa9480_set_switch(const char *buf)
>> +{
>> +     struct fsa9480_usbsw *usbsw = chip;
>> +     struct i2c_client *client = usbsw->client;
>> +     unsigned int value;
>> +     unsigned int path = 0;
>> +
>> +     value = fsa9480_read_reg(client, FSA9480_REG_CTRL);
>> +
>> +     if (!strncmp(buf, "VAUDIO", 6)) {
>> +             path = SW_VAUDIO;
>> +             value &= ~CON_MANUAL_SW;
>> +     } else if (!strncmp(buf, "UART", 4)) {
>> +             path = SW_UART;
>> +             value &= ~CON_MANUAL_SW;
>> +     } else if (!strncmp(buf, "AUDIO", 5)) {
>> +             path = SW_AUDIO;
>> +             value &= ~CON_MANUAL_SW;
>> +     } else if (!strncmp(buf, "DHOST", 5)) {
>> +             path = SW_DHOST;
>> +             value &= ~CON_MANUAL_SW;
>> +     } else if (!strncmp(buf, "AUTO", 4)) {
>> +             path = SW_AUTO;
>> +             value |= CON_MANUAL_SW;
>> +     } else {
>> +             printk(KERN_ERR "Wrong command\n");
>> +             return;
>> +     }
>> +
>> +     usbsw->mansw = path;
>> +     fsa9480_write_reg(client, FSA9480_REG_MANSW1, path);
>> +     fsa9480_write_reg(client, FSA9480_REG_CTRL, value);
>> +}
>> +EXPORT_SYMBOL_GPL(fsa9480_set_switch);
To Minkyu, It's should be EXPORT_SYMBOL???
>
> Why was this exported?

Even though it switch the USB path automatically, we don't use the
full path for each purpose.
e.g., we don't use the V(ideo)Audio or Audio. it's connected it for
other purpose.
In this case we switch it by manually by MAN(ual) Switch register.

>
>> +ssize_t fsa9480_get_switch(char *buf)
>> +{
>> +     struct fsa9480_usbsw *usbsw = chip;
>> +     struct i2c_client *client = usbsw->client;
>> +     unsigned int value;
>> +
>> +     value = fsa9480_read_reg(client, FSA9480_REG_MANSW1);
>> +
>> +     if (value == SW_VAUDIO)
>> +             return sprintf(buf, "VAUDIO\n");
>> +     else if (value == SW_UART)
>> +             return sprintf(buf, "UART\n");
>> +     else if (value == SW_AUDIO)
>> +             return sprintf(buf, "AUDIO\n");
>> +     else if (value == SW_DHOST)
>> +             return sprintf(buf, "DHOST\n");
>> +     else if (value == SW_AUTO)
>> +             return sprintf(buf, "AUTO\n");
>> +     else
>> +             return sprintf(buf, "%x", value);
>> +}
>> +EXPORT_SYMBOL_GPL(fsa9480_get_switch);
>
> This export also has no callers?
It's used check what's the current switch status at other drivers.

Thank you,
Kyungmin Park
>
> These functions implement a userspace API.  Userspace APIs are
> important.  But the patch provided no documentation for that API.
> Please always fully, exhaustively document userspace APIs!  For they
> are the one part of the driver which we can never change.
>
> Documenting them in a documentation file is OK.  Also there's
> Documentation/ABI/.  And they can be nicely described in the changelog
> too.
>
> But providing us with no description at all makes review harder and
> less effective than we'd like it to be, and results in a driver which
> is harder for our users to use.
>
> OK?
>
>> +static ssize_t fsa9480_show_status(struct device *dev,
>> +                                struct device_attribute *attr,
>> +                                char *buf)
>> +{
>> +     struct fsa9480_usbsw *usbsw = dev_get_drvdata(dev);
>> +     struct i2c_client *client = usbsw->client;
>> +     int devid, ctrl, adc, dev1, dev2, intr,
>> +         intmask1, intmask2, time1, time2, mansw1;
>> +
>> +     devid = fsa9480_read_reg(client, FSA9480_REG_DEVID);
>> +     ctrl = fsa9480_read_reg(client, FSA9480_REG_CTRL);
>> +     adc = fsa9480_read_reg(client, FSA9480_REG_ADC);
>> +     intmask1 = fsa9480_read_reg(client, FSA9480_REG_INT1_MASK);
>> +     intmask2 = fsa9480_read_reg(client, FSA9480_REG_INT2_MASK);
>> +     dev1 = fsa9480_read_reg(client, FSA9480_REG_DEV_T1);
>> +     dev2 = fsa9480_read_reg(client, FSA9480_REG_DEV_T2);
>> +     time1 = fsa9480_read_reg(client, FSA9480_REG_TIMING1);
>> +     time2 = fsa9480_read_reg(client, FSA9480_REG_TIMING2);
>> +     mansw1 = fsa9480_read_reg(client, FSA9480_REG_MANSW1);
>> +
>> +     fsa9480_read_irq(client, &intr);
>> +
>> +     return sprintf(buf, "Device ID(%02x), CTRL(%02x)\n"
>> +                     "ADC(%02x), DEV_T1(%02x), DEV_T2(%02x)\n"
>> +                     "INT(%04x), INTMASK(%02x, %02x)\n"
>> +                     "TIMING(%02x, %02x), MANSW1(%02x)\n",
>> +                     devid, ctrl, adc, dev1, dev2, intr,
>> +                     intmask1, intmask2, time1, time2, mansw1);
>> +}
>
> That's will produce odd-looking output I suspect.  More conventional
> would be
>
>        Device ID:%02x CTRL:%02x
>
> or something like that.
>
> But that result is basically unparseable by software and a better output
> would be
>
> Device_ID: %02x
> CTRL: %02x
> ADC: %02x
>
> etc.
>
> But even that violates the sysfs one-value-per-file guideline.
>
> So this interface is problematic.  It should have been discussed
> up-front in the changelog so we can all take a look at the proposal and
> have a think about it.
>
>>
>> ...
>>
>> +static irqreturn_t fsa9480_irq_handler(int irq, void *data)
>> +{
>> +     struct fsa9480_usbsw *usbsw = data;
>> +
>> +     if (!work_pending(&usbsw->work)) {
>> +             disable_irq_nosync(irq);
>> +             schedule_work(&usbsw->work);
>> +     }
>> +
>> +     return IRQ_HANDLED;
>> +}
>
> I expect that this driver can be converted to the new threaded IRQ code
> (request_threaded_irq) and it will all become simpler.
>
>>
>> ...
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

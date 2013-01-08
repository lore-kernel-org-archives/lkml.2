Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab3AHWCW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 17:02:22 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:58766 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab3AHWCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 17:02:20 -0500
MIME-Version: 1.0
In-Reply-To: <20130108180958.GL13897@intel.com>
References: <1357650332-30031-1-git-send-email-mika.westerberg@linux.intel.com>
	<CAN+gG=HzJaOwPfymx5JST1+r9QxfqU5D-gN8i95aVDkqQ=ot8Q@mail.gmail.com>
	<20130108180958.GL13897@intel.com>
Date: Tue, 8 Jan 2013 22:55:59 +0100
Message-ID: <CAN+gG=FGv=VJ=6Db_s7p_7XJQi3=FJXDfqeE1AVPtFznHnWQ0Q@mail.gmail.com>
Subject: Re: [PATCH] HID: i2c-hid: add ACPI support
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-input@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 8, 2013 at 7:09 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> On Tue, Jan 08, 2013 at 02:51:53PM +0100, Benjamin Tissoires wrote:
>> Hi Mika,
>>
>> On Tue, Jan 8, 2013 at 2:05 PM, Mika Westerberg
>> <mika.westerberg@linux.intel.com> wrote:
>> > The HID over I2C protocol specification states that when the device is
>> > enumerated from ACPI the HID descriptor address can be obtained by
>> > executing "_DSM" for the device with function 1. Enable this.
>>
>> Hehe, funny thing, I worked on the very same patch last Friday. I was
>> not able to send it upstream as I still don't have an ACPI 5 enabled
>> device...
>> So thanks for submitting (and testing) this!
>>
>> Before the review, I just have a quick question. All the HID/i2c
>> devices I saw so far present a reset line (through a GPIO). Does the
>> shipped device you have present this line, and if yes, how this meld
>> with the code (i.e. should we take this into account).
>
> Yes, there is either one or two GPIO lines. But there are also devices that
> don't have any GPIO lines.

Ouch. But if they don't have any GPIO, how can they manage to send
information? If they are using polling, then this will require some
more work in i2c-hid :(

>
> We probably should take this into account. I'm not too familiar with HID
> drivers but what if we set the hid->dev.acpi_node and let the actual HID
> driver to deal with the GPIO?

Well, HID is a communication layer between the device and the kernel
in order to make it agnostic of the transport layer (usb, bt or i2c).
Even if some drivers do some transport tuning, I don't think it's a
good idea to ask HID drivers to do transport handling such as setting
up GPIOs.

The closest thing which is already in the kernel tree is the handling
of device specific quirks in usbhid. We may be forced to do such a
thing if the DSDT is not explicit enough to guess the right behavior
(how to trigger the reset line, etc..)

Also, I missed one point in my previous review:

>
>> Please note that I can only compare this to my patch, based on the
>> DSDT example Microsoft gave in its spec. So sorry if I'm asking
>> useless things, but I like to understand... :)
>> Here are a few comments:
>>
>> >
>> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
>> > ---
>> >  drivers/hid/i2c-hid/i2c-hid.c |   73 +++++++++++++++++++++++++++++++++++++++--
>> >  1 file changed, 71 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
>> > index 9ef22244..b2eebb6 100644
 (...snipped...)

>> > +
>> > +       pdata = devm_kzalloc(&client->dev, sizeof(*pdata), GFP_KERNEL);

Here, I don't think mixing devm_* and regular allocations is a good thing.
I know it's a pain, but at the time I wrote the driver, the input
layer was not devm-ized, so I was not able to use devm allocs. Now it
should be feasible, but I didn't found the time to do it.
So I'm afraid, this allocation must use a regular kwalloc and it
should be freed somewhere later, until we devm-ize the whole module.

>> > +       if (!pdata)
>> > +               goto fail;
>>

(...snipped...)
>> >         if (!platform_data) {
>> > -               dev_err(&client->dev, "HID register address not provided\n");
>> > -               return -EINVAL;
>> > +               platform_data = i2c_hid_acpi_pdata(client);
>> > +               if (!platform_data) {
>> > +                       dev_err(&client->dev, "HID register address not provided\n");
>>
>> You may have a line with more than 80 characters here (it's difficult
>> to guess thanks to my gmail client converting tabs into spaces...
>> grrr)
>
> Shouldn't be as checkpatch.pl didn't complain but I'll re-check.

It's strange if it didn't complained: I count 61 chars for the
dev_err() message + 3 tabs * 8 chars => 85 chars in total...

Cheers,
Benjamin

>
>> > +                       return -EINVAL;
>>
>> Always returning -EINVAL does not seem to be the exact error code if
>> i2c_hid_acpi_pdata fails.
>
> OK. I'll return whatever error code is returned from i2c_hid_acpi_pdata().
>
>> > +               }
>> >         }
>> >
>> >         if (!client->irq) {
>> > @@ -964,6 +1032,7 @@ static struct i2c_driver i2c_hid_driver = {
>> >                 .name   = "i2c_hid",
>> >                 .owner  = THIS_MODULE,
>> >                 .pm     = &i2c_hid_pm,
>> > +               .acpi_match_table = ACPI_PTR(i2c_hid_acpi_match),
>>
>> This is something I was wondering when looking at your documentation.
>> If CONFIG_ACPI is not defined, then 'i2c_hid_acpi_match' does not exists.
>> Is there some magic within ACPI_PTR if CONFIG_ACPI is not defined, or
>> should we put the #ifdef around?
>
> if !CONFIG_ACPI then ACPI_PTR(whatever) becomes NULL so it is safe to set
> here.
>
>> Anyway thanks for this job!
>
> No problem and thanks for your review.

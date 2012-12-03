Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab2LCLcJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 06:32:09 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48658 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813Ab2LCLcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 06:32:06 -0500
MIME-Version: 1.0
In-Reply-To: <20121130155650.69407e9f@endymion.delvare>
References: <1352731379-24683-1-git-send-email-benjamin.tissoires@gmail.com>
	<20121130155650.69407e9f@endymion.delvare>
Date: Mon, 3 Dec 2012 12:32:03 +0100
Message-ID: <CAN+gG=FjVswyx1W4y6NtbNnBu2AWgZZfxVr0h00ZYujCOz3v7Q@mail.gmail.com>
Subject: Re: [PATCH v3] i2c-hid: introduce HID over i2c specification implementation
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, fabien.andre@gmail.com,
        scott.liu@emc.com.tw, JJ Ding <jj_ding@emc.com.tw>,
        Jiri Slaby <jslaby@suse.cz>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        linux-i2c@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On Fri, Nov 30, 2012 at 3:56 PM, Jean Delvare <khali@linux-fr.org> wrote:
> Hi Benjamin, Jiri,
>
> Sorry for the late review. But better late than never I guess...

Sure! Thanks for the review. As the driver is already in Jiri's tree,
I'll do small incremental patches based on this release.

I'll try to address all of your comments.

I have a few answers to some of your remarks (I fully agree with all
of the others):

>
> On Mon, 12 Nov 2012 15:42:59 +0100, Benjamin Tissoires wrote:
>> Microsoft published the protocol specification of HID over i2c:
>> http://msdn.microsoft.com/en-us/library/windows/hardware/hh852380.aspx
>>
>> This patch introduces an implementation of this protocol.
>>
>> This implementation does not includes the ACPI part of the specification.
>> This will come when ACPI 5.0 devices enumeration will be available.
>>
>> Once the ACPI part is done, OEM will not have to declare HID over I2C
>> devices in their platform specific driver.
>>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
>> ---
>> (..)
>>  drivers/hid/Kconfig           |   2 +
>>  drivers/hid/Makefile          |   1 +
>>  drivers/hid/i2c-hid/Kconfig   |  21 +
>>  drivers/hid/i2c-hid/Makefile  |   5 +
>>  drivers/hid/i2c-hid/i2c-hid.c | 974 ++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/i2c/i2c-hid.h   |  35 ++
>>  6 files changed, 1038 insertions(+)
>>  create mode 100644 drivers/hid/i2c-hid/Kconfig
>>  create mode 100644 drivers/hid/i2c-hid/Makefile
>>  create mode 100644 drivers/hid/i2c-hid/i2c-hid.c
>>  create mode 100644 include/linux/i2c/i2c-hid.h
>
> Looks much better. I still have several random comments which you may
> be interested in.
>
> (...)
>> +/* debug option */
>> +static bool debug = false;
>
> Whether you like it or not, that's still an error for checkpatch:
> ERROR: do not initialise statics to 0 or NULL
> #240: FILE: drivers/hid/i2c-hid/i2c-hid.c:49:
> +static bool debug = false;
>
> The rationale is that the compiler can write more efficient code if
> initializations to 0 or NULL are implicit.

ok, will do.

>
>> +module_param(debug, bool, 0444);
>> +MODULE_PARM_DESC(debug, "print a lot of debug information");
>> +
>> +#define i2c_hid_dbg(ihid, fmt, arg...)       \
>> +     if (debug)                      \
>> +             dev_printk(KERN_DEBUG, &(ihid)->client->dev, fmt, ##arg)
>
> This is considered an error by checkpatch too:
> ERROR: Macros with complex values should be enclosed in parenthesis
> #244: FILE: drivers/hid/i2c-hid/i2c-hid.c:53:
> +#define i2c_hid_dbg(ihid, fmt, arg...) \
> +       if (debug)                      \
> +               dev_printk(KERN_DEBUG, &(ihid)->client->dev, fmt, ##arg)
>
> And I wouldn't disagree, as the construct above can lead to bugs which
> are hard to see... Consider the following piece of code:
>
>         if (condition)
>                 i2c_hid_dbg(ihid, "Blah blah %d\n", i);
>         else
>                 do_something_very_important();
>
> It looks correct, however with the macro definition above, this expands
> to the unexpected:
>
>         if (condition) {
>                 if (debug)                      \
>                         dev_printk(KERN_DEBUG, &ihid->client->dev,
>                                    "Blah blah %d\n", i);
>                 else
>                         do_something_very_important();
>         }
>
> That is, the condition to call do_something_very_important() is
> condition && !debug, and not !condition as the code suggests. This is
> only an example and your driver doesn't currently use any such
> construct. Still I believe this should be fixed.

With your explanation, you've convinced me. I was not sure on how
should I handle this warning as I copied this macro from one in hid.
I will fix the two then.

>
> (...)
> static int i2c_hid_alloc_buffers(struct i2c_hid *ihid)
> {
>         /* the worst case is computed from the set_report command with a
>          * reportID > 15 and the maximum report length */
>         int args_len = sizeof(__u8) + /* optional ReportID byte */
>                        sizeof(__u16) + /* data register */
>                        sizeof(__u16) + /* size of the report */
>                        ihid->bufsize; /* report */
>
>         ihid->inbuf = kzalloc(ihid->bufsize, GFP_KERNEL);
>         ihid->argsbuf = kzalloc(args_len, GFP_KERNEL);
>         ihid->cmdbuf = kzalloc(sizeof(union command) + args_len, GFP_KERNEL);
>
>         if (!ihid->inbuf || !ihid->argsbuf || !ihid->cmdbuf) {
>                 i2c_hid_free_buffers(hid);
>                 return -ENOMEM;
>         }
>
>         return 0;
> }

Much better, thanks!

>
>> +static void i2c_hid_free_buffers(struct i2c_hid *ihid)
>> +{
>> +     kfree(ihid->inbuf);
>> +     kfree(ihid->argsbuf);
>> +     kfree(ihid->cmdbuf);
>> +     ihid->inbuf = NULL;
>> +     ihid->cmdbuf = NULL;
>> +     ihid->argsbuf = NULL;
>> +}
>> +
>> +static int i2c_hid_get_raw_report(struct hid_device *hid,
>> +             unsigned char report_number, __u8 *buf, size_t count,
>> +             unsigned char report_type)
>> +{
>> +     struct i2c_client *client = hid->driver_data;
>> +     struct i2c_hid *ihid = i2c_get_clientdata(client);
>> +     int ret;
>> +
>> +     if (report_type == HID_OUTPUT_REPORT)
>> +             return -EINVAL;
>> +
>> +     if (count > ihid->bufsize)
>> +             count = ihid->bufsize;
>> +
>> +     ret = i2c_hid_get_report(client,
>> +                     report_type == HID_FEATURE_REPORT ? 0x03 : 0x01,
>> +                     report_number, ihid->inbuf, count);
>> +
>> +     if (ret < 0)
>> +             return ret;
>> +
>> +     count = ihid->inbuf[0] | (ihid->inbuf[1] << 8);
>> +
>> +     memcpy(buf, ihid->inbuf + 2, count);
>
> What guarantee do you have that count is not larger than buf's length?
> I hope you don't just count on all hardware out there being nice and
> sane, do you? ;)

Hehe, this function is never called from the device, but from the user
space. It's called by hidraw_get_report in drivers/hid/hidraw.c, and
the caller makes the allocation of buf with a size of count.
There is an other usage in hid-input.c with "buf, sizeof(buf)," as arguments.
So this should never be a problem as long as anybody else call this
function without making sure count is the right size.

>
>> +
>> +     return count;
>> +}
>(...)
>> +static int __devinit i2c_hid_init_irq(struct i2c_client *client)
>> +{
>> +     struct i2c_hid *ihid = i2c_get_clientdata(client);
>> +     int ret;
>> +
>> +     dev_dbg(&client->dev, "Requesting IRQ: %d\n", client->irq);
>> +
>> +     ret = request_threaded_irq(client->irq, NULL, i2c_hid_irq,
>> +                     IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
>> +                     client->name, ihid);
>> +     if (ret < 0) {
>> +             dev_dbg(&client->dev,
>> +                     "Could not register for %s interrupt, irq = %d,"
>> +                     " ret = %d\n",
>> +             client->name, client->irq, ret);
>
> dev_warn()? Indentation is broken too.
>
>> +
>> +             return ret;
>> +     }
>> +
>> +     ihid->irq = client->irq;
>
> I don't think you need this. Everywhere you use ihid->irq, you have
> client at hand so you could as well use client->irq. This would avoid
> inconsistencies like free_irq(ihid->irq, ihid) in probing error path
> vs. free_irq(client->irq, ihid) in removal path, or
> enable_irq_wake(ihid->irq) vs. disable_irq_wake(client->irq) in
> suspend/resume.

Yep, these inconsistency are pretty bad. IIRC, I used that to know if
the setup was fine for the irq, but it may comes from an earlier
version where I had polling, which is not allowed by the spec.
So definitively, I'll have to rework that.

>
>> +
>> +     return 0;
>> +}
>> +
>(...)
>> +static int __devexit i2c_hid_remove(struct i2c_client *client)
>> +{
>> +     struct i2c_hid *ihid = i2c_get_clientdata(client);
>> +     struct hid_device *hid;
>> +
>> +     if (WARN_ON(!ihid))
>> +             return -1;
>
> This just can't happen...?
>
>> +
>> +     hid = ihid->hid;
>> +     hid_destroy_device(hid);
>> +
>> +     free_irq(client->irq, ihid);
>> +
>
> Is there any guarantee that i2c_hid_stop() has been called before
> i2c_hid_remove() is? If not, you're missing a call to
> i2c_hid_free_buffers() here. BTW I'm not quite sure why
> i2c_hid_remove() frees the buffers in the first place, but then again I
> don't know a thing about the HID infrastructure.

Calling i2c_hid_stop() is the responsibility of the hid driver at his
remove. By hid driver, I mean the driver that relies on hid to handle
the device (hid-generic in 80% of the cases) So as long as this hid
driver is loaded, we can not remove i2c_hid as it is used by the hid
driver. So it seems that this guarantees that i2c_hid_stop() has been
called before i2c_hid_remove() is.

But now that I think of it, there are cases where i2c_hid_stop() is
not called: when the hid driver failed to probe. So definitively,
there is a mem leak here. Thanks.


>
>> +     kfree(ihid);
>> +
>> +     return 0;
>> +}
>> +(...)
>> +static const struct i2c_device_id i2c_hid_id_table[] = {
>> +     { "i2c_hid", 0 },
>
> I am just realizing "i2c_hid" is a little redundant as an i2c device
> name. Can we make this just "hid"?

I know that it already have been used by one Nvidia team and by Elan
for internal tests. So I don't know if it's possible to change it now
(though it's not a big deal).
Anyway, "hid" is a little weird to me (but this is because I started
hacking the kernel from there), as it's really short and does not
contain i2c :)

Cheers,
Benjamin

>
>> +     { },
>> +};
>> +MODULE_DEVICE_TABLE(i2c, i2c_hid_id_table);
>
> --
> Jean Delvare

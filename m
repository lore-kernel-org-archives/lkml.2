Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015Ab2LCNl1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 08:41:27 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:60245 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754937Ab2LCNlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 08:41:24 -0500
MIME-Version: 1.0
In-Reply-To: <20121203140226.0fede51e@endymion.delvare>
References: <1352731379-24683-1-git-send-email-benjamin.tissoires@gmail.com>
	<20121130155650.69407e9f@endymion.delvare>
	<CAN+gG=FjVswyx1W4y6NtbNnBu2AWgZZfxVr0h00ZYujCOz3v7Q@mail.gmail.com>
	<20121203140226.0fede51e@endymion.delvare>
Date: Mon, 3 Dec 2012 14:41:22 +0100
Message-ID: <CAN+gG=F5jae=UFDR4-zZY-dt6KGE22QgmWiF2RkVvqN0ySX-kQ@mail.gmail.com>
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

On Mon, Dec 3, 2012 at 2:02 PM, Jean Delvare <khali@linux-fr.org> wrote:
> Hi Benjamin,
>
> On Mon, 3 Dec 2012 12:32:03 +0100, Benjamin Tissoires wrote:
>> Hi Jean,
>>
>> On Fri, Nov 30, 2012 at 3:56 PM, Jean Delvare <khali@linux-fr.org> wrote:
>> > Hi Benjamin, Jiri,
>> >
>> > Sorry for the late review. But better late than never I guess...
>>
>> Sure! Thanks for the review. As the driver is already in Jiri's tree,
>> I'll do small incremental patches based on this release.
>>
>> I'll try to address all of your comments.
>>
>> I have a few answers to some of your remarks (I fully agree with all
>> of the others):
>>
>> > On Mon, 12 Nov 2012 15:42:59 +0100, Benjamin Tissoires wrote:
>> >> +static int i2c_hid_get_raw_report(struct hid_device *hid,
>> >> +             unsigned char report_number, __u8 *buf, size_t count,
>> >> +             unsigned char report_type)
>> >> +{
>> >> +     struct i2c_client *client = hid->driver_data;
>> >> +     struct i2c_hid *ihid = i2c_get_clientdata(client);
>> >> +     int ret;
>> >> +
>> >> +     if (report_type == HID_OUTPUT_REPORT)
>> >> +             return -EINVAL;
>> >> +
>> >> +     if (count > ihid->bufsize)
>> >> +             count = ihid->bufsize;
>> >> +
>> >> +     ret = i2c_hid_get_report(client,
>> >> +                     report_type == HID_FEATURE_REPORT ? 0x03 : 0x01,
>> >> +                     report_number, ihid->inbuf, count);
>> >> +
>> >> +     if (ret < 0)
>> >> +             return ret;
>> >> +
>> >> +     count = ihid->inbuf[0] | (ihid->inbuf[1] << 8);
>> >> +
>> >> +     memcpy(buf, ihid->inbuf + 2, count);
>> >
>> > What guarantee do you have that count is not larger than buf's length?
>> > I hope you don't just count on all hardware out there being nice and
>> > sane, do you? ;)
>>
>> Hehe, this function is never called from the device, but from the user
>> space. It's called by hidraw_get_report in drivers/hid/hidraw.c, and
>> the caller makes the allocation of buf with a size of count.
>> There is an other usage in hid-input.c with "buf, sizeof(buf)," as arguments.
>> So this should never be a problem as long as anybody else call this
>> function without making sure count is the right size.
>
> Not sure I follow you here.
>
> There are two flavors of "count" in this function. The first one is
> passed as a parameter by the caller and used to set the buffer length
> as passed to i2c_hid_get_report(). This part is fine and I have no
> problem with it. The second flavor is extracted from ihid->inbuf as
> provided by i2c_hid_get_report(). As I understand it,
> i2c_hid_get_report() fills the buffer with data it receives from the
> hardware, so I fail to see how you can have any guarantee that this
> second flavor of count is not greater than buf's length.
>
> In fact I don't think you should reuse "count" in the first place,
> that's confusing. Then, looking at the code again, I don't think the
> test "count > ihid->bufsize", and more generally changing the value of
> "count", makes sense. You don't care about the size of "buf" when
> calling i2c_hid_get_report(), you care about the size of ihid->inbuf,
> which should be at least 2 more than the size of "buf". You care about
> the size of "buf" _after_ the call to i2c_hid_get_report(), as you are
> copying the data from ihid->bufsize to "buf". This is precisely the
> check which I claim is missing.

Oops. Really sorry. You are perfectly right.
This mismatch comes from the reuse of count for 2 different purposes,
so it was not a good idea at all.

Will fix it. And thanks!


>
>> >> (...)
>> >> +
>> >> +     hid = ihid->hid;
>> >> +     hid_destroy_device(hid);
>> >> +
>> >> +     free_irq(client->irq, ihid);
>> >> +
>> >
>> > Is there any guarantee that i2c_hid_stop() has been called before
>> > i2c_hid_remove() is? If not, you're missing a call to
>> > i2c_hid_free_buffers() here. BTW I'm not quite sure why
>> > i2c_hid_remove() frees the buffers in the first place, but then again I
>> > don't know a thing about the HID infrastructure.
>>
>> Calling i2c_hid_stop() is the responsibility of the hid driver at his
>> remove. By hid driver, I mean the driver that relies on hid to handle
>> the device (hid-generic in 80% of the cases) So as long as this hid
>> driver is loaded, we can not remove i2c_hid as it is used by the hid
>> driver. So it seems that this guarantees that i2c_hid_stop() has been
>> called before i2c_hid_remove() is.
>>
>> But now that I think of it, there are cases where i2c_hid_stop() is
>> not called: when the hid driver failed to probe. So definitively,
>> there is a mem leak here. Thanks.
>
> Actually this path was fixed by Jiri already:
> http://git.kernel.org/?p=linux/kernel/git/jikos/hid.git;a=commitdiff;h=3c62602434c13744df62b3ab0ab7950cd36f24db

Not exactly. This commit fixes the memory leak when i2c_hid_probe
fails. Not when the hid driver (hid-generic or hid-multitouch in our
cases) fails.

>
> My worry was that, when probe succeeds, i2c_hid_start/stop() could
> never be called if the module was unloaded immediately for example,
> before user-space has a chance to use the device. But if you are
> certain it can't happen, then alright.

I made a few tests after sending the mail. Contrary to what I said,
it's possible to unload the i2c-hid module before the hid module. But
in this case, the function i2c_hid_stop() is called.

So the only missing case is when no hid driver use the module (either
because it has failed or because it's not loaded). As
i2c_hid_alloc_buffer is called in the probe, we should dealloc them in
.remove.

>
>> >> +(...)
>> >> +static const struct i2c_device_id i2c_hid_id_table[] = {
>> >> +     { "i2c_hid", 0 },
>> >
>> > I am just realizing "i2c_hid" is a little redundant as an i2c device
>> > name. Can we make this just "hid"?
>>
>> I know that it already have been used by one Nvidia team and by Elan
>> for internal tests. So I don't know if it's possible to change it now
>> (though it's not a big deal).
>
> Yes it is possible, as long as the code isn't in Linus' tree (and I'd
> even say: as long as it is not in any kernel released by Linus.)
> Whoever is already using your driver will have to adjust their code.
> They'll certainly want to anyway, in order to get the bug fixes.
>
>> Anyway, "hid" is a little weird to me (but this is because I started
>> hacking the kernel from there), as it's really short and does not
>> contain i2c :)
>
> This is exactly my point: no other i2c client (to my knowledge) has
> "i2c" in its name, because it is redundant.
>
> I would agree that this is kind of a special case as this is a generic
> driver and not a device-specific driver. I would still prefer "hid" but
> if you don't feel like changing it, I guess I can live with that.

Ok, I'll change the name.
My concerns were just because from my point of view, "hid" refers to
the core implementation. But for OEMs, they need to declare a "hid"
device, so it makes sense. Anyway, when I'll be able to get my hand on
an ACPI 5 device with hid over i2c, I'll be able to write the missing
autoloading code, and this name will be only used by a small part of
OEMs (I hope).

Cheers,
Benjamin

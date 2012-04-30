Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118Ab2D3OpB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 10:45:01 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46734 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901Ab2D3Oo7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 10:44:59 -0400
MIME-Version: 1.0
In-Reply-To: <CAE7qMrqEJmBWo7JDHuB2DnWJ4vkvv9jya7RDJguiXsrs2xgadQ@mail.gmail.com>
References: <1335097300-11881-1-git-send-email-rydberg@euromail.se>
	<1335097300-11881-3-git-send-email-rydberg@euromail.se>
	<CAE7qMrqEJmBWo7JDHuB2DnWJ4vkvv9jya7RDJguiXsrs2xgadQ@mail.gmail.com>
Date: Mon, 30 Apr 2012 16:44:58 +0200
Message-ID: <CAN+gG=EDbtZkRZ+zr6awvK8fDYdV-c59On8B3O=vSMYhdQs_cw@mail.gmail.com>
Subject: Re: [PATCH 2/3] hid-logitech: Collect report descriptors before sending
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Nestor Lopez Casado <nlopezcasad@logitech.com>
Cc: Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Henrik,

I've been able to test the changes with different Logitech mice and keyboards.

So Jiri,
Tested-By: Benjamin Tissoires <benjamin.tissoires@gmail.com
for this change and this patch and the 3rd one (Hid: Handle
driver-specific device descriptor in core).

Cheers,
Benjamin

On Mon, Apr 23, 2012 at 15:23, Nestor Lopez Casado
<nlopezcasad@logitech.com> wrote:
> This change looks good to me. I can't test right now, but I will check as
> soon as I have some time to work on our kernel drivers again.
>
> Nestor.
>
>
> On Sun, Apr 22, 2012 at 2:21 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
>>
>> The current code allows several consecutive calls to hid_parse_report(),
>> which may have happened to work before, but would cause a memory leak
>> and generally be incorrect. This patch collects all the reports
>> before sending them once.
>>
>> Compiled, not tested.
>>
>> Cc: Nestor Lopez Casado <nlopezcasad@logitech.com>
>> Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>
>> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
>> ---
>>  drivers/hid/hid-logitech-dj.c |   71
>> +++++++++++++++++------------------------
>>  1 file changed, 29 insertions(+), 42 deletions(-)
>>
>> diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
>> index 2b56efc..e1c38bb 100644
>> --- a/drivers/hid/hid-logitech-dj.c
>> +++ b/drivers/hid/hid-logitech-dj.c
>> @@ -155,6 +155,14 @@ static const char media_descriptor[] = {
>>  /* Maximum size of all defined hid reports in bytes (including report id)
>> */
>>  #define MAX_REPORT_SIZE 8
>>
>> +/* Make sure all descriptors are present here */
>> +#define MAX_RDESC_SIZE                         \
>> +       (sizeof(kbd_descriptor) +               \
>> +        sizeof(mse_descriptor) +               \
>> +        sizeof(consumer_descriptor) +          \
>> +        sizeof(syscontrol_descriptor) +        \
>> +        sizeof(media_descriptor))
>> +
>>  /* Number of possible hid report types that can be created by this
>> driver.
>>  *
>>  * Right now, RF report types have the same report types (or report id's)
>> @@ -473,9 +481,17 @@ static int logi_dj_output_hidraw_report(struct
>> hid_device *hid, u8 * buf,
>>        return 0;
>>  }
>>
>> +static void rdcat(char **rdesc, unsigned int *rsize, const char *data,
>> unsigned int size)
>> +{
>> +       memcpy(*rdesc + *rsize, data, size);
>> +       *rsize += size;
>> +}
>> +
>>  static int logi_dj_ll_parse(struct hid_device *hid)
>>  {
>>        struct dj_device *djdev = hid->driver_data;
>> +       unsigned int rsize = 0;
>> +       char *rdesc;
>>        int retval;
>>
>>        dbg_hid("%s\n", __func__);
>> @@ -483,70 +499,38 @@ static int logi_dj_ll_parse(struct hid_device *hid)
>>        djdev->hdev->version = 0x0111;
>>        djdev->hdev->country = 0x00;
>>
>> +       rdesc = kmalloc(MAX_RDESC_SIZE, GFP_KERNEL);
>> +       if (!rdesc)
>> +               return -ENOMEM;
>> +
>>        if (djdev->reports_supported & STD_KEYBOARD) {
>>                dbg_hid("%s: sending a kbd descriptor, reports_supported:
>> %x\n",
>>                        __func__, djdev->reports_supported);
>> -               retval = hid_parse_report(hid,
>> -                                         (u8 *) kbd_descriptor,
>> -                                         sizeof(kbd_descriptor));
>> -               if (retval) {
>> -                       dbg_hid("%s: sending a kbd descriptor, hid_parse
>> failed"
>> -                               " error: %d\n", __func__, retval);
>> -                       return retval;
>> -               }
>> +               rdcat(&rdesc, &rsize, kbd_descriptor,
>> sizeof(kbd_descriptor));
>>        }
>>
>>        if (djdev->reports_supported & STD_MOUSE) {
>>                dbg_hid("%s: sending a mouse descriptor, reports_supported:
>> "
>>                        "%x\n", __func__, djdev->reports_supported);
>> -               retval = hid_parse_report(hid,
>> -                                         (u8 *) mse_descriptor,
>> -                                         sizeof(mse_descriptor));
>> -               if (retval) {
>> -                       dbg_hid("%s: sending a mouse descriptor, hid_parse
>> "
>> -                               "failed error: %d\n", __func__, retval);
>> -                       return retval;
>> -               }
>> +               rdcat(&rdesc, &rsize, mse_descriptor,
>> sizeof(mse_descriptor));
>>        }
>>
>>        if (djdev->reports_supported & MULTIMEDIA) {
>>                dbg_hid("%s: sending a multimedia report descriptor: %x\n",
>>                        __func__, djdev->reports_supported);
>> -               retval = hid_parse_report(hid,
>> -                                         (u8 *) consumer_descriptor,
>> -                                         sizeof(consumer_descriptor));
>> -               if (retval) {
>> -                       dbg_hid("%s: sending a consumer_descriptor,
>> hid_parse "
>> -                               "failed error: %d\n", __func__, retval);
>> -                       return retval;
>> -               }
>> +               rdcat(&rdesc, &rsize, consumer_descriptor,
>> sizeof(consumer_descriptor));
>>        }
>>
>>        if (djdev->reports_supported & POWER_KEYS) {
>>                dbg_hid("%s: sending a power keys report descriptor: %x\n",
>>                        __func__, djdev->reports_supported);
>> -               retval = hid_parse_report(hid,
>> -                                         (u8 *) syscontrol_descriptor,
>> -                                         sizeof(syscontrol_descriptor));
>> -               if (retval) {
>> -                       dbg_hid("%s: sending a syscontrol_descriptor, "
>> -                               "hid_parse failed error: %d\n",
>> -                               __func__, retval);
>> -                       return retval;
>> -               }
>> +               rdcat(&rdesc, &rsize, syscontrol_descriptor,
>> sizeof(syscontrol_descriptor));
>>        }
>>
>>        if (djdev->reports_supported & MEDIA_CENTER) {
>>                dbg_hid("%s: sending a media center report descriptor:
>> %x\n",
>>                        __func__, djdev->reports_supported);
>> -               retval = hid_parse_report(hid,
>> -                                         (u8 *) media_descriptor,
>> -                                         sizeof(media_descriptor));
>> -               if (retval) {
>> -                       dbg_hid("%s: sending a media_descriptor, hid_parse
>> "
>> -                               "failed error: %d\n", __func__, retval);
>> -                       return retval;
>> -               }
>> +               rdcat(&rdesc, &rsize, media_descriptor,
>> sizeof(media_descriptor));
>>        }
>>
>>        if (djdev->reports_supported & KBD_LEDS) {
>> @@ -554,7 +538,10 @@ static int logi_dj_ll_parse(struct hid_device *hid)
>>                        __func__, djdev->reports_supported);
>>        }
>>
>> -       return 0;
>> +       retval = hid_parse_report(hid, rdesc, rsize);
>> +       kfree(rdesc);
>> +
>> +       return retval;
>>  }
>>
>>  static int logi_dj_ll_input_event(struct input_dev *dev, unsigned int
>> type,
>> --
>> 1.7.10
>>
>

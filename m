Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab2LEKHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 05:07:23 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35533 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648Ab2LEKHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 05:07:19 -0500
MIME-Version: 1.0
In-Reply-To: <20121205105917.291f483f@endymion.delvare>
References: <1354634875-5182-1-git-send-email-benjamin.tissoires@gmail.com>
	<1354634875-5182-10-git-send-email-benjamin.tissoires@gmail.com>
	<20121205105917.291f483f@endymion.delvare>
Date: Wed, 5 Dec 2012 11:07:17 +0100
Message-ID: <CAN+gG=EqRgaUCg=Af_LtU6ez+x+gf=s+TM2h5v9dtTx0uQwLHg@mail.gmail.com>
Subject: Re: [PATCH 09/14] HID: i2c-hid: i2c_hid_get_report may fail
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 5, 2012 at 10:59 AM, Jean Delvare <khali@linux-fr.org> wrote:
> On Tue,  4 Dec 2012 16:27:50 +0100, Benjamin Tissoires wrote:
>> If i2c_hid_get_report fails, exit i2c_hid_init_report.
>> The printk log is already called by i2c_hid_get_report, so no need
>> to add some more printks.
>>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
>> ---
>>  drivers/hid/i2c-hid/i2c-hid.c | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
>> index da04948..dcacfc4 100644
>> --- a/drivers/hid/i2c-hid/i2c-hid.c
>> +++ b/drivers/hid/i2c-hid/i2c-hid.c
>> @@ -400,9 +400,10 @@ static void i2c_hid_init_report(struct hid_report *report, u8 *buffer,
>>       unsigned int size, ret_size;
>>
>>       size = i2c_hid_get_report_length(report);
>> -     i2c_hid_get_report(client,
>> +     if (i2c_hid_get_report(client,
>>                       report->type == HID_FEATURE_REPORT ? 0x03 : 0x01,
>> -                     report->id, buffer, size);
>> +                     report->id, buffer, size))
>> +             return;
>>
>>       i2c_hid_dbg(ihid, "report (len=%d): %*ph\n", size, size, ihid->inbuf);
>>
>
> OK, although I don't quite get the rationale for not reporting the
> errors from i2c_hid_init_report() and i2c_hid_init_reports() to their
> respective callers. Does the device have any chance to work properly if
> i2c_hid_init_reports() fails?

Hi Jean,

first thanks for the review you have started.

For your question, the answer is yes, the device works properly even
if i2c_hid_init_reports().
IIRC, the only required steps are:
- get HID descriptor
- get HID report descriptors
- send reset
- set power on

 i2c_hid_init_reports is not part of the specification for the boot
process, and the Windows driver does not retrieve the reports for
input reports at all (it does it though for the features).
Actually, the device I have does not implement get_report for inputs
(it returns 0), but it's not a problem for it to work.

I put the whole init_reports in place to get the features values
before sending them to the hid driver, and also to copy the behavior
of usbhid.

Cheers,
Benjamin

>
> Reviewed-by: Jean Delvare <khali@linux-fr.org>
>
> --
> Jean Delvare

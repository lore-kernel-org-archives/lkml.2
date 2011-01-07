Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab1AGJor (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 04:44:47 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:51284 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706Ab1AGJop convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 04:44:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=q7CeEICc/g+bWAQZj0/w6iObdwXerr6aBrMLuALxGkUHR9WOZD/3+EjkJmX1aYwC3F
         aZpuL48oQKo+inNmqlHvodHrqiGe0rM4KPUYslXMPBFfHb5smyoO7hGsNLuktl7/wqlx
         271Y3aliqy/JFhZGh5LG8gSBGMa0a2qXHqCgE=
MIME-Version: 1.0
In-Reply-To: <20110106162223.GB1790@polaris.bitmath.org>
References: <1294248468-19979-1-git-send-email-benjamin.tissoires@enac.fr>
	<1294248468-19979-2-git-send-email-benjamin.tissoires@enac.fr>
	<20110106162223.GB1790@polaris.bitmath.org>
Date: Fri, 7 Jan 2011 10:44:43 +0100
X-Google-Sender-Auth: GPJz2O95BIXa66Qu9s4pORK6-Fg
Message-ID: <AANLkTi=xdPJP9okhRL8q-0vL5cVPKniAjve6BQHmB=+p@mail.gmail.com>
Subject: Re: [RFC v2 01/10] hid: add feature_mapping callback
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Stephane Chatty <chatty@enac.fr>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 6, 2011 at 5:22 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> On Wed, Jan 05, 2011 at 06:27:39PM +0100, Benjamin Tissoires wrote:
>> Currently hid doesn't export the features it knows to the specific modules.
>> Some information can be really important in such features: MosArt and
>> Cypress devices are by default not in a multitouch mode.
>> We have to send the value 2 on the right feature.
>>
>> This patch exports to the module the features report so they can find the
>> right feature to set up the correct mode.
>>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
>> ---
>>  drivers/hid/hid-input.c |   10 +++++++++-
>>  include/linux/hid.h     |    4 ++++
>>  2 files changed, 13 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
>> index bb0b365..07d8cb2 100644
>> --- a/drivers/hid/hid-input.c
>> +++ b/drivers/hid/hid-input.c
>> @@ -287,6 +287,14 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
>>               goto ignore;
>>       }
>>
>> +     if (field->report_type == HID_FEATURE_REPORT) {
>> +             if (device->driver->feature_mapping) {
>> +                     device->driver->feature_mapping(device, hidinput, field,
>> +                                usage);
>> +             }
>> +             goto ignore;
>> +     }
>> +
>>       if (device->driver->input_mapping) {
>>               int ret = device->driver->input_mapping(device, hidinput, field,
>>                               usage, &bit, &max);
>> @@ -836,7 +844,7 @@ int hidinput_connect(struct hid_device *hid, unsigned int force)
>>       struct hid_input *hidinput = NULL;
>>       struct input_dev *input_dev;
>>       int i, j, k;
>> -     int max_report_type = HID_OUTPUT_REPORT;
>> +     int max_report_type = HID_FEATURE_REPORT;
>
> Doing it this way conflicts with the HID_QUIRK_SKIP_OUTPUT_REPORTS quirk.


Do you agree on this way? (will send the patch in the next version)

@@ -834,11 +842,10 @@ int hidinput_connect(struct hid_device *hid,
unsigned int force)
 {
 	struct hid_report *report;
 	struct hid_input *hidinput = NULL;
 	struct input_dev *input_dev;
 	int i, j, k;
-	int max_report_type = HID_OUTPUT_REPORT;

 	INIT_LIST_HEAD(&hid->inputs);

 	if (!force) {
 		for (i = 0; i < hid->maxcollection; i++) {
@@ -851,14 +858,14 @@ int hidinput_connect(struct hid_device *hid,
unsigned int force)

 		if (i == hid->maxcollection)
 			return -1;
 	}

-	if (hid->quirks & HID_QUIRK_SKIP_OUTPUT_REPORTS)
-		max_report_type = HID_INPUT_REPORT;
+	for (k = HID_INPUT_REPORT; k <= HID_FEATURE_REPORT; k++)
+		if (hid->quirks & HID_QUIRK_SKIP_OUTPUT_REPORTS)
+			continue;

-	for (k = HID_INPUT_REPORT; k <= max_report_type; k++)
 		list_for_each_entry(report, &hid->report_enum[k].report_list, list) {

 			if (!report->maxfield)
 				continue;

Cheers,
Benjamin
>
>>
>>       INIT_LIST_HEAD(&hid->inputs);
>>
>> diff --git a/include/linux/hid.h b/include/linux/hid.h
>> index bb0f56f..75303b0 100644
>> --- a/include/linux/hid.h
>> +++ b/include/linux/hid.h
>> @@ -593,6 +593,7 @@ struct hid_usage_id {
>>   * @report_fixup: called before report descriptor parsing (NULL means nop)
>>   * @input_mapping: invoked on input registering before mapping an usage
>>   * @input_mapped: invoked on input registering after mapping an usage
>> + * @feature_mapping: invoked on feature registering
>>   * @suspend: invoked on suspend (NULL means nop)
>>   * @resume: invoked on resume if device was not reset (NULL means nop)
>>   * @reset_resume: invoked on resume if device was reset (NULL means nop)
>> @@ -636,6 +637,9 @@ struct hid_driver {
>>       int (*input_mapped)(struct hid_device *hdev,
>>                       struct hid_input *hidinput, struct hid_field *field,
>>                       struct hid_usage *usage, unsigned long **bit, int *max);
>> +     void (*feature_mapping)(struct hid_device *hdev,
>> +                     struct hid_input *hidinput, struct hid_field *field,
>> +                     struct hid_usage *usage);
>>  #ifdef CONFIG_PM
>>       int (*suspend)(struct hid_device *hdev, pm_message_t message);
>>       int (*resume)(struct hid_device *hdev);
>
> Thanks,
> Henrik
>

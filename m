Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab1CKHHX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 02:07:23 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49754 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab1CKHHU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 02:07:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=SCLJ92ghes4jvCJKF6HvyNqvkM80j/EFnFV/ESLjOo4snMNSrh6gPobym0fiftP1S2
         d1nPSaugq6SbasCEx61+ZH2LY9AdTxcti+0GWoQQO9zBM9okAVRdKeM+mpWZqhHUg5H8
         VxkToGM9ydpc9e3DT5pEh/eedb2/WCp1mS7vw=
MIME-Version: 1.0
In-Reply-To: <20110310124530.GA3378@polaris.bitmath.org>
References: <1299686450-5475-1-git-send-email-benjamin.tissoires@enac.fr>
	<1299686450-5475-2-git-send-email-benjamin.tissoires@enac.fr>
	<20110310124530.GA3378@polaris.bitmath.org>
Date: Fri, 11 Mar 2011 08:07:18 +0100
X-Google-Sender-Auth: znP2-kBFZ82hBrW_Sy_VzISOluI
Message-ID: <AANLkTinL4TL_BMv_1KwCjKwbEthj6Ho1L8UvM2ad1t0x@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] hid-multitouch: Auto detection of maxcontacts
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

thanks for the review.

On Thu, Mar 10, 2011 at 13:45, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Benjamin,
>
> thanks for this, just a couple of things...
>
>> @@ -126,9 +127,19 @@ struct mt_class mt_classes[] = {
>>  static void mt_feature_mapping(struct hid_device *hdev,
>>               struct hid_field *field, struct hid_usage *usage)
>>  {
>> -     if (usage->hid == HID_DG_INPUTMODE) {
>> -             struct mt_device *td = hid_get_drvdata(hdev);
>> +     struct mt_device *td = hid_get_drvdata(hdev);
>> +
>> +     switch (usage->hid) {
>> +     case HID_DG_INPUTMODE:
>>               td->inputmode = field->report->id;
>> +             break;
>> +     case HID_DG_CONTACTMAX:
>> +             td->maxcontacts = *(field->value);
>
> field->value[0] seems more standard-ish

If you want

>
>> +             if (td->mtclass->maxcontacts > td->maxcontacts)
>> +                     /* check if the maxcontacts is given by the class */
>> +                     td->maxcontacts = td->mtclass->maxcontacts;
>> +
>> +             break;
>>       }
>>  }
>>
>> @@ -317,7 +327,7 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
>>       struct mt_device *td = hid_get_drvdata(hid);
>>       __s32 quirks = td->mtclass->quirks;
>>
>> -     if (hid->claimed & HID_CLAIMED_INPUT) {
>> +     if (hid->claimed & HID_CLAIMED_INPUT && td->slots) {
>
> The extra test could in principle be placed after the usage switch, which would prevent partially filled contact data, should this ever occur. Something like
>
> if (!td->slots)
>   break;

I don't know where these "break" comes from. We can add the test after
the switch before the mt_complete_slot and mt_emit_event. But please
note than it can in all cases introduce truncated slots reports as all
the slots in the report may not have been completed. To be honest, I'm
not sure this will ever matter as it's a race at the connection of the
device, and the reports will come to correct anything wrong.

>
>>               switch (usage->hid) {
>>               case HID_DG_INRANGE:
>>                       if (quirks & MT_QUIRK_VALID_IS_INRANGE)
>> @@ -415,9 +425,7 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
>>        */
>>       hdev->quirks |= HID_QUIRK_NO_INPUT_SYNC;
>>
>> -     td = kzalloc(sizeof(struct mt_device) +
>> -                             mtclass->maxcontacts * sizeof(struct mt_slot),
>> -                             GFP_KERNEL);
>> +     td = kzalloc(sizeof(struct mt_device), GFP_KERNEL);
>>       if (!td) {
>>               dev_err(&hdev->dev, "cannot allocate multitouch data\n");
>>               return -ENOMEM;
>> @@ -434,6 +442,14 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
>>       if (ret)
>>               goto fail;
>>
>> +     td->slots = kzalloc(td->maxcontacts * sizeof(struct mt_slot),
>> +                             GFP_KERNEL);
>> +     if (!td->slots) {
>> +             dev_err(&hdev->dev, "cannot allocate multitouch slots\n");
>> +             ret = -ENOMEM;
>> +             goto fail;
>
> This exit leaves the device running.

Yep, will do sth.

Thanks
Benjamin

>
>> +     }
>> +
>>       mt_set_input_mode(hdev);
>>
>>       return 0;
>> @@ -455,6 +471,7 @@ static void mt_remove(struct hid_device *hdev)
>>  {
>>       struct mt_device *td = hid_get_drvdata(hdev);
>>       hid_hw_stop(hdev);
>> +     kfree(td->slots);
>>       kfree(td);
>>       hid_set_drvdata(hdev, NULL);
>>  }
>> --
>> 1.7.4
>>
>
> Thanks,
> Henrik
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab1A0MtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 07:49:21 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48866 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab1A0MtU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 07:49:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=fNJUTR/Zk+d/sa1AGEhjhwwbECFkMkCTVad1Xr77ooa84LKtqzXNKtFKgqdPhIzhjT
         ceZrGKsO3ePRujNVPI+NpaMC5UqFz9CbDHpeJtl43BUN1BU3G0HbcmHpoFOw21pKhEpY
         NMUyClOtJcD9OxyP5QjqlpeNOLXfVzjUjYlno=
MIME-Version: 1.0
In-Reply-To: <20110127120603.GB15626@polaris.bitmath.org>
References: <1296124547-3323-1-git-send-email-benjamin.tissoires@enac.fr>
	<1296124547-3323-2-git-send-email-benjamin.tissoires@enac.fr>
	<20110127120603.GB15626@polaris.bitmath.org>
Date: Thu, 27 Jan 2011 13:49:18 +0100
X-Google-Sender-Auth: yYYBR1-5K5vM3ctXsHX2Gw73QEg
Message-ID: <AANLkTim7DbxhEO7vHPFcC1PFf=d2mSEyL+wurzUQa0pg@mail.gmail.com>
Subject: Re: [RFC 1/2] input: mt: Add method to extract the MT slot state
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ping Cheng <pingc@wacom.com>,
        Jiri Kosina <jkosina@suse.cz>, Chris Bagwell <chris@cnpbagwell.com>,
        Rafi Rubin <rafi@seas.upenn.edu>, Stephane Chatty <chatty@lii-enac.fr>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Thu, Jan 27, 2011 at 13:06, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Benjamin,
>
> On Thu, Jan 27, 2011 at 11:35:46AM +0100, Benjamin Tissoires wrote:
>> This patch adds the function input_mt_get_abs_value(), which may be
>
> Ehm, input_mt_get_absinfo?

In fact, the idea was to put this on the table again ;). I have no
idea of what is the right think to do in such case.
So I'll take all comments.

>
>> used to extract the current state of the MT slots.
>>
>> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
>
> I had rather re-add this myself, thanks.

That was my question. Plus I had a subliminal message in which I
intend you to take the drive on this work. ;)

>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
>> ---
>>  drivers/input/input-mt.c |   32 ++++++++++++++++++++++++++++++++
>>  include/linux/input/mt.h |    1 +
>>  2 files changed, 33 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/input/input-mt.c b/drivers/input/input-mt.c
>> index c48c81f..5b95e38 100644
>> --- a/drivers/input/input-mt.c
>> +++ b/drivers/input/input-mt.c
>> @@ -168,3 +168,35 @@ void input_mt_report_pointer_emulation(struct input_dev *dev, bool use_count)
>>       }
>>  }
>>  EXPORT_SYMBOL(input_mt_report_pointer_emulation);
>> +
>> +/**
>> + * input_mt_get_absinfo - retrieve MT state variables from a device slot
>> + * @dev: input device which state is being queried
>> + * @code: ABS code to retrieve
>> + * @slot: slot to retrieve from
>> + *
>> + * Return the ABS state of the given MT slot. If code is not an MT
>> + * event, the corresponding ABS event is returned.
>> + *
>> + * This function may be called by anyone interested in extracting the
>> + * current MT state. Used by evdev handlers.
>> + */
>> +struct input_absinfo input_mt_get_absinfo(struct input_dev *dev, unsigned int code, int slot)
>
> Why return the struct? Give it a pointer instead, so the return value
> can be used for errors.

Quick and dirty think. Maybe the old implementation is better.

>
> Also, I wonder about the usefulness of extracting the absinfo here -
> only the value depends on the slot argument, and absinfo does not
> require the same lock protection. Why not keep the layout from the
> original patch?

same above

>
>> +{
>> +     unsigned int mtmap = code > ABS_MT_FIRST ? code - ABS_MT_FIRST : 0;
>
> Should rather return -EINVAL on bad argument.

I did not know how to handle the original code:
"unsigned int mtmap = input_mt_abs_map[code];"

Now I know.

>
>> +     unsigned long flags;
>> +     struct input_absinfo retval;
>> +
>> +     spin_lock_irqsave(&dev->event_lock, flags);
>> +     if (!mtmap)
>> +             retval = dev->absinfo[code];
>> +     else if (slot >= 0 && slot < dev->mtsize) {
>> +             retval = dev->absinfo[code];
>> +             retval.value = dev->mt[slot].abs[mtmap];
>
> Please use input_mt_get_value().

This is a problem when working with code that was send 6 months ago.

>
>> +     } else
>> +             retval.value = 0;
>> +     spin_unlock_irqrestore(&dev->event_lock, flags);
>> +
>> +     return retval;
>> +}
>> +EXPORT_SYMBOL(input_mt_get_absinfo);
>> diff --git a/include/linux/input/mt.h b/include/linux/input/mt.h
>> index b3ac06a..a71a27f 100644
>> --- a/include/linux/input/mt.h
>> +++ b/include/linux/input/mt.h
>> @@ -54,4 +54,5 @@ void input_mt_report_slot_state(struct input_dev *dev,
>>  void input_mt_report_finger_count(struct input_dev *dev, int count);
>>  void input_mt_report_pointer_emulation(struct input_dev *dev, bool use_count);
>>
>> +struct input_absinfo input_mt_get_absinfo(struct input_dev *dev, unsigned int code, int slot);
>>  #endif
>
> Thanks,
> Henrik
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

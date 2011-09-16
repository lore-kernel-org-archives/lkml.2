Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab1IPFKy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 01:10:54 -0400
Received: from smtp-out.google.com ([74.125.121.67]:44347 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab1IPFKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 01:10:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:from:
	date:x-google-sender-auth:message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=tqnxg5l4nUIn13MU5NFNgYSVERuXXN5AW3Xj4I6kAiOz9rBZ8JiiqgqpHndb8RDJH
	zEAoFhlAPMRIuSS/Fgt8A==
MIME-Version: 1.0
In-Reply-To: <4E729DD4.8010208@samsung.com>
References: <1316115647-1244-1-git-send-email-djkurtz@chromium.org> <4E729DD4.8010208@samsung.com>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Fri, 16 Sep 2011 13:10:29 +0800
X-Google-Sender-Auth: GEWpyGOBL8ZCzU90fFyRwM2pKc8
Message-ID: <CAGS+omBkpTi34diCrp_99FPHaTpTT35baX6veOX2+B-RhR6QqQ@mail.gmail.com>
Subject: Re: [PATCH] Input: atmel_mxt_ts - Use snprintf for sysfs attribute
 show method
To: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Iiro Valkonen <iiro.valkonen@atmel.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Yufeng Shen <miletus@chromium.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p8G5BQFM032181

Hi Joonyoung,

Thanks for replying.

On Fri, Sep 16, 2011 at 8:52 AM, Joonyoung Shim <jy0922.shim@samsung.com> wrote:
> Hi,
>
> On 2011-09-16 오전 4:40, Daniel Kurtz wrote:
>>
>> Sysfs attribute show methods are always passed a buffer of length
>> PAGE_SIZE.  To keep from overwriting this buffer and causing havoc, use
>> snprintf() to guarantee we never write more than the buffer can hold.
>>
>> In addition, at least for my touchscreen, the number and size of objects
>> was far too big to fit in a single 4K page.  Therefore, this patch also
>> trims some redundant framing text to leave more room for actual data.
>>
>> Signed-off-by: Daniel Kurtz<djkurtz@chromium.org>
>
> This patch is working but original problem is object size is increasing
> as atmel touchscreen chip updates and we should consider also the
> instances of object.

"This patch is working" = Acked-By ?

> How about splitting attributes to each object?

I agree.  Can we do that in another patch (with instance printing)?

> Iiro, do you have any update plans about atmel touchscreen driver?

I have several more patches coming for this driver, mostly to speed up
startup time, cleanup the MT-B implementation, and optimize interrupt
handling.

Thanks,
Daniel

>> ---
>>  drivers/input/touchscreen/atmel_mxt_ts.c |   21 +++++++++++++++------
>>  1 files changed, 15 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c
>> b/drivers/input/touchscreen/atmel_mxt_ts.c
>> index f5d6685..a596c27 100644
>> --- a/drivers/input/touchscreen/atmel_mxt_ts.c
>> +++ b/drivers/input/touchscreen/atmel_mxt_ts.c
>> @@ -910,12 +910,17 @@ static ssize_t mxt_object_show(struct device *dev,
>>        for (i = 0; i<  data->info.object_num; i++) {
>>                object = data->object_table + i;
>>
>> -               count += sprintf(buf + count,
>> -                               "Object Table Element %d(Type %d)\n",
>> +               count += snprintf(buf + count, PAGE_SIZE - count,
>> +                               "Object[%d] (Type %d)\n",
>>                                i + 1, object->type);
>> +               if (count>= PAGE_SIZE)
>> +                       return PAGE_SIZE - 1;
>>
>>                if (!mxt_object_readable(object->type)) {
>> -                       count += sprintf(buf + count, "\n");
>> +                       count += snprintf(buf + count, PAGE_SIZE - count,
>> +                                       "\n");
>> +                       if (count>= PAGE_SIZE)
>> +                               return PAGE_SIZE - 1;
>>                        continue;
>>                }
>>
>> @@ -925,11 +930,15 @@ static ssize_t mxt_object_show(struct device *dev,
>>                        if (error)
>>                                return error;
>>
>> -                       count += sprintf(buf + count,
>> -                                       "  Byte %d: 0x%x (%d)\n", j, val,
>> val);
>> +                       count += snprintf(buf + count, PAGE_SIZE - count,
>> +                                       "\t[%2d]: %02x (%d)\n", j, val,
>> val);
>> +                       if (count>= PAGE_SIZE)
>> +                               return PAGE_SIZE - 1;
>>                }
>>
>> -               count += sprintf(buf + count, "\n");
>> +               count += snprintf(buf + count, PAGE_SIZE - count, "\n");
>> +               if (count>= PAGE_SIZE)
>> +                       return PAGE_SIZE - 1;
>>        }
>>
>>        return count;
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab1JSHkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 03:40:40 -0400
Received: from smtp-out.google.com ([216.239.44.51]:19330 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab1JSHkj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 03:40:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:from:
	date:x-google-sender-auth:message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=J7OXZGld78h/wy1MtDrKDYKXTuQYLbpInlyGeIKZup58fFW8+HM06D8piYP1wcRyy
	EYCt6XgIkThVrB6ww+GTg==
MIME-Version: 1.0
In-Reply-To: <1316115647-1244-1-git-send-email-djkurtz@chromium.org>
References: <1316115647-1244-1-git-send-email-djkurtz@chromium.org>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Wed, 19 Oct 2011 15:40:16 +0800
X-Google-Sender-Auth: u035HbfnpQBrGvB-fL2KzVMVfZw
Message-ID: <CAGS+omDJM700h22zsAQZRn_9qCcUk1gJsKN0GzQxG7FkK-PRsQ@mail.gmail.com>
Subject: Re: [PATCH] Input: atmel_mxt_ts - Use snprintf for sysfs attribute
 show method
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Iiro Valkonen <iiro.valkonen@atmel.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Yufeng Shen <miletus@chromium.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Daniel Kurtz <djkurtz@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

I fear the following patch, and its 'Acked-by' from Nick Dyer, may
have gotten lost:

On Fri, Sep 16, 2011 at 3:40 AM, Daniel Kurtz <djkurtz@chromium.org> wrote:
>
> Sysfs attribute show methods are always passed a buffer of length
> PAGE_SIZE.  To keep from overwriting this buffer and causing havoc, use
> snprintf() to guarantee we never write more than the buffer can hold.
>
> In addition, at least for my touchscreen, the number and size of objects
> was far too big to fit in a single 4K page.  Therefore, this patch also
> trims some redundant framing text to leave more room for actual data.
>
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> ---
>  drivers/input/touchscreen/atmel_mxt_ts.c |   21 +++++++++++++++------
>  1 files changed, 15 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
> index f5d6685..a596c27 100644
> --- a/drivers/input/touchscreen/atmel_mxt_ts.c
> +++ b/drivers/input/touchscreen/atmel_mxt_ts.c
> @@ -910,12 +910,17 @@ static ssize_t mxt_object_show(struct device *dev,
>        for (i = 0; i < data->info.object_num; i++) {
>                object = data->object_table + i;
>
> -               count += sprintf(buf + count,
> -                               "Object Table Element %d(Type %d)\n",
> +               count += snprintf(buf + count, PAGE_SIZE - count,
> +                               "Object[%d] (Type %d)\n",
>                                i + 1, object->type);
> +               if (count >= PAGE_SIZE)
> +                       return PAGE_SIZE - 1;
>
>                if (!mxt_object_readable(object->type)) {
> -                       count += sprintf(buf + count, "\n");
> +                       count += snprintf(buf + count, PAGE_SIZE - count,
> +                                       "\n");
> +                       if (count >= PAGE_SIZE)
> +                               return PAGE_SIZE - 1;
>                        continue;
>                }
>
> @@ -925,11 +930,15 @@ static ssize_t mxt_object_show(struct device *dev,
>                        if (error)
>                                return error;
>
> -                       count += sprintf(buf + count,
> -                                       "  Byte %d: 0x%x (%d)\n", j, val, val);
> +                       count += snprintf(buf + count, PAGE_SIZE - count,
> +                                       "\t[%2d]: %02x (%d)\n", j, val, val);
> +                       if (count >= PAGE_SIZE)
> +                               return PAGE_SIZE - 1;
>                }
>
> -               count += sprintf(buf + count, "\n");
> +               count += snprintf(buf + count, PAGE_SIZE - count, "\n");
> +               if (count >= PAGE_SIZE)
> +                       return PAGE_SIZE - 1;
>        }
>
>        return count;
> --
> 1.7.3.1
>

On Thu, Oct 6, 2011 at 5:59 PM, Nick Dyer <nick.dyer@itdev.co.uk> wrote:
> Hi Daniel-
>
> Just to introduce myself, I'm working for Atmel in UK on the atmel_mxt_ts
> driver.
>
> Daniel Kurtz wrote:
>> Sysfs attribute show methods are always passed a buffer of length
>> PAGE_SIZE.  To keep from overwriting this buffer and causing havoc,
>> use snprintf() to guarantee we never write more than the buffer can
>> hold.
>>
>> In addition, at least for my touchscreen, the number and size of
>> objects was far too big to fit in a single 4K page.  Therefore, this
>> patch also trims some redundant framing text to leave more room for
>> actual data.
>
> Yes, I'd noticed this problem as well. I was planning to address it by
> splitting up the file, but your patch looks like a good solution for now.
>
> I've tested it successfully on several chips.
>
> Acked-by: Nick Dyer <nick.dyer@itdev.co.uk>
>
> --
> Nick Dyer
> Software Engineer, ITDev  Ltd
>
> Hardware and Software Development Consultancy
>
> Email:   nick.dyer@itdev.co.uk
> Website: http://www.itdev.co.uk

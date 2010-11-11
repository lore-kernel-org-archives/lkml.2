Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649Ab0KKNmv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 08:42:51 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40049 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183Ab0KKNmu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 08:42:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rDhK/9hORkaJXUXjspzu4mRGikJmvZ8EJ9lDNekzIHI5ekbKZ714F7Ige3TmJPP+Zn
         AbjAEE/snWUq9ikCY2UhzXNo915nq4EFxjK0eF25PBX2hEx4/L+UZ+Aksd6NAnv1NruX
         nhYcfYWVxNJhmtG93kCAiQV7H829ekyrNEnls=
MIME-Version: 1.0
In-Reply-To: <1289400533.2208.6.camel@cowboy>
References: <AANLkTi=butKgG8VktAu0V12aBKTetOJwiGkcTLG_RZWB@mail.gmail.com>
	<1289400533.2208.6.camel@cowboy>
Date: Thu, 11 Nov 2010 21:42:47 +0800
Message-ID: <AANLkTimSm687VOENtqBbrK+LyQYndGaLX4yB683=8C4G@mail.gmail.com>
Subject: Re: [PATCH] fix the poll method of bsg file operations in Block layer
 SCSI generic driver
From: Hillf Danton <dhillf@gmail.com>
To: dave@gnu.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Zou, Yi" <yi.zou@intel.com>, Joe Eykholt <jeykholt@cisco.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 10:48 PM, Davidlohr Bueso <dave@gnu.org> wrote:
> On Wed, 2010-11-10 at 21:58 +0800, Hillf Danton wrote:
>> Though it looks like a typo, the check for POLLOUT is computed incorrectly.
>>
>> Signed-off-by: Hillf Danton <dhillf@gmail.com>
>> ---
>>
>> --- a/block/bsg.c     2010-09-13 07:07:38.000000000 +0800
>> +++ b/block/bsg.c     2010-11-10 21:40:30.000000000 +0800
>> @@ -874,6 +874,8 @@ static unsigned int bsg_poll(struct file
>>       if (!list_empty(&bd->done_list))
>>               mask |= POLLIN | POLLRDNORM;
>>       if (bd->queued_cmds >= bd->max_queue)
>> +             ;
>> +     else
>>               mask |= POLLOUT;
>>       spin_unlock_irq(&bd->lock);
>
> How about something more like this:
>
> diff --git a/block/bsg.c b/block/bsg.c
> index f20d6a7..2663db3 100644
> --- a/block/bsg.c
> +++ b/block/bsg.c
> @@ -870,7 +870,7 @@ static unsigned int bsg_poll(struct file *file,
> poll_table *wait)
>        spin_lock_irq(&bd->lock);
>        if (!list_empty(&bd->done_list))
>                mask |= POLLIN | POLLRDNORM;
> -       if (bd->queued_cmds >= bd->max_queue)
> +       if (bd->queued_cmds < bd->max_queue)
>                mask |= POLLOUT;
>        spin_unlock_irq(&bd->lock);
>
>
> Thanks,
> Davidlohr
>
cool, thanks//Hillf

>
>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
>
>

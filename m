Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887Ab1HHKuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 06:50:04 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43479 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab1HHKuD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 06:50:03 -0400
MIME-Version: 1.0
In-Reply-To: <op.vzv2g7aa3l0zgt@mnazarewicz-glaptop>
References: <1312762934-4884-1-git-send-email-per.forlin@linaro.org>
	<op.vzv2g7aa3l0zgt@mnazarewicz-glaptop>
Date: Mon, 8 Aug 2011 12:50:01 +0200
Message-ID: <CAJ0pr19edNL29ghqmAp_mwP0whoGZL_p1bQX23KaUsJGVDXQhg@mail.gmail.com>
Subject: Re: [PATCH] usb: gadget: storage_common: make FSG_NUM_BUFFERS
 variable size
From: Per Forlin <per.forlin@linaro.org>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

2011/8/8 Michal Nazarewicz <mina86@mina86.com>:
> On Mon, 08 Aug 2011 02:22:14 +0200, Per Forlin <per.forlin@linaro.org>
> wrote:
>>
>> FSG_NUM_BUFFERS is set to 2 as default.
>> Usually 2 buffers are enough to establish a good
>> double buffering pipeline. But when dealing with expensive
>> request preparation (i.e. dma_map) there may be benefits of
>> increasing the number of buffers. There is an extra cost for
>> every first request, the others are prepared in parallell with
>> an ongoing transfer. Every time all buffers are consumed there is
>> an additional cost for the next first request. Increasing the number
>> of buffers decreases the risk of running out of buffers.
>
> [... benchmark snip ...]
>
>> There may not be one optimal number for all boards. That is the
>> reason for adding the number to Kconfig,
>
> It could actually be turned into a run-time configuration, but
> that's a bit more intrusive,
I consider this too but couldn't see how this would be done nicely.

>> Signed-off-by: Per Forlin <per.forlin@linaro.org>
>
> Acked-by: Michal Nazarewicz <mina86@mina86.com>
>
>
> Some not very relevant comments below:
Thanks for these pointers. I'll update.

>
>> diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
>> index 029e288..bbd17f3 100644
>> --- a/drivers/usb/gadget/Kconfig
>> +++ b/drivers/usb/gadget/Kconfig
>> @@ -96,6 +96,21 @@ config USB_GADGET_VBUS_DRAW
>>           This value will be used except for system-specific gadget
>>           drivers that have more specific information.
>> +config USB_GADGET_STORAGE_NUM_BUFFERS
>> +       int "Number of storage pipline buffers"
>
> “pipeline”, missing “e”.
Will fix.

>
>> +       range 2 64
>> +       default 2
>> +       help
>> +         Usually 2 buffers are enough to establish a good
>> +         double buffering pipeline. But when dealing with expensive
>
> s/double//.  By definition, “double” buffering uses two buffers, isn't it?
> So if we change number of buffers, it's no longer “double”.
>
Good point!

>> +         request preparation (i.e. dma_map) there may be benefits of
>> +         increasing the number of buffers. There is an extra cost for
>> +         every first request, the others are prepared in parallell with
>
> “parallel”, too many “l”s.
>
Will fix

>> +         an ongoing transfer. Every time all buffers are consumed there
>> is
>> +         an additional cost for the next first request. Increasing the
>> number
>
> “Next first request” sounds a bit illogical to me.
>
I'll remove "next" to avoid confusion.

>> +         of buffers decreases the risk of running out of buffers.
>> +         If unsure, say 2.
>> +
>>  config USB_GADGET_SELECTED
>>        boolean
>> diff --git a/drivers/usb/gadget/storage_common.c
>> b/drivers/usb/gadget/storage_common.c
>> index 1fa4f70..512d9cf 100644
>> --- a/drivers/usb/gadget/storage_common.c
>> +++ b/drivers/usb/gadget/storage_common.c
>> @@ -262,8 +262,8 @@ static struct fsg_lun *fsg_lun_from_dev(struct device
>> *dev)
>>  #define EP0_BUFSIZE    256
>>  #define DELAYED_STATUS (EP0_BUFSIZE + 999)     /* An impossibly large
>> value */
>> -/* Number of buffers we will use.  2 is enough for double-buffering */
>> -#define FSG_NUM_BUFFERS        2
>> +/* Number of buffers we will use.  2 is usually enough for
>> double-buffering */
>
> s/double-buffering/good buffering pipeline/?
>
Will fix.

>> +#define FSG_NUM_BUFFERS        CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS
>> /* Default size of buffer length. */
>>  #define FSG_BUFLEN     ((u32)16384)
>
> --
> Best regards,                                         _     _
> .o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
> ..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
> ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
>

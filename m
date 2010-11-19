Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646Ab0KSW7G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:59:06 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64759 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755518Ab0KSW7B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 17:59:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dwGxpHBh6gUjB/FGIlCoaNsl55ajvzoPGTK5DSwBzQvBFHqU4NCRPJxMFnyJPI0+TG
         /RdILjdMukLMdXlipPe1Zk7iaJKc2YnNEkLfO/QU1lTm0yVNEod1DyWJDdCFji/juBH3
         vo3ytdJeQci8Zb77DQOFUu5CSito5Yz2S+KYw=
MIME-Version: 1.0
In-Reply-To: <4CE7006E.4040102@teksavvy.com>
References: <tTUH_XeInOH.A.dMF.c3b5MB@chimera>
	<4CE5C919.7090504@teksavvy.com>
	<AANLkTi=8G7pNA7QTxaXDWKrWrCERPfmKU+nLJWCA=JUH@mail.gmail.com>
	<4CE7006E.4040102@teksavvy.com>
Date: Fri, 19 Nov 2010 17:58:59 -0500
Message-ID: <AANLkTim9aXi1_EJyh2f-+X4HnNWJ3uk2z=P6m1hQso5a@mail.gmail.com>
Subject: Re: 2.6.37-rc2-git4: Reported regressions 2.6.35 -> 2.6.36
From: Alex Deucher <alexdeucher@gmail.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        Florian Mickler <florian@mickler.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 5:55 PM, Mark Lord <kernel@teksavvy.com> wrote:
> On 10-11-19 11:39 AM, Alex Deucher wrote:
>>
>> On Thu, Nov 18, 2010 at 7:47 PM, Mark Lord<kernel@teksavvy.com>  wrote:
>>
>>> My non-Intel graphics notebook (has ATI X1400 graphics) also has a resume
>>> regression with 2.6.36.  But it does work fine with 2.6.35 (and earlier,
>>> back many years).  As a result, I'm stuck with 2.6.35 for the time being,
>>> and lack the time for a concerted debug effort on 2.6.36+ right now.
>>>
>>
>> Can you bisect?  Does this patch help?
>>
>> diff --git a/drivers/gpu/drm/radeon/atom.c b/drivers/gpu/drm/radeon/atom.c
>> index 8e421f6..05efb5b 100644
>> --- a/drivers/gpu/drm/radeon/atom.c
>> +++ b/drivers/gpu/drm/radeon/atom.c
>> @@ -112,6 +112,7 @@ static uint32_t atom_iio_execute(struct
>> atom_context *ctx, int base,
>>                         base += 3;
>>                         break;
>>                 case ATOM_IIO_WRITE:
>> +                       (void)ctx->card->ioreg_read(ctx->card, CU16(base +
>> 1));
>>                         ctx->card->ioreg_write(ctx->card, CU16(base + 1),
>> temp);
>>                         base += 3;
>>                         break;
>
> It now comes back at resume time.

So that patch helped?

>
> But suffers long delays (also sometimes with 2.6.35) doing this:
>
> [drm:atom_op_jump] *ERROR* atombios stuck in loop for more than 5secs
> aborting
> [drm:atom_execute_table_locked] *ERROR* atombios stuck executing E576 (len
> 105, WS 12, PS 8) @ 0xE5C4
> [drm:atom_op_jump] *ERROR* atombios stuck in loop for more than 5secs
> aborting
> [drm:atom_execute_table_locked] *ERROR* atombios stuck executing ECD2 (len
> 86, WS 4, PS 0) @ 0xED05
> [drm:atom_op_jump] *ERROR* atombios stuck in loop for more than 5secs
> aborting
> [drm:atom_execute_table_locked] *ERROR* atombios stuck executing E576 (len
> 105, WS 12, PS 8) @ 0xE5C4
> PM: resume of devices complete after 15718.253 msecs
>

It's be nice if you could bisect to track down when those started.

> So I did this (local hack only, obviously NOT for mainline) to work around
> that issue:
>
> --- linux-2.6.36/drivers/gpu/drm/radeon/atom.c  2010-10-20
> 16:30:22.000000000 -0400
> +++ linux/drivers/gpu/drm/radeon/atom.c 2010-11-19 17:14:21.141807003 -0500
> @@ -1150,6 +1151,7 @@
>
>        if (!base)
>                return -EINVAL;
> +       if (base == 0xe576 || base == 0xecd2) return 0;  /* prevent freezes
> on Dell i9400 w/X1400 */
>
>        len = CU16(base + ATOM_CT_SIZE_PTR);
>        ws = CU8(base + ATOM_CT_WS_PTR);
>

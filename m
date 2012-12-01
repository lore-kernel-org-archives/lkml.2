Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509Ab2LABWr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 20:22:47 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39267 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab2LABWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 20:22:46 -0500
MIME-Version: 1.0
In-Reply-To: <20121130213333.GA2603@local>
References: <201211271348.14603.vitas@nppfactor.kiev.ua>
	<CAM3j68rrBePLoamRb1pCH+TeAfLDO-5Jd_kk7-JRCNnEBhLp2Q@mail.gmail.com>
	<201211291822.16565.vitas@nppfactor.kiev.ua>
	<201211291836.59358.vitas@nppfactor.kiev.ua>
	<20121129235822.GA2590@local>
	<CAM3j68rH8qyN8zX7TLZNvQz-1Vr6qMjS0cR7QKGAs6w54L7dag@mail.gmail.com>
	<20121130213333.GA2603@local>
Date: Sat, 1 Dec 2012 02:22:44 +0100
X-Google-Sender-Auth: 7OIivxHuGK3ih_LQzXkWxPmSwRA
Message-ID: <CAM3j68qHuqeafMjfpCiuRKLsKk+ZE3f=DuTM4zmHwUZdHULBMQ@mail.gmail.com>
Subject: Re: [PATCH] uio.c: Fix warning: 'ret' might be used uninitialized
From: Cong Ding <dinggnu@gmail.com>
To: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: Vitalii Demianets <vitas@nppfactor.kiev.ua>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 10:33 PM, Hans J. Koch <hjk@hansjkoch.de> wrote:
> On Fri, Nov 30, 2012 at 12:12:46PM +0100, Tux9 wrote:
>> I like Vitalii's solution more. Hans's solution assign the value
>> -ENOMEM to ret in every round of the loop, which is a kind of wasting
>> CPU cycles.
>
> The difference between
> 1 files changed, 12 insertions(+), 4 deletions(-) and
> 1 files changed, 2 insertions(+), 0 deletions(-)
>
> is more important. Note that this code is not in a fast path but only
> called once at device creation.
Why do you think the size of the patch is so important? I think the
most important thing is the coding style and efficiency. I agree
efficiency is not important in this case, but what about coding style?
Your code is _not_ very easy to understand. It's a very natural thing
to set the return value and then goto the error-handling codes, which
is exactly same as what Vitalii did, rather than setting an initial
value in the beginning of each round of the loop as you did. There are
also a bunch of codes in kernel in the same style with Vitalii, but I
cannot find anything same as your codes.

Cong
>
>>
>> On Fri, Nov 30, 2012 at 12:58 AM, Hans J. Koch <hjk@hansjkoch.de> wrote:
>> > On Thu, Nov 29, 2012 at 06:36:59PM +0200, Vitalii Demianets wrote:
>> >> > On Thursday 29 November 2012 18:05:27 Tux9 wrote:
>> >> > > Hans, I think there are something wrong in your patch, while Vitalii's
>> >> > > is right. The variable "ret" is reused in line 292 and line 295, so
>> >> > > the value of "ret" would be overridden (if it goto err_map in line 284
>> >> > > when mi>=1).
>> >> >
>> >> > Actually, both patches do exactly the same thing. Hans's patch establishes
>> >> > default value for the ret for all those "other" cases when ret is not
>> >> > explicitly overridden. My patch explicitly enumerates all those "other"
>> >> > cases in more wordily manner.
>> >> >
>> >>
>> >> Oops, disregard this. After looking at it more thoroughly I got your point.
>> >> You are right, ret is overridden at first iteration (mi == 0), so Hans's
>> >> approach does not work.
>> >> I must do more thinking before replying in a hurry.
>> >
>> > You're right. Initialization of "ret" has to take place at the beginning of
>> > the loop.
>> >
>> > I think this version is right:
>> >
>> >
>> > From 00c3c734c0dde67873a628bcb18cee403c95c301 Mon Sep 17 00:00:00 2001
>> > From: "Hans J. Koch" <hjk@hansjkoch.de>
>> > Date: Fri, 30 Nov 2012 00:51:50 +0100
>> > Subject: [PATCH] uio: Fix warning: 'ret' might be used uninitialized
>> >
>> > In two cases, the return value variable "ret" can be undefined.
>> >
>> > Signed-off-by: Hans J. Koch <hjk@hansjkoch.de>
>> > ---
>> >  drivers/uio/uio.c |    2 ++
>> >  1 files changed, 2 insertions(+), 0 deletions(-)
>> >
>> > diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
>> > index 5110f36..0c80df2 100644
>> > --- a/drivers/uio/uio.c
>> > +++ b/drivers/uio/uio.c
>> > @@ -273,6 +273,7 @@ static int uio_dev_add_attributes(struct uio_device *idev)
>> >         struct uio_portio *portio;
>> >
>> >         for (mi = 0; mi < MAX_UIO_MAPS; mi++) {
>> > +               ret = -ENOMEM;
>> >                 mem = &idev->info->mem[mi];
>> >                 if (mem->size == 0)
>> >                         break;
>> > @@ -298,6 +299,7 @@ static int uio_dev_add_attributes(struct uio_device *idev)
>> >         }
>> >
>> >         for (pi = 0; pi < MAX_UIO_PORT_REGIONS; pi++) {
>> > +               ret = -ENOMEM;
>> >                 port = &idev->info->port[pi];
>> >                 if (port->size == 0)
>> >                         break;
>> > --
>> > 1.7.9
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> > Please read the FAQ at  http://www.tux.org/lkml/
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

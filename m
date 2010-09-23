Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab0IWIrt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 04:47:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:35666 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347Ab0IWIrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 04:47:47 -0400
Message-ID: <4C9B141F.3050908@kernel.org>
Date: Thu, 23 Sep 2010 10:47:27 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>,
        Kay Sievers <kay.sievers@vrfy.org>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [REGRESSION] cdrom drive doesn't detect removal
References: <1284284969.2928.18.camel@maxim-laptop>	 <1284427621.4127.7.camel@maxim-laptop> <4C8F2699.3020509@kernel.org>	 <AANLkTinGHB9fbLw1Cm5wvPLGy8QEuoBBmFiqpnvXiZ8R@mail.gmail.com>	 <1284507516.4963.2.camel@maxim-laptop>	 <AANLkTimFpyYab69=XQVZc+P50v6_uVr6UbA246Fnm3-u@mail.gmail.com>	 <1284511071.3551.1.camel@maxim-laptop>	 <AANLkTikF37hN7dFqPbCp-gcim7SarveaTrjXipnGpJM7@mail.gmail.com>	 <20100915132731.GA20558@khazad-dum.debian.net>	 <AANLkTinGDUxsgaGey7EnYOu3kKP-YRE00gL33hiKvAWj@mail.gmail.com>	 <1284589207.4672.3.camel@maxim-laptop>	 <AANLkTin37rbEbcGDejhcsnxZNYhhUWGy+x=v4Y=s0_Qx@mail.gmail.com>	 <1285069338.3124.4.camel@maxim-laptop>	 <1285110590.2822.9.camel@maxim-laptop>  <4C99B25D.20805@kernel.org>	 <1285162900.3335.15.camel@maxim-laptop> <1285163911.3159.5.camel@maxim-laptop>
In-Reply-To: <1285163911.3159.5.camel@maxim-laptop>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 23 Sep 2010 08:47:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 09/22/2010 03:58 PM, Maxim Levitsky wrote:
>> 1. Make exclusive opens really exclusive.
>> That is if someone opens a device with exclusive access, no more opens
>> will succeed.
> And as a follow-up, indeed hal first tries exclusive open, and if it
> fails, it retries with non-exclusive open, and it succeeds.
> And that somewhat makes me think that exclusive open is pretty much
> useless.

Yeah, what I'm curious about is why hal behaves differently with
claiming block patch.  Exclusive open still fails with EBUSY with or
without the patch, right?  So, why does hal behave differently?

> Look if it fails. sure the device is open, but if doesn't fail, nothing
> prevents a bit less honest clients (that don't use exclusive open) to
> open the device. How exclusive such an open is then?

It's cooperative exclusion.  It doesn't assume the presence of hostile
programs having access to the device.

> So I mean exclusive open should really block _all_ following opens of
> the device, exclusive or not.

That will probably break a lot of stuff.

> Btw I had few failed dual layer disk burns that failed just after write
> of few MBs. I wouldn't be surprised if this was the cause.

Usually open sequence just inserts TEST UNIT READY which usually is
safe but yeah it's possible that some device might react badly.

I'm currently working on in-kernel media presence polling to handle
the open and polling command sequence issues.  That said, it's not
entirely clear how the mount case should be handled.  If a media is
mounted, the device is exclusively open and media presence polling
shouldn't be inserting commands in the middle but then how can it
detect the media has been ejected by the user?  Kay, can you please
enlighten me on how it's supposed to work?

Thanks.

-- 
tejun

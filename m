Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab1CVODA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 10:03:00 -0400
Received: from ist.d-labs.de ([213.239.218.44]:41288 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753666Ab1CVOCw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 10:02:52 -0400
MIME-Version: 1.0
In-Reply-To: <1300800904.3290.7.camel@mulgrave.site>
References: <1300732426-18958-1-git-send-email-florian@mickler.org>
	<a08d026a-d4c3-4ee5-b01a-d561f755b1ec@email.android.com>
	<20110321220315.7545a61a@schatten.dmk.lab>
	<1300800904.3290.7.camel@mulgrave.site>
Date: Tue, 22 Mar 2011 15:02:48 +0100
Message-ID: <AANLkTinWhwX1ZONGi-JwPr-oG565bKSsF0-UvJRh+4Cp@mail.gmail.com>
Subject: Re: [PATCH 0/6] get rid of on-stack dma buffers
From: Florian Mickler <florian@mickler.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andy Walls <awalls@md.metrocast.net>, mchehab@infradead.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        js@linuxtv.org, tskd2@yahoo.co.jp, liplianin@me.by, g.marco@freenet.de,
        aet@rasterburn.org, pb@linuxtv.org, mkrufky@linuxtv.org,
        nick@nick-andrew.net, max@veneto.com, janne-dvb@grunau.be,
        Oliver Neukum <oliver@neukum.org>, Greg Kroah-Hartman <greg@kroah.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Joerg Roedel <joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/22 James Bottomley <James.Bottomley@hansenpartnership.com>:
> On Mon, 2011-03-21 at 22:03 +0100, Florian Mickler wrote:
>> On Mon, 21 Mar 2011 15:26:43 -0400
>> Andy Walls <awalls@md.metrocast.net> wrote:
>>
>> > Florian Mickler <florian@mickler.org> wrote:
>>
>> To be blunt, I'm not shure I fully understand the requirements myself.
>> But as far as I grasped it, the main problem is that we need memory
>> which the processor can see as soon as the device has scribbled upon
>> it. (think caches and the like)
>>
>> Somewhere down the line, the buffer to usb_control_msg get's to be
>> a parameter to dma_map_single which is described as part of
>> the DMA API in Documentation/DMA-API.txt
>>
>> The main point I filter out from that is that the memory has to begin
>> exactly at a cache line boundary...
>
> The API will round up so that the correct region covers the API.
> However, if you have other structures packed into the space (as very
> often happens on stack), you get cache line interference in the CPU if
> they get accessed:  The act of accessing an adjacent object pulls in
> cache above your object and destroys DMA coherence.  This is the
> principle reason why DMA to stack is a bad idea.

Thanks, this was the missing piece of information to make sense of
 why it's bad for stack memory to be part of this.

>
>> I guess (not verified), that the dma api takes sufficient precautions
>> to abort the dma transfer if a timeout happens.  So freeing _should_
>> not be an issue. (At least, I would expect big fat warnings everywhere
>> if that were the case)

I did mean s/dma api/usb_control_msg/ in the above paragraph. As that is the
 ''dma api'' these drivers are using... sorry for the confusion there...

>
> No, it doesn't take any precautions like this.  the DMA API is just
> mapping (possibly via an IOMMU).  If the transfer times out, that's done
> in the DMA engine of the card, and must be cleaned up by the driver and
> unmapped.

ok.

> The general rule though is never DMA to stack.  On some processors, the
> way stack is allocated can actually make this not work.
>
> James

thanks,
Flo

p.s.: hope this message get's through to the list... I am on the road
at the moment,
 so I'm not shure that there won't be any html in it again :(

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758653Ab1IIISu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 04:18:50 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34480 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758549Ab1IIISr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 04:18:47 -0400
MIME-Version: 1.0
In-Reply-To: <1315518378.6638.2.camel@vkoul-mobl4>
References: <1315374075-15479-1-git-send-email-Baohua.Song@csr.com>
 <438BB0150E931F4B9CE701519A4463010871804A46@bgsmsx502.gar.corp.intel.com>
 <CAGsJ_4x4S+8d3xS+QTrjDpoxcHo3p7qArd7yFr=+h1vxSRvEpA@mail.gmail.com>
 <438BB0150E931F4B9CE701519A4463010871804A48@bgsmsx502.gar.corp.intel.com>
 <CAGsJ_4yeovNP=6CKTafbxrBTrYQ42B9yvAOM8gM_bYqD6mTnUw@mail.gmail.com>
 <CABb+yY1=P=D3GFFxMOUM0a2yWCiAHNqwVU0a--t+pJnUhqKHKA@mail.gmail.com>
 <CABb+yY3F+DMn2SxeO0chjpiMBkgLvSK5EVYMdhQsfQoZNZ4_7Q@mail.gmail.com> <1315518378.6638.2.camel@vkoul-mobl4>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 9 Sep 2011 16:18:25 +0800
Message-ID: <CAGsJ_4xv9+=+=2b=i47P5V5sOQH-GyTMaESwbeHxu439Vx1gLA@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: add CSR SiRFprimaII DMAC driver
To: Vinod Koul <vkoul@infradead.org>
Cc: Jassi Brar <jassisinghbrar@gmail.com>, vinod.koul@intel.com,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "workgroup.linux@csr.com" <workgroup.linux@csr.com>,
        "rongjun.ying@csr.com" <rongjun.ying@csr.com>,
        "Baohua.Song@csr.com" <Baohua.Song@csr.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/9 Vinod Koul <vkoul@infradead.org>:
> On Thu, 2011-09-08 at 10:55 +0530, Jassi Brar wrote:
>> On Thu, Sep 8, 2011 at 8:47 AM, Jassi Brar <jassisinghbrar@gmail.com> wrote:
>> > On Thu, Sep 8, 2011 at 7:42 AM, Barry Song <21cnbao@gmail.com> wrote:
>> >
>> >>>> it is much different with primacell based DMA like pl080, pl330.
>> >>>> prima2 has a self-defined DMAC IP. basically it is a 2D mode dma with
>> >>>> two scales X and Y and direct way to start and stop DMA.
>> >>>> every channel has fixed function to serve only one perpheral. so you
>> >>>> find we have a filter id.
>> >>> okay, what do you mean by 2D mode? Is it similar to what TI folks, Linus
>> >>> W and Jassi Brar posted RFC's on?
>> >>
>> >> In SiRFprimaII 2-D DMA, the system memory space is interpreted
>> >> as a 2-D layout instead of a linear 1-D layout. More specifically, the
>> >> system memory can be considered as
>> >> multiple data lines. The length of the data line is determined by the
>> >> user-selected DMA_WIDTH register.
>> >> The user can specify a data window that the user wants to access using
>> >> four parameters:
>> >> ■ Start address
>> >> ■ X length
>> >> ■ Y length
>> >> ■ Width
>> >>
>> >> The idea of a 2-D DMA is shown in figure 2d-dma.png attached.
>> >>
>> >> If you specifies the Y length as 0 or the X length equals to the DMA
>> >> width, then this 2-D DMA reduces to
>> >> 1-D. If the user configures the X length greater than the DMA width,
>> >> then the extra data is wrapped around
>> >> to the next data line, this may corrupt the DMA transfer for
>> >> multiple-line 2-D DMA. If this is a 1-D DMA, then
>> >> there is no issue. The attached diagram 2d-dma2.png shows the
>> >> wrap-around of the extra data in case the X length
>> >> greater than DMA width.
>> >
>> > Sorry, the role of DMA_WIDTH is not clear to me yet.
>> > In which case the user _must_ set {xlen > width} ?
>> >
>> Perhaps 2d-dma.PNG is inaccurate - it shouldn't depict any deltaX.
>> Doesn't xlen and width always start together ? If no, please don't read ahead.
>>
>> According to figures, {xlen > width} is to be set _only_ when a transfer
>> is divided into _exactly_ two chunks separated by gap _exactly_
>> equal to length of the second chunk (an extremely rare case).
>>
>> Anyways, every case can be easily expressed using the generic api
>> I proposed. See 'struct xfer_template' in https://lkml.org/lkml/2011/8/12/128
>>
>> Roughly speaking, the following should be done...
>> Client driver :-
>> **************
>> For a 'Rectangular' transfer (2d-dma.PNG) :-
>>       xfer_template.numf = Ylen;  /* height of rectangle */
>>       xfer_template.frame_size = 1;
>>       xfer_template.sgl[0].size = Xlen; /* width of rectangle */
>>       xfer_template.sgl[0].icg = start_addr_Y(n) - end_addr_Y(n-1);
>>
>> For the "A Line and some" transfer (2d-dma2.PNG) :-
>>       xfer_template.numf = 1;
>>       xfer_template.frame_size = 2;
>>       xfer_template.sgl[0].size = xlen1; /* a line */
>>       xfer_template.sgl[1].size = xlen2;  /* and some */
>>       xfer_template.sgl[0].icg = start_addr_Y(n) - end_addr_Y(n-1);
>>       xfer_template.sgl[1].icg = 0; /* doesn't matter */
>>
>> DMAC driver :-
>> ***************
>>       if (xfer_template.frame_size == 1) {
>>            /* rectangle */
>>            schan->xlen = xfer_template.sgl[0].size;
>>            schan->width = schan->xlen + xfer_template.sgl[0].icg;
>>       } else if (xfer_template.frame_size == 2 &&
>>                   xfer_template.numf == 1 &&
>>                   xfer_template.sgl[1].size == xfer_template.sgl[0].icg){
>>            /* a line and some */
>>            schan->xlen = xfer_template.sgl[0].size +  xfer_template.sgl[1].size.
>>            schan->width = xfer_template.sgl[0].size;
>>       } else {
>>            /* _Hardware_ doesn't support the transfer as such. *
>>            return -EINVAL;
>>       }
>>       schan->ylen = xfer_template.numf /* -1? */;
> Looks like Jassi got a user for his proposed API. I am not sure whats
> going on with TI folks, they never showed up here @LPC.

yes, i can definitely be an user of Jassi's new generic api. it seems
the api is just there for dma in 2d.

Jassi prefer to use a transfer type instead of a control command.
though we will not really change the interleaved setting for every
transfer(it is more possible for one device, we will not change the
xlen/ylen/dma_width setting in the whole life period), i do believe
the transfer type is enough flexible for my possible applications to
change xlen, ylen and dma_width in different transfers.

as we know, interleaved DMA can also be used for audio driver. for
some audio controllers, if there are n channels, it can't tranfer the
whole audio frame to sound card by one dma channel, and it needs to
tranfer every channel by separate dma. typically, we can define this
kind of xfer to skip other n-1 channel.

Jassi, you might think my reply as an ACK to "[PATCH] DMAEngine:
Define generic transfer request api".

>
>
> --
> ~Vinod Koul
> Intel Corp.
>
>

thanks
barry

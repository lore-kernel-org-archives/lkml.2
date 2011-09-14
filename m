Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336Ab1INGqf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 02:46:35 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43698 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817Ab1INGqd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 02:46:33 -0400
MIME-Version: 1.0
In-Reply-To: <CABb+yY3F+DMn2SxeO0chjpiMBkgLvSK5EVYMdhQsfQoZNZ4_7Q@mail.gmail.com>
References: <1315374075-15479-1-git-send-email-Baohua.Song@csr.com>
 <438BB0150E931F4B9CE701519A4463010871804A46@bgsmsx502.gar.corp.intel.com>
 <CAGsJ_4x4S+8d3xS+QTrjDpoxcHo3p7qArd7yFr=+h1vxSRvEpA@mail.gmail.com>
 <438BB0150E931F4B9CE701519A4463010871804A48@bgsmsx502.gar.corp.intel.com>
 <CAGsJ_4yeovNP=6CKTafbxrBTrYQ42B9yvAOM8gM_bYqD6mTnUw@mail.gmail.com>
 <CABb+yY1=P=D3GFFxMOUM0a2yWCiAHNqwVU0a--t+pJnUhqKHKA@mail.gmail.com> <CABb+yY3F+DMn2SxeO0chjpiMBkgLvSK5EVYMdhQsfQoZNZ4_7Q@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 14 Sep 2011 14:46:12 +0800
Message-ID: <CAGsJ_4x0isAUgmTkRavUC6p3K38ho70A+q8Pp2cMLnxbgMEL7Q@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: add CSR SiRFprimaII DMAC driver
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: "Koul, Vinod" <vinod.koul@intel.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "workgroup.linux@csr.com" <workgroup.linux@csr.com>,
        "rongjun.ying@csr.com" <rongjun.ying@csr.com>,
        "Baohua.Song@csr.com" <Baohua.Song@csr.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jassi,

2011/9/8 Jassi Brar <jassisinghbrar@gmail.com>:
> On Thu, Sep 8, 2011 at 8:47 AM, Jassi Brar <jassisinghbrar@gmail.com> wrote:
>> On Thu, Sep 8, 2011 at 7:42 AM, Barry Song <21cnbao@gmail.com> wrote:
>>
>>>>> it is much different with primacell based DMA like pl080, pl330.
>>>>> prima2 has a self-defined DMAC IP. basically it is a 2D mode dma with
>>>>> two scales X and Y and direct way to start and stop DMA.
>>>>> every channel has fixed function to serve only one perpheral. so you
>>>>> find we have a filter id.
>>>> okay, what do you mean by 2D mode? Is it similar to what TI folks, Linus
>>>> W and Jassi Brar posted RFC's on?
>>>
>>> In SiRFprimaII 2-D DMA, the system memory space is interpreted
>>> as a 2-D layout instead of a linear 1-D layout. More specifically, the
>>> system memory can be considered as
>>> multiple data lines. The length of the data line is determined by the
>>> user-selected DMA_WIDTH register.
>>> The user can specify a data window that the user wants to access using
>>> four parameters:
>>> ■ Start address
>>> ■ X length
>>> ■ Y length
>>> ■ Width
>>>
>>> The idea of a 2-D DMA is shown in figure 2d-dma.png attached.
>>>
>>> If you specifies the Y length as 0 or the X length equals to the DMA
>>> width, then this 2-D DMA reduces to
>>> 1-D. If the user configures the X length greater than the DMA width,
>>> then the extra data is wrapped around
>>> to the next data line, this may corrupt the DMA transfer for
>>> multiple-line 2-D DMA. If this is a 1-D DMA, then
>>> there is no issue. The attached diagram 2d-dma2.png shows the
>>> wrap-around of the extra data in case the X length
>>> greater than DMA width.
>>
>> Sorry, the role of DMA_WIDTH is not clear to me yet.
>> In which case the user _must_ set {xlen > width} ?
>>
> Perhaps 2d-dma.PNG is inaccurate - it shouldn't depict any deltaX.
> Doesn't xlen and width always start together ? If no, please don't read ahead.
>
> According to figures, {xlen > width} is to be set _only_ when a transfer
> is divided into _exactly_ two chunks separated by gap _exactly_
> equal to length of the second chunk (an extremely rare case).
>
> Anyways, every case can be easily expressed using the generic api
> I proposed. See 'struct xfer_template' in https://lkml.org/lkml/2011/8/12/128
>
> Roughly speaking, the following should be done...
> Client driver :-
> **************
> For a 'Rectangular' transfer (2d-dma.PNG) :-
>      xfer_template.numf = Ylen;  /* height of rectangle */
>      xfer_template.frame_size = 1;
>      xfer_template.sgl[0].size = Xlen; /* width of rectangle */
>      xfer_template.sgl[0].icg = start_addr_Y(n) - end_addr_Y(n-1);

For prima2:

xfer_template.numf = ylen + 1
xfer_template.frame_size = 1;
xfer_template.sgl[0].size = xlen;
xfer_template.sgl[0].icg = dma_width - xlen;

>
> For the "A Line and some" transfer (2d-dma2.PNG) :-
>      xfer_template.numf = 1;
>      xfer_template.frame_size = 2;
>      xfer_template.sgl[0].size = xlen1; /* a line */
>      xfer_template.sgl[1].size = xlen2;  /* and some */
>      xfer_template.sgl[0].icg = start_addr_Y(n) - end_addr_Y(n-1);
>      xfer_template.sgl[1].icg = 0; /* doesn't matter */
>
> DMAC driver :-
> ***************
>      if (xfer_template.frame_size == 1) {
>           /* rectangle */
>           schan->xlen = xfer_template.sgl[0].size;
>           schan->width = schan->xlen + xfer_template.sgl[0].icg;
>      } else if (xfer_template.frame_size == 2 &&
>                  xfer_template.numf == 1 &&
>                  xfer_template.sgl[1].size == xfer_template.sgl[0].icg){
>           /* a line and some */
>           schan->xlen = xfer_template.sgl[0].size +  xfer_template.sgl[1].size.
>           schan->width = xfer_template.sgl[0].size;
>      } else {
>           /* _Hardware_ doesn't support the transfer as such. *
>           return -EINVAL;
>      }
>      schan->ylen = xfer_template.numf /* -1? */;
>

For prima2:
xfer_template.frame_size is always 1, then
schan->xlen = xfer_template.sgl[0].size;
schan->width = schan->xlen + xfer_template.sgl[0].icg;

Thanks
barry

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700Ab1INHL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 03:11:28 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41329 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755418Ab1INHL1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 03:11:27 -0400
MIME-Version: 1.0
In-Reply-To: <CAGsJ_4x0isAUgmTkRavUC6p3K38ho70A+q8Pp2cMLnxbgMEL7Q@mail.gmail.com>
References: <1315374075-15479-1-git-send-email-Baohua.Song@csr.com>
	<438BB0150E931F4B9CE701519A4463010871804A46@bgsmsx502.gar.corp.intel.com>
	<CAGsJ_4x4S+8d3xS+QTrjDpoxcHo3p7qArd7yFr=+h1vxSRvEpA@mail.gmail.com>
	<438BB0150E931F4B9CE701519A4463010871804A48@bgsmsx502.gar.corp.intel.com>
	<CAGsJ_4yeovNP=6CKTafbxrBTrYQ42B9yvAOM8gM_bYqD6mTnUw@mail.gmail.com>
	<CABb+yY1=P=D3GFFxMOUM0a2yWCiAHNqwVU0a--t+pJnUhqKHKA@mail.gmail.com>
	<CABb+yY3F+DMn2SxeO0chjpiMBkgLvSK5EVYMdhQsfQoZNZ4_7Q@mail.gmail.com>
	<CAGsJ_4x0isAUgmTkRavUC6p3K38ho70A+q8Pp2cMLnxbgMEL7Q@mail.gmail.com>
Date: Wed, 14 Sep 2011 12:41:26 +0530
Message-ID: <CABb+yY36xmq3mKpWOn+ZZuvPehRkSGe720WrQtMie2C-udgZyQ@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: add CSR SiRFprimaII DMAC driver
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Barry Song <21cnbao@gmail.com>
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

On Wed, Sep 14, 2011 at 12:16 PM, Barry Song <21cnbao@gmail.com> wrote:

>> Anyways, every case can be easily expressed using the generic api
>> I proposed. See 'struct xfer_template' in https://lkml.org/lkml/2011/8/12/128
>>
>> Roughly speaking, the following should be done...
>> Client driver :-
>> **************
>> For a 'Rectangular' transfer (2d-dma.PNG) :-
>>      xfer_template.numf = Ylen;  /* height of rectangle */
>>      xfer_template.frame_size = 1;
>>      xfer_template.sgl[0].size = Xlen; /* width of rectangle */
>>      xfer_template.sgl[0].icg = start_addr_Y(n) - end_addr_Y(n-1);
>
> For prima2:
>
> xfer_template.numf = ylen + 1
> xfer_template.frame_size = 1;
> xfer_template.sgl[0].size = xlen;
> xfer_template.sgl[0].icg = dma_width - xlen;
>
All is same as I suggested except for 'numf'.
You might want to keep 'numf' same as well. Because the client
driver shouldn't need to know that the DMAC's register expect "+1" value.
Remember the client is supposed to be reusable over other DMACs as well.
So, rather in the DMAC driver, please do
    schan->ylen = xfer_template.numf + 1;


>> DMAC driver :-
>> ***************
>>      if (xfer_template.frame_size == 1) {
>>           /* rectangle */
>>           schan->xlen = xfer_template.sgl[0].size;
>>           schan->width = schan->xlen + xfer_template.sgl[0].icg;
>>      } else if (xfer_template.frame_size == 2 &&
>>                  xfer_template.numf == 1 &&
>>                  xfer_template.sgl[1].size == xfer_template.sgl[0].icg){
>>           /* a line and some */
>>           schan->xlen = xfer_template.sgl[0].size +  xfer_template.sgl[1].size.
>>           schan->width = xfer_template.sgl[0].size;
>>      } else {
>>           /* _Hardware_ doesn't support the transfer as such. *
>>           return -EINVAL;
>>      }
>>      schan->ylen = xfer_template.numf /* -1? */;
>>
>
> For prima2:
> xfer_template.frame_size is always 1, then
> schan->xlen = xfer_template.sgl[0].size;
> schan->width = schan->xlen + xfer_template.sgl[0].icg;
>
Ok, you don't need the 'else if' clause because as you said
{xlen > width} is not an option.
But you do need the other two checks, so that the DMAC driver
cleanly rejects any interleaved-format that it doesn't support.

Point being, the clients and DMAC drivers are supposed to be
very 'promiscuous' - any Client could be 'riding' any DMAC ;)

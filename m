Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab1JQTkO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 15:40:14 -0400
Received: from mxout1.idt.com ([157.165.5.25]:42198 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753353Ab1JQTkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 15:40:12 -0400
x-mimeole: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Subject: RE: [RFC PATCH 1/2] RapidIO: Add DMA Engine support for RIO data transfers
Date: Mon, 17 Oct 2011 12:39:45 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E55202322024@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <1318870884.23438.174.camel@vkoul-udesk3>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RFC PATCH 1/2] RapidIO: Add DMA Engine support for RIO data transfers
Thread-Index: AcyM76tmc6uJkA8ISZCgJAnf5+5IwAAD9/nQ
References: <1317418715-9666-1-git-send-email-alexandre.bounine@idt.com> <1317492077.1573.1839.camel@vkoul-udesk3> <0CE8B6BE3C4AD74AB97D9D29BD24E55202291E40@CORPEXCH1.na.ads.idt.com> <1317965252.1573.2238.camel@vkoul-udesk3> <0CE8B6BE3C4AD74AB97D9D29BD24E552022D6C9A@CORPEXCH1.na.ads.idt.com> <1318700142.23438.45.camel@vkoul-udesk3> <CAJe_ZhdjMTsqSTDwV_zaAQKmCbjOtRVc951wxqKScaCR-DBG9Q@mail.gmail.com> <1318870884.23438.174.camel@vkoul-udesk3>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: Vinod Koul <vinod.koul@intel.com>, Jassi Brar <jaswinder.singh@linaro.org>
CC: Dan <dan.j.williams@intel.com>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p9HJeMNR002771

On Mon, Oct 17, 2011 at 1:01 PM, Vinod Koul <vinod.koul@intel.com> wrote:
> 
> On Mon, 2011-10-17 at 21:22 +0530, Jassi Brar wrote:
> > On 15 October 2011 23:05, Vinod Koul <vinod.koul@intel.com> wrote:
> >
> > > Another alternate approach could be to add one more argument to
> > > prep_slave_sg API which allows us to pass additional runtime
> specific
> > > parameters. This can be NULL and unused for existing drivers and
> used in
> > > RIO and any future subsystems which want to use dmaengine.
> > > Thoughts...?
> > >
> > That doesn't sound much different than passing the data via
> > dma_chan.private during prep_slave_sg. Only now we add to
> > the number of arguments.
> Yes agreed, but we already decided and marked it as depreciated.
> 
> > And then either this argument would be RapidIO specific (unfair
> > to other users) or generic. In latter case what would it look like ?
> My initial thoughts were to add an argument which only the specific
> dmac
> knows howto decode and is filled by its client. As i said for existing
> users and people who don't require dynamic information wouldn't bother.
> The pros
>  - allows us to support RIO kind of subsystems where one needs to pass
> subsystem specific information for programing the dmac
>  - doesn't require us to add subsystem specific stuff in dmaengine,
> today its RIO tomorrow some other folks may want to add. We want to
> maintain dmaengine as a generic framework, while also trying to support
> multiple audiences.
> Cons:
>  - there is no guarantee;  dmac expects foo and clients pass bar
> 
This was my concern that I mentioned in the beginning of this thread:
how to differentiate between different types of slave channels. At that
time we decided that channel filtering routines should be sufficient
to properly identify a suitable channel. And this is true - if RIO filter
detects registered RapidIO capable DMA channel it should be safe to pass
a parameter specific to RIO client implementation.   

If we want to protect pure slave channels from mixing with some specific
implementations we may consider adding new values for dma_transaction_type
as it done for RapidIO (DMA_RAPIDIO, DMA_FOO, DMA_BAR etc.).
This way we may keep single API with extra argument and differentiate
between "flavors" of DMA_SLAVE to make decisions about use of that
extra parameter. E.g. channels registered as DMA_SLAVE will ignore
the new parameter (pure slave mode), DMA_RAPIDIO and DMA_FOO use it
according to the "flavor".  

Yes, I am planning to drop that flag from the current RIO implementation but
It may have a new meaning if prep_slave_sg() gets the extra argument.  

> I am okay if we have alternate way to support this with above goal :)
> 
> --
> ~Vinod

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

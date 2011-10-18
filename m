Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933449Ab1JRR12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 13:27:28 -0400
Received: from mxout1.idt.com ([157.165.5.25]:38709 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932570Ab1JRR11 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 13:27:27 -0400
x-mimeole: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCHv4] DMAEngine: Define interleaved transfer request api
Date: Tue, 18 Oct 2011 10:26:56 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E55202367258@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <20111018094944.GA30644@flint.arm.linux.org.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCHv4] DMAEngine: Define interleaved transfer request api
Thread-Index: AcyNe2r7U6sGU4TwQY+4x5hxJZXhcQAMmSdQ
References: <CAJe_ZhdFA641AzmEmYaz++iRNYQmrHDFmAWOkrwmR_h2ie176g@mail.gmail.com> <CABE8wwtcO_su0cF6YocVjAYKhUb=TTwqttfaZkC+RWGLKJimdQ@mail.gmail.com> <0CE8B6BE3C4AD74AB97D9D29BD24E55202321E20@CORPEXCH1.na.ads.idt.com> <CAJe_ZhfWcUY2ctUFt0iUf2FOfjKj1Aa8hQH5LqFG+bZ+93CcNQ@mail.gmail.com> <0CE8B6BE3C4AD74AB97D9D29BD24E55202321F65@CORPEXCH1.na.ads.idt.com> <CAJe_ZhfTg17YgyQ9TuKdhtXMu+8W_E2t3cBqZybfarxWu9Zasg@mail.gmail.com> <0CE8B6BE3C4AD74AB97D9D29BD24E552023220AC@CORPEXCH1.na.ads.idt.com> <CAJe_ZhdBSxvH6Zd8JsoLrerapNbLn0a7Lv6KxwivbFuLaSavyg@mail.gmail.com> <20111018074211.GA13483@flint.arm.linux.org.uk> <CAJe_ZhdHcsBNT6iX7TJCqoGZMrPwE2BOt06e8M8PHzuDe3Z70w@mail.gmail.com> <20111018094944.GA30644@flint.arm.linux.org.uk>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: Russell King <rmk@arm.linux.org.uk>,
        Jassi Brar <jaswinder.singh@linaro.org>
CC: "Williams, Dan J" <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, Barry Song <21cnbao@gmail.com>,
        <linux-kernel@vger.kernel.org>,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>,
        Dave Jiang <dave.jiang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 5:50 AM, Russell King <rmk@arm.linux.org.uk> wrote:
> 
> On Tue, Oct 18, 2011 at 02:00:45PM +0530, Jassi Brar wrote:
> > On 18 October 2011 13:12, Russell King <rmk@arm.linux.org.uk> wrote:
> > > On Tue, Oct 18, 2011 at 11:15:29AM +0530, Jassi Brar wrote:
> > >> On 18 October 2011 02:37, Bounine, Alexandre
> <Alexandre.Bounine@idt.com> wrote:
> > >> > With item #1 above being a separate topic, I may have a problem
> with #2
> > >> > as well: dma_addr_t is sized for the local platform and not
> guaranteed
> > >> > to be a 64-bit value (which may be required by a target).
> > >> > Agree with #3 (if #1 and #2 work).
> > >> >
> > >> Perhaps simply change dma_addr_t to u64 in dmaengine.h alone ?
> > >
> > > That's just an idiotic suggestion - there's no other way to put
> that.
> > > Let's have some sanity here.
> > >
> > Yeah, I am not proud of the workaround, so I only probed the option.
> > I think I need to explain myself.
> >
> > The case here is that even a 32-bit RapidIO host could ask transfer
> against
> > 64-bit address space on a remote device. And vice versa 64->32.
> >
> > > dma_addr_t is the size of a DMA address for the CPU architecture
> being
> > > built.  This has no relationship to what any particular DMA engine
> uses.
> > >
> > Yes, so far the dmaengine ever only needed to transfer within
> platform's
> > address-space. So the assumption that src and dst addresses could
> > be contained within dma_addr_t, worked.
> > If the damengine is to get rid of that assumption/constraint, the
> memcpy,
> > slave_sg etc need to accept addresses specified in bigger of the host
> and
> > remote address space, and u64 is the safe option.
> > Ultimately dma_addr_t is either u32 or u64.
> 
> Let me spell it out:
> 
> 1. Data structures read by the DMA engine hardware should not be
> defined
>    using the 'dma_addr_t' type, but one of the [bl]e{8,16,32,64} types,
>    or at a push the u{8,16,32,64} types if they're always host-endian.
> 
>    This helps to ensure that the layout of the structures read by the
>    hardware are less dependent of the host architecture and each
> element
>    is appropriately sized (and, with sparse and the endian-sized types,
>    can be endian-checked at compile time.)
> 
> 2. dma_addr_t is the size of the DMA address for the host architecture.
>    This may be 32-bit or 64-bit depending on the host architecture.
> 
> The following points are my opinion:
> 
> 3. For architectures where there are only 32-bit DMA addresses,
> dma_addr_t
>    will be a 32-bit type.  For architectures where there are 64-bit DMA
>    addresses, it will be a 64-bit type.
> 
> 4. If RIO can accept 64-bit DMA addresses but is only connected to 32-
> bit
>    busses, then the top 32 address bits are not usable (it's truncated
> in
>    hardware.)  So there's no point passing around a 64-bit DMA address.

Existing RapidIO controllers offer an address translation mechanism for
inbound RIO requests which will translate RIO address into an address of
mapped endpoint's local buffer. Some less-generic endpoints may also use
upper address bits for their own implementation specific mapping and this
is absolutely legal from the RIO POV. As an example of similar use may be
a PCI bus where upper AD lines are used for device selection during PCI
configuration cycles.       

So RIO addresses of any size are not blindly truncated and cannot be ignored.
  
> 
> 5. In the case of a 64-bit dma_addr_t and a 32-bit DMA engine host
> being
>    asked to transfer >= 4GB, this needs error handing in the DMA engine
>    driver (I don't think its checked for - I know amba-pl08x doesn't.)
> 
> 6. 32-bit dma_addr_t with 64-bit DMA address space is a problem and is
>    probably a bug in itself - the platform should be using a 64-bit
>    dma_addr_t in this case.  (see 3.)

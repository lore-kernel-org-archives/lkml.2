Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226Ab2CMQyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 12:54:31 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:45474 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab2CMQya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 12:54:30 -0400
Date: Tue, 13 Mar 2012 12:49:02 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>, xen-devel@lists.xensource.com,
        Dave Jiang <dave.jiang@intel.com>,
        pkg-xen-devel@lists.alioth.debian.org,
        Thomas Goirand <zigo@debian.org>,
        Maciej Sosnowski <maciej.sosnowski@intel.com>,
        linux-kernel@vger.kernel.org, Jonathan Nieder <jrnieder@gmail.com>,
        William Dauchy <wdauchy@gmail.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>
Subject: Re: [Xen-devel] [Pkg-xen-devel] ioatdma: Boot process hangs then
 reboots when using Xen + Linux 3.2
Message-ID: <20120313164902.GF19228@phenom.dumpdata.com>
References: <CABE8wwt8Lngy=-iL7QGCofy0nW5-q4VJDS_ovEr96fGdYm72ew@mail.gmail.com>
 <20120302162159.GB31683@wavehammer.waldi.eu.org>
 <CABE8wwtrMEAMw3sJgb8XWQWn_N=YOPzhNbLL0kzMKLhv7xt5=A@mail.gmail.com>
 <20120302175719.GA1468@wavehammer.waldi.eu.org>
 <CABE8wwvd-R1VkyFL-eZYDB9O05zyWkVQ8pXuMb8GcdAW=5qT3A@mail.gmail.com>
 <4F54DB1F.3080000@debian.org>
 <CABE8wwtOwgiYwb-_g-3Fg_QH6ph7LEPdkcOff94inDFvs9kwxA@mail.gmail.com>
 <4F55D6F6.2040906@debian.org>
 <CABE8wwsPA2PUx45EbY3w3BAHaHbUMWo7+giK=uU8gx9mbBkRpQ@mail.gmail.com>
 <1331044752.22559.97.camel@cthulhu.hellion.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331044752.22559.97.camel@cthulhu.hellion.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090208.4F5F7B72.005A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2012 at 06:39:12AM -0800, Ian Campbell wrote:
> On Tue, 2012-03-06 at 06:14 -0800, Dan Williams wrote:
> > [    9.276817] ioatdma 0000:00:16.4: desc[0]:
> > (0x300cc7000->0x300cc7040) cookie: 0 flags: 0x2 ctl: 0x29 (op: 0
> > int_en: 1 compl: 1)
> > ...
> > [    9.276832] ioatdma 0000:00:16.4: ioat_get_current_completion:
> > phys_complete: 0xcc7000
> > 
> > Thanks, this clearly shows that our descriptors are above 4GB and that
> > the driver truncates the completion word.
> > 
> > Is this new behavior for xen?
> 
> Xen makes a distinction between physical addresses and DMA addresses and
> the latter can potentially be anywhere in the machine's real address
> space while the former is what GFP_KERNEL etc controls.
> 
> You are using pci_pool_alloc which is the correct API to use for these
> things since it's purpose is to handle cases where PHYS != DMA addr by
> exposing the DMA address to the caller. As part of that you should also
> be using dma_addr_t for DMA addresses since that is the type which is
> defined to handle the appropriate DMA address size on the platform.
> 
> I think this DMA!=PHYS can also be true of some non-x86 architectures

Especially SPARC.
> without Xen too but I guess ioat is quite x86 specific? In any case it
> is wrong, or at least non-portable, to use unsigned long for these
> addresses even though it happens on x86 that physaddr == dma addr
> (usually).

I think with the Intel VT-d that can be different. The bus addresses returned
do seem different.

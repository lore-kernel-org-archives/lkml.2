Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030816Ab2CFOpp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 09:45:45 -0500
Received: from aaar.vm.bytemark.co.uk ([80.68.92.230]:41409 "EHLO
	aaar.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030791Ab2CFOpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 09:45:43 -0500
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Mar 2012 09:45:43 EST
Message-ID: <1331044752.22559.97.camel@cthulhu.hellion.org.uk>
From: Ian Campbell <ijc@hellion.org.uk>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Thomas Goirand <zigo@debian.org>, xen-devel@lists.xensource.com,
        Dave Jiang <dave.jiang@intel.com>,
        pkg-xen-devel@lists.alioth.debian.org,
        Maciej Sosnowski <maciej.sosnowski@intel.com>,
        linux-kernel@vger.kernel.org, Jonathan Nieder <jrnieder@gmail.com>,
        William Dauchy <wdauchy@gmail.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>
Date: Tue, 06 Mar 2012 06:39:12 -0800
In-Reply-To: <CABE8wwsPA2PUx45EbY3w3BAHaHbUMWo7+giK=uU8gx9mbBkRpQ@mail.gmail.com>
References: <CAJ75kXZ-2vWZpG7Uz3firg6ew4y_DdorXotkAkUGSK0GWLMUQQ@mail.gmail.com>
	 <20120127144737.GA27750@andromeda.dapyr.net>
	 <20120219223125.GA820@burratino> <20120220181618.GD17566@burratino>
	 <4F4891B8.9050008@goirand.fr> <20120302055715.GA692@burratino>
	 <CABE8wwt8Lngy=-iL7QGCofy0nW5-q4VJDS_ovEr96fGdYm72ew@mail.gmail.com>
	 <20120302162159.GB31683@wavehammer.waldi.eu.org>
	 <CABE8wwtrMEAMw3sJgb8XWQWn_N=YOPzhNbLL0kzMKLhv7xt5=A@mail.gmail.com>
	 <20120302175719.GA1468@wavehammer.waldi.eu.org>
	 <CABE8wwvd-R1VkyFL-eZYDB9O05zyWkVQ8pXuMb8GcdAW=5qT3A@mail.gmail.com>
	 <4F54DB1F.3080000@debian.org>
	 <CABE8wwtOwgiYwb-_g-3Fg_QH6ph7LEPdkcOff94inDFvs9kwxA@mail.gmail.com>
	 <4F55D6F6.2040906@debian.org>
	 <CABE8wwsPA2PUx45EbY3w3BAHaHbUMWo7+giK=uU8gx9mbBkRpQ@mail.gmail.com>
Organization: 
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 63.145.238.4
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [Pkg-xen-devel] ioatdma: Boot process hangs then reboots when
 using Xen + Linux 3.2
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-06 at 06:14 -0800, Dan Williams wrote:
> [    9.276817] ioatdma 0000:00:16.4: desc[0]:
> (0x300cc7000->0x300cc7040) cookie: 0 flags: 0x2 ctl: 0x29 (op: 0
> int_en: 1 compl: 1)
> ...
> [    9.276832] ioatdma 0000:00:16.4: ioat_get_current_completion:
> phys_complete: 0xcc7000
> 
> Thanks, this clearly shows that our descriptors are above 4GB and that
> the driver truncates the completion word.
> 
> Is this new behavior for xen?

Xen makes a distinction between physical addresses and DMA addresses and
the latter can potentially be anywhere in the machine's real address
space while the former is what GFP_KERNEL etc controls.

You are using pci_pool_alloc which is the correct API to use for these
things since it's purpose is to handle cases where PHYS != DMA addr by
exposing the DMA address to the caller. As part of that you should also
be using dma_addr_t for DMA addresses since that is the type which is
defined to handle the appropriate DMA address size on the platform.

I think this DMA!=PHYS can also be true of some non-x86 architectures
without Xen too but I guess ioat is quite x86 specific? In any case it
is wrong, or at least non-portable, to use unsigned long for these
addresses even though it happens on x86 that physaddr == dma addr
(usually).

Ian.

-- 
Ian Campbell

Start every day off with a smile and get it over with.
		-- W. C. Fields


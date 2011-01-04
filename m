Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456Ab1ADT2C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 14:28:02 -0500
Received: from smtp.citrix.com ([66.165.176.89]:14037 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014Ab1ADT2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 14:28:00 -0500
X-IronPort-AV: E=Sophos;i="4.60,273,1291611600"; 
   d="scan'208";a="11776728"
Subject: Re: [PATCH 3/8] xen/setup: Set identity mapping for non-RAM E820
 and E820 gaps.
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jeremy Fitzhardinge" <jeremy@goop.org>,
        "hpa@zytor.com" <hpa@zytor.com>, "Jan Beulich" <JBeulich@novell.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
In-Reply-To: <20110104183822.GA1505@dumpdata.com>
References: <1293738517-7287-1-git-send-email-konrad.wilk@oracle.com>
	 <1293738517-7287-4-git-send-email-konrad.wilk@oracle.com>
	 <1294161538.3831.639.camel@zakaz.uk.xensource.com>
	 <20110104183822.GA1505@dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Organization: Citrix Systems, Inc.
Date: Tue, 4 Jan 2011 19:27:57 +0000
Message-ID: <1294169277.3582.23.camel@localhost.localdomain>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-04 at 18:38 +0000, Konrad Rzeszutek Wilk wrote: 
> On Tue, Jan 04, 2011 at 05:18:58PM +0000, Ian Campbell wrote:
> > On Thu, 2010-12-30 at 19:48 +0000, Konrad Rzeszutek Wilk wrote:
> > > We walk the E820 region and start at 0 (for PV guests we start
> > > at ISA_END_ADDRESS)
> > 
> > I was trying to figure out what any of this had to do with HVM guests,
> > but you mean as opposed to dom0, which with my pedant hat on is also a
> > guest ;-).
> > 
> > >  and skip any E820 RAM regions. For all other
> > > regions and as well the gaps we set them to be identity mappings.
> > > 
> > > The reasons we do not want to set the identity mapping from 0->
> > > ISA_END_ADDRESS when running as PV is b/c that the kernel would
> > > try to read DMI information and fail (no permissions to read that).
> > 
> > The reason for this special case is that in domU we have already punched
> > a hole from 640k-1M into the e820 which the hypervisor gave us.
> 
> For the privileged guest - yes. But for the non-priviligied it does not have
> such range and would end up failing.

xen_memory_setup has: 
        e820_add_region(ISA_START_ADDRESS, ISA_END_ADDRESS - ISA_START_ADDRESS,
                        E820_RESERVED);
which is unconditional but is actually more for domU's benefit than
dom0's which already sees the host e820 presumably with the right hole
already in place, which we simply shadow, or maybe slightly extend,
here.

In a domU we do this because if you let these pages into the general
allocation pool then they will potentially get used as page table pages
(hence be R/O) but e.g. the DMI code tries to map them to probe for
signatures and tries to does so R/W which fails. We could try and find
everywhere in the kernel which does this or we can simply reserve the
region which stops it getting used for page tables or other special
things, and is somewhat less surprising for non-Xen code.

> > Should we perhaps be doing this identity mapping before we punch that
> > extra hole? i.e. setup ID mappings based on the hypervisors idea of the
> > guest e820 not the munged one we subsequently magicked up? Only the
> 
> You mean the ISA_START_ADDRESS->ISA_END_ADDRESS we mark as reserved?

Yep. 

> It sure would be easier

> (and it would mean we can return that memory back to the hypervisor).

I don't think you can return it, since something like the DMI code which
wants to probe it expects to be able to map that PFN, if you've given
the MFN back then that will fail.

I suppose we could alias all such PFNs to the same scratch MFN but I'd
be concerned about some piece of code which expects to interact with
firmware scribbling over it and surprising some other piece of code
which interacts with the firmware...

Ian.


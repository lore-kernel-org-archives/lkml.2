Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456Ab1ADVkH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 16:40:07 -0500
Received: from andromeda.dapyr.net ([206.212.254.10]:60182 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab1ADVkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 16:40:04 -0500
X-Greylist: delayed 578 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Jan 2011 16:39:56 EST
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Reply-To: konrad.wilk@oracle.com
Organization: Oracle
To: Ian Campbell <Ian.Campbell@eu.citrix.com>
Subject: Re: [PATCH 3/8] xen/setup: Set identity mapping for non-RAM E820 and E820 gaps.
Date: Tue, 4 Jan 2011 16:28:25 -0500
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc4agp-pci-api+; KDE/4.5.1; i686; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jeremy Fitzhardinge" <jeremy@goop.org>,
        "hpa@zytor.com" <hpa@zytor.com>, "Jan Beulich" <JBeulich@novell.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
References: <1293738517-7287-1-git-send-email-konrad.wilk@oracle.com> <20110104183822.GA1505@dumpdata.com> <1294169277.3582.23.camel@localhost.localdomain>
In-Reply-To: <1294169277.3582.23.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101041628.25950.konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > For the privileged guest - yes. But for the non-priviligied it does not
> > have such range and would end up failing.
> 
> xen_memory_setup has:
>         e820_add_region(ISA_START_ADDRESS, ISA_END_ADDRESS -
> ISA_START_ADDRESS, E820_RESERVED);
> which is unconditional but is actually more for domU's benefit than
> dom0's which already sees the host e820 presumably with the right hole
> already in place, which we simply shadow, or maybe slightly extend,
> here.

Actually we don't do anything with that region in Dom0 case. We just
return the PFN without consulting the P2M for 0->0x100 while for DomU _we_
do consult the P2M and set those in the PTE. (look in xen_make_pte)

> 
> In a domU we do this because if you let these pages into the general
> allocation pool then they will potentially get used as page table pages
> (hence be R/O) but e.g. the DMI code tries to map them to probe for
> signatures and tries to does so R/W which fails. We could try and find
> everywhere in the kernel which does this or we can simply reserve the
> region which stops it getting used for page tables or other special
> things, and is somewhat less surprising for non-Xen code.

Yeah, went that hole once.. too many generic pieces of code.
.. snip..
> > You mean the ISA_START_ADDRESS->ISA_END_ADDRESS we mark as reserved?
> 
> Yep.
> 
> > It sure would be easier
> > 
> > (and it would mean we can return that memory back to the hypervisor).
> 
> I don't think you can return it, since something like the DMI code which
> wants to probe it expects to be able to map that PFN, if you've given
> the MFN back then that will fail.

Correct (for non-priviliged PV domain).
> 
> I suppose we could alias all such PFNs to the same scratch MFN but I'd

It actually works. I setup 0x1->0x100 to point to whatever the MFN was at
0x0, and released the pages from 0x1->0x100 and it worked for DomU PV guests 
(and dom0 since I ended up stomping those regions with the PFN|
IDENTITY_BIT_FRAME).

However, the tools weren't happy ('xm save'). They did not like the same PFN 
across a couple of entries in the P2M table and complained about a potential 
race. But there is another way and that is to special case in 'xen_make_pte' 
when we want to create a PTE for 0->ISA_END_ADDRESS and just give it the MFN 
from P2M[0x0] (for !xen_initial_domain()) while having the the pfns from 0x1-
>0x100 freed and set to be IDENTITY_BIT_FRAME... But that all just smacks of 
weird corner cases. Thought the code that is there is already special casing 
access to that region. Maybe it would clear it up a bit.


> be concerned about some piece of code which expects to interact with
> firmware scribbling over it and surprising some other piece of code
> which interacts with the firmware...

Fortunatly the all look for a some signature first before trying to scribble.

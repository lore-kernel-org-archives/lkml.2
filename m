Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab1DENqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 09:46:21 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:65017 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab1DENqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 09:46:20 -0400
X-IronPort-AV: E=Sophos;i="4.63,304,1299456000"; 
   d="scan'208";a="5147407"
Date: Tue, 5 Apr 2011 14:47:33 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Yinghai Lu <yinghai@kernel.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: another pagetable initialization crash on xen
In-Reply-To: <4D936F2D.4000902@kernel.org>
Message-ID: <alpine.DEB.2.00.1104011525260.16492@kaball-desktop>
References: <alpine.DEB.2.00.1103281729190.5516@kaball-desktop> <alpine.DEB.2.00.1103281929390.5516@kaball-desktop> <alpine.DEB.2.00.1103291620560.16492@kaball-desktop> <4D9221DA.90900@kernel.org> <alpine.DEB.2.00.1103301714250.16492@kaball-desktop>
 <alpine.DEB.2.00.1103301748380.16492@kaball-desktop> <4D936F2D.4000902@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Mar 2011, Yinghai Lu wrote:
> On 03/30/2011 09:59 AM, Stefano Stabellini wrote:
> > On Wed, 30 Mar 2011, Stefano Stabellini wrote:
> >> I have another unrelated question: init_memory_mapping is called on the
> >> range 0 - max_low_pfn, but that range usually includes a reserved region
> >> below the first MB. On one machine of mine the IOAPIC mmio region falls
> >> in that memory range therefore we are mapping the IOAPIC mmio region in
> >> init_memory_mapping without going through the fixmap as we should.
> >> This is causing problems on Xen, but I guess it could theoretically
> >> cause problems on other platforms as well. Should we avoid reserved
> >> memory regions below the first MB from the initial memory mappings?
> >
> > Sorry I mixed up frame numbers with physical addresses, so the IOAPIC
> > mmio region is actually at 0xfec00000 where it should be but it gets
> > mapped during the initial memory mapping (range 0 - 0x100000000).
> > Is that supposed to happen? Shouldn't it go through the fixmap?
> 
> io apic addr is going through fixmap.
> 
> initial_memory_mapping will map to [0, max_mem_under_4g).
> max_mem_under_4g is from E820 table searching.
> 
> later it will map [4g, max_mem_above_4g).
> 
> We do not map mmio gap between [max_mem_under_4g,4g)

Thanks for the explanation, I figure out what the problem is: on xen we
add an extra memory region at the end of the e820, and on this
particular machine this extra memory region would start below 4g and
cross over the 4g boundary:

[0xfee01000-0x192655000)


Unfortunately e820_end_of_low_ram_pfn does not expect an
e820 layout like that so it returns 4g, therefore initial_memory_mapping
will map [0 - 0x100000000), that is a memory range that includes some
reserved memory regions.


I would submit a fix that makes sure that the extra memory region is
always added over 4g and not below.

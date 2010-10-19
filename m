Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257Ab0JSKuJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 06:50:09 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:45060 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758160Ab0JSKuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 06:50:06 -0400
X-IronPort-AV: E=Sophos;i="4.57,349,1283731200"; 
   d="scan'208";a="2409115"
Date: Tue, 19 Oct 2010 11:49:41 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>
Subject: Re: [PATCH v3 08/10] xen: use host E820 map for dom0
In-Reply-To: <20101018155412.GD27373@dumpdata.com>
Message-ID: <alpine.DEB.2.00.1010191148550.2423@kaball-desktop>
References: <alpine.DEB.2.00.1010121043030.2422@kaball-desktop> <1286901770-8612-8-git-send-email-Stefano.Stabellini@eu.citrix.com> <20101018155412.GD27373@dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Oct 2010, Konrad Rzeszutek Wilk wrote:
> On Tue, Oct 12, 2010 at 05:42:48PM +0100, Stefano Stabellini wrote:
> > From: Ian Campbell <ian.campbell@citrix.com>
> > 
> > When running as initial domain, get the real physical memory map from
> > xen using the XENMEM_machine_memory_map hypercall and use it to setup
> > the e820 regions.
> > 
> > Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> > Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > ---
> >  arch/x86/xen/setup.c           |   43 +++++++++++++++++++++++++++++++++++++--
> >  include/xen/interface/memory.h |   28 ++++++++++++++++++++++++++
> >  2 files changed, 68 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
> > index 62ceb78..b08aac2 100644
> > --- a/arch/x86/xen/setup.c
> > +++ b/arch/x86/xen/setup.c
> > @@ -107,14 +107,51 @@ static unsigned long __init xen_return_unused_memory(unsigned long max_pfn,
> >  
> >  char * __init xen_memory_setup(void)
> >  {
> > +	static __initdata struct e820entry map[E820MAX];
> > +
> >  	unsigned long max_pfn = xen_start_info->nr_pages;
> > +	struct xen_memory_map memmap;
> > +	unsigned long long mem_end;
> > +	int op;
> > +	int rc;
> > +	int i;
> >  
> >  	max_pfn = min(MAX_DOMAIN_PAGES, max_pfn);
> > +	mem_end = PFN_PHYS((u64)max_pfn);
> > +
> > +	memmap.nr_entries = E820MAX;
> > +	set_xen_guest_handle(memmap.buffer, map);
> > +
> > +	op = xen_initial_domain() ?
> > +		XENMEM_machine_memory_map :
> > +		XENMEM_memory_map;
> > +	rc = HYPERVISOR_memory_op(op, &memmap);
> > +	if (rc == -ENOSYS) {
> > +		memmap.nr_entries = 1;
> > +		map[0].addr = 0ULL;
> > +		map[0].size = mem_end;
> > +		/* 8MB slack (to balance backend allocations). */
> > +		map[0].size += 8ULL << 20;
> > +		map[0].type = E820_RAM;
> > +		rc = 0;
> > +	}
> > +	BUG_ON(rc);
> >  
> >  	e820.nr_map = 0;
> > -
> > -	e820_add_region(0, PFN_PHYS((u64)max_pfn), E820_RAM);
> > -
> > +	for (i = 0; i < memmap.nr_entries; i++) {
> > +		unsigned long long end = map[i].addr + map[i].size;
> > +		if (map[i].type == E820_RAM) {
> > +			if (map[i].addr > mem_end)
> > +				continue;
> 
> Would it make sense to print out a message saying something to the
> effect of: "You need to increase the CONFIG_XEN_MAX_DOMAIN_MEMORY value to
> take advantage of the extra %d gobs of memory!\n", map[i].size
> 
> Or will this be unneccessary with the later changes that Jeremy has
> for the balloon work?
> 

I think it still makes a lot of sense to print that message because
ballooning might be disabled.


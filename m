Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab2HVOKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 10:10:55 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:27815 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab2HVOKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 10:10:52 -0400
Date: Wed, 22 Aug 2012 10:00:39 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "JBeulich@suse.com" <JBeulich@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: Q:pt_base in COMPAT mode offset by two pages. Was:Re:
 [Xen-devel] [PATCH 02/11] xen/x86: Use memblock_reserve for sensitive areas.
Message-ID: <20120822140039.GB30964@phenom.dumpdata.com>
References: <1345133009-21941-1-git-send-email-konrad.wilk@oracle.com>
 <1345133009-21941-3-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.02.1208171835010.15568@kaball.uk.xensource.com>
 <20120820141305.GA2713@phenom.dumpdata.com>
 <20120821172732.GA23715@phenom.dumpdata.com>
 <20120821190317.GA13035@phenom.dumpdata.com>
 <alpine.DEB.2.02.1208221146230.15568@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1208221146230.15568@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	/* Under 64-bit hypervisor with a 32-bit domain, the hypervisor
> > +	 * offsets the pt_base by two pages. Hence the reservation that is done
> > +	 * in mmu.c misses two pages. We correct it here if we detect this. */
> > +	if (last_phys < __pa(xen_start_info->pt_base))
> > +		memblock_reserve(last_phys, __pa(xen_start_info->pt_base) - last_phys);
> >  }
> 
> What are these two pages used for? They are not documented in xen.h, why
> should we reserve them?
> 
> After all we still have:
> 
> memblock_reserve(PFN_PHYS(pt_base), (pt_end - pt_base) * PAGE_SIZE);
> 
> that should protect what we are interested in anyway...

You are looking at the x86_64 piece of code. This issue only appears
on 32-bit which was not modified by my patches and has:

2003         memblock_reserve(__pa(xen_start_info->pt_base),
2004                          xen_start_info->nr_pt_frames * PAGE_SIZE);

and as I found out, the pt_base is wrong. The cr3 we load and use is actually
two pages back!

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab2G3OoJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 10:44:09 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:28497 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703Ab2G3OoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 10:44:05 -0400
X-IronPort-AV: E=Sophos;i="4.77,679,1336348800"; 
   d="scan'208";a="13764326"
Date: Mon, 30 Jul 2012 15:43:48 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 2/4] xen/x86: Use memblock_reserve for
 sensitive areas.
In-Reply-To: <20120727174534.GF17427@andromeda.dapyr.net>
Message-ID: <alpine.DEB.2.02.1207301542120.4645@kaball.uk.xensource.com>
References: <1343334845-5340-1-git-send-email-konrad.wilk@oracle.com> <1343334845-5340-3-git-send-email-konrad.wilk@oracle.com> <alpine.DEB.2.02.1207271139140.26163@kaball.uk.xensource.com> <20120727174534.GF17427@andromeda.dapyr.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2012, Konrad Rzeszutek Wilk wrote:
> On Fri, Jul 27, 2012 at 11:49:02AM +0100, Stefano Stabellini wrote:
> > On Thu, 26 Jul 2012, Konrad Rzeszutek Wilk wrote:
> > > instead of a big memblock_reserve. This way we can be more
> > > selective in freeing regions (and it also makes it easier
> > > to understand where is what).
> > > 
> > > [v1: Move the auto_translate_physmap to proper line]
> > > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > > ---
> > >  arch/x86/xen/enlighten.c |   38 ++++++++++++++++++++++++++++++++++++++
> > >  arch/x86/xen/p2m.c       |    5 +++++
> > >  arch/x86/xen/setup.c     |    9 ---------
> > >  3 files changed, 43 insertions(+), 9 deletions(-)
> > > 
> > > diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> > > index ff962d4..9b1afa4 100644
> > > --- a/arch/x86/xen/enlighten.c
> > > +++ b/arch/x86/xen/enlighten.c
> > > @@ -998,7 +998,44 @@ static int xen_write_msr_safe(unsigned int msr, unsigned low, unsigned high)
> > >  
> > >  	return ret;
> > >  }
> > > +static void __init xen_reserve_mfn(unsigned long mfn)
> > > +{
> > > +	unsigned long pfn;
> > > +
> > > +	if (!mfn)
> > > +		return;
> > > +	pfn = mfn_to_pfn(mfn);
> > > +	if (phys_to_machine_mapping_valid(pfn))
> > > +		memblock_reserve(PFN_PHYS(pfn), PAGE_SIZE);
> > > +}
> > 
> > If the mfn is not in the m2p xen_reserve_mfn won't do anything. It is
> > worth writing it down in a comment.
> 
> Meaning in a printk?

I meant a comment in the code.


> > > +static void __init xen_reserve_internals(void)
> > > +{
> > > +	unsigned long size;
> > > +
> > > +	if (!xen_pv_domain())
> > > +		return;
> > > +
> > > +	memblock_reserve(__pa(xen_start_info), PAGE_SIZE);
> > 
> > xen_start_info is not in the m2p, so you cannot use xen_reserve_mfn
> 
> It seems to work for me. For both the toolstack created guests
> and dom0. Let me double check thought.

I was just thinking out loud: you are calling memblock_reserve rather
than xen_reserve_mfn, because xen_reserve_mfn wouldn't work in this case
as xen_start_info is not in the m2p.

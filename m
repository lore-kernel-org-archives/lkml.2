Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab1AKPZH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 10:25:07 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:19153 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756151Ab1AKPZE (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 11 Jan 2011 10:25:04 -0500
Date: Tue, 11 Jan 2011 10:24:40 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: [PATCH 05/12] xen: add m2p override mechanism
Message-ID: <20110111152439.GB10897@dumpdata.com>
References: <alpine.DEB.2.00.1101101012190.2390@kaball-desktop>
 <1294655801-16230-5-git-send-email-stefano.stabellini@eu.citrix.com>
 <20110110231121.GB16550@dumpdata.com>
 <alpine.DEB.2.00.1101111202020.7277@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1101111202020.7277@kaball-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 12:44:39PM +0000, Stefano Stabellini wrote:
> On Mon, 10 Jan 2011, Konrad Rzeszutek Wilk wrote:
> > > @@ -83,6 +85,14 @@ static inline unsigned long mfn_to_pfn(unsigned long mfn)
> > >  	 */
> > >  	__get_user(pfn, &machine_to_phys_mapping[mfn]);
> > >  
> > > +	/*
> > > +	 * If this appears to be a foreign mfn (because the pfn
> > > +	 * doesn't map back to the mfn), then check the local override
> > > +	 * table to see if there's a better pfn to use.
> > > +	 */
> > > +	if (get_phys_to_machine(pfn) != mfn)
> > 
> > Any reason to not use 'pfn_to_mfn' call instead? If we do want
> > to use the get_hhys_to_machine wouldn't be easier to just
> > check for 'FOREIGN_FRAME_BIT' set? Or is just mostly a copy-n-paste
> > of mfn_to_local_pfn?
> 
> 
> pfn in this case is the return value of m2p(mfn); there are 3 possible
> cases:
> 
> 1) the mfn was a regular ram page belonging to the domain so
> get_phys_to_machine(pfn) == mfn. Nothing to see here.
> 
> 2) the mfn was a granted page so pfn is actually the pfn in the source
> domain and doesn't mean anything in our domain. 
> In this case get_phys_to_machine(pfn) is always different from mfn,
> either because the mapping in our domain is just different or because
> the FOREIGN_FRAME_BIT is set.
> 
> 3) the pfn belongs to a 1:1 region. In this case
> get_phys_to_machine(pfn) != mfn because of the IDENTITY_FRAME_BIT but we
> don't actually want to look in the m2p_override because we are not going
> to find anything useful there.
> 
> 
> Considering all this, I propose this change:
> 
> if (get_phys_to_machine(pfn) != mfn)
> 
> into
> 
> if (pfn_to_mfn(pfn) != mfn)
> 
> because:
> 
> - it won't make any differences in case 1);
> 
> - it will avoid false potives in case 3);
> 
> - in case 2) if p2m(pfn) => mfn in both the source and the destination
> domain then we might skip the check in the m2p_override but we don't
> care because by luck we got the correct value anyway (m2p(mfn) ==
> m2p_override(mfn)).
> 
> 
> 
> However I understand that it might be subtle and needs a very long
> comment so a simpler alternative would be to explicitly remove the
> IDENTITY_FRAME_BIT from the check:
> 
> if ((get_phys_to_machine(pfn) & ~IDENTITY_FRAME_BIT) != mfn)

Thank you analyzing this in such depth. Let me create a branch with
this patchset (devel/grantdev.v2), merge it with the devel/p2m-identity one and
then on top of that create a patch that will what you just suggested (removing
the IDENTITY_FRAME_BIT) and make the author you.

That way we have something we can test with both modifications to the
P2M and M2P lookups and weed out any bugs.


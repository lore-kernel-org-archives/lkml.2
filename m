Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab1BBLua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 06:50:30 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:34942 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab1BBLu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 06:50:27 -0500
X-IronPort-AV: E=Sophos;i="4.60,413,1291593600"; 
   d="scan'208";a="4105029"
Date: Wed, 2 Feb 2011 11:52:06 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "konrad@kernel.org" <konrad@kernel.org>,
        "jeremy@goop.org" <jeremy@goop.org>, "hpa@zytor.com" <hpa@zytor.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>
Subject: Re: [PATCH 11/11] xen/m2p: Check whether the MFN has IDENTITY_FRAME
 bit set..
In-Reply-To: <20110201202923.GC18656@dumpdata.com>
Message-ID: <alpine.DEB.2.00.1102021128350.7277@kaball-desktop>
References: <1296513876-31415-1-git-send-email-konrad.wilk@oracle.com> <1296513876-31415-12-git-send-email-konrad.wilk@oracle.com> <alpine.DEB.2.00.1102011513190.7277@kaball-desktop> <20110201202923.GC18656@dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Feb 2011, Konrad Rzeszutek Wilk wrote:
> > I have been thinking some more about it and now I have few questions:
> > 
> > 1) is it possible for a single domain to have a valid mfn with the same
> > number as an identity mfn (apart from the IDENTITY_FRAME bit)?
> 
> Yes.
> > 
> > 2) is it true that mfn_to_pfn should never be called passing an identity
> > mfn (because we set _PAGE_IOMAP)?
> 
> Yes. And currently the code checks for _PAGE_IOMAP and bypasses the
> M2P.
> 
> > 
> > 3) what is the value returned by m2p(identity_mfn)? Is it a correct pfn
> > or may be something like 0xfffff or 0xeeeee?
> 
> 0xFFFFF... or 0x5555555..
> > 
> > 
> > These are my guessed answers:
> > 
> > 1) yes, it is possible.
> > For example mfn=0xc0100 might be a valid ram mfn present in the mfn_list
> > of a domU and also be present as 1:1 mfn of the 3G-4G region.
> 
> If we consider it valid, then it would be in the E820 as an E820_RAM
> type. The xen_setup_identity code would skip over that region and not
> mark is as IDENTITY.
> 
> Keep in mind the code skips over small/big E820_RAM regions even if
> those regions have reserved E820 regions on both sides.
> 
> > For this reason I think we should look in m2p_override first and check
> > for possible identity mapping later.
> > We might want to avoid these situations but the only way I can see to do
> > it would be to make sure that the 1:1 regions are always subset of
> > the host reserved regions, even for domUs.
> 
> Right, and they are...
> > 
> > 2) yes indeed.
> > One more reason to look in the m2p_override first.
> 
> Not sure I understand.

Considering that getting in this function with an identity mfn passed as
argument shouldn't happen at all, and considering that there are cases
in which the same mfn can correspond to a normal mapping, a 1:1 mapping
or even a granted page, it is a good idea to check the m2p_override
*before* checking if the mfn is an identity mfn.
So that if there are two identical mfns, one granted and the other
one belonging to an identity mapping, we would return the pfn
corresponding to the granted mfn, that is the right answer because we
shouldn't even be here if the argument was an identity mfn.


> > 3) the returned pfn might be 0xfffff or 0xeeeee.
> > We should use the mfn value directly as pfn value to check for possible
> > identity mappings.
> 
> Aren't we doing that via 'get_phys_to_machine' ? It returns the value
> and if it has the IDENTITY_FRAME_BIT it is an identity.
> 
> Or are you thinking of abolishing the IDENTITY_FRAME_BIT and check the
> M2P in conjunction with the P2M to see if the mfn is a 1-1 mapping?
> 

Not at all.
The problem is the following:

pfn = m2p(mfn);

let's suppose that pfn is garbage (0xFFFFF.. or 0x55555..), in this case
get_phys_to_machine(pfn) will return INVALID_P2M_ENTRY that is not what
we want.
So we check for

get_phys_to_machine(mfn) == IDENTITY_FRAME(mfn)
                    ---
if it is true than it means that the mfn passed as argument belongs to
an identity mapping.



> > 
> > The resulting patch looks like the following:
> > 
> > ---
> > 
> > 
> > diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
> > index ed46ec2..7f9bae2 100644
> > --- a/arch/x86/include/asm/xen/page.h
> > +++ b/arch/x86/include/asm/xen/page.h
> > @@ -80,6 +80,7 @@ static inline int phys_to_machine_mapping_valid(unsigned long pfn)
> >  
> >  static inline unsigned long mfn_to_pfn(unsigned long mfn)
> >  {
> > +	int ret = 0;
> >  	unsigned long pfn;
> >  
> >  	if (xen_feature(XENFEAT_auto_translated_physmap))
> > @@ -95,15 +96,21 @@ static inline unsigned long mfn_to_pfn(unsigned long mfn)
> >  	 * In such cases it doesn't matter what we return (we return garbage),
> >  	 * but we must handle the fault without crashing!
> >  	 */
> > -	__get_user(pfn, &machine_to_phys_mapping[mfn]);
> > +	ret = __get_user(pfn, &machine_to_phys_mapping[mfn]);
> >  try_override:
> >  	/*
> >  	 * If this appears to be a foreign mfn (because the pfn
> >  	 * doesn't map back to the mfn), then check the local override
> >  	 * table to see if there's a better pfn to use.
> >  	 */
> > -	if (get_phys_to_machine(pfn) != mfn)
> > -		pfn = m2p_find_override_pfn(mfn, pfn);
> > +	if (ret < 0)
> > +		pfn = ~0;
> > +	else if (get_phys_to_machine(pfn) != mfn)
> > +		pfn = m2p_find_override_pfn(mfn, ~0);
> > +
> > +	if (pfn == ~0 &&
> 
> You should also check for 0x55555... then.

that is not necessary because pfn == ~0 at this point, this is the code
path:

ret = __get_user(pfn, &machine_to_phys_mapping[mfn]); /* ret is >= 0 and
                                                       pfn is 0x55555.. */
get_phys_to_machine(0x55555) != mfn /* true, I am assuming there are no
                                     valid p2m mappings at 0x55555.. */
pfn = m2p_find_override_pfn(mfn, ~0); /* the m2p_ovverride doesn't find
                                         anything so it returns ~0 (the
                                         second argument), pfn == ~0 now */
if (pfn == ~0 && /* true */


maybe I should add a comment (and drink less caffeine)?


> > +			get_phys_to_machine(mfn) == IDENTITY_FRAME(mfn))
> > +		pfn = mfn;
> 
> So for identity type mfns we end up calling 'get_phys_to_machine(mfn)' twice
> I think?
> 
> Would it make sense to save the result of 'get_phys_to_machine(mfn)'
> the first call?

the first call is get_phys_to_machine(pfn), with pfn potentially
garbage; this call is get_phys_to_machine(mfn).

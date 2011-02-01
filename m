Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279Ab1BAUaQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 15:30:16 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:18135 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802Ab1BAUaO (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 1 Feb 2011 15:30:14 -0500
Date: Tue, 1 Feb 2011 15:29:23 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "konrad@kernel.org" <konrad@kernel.org>,
        "jeremy@goop.org" <jeremy@goop.org>, "hpa@zytor.com" <hpa@zytor.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>
Subject: Re: [PATCH 11/11] xen/m2p: Check whether the MFN has
 IDENTITY_FRAME bit set..
Message-ID: <20110201202923.GC18656@dumpdata.com>
References: <1296513876-31415-1-git-send-email-konrad.wilk@oracle.com>
 <1296513876-31415-12-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.00.1102011513190.7277@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1102011513190.7277@kaball-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 05:52:29PM +0000, Stefano Stabellini wrote:
> On Mon, 31 Jan 2011, Konrad Rzeszutek Wilk wrote:
> > From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > 
> > If we have the IDENTITY_FRAME bit set from the P2M, there
> > is no point in looking up MFN in the M2P override. This is
> > b/c the MFN is a physical MFN.
> > 
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  arch/x86/include/asm/xen/page.h |    8 +++++++-
> >  1 files changed, 7 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
> > index ed46ec2..e6f7f37 100644
> > --- a/arch/x86/include/asm/xen/page.h
> > +++ b/arch/x86/include/asm/xen/page.h
> > @@ -81,6 +81,7 @@ static inline int phys_to_machine_mapping_valid(unsigned long pfn)
> >  static inline unsigned long mfn_to_pfn(unsigned long mfn)
> >  {
> >  	unsigned long pfn;
> > +	unsigned long p2m_mfn;
> >  
> >  	if (xen_feature(XENFEAT_auto_translated_physmap))
> >  		return mfn;
> > @@ -102,7 +103,12 @@ try_override:
> >  	 * doesn't map back to the mfn), then check the local override
> >  	 * table to see if there's a better pfn to use.
> >  	 */
> > -	if (get_phys_to_machine(pfn) != mfn)
> > +	p2m_mfn = get_phys_to_machine(pfn);
> > +
> > +	if (p2m_mfn == IDENTITY_FRAME(mfn))
> > +		return pfn;
> > +
> > +	if (p2m_mfn != mfn)
> >  		pfn = m2p_find_override_pfn(mfn, pfn);
> >  
> >  	return pfn;
>  
> 
> I have been thinking some more about it and now I have few questions:
> 
> 1) is it possible for a single domain to have a valid mfn with the same
> number as an identity mfn (apart from the IDENTITY_FRAME bit)?

Yes.
> 
> 2) is it true that mfn_to_pfn should never be called passing an identity
> mfn (because we set _PAGE_IOMAP)?

Yes. And currently the code checks for _PAGE_IOMAP and bypasses the
M2P.

> 
> 3) what is the value returned by m2p(identity_mfn)? Is it a correct pfn
> or may be something like 0xfffff or 0xeeeee?

0xFFFFF... or 0x5555555..
> 
> 
> These are my guessed answers:
> 
> 1) yes, it is possible.
> For example mfn=0xc0100 might be a valid ram mfn present in the mfn_list
> of a domU and also be present as 1:1 mfn of the 3G-4G region.

If we consider it valid, then it would be in the E820 as an E820_RAM
type. The xen_setup_identity code would skip over that region and not
mark is as IDENTITY.

Keep in mind the code skips over small/big E820_RAM regions even if
those regions have reserved E820 regions on both sides.

> For this reason I think we should look in m2p_override first and check
> for possible identity mapping later.
> We might want to avoid these situations but the only way I can see to do
> it would be to make sure that the 1:1 regions are always subset of
> the host reserved regions, even for domUs.

Right, and they are...
> 
> 2) yes indeed.
> One more reason to look in the m2p_override first.

Not sure I understand.
> 
> 3) the returned pfn might be 0xfffff or 0xeeeee.
> We should use the mfn value directly as pfn value to check for possible
> identity mappings.

Aren't we doing that via 'get_phys_to_machine' ? It returns the value
and if it has the IDENTITY_FRAME_BIT it is an identity.

Or are you thinking of abolishing the IDENTITY_FRAME_BIT and check the
M2P in conjunction with the P2M to see if the mfn is a 1-1 mapping?

> 
> 
> The resulting patch looks like the following:
> 
> ---
> 
> 
> diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
> index ed46ec2..7f9bae2 100644
> --- a/arch/x86/include/asm/xen/page.h
> +++ b/arch/x86/include/asm/xen/page.h
> @@ -80,6 +80,7 @@ static inline int phys_to_machine_mapping_valid(unsigned long pfn)
>  
>  static inline unsigned long mfn_to_pfn(unsigned long mfn)
>  {
> +	int ret = 0;
>  	unsigned long pfn;
>  
>  	if (xen_feature(XENFEAT_auto_translated_physmap))
> @@ -95,15 +96,21 @@ static inline unsigned long mfn_to_pfn(unsigned long mfn)
>  	 * In such cases it doesn't matter what we return (we return garbage),
>  	 * but we must handle the fault without crashing!
>  	 */
> -	__get_user(pfn, &machine_to_phys_mapping[mfn]);
> +	ret = __get_user(pfn, &machine_to_phys_mapping[mfn]);
>  try_override:
>  	/*
>  	 * If this appears to be a foreign mfn (because the pfn
>  	 * doesn't map back to the mfn), then check the local override
>  	 * table to see if there's a better pfn to use.
>  	 */
> -	if (get_phys_to_machine(pfn) != mfn)
> -		pfn = m2p_find_override_pfn(mfn, pfn);
> +	if (ret < 0)
> +		pfn = ~0;
> +	else if (get_phys_to_machine(pfn) != mfn)
> +		pfn = m2p_find_override_pfn(mfn, ~0);
> +
> +	if (pfn == ~0 &&

You should also check for 0x55555... then.

> +			get_phys_to_machine(mfn) == IDENTITY_FRAME(mfn))
> +		pfn = mfn;

So for identity type mfns we end up calling 'get_phys_to_machine(mfn)' twice
I think?

Would it make sense to save the result of 'get_phys_to_machine(mfn)'
the first call?

>  
>  	return pfn;
>  }

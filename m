Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab1BBQo7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 11:44:59 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:27793 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038Ab1BBQo6 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 2 Feb 2011 11:44:58 -0500
Date: Wed, 2 Feb 2011 11:43:07 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "jeremy@goop.org" <jeremy@goop.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "konrad@kernel.org" <konrad@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [Xen-devel] Re: [PATCH 11/11] xen/m2p: Check whether the MFN
 has IDENTITY_FRAME bit set..
Message-ID: <20110202164307.GB14834@dumpdata.com>
References: <1296513876-31415-1-git-send-email-konrad.wilk@oracle.com>
 <1296513876-31415-12-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.00.1102011513190.7277@kaball-desktop>
 <20110201202923.GC18656@dumpdata.com>
 <alpine.DEB.2.00.1102021128350.7277@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1102021128350.7277@kaball-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4D4989FE.0202:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Not sure I understand.
> 
> Considering that getting in this function with an identity mfn passed as
> argument shouldn't happen at all, and considering that there are cases

True, unless a developer wants to check that p2m(m2p(mfn))=mfn and 
supplies the MFNs that cover the PCI BAR spaces.. but that is mostly
done when trying to troubleshoot something and normal folks won't do this.


> in which the same mfn can correspond to a normal mapping, a 1:1 mapping
> or even a granted page, it is a good idea to check the m2p_override
> *before* checking if the mfn is an identity mfn.
> So that if there are two identical mfns, one granted and the other
> one belonging to an identity mapping, we would return the pfn

How can you have that? Are you passing through a PCI device to
a PV domain, making the PV domain have the netback/blkback device,
and then granting those pages to another domain?

> corresponding to the granted mfn, that is the right answer because we
> shouldn't even be here if the argument was an identity mfn.
> 
> 
> > > 3) the returned pfn might be 0xfffff or 0xeeeee.

>From the machine_to_phys_mapping array. OK.
> > > We should use the mfn value directly as pfn value to check for possible
> > > identity mappings.
> > 
> > Aren't we doing that via 'get_phys_to_machine' ? It returns the value
> > and if it has the IDENTITY_FRAME_BIT it is an identity.
> > 
> > Or are you thinking of abolishing the IDENTITY_FRAME_BIT and check the
> > M2P in conjunction with the P2M to see if the mfn is a 1-1 mapping?
> > 
> 
> Not at all.
> The problem is the following:
> 
> pfn = m2p(mfn);

You are assuming that the 'mfn' is outside the scope off our machine_to_phys array
or that it is "garbage", such as 0xdeadbeef for example, I think.

In which case the pfn value is either 0xdeadbeef or INVALID_P2M_ENTRY.

If you provide that to get_phys_to_machine(0xdeadbeef) you get INVALID_P2M_ENTRY,
and you would call:
  pfn = m2p_find_override_pfn(mfn, pfn);

So we still end up checking the M2P override. If the pfn supplied
was INVALID_P2M_ENTRY, you would get the same value and still check the P2M override.


> 
> let's suppose that pfn is garbage (0xFFFFF.. or 0x55555..), in this case

0xFFFF or 0x5555 are not garbage. They are valid values. Garbage is the
value zero. 0xFFFF.. has two meanings: It is a missing page that can be
balloon-ed in, or it belongs to the DOMID_IO. The 0x5555.. means it is
a shared DOMID_IO page.

> get_phys_to_machine(pfn) will return INVALID_P2M_ENTRY that is not what
> we want.
> So we check for
> 
> get_phys_to_machine(mfn) == IDENTITY_FRAME(mfn)
>                     ---
> if it is true than it means that the mfn passed as argument belongs to
> an identity mapping.

<nods> Yup.
> 
> 
> 
> > > 
> > > The resulting patch looks like the following:
> > > 
> > > ---
> > > 
> > > 
> > > diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
> > > index ed46ec2..7f9bae2 100644
> > > --- a/arch/x86/include/asm/xen/page.h
> > > +++ b/arch/x86/include/asm/xen/page.h
> > > @@ -80,6 +80,7 @@ static inline int phys_to_machine_mapping_valid(unsigned long pfn)
> > >  
> > >  static inline unsigned long mfn_to_pfn(unsigned long mfn)
> > >  {
> > > +	int ret = 0;
> > >  	unsigned long pfn;
> > >  
> > >  	if (xen_feature(XENFEAT_auto_translated_physmap))
> > > @@ -95,15 +96,21 @@ static inline unsigned long mfn_to_pfn(unsigned long mfn)
> > >  	 * In such cases it doesn't matter what we return (we return garbage),
> > >  	 * but we must handle the fault without crashing!
> > >  	 */
> > > -	__get_user(pfn, &machine_to_phys_mapping[mfn]);
> > > +	ret = __get_user(pfn, &machine_to_phys_mapping[mfn]);
> > >  try_override:
> > >  	/*
> > >  	 * If this appears to be a foreign mfn (because the pfn
> > >  	 * doesn't map back to the mfn), then check the local override
> > >  	 * table to see if there's a better pfn to use.
> > >  	 */
> > > -	if (get_phys_to_machine(pfn) != mfn)
> > > -		pfn = m2p_find_override_pfn(mfn, pfn);
> > > +	if (ret < 0)
> > > +		pfn = ~0;
> > > +	else if (get_phys_to_machine(pfn) != mfn)
> > > +		pfn = m2p_find_override_pfn(mfn, ~0);
> > > +
> > > +	if (pfn == ~0 &&
> > 
> > You should also check for 0x55555... then.
> 
> that is not necessary because pfn == ~0 at this point, this is the code
> path:
> 
> ret = __get_user(pfn, &machine_to_phys_mapping[mfn]); /* ret is >= 0 and
>                                                        pfn is 0x55555.. */
> get_phys_to_machine(0x55555) != mfn /* true, I am assuming there are no
>                                      valid p2m mappings at 0x55555.. */

> pfn = m2p_find_override_pfn(mfn, ~0); /* the m2p_ovverride doesn't find
>                                          anything so it returns ~0 (the
>                                          second argument), pfn == ~0 now */
> if (pfn == ~0 && /* true */
> 
> 
> maybe I should add a comment (and drink less caffeine)?

The first time I saw the patch I missed that you passed in 'mfn' to
the second get_phys_to_machine .. Comments are good here I think.
> 
> 
> > > +			get_phys_to_machine(mfn) == IDENTITY_FRAME(mfn))
> > > +		pfn = mfn;
> > 
> > So for identity type mfns we end up calling 'get_phys_to_machine(mfn)' twice
> > I think?
> > 
> > Would it make sense to save the result of 'get_phys_to_machine(mfn)'
> > the first call?
> 
> the first call is get_phys_to_machine(pfn), with pfn potentially
> garbage; this call is get_phys_to_machine(mfn).

I think what you are telling me is that it is pointless to check for
the IDENTITY_FRAME b/c it won't happen often or at all.

So moving the code so that we do the hot-paths first makes more
sense and we should structure the code as so, right?

I agree with that sentiment, do you want to prep another patch that
has this patch and also some more comments?

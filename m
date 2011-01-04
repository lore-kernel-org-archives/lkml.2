Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab1ADQqE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 11:46:04 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:36025 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab1ADQqC (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 4 Jan 2011 11:46:02 -0500
Date: Tue, 4 Jan 2011 11:45:44 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>, "hpa@zytor.com" <hpa@zytor.com>,
        Jan Beulich <JBeulich@novell.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [PATCH 7/8] xen/mmu: Introduce IDENTITY_FRAME_BIT
Message-ID: <20110104164544.GB7543@dumpdata.com>
References: <1293738517-7287-1-git-send-email-konrad.wilk@oracle.com>
 <1293738517-7287-8-git-send-email-konrad.wilk@oracle.com>
 <1294158375.3831.490.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294158375.3831.490.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 04, 2011 at 04:26:15PM +0000, Ian Campbell wrote:
> On Thu, 2010-12-30 at 19:48 +0000, Konrad Rzeszutek Wilk wrote:
> > @@ -52,9 +53,12 @@ static inline unsigned long pfn_to_mfn(unsigned long pfn)
> >  
> >  	mfn = get_phys_to_machine(pfn);
> >  
> > -	if (mfn != INVALID_P2M_ENTRY)
> > +	if (mfn != INVALID_P2M_ENTRY) {
> >  		mfn &= ~FOREIGN_FRAME_BIT;
> >  
> > +		if (mfn & IDENTITY_FRAME_BIT)
> > +			mfn &= ~IDENTITY_FRAME_BIT;
> > +	}
> 
> I don't think the inner-if buys us anything here and the whole thing is
> equivalent to:
> 	if (mfn != INVALID_P2M_ENTRY)
> 		mfn &= ~(FOREIGN_FRAME_BIT|IDENTITY_FRAME_BIT);
> 
> Not sure if the FOREIGN_FRAME_BIT|IDENTITY_FRAME_BIT construct gets
> enough use to be worthy of a #define FRAME_TYPE_MASK etc.

Yeah, that is much better.
> 
> >  	return mfn;
> >  }
> >  
> > diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> > index d98bd43..d470435 100644
> > --- a/arch/x86/xen/mmu.c
> > +++ b/arch/x86/xen/mmu.c
> > @@ -425,10 +425,10 @@ unsigned long get_phys_to_machine(unsigned long pfn)
> >  	 * would be wrong.
> >  	 */
> >  	if (p2m_top[topidx] == p2m_mid_identity)
> > -		return pfn;
> > +		return pfn | IDENTITY_FRAME_BIT;
> 
> It's probably worth defining IDENTITY_FRAME(m) in the pattern of
> FOREIGN_FRAME(m).

<nods>

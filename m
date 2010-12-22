Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618Ab0LVPI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 10:08:28 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:38196 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455Ab0LVPI1 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 22 Dec 2010 10:08:27 -0500
Date: Wed, 22 Dec 2010 10:07:59 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com,
        Jan Beulich <JBeulich@novell.com>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: Re: [PATCH 06/10] xen/setup: Only set identity mapping in E820
 regions when privileged.
Message-ID: <20101222150759.GG1760@dumpdata.com>
References: <1292967460-15709-1-git-send-email-konrad.wilk@oracle.com>
 <1292967460-15709-7-git-send-email-konrad.wilk@oracle.com>
 <4D112C0D.6060400@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D112C0D.6060400@goop.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 02:37:01PM -0800, Jeremy Fitzhardinge wrote:
> On 12/21/2010 01:37 PM, Konrad Rzeszutek Wilk wrote:
> > We do not want to set the identity mapping on E820 reserved
> > regions when running as PV. This is b/c the 0->ISA_END_ADDRESS region
> > would be considered identity and we would try to read DMI information
> > and fail (since the pfn_to_mfn(mfn)==pfn) under PV guests.
> >
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  arch/x86/xen/setup.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
> > index 752c865..34fb906 100644
> > --- a/arch/x86/xen/setup.c
> > +++ b/arch/x86/xen/setup.c
> > @@ -160,7 +160,7 @@ static unsigned long __init xen_set_identity(const struct e820map *e820)
> >  		if (end < start)
> >  			continue;
> >  
> > -		if (e820->map[i].type != E820_RAM) {
> > +		if (xen_initial_domain() && e820->map[i].type != E820_RAM) {
> >  			for (pfn = PFN_UP(start); pfn < PFN_DOWN(end); pfn++)
> >  				set_phys_to_machine(pfn, pfn);
> >  			identity += pfn - PFN_UP(start);
> 
> So you're relying on the fact that the ISA area is the only non-RAM e820
> entry in domU?  I think it would be better to do a specific exclusion
> for the ISA area rather than this.

Ok. I've rolled something along what xen_return_unused regions does in the
function.

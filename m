Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab2JVQRN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 12:17:13 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:44541 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab2JVQRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 12:17:12 -0400
Date: Mon, 22 Oct 2012 12:04:56 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "mukesh.rathor@oracle.com" <mukesh.rathor@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [PATCH 5/6] xen/pvh: balloon and grant changes.
Message-ID: <20121022160455.GC25200@phenom.dumpdata.com>
References: <1350695882-12820-1-git-send-email-konrad.wilk@oracle.com>
 <1350695882-12820-6-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.02.1210221423510.2689@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1210221423510.2689@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 02:25:43PM +0100, Stefano Stabellini wrote:
> On Sat, 20 Oct 2012, Konrad Rzeszutek Wilk wrote:
> > From: Mukesh Rathor <mukesh.rathor@oracle.com>
> > 
> > For balloon changes we skip setting of local P2M as it's updated
> > in Xen. For grant, the shared grant frame is the pfn and not mfn,
> > hence its mapped via the same code path as HVM.
> > 
> > Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  drivers/xen/balloon.c     |   15 +++++++++------
> >  drivers/xen/gntdev.c      |    3 ++-
> >  drivers/xen/grant-table.c |   26 ++++++++++++++++++++++----
> >  3 files changed, 33 insertions(+), 11 deletions(-)
> > 
> > diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
> > index 31ab82f..c825b63 100644
> > --- a/drivers/xen/balloon.c
> > +++ b/drivers/xen/balloon.c
> > @@ -361,7 +361,9 @@ static enum bp_state increase_reservation(unsigned long nr_pages)
> >  		set_phys_to_machine(pfn, frame_list[i]);
> >  
> >  		/* Link back into the page tables if not highmem. */
> > -		if (xen_pv_domain() && !PageHighMem(page)) {
> > +		if (xen_pv_domain() && !PageHighMem(page) &&
> > +		    !xen_feature(XENFEAT_auto_translated_physmap)) {

This could be done as:

	if ((xen_pv_domain() && !PageHighMem(page) && !xen_feature(XENFEAT_auto_translated_physmap))

Just to make it more easier to read.

> > +
> >  			int ret;
> >  			ret = HYPERVISOR_update_va_mapping(
> >  				(unsigned long)__va(pfn << PAGE_SHIFT),
> > @@ -418,12 +420,13 @@ static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
> >  		scrub_page(page);
> >  
> >  		if (xen_pv_domain() && !PageHighMem(page)) {
> > -			ret = HYPERVISOR_update_va_mapping(
> > -				(unsigned long)__va(pfn << PAGE_SHIFT),
> > -				__pte_ma(0), 0);
> > -			BUG_ON(ret);
> > +			if (!xen_feature(XENFEAT_auto_translated_physmap)) {
> > +				ret = HYPERVISOR_update_va_mapping(
> > +					(unsigned long)__va(pfn << PAGE_SHIFT),
> > +					__pte_ma(0), 0);
> > +				BUG_ON(ret);
> > +			}
> >  		}
> 
> this change, unlike the one before, actually makes things different for
> traditional pv domains in case PageHighMem(page).

How? He is not altering the !PageHighMem check. Just adding a check
before the hypercall to render it nop on PVH.


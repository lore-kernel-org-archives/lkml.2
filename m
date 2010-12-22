Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab0LVOxl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 09:53:41 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:59559 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab0LVOxk (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 22 Dec 2010 09:53:40 -0500
Date: Wed, 22 Dec 2010 09:53:27 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com,
        Jan Beulich <JBeulich@novell.com>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: Re: [PATCH 01/10] xen: Make all reserved pages for the balloon be
 INVALID_P2M_ENTRY.
Message-ID: <20101222145327.GA1760@dumpdata.com>
References: <1292967460-15709-1-git-send-email-konrad.wilk@oracle.com>
 <1292967460-15709-2-git-send-email-konrad.wilk@oracle.com>
 <4D1127FC.8060102@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D1127FC.8060102@goop.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 02:19:40PM -0800, Jeremy Fitzhardinge wrote:
> On 12/21/2010 01:37 PM, Konrad Rzeszutek Wilk wrote:
> > This patch prepares ourselves for the case where void entries in the P2M
> > tree structure do not necessarily imply that the pages are missing.
> > With this, we diligently set regions that will be used by the
> > balloon driver to be INVALID_P2M_ENTRY and under the ownership
> > of the balloon driver.
> >
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  arch/x86/xen/setup.c  |    8 ++++++++
> >  drivers/xen/balloon.c |    1 +
> >  2 files changed, 9 insertions(+), 0 deletions(-)
> >
> > diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
> > index b5a7f92..d984d36 100644
> > --- a/arch/x86/xen/setup.c
> > +++ b/arch/x86/xen/setup.c
> > @@ -52,6 +52,8 @@ phys_addr_t xen_extra_mem_start, xen_extra_mem_size;
> >  
> >  static __init void xen_add_extra_mem(unsigned long pages)
> >  {
> > +	unsigned long pfn;
> > +
> >  	u64 size = (u64)pages * PAGE_SIZE;
> >  	u64 extra_start = xen_extra_mem_start + xen_extra_mem_size;
> >  
> > @@ -66,6 +68,11 @@ static __init void xen_add_extra_mem(unsigned long pages)
> >  	xen_extra_mem_size += size;
> >  
> >  	xen_max_p2m_pfn = PFN_DOWN(extra_start + size);
> > +
> > +	for (pfn = PFN_DOWN(extra_start); pfn <= xen_max_p2m_pfn; pfn++) {
> > +		BUG_ON(!set_phys_to_machine(pfn, INVALID_P2M_ENTRY));
> 
> Use __set_phys_to_machine where you don't expect (or can't allow) any
> allocation.

Are you OK with me moving then this check:

    if (unlikely(xen_feature(XENFEAT_auto_translated_physmap))) {
                BUG_ON(pfn != mfn && mfn != INVALID_P2M_ENTRY);
                return true;
        }    
from set_phys_to_machine to __set_phys_to_machine?

> 
> Also, I'm not a fan of hiding real side-effectful code in a BUG_ON
> predicate.

Ok. Will expunge these.

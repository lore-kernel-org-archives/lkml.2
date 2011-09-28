Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab1I1NMs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 09:12:48 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:23659 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941Ab1I1NMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 09:12:46 -0400
Date: Wed, 28 Sep 2011 09:12:29 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Re: [PATCH v4 2/2] xen: modify kernel mappings
 corresponding to granted pages
Message-ID: <20110928131229.GA10270@phenom.oracle.com>
References: <alpine.DEB.2.00.1109081944150.12963@kaball-desktop>
 <20110921145853.GA541@phenom.oracle.com>
 <alpine.DEB.2.00.1109231412220.8700@kaball-desktop>
 <20110923144538.GA10701@phenom.oracle.com>
 <alpine.DEB.2.00.1109271549030.3519@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1109271549030.3519@kaball-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet23.oracle.com [156.151.31.71]
X-CT-RefId: str=0001.0A090201.4E831D48.0005,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Anyhow, If you want to modify your patchset to check PagePrivate bit
> > and set the SetPagePrivate/set_page_private - go ahead.
> 
> I'll do that.

Preempted you a bit :-)
http://lists.xensource.com/archives/html/xen-devel/2011-09/msg01364.html

> > > > > +                     gnttab_set_map_op(&map->kmap_ops[i], pte_maddr,
> > > > > +                             map->flags |
> > > > > +                             GNTMAP_host_map |
> > > > > +                             GNTMAP_contains_pte,
> > > > > +                             map->grants[i].ref,
> > > > > +                             map->grants[i].domid);
> > > > > +             }
> > > >
> > > > So, on startup.. (before this function is called) the
> > > > find_grant_ptes is called which pretty much does the exact thing for
> > > > each virtual address.  Except its flags are GNTMAP_application_map
> > > > instead of GNTMAP_host_map.
> > > >
> > > > It even uses the same type structure.. It fills out map_ops[i] one.
> > > >
> > > > Can we use that instead of adding a new structure?
> > >
> > > Do you mean moving this code inside find_grant_ptes?
> > > I don't think that can be done because find_grant_ptes is called on a
> > > range of virtual addresses while this is called on an array of struct
> > > pages. It is true that the current implementation of
> > 
> > But aren't that 'range of virtual address' of struct pages? You
> > are using 'alloc_xenballooned_pages' to get those pages and that is
> > what the 'range of virtual adresses' is walking through.
> 
> it is not the same range of virtual addresses

OK, but the pte_maddr is the same, isn't it?

> 
> > > alloc_xenballooned_pages is going to return a consecutive set of pages
> > > but it might not always be the case.
> > 
> > I am sensing some grand plans in work here? I thought we are going to
> > try to simply our lives and see about making alloc_xenballooned_pages
> > returned sane pages that are !PageHighMem (or if they are PageHighMem they
> > are already pinned, and set in the &init_mm)?
> > 
> > I am just thinking in terms of lookup_address and arbitrary_virt_to_machine
> > calls being done _twice_. And it seems like we have the find_grant_ptes
> > which does the bulk of this already - so why not piggyback on it?
> 
> It has to be done twice: once for the user ptes and once for the kernel
> mappings of map->pages.
> 
> 
> > Besides that, the patch set looks fine. .. How do I reproduce the failures
> > you had encountered with the AIO?
> > 
> 
> Just setup and use upstream qemu and configure your VM to use a disk on
> a file (file:).

OK.

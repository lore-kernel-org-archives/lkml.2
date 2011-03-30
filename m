Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932662Ab1C3OjX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 10:39:23 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:48812 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932266Ab1C3OjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 10:39:22 -0400
Subject: Re: [PATCH] xen/balloon: Memory hotplug support for Xen balloon
 driver
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Daniel Kiper <dkiper@net-space.pl>
Cc: ian.campbell@citrix.com, akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com,
        v.tolstov@selfip.ru, pasik@iki.fi, wdauchy@gmail.com,
        rientjes@google.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20110329181852.GD30387@router-fw-old.local.net-space.pl>
References: <20110328094757.GJ13826@router-fw-old.local.net-space.pl>
	 <1301327727.31700.8354.camel@nimitz>
	 <20110329181852.GD30387@router-fw-old.local.net-space.pl>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 30 Mar 2011 07:39:14 -0700
Message-ID: <1301495954.21454.3788.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-29 at 20:18 +0200, Daniel Kiper wrote:
> On Mon, Mar 28, 2011 at 08:55:27AM -0700, Dave Hansen wrote:
> > On Mon, 2011-03-28 at 11:47 +0200, Daniel Kiper wrote:
> > >
> > > +static enum bp_state reserve_additional_memory(long credit)
> > > +{
> > > +       int nid, rc;
> > > +       u64 start;
> > > +       unsigned long balloon_hotplug = credit;
> > > +
> > > +       start = PFN_PHYS(SECTION_ALIGN_UP(max_pfn));
> > > +       balloon_hotplug = (balloon_hotplug & PAGE_SECTION_MASK) + PAGES_PER_SECTION;
> > > +       nid = memory_add_physaddr_to_nid(start);
> >
> > Is the 'balloon_hotplug' calculation correct?  I _think_ you're trying
> > to round up to the SECTION_SIZE_PAGES.  But, if 'credit' was already
> > section-aligned I think you'll unnecessarily round up to the next
> > SECTION_SIZE_PAGES boundary.  Should it just be:
> >
> > 	balloon_hotplug = ALIGN(balloon_hotplug, PAGES_PER_SECTION);
> 
> Yes, you are right. I am wrong. I will correct that. However, as I said
> ealier I do not like ALIGN() in size context. For me ALIGN() is operation
> on an address which aligns this address to specified boundary. That is
> why I prefer use here open coded version (I agree that it is the same
> to ALIGN()). I think that ROUND() macro would be better in size context.
> However, I am not native english speaker and if I missed something correct
> me, please.

The only problem with open-coding it is that it's more likely to have
bugs.  But, sure, ROUND() sounds OK, as long as it does what you intend.
I'm still not quite sure what your intent here is, or in which direction
you're trying to round and why.

> > You might also want to consider some nicer units for those suckers.
> 
> What do you mind ??? I think that in that context PAGES_PER_SECTION
> is quite good.

Memory management code is tricky.  We keep addresses in many forms:
virtual addresses, physical addresses, pfns, 'struct page', etc...  I've
found it very useful in the past to ensure that I'm explicit about what
I'm dealing with among those.  

In this case, PAGES_PER_SECTION says that "balloon_hotplug" is intended
to be either a physical address or a page count.  But, that only says
what you're filling the variable with, not what you _intend_ it to
contain.

-- Dave


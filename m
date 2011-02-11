Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932455Ab1BKXW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 18:22:27 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:39757 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932347Ab1BKXWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 18:22:25 -0500
Subject: Re: [PATCH R3 7/7] xen/balloon: Memory hotplug support for Xen
 balloon driver
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Daniel Kiper <dkiper@net-space.pl>
Cc: ian.campbell@citrix.com, akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com,
        v.tolstov@selfip.ru, pasik@iki.fi, wdauchy@gmail.com,
        rientjes@google.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20110211231312.GA9646@router-fw-old.local.net-space.pl>
References: <20110203163033.GJ1364@router-fw-old.local.net-space.pl>
	 <1296756744.8299.1440.camel@nimitz>
	 <20110207141227.GA10852@router-fw-old.local.net-space.pl>
	 <1297185746.6737.12110.camel@nimitz>
	 <20110211231312.GA9646@router-fw-old.local.net-space.pl>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Fri, 11 Feb 2011 15:22:18 -0800
Message-ID: <1297466538.6737.18521.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-02-12 at 00:13 +0100, Daniel Kiper wrote:
> On Tue, Feb 08, 2011 at 09:22:26AM -0800, Dave Hansen wrote:
> > You spoke about page alignment up there.  Why is this section-aligned?
> > Should we make an "align to section" function in generic sparsemem code?
> 
> It is done because all pages in relevant section starting from max_pfn
> to the end of that section do not have PG_reserved bit set. It was tested
> on Linux Kernel Ver. 2.6.32.x, however, I am going to do some tests on
> current Linus tree. Currently, I do not expect that "align to section"
> function is required by others.

It doesn't matter if it gets used by anybody else.  It's a generic
function that fits in well with the other sparsemem code.  It should go
there.

...
> > As for telling the hypervisor where you've mapped things, that should be
> > done in arch_add_memory().
> >
> > When it comes down to online_page(), you don't want your pages freed
> > back in to the buddy allocator, you want them put in to the balloon.
> > So, take the __free_page() in online_page(), and put a Xen hook in
> > there.
> >
> > +void __attribute__((weak)) arch_free_hotplug_page(struct page *page)
> > +{
> > +	__free_page(page);
> > +}
> 
> I think that this function should be registered dynamically at init
> stage by specific balloon driver (in this case Xen balloon driver).

That sounds fine to me.  I guess we could use some of the subarch stuff
or the pv_ops structure to do it as well.  This isn't exactly a hot
path, either, so I'm not worried about it being some kind of
conditional.

Really, anything that allows us to divert pages over to the Xen balloon
driver rather than the buddy allocator is probably just fine.  

> > > Additionally, IIRC, add_memory() requires
> > > that underlying memory is available before its call.
> >
> > No, that's not correct.  s390's memory isn't available until after it
> > calls vmem_add_mapping().  See arch/s390/mm/init.c
> 
> I was right to some extent. First versions of memory hotplug code were
> written on the base of Linux Kernel Ver. 2.6.32.x. Tests done on that
> versions showed that add_memory() required that underlying memory should
> be available before its call. However, after short investigation it came
> out that there are some issues with some Xen calls. Those issues does
> not exists in current Linus tree.

Sounds good, I'm looking forward to your next patch.

-- Dave


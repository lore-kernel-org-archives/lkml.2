Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab0JaJNz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 05:13:55 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:30111 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab0JaJNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 05:13:52 -0400
X-IronPort-AV: E=Sophos;i="4.58,267,1286164800"; 
   d="scan'208";a="120447428"
Subject: Re: [GIT PULL] Small Xen bugfixes
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        Vasiliy G Tolstov <v.tolstov@selfip.ru>
In-Reply-To: <4CCB292E.9090602@goop.org>
References: <4CCB1906.4000608@goop.org>
	 <AANLkTi=g5sdiWSaLUHAATQn-1=jPqtc=RL6SpYSMYn98@mail.gmail.com>
	 <4CCB1E71.3060600@goop.org>  <4CCB292E.9090602@goop.org>
Content-Type: text/plain; charset="ISO-8859-1"
Organization: Citrix Systems, Inc.
Date: Sun, 31 Oct 2010 09:13:49 +0000
Message-ID: <1288516429.16032.13.camel@localhost.localdomain>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-29 at 21:06 +0100, Jeremy Fitzhardinge wrote:
> On 10/29/2010 12:20 PM, Jeremy Fitzhardinge wrote:
> >  On 10/29/2010 12:08 PM, Linus Torvalds wrote:
> >> On Fri, Oct 29, 2010 at 11:57 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> >>>    * fix dom0 boot on systems whose E820 doesn't completely cover the
> >>>      ISA address space.  This fixes a crash on a Dell R310.
> >> Hmm. This clashes with my current tree.
> > Bugger, so it does.  I just did a test merge with no complaint though;
> > what happened?
> >
> > I'll redo the patch anyway to fix the below.
> >
> >> And that conflict is trivial to fix up, but the thing is, I think the
> >> patch that comes from your tree is worse than what is already there.
> >>
> >> Why is that simple unconditional
> >>
> >>     e820_add_region(ISA_START_ADDRESS, ISA_END_ADDRESS - ISA_START_ADDRESS,
> >>            E820_RESERVED);
> >>
> >> not just always the right thing? Why do you have a separate hack for
> >> dom0 in xen_release_chunk() instead? That just looks bogus.
> > Yes, we actually had this discussion.  I was for making the
> > e820_add_region unconditional, and Ian's counter was that it could be
> > done in the common code rather than Xen-specific.
> >
> >> The normal logic we use on PC's is to just always reserve the low 64kB
> >> of memory, and the whole ISA space. Why doesn't Xen just do the same?
> > The specific issue is that the Xen domain returns any memory that's not
> > covered by an E820 entry back to Xen, mostly to make sure that memory
> > isn't wasted by being shadowed by PCI devices.  But it was also doing
> > this in the sub-1M region, which on all the machines I've tested on is
> > completely covered.  But on a Dell R310 there's a little 2-page gap
> > where some ACPI stuff is lurking, that was being released back to Xen so
> > it couldn't be accessed from Linux any more.
> >
> > The fix is to just make sure the whole low region is covered (or at
> > least the 640k-1M space).
> 
> Hm, I see.  This Dell machine stashes the MPS table in 2 pages just
> *below* 640k, so the ISA_START_ADDRESS-ISA_END_ADDRESS reserved range
> doesn't cover it.

Yes, what the machine has is:
        (XEN)  0000000000000000 - 000000000009e000 (usable)
        (XEN)  0000000000100000 - 00000000bf699000 (usable)
which after reserving the 640k-1M range shows up in dom0 as:
        BIOS-provided physical RAM map:
         Xen: 0000000000000000 - 000000000009e000 (usable)
         Xen: 00000000000a0000 - 0000000000100000 (reserved)
         Xen: 0000000000100000 - 0000000020000000 (usable)
which has a little 2 page hole between 9e000-a0000 which
xen_release_chunk dutifully punches out as a hole in both the virtual
and physical address space.

> There's three ways to fix this:
> 
>     * not free memory below 1M (Ian's current patch)
>     * fill any E820 gaps below 1M
>     * reserve all memory below 1M

The second two basically indirectly implement the first under Xen. They
also seem like things which if they are correct to do in Xen dom0 they
would also be correct on native too and therefore belong in
sanitize_e820 or somewhere like that.

The actual memory which is marked reserved (or just unmentioned) doesn't
really matter much here since the code which goes poking around in this
stuff doesn't check if it is reserved or not (and it shouldn't since we
know the BIOSes can/will get this stuff wrong).

> The 3rd is certainly simplest, at the cost of wasting a trivial amount
> of memory.

Doesn't Linux avoid using the lowest 1M anyway? (obviously apart from
the start of day probing for firmware tables etc).

>   Unfortunately it crashes early.  Sigh, will try and sort it
> out this afternoon.

Strange!



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706Ab1BXOMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 09:12:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754065Ab1BXOMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 09:12:43 -0500
Date: Thu, 24 Feb 2011 15:11:53 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Jan Beulich <JBeulich@novell.com>
Cc: Ian Campbell <Ian.Campbell@citrix.com>, Andi Kleen <andi@firstfloor.org>,
        Hugh Dickins <hughd@google.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Johannes Weiner <jweiner@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>, Rik van Riel <riel@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] fix pgd_lock deadlock
Message-ID: <20110224141153.GB5633@random.random>
References: <alpine.LFD.2.00.1102152102530.26192@localhost6.localdomain6>
 <20110216183304.GD5935@random.random>
 <20110217101941.GH2380@redhat.com>
 <20110221143023.GF13092@random.random>
 <20110221145350.GH25382@redhat.com>
 <4D6378760200007800033104@vpn.id2.novell.com>
 <20110222134956.GU13092@random.random>
 <4D63D4CD020000780003320A@vpn.id2.novell.com>
 <20110224042222.GG31195@random.random>
 <4D66239902000078000336D6@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D66239902000078000336D6@vpn.id2.novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 08:23:37AM +0000, Jan Beulich wrote:
> >>> On 24.02.11 at 05:22, Andrea Arcangeli <aarcange@redhat.com> wrote:
> > On Tue, Feb 22, 2011 at 02:22:53PM +0000, Jan Beulich wrote:
> >> >>> On 22.02.11 at 14:49, Andrea Arcangeli <aarcange@redhat.com> wrote:
> >> > On Tue, Feb 22, 2011 at 07:48:54AM +0000, Jan Beulich wrote:
> >> >> A possible alternative would be to acquire the page table lock
> >> >> in vmalloc_sync_all() only in the Xen case (perhaps by storing
> >> >> NULL into page->index in pgd_set_mm() when not running on
> >> >> Xen). This is utilizing the fact that there aren't (supposed to
> >> >> be - for non-pvops this is definitely the case) any TLB flush IPIs
> >> >> under Xen, and hence the race you're trying to fix doesn't
> >> >> exist there (while non-Xen doesn't need the extra locking).
> >> > 
> >> > That's sure ok with me. Can we use a global runtime to check if the
> >> > guest is running under Xen paravirt, instead of passing that info
> >> > through page->something?
> >> 
> >> If everyone's okay with putting a couple of "if (xen_pv_domain())"
> >> into mm/fault.c - sure. I would have thought that this wouldn't be
> >> liked, hence the suggestion to make this depend on seeing the
> >> backlink be non-NULL.
> > 
> > What about this? The page->private logic gets optimized away at
> > compile time with XEN=n.
> > 
> > The removal of _irqsave from pgd_lock, I'll delay it as it's no bugfix
> > anymore.
> > 
> > ===
> > Subject: xen: stop taking the page_table_lock with irq disabled
> > 
> > From: Andrea Arcangeli <aarcange@redhat.com>
> > 
> > It's forbidden to take the page_table_lock with the irq disabled or if there's
> > contention the IPIs (for tlb flushes) sent with the page_table_lock held will
> > never run leading to a deadlock.
> > 
> > Only Xen needs the page_table_lock and Xen won't need IPI TLB flushes hence 
> > the deadlock doesn't exist for Xen.
> 
> Looks reasonable to me, except for the implementation no longer
> matching subject and description (the lock still gets taken with
> IRQs disabled, just that - as far as we can tell so far - doesn't
> matter for Xen).
> 
> With the conditional on the reader side I also wonder whether
> the conditional on the writer side is really a good thing to have,
> considering that generally distro kernels are likely to have XEN
> enabled.

Well there is no point to keep the writer side functional. There
aren't only distro kernels out there, I really like features to go
away completely at build time when they're not needed. Not because
it's Xen (I recently did the same thing for THP too for example,
making sure every sign of it gone away with a =n setting, with the
exception perhaps of the put_page/get_page compound logic but at least
the compound_lock goes away). It simply makes no sense to page->index
= mm if nobody could possibly read it so I prefer this. Otherwise I
wouldn't need to put in a macro for the reader side to workaround the
fact the xen.h isn't available in pgtable.h and I could leave it in
pgtable.c (and I didn't want to add it to pgtable.h). It seems to
build on i386 but it's better to re-verify i386, because on older
kernels I had to add a xen/xen.h include to x86/mm/fault.c too to
x86_64 (but upstream fault.c seems not to need it). I'll try to re-run
some build with XEN on and off x86 32/64 to be really sure all
includes are ok.

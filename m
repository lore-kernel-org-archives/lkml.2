Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab1BOTzq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 14:55:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60872 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178Ab1BOTzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 14:55:45 -0500
Date: Tue, 15 Feb 2011 20:54:50 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Jan Beulich <JBeulich@novell.com>, Larry Woodman <lwoodman@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] fix pgd_lock deadlock
Message-ID: <20110215195450.GO5935@random.random>
References: <4CB76E8B.2090309@goop.org>
 <4CC0AB73.8060609@goop.org>
 <20110203024838.GI5843@random.random>
 <4D4B1392.5090603@goop.org>
 <20110204012109.GP5843@random.random>
 <4D4C6F45.6010204@goop.org>
 <20110207232045.GJ3347@random.random>
 <20110215190710.GL5935@random.random>
 <alpine.LFD.2.00.1102152020590.26192@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1102152020590.26192@localhost6.localdomain6>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 08:26:51PM +0100, Thomas Gleixner wrote:
> On Tue, 15 Feb 2011, Andrea Arcangeli wrote:
> 
> > Hello,
> > 
> > Without this patch we can deadlock in the page_table_lock with NR_CPUS
> > < 4 or THP on, with this patch we hopefully won't deadlock in the
> > pgd_lock (if taken from irq). I can't see anything taking it from irq
> > (maybe aio? to check I also tried the libaio testuite with no apparent
> > VM_BUG_ON triggering), so unless somebody sees it, I think we should
> > apply it. I've been running for a while with this patch applied
> > without apparent problems. Other archs may follow suit if it's proven
> > that there's nothing taking the pgd_lock from irq.
> > 
> > ===
> > Subject: fix pgd_lock deadlock
> > 
> > From: Andrea Arcangeli <aarcange@redhat.com>
> > 
> > It's forbidden to take the page_table_lock with the irq disabled or if there's
> > contention the IPIs (for tlb flushes) sent with the page_table_lock held will
> > never run leading to a deadlock.
> 
> I really read this thing 5 times and still cannot make any sense of it.
> 
> You talk about page_table_lock and then fiddle with pgd_lock.
> 
> -ENOSENSE

With NR_CPUs < 4, or with THP enabled, rmap.c will do
spin_lock(&mm->page_table_lock) (or pte_offset_map_lock where the lock
is still mm->page_table_lock and not the PT lock). Then it will send
IPIs to flush the tlb of the other CPUs.

But the other CPU is running the vmalloc_sync_all, and it is trying to
take the page_table_lock with irq disabled. It will never take the
lock because the CPU waiting the IPI delivery holds it. And it will
never run the IPI because it has irqs disabled.

Now the big question is if anything is taking the pgd_lock from
irqs. Normal testing could never reveal it as even if it happens it
has a slim chance to happen while the pgd_lock is already hold by
normal kernel context. But the VM_BUG_ON(in_interrupt()) should
hopefully have revealed it already if it ever happened, I hope.

Clearly we could try to fix it in other ways, but still if there's no
reason to do the _irqsave this sounds a good idea to apply my fix
anyway.

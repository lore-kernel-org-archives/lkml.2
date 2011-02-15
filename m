Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab1BOUGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 15:06:39 -0500
Received: from www.tglx.de ([62.245.132.106]:37464 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755313Ab1BOUGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 15:06:37 -0500
Date: Tue, 15 Feb 2011 21:05:20 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrea Arcangeli <aarcange@redhat.com>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Jan Beulich <JBeulich@novell.com>, Larry Woodman <lwoodman@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] fix pgd_lock deadlock
In-Reply-To: <20110215195450.GO5935@random.random>
Message-ID: <alpine.LFD.2.00.1102152102530.26192@localhost6.localdomain6>
References: <4CB76E8B.2090309@goop.org> <4CC0AB73.8060609@goop.org> <20110203024838.GI5843@random.random> <4D4B1392.5090603@goop.org> <20110204012109.GP5843@random.random> <4D4C6F45.6010204@goop.org> <20110207232045.GJ3347@random.random>
 <20110215190710.GL5935@random.random> <alpine.LFD.2.00.1102152020590.26192@localhost6.localdomain6> <20110215195450.GO5935@random.random>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Feb 2011, Andrea Arcangeli wrote:
> On Tue, Feb 15, 2011 at 08:26:51PM +0100, Thomas Gleixner wrote:
> 
> With NR_CPUs < 4, or with THP enabled, rmap.c will do
> spin_lock(&mm->page_table_lock) (or pte_offset_map_lock where the lock
> is still mm->page_table_lock and not the PT lock). Then it will send
> IPIs to flush the tlb of the other CPUs.
> 
> But the other CPU is running the vmalloc_sync_all, and it is trying to
> take the page_table_lock with irq disabled. It will never take the
> lock because the CPU waiting the IPI delivery holds it. And it will
> never run the IPI because it has irqs disabled.

Ok, that makes sense :)
 
> Now the big question is if anything is taking the pgd_lock from
> irqs. Normal testing could never reveal it as even if it happens it
> has a slim chance to happen while the pgd_lock is already hold by
> normal kernel context. But the VM_BUG_ON(in_interrupt()) should
> hopefully have revealed it already if it ever happened, I hope.
> 
> Clearly we could try to fix it in other ways, but still if there's no
> reason to do the _irqsave this sounds a good idea to apply my fix
> anyway.

Did you try with DEBUG_PAGEALLOC, which is calling into cpa quite a
lot?

Thanks,

	tglx


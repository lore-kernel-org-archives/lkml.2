Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005Ab2DWTK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 15:10:59 -0400
Received: from 1wt.eu ([62.212.114.60]:1450 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690Ab2DWTK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 15:10:57 -0400
Date: Mon, 23 Apr 2012 21:09:15 +0200
From: Willy Tarreau <w@1wt.eu>
To: Philipp Hahn <hahn@univention.de>
Cc: stable@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
        Peter Zijlstra <peterz@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@novell.com>, Andi Kleen <ak@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <jweiner@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Larry Woodman <lwoodman@redhat.com>, Rik van Riel <riel@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, 669335@bugs.debian.org
Subject: Re: [2.6.32.y][PATCH] fix pgd_lock deadlock
Message-ID: <20120423190915.GF19117@1wt.eu>
References: <alpine.LFD.2.00.1102152020590.26192@localhost6.localdomain6> <20110216102801.GA23082@elte.hu> <20110216144947.GA5935@random.random> <201204231107.59484.hahn@univention.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201204231107.59484.hahn@univention.de>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Philipp,

On Mon, Apr 23, 2012 at 11:07:53AM +0200, Philipp Hahn wrote:
> Hello,
> 
> On Wednesday 16 February 2011 15:49:47 Andrea Arcangeli wrote:
> > Subject: fix pgd_lock deadlock
> >
> > From: Andrea Arcangeli <aarcange@redhat.com>
> >
> > It's forbidden to take the page_table_lock with the irq disabled or if
> > there's contention the IPIs (for tlb flushes) sent with the page_table_lock
> > held will never run leading to a deadlock.
> >
> > Apparently nobody takes the pgd_lock from irq so the _irqsave can be
> > removed.
> >
> > Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> 
> This patch (original commit Id for 2.6.38 
> a79e53d85683c6dd9f99c90511028adc2043031f) needs to be back-ported to 2.6.32.x 
> as well.
> I observed a dead-lock problem when running a PAE enabled Debian 2.6.32.46+ 
> kernel with 6 VCPUs as a KVM on (2.6.32, 3.2, 3.3) kernel, which showed the 
> following behaviour:
> 
> 1 VCPU is stuck in
>   pgd_alloc() ??? pgd_prepopulate_pmb() ???... ???  flush_tlb_others_ipi()
> while (!cpumask_empty(to_cpumask(f->flush_cpumask)))
>     cpu_relax();
> (gdb) print f->flush_cpumask
> $5 = {1}
> 
> while all other VCPUs are stuck in
>   pgd_alloc() ??? spin_lock_irqsave(pgd_lock)
> 
> I tracked it down to the commit
>  2.6.39-rc1: 4981d01eada5354d81c8929d5b2836829ba3df7b
>  2.6.32.34: ba456fd7ec1bdc31a4ad4a6bd02802dcaa730a33
>  x86: Flush TLB if PGD entry is changed in i386 PAE mode
> which when reverted made the bug disappear.
> 
> Comparing 3.2 to 2.6.32.34 showed that the 'pgd-deadlock'-patch went into 
> 2.6.38, that is before the 'PAE correctness'-patch, so the problem was 
> probably never observed in the main development branch.
> But for 2.6.32 the 'pgd-deadlock' patch is still missing, so the 'PAE 
> corretness'-patch made the problem worse with 2.6.32.
> 
> The Patch was also back-ported to the OpenSUSE Kernel
> <http://kernel.opensuse.org/cgit/kernel-source/commit/?id=ac27c01aa880c65d17043ab87249c613ac4c3635>,
> Since the patch didn't apply cleanly on the current Debian kernel, I had to 
> backport it for us and Debian. The patch is also available from our (German) 
> Bugzilla <https://forge.univention.org/bugzilla/show_bug.cgi?id=26661> or 
> from the Debian BTS at 
> <http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=669335>.
> 
> I have no easy test case, but running multiple parallel builds inside the VM 
> normally triggers the bug within seconds to minutes. With the patch applied 
> the VM survived a night building packages without any problem.
> 
> Signed-off-by: Philipp Hahn <hahn@univention.de>
> 
> Sincerely
> Philipp

Thank you, I'm queuing it for next 32-stable.

Regards,
Willy


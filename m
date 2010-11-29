Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab0K2Urt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 15:47:49 -0500
Received: from casper.infradead.org ([85.118.1.10]:49363 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185Ab0K2Urr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 15:47:47 -0500
Subject: Re: [PATCH 08/21] mm: Preemptible mmu_gather
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <rmk@arm.linux.org.uk>, Paul Mundt <lethal@linux-sh.org>,
        Jeff Dike <jdike@addtoit.com>, Tony Luck <tony.luck@intel.com>
In-Reply-To: <20101129115324.31cc9005.kamezawa.hiroyu@jp.fujitsu.com>
References: <20101126143843.801484792@chello.nl>
	 <20101126145410.712834114@chello.nl>
	 <20101129115324.31cc9005.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 29 Nov 2010 21:47:02 +0100
Message-ID: <1291063622.32004.376.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-29 at 11:53 +0900, KAMEZAWA Hiroyuki wrote:
> On Fri, 26 Nov 2010 15:38:51 +0100
> Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > Make mmu_gather preemptible by using a small on stack list and use
> > an option allocation to speed things up.
> > 
> > Preemptible mmu_gather is desired in general and usable once
> > i_mmap_lock becomes a mutex. Doing it before the mutex conversion
> > saves us from having to rework the code by moving the mmu_gather
> > bits inside the i_mmap_lock.
> > 
> > Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > Cc: David Miller <davem@davemloft.net>
> > Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > Cc: Russell King <rmk@arm.linux.org.uk>
> > Cc: Paul Mundt <lethal@linux-sh.org>
> > Cc: Jeff Dike <jdike@addtoit.com>
> > Cc: Tony Luck <tony.luck@intel.com>
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Interesting, Hmm, how about using the 1st freed pages as tlb->pages
> rathet than calling alloc_page() ? no benefits ?

We could try that, but we need to be careful there, you need to wait
till after the TLB invalidate and possibly an RCU period for the
page-directory pages (sparc/powerpc).

So doing an optimistic allocation before the TLB invalidate seems saner.

Also, see patch 20.

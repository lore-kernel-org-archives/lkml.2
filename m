Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab1AYUWP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 15:22:15 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58577 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab1AYUWO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 15:22:14 -0500
Subject: Re: [PATCH 09/25] ia64: Preemptible mmu_gather
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Tony Luck <tony.luck@intel.com>
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
        Yanmin Zhang <yanmin_zhang@linux.intel.com>
In-Reply-To: <AANLkTikgpX16=ouGCpKqDtr7w-AUWLQNU7cFi4vKWbt+@mail.gmail.com>
References: <20110125173111.720927511@chello.nl>
	 <20110125174907.664402563@chello.nl>
	 <AANLkTikgpX16=ouGCpKqDtr7w-AUWLQNU7cFi4vKWbt+@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 25 Jan 2011 21:22:23 +0100
Message-ID: <1295986943.28776.1108.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-25 at 12:12 -0800, Tony Luck wrote:
> On Tue, Jan 25, 2011 at 9:31 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >  struct mmu_gather {
> >        struct mm_struct        *mm;
> >        unsigned int            nr;             /* == ~0U => fast mode */
> > +       unsigned int            max;
> >        unsigned char           fullmm;         /* non-zero means full mm flush */
> >        unsigned char           need_flush;     /* really unmapped some PTEs? */
> >        unsigned long           start_addr;
> >        unsigned long           end_addr;
> > -       struct page             *pages[FREE_PTE_NR];
> > +       struct page             **pages;
> > +       struct page             *local[8];
> >  };
> 
> Overall it looks OK - builds, boots & runs too. One question about
> the above bit ... why "8" elements in the local[] array?  This ought to be
> a #define, maybe with a comment explaining the significance. It doesn't
> seem to fill out struct mmu_gather to some "nice" size.  I can't think
> of why batching 8 at a time (in the fallback cannot allocate **pages case)
> is a good number. So is there some science to the choice, or did you
> pluck 8 out of the air? 

Yeah, pretty much a random number small enough to make struct mmu_gather
fit on stack, the reason its not 1 is that a few more entries increase
performance a little and freeing more pages increases the chance the
page allocation works next time around.



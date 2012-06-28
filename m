Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab2F1LUj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 07:20:39 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:50631 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816Ab2F1LUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 07:20:36 -0400
Date: Thu, 28 Jun 2012 13:19:50 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>, Alex Shi <alex.shi@intel.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Russell King <rmk@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Tony Luck <tony.luck@intel.com>,
        Paul Mundt <lethal@linux-sh.org>, Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Ralf Baechle <ralf@linux-mips.org>, Kyle McMartin <kyle@mcmartin.ca>,
        James Bottomley <jejb@parisc-linux.org>,
        Chris Zankel <chris@zankel.net>
Subject: Re: [PATCH 08/20] mm: Optimize fullmm TLB flushing
Message-ID: <20120628131950.0afe39f0@de.ibm.com>
In-Reply-To: <1340880904.28750.13.camel@twins>
References: <20120627211540.459910855@chello.nl>
	<20120627212831.137126018@chello.nl>
	<CA+55aFwZoVK76ue7tFveV0XZpPUmoCVXJx8550OxPm+XKCSSZA@mail.gmail.com>
	<1340838154.10063.86.camel@twins>
	<1340838807.10063.90.camel@twins>
	<CA+55aFy6m967fMxyBsRoXVecdpGtSphXi_XdhwS0DB81Qaocdw@mail.gmail.com>
	<CA+55aFzLNsVRkp_US8rAmygEkQpp1s1YdakV86Ck-4RZM7TTdA@mail.gmail.com>
	<1340880904.28750.13.camel@twins>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12062811-3548-0000-0000-000002608070
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2012 12:55:04 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2012-06-27 at 16:33 -0700, Linus Torvalds wrote:
> > IOW, the point I'm trying to make is that even if there are zero
> > *actual* accesses of user space (because user space is dead, and the
> > kernel hopefully does no "get_user()/put_user()" stuff at this point
> > any more), the CPU may speculatively use user addresses for the
> > bog-standard kernel addresses that happen. 
> 
> Right.. and s390 having done this only says that s390 appears to be ok
> with it. Martin, does s390 hardware guarantee no speculative stuff like
> Linus explained, or might there even be a latent issue on s390?

The cpu can create speculative TLB entries, but only if it runs in the
mode that uses the respective mm. We have two mm's active at the same
time, the kernel mm (init_mm) and the user mm. While the cpu runs only
in kernel mode it is not allowed to create TLBs for the user mm.
While running in user mode it is allowed to speculatively create TLBs.
 
> But it looks like we cannot do this in general, and esp. ARM (as already
> noted by Catalin) has very aggressive speculative behaviour.
> 
> The alternative is that we do a switch_mm() to init_mm instead of the
> TLB flush. On x86 that should be about the same cost, but I've not
> looked at other architectures yet.
> 
> The second and least favourite alternative is of course special casing
> this for s390 if it turns out its a safe thing to do for them.
> 
> /me goes look through arch code.

Basically we have two special requirements on s390:
1) do not modify ptes while attached to another cpu except with the
   special IPTE / IDTE instructions
2) do a TLB flush before freeing any kind of page table page, s390
   needs a flush for pud, pmd & pte tables.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.


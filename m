Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933880Ab0KQBpf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 20:45:35 -0500
Received: from mga09.intel.com ([134.134.136.24]:52460 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933466Ab0KQBpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 20:45:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,208,1288594800"; 
   d="scan'208";a="678231261"
Subject: Re: [PATCH -v4 0/2] Lockless memory allocator and list
From: Huang Ying <ying.huang@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Chris Mason <chris.mason@oracle.com>, Jens Axboe <jaxboe@fusionio.com>
In-Reply-To: <1289930649.2109.640.camel@laptop>
References: <1289868791-16658-1-git-send-email-ying.huang@intel.com>
	 <1289908158.2109.568.camel@laptop>
	 <AANLkTime3Sh2TbgCGKir=t_TBNsd5fHipEqQwa4bVJuY@mail.gmail.com>
	 <1289930649.2109.640.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Nov 2010 09:45:30 +0800
Message-ID: <1289958330.8719.1196.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 02:04 +0800, Peter Zijlstra wrote:
> On Tue, 2010-11-16 at 08:38 -0800, Linus Torvalds wrote:
> > 
> > I kind of like the lock-less list implementation (it could easily be
> > useful for random things, and it's very simple).
> 
> Yes, there's various implementations floating around, and we already
> have one in-kernel ( net/rds/xlist.h ), mason and axboe and me have been
> kicking around various patches using that thing in other circumstances
> as well.
> 
> [ At some point we had perf -- what now is kernel/irq_work.c --  using
>   it as well, but the new code grew too complex due to requirements
>   from Huang ]

I think it should be possible for them to use the general lockless list
implementation in the patch. I think this will reduce some code
duplication/complexity. Do you agree?

> >  And I don't think the
> > notion of a lockless memory allocator is wrong either, although it
> > looks a lot more specialized than the list thing (the solution to
> > lockless allocations is generally simply to do them ahead of time).
> > 
> Right, I don't generally object to lockless things, but they either need
> to be 1) faster than the existing code, and/or 2) have a very convincing
> use-case (other than performance) for their added complexity.

I will post a generic hardware error reporting mechanism patchset soon.
The lock-less memory allocator is used there. And I think maybe we can
use it in lockdep code too. Which needs to allocate something locklessly
if my understanding is correct.

> Afaict the proposed patch adds lots more LOCK'ed instructions into that
> allocator path than it removes, ie its a slow down for existing users.

Let's take a look at gen_pool_alloc

The locks removed:

- one rwlock: pool->lock
- one spinlock for each chunk: chunk->lock

The LOCK'ed instructions added:

- one or two cmpxchg in most cases. But if there is heavy contention
between users, there will be more cmpxchg. So I suggest to use one
gen_pool for each CPU for heavy contention situation.

BTW: The original gen_pool is designed to deal with special purpose
memory in some drivers. So I don't think performance is a big issue for
it.

Best Regards,
Huang Ying



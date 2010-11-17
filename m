Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759722Ab0KQGFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 01:05:20 -0500
Received: from mga02.intel.com ([134.134.136.20]:42645 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751910Ab0KQGFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 01:05:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,209,1288594800"; 
   d="scan'208";a="574598608"
Subject: Re: [PATCH -v4 1/2] lib, Make gen_pool memory allocator lockless
From: Huang Ying <ying.huang@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20101116195720.23287038.akpm@linux-foundation.org>
References: <1289868791-16658-1-git-send-email-ying.huang@intel.com>
	 <1289868791-16658-2-git-send-email-ying.huang@intel.com>
	 <20101116135038.fcaa90ca.akpm@linux-foundation.org>
	 <1289960281.8719.1218.camel@yhuang-dev>
	 <20101116183506.41e77e1a.akpm@linux-foundation.org>
	 <1289963005.8719.1238.camel@yhuang-dev>
	 <20101116195720.23287038.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Nov 2010 14:05:14 +0800
Message-ID: <1289973914.8719.1261.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 11:57 +0800, Andrew Morton wrote:
> On Wed, 17 Nov 2010 11:03:25 +0800 Huang Ying <ying.huang@intel.com> wrote:
> 
> > It seems that Steven thinks many architectures without NMI-safe cmpxchg
> > have no real NMI too.
> 
> Could be.
> 
> Really, we should nail this down and work out the matrix of
> what-works-with-what, and then arrange for the things which _won't_
> work to be either non-Kconfigurable or non-compilable.

Yes.  I will try to work out a draft matrix for review firstly.

> The worst thing we could do would be to advertise some code as
> "nmi-safe!!", then to have someone go and use it on that basis, only
> for their users to later discover ghastly rare races.

Yes.

> > In the patch description and comments, it is said that on architectures
> > without NMI-safe cmpxchg, gen_pool can not be used in NMI handler
> > safely.
> > 
> > Or do you think it is better to use a spin_trylock based fallback if
> > NMI-safe cmpxchg is not available? Or require cmpxchg implementation
> > uses spin_trylock instead of spin_lock?
> 
> As a first step, a typical thing to do would be to create
> CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG, define that in the appropriate
> architectures, make ftrace and perf and genpool and anything else
> dependent upon that at Kconfig-time.

Yes.  At least lockless list should depend on that.  And we need select
between cmpxchg and spin_trylock_irqsave based on that.

Hi, Peter,

Do you think think irq_work should depend on that?  Or we just
reimplement irq_work based on lockless list and make irq_work depends on
lockless list?

> A spin_trylock_irqsave() implementation would do what?  Rarely fail the
> memory allocation attempt if the trylock failed?  I guess that's
> acceptable in the context of gen_pool, because memory allocators are
> expected to fail, and everyone carefully tests the allocation-failed
> error paths (lol).

Yes.  I will implement the fallback for gen_pool.

> But rare failures may not be useful within the context of future
> clients of the "lockless" list implementation so I'd say that a safer
> approach would be to make the list implementation require
> CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG and be done with it.

Yes.

> So that's all pretty simple so far.  However...
> 
> The list implementation is still useful to
> non-CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG clients, as long as they aren't
> using it from NMI context, yes?
> 
> In which case I suppose we could add a library of lockless_list_foo()
> functions which are usable from non-NMI contexts and which are
> available to all configs.  And on top of that implement a library of
> nmi_safe_lockless_list_foo() functions which are just wrappers around
> lockless_list_foo(), but which are only available if
> CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y.
> 
> Which is getting to be a bit of a pain, so you might choose to
> disregard everything after "However..." ;)

At least as the first step, I prefer to just make lockless list depend
on CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG.

Best Regards,
Huang Ying



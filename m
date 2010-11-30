Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab0K3BIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 20:08:17 -0500
Received: from mga03.intel.com ([143.182.124.21]:64173 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756024Ab0K3BIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 20:08:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,277,1288594800"; 
   d="scan'208";a="354734243"
Subject: Re: [PATCH -v6 2/3] lib, Make gen_pool memory allocator lockless
From: Huang Ying <ying.huang@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1291032697.32004.28.camel@laptop>
References: <1291014201-15513-1-git-send-email-ying.huang@intel.com>
	 <1291014201-15513-3-git-send-email-ying.huang@intel.com>
	 <1291032697.32004.28.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Nov 2010 09:08:09 +0800
Message-ID: <1291079289.12648.30.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Peter,

On Mon, 2010-11-29 at 20:11 +0800, Peter Zijlstra wrote:
> On Mon, 2010-11-29 at 15:03 +0800, Huang Ying wrote:
> > This version of the gen_pool memory allocator supports lockless
> > operation.
> > 
> > This makes it safe to use in NMI handlers and other special
> > unblockable contexts that could otherwise deadlock on locks.  This is
> > implemented by using atomic operations and retries on any conflicts.
> > The disadvantage is that there may be livelocks in extreme cases.  For
> > better scalability, one gen_pool allocator can be used for each CPU.
> > 
> > The lockless operation only works if there is enough memory available.
> > If new memory is added to the pool a lock has to be still taken.  So
> > any user relying on locklessness has to ensure that sufficient memory
> > is preallocated.
> > 
> > The basic atomic operation of this allocator is cmpxchg on long.  On
> > architectures that don't have NMI-safe cmpxchg implementation, a
> > spin_trylock_irqsave based fallback is used for gen_pool_alloc, so it
> > can be used in NMI handler safely.  But gen_pool_free can not be used
> > in NMI handler in these architectures, because memory free can not
> > fail. 
> 
> I still don't see a reason to merge this.
> 
> It makes the genalloc thing slower for every other user (more LOCK'ed
> ops) and there is no new user presented in this series.

As far as I know, all genalloc users are not performance sensitive.
After all, it is mainly used to manage some device memory before. As for
users, I think this is a "chicken and egg" problem. And I have plan to
use it in APEI code.

Best Regards,
Huang Ying




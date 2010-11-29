Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab0K2ML2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 07:11:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:55309 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab0K2ML1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 07:11:27 -0500
Subject: Re: [PATCH -v6 2/3] lib, Make gen_pool memory allocator lockless
From: Peter Zijlstra <peterz@infradead.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, linux-acpi@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1291014201-15513-3-git-send-email-ying.huang@intel.com>
References: <1291014201-15513-1-git-send-email-ying.huang@intel.com>
	 <1291014201-15513-3-git-send-email-ying.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 29 Nov 2010 13:11:37 +0100
Message-ID: <1291032697.32004.28.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-29 at 15:03 +0800, Huang Ying wrote:
> This version of the gen_pool memory allocator supports lockless
> operation.
> 
> This makes it safe to use in NMI handlers and other special
> unblockable contexts that could otherwise deadlock on locks.  This is
> implemented by using atomic operations and retries on any conflicts.
> The disadvantage is that there may be livelocks in extreme cases.  For
> better scalability, one gen_pool allocator can be used for each CPU.
> 
> The lockless operation only works if there is enough memory available.
> If new memory is added to the pool a lock has to be still taken.  So
> any user relying on locklessness has to ensure that sufficient memory
> is preallocated.
> 
> The basic atomic operation of this allocator is cmpxchg on long.  On
> architectures that don't have NMI-safe cmpxchg implementation, a
> spin_trylock_irqsave based fallback is used for gen_pool_alloc, so it
> can be used in NMI handler safely.  But gen_pool_free can not be used
> in NMI handler in these architectures, because memory free can not
> fail. 

I still don't see a reason to merge this.

It makes the genalloc thing slower for every other user (more LOCK'ed
ops) and there is no new user presented in this series.



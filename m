Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759612Ab1CDMzL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 07:55:11 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52671 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759400Ab1CDMzH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 07:55:07 -0500
Subject: RE: [PATCH 09/13] unicore: mmu_gather rework
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org,
        "'Benjamin Herrenschmidt'" <benh@kernel.crashing.org>,
        "'David Miller'" <davem@davemloft.net>,
        "'Hugh Dickins'" <hugh.dickins@tiscali.co.uk>,
        "'Mel Gorman'" <mel@csn.ul.ie>, "'Nick Piggin'" <npiggin@kernel.dk>,
        "'Paul McKenney'" <paulmck@linux.vnet.ibm.com>,
        "'Yanmin Zhang'" <yanmin_zhang@linux.intel.com>,
        "'Andrea Arcangeli'" <aarcange@redhat.com>,
        "'Avi Kivity'" <avi@redhat.com>,
        "'Thomas Gleixner'" <tglx@linutronix.de>,
        "'Rik van Riel'" <riel@redhat.com>, "'Ingo Molnar'" <mingo@elte.hu>,
        akpm@linux-foundation.org,
        "'Linus Torvalds'" <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <03ca01cbda63$31930fd0$94b92f70$@mprc.pku.edu.cn>
References: <20110302175004.222724818@chello.nl>
	 <20110302175200.883953013@chello.nl>
	 <03ca01cbda63$31930fd0$94b92f70$@mprc.pku.edu.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 04 Mar 2011 13:17:00 +0100
Message-ID: <1299241020.2428.13504.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-04 at 19:56 +0800, Guan Xuetao wrote:

> Thanks Peter.
> It looks good to me, though it is dependent on your patch set "mm: Preemptible mmu_gather"

It is indeed, the split-out per arch is purely to ease review. The final
commit should be a merge of the first 10 patches so as not to break
bisection.

> While I have another look to include/asm-generic/tlb.h, I found it is also suitable for unicore32.
> And so, I rewrite the tlb.h to use asm-generic version, and then your patch set will also work for me.

Awesome, I notice you're loosing flush_tlb_range() support for this, if
you're fine with that I'm obviously not going to argue, but if its
better for your platform to keep doing this we can work on that as well
as I'm trying to add generic support for range tracking into the generic
tlb code.

More importantly, you seem to loose your call to flush_cache_range()
which isn't a NOP on your platform.

Furthermore, while arch/unicore32/mm/tlb-ucv2.S is mostly magic to me, I
see unicore32 is one of the few architectures that actually uses
vm_flags in flush_tlb_range(). Do you have independent I/D-TLB flushes
or are you flushing I-cache on VM_EXEC?

Also, I notice your flush_tlb_range() implementation looks to be a loop
invalidating individual pages, which I can imagine is cheaper for small
ranges but large ranges might be better of with a full invalidate. Did
you think about this?




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab0EJOAh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 10:00:37 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60119 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754736Ab0EJOAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 10:00:34 -0400
Subject: Re: [RFC PATCH] Update the cachetlb.txt file WRT
 flush_dcache_pageand update_mmu_cache
From: Catalin Marinas <catalin.marinas@arm.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       James.Bottomley@HansenPartnership.com, benh@kernel.crashing.org,
       davem@davemloft.net, rmk@arm.linux.org.uk
In-Reply-To: <20100510115552.GD10452@parisc-linux.org>
References: <20100507132418.28009.6013.stgit@e102109-lin.cambridge.arm.com>
	 <20100510170616O.fujita.tomonori@lab.ntt.co.jp>
	 <1273486607.3023.37.camel@e102109-lin.cambridge.arm.com>
	 <20100510115552.GD10452@parisc-linux.org>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Mon, 10 May 2010 15:00:10 +0100
Message-ID: <1273500010.10282.25.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 May 2010 14:00:10.0800 (UTC) FILETIME=[1AE56300:01CAF049]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-10 at 12:55 +0100, Matthew Wilcox wrote:
> On Mon, May 10, 2010 at 11:16:47AM +0100, Catalin Marinas wrote:
> > In most situations, just doing flushing in set_pte_at() would suffice
> > and flush_dcache_page() can be ignored. There are two situations where I
> > still see flush_dcache_page() useful:
> >
> >      1. SMP systems where the cache maintenance operations aren't
> >         automatically broadcast in hardware
> >      2. The kernel modifies a page cache page that is already mapped in
> >         user space
> >
> > (1) can be worked around on some architectures (though not sure about
> > all of them).
> >
> > Is (2) a valid scenario?
> 
> The kernel always calls kmap() / kunmap() around accesses to page cache
> pages (thanks to x86-32's ability to support 64GB).  There are three
> ways I know of that architectures use this:

I think this was mentioned in some past discussions. There are
situations where page cache pages aren't highmem pages and kmap/kunmap
isn't used:

http://thread.gmane.org/gmane.linux.ide/44847

But yes, that's a possible solution that ideally would need to be agreed
with the other architectures and write the recommendations in
cachetlb.txt. It may need, however, to update some of the drivers in
Linux.

It would also mean that some architectures need to implement the kmap
API even if they don't need it. That's David Miller's comment on
sparc64:

http://article.gmane.org/gmane.linux.ide/44872

> 1) No-ops.  These architectures don't have cache problems.
> 2) Flush the kernel's mapping in kunmap().  This can have bad consequences
> in SMP systems with threaded programs.
> 3) Select an address in kmap() that will alias to the user's address.

3rd point above would help with the D-cache aliasing. Does the I/D cache
coherency need to be handled differently? On PIPT Harvard architectures,
we don't actually have D-cache aliasing but we may end up flushing too
much in kunmap() just in case such page would be mapped in user space
with executable permission.

An alternative for a PIO API which would require fixing individual
drivers was proposed here:

http://thread.gmane.org/gmane.linux.kernel.cross-arch/5136

-- 
Catalin


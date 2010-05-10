Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497Ab0EJKRe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 06:17:34 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:34868 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754065Ab0EJKRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 06:17:30 -0400
Subject: Re: [RFC PATCH] Update the cachetlb.txt file WRT flush_dcache_page
 and update_mmu_cache
From: Catalin Marinas <catalin.marinas@arm.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       James.Bottomley@HansenPartnership.com, benh@kernel.crashing.org,
       davem@davemloft.net, rmk@arm.linux.org.uk
In-Reply-To: <20100510170616O.fujita.tomonori@lab.ntt.co.jp>
References: <20100507132418.28009.6013.stgit@e102109-lin.cambridge.arm.com>
	 <20100510170616O.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Mon, 10 May 2010 11:16:47 +0100
Message-ID: <1273486607.3023.37.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 May 2010 10:16:55.0831 (UTC) FILETIME=[EADF5270:01CAF029]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-10 at 09:06 +0100, FUJITA Tomonori wrote:
> On Fri, 07 May 2010 14:24:18 +0100
> Catalin Marinas <catalin.marinas@arm.com> wrote:
> > @@ -312,15 +324,15 @@ maps this page at its virtual address.
> >       This allows these interfaces to be implemented much more
> >       efficiently.  It allows one to "defer" (perhaps indefinitely)
> >       the actual flush if there are currently no user processes
> > -     mapping this page.  See sparc64's flush_dcache_page and
> > -     update_mmu_cache implementations for an example of how to go
> > +     mapping this page.  See IA-64's flush_dcache_page and
> > +     set_pte_at implementations for an example of how to go
> >       about doing this.
> 
> cachetlb.txt says that flush_dcache_page() is the API to solve the
> D-cache aliasing issue. Using IA64 as an example for the API here
> looks strange since IA64 (PIPT) doesn't have D-cache aliasing
> issue.

Once we fix the ARM implementation, we could use it as an example :). It
has processors with both D-cache aliasing and separate I/D caches.

> I don't think that just replacing sparc64 with IA64 helps much here
> since we still have the problem that the whole cache handling
> (architectures, subsystems, file systems) is inconsistent. I think
> that we need to agree on it first.

Yes, this need to be agreed and hopefully this thread is a starting
point for such discussion.

The main problem I encountered on ARM was I/D cache coherency on a PIPT
processor and IA-64 and PowerPC fixed it by combining
flush_dcache_page() with set_pte_at().

IMHO, the D-cache aliasing isn't that much different from the I/D cache
coherency. We can view the I-cache as yet another alias of the D-cache
which needs explicit flushing. As I said on a few occasions, including
this patch, the flush_dcache_page() isn't always called from PIO
drivers. Adding a PIO API didn't seem very popular as it requires a lot
of drivers to be modified.

In most situations, just doing flushing in set_pte_at() would suffice
and flush_dcache_page() can be ignored. There are two situations where I
still see flush_dcache_page() useful:

     1. SMP systems where the cache maintenance operations aren't
        automatically broadcast in hardware
     2. The kernel modifies a page cache page that is already mapped in
        user space

(1) can be worked around on some architectures (though not sure about
all of them).

Is (2) a valid scenario?

-- 
Catalin


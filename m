Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab0EKRXL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 13:23:11 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:32887 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752834Ab0EKRXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 13:23:08 -0400
Subject: Re: [RFC PATCH] Update the cachetlb.txt file WRT flush_dcache_page
 and update_mmu_cache
From: Catalin Marinas <catalin.marinas@arm.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       James.Bottomley@HansenPartnership.com, benh@kernel.crashing.org,
       davem@davemloft.net, rmk@arm.linux.org.uk
In-Reply-To: <20100511203024W.fujita.tomonori@lab.ntt.co.jp>
References: <20100511203024W.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Tue, 11 May 2010 18:22:34 +0100
Message-ID: <1273598554.3132.47.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 May 2010 17:22:35.0330 (UTC) FILETIME=[8C035A20:01CAF12E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-11 at 12:31 +0100, FUJITA Tomonori wrote:
> On Mon, 10 May 2010 11:16:47 +0100
> Catalin Marinas <catalin.marinas@arm.com> wrote:
> 
> > > I don't think that just replacing sparc64 with IA64 helps much here
> > > since we still have the problem that the whole cache handling
> > > (architectures, subsystems, file systems) is inconsistent. I think
> > > that we need to agree on it first.
> >
> > Yes, this need to be agreed and hopefully this thread is a starting
> > point for such discussion.
> 
> Hopefully, but I'm not sure what we need to agree is clear enough.
> 
> If we invert the meaning of PG_arch_1 (from PG_dcache_dirty to
> PG_dcache_clean) like the way IA64 and POWERPC to use the bit to solve
> I/D coherency, we can avoid calling flush_dcache_page() at low level
> drivers or their subsystems (ide_* macros, libata,
> bio_flush_dcache_pages, rq_flush_dcache_pages, etc). Architectures
> that need to handle D aliasing and I/D coherence need two bits
> respectively (needs another PG_arch_2 bit) to do flushes effectively.

The two bits idea was mentioned in the previous threads on cache
coherency.

So we basically have two main options (IMHO):

1) leave things as they currently are with PG_arch_1 meaning "dirty" and
change all low level (PIO) drivers call flush_dcache_page() when they
dirty the D-cache.

2) changing the meaning of PG_arch_1 to "clean" and maybe introduce
PG_arch_2 as an optimisation but don't force the low level drivers to
call flush_dcache_page().

The current cachetlb.txt recommends (1) but not all low-level (PIO)
drivers call flush_dcache_page(), hence I/D cache coherency issues at
least on ARM.

Should we go for (2) as a general recommendation across all
architectures that require I/D cache maintenance? Or stick with (1) and
modify the low level drivers to call flush_dcache_page (or a PIO API
similar to kmap that was already proposed on linux-arch)?

Thanks.

-- 
Catalin


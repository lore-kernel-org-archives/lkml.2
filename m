Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934195Ab0HMKy1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 06:54:27 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:63826 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934175Ab0HMKy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 06:54:26 -0400
Subject: Re: [REGRESSION 2.6.35+] crash (maybe kmemleak related)
From: Catalin Marinas <catalin.marinas@arm.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
In-Reply-To: <AANLkTi=uD1FAPcu1_dVy_KhnqHwqj1rjpZTA8bn96q9i@mail.gmail.com>
References: <AANLkTi=uD1FAPcu1_dVy_KhnqHwqj1rjpZTA8bn96q9i@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Fri, 13 Aug 2010 11:38:39 +0100
Message-ID: <1281695919.25390.31.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Aug 2010 10:38:39.0528 (UTC) FILETIME=[B12DF280:01CB3AD3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-13 at 11:28 +0100, Pekka Enberg wrote:
> On Fri, Aug 13, 2010 at 12:26 PM, Catalin Marinas
> <catalin.marinas@arm.com> wrote:
> > This kmemleak warning tells us that the kmemleak_alloc() hook got called
> > with a pointer (0xffff880079fe6000) that's already registered with
> > kmemleak. The first trace tells us where the hook gets called from while
> > the second trace shows the details of the already existing pointer.
> >
> > So __getname() allocates the same 4096 bytes block twice via
> > kmem_cache_alloc() but there is no kmemleak_free() call between them and
> > kmemleak gives up. It disables itself but does not panic the system.
> >
> > Pekka, were there any recent changes in the slab/slob/slub area and
> > maybe a kmemleak_free() hook is missing? Or maybe something else went
> > wrong with the slab allocator and returns an already allocated block?
> >
> >> <0>[   24.578578] general protection fault: 0000 [#1] PREEMPT SMP
> >
> > That's what's causing the fault but it doesn't seem to be related to
> > kmemleak.
> 
> Looking at Maxim's log, slab seems to be corrupted. I don't see
> anything obviously wrong with SLUB (which he is using) kmemleak hooks
> so it doesn't look like a slab allocator problem either. Could this be
> related to the bootmem kmemleak hook changes?

I don't think in this case since both allocations came via
kmem_cache_alloc() (and not one from bootmem and the other from slab, as
it happened to me in the past). But it's worth trying with kmemleak
disabled.

-- 
Catalin


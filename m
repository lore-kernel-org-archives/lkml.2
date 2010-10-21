Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270Ab0JUJwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 05:52:31 -0400
Received: from fep18.mx.upcmail.net ([62.179.121.38]:57490 "EHLO
	fep18.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756238Ab0JUJwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 05:52:30 -0400
X-SourceIP: 80.56.199.130
Subject: Re: mmotm 2010-10-20-15-01 uploaded
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20101021003008.064302ad.akpm@linux-foundation.org>
References: <201010202233.o9KMXNoL008303@imap1.linux-foundation.org>
	 <4CBFAB7B.7080306@cn.fujitsu.com> <4CBFB06B.3020305@cn.fujitsu.com>
	 <20101020204649.46361931.akpm@linux-foundation.org>
	 <1287645446.3488.56.camel@twins>
	 <20101021003008.064302ad.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Oct 2010 11:52:17 +0200
Message-ID: <1287654737.3488.94.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=BBXmjR/jrMMj1wHBsuD7Cdv69cLzNztNz9uR8CXiauo= c=1 sm=0 a=OHuDnJXnxFEA:10 a=IkcTkHD0fZMA:10 a=FutojZvVWbxFv7jhK4AA:9 a=00WyQZ2mByBFo8KtPeUA:7 a=8IBO46OYjezSwKS_KyPmg2Z-qWoA:4 a=QEXdDO2ut3YA:10 a=jcZ0KgbErnUWdn2y:21 a=2yIE1NYeGTNdLxZ9:21 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-21 at 00:30 -0700, Andrew Morton wrote:
> On Thu, 21 Oct 2010 09:17:26 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > > It would have been clearer to do
> > > 
> > >         WARN_ON_ONCE(vaddr != __fix_to_virt(FIX_KMAP_BEGIN + idx))
> > > 
> > > but I don't see what's gone wrong here.  Peter?
> > 
> > Right, so that's the warning that the unmapped address isn't actually
> > the top-of-stack one.
> > 
> > Your version is much nicer, although I haven't looked too hard at it, I
> > probably got my head in a twist.
> > 
> > But like you, I cannot directly see what's going wrong here,
> > zero_user_segments() seems a simple enough function without any
> > kmap_atomic nesting, so I'm not at all seeing how that's going wrong.
> > 
> > /me goes find where you hide your mmotm patch-queue and stare at the
> > actual code.

OK, so found it, and its really rather embarrassing.. I really blotched
those x86 WARN_ON_ONCE()s, for some reason I got my brain in a twist and
messed those up big-time. All other architectures have the form you
suggested earlier.

The problem is that fixmaps are top-down, so the original warning ended
up trying to compare x with (-x) >> PAGE_SHIFT, which clearly won't
work.

The sad part is that I apparently only compile tested the debug code :/

With the warning fixed (and CONFIG_DEBUG_HIGHMEM=y) an otherwise
i386-defconfig seems to fully complete boot without warnings on a qemu
with 2048 MB of memory.

---
Subject: mm, x86: Fix stack based kmap_atomic debug warnings
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Thu Oct 21 11:45:08 CEST 2010

Due to a massive brainfart I got the x86 kunmap_atomic debug code that
is supposed to avoid stack violations wrong.

Use the form all other architectures already use (which was also
independently suggested by Andrew).

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/mm/highmem_32.c |    3 +--
 arch/x86/mm/iomap_32.c   |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/x86/mm/highmem_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/highmem_32.c
+++ linux-2.6/arch/x86/mm/highmem_32.c
@@ -78,8 +78,7 @@ void __kunmap_atomic(void *kvaddr)
 		idx = type + KM_TYPE_NR * smp_processor_id();
 
 #ifdef CONFIG_DEBUG_HIGHMEM
-		WARN_ON_ONCE(idx !=
-			((vaddr - __fix_to_virt(FIX_KMAP_BEGIN)) >> PAGE_SHIFT));
+		WARN_ON_ONCE(vaddr != __fix_to_virt(FIX_KMAP_BEGIN + idx));
 #endif
 		/*
 		 * Force other mappings to Oops if they'll try to access this
Index: linux-2.6/arch/x86/mm/iomap_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/iomap_32.c
+++ linux-2.6/arch/x86/mm/iomap_32.c
@@ -102,8 +102,7 @@ iounmap_atomic(void __iomem *kvaddr)
 		idx = type + KM_TYPE_NR * smp_processor_id();
 
 #ifdef CONFIG_DEBUG_HIGHMEM
-		WARN_ON_ONCE(idx !=
-			((vaddr - __fix_to_virt(FIX_KMAP_BEGIN)) >> PAGE_SHIFT));
+		WARN_ON_ONCE(vaddr != __fix_to_virt(FIX_KMAP_BEGIN + idx));
 #endif
 		/*
 		 * Force other mappings to Oops if they'll try to access this



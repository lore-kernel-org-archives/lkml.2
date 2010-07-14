Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab0GNJvX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 05:51:23 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46927 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753553Ab0GNJvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 05:51:22 -0400
Subject: Re: kmemleak, cpu usage jump out of nowhere
From: Catalin Marinas <catalin.marinas@arm.com>
To: Zeno Davatz <zdavatz@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <AANLkTimgn1Xa0YIwjC6xOfNDjlqJSQYy65ZvqCtlMWHD@mail.gmail.com>
References: <AANLkTil6opQmTVVxuP1ngz72_ijpLzdlSFWDSyi4whOt@mail.gmail.com>
	 <AANLkTinGoUml9PQ8w7flukqwF9V1ae-YafiDVQy6Q8gC@mail.gmail.com>
	 <AANLkTimgn1Xa0YIwjC6xOfNDjlqJSQYy65ZvqCtlMWHD@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Wed, 14 Jul 2010 10:47:26 +0100
Message-ID: <1279100846.8592.53.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jul 2010 09:47:26.0963 (UTC) FILETIME=[91653C30:01CB2339]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-14 at 09:27 +0100, Zeno Davatz wrote:
> On Wed, Jul 14, 2010 at 10:05 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> > On Wed, Jul 14, 2010 at 9:12 AM, Zeno Davatz <zdavatz@gmail.com> wrote:

> >> I am attaching you the file from /sys/kernel/debug/kmemleak
> >
> > Zeno, can you post your dmesg and .config, please?
> 
> Sure, see attached files.

It looks like NO_BOOTMEM is enabled. You can try the attached patch (I
need to post it again on the list).


kmemleak: Add support for NO_BOOTMEM configurations

From: Catalin Marinas <catalin.marinas@arm.com>

With commits 08677214 and 59be5a8e, alloc_bootmem()/free_bootmem() and
friends use the early_res functions for memory management when
NO_BOOTMEM is enabled. This patch adds the kmemleak calls in the
corresponding code paths for bootmem allocations.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 mm/bootmem.c    |    2 ++
 mm/page_alloc.c |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/mm/bootmem.c b/mm/bootmem.c
index 58c66cc..0747f68 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -435,6 +435,7 @@ void __init free_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
 {
 #ifdef CONFIG_NO_BOOTMEM
 	free_early(physaddr, physaddr + size);
+	kmemleak_free_part(__va(physaddr), size);
 #else
 	unsigned long start, end;
 
@@ -460,6 +461,7 @@ void __init free_bootmem(unsigned long addr, unsigned long size)
 {
 #ifdef CONFIG_NO_BOOTMEM
 	free_early(addr, addr + size);
+	kmemleak_free_part(__va(addr), size);
 #else
 	unsigned long start, end;
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 431214b..f29f00b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3659,6 +3659,7 @@ void * __init __alloc_memory_core_early(int nid, u64 size, u64 align,
 		ptr = phys_to_virt(addr);
 		memset(ptr, 0, size);
 		reserve_early_without_check(addr, addr + size, "BOOTMEM");
+		kmemleak_alloc(ptr, size, 1, 0);
 		return ptr;
 	}
 


-- 
Catalin


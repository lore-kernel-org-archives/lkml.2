Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab2HCBsO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 21:48:14 -0400
Received: from bwv190.internetdsl.tpnet.pl ([83.18.229.190]:56528 "EHLO
	bwv190.internetdsl.tpnet.pl" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751433Ab2HCBsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 21:48:11 -0400
X-Greylist: delayed 735 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Aug 2012 21:48:10 EDT
Date: Fri, 3 Aug 2012 03:37:47 +0200 (CEST)
From: Piotr Gluszenia Slawinski <curious@bwv190.internetdsl.tpnet.pl>
To: linux-kernel@vger.kernel.org
cc: linux-mm@kvack.org
Subject: bootmem code - reboots after 'uncompressing linux' on old computers
Message-ID: <Pine.LNX.4.64.1208030324320.9164@bwv190.internetdsl.tpnet.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.
while bisecting old pcmcia bug i've noticed kernels ~2.6.36
and up do not boot on 586 machines with small amounts of ram (16M)

suprisingly 3.5 kernel booted fine.

i've bisected the problem and found fix :

solidstate linux # git bisect good
4e1c2b284461fd8aa8d7b295a1e911fc4390755b is the first bad commit
commit 4e1c2b284461fd8aa8d7b295a1e911fc4390755b
Author: David Miller <davem@davemloft.net>
Date:   Wed Apr 25 16:10:50 2012 -0400

     mm: nobootmem: Correct alloc_bootmem semantics.

     The comments above __alloc_bootmem_node() claim that the code will
     first try the allocation using 'goal' and if that fails it will
     try again but with the 'goal' requirement dropped.

     Unfortunately, this is not what the code does, so fix it to do so.

     This is important for nobootmem conversions to architectures such
     as sparc where MAX_DMA_ADDRESS is infinity.

     On such architectures all of the allocations done by generic spots,
     such as the sparse-vmemmap implementation, will pass in:

         __pa(MAX_DMA_ADDRESS)

     as the goal, and with the limit given as "-1" this will always fail
     unless we add the appropriate fallback logic here.

     Signed-off-by: David S. Miller <davem@davemloft.net>
     Acked-by: Yinghai Lu <yinghai@kernel.org>
     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

:040000 040000 5c42bbd13a81426248901205b051968bab14e6ff 
3e7fad8afb42036c6bbb1fcf5fcf12c87bbba9e2 M      mm


kernels before 3.6.39 do not have nobootmem.c , but they still have same 
bug!

this patch fixes the problem for them (useful for bisecting, etc, imho 
should be merged into 2.6.35-stable branch) :


diff --git a/mm/bootmem.c b/mm/bootmem.c
index 13b0caa..b0ccada 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -848,6 +848,7 @@ void * __init __alloc_bootmem_node(pg_data_t *pgdat, 
unsigned long size,
                 return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);

  #ifdef CONFIG_NO_BOOTMEM
+again:
         ptr = __alloc_memory_core_early(pgdat->node_id, size, align,
                                          goal, -1ULL);
         if (ptr)
@@ -859,6 +860,10 @@ void * __init __alloc_bootmem_node(pg_data_t *pgdat, 
unsigned long size,
         ptr = ___alloc_bootmem_node(pgdat->bdata, size, align, goal, 0);
  #endif

+       if (!ptr && goal) {
+               goal = 0;
+               goto again;
+       }
         return ptr;
  }


-- 

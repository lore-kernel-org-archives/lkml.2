Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758622Ab0JVSjD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:39:03 -0400
Received: from kroah.org ([198.145.64.141]:45790 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758319Ab0JVSi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:38:57 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:36:00 2010
Message-Id: <20101022183600.842337479@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:35:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [52/66] powerpc: Dont use kernel stack with translation off
In-Reply-To: <20101022183711.GA23214@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael Neuling <mikey@neuling.org>

commit 54a834043314c257210db2a9d59f8cc605571639 upstream.

In f761622e59433130bc33ad086ce219feee9eb961 we changed
early_setup_secondary so it's called using the proper kernel stack
rather than the emergency one.

Unfortunately, this stack pointer can't be used when translation is off
on PHYP as this stack pointer might be outside the RMO.  This results in
the following on all non zero cpus:
  cpu 0x1: Vector: 300 (Data Access) at [c00000001639fd10]
      pc: 000000000001c50c
      lr: 000000000000821c
      sp: c00000001639ff90
     msr: 8000000000001000
     dar: c00000001639ffa0
   dsisr: 42000000
    current = 0xc000000016393540
    paca    = 0xc000000006e00200
      pid   = 0, comm = swapper

The original patch was only tested on bare metal system, so it never
caught this problem.

This changes __secondary_start so that we calculate the new stack
pointer but only start using it after we've called early_setup_secondary.

With this patch, the above problem goes away.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/kernel/head_64.S |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/arch/powerpc/kernel/head_64.S
+++ b/arch/powerpc/kernel/head_64.S
@@ -566,13 +566,19 @@ __secondary_start:
 	/* Initialize the kernel stack.  Just a repeat for iSeries.	 */
 	LOAD_REG_ADDR(r3, current_set)
 	sldi	r28,r24,3		/* get current_set[cpu#]	 */
-	ldx	r1,r3,r28
-	addi	r1,r1,THREAD_SIZE-STACK_FRAME_OVERHEAD
-	std	r1,PACAKSAVE(r13)
+	ldx	r14,r3,r28
+	addi	r14,r14,THREAD_SIZE-STACK_FRAME_OVERHEAD
+	std	r14,PACAKSAVE(r13)
 
 	/* Do early setup for that CPU (stab, slb, hash table pointer) */
 	bl	.early_setup_secondary
 
+	/*
+	 * setup the new stack pointer, but *don't* use this until
+	 * translation is on.
+	 */
+	mr	r1, r14
+
 	/* Clear backchain so we get nice backtraces */
 	li	r7,0
 	mtlr	r7



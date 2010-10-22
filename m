Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759544Ab0JVS5O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:57:14 -0400
Received: from kroah.org ([198.145.64.141]:34404 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759493Ab0JVS5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:57:03 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:35 2010
Message-Id: <20101022185234.973658094@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:51:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Matt Evans <matt@ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [085/103] powerpc: Initialise paca->kstack before early_setup_secondary
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Matt Evans <matt@ozlabs.org>

commit f761622e59433130bc33ad086ce219feee9eb961 upstream.

As early setup calls down to slb_initialize(), we must have kstack
initialised before checking "should we add a bolted SLB entry for our kstack?"

Failing to do so means stack access requires an SLB miss exception to refill
an entry dynamically, if the stack isn't accessible via SLB(0) (kernel text
& static data).  It's not always allowable to take such a miss, and
intermittent crashes will result.

Primary CPUs don't have this issue; an SLB entry is not bolted for their
stack anyway (as that lives within SLB(0)).  This patch therefore only
affects the init of secondaries.

Signed-off-by: Matt Evans <matt@ozlabs.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/kernel/head_64.S |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/powerpc/kernel/head_64.S
+++ b/arch/powerpc/kernel/head_64.S
@@ -572,9 +572,6 @@ __secondary_start:
 	/* Set thread priority to MEDIUM */
 	HMT_MEDIUM
 
-	/* Do early setup for that CPU (stab, slb, hash table pointer) */
-	bl	.early_setup_secondary
-
 	/* Initialize the kernel stack.  Just a repeat for iSeries.	 */
 	LOAD_REG_ADDR(r3, current_set)
 	sldi	r28,r24,3		/* get current_set[cpu#]	 */
@@ -582,6 +579,9 @@ __secondary_start:
 	addi	r1,r1,THREAD_SIZE-STACK_FRAME_OVERHEAD
 	std	r1,PACAKSAVE(r13)
 
+	/* Do early setup for that CPU (stab, slb, hash table pointer) */
+	bl	.early_setup_secondary
+
 	/* Clear backchain so we get nice backtraces */
 	li	r7,0
 	mtlr	r7



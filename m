Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab2IZWbF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 18:31:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56636 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab2IZWa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 18:30:56 -0400
Date: Wed, 26 Sep 2012 15:30:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
        hpa@zytor.com, Alex Shi <alex.shi@intel.com>
Subject: Re: [PATCH] UV: fix incorrect tlb flush all issue
Message-Id: <20120926153055.77bfae02.akpm@linux-foundation.org>
In-Reply-To: <E1TGULk-000162-7Y@eag09.americas.sgi.com>
References: <E1TGULk-000162-7Y@eag09.americas.sgi.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Sep 2012 07:34:52 -0500
Cliff Wickman <cpw@sgi.com> wrote:

> From: Cliff Wickman <cpw@sgi.com>
> 
> (this was sent as an ack on 9/13, but with incorrect title and sign-off)
> 
> Ack.
> But with the adjustment below.  The 'end' argument was not declared long.
> 
> I tested the patch on a UV.
> It has the effect of either clearing 1 or all TLBs in a cpu.
> I added some debugging to test for the cases when clearing all TLBs is
> overkill, and in practice it happens very seldom.

- The initial (and rather wrong) patch was prepared by Alex.  Was it
  intentional that you claimed authorship?

  This patch is very different from the original, so that would be a
  reasonable thing to do.  But people often rewrite authorship by
  mistake.  Please clarify.

- If this is indeed considered a quite different patch then a
  Reported-by:Alex would be appropriate.

- You forgot to cc Alex on this email!

- Alex's original changelog contained the all-important bug
  description and that has got lost.


Here is what I have pieced together from this little mess.  It might be
wrong.  I added it to -mm's to-send-to-Ingo queue.


From: Alex Shi <alex.shi@intel.com>
Subject: arch/x86/platform/uv: fix incorrect tlb flush all issue

The flush tlb optimization code has logical issue on UV platform.  It
doesn't flush the full range at all, since it simply ignores its 'end'
parameter (and hence also the "all" indicator) in uv_flush_tlb_others()
function.

Cliff's notes:

: I tested the patch on a UV.  It has the effect of either clearing 1 or all
: TLBs in a cpu.  I added some debugging to test for the cases when clearing
: all TLBs is overkill, and in practice it happens very seldom.

Reported-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Alex Shi <alex.shi@intel.com>
Signed-off-by: Cliff Wickman <cpw@sgi.com>
Tested-by: Cliff Wickman <cpw@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/uv/uv.h  |    2 +-
 arch/x86/platform/uv/tlb_uv.c |   10 +++++++---
 2 files changed, 8 insertions(+), 4 deletions(-)

diff -puN arch/x86/include/asm/uv/uv.h~uv-fix-incorrect-tlb-flush-all-issue arch/x86/include/asm/uv/uv.h
--- a/arch/x86/include/asm/uv/uv.h~uv-fix-incorrect-tlb-flush-all-issue
+++ a/arch/x86/include/asm/uv/uv.h
@@ -16,7 +16,7 @@ extern void uv_system_init(void);
 extern const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
 						 struct mm_struct *mm,
 						 unsigned long start,
-						 unsigned end,
+						 unsigned long end,
 						 unsigned int cpu);
 
 #else	/* X86_UV */
diff -puN arch/x86/platform/uv/tlb_uv.c~uv-fix-incorrect-tlb-flush-all-issue arch/x86/platform/uv/tlb_uv.c
--- a/arch/x86/platform/uv/tlb_uv.c~uv-fix-incorrect-tlb-flush-all-issue
+++ a/arch/x86/platform/uv/tlb_uv.c
@@ -1034,7 +1034,8 @@ static int set_distrib_bits(struct cpuma
  * globally purge translation cache of a virtual address or all TLB's
  * @cpumask: mask of all cpu's in which the address is to be removed
  * @mm: mm_struct containing virtual address range
- * @va: virtual address to be removed (or TLB_FLUSH_ALL for all TLB's on cpu)
+ * @start: start virtual address to be removed from TLB
+ * @end: end virtual address to be remove from TLB
  * @cpu: the current cpu
  *
  * This is the entry point for initiating any UV global TLB shootdown.
@@ -1056,7 +1057,7 @@ static int set_distrib_bits(struct cpuma
  */
 const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
 				struct mm_struct *mm, unsigned long start,
-				unsigned end, unsigned int cpu)
+				unsigned long end, unsigned int cpu)
 {
 	int locals = 0;
 	int remotes = 0;
@@ -1113,7 +1114,10 @@ const struct cpumask *uv_flush_tlb_other
 
 	record_send_statistics(stat, locals, hubs, remotes, bau_desc);
 
-	bau_desc->payload.address = start;
+	if (!end || (end - start) <= PAGE_SIZE)
+		bau_desc->payload.address = start;
+	else
+		bau_desc->payload.address = TLB_FLUSH_ALL;
 	bau_desc->payload.sending_cpu = cpu;
 	/*
 	 * uv_flush_send_and_wait returns 0 if all cpu's were messaged,
_


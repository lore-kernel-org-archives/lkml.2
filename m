Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab2IMVTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 17:19:18 -0400
Received: from relay1.sgi.com ([192.48.179.29]:58129 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148Ab2IMVTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 17:19:16 -0400
Date: Thu, 13 Sep 2012 16:20:03 -0500
From: Cliff Wickman <cpw@sgi.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, alex.shi@intel.com, jbeulich@suse.com,
        tglx@linutronix.de, hpa@zytor.com
Subject: Re: [alex.shi@intel.com: Re: [PATCH] UV: fix incorrect tlb flush
	all issue]
Message-ID: <20120913212003.GA16789@sgi.com>
References: <20120913155310.GA4081@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120913155310.GA4081@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 05:53:10PM +0200, Ingo Molnar wrote:
> 
> Ack?
> 
> Thanks,
> 
> 	Ingo

Ack.
But with the adjustment below.  The 'end' argument was not declared long.

I tested the patch on a UV.
It has the effect of either clearing 1 or all TLBs in a cpu.
I added some debugging to test for the cases when clearing all TLBs is
overkill, and in practice it happens very seldom.

Sorry I didn't participate in this patch earlier.  Jack Steiner was
copied, I believe.  But steiner@sgi.com is no longer active. Jack has
retired -- congratulations to him, but a very big loss to us, both 
professionally and personally.

-Cliff

Reported-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Alex Shi <alex.shi@intel.com>
Acked-by: Cliff Wickman <cpw@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/include/asm/uv/uv.h  |    2 +-
 arch/x86/platform/uv/tlb_uv.c |   10 +++++++---
 2 files changed, 8 insertions(+), 4 deletions(-)

Index: linux/arch/x86/platform/uv/tlb_uv.c
===================================================================
--- linux.orig/arch/x86/platform/uv/tlb_uv.c
+++ linux/arch/x86/platform/uv/tlb_uv.c
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
Index: linux/arch/x86/include/asm/uv/uv.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv.h
+++ linux/arch/x86/include/asm/uv/uv.h
@@ -16,7 +16,7 @@ extern void uv_system_init(void);
 extern const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
 						 struct mm_struct *mm,
 						 unsigned long start,
-						 unsigned end,
+						 unsigned long end,
 						 unsigned int cpu);
 
 #else	/* X86_UV */

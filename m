Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451Ab2HVD06 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 23:26:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:18875 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663Ab2HVD0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 23:26:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,806,1336374000"; 
   d="scan'208";a="189630455"
Message-ID: <5034516E.60908@intel.com>
Date: Wed, 22 Aug 2012 11:26:38 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: apparent regressions from TLB range flushing page set
References: <503261F00200007800096710@nat28.tlf.novell.com>
In-Reply-To: <503261F00200007800096710@nat28.tlf.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Second, the UV code doesn't flush the full range at all, it simply
> ignores its 'end' parameter (and hence also the "all" indicator).
> 




Sure. the following rfc patch try to fix it. untested since no hardware.

=====

diff --git a/arch/x86/include/asm/uv/uv_bau.h b/arch/x86/include/asm/uv/uv_bau.h
index a06983c..ac6f326 100644
--- a/arch/x86/include/asm/uv/uv_bau.h
+++ b/arch/x86/include/asm/uv/uv_bau.h
@@ -225,8 +225,10 @@ struct bau_local_cpumask {
  * The payload is software-defined for INTD transactions
  */
 struct bau_msg_payload {
-	unsigned long	address;		/* signifies a page or all
-						   TLB's of the cpu */
+	unsigned long	start;			/* start address to flush TLB
+						   of the cpu */
+	unsigned long	end;			/* end address to flush TLB
+						   of the cpu */
 	/* 64 bits */
 	unsigned short	sending_cpu;		/* filled in by sender */
 	/* 16 bits */
diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index b8b3a37..c603d15 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -280,12 +280,12 @@ static void bau_process_message(struct msg_desc *mdp, struct bau_control *bcp,
 	/*
 	 * This must be a normal message, or retry of a normal message
 	 */
-	if (msg->address == TLB_FLUSH_ALL) {
+	if (msg->end == 0) {
+		__flush_tlb_one(msg->start);
+		stat->d_onetlb++;
+	} else {
 		local_flush_tlb();
 		stat->d_alltlb++;
-	} else {
-		__flush_tlb_one(msg->address);
-		stat->d_onetlb++;
 	}
 	stat->d_requestee++;
 
@@ -1034,7 +1034,8 @@ static int set_distrib_bits(struct cpumask *flush_mask, struct bau_control *bcp,
  * globally purge translation cache of a virtual address or all TLB's
  * @cpumask: mask of all cpu's in which the address is to be removed
  * @mm: mm_struct containing virtual address range
- * @va: virtual address to be removed (or TLB_FLUSH_ALL for all TLB's on cpu)
+ * @start: start virtual address to be removed from TLB
+ * @end: end virtual address to be remove from TLB
  * @cpu: the current cpu
  *
  * This is the entry point for initiating any UV global TLB shootdown.
@@ -1113,7 +1114,8 @@ const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
 
 	record_send_statistics(stat, locals, hubs, remotes, bau_desc);
 
-	bau_desc->payload.address = start;
+	bau_desc->payload.start = start;
+	bau_desc->payload.end	= end;
 	bau_desc->payload.sending_cpu = cpu;
 	/*
 	 * uv_flush_send_and_wait returns 0 if all cpu's were messaged,


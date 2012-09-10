Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704Ab2IJCIO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 22:08:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:53358 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756127Ab2IJCIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 22:08:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,396,1344236400"; 
   d="scan'208";a="190957574"
Message-ID: <504D4B68.6020404@intel.com>
Date: Mon, 10 Sep 2012 10:07:36 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: jeremy.fitzhardinge@citrix.com, tglx@linutronix.de,
        Andrew Morton <akpm@linux-foundation.org>, mingo@redhat.com,
        cpw@sgi.com, steiner@sgi.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com
Subject: Re: [PATCH] UV: fix incorrect tlb flush all issue
References: <1345798655-3669-1-git-send-email-alex.shi@intel.com> <20120906161136.b15e3d91.akpm@linux-foundation.org> <50498806.4020701@intel.com> <5049BA020200007800099920@nat28.tlf.novell.com>
In-Reply-To: <5049BA020200007800099920@nat28.tlf.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2012 03:10 PM, Jan Beulich wrote:

>>>> On 07.09.12 at 07:37, Alex Shi <alex.shi@intel.com> wrote:
>> @@ -1113,7 +1114,10 @@ const struct cpumask *uv_flush_tlb_others(const struct 
>> cpumask *cpumask,
>>  
>>  	record_send_statistics(stat, locals, hubs, remotes, bau_desc);
>>  
>> -	bau_desc->payload.address = start;
>> +	if (!end)
> 
> So despite having made a very similar mistake on the Xen side,
> you're again not following your own code adjustments here:
> The indicator for a multi-page flush is not 'end' being zero, nor
> would it be okay to use the proper indicator (TLB_FLUSH_ALL)
> here. Instead, to yield correct code, you need to check for the
> range covering more than one page. Improvements to do finer
> grained flushing (if worthwhile on UV) could then be done on
> top of this.
> 




Thanks for catching this typo. The patch was updated:
==========

>From bccb5f34834986fbd36c069640237296a9b1fe37 Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@intel.com>
Date: Fri, 7 Sep 2012 10:38:36 +0800
Subject: [PATCH] x86/uv: fix incorrect tlb flush issue

The flush tlb optimization code has logical issue on UV platform.
It doesn't flush the full range at all, since it simply
ignores its 'end' parameter (and hence also the "all" indicator)
in uv_flush_tlb_others() function.

I have tried to embed the start/end on UV code, but finally find the
'payload' message format embedded hardware filled vector. So be lacking
the enough knowledge of the hardware, I just check the start/end fair
in uv_flush_tlb_others(): except single page flush, will flush
all TLB entries for other situations.

Reported-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Alex Shi <alex.shi@intel.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/platform/uv/tlb_uv.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index b8b3a37..582836e 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
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
@@ -1113,7 +1114,10 @@ const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
 
 	record_send_statistics(stat, locals, hubs, remotes, bau_desc);
 
-	bau_desc->payload.address = start;
+	if (!end || (end - start) <= PAGE_SIZE)
+		bau_desc->payload.address = start;
+	else
+		bau_desc->payload.address = TLB_FLUSH_ALL;
 	bau_desc->payload.sending_cpu = cpu;
 	/*
 	 * uv_flush_send_and_wait returns 0 if all cpu's were messaged,
-- 
1.7.5.4


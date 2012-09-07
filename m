Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622Ab2IGFhq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 01:37:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:25647 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752537Ab2IGFho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 01:37:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,384,1344236400"; 
   d="scan'208";a="219189790"
Message-ID: <50498806.4020701@intel.com>
Date: Fri, 07 Sep 2012 13:37:10 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, cpw@sgi.com,
        steiner@sgi.com, jeremy.fitzhardinge@citrix.com,
        linux-kernel@vger.kernel.org, jbeulich@suse.com
Subject: Re: [PATCH] UV: fix incorrect tlb flush all issue
References: <1345798655-3669-1-git-send-email-alex.shi@intel.com> <20120906161136.b15e3d91.akpm@linux-foundation.org>
In-Reply-To: <20120906161136.b15e3d91.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2012 07:11 AM, Andrew Morton wrote:

> On Fri, 24 Aug 2012 16:57:35 +0800
> Alex Shi <alex.shi@intel.com> wrote:
> 
>> The flush tlb optimization code has logical issue on UV platform.
>> It doesn't flush the full range at all, since it simply
>> ignores its 'end' parameter (and hence also the "all" indicator)
>> in uv_flush_tlb_others() function.
>>
>> This patch fixed this issue, but untested due to hardware leaking.
> 
> Well, it doesn't really come very close to being compilable:
> 
> arch/x86/platform/uv/tlb_uv.c: In function 'bau_process_message':
> arch/x86/platform/uv/tlb_uv.c:283: error: 'struct bau_pq_entry' has no member named 'end'
> arch/x86/platform/uv/tlb_uv.c:284: error: 'struct bau_pq_entry' has no member named 'start'
> 
> Cliff, could you please help out here?
> 




Sorry, I had found the problem yesterday, and in trying to fix this issue.

here I use the simplest fixing, that just flush single page or flush all tlb.
It will great if UV experts like to enable flush_tlb_range() finally.

------
>From 1b5e470466d719109770a39b230c074f9d2a1490 Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@intel.com>
Date: Fri, 7 Sep 2012 10:38:36 +0800
Subject: [PATCH] x86/uv: fix incorrect tlb flush issue

The flush tlb optimization code has logical issue on UV platform.
It doesn't flush the full range at all, since it simply
ignores its 'end' parameter (and hence also the "all" indicator)
in uv_flush_tlb_others() function.

I have tried to embed the start/end on UV code, but finally find the
payload struct embedded hardware filled vector. So be lacking
the enough knowledge of the hardware, I just check the start/end fair
in uv_flush_tlb_others(): except single page flush(end==0), will flush
all TLB entries for any other situations.

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
index b8b3a37..1b2d49a 100644
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
+	if (!end)
+		bau_desc->payload.address = TLB_FLUSH_ALL;
+	else
+		bau_desc->payload.address = start;
 	bau_desc->payload.sending_cpu = cpu;
 	/*
 	 * uv_flush_send_and_wait returns 0 if all cpu's were messaged,
-- 
1.7.5.4


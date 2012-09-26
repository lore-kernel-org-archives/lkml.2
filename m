Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338Ab2IZCLl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 22:11:41 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:40462 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab2IZCLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 22:11:40 -0400
X-AuditID: b753bd60-94a4dba000002f78-4a-50626459467b
X-AuditID: b753bd60-94a4dba000002f78-4a-50626459467b
Subject: Re: [PATCH] x86: Distinguish TLB shootdown interrupts from other
 functions call interrupts
To: alex.shi@intel.com
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 26 Sep 2012 11:11:28 +0900
Message-ID: <20120926021128.22212.20440.stgit@hpxw>
In-Reply-To: <50611D82.4010702@intel.com>
References: <50611D82.4010702@intel.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

On 2012/09/25 11:57, Alex Shi wrote:
> On 09/24/2012 09:37 AM, Alex Shi wrote:
>
>> On 09/20/2012 04:50 PM, Tomoki Sekiyama wrote:
>>
>>>	unsigned int irq_resched_count;
>>>	unsigned int irq_call_count;
>>> +	/* irq_tlb_count is double-counted in irq_call_count, so it must be
>>> +	   subtracted from irq_call_count when displaying irq_call_count */
>>>	unsigned int irq_tlb_count;
>>
>> Review again this patch, above comments is not kernel compatible format.
>> Could you change it like standard comment format:
>>
>> /*
>>  * xxxxxxx
>>  * xxxx
>>  */
>>
>
> the 3.6 kernel will closed soon. it will be great to has this patch in.
> So, could you like to refresh your patch with popular comments format? :)

Fixed patch is below.
Thank you for the review again.

--
As TLB shootdown requests to other CPU cores are now using function call
interrupts, TLB shootdowns entry in /proc/interrupts is always shown as 0.

This behavior change was introduced by commit 52aec3308db8 ("x86/tlb:
replace INVALIDATE_TLB_VECTOR by CALL_FUNCTION_VECTOR").

This patch reverts TLB shootdowns entry in /proc/interrupts to count TLB
shootdowns separately from the other function call interrupts.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alex Shi <alex.shi@intel.com>
---
 arch/x86/include/asm/hardirq.h |    4 ++++
 arch/x86/kernel/irq.c          |    4 ++--
 arch/x86/mm/tlb.c              |    2 ++
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index d3895db..81f04ce 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -18,6 +18,10 @@ typedef struct {
 #ifdef CONFIG_SMP
 	unsigned int irq_resched_count;
 	unsigned int irq_call_count;
+	/*
+	 * irq_tlb_count is double-counted in irq_call_count, so it must be
+	 * subtracted from irq_call_count when displaying irq_call_count
+	 */
 	unsigned int irq_tlb_count;
 #endif
 #ifdef CONFIG_X86_THERMAL_VECTOR
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index d44f782..e4595f1 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -92,7 +92,8 @@ int arch_show_interrupts(struct seq_file *p, int prec)
 	seq_printf(p, "  Rescheduling interrupts\n");
 	seq_printf(p, "%*s: ", prec, "CAL");
 	for_each_online_cpu(j)
-		seq_printf(p, "%10u ", irq_stats(j)->irq_call_count);
+		seq_printf(p, "%10u ", irq_stats(j)->irq_call_count -
+					irq_stats(j)->irq_tlb_count);
 	seq_printf(p, "  Function call interrupts\n");
 	seq_printf(p, "%*s: ", prec, "TLB");
 	for_each_online_cpu(j)
@@ -147,7 +148,6 @@ u64 arch_irq_stat_cpu(unsigned int cpu)
 #ifdef CONFIG_SMP
 	sum += irq_stats(cpu)->irq_resched_count;
 	sum += irq_stats(cpu)->irq_call_count;
-	sum += irq_stats(cpu)->irq_tlb_count;
 #endif
 #ifdef CONFIG_X86_THERMAL_VECTOR
 	sum += irq_stats(cpu)->irq_thermal_count;
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 613cd83..2d6d8ed 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -98,6 +98,8 @@ static void flush_tlb_func(void *info)
 {
 	struct flush_tlb_info *f = info;
 
+	inc_irq_stat(irq_tlb_count);
+
 	if (f->flush_mm != this_cpu_read(cpu_tlbstate.active_mm))
 		return;
 


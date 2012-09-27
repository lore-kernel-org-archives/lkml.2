Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548Ab2I0HDW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 03:03:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:39770 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755961Ab2I0HDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 03:03:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,494,1344236400"; 
   d="scan'208";a="214161604"
Message-ID: <5063F9FD.8050002@intel.com>
Date: Thu, 27 Sep 2012 15:02:21 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: Distinguish TLB shootdown interrupts from other
 functions call interrupts
References: <50611D82.4010702@intel.com> <20120926021128.22212.20440.stgit@hpxw>
In-Reply-To: <20120926021128.22212.20440.stgit@hpxw>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>

>> the 3.6 kernel will closed soon. it will be great to has this patch in.
>> So, could you like to refresh your patch with popular comments format? :)
> 
> Fixed patch is below.
> Thank you for the review again.
> 



Peter:

Maybe the patch doesn't looks perfect for this issue.
So I am wondering if the following patch is better, if we don't care the irq_tlb
was counted again in irq_call?

===
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 613cd83..2d6d8ed 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -98,6 +98,8 @@ static void flush_tlb_func(void *info)
 {
        struct flush_tlb_info *f = info;
 
+       inc_irq_stat(irq_tlb_count);
+
        if (f->flush_mm != this_cpu_read(cpu_tlbstate.active_mm))
                return;
===

Or another solution is also reducing double counted irq_tlb_count from irq_call_count
What's your comments of this?

===
diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index d3895db..aac7886 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -36,6 +36,7 @@ DECLARE_PER_CPU_SHARED_ALIGNED(irq_cpustat_t, irq_stat);
 #define __ARCH_IRQ_STAT
 
 #define inc_irq_stat(member)   this_cpu_inc(irq_stat.member)
+#define dec_irq_stat(member)    this_cpu_dec(irq_stat.member)
 
 #define local_softirq_pending()        this_cpu_read(irq_stat.__softirq_pending)
 
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 613cd83..b82bd9f 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -98,6 +98,10 @@ static void flush_tlb_func(void *info)
 {
        struct flush_tlb_info *f = info;
 
+       /* remove double counted irq_tlb_count from irq_call_count */
+       dec_irq_stat(irq_call_count);
+       inc_irq_stat(irq_tlb_count);
+
        if (f->flush_mm != this_cpu_read(cpu_tlbstate.active_mm))
                return;
=== 

 
Thanks
    Alex

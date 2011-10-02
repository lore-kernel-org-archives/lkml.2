Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab1JBB7Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 21:59:25 -0400
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:43636
	"EHLO DB3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752115Ab1JBB7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 21:59:20 -0400
X-SpamScore: -15
X-BigFish: VPS-15(zzbb2dK936eK1432N98dKzz1202hzz8275bhz2fh668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4E87C535.2030907@am.sony.com>
Date: Sat, 1 Oct 2011 18:58:13 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>
CC: "Rowand, Frank" <Frank_Rowand@sonyusa.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PREEMPT_RT_FULL: arm coredump fails for cpu >= 4
References: <4E828E35.6070801@am.sony.com> <1317214993.24040.16.camel@twins> <4E83687D.1070507@am.sony.com>
In-Reply-To: <4E83687D.1070507@am.sony.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/11 11:33, Frank Rowand wrote:
> On 09/28/11 06:03, Peter Zijlstra wrote:
>> On Tue, 2011-09-27 at 20:02 -0700, Frank Rowand wrote:
>>>
>>> ARM can not use SPLIT_PTLOCK_CPUS if PREEMPT_RT_FULL because
>>> vectors_user_mapping() creates a VM_ALWAYSDUMP mapping of the vector page,
>>> but no ptl->lock has been allocated for the page.  An attempt to coredump
>>> that page will result in a kernel NULL pointer dereference when
>>> follow_page() attempts to lock the page.
>>
>>
>>>
>>> This patch is needed only if mm-shrink-the-page-frame-to-rt-size.patch is
>>> applied. 
>>
>> Yeah, vile hackery that is.. why isn't pgtable_page_ctor() called on
>> those pages?
> 
> Yep, that is the question.  I started fixing that yesterday, but realized
> I was going about it the wrong way, so I sent a first version of the
> patch that simply avoids the problem.
> 
> I'll be looking at whether I can fix it cleanly.
> 
>>
>> Not that I care too much about split_pte_lock on ARM, they're mostly all
>> tiny machines anyway so the gain is marginal, but it would be good to
>> find out why the pgtable constructor isn't called properly.


Patch Version 2

version 1 did not fix the underlying problem, but instead changed mm/Kconfig
to prevent ARM from enabling SPLIT_PTLOCK_CPUS.

Properly initialize the ptl->lock for the ARM vector page.

Without this patch, ARM can not use SPLIT_PTLOCK_CPUS if PREEMPT_RT_FULL
because vectors_user_mapping() creates a VM_ALWAYSDUMP mapping of the vector
page (address 0xffff0000), but no ptl->lock has been allocated for the page.
An attempt to coredump that page will result in a kernel NULL pointer
dereference when follow_page() attempts to lock the page.

The call tree to the NULL pointer dereference is:

   do_notify_resume()
      get_signal_to_deliver()
         do_coredump()
            elf_core_dump()
               get_dump_page()
                  __get_user_pages()
                     follow_page()
                        pte_offset_map_lock() <----- a #define
                           ...
                              rt_spin_lock()

The underlying problem is exposed by mm-shrink-the-page-frame-to-rt-size.patch.

Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>
---
 arch/arm/kernel/process.c |   25 	25 +	0 -	0 !
 1 file changed, 25 insertions(+)

Index: b/arch/arm/kernel/process.c
===================================================================
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -484,6 +484,31 @@ unsigned long arch_randomize_brk(struct 
 }
 
 #ifdef CONFIG_MMU
+
+/*
+ * CONFIG_SPLIT_PTLOCK_CPUS results in a page->ptl lock.  If the lock is not
+ * initialized by pgtable_page_ctor() then a coredump of the vector page will
+ * fail.
+ */
+static int __init vectors_user_mapping_init_page(void)
+{
+	struct page *page;
+	unsigned long addr = 0xffff0000;
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+
+	pgd = pgd_offset_k(addr);
+	pud = pud_offset(pgd, addr);
+	pmd = pmd_offset(pud, addr);
+	page = pmd_page(*(pmd));
+
+	pgtable_page_ctor(page);
+
+	return 0;
+}
+late_initcall(vectors_user_mapping_init_page);
+
 /*
  * The vectors page is always readable from user space for the
  * atomic helpers and the signal restart code.  Let's declare a mapping


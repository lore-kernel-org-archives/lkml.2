Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581Ab0GNP7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 11:59:46 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:36000 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756007Ab0GNP7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 11:59:44 -0400
Message-Id: <20100714155804.049012415@efficios.com>
User-Agent: quilt/0.48-1
Date: Wed, 14 Jul 2010 11:49:24 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, akpm@osdl.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>
Subject: [patch 1/2] x86_64 page fault NMI-safe
References: <20100714154923.947138065@efficios.com>
Content-Disposition: inline; filename=x86_64-page-fault-nmi-safe.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Wed, 14 Jul 2010 15:58:04 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think you're vastly overestimating what is sane to do from an NMI
> context.  It is utterly and totally insane to assume vmalloc is available
> in NMI.
>
>       -hpa
>

Ok, please tell me where I am wrong then.. by looking into
arch/x86/mm/fault.c, I see that vmalloc_sync_all() touches pgd_list
entries while the pgd_lock spinlock is taken, with interrupts disabled.
So it's protected against concurrent pgd_list modification from

a - vmalloc_sync_all() on other CPUs
b - local interrupts

However, a completely normal interrupt can come on a remote CPU, run
vmalloc_fault() and issue a set_pgd concurrently. Therefore I conclude
this interrupt disable is not there to insure any kind of protection
against concurrent updates.

Also, we see that vmalloc_fault has comments such as :

(for x86_32)
         * Do _not_ use "current" here. We might be inside
         * an interrupt in the middle of a task switch..

So it takes the pgd_addr from cr3, not from current. Using only the
stack/registers makes this NMI-safe even if "current" is invalid when
the NMI comes. This is caused by the fact that __switch_to will update
the registers before updating current_task without disabling interrupts.

You are right in that x86_64 does not seems to play as safely as x86_32
on this matter; it uses current->mm. Probably it shouldn't assume
"current" is valid. Actually, I don't see where x86_64 disables
interrupts around __switch_to, so this would seem to be a race
condition. Or have I missed something ?

(Ingo)
> > the scheduler disables interrupts around __switch_to(). (x86 does 
> > not set __ARCH_WANT_INTERRUPTS_ON_CTXSW)
>
(Mathieu)
> Ok, so I guess it's only useful to NMIs then. However, it makes me
> wonder why this comment was there in the first place on x86_32
> vmalloc_fault() and why it uses read_cr3() :
>
>         * Do _not_ use "current" here. We might be inside
>         * an interrupt in the middle of a task switch..
(Ingo)
hm, i guess it's still useful to keep the
__ARCH_WANT_INTERRUPTS_ON_CTXSW case working too. On -rt we used to
enable it to squeeze a tiny bit more latency out of the system.


Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: akpm@osdl.org
CC: mingo@elte.hu
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: "Frank Ch. Eigler" <fche@redhat.com>
---
 arch/x86/mm/fault.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/arch/x86/mm/fault.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/mm/fault.c	2010-03-13 16:56:46.000000000 -0500
+++ linux-2.6-lttng/arch/x86/mm/fault.c	2010-03-13 16:57:53.000000000 -0500
@@ -360,6 +360,7 @@ void vmalloc_sync_all(void)
  */
 static noinline __kprobes int vmalloc_fault(unsigned long address)
 {
+	unsigned long pgd_paddr;
 	pgd_t *pgd, *pgd_ref;
 	pud_t *pud, *pud_ref;
 	pmd_t *pmd, *pmd_ref;
@@ -374,7 +375,8 @@ static noinline __kprobes int vmalloc_fa
 	 * happen within a race in page table update. In the later
 	 * case just flush:
 	 */
-	pgd = pgd_offset(current->active_mm, address);
+	pgd_paddr = read_cr3();
+	pgd = __va(pgd_paddr) + pgd_index(address);
 	pgd_ref = pgd_offset_k(address);
 	if (pgd_none(*pgd_ref))
 		return -1;


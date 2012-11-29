Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab2K2Txc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 14:53:32 -0500
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:9895
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751399Ab2K2Tx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 14:53:29 -0500
X-Forefront-Antispam-Report: CIP:160.33.194.231;KIP:(null);UIP:(null);IPV:NLI;H:usculsndmail04v.am.sony.com;RD:mail04.sonyusa.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zzbb2dI98dI1432Izz1de0h1202h1d1ah1d2ahzz8275bhz2fh2a8h668h839h947hd25hf0ah10d2h1288h12a5h12a9h12bdh137ah13b6h1441h1537h153bh162dh1631h1155h)
Message-ID: <50B7BD1B.9010508@am.sony.com>
Date: Thu, 29 Nov 2012 11:52:59 -0800
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>
Subject: Re: 3.6.7-rt18 ARM BUG_ON() at kernel/sched/core.c:3817
References: <50B6D71E.30003@am.sony.com>
In-Reply-To: <50B6D71E.30003@am.sony.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/12 19:31, Frank Rowand wrote:
> 3.6.7-rt18:  kernel BUG at .../kernel/sched/core.c:3817!
> 
> Grant reported this same problem for 3.6.5-rt15.
> 
> I am seeing it on a different arm board.
> 
> Here is the BUG_ON():
> 
>    asmlinkage void __sched preempt_schedule_irq(void)
>    {
>         struct thread_info *ti = current_thread_info();
> 
>         /* Catch callers which need to be fixed */
>         BUG_ON(ti->preempt_count || !irqs_disabled());
> 
> Putting in some extra printk(), the BUG_ON() is triggering because
> ti->preempt_count is non-zero.
> 
> 
> It appears that the cause is in arch/arm/kernel/entry-armv.S.
> 
> The call to preempt_schedule_irq() is from svc_preempt:
> 
>    #ifdef CONFIG_PREEMPT
>    svc_preempt:
>            mov     r8, lr
>    1:      bl      preempt_schedule_irq            @ irq en/disable is done inside
> 
> 
> svc_preempt is branched to from one of two possible places.  The first was
> present before the lazy preempt code was added.  The first appears ok to me.
> (Note that the first branch does not occur if preempt count is non-zero.)
> 
> The second branch can occur even if the preempt count is non-zero (which is
> what the BUG_ON() is finding):
> 
>    __irq_svc:
>            svc_entry
>            irq_handler
> 
>    #ifdef CONFIG_PREEMPT
>            get_thread_info tsk
>            ldr     r8, [tsk, #TI_PREEMPT]          @ get preempt count
>            ldr     r0, [tsk, #TI_FLAGS]            @ get flags
>            teq     r8, #0                          @ if preempt count != 0
>            movne   r0, #0                          @ force flags to 0
>            tst     r0, #_TIF_NEED_RESCHED
>            blne    svc_preempt
>            ldr     r8, [tsk, #TI_PREEMPT_LAZY]     @ get preempt lazy count
>            ldr     r0, [tsk, #TI_FLAGS]            @ get flags
>            teq     r8, #0                          @ if preempt lazy count != 0
>            movne   r0, #0                          @ force flags to 0
>            tst     r0, #_TIF_NEED_RESCHED_LAZY
>            blne    svc_preempt
>    #endif

And here is a patch that fixes the symptom.  I'll have to look at how
the preempt lazy count feature works to see if the patch is consistent
with the feature.  I'll do that next.

Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>
---
 arch/arm/kernel/entry-armv.S |    4 	3 +	1 -	0 !
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: b/arch/arm/kernel/entry-armv.S
===================================================================
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -221,8 +221,10 @@ __irq_svc:
 	movne	r0, #0				@ force flags to 0
 	tst	r0, #_TIF_NEED_RESCHED
 	blne	svc_preempt
-	ldr	r8, [tsk, #TI_PREEMPT_LAZY]	@ get preempt lazy count
 	ldr	r0, [tsk, #TI_FLAGS]		@ get flags
+	teq	r8, #0				@ if preempt count != 0
+	movne	r0, #0				@ force flags to 0
+	ldr	r8, [tsk, #TI_PREEMPT_LAZY]	@ get preempt lazy count
 	teq	r8, #0				@ if preempt lazy count != 0
 	movne	r0, #0				@ force flags to 0
 	tst	r0, #_TIF_NEED_RESCHED_LAZY


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026Ab1EZQFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 12:05:49 -0400
Received: from canuck.infradead.org ([134.117.69.58]:43954 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017Ab1EZQFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 12:05:47 -0400
Subject: Re: [BUG] "sched: Remove rq->lock from the first half of ttwu()"
 locks up on ARM
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, Yong Zhang <yong.zhang0@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Frank Rowand <frank.rowand@am.sony.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <1306425584.2497.81.camel@laptop>
References: <1306260792.27474.133.camel@e102391-lin.cambridge.arm.com>
	 <1306272750.2497.79.camel@laptop> <1306343335.21578.65.camel@twins>
	 <1306358128.21578.107.camel@twins>
	 <BANLkTi=XbTXQsu3jUEvQyCfBy6-aRnqSpw@mail.gmail.com>
	 <1306405979.1200.63.camel@twins>
	 <1306407759.27474.207.camel@e102391-lin.cambridge.arm.com>
	 <1306409575.1200.71.camel@twins> <1306412511.1200.90.camel@twins>
	 <20110526154508.GA13788@redhat.com>  <1306425584.2497.81.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 May 2011 18:09:08 +0200
Message-ID: <1306426148.2497.83.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-26 at 17:59 +0200, Peter Zijlstra wrote:
> On Thu, 2011-05-26 at 17:45 +0200, Oleg Nesterov wrote:
> > Stupid question. Can't we fix this problem if we do
> > 
> >         -       if (p == current)
> >         +       if (cpu == raw_smp_processor_id())
> > 
> > ?
> > 
> > I forgot the rules... but iirc task_cpu(p) can't be changed under us?
> 
> Easy enough to test.. brain gave out again,. hold on ;-)

The below seems to run all-right so far, I'll let it run for a while.

---
 arch/x86/include/asm/system.h |    2 ++
 kernel/sched.c                |    3 ++-
 kernel/sched_debug.c          |    7 +++++++
 3 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
index c2ff2a1..2c597e8 100644
--- a/arch/x86/include/asm/system.h
+++ b/arch/x86/include/asm/system.h
@@ -10,6 +10,8 @@
 #include <linux/kernel.h>
 #include <linux/irqflags.h>
 
+#define __ARCH_WANT_INTERRUPTS_ON_CTXSW
+
 /* entries in ARCH_DLINFO: */
 #if defined(CONFIG_IA32_EMULATION) || !defined(CONFIG_X86_64)
 # define AT_VECTOR_SIZE_ARCH 2
diff --git a/kernel/sched.c b/kernel/sched.c
index 2d12893..f3627e5 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2636,7 +2636,8 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 		 * to spin on ->on_cpu if p is current, since that would
 		 * deadlock.
 		 */
-		if (p == current) {
+		if (cpu == smp_processor_id()) {
+			p->sched_contributes_to_load = 0;
 			ttwu_queue(p, cpu);
 			goto stat;
 		}
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index a6710a1..f0ff1de 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -332,6 +332,13 @@ static int sched_debug_show(struct seq_file *m, void *v)
 		(int)strcspn(init_utsname()->version, " "),
 		init_utsname()->version);
 
+#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
+	SEQ_printf(m, "__ARCH_WANT_INTERRUPTS_ON_CTXSW\n");
+#endif
+#ifdef __ARCH_WANT_UNLOCKED_CTXSW
+	SEQ_printf(m, "__ARCH_WANT_UNLOCKED_CTXSW\n");                                  
+#endif
+
 #define P(x) \
 	SEQ_printf(m, "%-40s: %Ld\n", #x, (long long)(x))
 #define PN(x) \



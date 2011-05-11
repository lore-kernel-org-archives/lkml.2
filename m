Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab1EKPmi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:42:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753308Ab1EKPiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:38:15 -0400
Date: Wed, 11 May 2011 13:06:13 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org
Subject: [PATCH, v2] kprobes, x86: Disable irq during optimized callback
Message-ID: <20110511110613.GB2390@jolsa.brq.redhat.com>
References: <1303822891-8450-1-git-send-email-jolsa@redhat.com>
 <20110510104019.GF2400@elte.hu>
 <20110510113913.GA6779@jolsa.brq.redhat.com>
 <20110510114418.GB24786@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110510114418.GB24786@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 01:44:18PM +0200, Ingo Molnar wrote:
> 
> * Jiri Olsa <jolsa@redhat.com> wrote:
> 
> > On Tue, May 10, 2011 at 12:40:19PM +0200, Ingo Molnar wrote:
> > > 
> > > * Jiri Olsa <jolsa@redhat.com> wrote:
> > > 
> > > > +	local_irq_save(flags);
> > > >  	preempt_disable();
> > > >  	if (kprobe_running()) {
> > > >  		kprobes_inc_nmissed_count(&op->kp);
> > > > @@ -1208,6 +1210,7 @@ static void __kprobes optimized_callback(struct optimized_kprobe *op,
> > > >  		__this_cpu_write(current_kprobe, NULL);
> > > >  	}
> > > >  	preempt_enable_no_resched();
> > > > +	local_irq_restore(flags);
> > > 
> > > irq-disable is synonymous to preempt disable so the preempt_disable()/enable() 
> > > pair looks like superfluous overhead.
> > 
> > yes, there's correct patch already in the list here:
> > http://marc.info/?l=linux-kernel&m=130382756829695&w=2
> 
> It helps to change the subject line when you think another patch should be 
> considered, to something like:
> 
>   [PATCH, v2] kprobes, x86: Disable irq during optimized callback
> 
> (also note the other changes i made to the title, 3 altogether.)

sorry, here it is ;) thanks

jirka

---
Disabling irqs during optimized callback, so we dont miss
any in-irq kprobes as missed.

running following:

# cd /debug/tracing/
# echo "p mutex_unlock" >> kprobe_events
# echo "p _raw_spin_lock" >> kprobe_events
# echo "p smp_apic_timer_interrupt" >> ./kprobe_events
# echo 1 > events/enable

makes the optimized kprobes to be missed. None is missed
if the kprobe optimatization is disabled.


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 arch/x86/kernel/kprobes.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index c969fd9..f1a6244 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -1183,12 +1183,13 @@ static void __kprobes optimized_callback(struct optimized_kprobe *op,
 					 struct pt_regs *regs)
 {
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+	unsigned long flags;
 
 	/* This is possible if op is under delayed unoptimizing */
 	if (kprobe_disabled(&op->kp))
 		return;
 
-	preempt_disable();
+	local_irq_save(flags);
 	if (kprobe_running()) {
 		kprobes_inc_nmissed_count(&op->kp);
 	} else {
@@ -1207,7 +1208,7 @@ static void __kprobes optimized_callback(struct optimized_kprobe *op,
 		opt_pre_handler(&op->kp, regs);
 		__this_cpu_write(current_kprobe, NULL);
 	}
-	preempt_enable_no_resched();
+	local_irq_restore(flags);
 }
 
 static int __kprobes copy_optimized_instructions(u8 *dest, u8 *src)
-- 
1.7.1


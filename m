Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758679Ab0GVVvz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 17:51:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756559Ab0GVVvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 17:51:53 -0400
Date: Thu, 22 Jul 2010 17:51:37 -0400
From: Don Zickus <dzickus@redhat.com>
To: fweisbec@gmail.com, peterz@infradead.org
Cc: mingo@elte.hu, yinghai@kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC] x86: perf swallows all NMIs when registered with a user
Message-ID: <20100722215136.GA23517@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When debugging a problem with Yinghai, I noticed that when the perf event
subsystem has a user (in this case the new generic nmi_watchdog), it just
blindly swallows all the NMIs in the system.

This causes issues for people like Yinghai, who want to use an external
nmi button to generate a panic, or other big companies that like to
registered the nmi handlers at a lower priority to be a catch-all for NMI
problems or also it will start masking any unknown nmi problems that would
have cropped up due to broken firmware or such.

The problem is spelled out in the comment in
arch/x86/kernel/cpu/perf_event.c::perf_event_nmi_handler

perf_event_nmi_handler(struct notifier_block *self,
                         unsigned long cmd, void *__args)
{
        struct die_args *args = __args;
        struct pt_regs *regs;
        static int eat_nmis = 0;

        if (!atomic_read(&active_events))
                return NOTIFY_DONE;

        switch (cmd) {
        case DIE_NMI:
        case DIE_NMI_IPI:
                break;

        default:
                return NOTIFY_DONE;
        }

        regs = args->regs;

        apic_write(APIC_LVTPC, APIC_DM_NMI);
        /*
         * Can't rely on the handled return value to say it was our NMI,
         * two
         * events could trigger 'simultaneously' raising two back-to-back
         * NMIs.
         *
         * If the first NMI handles both, the latter will be empty and
         * daze
         * the CPU.
         */
        x86_pmu.handle_irq(regs);

        return NOTIFY_STOP;
}

In the normal case, there is no perf user, so the function returns with
NOTIFY_DONE right away.  But with the new nmi_watchdog, which is a user of
the perf subsystem, it catches DIE_NMI, executes x86_pmu.handle_irq, and
finally returns NOTIFY_STOP.

The comment above describes the problem well, but as a result no other
NMIs can get through.

I looked at the code and thought I could modify the handle_irq to only
handle one PMU at a time, with the thought that there is probably another
NMI waiting for the other PMUs.  This would handle the problem nicely.

But I believe the code is structured such that an event can occupy more
than one PMU in complex cases and as a result would probably break things
because the event would be in limbo until all the NMIs happened to
disable it??  I am not familiar enough with how perf works to know if that
case is correct or not.

So I hacked up some stupid code to start a conversation that just keeps
track of how many NMIs are supposed to happen based on the number of PMUs
handled.  Then on future NMIs those are 'eaten' until the count is zero
again.

Like I said this patch is just something to start a conversation.  I
tested it, but could not do anything complicated enough such that more
than one PMU was handled during one NMI call.

Comments?

Cheers,
Don

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index f2da20f..df6255c 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1154,7 +1156,7 @@ static int x86_pmu_handle_irq(struct pt_regs *regs)
 		/*
 		 * event overflow
 		 */
-		handled		= 1;
+		handled		+= 1;
 		data.period	= event->hw.last_period;
 
 		if (!x86_perf_event_set_period(event))
@@ -1206,6 +1210,7 @@ perf_event_nmi_handler(struct notifier_block *self,
 {
 	struct die_args *args = __args;
 	struct pt_regs *regs;
+	static int eat_nmis = 0;
 
 	if (!atomic_read(&active_events))
 		return NOTIFY_DONE;
@@ -1229,9 +1234,13 @@ perf_event_nmi_handler(struct notifier_block *self,
 	 * If the first NMI handles both, the latter will be empty and daze
 	 * the CPU.
 	 */
-	x86_pmu.handle_irq(regs);
+	eat_nmis += x86_pmu.handle_irq(regs);
+	if (eat_nmis) {
+		eat_nmis--;
+		return NOTIFY_STOP;
+	}
 
-	return NOTIFY_STOP;
+	return NOTIFY_DONE;
 }
 
 static __read_mostly struct notifier_block perf_event_nmi_notifier = {

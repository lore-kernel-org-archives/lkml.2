Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150Ab0IRTQF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:16:05 -0400
Received: from kroah.org ([198.145.64.141]:43743 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757095Ab0IRTQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:16:01 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:05 2010
Message-Id: <20100918191305.403277590@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:13:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [094/129] powerpc/perf_event: Reduce latency of calling perf_event_do_pending
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Paul Mackerras <paulus@samba.org>

commit b0d278b7d3ae9115939ddcea93f516308cc367e2 upstream.

Commit 0fe1ac48 ("powerpc/perf_event: Fix oops due to
perf_event_do_pending call") moved the call to perf_event_do_pending
in timer_interrupt() down so that it was after the irq_enter() call.
Unfortunately this moved it after the code that checks whether it
is time for the next decrementer clock event.  The result is that
the call to perf_event_do_pending() won't happen until the next
decrementer clock event is due.  This was pointed out by Milton
Miller.

This fixes it by moving the check for whether it's time for the
next decrementer clock event down to the point where we're about
to call the event handler, after we've called perf_event_do_pending.

This has the side effect that on old pre-Core99 Powermacs where we
use the ppc_n_lost_interrupts mechanism to replay interrupts, a
replayed interrupt will incur a little more latency since it will
now do the code from the irq_enter down to the irq_exit, that it
used to skip.  However, these machines are now old and rare enough
that this doesn't matter.  To make it clear that ppc_n_lost_interrupts
is only used on Powermacs, and to speed up the code slightly on
non-Powermac ppc32 machines, the code that tests ppc_n_lost_interrupts
is now conditional on CONFIG_PMAC as well as CONFIG_PPC32.

Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/kernel/time.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -616,20 +616,11 @@ void timer_interrupt(struct pt_regs * re
 	 * some CPUs will continuue to take decrementer exceptions */
 	set_dec(DECREMENTER_MAX);
 
-#ifdef CONFIG_PPC32
+#if defined(CONFIG_PPC32) && defined(CONFIG_PMAC)
 	if (atomic_read(&ppc_n_lost_interrupts) != 0)
 		do_IRQ(regs);
 #endif
 
-	now = get_tb_or_rtc();
-	if (now < decrementer->next_tb) {
-		/* not time for this event yet */
-		now = decrementer->next_tb - now;
-		if (now <= DECREMENTER_MAX)
-			set_dec((int)now);
-		trace_timer_interrupt_exit(regs);
-		return;
-	}
 	old_regs = set_irq_regs(regs);
 	irq_enter();
 
@@ -645,8 +636,16 @@ void timer_interrupt(struct pt_regs * re
 		get_lppaca()->int_dword.fields.decr_int = 0;
 #endif
 
-	if (evt->event_handler)
-		evt->event_handler(evt);
+	now = get_tb_or_rtc();
+	if (now >= decrementer->next_tb) {
+		decrementer->next_tb = ~(u64)0;
+		if (evt->event_handler)
+			evt->event_handler(evt);
+	} else {
+		now = decrementer->next_tb - now;
+		if (now <= DECREMENTER_MAX)
+			set_dec((int)now);
+	}
 
 #ifdef CONFIG_PPC_ISERIES
 	if (firmware_has_feature(FW_FEATURE_ISERIES) && hvlpevent_is_pending())



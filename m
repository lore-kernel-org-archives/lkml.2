Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119Ab1ITOov (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 10:44:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498Ab1ITOoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 10:44:03 -0400
From: Don Zickus <dzickus@redhat.com>
To: <x86@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        Peter Zijlstra <peterz@infradead.org>, ying.huang@intel.com
Cc: LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com,
        avi@redhat.com, jeremy@goop.org, Don Zickus <dzickus@redhat.com>
Subject: [V5][PATCH 4/6] x86, nmi:  add in logic to handle multiple events and unknown NMIs
Date: Tue, 20 Sep 2011 10:43:10 -0400
Message-Id: <1316529792-6560-5-git-send-email-dzickus@redhat.com>
In-Reply-To: <1316529792-6560-1-git-send-email-dzickus@redhat.com>
References: <1316529792-6560-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previous patches allow the NMI subsystem to process multipe NMI events
in one NMI.  As previously discussed this can cause issues when an event
triggered another NMI but is processed in the current NMI.  This causes the
next NMI to go unprocessed and become an 'unknown' NMI.

To handle this, we first have to flag whether or not the NMI handler handled
more than one event or not.  If it did, then there exists a chance that
the next NMI might be already processed.  Once the NMI is flagged as a
candidate to be swallowed, we next look for a back-to-back NMI condition.

This is determined by looking at the %rip from pt_regs.  If it is the same
as the previous NMI, it is assumed the cpu did not have a chance to jump
back into a non-NMI context and execute code and instead handled another NMI.

If both of those conditions are true then we will swallow any unknown NMI.

There still exists a chance that we accidentally swallow a real unknown NMI,
but for now things seem better.

An optimization has also been added to the nmi notifier rountine.  Because x86
can latch up to one NMI while currently processing an NMI, we don't have to
worry about executing _all_ the handlers in a standalone NMI.  The idea is
if multiple NMIs come in, the second NMI will represent them.  For those
back-to-back NMI cases, we have the potentail to drop NMIs.  Therefore only
execute all the handlers in the second half of a detected back-to-back NMI.

V2:
  - forgot to add the 'read' code for swallow_nmi (went into next patch)

V3:
  - redesigned the algorithm to utilize Avi's idea of detecting a back-to-back
    NMI with %rip.
V4:
  - clean up fixes, like adding 'static', rename save_rip to last_nmi_rip

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/nmi.c |   80 +++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 75 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index acd61e8..04c9339 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -66,7 +66,7 @@ __setup("unknown_nmi_panic", setup_unknown_nmi_panic);
 
 #define nmi_to_desc(type) (&nmi_desc[type])
 
-static int notrace __kprobes nmi_handle(unsigned int type, struct pt_regs *regs)
+static int notrace __kprobes nmi_handle(unsigned int type, struct pt_regs *regs, bool b2b)
 {
 	struct nmi_desc *desc = nmi_to_desc(type);
 	struct nmiaction *next_a, *a, **ap = &desc->head;
@@ -87,6 +87,16 @@ static int notrace __kprobes nmi_handle(unsigned int type, struct pt_regs *regs)
 
 		handled += a->handler(type, regs);
 
+		/*
+ 		 * Optimization: only loop once if this is not a 
+ 		 * back-to-back NMI.  The idea is nothing is dropped
+ 		 * on the first NMI, only on the second of a back-to-back
+ 		 * NMI.  No need to waste cycles going through all the
+ 		 * handlers.
+ 		 */
+		if (!b2b && handled)
+			break;
+
 		a = next_a;
 	}
 	rcu_read_unlock();
@@ -255,7 +265,13 @@ unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 {
 	int handled;
 
-	handled = nmi_handle(NMI_UNKNOWN, regs);
+	/*
+	 * Use 'false' as back-to-back NMIs are dealt with one level up.
+	 * Of course this makes having multiple 'unknown' handlers useless
+	 * as only the first one is ever run (unless it can actually determine
+	 * if it caused the NMI)
+	 */
+	handled = nmi_handle(NMI_UNKNOWN, regs, false);
 	if (handled) 
 		return;
 #ifdef CONFIG_MCA
@@ -278,19 +294,49 @@ unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 	pr_emerg("Dazed and confused, but trying to continue\n");
 }
 
+static DEFINE_PER_CPU(bool, swallow_nmi);
+static DEFINE_PER_CPU(unsigned long, last_nmi_rip);
+
 static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 {
 	unsigned char reason = 0;
 	int handled;
+	bool b2b = false;
 
 	/*
 	 * CPU-specific NMI must be processed before non-CPU-specific
 	 * NMI, otherwise we may lose it, because the CPU-specific
 	 * NMI can not be detected/processed on other CPUs.
 	 */
-	handled = nmi_handle(NMI_LOCAL, regs);
-	if (handled)
+
+	/*
+	 * Back-to-back NMIs are interesting because they can either
+	 * be two NMI or more than two NMIs (any thing over two is dropped
+	 * due to NMI being edge-triggered).  If this is the second half
+	 * of the back-to-back NMI, assume we dropped things and process
+	 * more handlers.  Otherwise reset the 'swallow' NMI behaviour
+	 */
+	if (regs->ip == __this_cpu_read(last_nmi_rip))
+		b2b = true;
+	else
+		__this_cpu_write(swallow_nmi, false);
+
+	__this_cpu_write(last_nmi_rip, regs->ip);
+
+	handled = nmi_handle(NMI_LOCAL, regs, b2b);
+	if (handled) {
+		/*
+ 		 * There are cases when a NMI handler handles multiple
+ 		 * events in the current NMI.  One of these events may
+ 		 * be queued for in the next NMI.  Because the event is
+ 		 * already handled, the next NMI will result in an unknown
+ 		 * NMI.  Instead lets flag this for a potential NMI to
+ 		 * swallow.
+		 */
+		if (handled > 1)
+			__this_cpu_write(swallow_nmi, true);
 		return;
+	}
 
 	/* Non-CPU-specific NMI: NMI sources can be processed on any CPU */
 	raw_spin_lock(&nmi_reason_lock);
@@ -313,7 +359,31 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 	}
 	raw_spin_unlock(&nmi_reason_lock);
 
-	unknown_nmi_error(reason, regs);
+	/*
+	 * Only one NMI can be latched at a time.  To handle
+	 * this we may process multiple nmi handlers at once to
+	 * cover the case where an NMI is dropped.  The downside
+	 * to this approach is we may process an NMI prematurely,
+	 * while its real NMI is sitting latched.  This will cause
+	 * an unknown NMI on the next run of the NMI processing.
+	 * 
+	 * We tried to flag that condition above, by setting the
+	 * swallow_nmi flag when we process more than one event.
+	 * This condition is also only present on the second half
+	 * of a back-to-back NMI, so we flag that condition too.
+	 *
+	 * If both are true, we assume we already processed this
+	 * NMI previously and we swallow it.  Otherwise we reset
+	 * the logic.
+	 *
+	 * I am sure there are scenarios where we accidentally
+	 * swallow a real 'unknown' NMI.  But this is the best
+	 * we can do for now.
+	 */
+	if (b2b && __this_cpu_read(swallow_nmi))
+		;
+	else
+		unknown_nmi_error(reason, regs);
 }
 
 dotraplinkage notrace __kprobes void
-- 
1.7.6


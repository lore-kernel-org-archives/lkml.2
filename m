Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab1HYQqg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:46:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754108Ab1HYQqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:46:34 -0400
From: Don Zickus <dzickus@redhat.com>
To: <x86@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        Peter Zijlstra <peterz@infradead.org>, ying.huang@intel.com
Cc: LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com,
        Don Zickus <dzickus@redhat.com>
Subject: [V3][PATCH 4/6] x86, nmi:  add in logic to handle multiple events and unknown NMIs
Date: Thu, 25 Aug 2011 12:45:46 -0400
Message-Id: <1314290748-23569-5-git-send-email-dzickus@redhat.com>
In-Reply-To: <1314290748-23569-1-git-send-email-dzickus@redhat.com>
References: <1314290748-23569-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previous patches allow the NMI subsystem to process multipe NMI events
in one NMI.  As previously discussed this can cause issues when an event
triggered another NMI but is processed in the current NMI.  This causes the
next NMI to go unprocessed and become an 'unknown' NMI.

Having this print 'unknown' NMI to the console would be inaccurate and
scare users.  As a result I have copied the 'skip unknown' NMI logic
developed by Robert Richter (and simplfied a little because we can
track _all_ NMIs better instead of just the perf ones) to the main
NMI handling routine.

It is fairly simple, if when processing an NMI, the nmi_handle routine returns
more than one event handled, then set a flag for future use.  This flag just
says there might be a possible unknown NMI.  If an unknown NMI does come in,
then it is skipped (swallowed).  Otherwise just clear the flag on the next NMI
if it has events processed.

The algorithm isn't 100% accurate but for most loads we have seen in perf it
captures a large majority of unknown NMIs.  Under high workloads there still
is the chance that unknown NMIs can trigger because you can time it just right
such that you are generating NMIs as fast as you can process them and go four
or five NMIs before seeing the unknown NMI.

Without involving the concept of time when tracking these 'possible' NMIs,
we may never be 100% reliable.  The idea with time being that back-to-back
NMIs immediately follow each other.  Anything more than a micro second or so
on modern machines between when the first NMI finished to when the second one
starts, probably indicates a completely new event.

V2:
  - forgot to add the 'read' code for swallow_nmi (went into next patch)

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/nmi.c |   29 +++++++++++++++++++++++++++--
 1 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 45fcd82..435dc71 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -270,6 +270,8 @@ unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 	pr_emerg("Dazed and confused, but trying to continue\n");
 }
 
+DEFINE_PER_CPU(bool, swallow_nmi);
+
 static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 {
 	unsigned char reason = 0;
@@ -281,8 +283,28 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 	 * NMI can not be detected/processed on other CPUs.
 	 */
 	handled = nmi_handle(NMI_LOCAL, regs);
-	if (handled)
+	if (handled) {
+		/*
+		 * When handling multiple NMI events, we are not
+		 * sure if the second NMI was dropped (because of
+		 * too many NMIs), piggy-backed on the same NMI
+		 * (perf) or is queued right behind this NMI.
+		 * In the last case, we may accidentally get an
+		 * unknown NMI because the event is already handled.
+		 * Flag for this condition and swallow it later.
+		 *
+		 * FIXME: This detection has holes in it mainly
+		 * because we can't tell _when_ the next NMI comes
+		 * in.  A multi-handled NMI event followed by an 
+		 * unknown NMI a second later, clearly should not
+		 * be swallowed.
+		 */
+		if (handled > 1)
+			__this_cpu_write(swallow_nmi, true);
+		else
+			__this_cpu_write(swallow_nmi, false);
 		return;
+	}
 
 	/* Non-CPU-specific NMI: NMI sources can be processed on any CPU */
 	raw_spin_lock(&nmi_reason_lock);
@@ -305,7 +327,10 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 	}
 	raw_spin_unlock(&nmi_reason_lock);
 
-	unknown_nmi_error(reason, regs);
+	if (!__this_cpu_read(swallow_nmi))
+		unknown_nmi_error(reason, regs);
+
+	__this_cpu_write(swallow_nmi, false);
 }
 
 dotraplinkage notrace __kprobes void
-- 
1.7.6


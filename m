Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810Ab1ITOoH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 10:44:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384Ab1ITOoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 10:44:02 -0400
From: Don Zickus <dzickus@redhat.com>
To: <x86@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        Peter Zijlstra <peterz@infradead.org>, ying.huang@intel.com
Cc: LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com,
        avi@redhat.com, jeremy@goop.org, Don Zickus <dzickus@redhat.com>
Subject: [V5][PATCH 5/6] x86, nmi: track NMI usage stats
Date: Tue, 20 Sep 2011 10:43:11 -0400
Message-Id: <1316529792-6560-6-git-send-email-dzickus@redhat.com>
In-Reply-To: <1316529792-6560-1-git-send-email-dzickus@redhat.com>
References: <1316529792-6560-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the NMI handler are broken into lists, increment the appropriate
stats for each list.  This allows us to see what is going on when they
get printed out in the next patch.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/nmi.c |   20 ++++++++++++++++++--
 1 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 04c9339..bb8242e 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -48,6 +48,15 @@ static struct nmi_desc nmi_desc[NMI_MAX] =
 
 };
 
+struct nmi_stats {
+	unsigned int normal;
+	unsigned int unknown;
+	unsigned int external;
+	unsigned int swallow;
+};
+
+static DEFINE_PER_CPU(struct nmi_stats, nmi_stats);
+
 static int ignore_nmis;
 
 int unknown_nmi_panic;
@@ -272,8 +281,13 @@ unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 	 * if it caused the NMI)
 	 */
 	handled = nmi_handle(NMI_UNKNOWN, regs, false);
-	if (handled) 
+	if (handled) {
+		__this_cpu_add(nmi_stats.unknown, handled);
 		return;
+	}
+
+	__this_cpu_add(nmi_stats.unknown, 1);
+
 #ifdef CONFIG_MCA
 	/*
 	 * Might actually be able to figure out what the guilty party
@@ -324,6 +338,7 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 	__this_cpu_write(last_nmi_rip, regs->ip);
 
 	handled = nmi_handle(NMI_LOCAL, regs, b2b);
+	__this_cpu_add(nmi_stats.normal, handled);
 	if (handled) {
 		/*
  		 * There are cases when a NMI handler handles multiple
@@ -354,6 +369,7 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 		 */
 		reassert_nmi();
 #endif
+		__this_cpu_add(nmi_stats.external, 1);
 		raw_spin_unlock(&nmi_reason_lock);
 		return;
 	}
@@ -381,7 +397,7 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 	 * we can do for now.
 	 */
 	if (b2b && __this_cpu_read(swallow_nmi))
-		;
+		__this_cpu_add(nmi_stats.swallow, 1);
 	else
 		unknown_nmi_error(reason, regs);
 }
-- 
1.7.6


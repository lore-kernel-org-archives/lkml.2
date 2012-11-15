Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768593Ab2KORws (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 12:52:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13422 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768567Ab2KORwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 12:52:47 -0500
X-Authority-Analysis: v=2.0 cv=YP4dOG6x c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=skrZvcOWfsoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=E9MJ4dmaRSoA:10 a=HQDe5QKAFfvOPPeXlHcA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1353001964.18025.107.camel@gandalf.local.home>
Subject: [PATCH RFC] irq_work: Warn if there's still work on cpu_down
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Thu, 15 Nov 2012 12:52:44 -0500
In-Reply-To: <1352997261.18025.103.camel@gandalf.local.home>
References: <1352925457-15700-1-git-send-email-fweisbec@gmail.com>
	 <1352925457-15700-8-git-send-email-fweisbec@gmail.com>
	 <1352953617.18025.94.camel@gandalf.local.home>
	 <CAFTL4hzzhd5__VwR7N+VKpq1C27xHGgi4vj87drbcLghJ+Od5g@mail.gmail.com>
	 <1352997261.18025.103.camel@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we are in nohz and there's still irq_work to be done when the idle
task is about to go offline. Give a nasty warning.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-rt.git/kernel/irq_work.c
===================================================================
--- linux-rt.git.orig/kernel/irq_work.c
+++ linux-rt.git/kernel/irq_work.c
@@ -103,6 +103,9 @@ bool irq_work_needs_cpu(void)
 	if (llist_empty(this_list))
 		return false;
 
+	/* All work should have been flushed before going offline */
+	WARN_ON_ONCE(cpu_is_offline(smp_processor_id()));
+
 	return true;
 }
 



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781Ab1ISV0u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 17:26:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64682 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932581Ab1ISV0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 17:26:44 -0400
X-Authority-Analysis: v=1.1 cv=agqPq5NoKwAPC9P66H7dbYUCjxvmT73as08i4x3aqAA= c=1 sm=0 a=vhdKIqpQuCYA:10 a=iUONPdXu25QA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=NIgmlyQdXp35JIEuWdIA:9 a=EwDInnQkB1lwH7pLuqwA:7 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Message-Id: <20110919212640.343186687@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 19 Sep 2011 17:20:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Lameter <cl@linux.com>
Subject: [RFC][PATCH 1/5] x86: Remove const_udelay() caring about which cpu var it uses
References: <20110919212040.745370781@goodmis.org>
Content-Disposition: inline; filename=0001-x86-Remove-const_udelay-caring-about-which-cpu-var-i.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The __const_udelay() code originally used raw_smp_processor_id()
in its calculations for a delaying. Probably because if it were
to migrate, it would take much longer to do so than the requested
delay.

Switch from this_cpu_read() to __this_cpu_read() to document that
the read is racy and we do not care.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/lib/delay.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/lib/delay.c b/arch/x86/lib/delay.c
index fc45ba8..1b9bde5 100644
--- a/arch/x86/lib/delay.c
+++ b/arch/x86/lib/delay.c
@@ -121,7 +121,7 @@ inline void __const_udelay(unsigned long xloops)
 	asm("mull %%edx"
 		:"=d" (xloops), "=&a" (d0)
 		:"1" (xloops), "0"
-		(this_cpu_read(cpu_info.loops_per_jiffy) * (HZ/4)));
+		(__this_cpu_read(cpu_info.loops_per_jiffy) * (HZ/4)));
 
 	__delay(++xloops);
 }
-- 
1.7.5.4



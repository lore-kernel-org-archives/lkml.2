Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab1LNCw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 21:52:56 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:64584 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193Ab1LNCwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 21:52:53 -0500
X-Authority-Analysis: v=2.0 cv=HeWWv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=Uhj6tBLeQuQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=Z4Rwk6OoAAAA:8 a=WfulkdPnAAAA:8 a=meVymXHHAAAA:8 a=xMw-xWDpt8kuUQIESIkA:9 a=Mljc0igdFrOWSPI8JDkA:7 a=jEp0ucaQiEUA:10 a=jbrJJM5MRmoA:10 a=l29vjEC0CZ8A:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111214025251.679787228@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 13 Dec 2011 21:52:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: [RFC][PATCH 2/5 v2] x86: Document the NMI handler about not using paranoid_exit
References: <20111214025237.457632996@goodmis.org>
Content-Disposition: inline; filename=0002-x86-Document-the-NMI-handler-about-not-using-paranoi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Linus cleaned up the NMI handler but it still needs some comments to
explain why it uses save_paranoid but not paranoid_exit. Just to keep
others from adding that in the future, document why it's not used.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/entry_64.S |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 3819ea9..d1d5434 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1480,9 +1480,16 @@ END(error_exit)
 ENTRY(nmi)
 	INTR_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
-	pushq_cfi $-1
+	pushq_cfi $-1		/* ORIG_RAX: no syscall to restart */
 	subq $ORIG_RAX-R15, %rsp
 	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
+	/*
+	 * Use save_paranoid to handle SWAPGS, but no need to use paranoid_exit
+	 * as we should not be calling schedule in NMI context.
+	 * Even with normal interrupts enabled. An NMI should not be
+	 * setting NEED_RESCHED or anything that normal interrupts and
+	 * exceptions might do.
+	 */
 	call save_paranoid
 	DEFAULT_FRAME 0
 	/* paranoidentry do_nmi, 0; without TRACE_IRQS_OFF */
-- 
1.7.7.3



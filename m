Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab2F2PkT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 11:40:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31354 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932075Ab2F2PkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 11:40:14 -0400
X-Authority-Analysis: v=2.0 cv=IOWA+3TG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=dGFX5WHEKRYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=VwQbUJbxAAAA:8 a=6v5OQekSAAAA:8 a=-exyVoOIAAAA:8 a=6WMiQYZljNOIHUvWGLkA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=_Yg506RlYqQA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340984411.16702.127.camel@gandalf.stny.rr.com>
Subject: [PATCH] printk: Optimize if statement logic where newline exists
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Kay Sievers <kay@vrfy.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Wu Fengguang <fengguang.wu@intel.com>, Joe Perches <joe@perches.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Date: Fri, 29 Jun 2012 11:40:11 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In reviewing Kay's fix up patch: "printk: Have printk() never buffer its
data", I found two if statements that could be combined and optimized.

Put together the two 'cont.len && cont.owner == current' if statements
into a single one, and check if we need to call cont_add(). This also
removes the unneeded double cont_flush() calls.

Link: http://lkml.kernel.org/r/1340869133.876.10.camel@mop

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---

[ This patch is dependent on Kay's patch, referenced at the above Link ]

Index: linux-trace.git/kernel/printk.c
===================================================================
--- linux-trace.git.orig/kernel/printk.c
+++ linux-trace.git/kernel/printk.c
@@ -1474,15 +1474,14 @@ asmlinkage int vprintk_emit(int facility
 		bool stored = false;
 
 		/*
-		 * Flush the conflicting buffer. An earlier newline was missing,
-		 * or we race with a continuation line from an interrupt.
+		 * If an earlier newline was missing and it was the same task,
+		 * either merge it with the current buffer and flush, or if
+		 * there was a race with interrupts (prefix == true) then just
+		 * flush it out and store this line separately.
 		 */
-		if (cont.len && prefix && cont.owner == current)
-			cont_flush();
-
-		/* Merge with our buffer if possible; flush it in any case */
 		if (cont.len && cont.owner == current) {
-			stored = cont_add(facility, level, text, text_len);
+			if (!prefix)
+				stored = cont_add(facility, level, text, text_len);
 			cont_flush();
 		}
 



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab2EWI5A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 04:57:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19755 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab2EWI44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 04:56:56 -0400
X-Authority-Analysis: v=2.0 cv=ae7jbGUt c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=al8JDgEDVlLKsxrF0IgA:9 a=6APKsA9CD2tMW9uVrvIA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337763411.13348.140.camel@gandalf.stny.rr.com>
Subject: Re: NMI vs #PF clash
From: Steven Rostedt <rostedt@goodmis.org>
To: Brian Gerst <brgerst@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Wed, 23 May 2012 04:56:51 -0400
In-Reply-To: <CAMzpN2hWhcYBT0noFSc24e_fH-sVwK+Da97Byvge4tsF3_vRTQ@mail.gmail.com>
References: <4FBB8C40.6080304@redhat.com>
	 <1337693441.13348.36.camel@gandalf.stny.rr.com>
	 <4FBB986F.5030306@redhat.com>
	 <1337695780.13348.41.camel@gandalf.stny.rr.com>
	 <4FBBA094.3090703@redhat.com>
	 <1337696825.13348.44.camel@gandalf.stny.rr.com>
	 <CA+55aFwx3QjNB2ckQfsThhDn7=Bm1d=n0Ai8zawbpLKBKgugGg@mail.gmail.com>
	 <1337733575.13348.134.camel@gandalf.stny.rr.com>
	 <CAMzpN2hWhcYBT0noFSc24e_fH-sVwK+Da97Byvge4tsF3_vRTQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-22 at 21:26 -0400, Brian Gerst wrote:
> 
> You could save cr2 in a callee-saved register (like r12) instead of
> putting it on the stack.
> 
Much simpler!

-- Steve

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index f41b3b1..59bae47 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1725,10 +1725,30 @@ end_repeat_nmi:
 	 */
 	call save_paranoid
 	DEFAULT_FRAME 0
+
+	/*
+	 * Save off the CR2 register. If we take a page fault in the NMI then
+	 * it could corrupt the CR2 value. If the NMI preempts a page fault
+	 * handler before it was able to read the CR2 register, and then the
+	 * NMI itself takes a page fault, the page fault that was preempted
+	 * will read the information from the NMI page fault and not the
+	 * origin fault. Save it off and restore it if it changes.
+	 * Use the r12 callee-saved register.
+	 */
+	movq %cr2, %r12
+
 	/* paranoidentry do_nmi, 0; without TRACE_IRQS_OFF */
 	movq %rsp,%rdi
 	movq $-1,%rsi
 	call do_nmi
+
+	/* Did the NMI take a page fault? Restore cr2 if it did */
+	movq %cr2, %rcx
+	cmpq %rcx, %r12
+	je 1f
+	movq %r12, %cr2
+1:
+	
 	testl %ebx,%ebx				/* swapgs needed? */
 	jnz nmi_restore
 nmi_swapgs:



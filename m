Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933210Ab2EWIc0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 04:32:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9512 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756940Ab2EWIcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 04:32:23 -0400
X-Authority-Analysis: v=2.0 cv=ae7jbGUt c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=RWw2aZgjqmW2vuf4FN8A:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337761940.13348.138.camel@gandalf.stny.rr.com>
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
Date: Wed, 23 May 2012 04:32:20 -0400
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

> > @@ -1734,6 +1748,13 @@ end_repeat_nmi:
> >  nmi_swapgs:
> >        SWAPGS_UNSAFE_STACK
> >  nmi_restore:
> > +       /* Test if the cr2 reg changed */
> > +       movq ORIG_RAX-R15+(12*8)(%rsp), %rdx
> > +       movq %cr2, %rcx
> > +       cmp %rdx, %rcx
> > +       je 1f
> > +       movq %rdx, %cr2
> > +1:
> >        RESTORE_ALL 8
> >        /* Clear the NMI executing stack variable */
> >        movq $0, 10*8(%rsp)
> 
> You could save cr2 in a callee-saved register (like r12) instead of
> putting it on the stack.
> 

You know, I thought about that but decided against it. My rational was
that I wanted the store of the cr2 in the first NMI where it would do it
again if it had to do a repeated NMI. At first I thought that a repeated
NMI would corrupt the cr2, but that is not the case as the cr2 would
have been restored before repeating the NMI.

I guess I also wanted to limit the number of reads of the cr2 as well.
But as repeated NMIs is such a seldom case (requires a fault and then
another NMI to come in), that this optimization is practically useless.

I agree, it would be better to just use one of the non-clobbered regs.


Thanks, I'll try that out and this should make the patch much simpler.


-- Steve



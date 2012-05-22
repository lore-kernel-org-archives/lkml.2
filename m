Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483Ab2EVOJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 10:09:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13996 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757224Ab2EVOJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 10:09:42 -0400
X-Authority-Analysis: v=2.0 cv=ae7jbGUt c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=Bum8_tTBk6x6Qg0GSOwA:9 a=U5KCuCZG6v3dvqQlKuEA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337695780.13348.41.camel@gandalf.stny.rr.com>
Subject: Re: NMI vs #PF clash
From: Steven Rostedt <rostedt@goodmis.org>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Turner <pjt@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Tue, 22 May 2012 10:09:40 -0400
In-Reply-To: <4FBB986F.5030306@redhat.com>
References: <4FBB8C40.6080304@redhat.com>
	 <1337693441.13348.36.camel@gandalf.stny.rr.com>
	 <4FBB986F.5030306@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-22 at 16:45 +0300, Avi Kivity wrote:

> I thought the whole thing was started by someone adding a
> vmalloc_sync_all() to prevent this scenario, and Linus wanting to
> fix NMI instead.  But maybe I'm confusing two threads.

No, you are rightfully confused.

That was the case that started the thread and created the eventual code
that we have. But Mathieu Desnoyers brought this up not to just solve
the page fault issue for perf, but also to handle page faults for his
own ring buffer and as a nice side effect, fixing breakpoints, which is
critical to be able to modify text without the use of stop machine.

But the answer was to modify perf to not need to use vmalloc'd data from
NMI context. Or at least never do it where a page fault could happen.

The motivation for me to allow faults in NMI context was for
breakpoints, as it was required to remove stop machine from the function
tracer.

> 
> > Now if we want to handle page faults from NMI context, we could do some
> > tricks to have the NMI detect that it interrupted a page fault before it
> > read the cr2 and in that case, save off the cr2 register, and restore it
> > before returning.
> > 
> > Or we could just have the NMI always restore the cr2 register.
> 
> IMO that's best.

OK, I can whip up a patch, but I wont push that in till 3.6.

-- Steve



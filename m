Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab2EVNaq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 09:30:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28827 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab2EVNao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 09:30:44 -0400
X-Authority-Analysis: v=2.0 cv=ae7jbGUt c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=zCH6jB1A-232fqpeKNgA:9 a=8ZgFc_Zevw9XLIMe6rYA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337693441.13348.36.camel@gandalf.stny.rr.com>
Subject: Re: NMI vs #PF clash
From: Steven Rostedt <rostedt@goodmis.org>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Turner <pjt@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Tue, 22 May 2012 09:30:41 -0400
In-Reply-To: <4FBB8C40.6080304@redhat.com>
References: <4FBB8C40.6080304@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-22 at 15:53 +0300, Avi Kivity wrote:
> The recent changes to NMI allow exceptions to take place in NMI
> handlers, but I think that a #PF (say, due to access to vmalloc space)
> is still problematic.  Consider the sequence
> 
>   #PF  (cr2 set by processor)
>     NMI
>       ...
>       #PF (cr2 clobbered)
>         do_page_fault()
>         IRET
>       ...
>       IRET
>     do_page_fault()
>       address = read_cr2()

This is still problematic. But the "allow faults in NMI" wasn't written
for page faults, although they wont totally crash the system like they
use to. If a NMI triggers during a page fault routine before the reading
of the cr2, and it takes a page fault, then yes, this will corrupt the
cr2 and cause unpredictable results (not good)

That said, we still should not be having page faults in NMI. The fault
handling was to allow breakpoints in the NMI code, which should not be a
problem here. There is code to handle nested breakpoints because of
NMIs.

The only time I found #PF useful in NMIs was for debugging. Having a
stack dump of all tasks (sysrq-t) when the NMI watchdog detects a
deadlock can be very useful. But stack traces can trigger page faults,
and before this fault handling in NMI code went in, I could not get a
full task state dump from NMI context. This was due to the first page
fault happening by a stack dump would enable NMIs, and as the state of
all tasks dumping out to the serial port took a long time, another NMI
would come in and corrupt the NMI stack leading to a system hang or
triple fault reboot. Never letting the task dump to finish.

This code now alleviates that problem.

>  
> The last line reads the overwritten cr2 value.
> 
> I vaguely remember some discussion about this back in the day, but I
> can't find anything in the code to save/restore cr2 in the NMI handler. 
> Did I miss it?  Or perhaps the page fault handler ignores the incorrect
> cr2 and IRETs, to fault back immediately?
> 

Now if we want to handle page faults from NMI context, we could do some
tricks to have the NMI detect that it interrupted a page fault before it
read the cr2 and in that case, save off the cr2 register, and restore it
before returning.

Or we could just have the NMI always restore the cr2 register.

-- Steve



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758886Ab2EVOue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 10:50:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24643 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758809Ab2EVOub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 10:50:31 -0400
X-Authority-Analysis: v=2.0 cv=OMylLFmB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=jpRvb8xjGnMehMG-nJgA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337698229.13348.46.camel@gandalf.stny.rr.com>
Subject: Re: NMI vs #PF clash
From: Steven Rostedt <rostedt@goodmis.org>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Turner <pjt@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Tue, 22 May 2012 10:50:29 -0400
In-Reply-To: <4FBBA4A2.2070501@redhat.com>
References: <4FBB8C40.6080304@redhat.com>
	   <1337693441.13348.36.camel@gandalf.stny.rr.com>
	   <4FBB986F.5030306@redhat.com>
	  <1337695780.13348.41.camel@gandalf.stny.rr.com>
	  <4FBBA094.3090703@redhat.com>
	 <1337696825.13348.44.camel@gandalf.stny.rr.com>
	 <4FBBA4A2.2070501@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-22 at 17:37 +0300, Avi Kivity wrote:
> > 
> > 
> > Is reading it fast? Then we could do a two reads and only write when
> > needed.
> 
> The upside is 70 cycles on one machine, see d3edefc0035669.

Thanks

> 
> 
> > 
> > Something like this pseudo assembly
> >  
> > 	mov cr2, rax
> > 	push rax
> > 
> > 	call do_nmi
> > 
> > 	pop rax
> > 	mov cr2, rbx
> > 	cmp rax, rbx
> > 	be skip
> > 	mov rax, cr2
> > skip:
> > 
> 
> 
> Yes, provided no exceptions can happen at those points.

Yes, exceptions can only happen in the do_nmi area. There should not be
any breakpoints or page faults in the assembly code of the NMI handler.

Now another NMI may come in at any point here, but it will detect that
it is nested and return without doing anything (but telling this NMI to
repeat itself).

-- Steve



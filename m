Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328Ab1EZJbY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 05:31:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41657 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757229Ab1EZJbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 05:31:21 -0400
Date: Thu, 26 May 2011 11:30:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: James Morris <jmorris@namei.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <kees.cook@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Will Drewry <wad@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        gnatapov@redhat.com, Chris Wright <chrisw@sous-sol.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 3/5] v2 seccomp_filters: Enable ftrace-based system call
 filtering
Message-ID: <20110526093040.GB19536@elte.hu>
References: <1306254027.18455.47.camel@twins>
 <20110524195435.GC27634@elte.hu>
 <alpine.LFD.2.02.1105242239230.3078@ionos>
 <20110525150153.GE29179@elte.hu>
 <alpine.LFD.2.02.1105251836030.3078@ionos>
 <20110525180100.GY19633@outflux.net>
 <BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com>
 <alpine.LRH.2.00.1105261034200.29690@tundra.namei.org>
 <20110526082451.GB26775@elte.hu>
 <4DDE1419.3000708@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DDE1419.3000708@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> > Note that tools/kvm/ would probably like to implement its own 
> > object manager model as well in addition to access method 
> > restrictions: by being virtual hardware it deals with many 
> > resources and object hierarchies that are simply not known to the 
> > host OS's LSM.
> >
> > Unlike Qemu tools/kvm/ has a design that is very fit for MAC 
> > concepts: it uses separate helper threads for separate resources 
> > (this could in many cases even be changed to be separate 
> > processes which only share access to the guest RAM image) - while 
> > Qemu is in most parts a state machine, so in tools/kvm/ we can 
> > realistically have a good object manager and keep an exploit in a 
> > networking interface driver from being able to access disk driver 
> > state.
> 
> You mean each thread will have a different security context?  I 
> don't see the point.  All threads share all of memory so it would 
> be trivial for one thread to exploit another and gain all of its 
> privileges.

You are missing the geniality of the tools/kvm/ thread pool! :-)

It could be switched to a worker *process* model rather easily. Guest 
RAM and (a limited amount of) global resources would be shared via 
mmap(SHARED), but otherwise each worker process would have its own 
stack, its own subsystem-specific state, etc.

Exploiting other device domains via the shared guest RAM image is not 
possible, we treat guest RAM as untrusted data already.

Devices, like real hardware devices, are functionally pretty 
independent from each other, so this security model is rather natural 
and makes a lot of sense.

> A multi process model works better but it has significant memory 
> and performance overhead.

Not in Linux :-) We context-switch between processes almost as 
quickly as we do between threads. With modern tagged TLB hardware 
it's even faster.

> (well the memory overhead is much smaller when using transparent 
> huge pages, but these only work for anonymous memory).

The biggest amount of RAM is the guest RAM image - but if that is 
mmap(SHARED) and mapped using hugepages then the pte overhead from a 
process model is largely mitigated.

Once we have a process model then isolation and MAC between devices 
becomes a very real possibility: exploit via one network interface 
cannot break into a disk interface.

Maybe even the isolation and per device access control of 
*same-class* devices from each other is possible: with careful 
implementation of the subsystem shared data structures. (which isnt 
much really)

Thanks,

	Ingo

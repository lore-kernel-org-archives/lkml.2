Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339Ab1EZK5d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 06:57:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756173Ab1EZK5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 06:57:31 -0400
Message-ID: <4DDE31D6.4070209@redhat.com>
Date: Thu, 26 May 2011 13:56:22 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: James Morris <jmorris@namei.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <kees.cook@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Will Drewry <wad@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        gnatapov@redhat.com, Chris Wright <chrisw@sous-sol.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 3/5] v2 seccomp_filters: Enable ftrace-based system call
 filtering
References: <1306254027.18455.47.camel@twins> <20110524195435.GC27634@elte.hu> <alpine.LFD.2.02.1105242239230.3078@ionos> <20110525150153.GE29179@elte.hu> <alpine.LFD.2.02.1105251836030.3078@ionos> <20110525180100.GY19633@outflux.net> <BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com> <alpine.LRH.2.00.1105261034200.29690@tundra.namei.org> <20110526082451.GB26775@elte.hu> <4DDE1419.3000708@redhat.com> <20110526093040.GB19536@elte.hu>
In-Reply-To: <20110526093040.GB19536@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2011 12:30 PM, Ingo Molnar wrote:
> * Avi Kivity<avi@redhat.com>  wrote:
>
> >  >  Note that tools/kvm/ would probably like to implement its own
> >  >  object manager model as well in addition to access method
> >  >  restrictions: by being virtual hardware it deals with many
> >  >  resources and object hierarchies that are simply not known to the
> >  >  host OS's LSM.
> >  >
> >  >  Unlike Qemu tools/kvm/ has a design that is very fit for MAC
> >  >  concepts: it uses separate helper threads for separate resources
> >  >  (this could in many cases even be changed to be separate
> >  >  processes which only share access to the guest RAM image) - while
> >  >  Qemu is in most parts a state machine, so in tools/kvm/ we can
> >  >  realistically have a good object manager and keep an exploit in a
> >  >  networking interface driver from being able to access disk driver
> >  >  state.
> >
> >  You mean each thread will have a different security context?  I
> >  don't see the point.  All threads share all of memory so it would
> >  be trivial for one thread to exploit another and gain all of its
> >  privileges.
>
> You are missing the geniality of the tools/kvm/ thread pool! :-)

I'm sure the thread pool is very general, but the hardware we're 
modelling is not.

> It could be switched to a worker *process* model rather easily. Guest
> RAM and (a limited amount of) global resources would be shared via
> mmap(SHARED), but otherwise each worker process would have its own
> stack, its own subsystem-specific state, etc.

Suppose a guest reconfigures a device's MSI page, and suppose that's 
handled by the device's process.  Now it's not sufficient to update some 
global state, you have to go and tell the host kernel about it.  With 
good privilege separation the device process would not be permitted to 
do that; now it has to pass a message to a process that is.

Same thing applies for BARs, reset signals, live migration, etc.

> Exploiting other device domains via the shared guest RAM image is not
> possible, we treat guest RAM as untrusted data already.

Right.

> Devices, like real hardware devices, are functionally pretty
> independent from each other, so this security model is rather natural
> and makes a lot of sense.

When just pushing packets, you are right.  However setup/configuration 
is hardly clean.

Consider a CD-ROM eject, for example.  Now it can't be done by a simple 
callback.

> >  A multi process model works better but it has significant memory
> >  and performance overhead.
>
> Not in Linux :-) We context-switch between processes almost as
> quickly as we do between threads. With modern tagged TLB hardware
> it's even faster.

Once we get PCID in, yes.  There's still the message passing overhead, 
and unnecessary context switches.  In a threaded model you can choose 
whether to switch threads or not, in a process model you cannot.

> >  (well the memory overhead is much smaller when using transparent
> >  huge pages, but these only work for anonymous memory).
>
> The biggest amount of RAM is the guest RAM image - but if that is
> mmap(SHARED) and mapped using hugepages then the pte overhead from a
> process model is largely mitigated.

That doesn't work with memory hotplug.

> Once we have a process model then isolation and MAC between devices
> becomes a very real possibility: exploit via one network interface
> cannot break into a disk interface.

Yes, certainly.

> Maybe even the isolation and per device access control of
> *same-class* devices from each other is possible: with careful
> implementation of the subsystem shared data structures. (which isnt
> much really)

Right, hardly at all in fact.  The problem comes from the side-band 
issues like reset, interrupts, hotplug, and whatnot.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.


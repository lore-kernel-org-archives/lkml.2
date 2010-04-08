Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab0DHDd4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 23:33:56 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:38465 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297Ab0DHDdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 23:33:53 -0400
Message-ID: <4BBD4E9C.2040500@us.ibm.com>
Date: Wed, 07 Apr 2010 20:33:48 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: john cooper <john.cooper@third-harmonic.com>
CC: Avi Kivity <avi@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Eric Dumazet <eric.dumazet@gmail.com>,
       "Peter W. Morreale" <pmorreale@novell.com>,
       Rik van Riel <riel@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Chris Mason <chris.mason@oracle.com>,
       Chris Wright <chrisw@sous-sol.org>,
       john cooper <john.cooper@redhat.com>
Subject: Re: [PATCH V2 0/6][RFC] futex: FUTEX_LOCK with optional adaptive
 spinning
References: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com> <4BBA5305.7010002@redhat.com> <4BBA5C00.4090703@us.ibm.com> <4BBA6279.20802@redhat.com> <4BBA6B6F.7040201@us.ibm.com> <4BBB36FA.4020008@redhat.com> <1270560931.1595.342.camel@laptop> <20100406145128.6324ac9a@lxorguk.ukuu.org.uk> <4BBB531A.4070500@us.ibm.com> <4BBB5C0D.8050602@redhat.com> <alpine.LFD.2.00.1004061809080.32352@localhost.localdomain> <4BBB5F52.4000403@redhat.com> <4BBC23C2.4080100@third-harmonic.com>
In-Reply-To: <4BBC23C2.4080100@third-harmonic.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

john cooper wrote:
> Avi Kivity wrote:
>> On 04/06/2010 07:14 PM, Thomas Gleixner wrote:
>>>> IMO the best solution is to spin in userspace while the lock holder is
>>>> running, fall into the kernel when it is scheduled out.
>>>>      
>>> That's just not realistic as user space has no idea whether the lock
>>> holder is running or not and when it's scheduled out without a syscall :)
>>>    
>> The kernel could easily expose this information by writing into the
>> thread's TLS area.
>>
>> So:
>>
>> - the kernel maintains a current_cpu field in a thread's tls
>> - lock() atomically writes a pointer to the current thread's current_cpu
>> when acquiring
>> - the kernel writes an invalid value to current_cpu when switching out
>> - a contended lock() retrieves the current_cpu pointer, and spins as
>> long as it is a valid cpu
> 
> There are certainly details to sort through in the packaging
> of the mechanism but conceptually that should do the job.
> So here the application has chosen a blocking lock as being
> the optimal synchronization operation and we're detecting a
> scenario where we can factor out the aggregate overhead of two
> context switch operations.

I didn't intend to change the behavior of an existing blocking call with 
adaptive spinning if that is what you are getting at here. Initially 
there would be a new futex op, something like FUTEX_LOCK_ADAPTIVE or 
maybe just FUTEX_WAIT_ADAPTIVE. Applications can use this directly to 
implement adaptive spinlocks. Ideally glibc would make use of this via 
either the existing adaptive spinning NP API or via a new one. Before we 
even go there, we need to see if this can provide a real benefit.

> 
> There is also the case where the application requires a
> polled lock with the rational being the assumed lock
> hold/wait time is substantially less than the above context
> switch overhead.

Polled lock == userspace spinlock?

> But here we're otherwise completely
> open to indiscriminate scheduling preemption even though
> we may be holding a userland lock.

That's true with any userland lock.

> The adaptive mutex above is an optimization beyond what
> is normally expected for the associated model.  The preemption
> of a polled lock OTOH can easily inflict latency several orders
> of magnitude beyond what is expected in that model.  Two use
> cases exist here which IMO aren't related except for the latter
> unintentionally degenerating into the former.

Again, my intention is not to replace any existing functionality, so 
applications would have to explicitly request this behavior.

If I'm missing your point, please elaborate.

Thanks,

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team

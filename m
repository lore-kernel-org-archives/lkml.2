Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086Ab0DGGbS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 02:31:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55232 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756970Ab0DGGbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 02:31:12 -0400
Message-ID: <4BBC23C2.4080100@third-harmonic.com>
Date: Wed, 07 Apr 2010 02:18:42 -0400
From: john cooper <john.cooper@third-harmonic.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Darren Hart <dvhltc@us.ibm.com>,
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
References: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com> <4BBA5305.7010002@redhat.com> <4BBA5C00.4090703@us.ibm.com> <4BBA6279.20802@redhat.com> <4BBA6B6F.7040201@us.ibm.com> <4BBB36FA.4020008@redhat.com> <1270560931.1595.342.camel@laptop> <20100406145128.6324ac9a@lxorguk.ukuu.org.uk> <4BBB531A.4070500@us.ibm.com> <4BBB5C0D.8050602@redhat.com> <alpine.LFD.2.00.1004061809080.32352@localhost.localdomain> <4BBB5F52.4000403@redhat.com>
In-Reply-To: <4BBB5F52.4000403@redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> On 04/06/2010 07:14 PM, Thomas Gleixner wrote:
>>
>>> IMO the best solution is to spin in userspace while the lock holder is
>>> running, fall into the kernel when it is scheduled out.
>>>      
>> That's just not realistic as user space has no idea whether the lock
>> holder is running or not and when it's scheduled out without a syscall :)
>>    
> 
> The kernel could easily expose this information by writing into the
> thread's TLS area.
> 
> So:
> 
> - the kernel maintains a current_cpu field in a thread's tls
> - lock() atomically writes a pointer to the current thread's current_cpu
> when acquiring
> - the kernel writes an invalid value to current_cpu when switching out
> - a contended lock() retrieves the current_cpu pointer, and spins as
> long as it is a valid cpu

There are certainly details to sort through in the packaging
of the mechanism but conceptually that should do the job.
So here the application has chosen a blocking lock as being
the optimal synchronization operation and we're detecting a
scenario where we can factor out the aggregate overhead of two
context switch operations.

There is also the case where the application requires a
polled lock with the rational being the assumed lock
hold/wait time is substantially less than the above context
switch overhead.  But here we're otherwise completely
open to indiscriminate scheduling preemption even though
we may be holding a userland lock.

The adaptive mutex above is an optimization beyond what
is normally expected for the associated model.  The preemption
of a polled lock OTOH can easily inflict latency several orders
of magnitude beyond what is expected in that model.  Two use
cases exist here which IMO aren't related except for the latter
unintentionally degenerating into the former.

-john

-- 
john.cooper@third-harmonic.com

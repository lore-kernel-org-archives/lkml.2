Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757788Ab0DFXgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 19:36:49 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:50693 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757742Ab0DFXgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 19:36:45 -0400
Message-ID: <4BBBC586.7000506@us.ibm.com>
Date: Tue, 06 Apr 2010 16:36:38 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ulrich Drepper <drepper@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "Peter W. Morreale" <pmorreale@novell.com>,
       Rik van Riel <riel@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Chris Mason <chris.mason@oracle.com>,
       John Cooper <john.cooper@third-harmonic.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH V2 0/6][RFC] futex: FUTEX_LOCK with optional adaptive
 spinning
References: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com> <4BBA5C00.4090703@us.ibm.com> <4BBA6279.20802@redhat.com> <4BBA6B6F.7040201@us.ibm.com> <4BBB36FA.4020008@redhat.com> <1270560931.1595.342.camel@laptop> <20100406145128.6324ac9a@lxorguk.ukuu.org.uk>  <4BBB531A.4070500@us.ibm.com> <20100406174459.60088461@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.1004062024560.32352@localhost.localdomain> <y2qa36005b51004061302t53bccf60v2cc152e7c64b20ca@mail.gmail.com> <alpine.LFD.2.00.1004070047100.32352@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1004070047100.32352@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Tue, 6 Apr 2010, Ulrich Drepper wrote:
> 
>> On Tue, Apr 6, 2010 at 12:31, Thomas Gleixner <tglx@linutronix.de> wrote:
>>> We need to figure out a more efficient way to
>>> do the spinning in the kernel where we have all the necessary
>>> information already.
>> Really?  The owner information isn't in general available in the
>> kernel.  Futex operation doesn't require the value used to be the PID
>> (or negative of the PID).  That is a dramatic limitation of the
>> usefulness of futexes.
> 
> I know that you can do any weird stuff with the futex value, but I
> don't see the "dramatic" limitation. Care to elaborate ?
> 
>> At userlevel there is access to other fields of the data structure
>> which can contain the owner information.
>>
>> I would like to see the method using a per-thread pinned page and an
>> update of a memory location on scheduling.  For benchmarking at least.
> 
> The per thread pinned page would be unconditional, right ?
> 
> I agree that benchmarking would be interesting, but OTOH I fear that
> we open up a huge can of worms with exposing scheduler details and the
> related necessary syscalls like sys_yield_to: User space thread
> management/scheduling comes to my mind and I hope we agree that we do
> not want to revisit that.
> 
>>  I agree that a sys_yield_to() syscall would be at the very least
>> useful as well.  But it's useful for other things already.
> 
> Useful for what ?
> 
> What are the exact semantics of such a syscall ? 
> 
> How does that fit into the various scheduling constraints ?


I believe this comes back to the discussions of a directed yield. The 
idea being that a thread yields its remaining timeslice to a thread of 
it's choosing - usually because the target thread holds a resource the 
yielding thread needs access to. This makes the yield more explicit so 
the yielding thread is more likely to get some benefit out of yielding.

I believe the arguments would be either a TID or a thread group - 
however that is specified. I believe the KVM guys would like to see 
something like this as well - which might be the "other things" referred 
to above.

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team

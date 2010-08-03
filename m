Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab0HCAJz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 20:09:55 -0400
Received: from mail.lang.hm ([64.81.33.126]:56526 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754225Ab0HCAJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 20:09:49 -0400
Date: Mon, 2 Aug 2010 17:08:30 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Arjan van de Ven <arjan@infradead.org>, "Ted Ts'o" <tytso@mit.edu>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
In-Reply-To: <20100802140933.GB2405@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.1008021627290.29820@asgard.lang.hm>
References: <20100731175841.GA9367@linux.vnet.ibm.com> <20100731215214.2543c07e@infradead.org> <20100801054816.GI2470@linux.vnet.ibm.com> <20100731230101.7cc1d8c7@infradead.org> <20100801191228.GL2470@linux.vnet.ibm.com> <20100801204026.GH31324@thunk.org>
 <20100802030304.GU2470@linux.vnet.ibm.com> <20100801210548.23f77ff6@infradead.org> <alpine.DEB.2.00.1008012153300.25170@asgard.lang.hm> <20100802140933.GB2405@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Aug 2010, Paul E. McKenney wrote:

> On Sun, Aug 01, 2010 at 10:06:34PM -0700, david@lang.hm wrote:
>> On Sun, 1 Aug 2010, Arjan van de Ven wrote:
>>
>>> I'm a little worried that this whole "I need to block suspend" is
>>> temporary. Yes today there is silicon from ARM and Intel where suspend
>>> is a heavy operation, yet at the same time it's not all THAT heavy
>>> anymore.... at least on the Intel side it's good enough to use pretty
>>> much all the time (when the screen is off for now, but that's a memory
>>> controller issue more than anything else). I'm pretty sure the ARM guys
>>> will not be far behind.
>>
>> remember that this 'block suspend' is really 'block overriding the
>> fact that there are still runable processes and suspending anyway"
>>
>> having it labeled as 'suspend blocker' or even 'wakelock' makes it
>> sound as if it blocks any attempt to suspend, and I'm not sure
>> that's what's really intended. Itsounds like the normal syspend
>> process would continue to work, just this 'ignore if these other
>> apps are busy' mode of operation would not work.
>>
>> which makes me wonder, would it be possible to tell the normal idle
>> detection mechanism to ignore specific processes when deciding if it
>> should suspend or not? how about only considering processes in one
>> cgroup when deciding to suspend and ignoring all others?
>
> Why not flesh this out and compare it to the draft requirements?
> (I expect to be sending another version by end of day Pacific Time.)
>
> The biggest issue I see right off-hand is that a straightforward
> implementation of your idea would require moving processes from one
> cgroup to another when acquiring or releasing a suspend blocker, which
> from what I understand would be way to heavyweight.  On the other hand,
> if acquiring and releasing a suspend blocker does not move the process
> from one cgroup to another, then you need something very like the
> suspend-blocker mechanism to handle those processes that are permitted
> to acquire suspend blockers, and which are thus not a member of the
> cgroup in question.
>
> That said, I did see some hint from the Android guys that it -might-
> be possible to leverage cgroups in the way that you suggest might help
> save power during times when suspend was blocked but (for example) the
> screen was turned off.  The idea would be to freeze the cgroup whenever
> the screen blanked, even if suspend was blocked.  The biggest issue
> here is that any process that can hold a suspend blocker must never to
> an unconditional wait on any process in this cgroup.  Seems to me that
> this should be possible in theory, but the devil would be in the details.
>
> If I am misunderstanding your proposal, please enlighten me!

you are close, but I think what I'm proposing is actually simpler 
(assuming that the scheduler can be configured to generate the appropriate 
stats)

my thought was not to move applications between cgroups as they 
aquire/release the suspend-block lock, bur rather to say that any 
application that you would trust to get the suspend-block lock should be 
in cgroup A while all other applications are in cgroup B

when you are deciding if the system shoudl go to sleep because it is idle, 
ignore the activity of all applications in cgroup B

if cgroup A applications are busy, the system is not idle and should not 
suspend.

this requires that the applications in cgroup A actually go idle as 
opposed to simply releaseing the suspend-block lock, but it would mean 
that there are no application changes required for to move a system from 
the status "even if it's busy, go ahead ans suspend" to "this application 
is important, don't suspend if it's got work to do", it would just be 
classifying the application in one cgroup or the other.

This assumes that an application that you would trust to hold the 
suspend-block lock is going to be well behaved (if it isn't, how can you 
trust it to not grab the lock inappropriatly?)

David Lang

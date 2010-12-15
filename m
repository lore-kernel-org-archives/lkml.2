Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457Ab0LOOaV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 09:30:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754433Ab0LOOaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 09:30:20 -0500
Subject: Re: likely() vs. unlikely()
From: Steven Rostedt <srostedt@redhat.com>
To: Daniel Kopko <dk_fedorabugs@yahoo.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <294021.5068.qm@web120709.mail.ne1.yahoo.com>
References: <294021.5068.qm@web120709.mail.ne1.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Wed, 15 Dec 2010 09:30:18 -0500
Message-ID: <1292423418.2733.220.camel@fedora>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-14 at 22:42 -0800, Daniel Kopko wrote:
> Hello, Mr. Rostedt, LKML,
> 
> I've noticed the patch series by Steven Rostedt.  I am a bit of a lurker here, 
> but I noticed something that I could perhaps contribute to.  Mr. Rostedt has 
> done some great work deducing exactly whether or not these clauses meet their 
> stated presumptions of "likeliness".  However, I think there may be some cases 
> where accurately codifying branch biases based on literal likeliness might 
> produce worse performance overall.  An example:
> 
> if(X)
>     some_expensive_code();   //takes 500 ms

Nothing in the kernel proper should ever take 500ms.

> else
>     some_very_cheap_code();  //takes 100 us
> 
> Now, let's say X is true 90% of the time.  The literal encoding of that would be 
> "if(likely(X))".  However, it may make much more sense to encode it *wrongly* 
> for the sake of cheapening the already cheap code, as the delay of the branch 
> misprediction may be readily "absorbed" into the more expensive code.  In which 
> case, even with X being likely, we may want to encode it as "if(unlikely(X))".  
> (Also, to avoid obscuring things, please keep in mind that the bodies of the two 
> halves of the branch above need not actually be function calls.)

Doesn't matter if they are function calls or not.

> 
> I think that this type of thing may be most noticeable around any branches where 
> there is a fastpath that may be run if ideal conditions are met, but which are 
> met less than 50% of the time.

Then that's not a fastpath. A definition of a fastpath has nothing to do
with the amount of time that path takes. We call something a fastpath
when it is hit 90% of the time and hit often. We want that to be as fast
as possible, even if it takes 500ms compared to the 10% of 100us. If you
look at the big picture (the entire running system) adding a missed
branch prediction(*) to 90% of a single branch is going to be larger
than having it hit the branch that is only 10% taken.

Also note, I honestly believe that most of the branch annotations should
be removed unless they are correct 90% of the time. But I do not remove
them blindly, so it takes a bit of work for each and every change.

>   In such cases, the likely()/unlikely() may be 
> used "wrongly" to cause the branch misprediction to occur in the 
> already-high-latency (some_expensive_function()) case, and lower latencies in 
> the already-low-latency (some_very_cheap_function()) case.  This would lead to 
> lower attainable latencies overall (by at least the cost of a branch miss which 
> would otherwise have been spent in the fast code), and further encourage coding 
> to meet the ideal conditions of the fastpath.

Which is not what we call a fast path.

> 
> So, several points:
> 1)  Please let me know if any of the above is outright wrong.

Already stated ;-)

> 2)  I don't know if any such cases occur in the likely()/unlikely() patch 
> series.  A place where it obviously DOESN'T occur would be:
> http://marc.info/?l=linux-kernel&m=129229014528892&w=2
> A place where I thought it MAY occur:
> http://marc.info/?l=linux-kernel&m=129228728125413&w=2
> 3)  If there is overall agreement on the above, then I would also suggest that 
> perhaps some additional macro names would be appropriate for the 
> __builtin_expect() use (for cases where we want __builtin_expect(!!(X),1), but 
> for which it isn't truly "likely", and for cases where we want 
> __builtin_expect((X), 0), but for which it isn't truly "unlikely").  These would 
> be parallel to likely()/unlikely() and have the same implementations, but 
> different titles, to better document the intent of the code where they're used.  
> Names maybe slow_branch_path() and fast_branch_path()? 
> slow_branch()/fast_branch()?
> 4) I'm very sorry if this winds up ill-formatted.  I have a yahoo webmail 
> client.  Open to suggestions for different free email providers on this front.

Lets look at a very short path that is done all over the place:

	if (unlikely(mypointer == NULL))
		return;

This is done all over the place. And it fits your definition of a fast
path. Because all it does is end the function. Where if we were to
continue, the path could be much longer. But if this function is called
1000 times a second, we want all branches to be as little of a hindrance
as possible.

-- Steve

(*) the likely() and unlike()'s do not really do anything with branch
prediction of most archs. Some archs allow for a flag that can be added
to a branch condition in assembly to what you expect it will take. Intel
does not. But it does affect the way gcc orders code, which causes
instruction cache misses. And there is a bit of default predictions that
we want. A compare and branch is default to not branch.

	cmp x
	be  1:
	[...]
1:	

The cpu will be pulling in the instructions from memory and placing it
into the instruction cache. Branch prediction helps when the CPU sees
the branch and if there's already a prediction made, it can pull in the
location of the destination of that branch, if it has not done so
already.

Lets say the cache size is 128 bytes, and that branch was pulled in at
the beginning of the cache line. We then have 124 bytes of instructions
after it even if that branch is expected to be taken.

If we have the following code:

	if (x)
		r = 1;
	a = 2;

If we consider likely(x) then we will have this:

	cmp x
	be  1: ;; if (x == 0) branch
	ld r, 1
1:	ld a, 2

But if x is unlikely 90% of the time, we don't want to even bother
jumping around it. 10% of the time it's ok to just make it slower.

	cmp x
	bne 2: ;; if (x != 0) branch
1:	ld a, 1
[...]

2:	ld r, 1
	jmp 1b

We just removed a line of code from our cache line that we don't want in
there in the first place. A lot of error code is like this. We test for
errors all the time, but we do not expect that error code to ever be
taken, so we want it out of our cache lines as much as possible.



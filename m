Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab0LQGH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 01:07:57 -0500
Received: from web120713.mail.ne1.yahoo.com ([98.138.82.220]:20634 "HELO
	web120713.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750942Ab0LQGH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 01:07:56 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:References:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=yPJTDznV1BO8+5Vids8bXkmdRYefFM2nnQopgORHbRRQtBurvzaqb9LjIhlWwE9Wwz/CjNRHuql0ig6JlhyED7ppLUkkgOfRv3PeXHoei1q6h9V8BJLu1QuxX0zwBD47TxlT4uPSSSlLdxL/9eGAK8oBzzRbh54eU/MlAVVz/dk=;
Message-ID: <37836.43110.qm@web120713.mail.ne1.yahoo.com>
X-YMail-OSG: SDS1sy8VM1mihptbOpRQVE_4VNSpqFPjbWbuQMDUd6Xjsio
 bJa0VUPifipdaQEKyPdP9_DOJq7N..DbtGZ0zJVJ2ONZ0xm5K7.6QDwmQ0xy
 foAU.PnscNpHMYZLAX_eYKt80XOk2fSAeML9QZAyB0NCgFvTKiPtBOD26nw_
 hZ09Zo0iE0d2jx4wDMhHkNSOM79BM4iSzrEr1wUshLS8CN8QAlsenCAWOiIU
 I1hhM1gzXJ.yhbbU7QA--
X-Mailer: YahooMailRC/553 YahooMailWebService/0.8.107.285259
References: <294021.5068.qm@web120709.mail.ne1.yahoo.com> <1292423418.2733.220.camel@fedora>
Date: Thu, 16 Dec 2010 22:07:54 -0800 (PST)
From: Daniel Kopko <dk_fedorabugs@yahoo.com>
Subject: Re: likely() vs. unlikely()
To: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1292423418.2733.220.camel@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks for the thorough response.  I think maybe I didn't make my point well 
enough the first time, so please see below.



----- Original Message ----
> From: Steven Rostedt <srostedt@redhat.com>
> To: Daniel Kopko <dk_fedorabugs@yahoo.com>
> Cc: linux-kernel@vger.kernel.org
> Sent: Wed, December 15, 2010 9:30:18 AM
> Subject: Re: likely() vs. unlikely()
> 
> On Tue, 2010-12-14 at 22:42 -0800, Daniel Kopko wrote:
> > Hello, Mr.  Rostedt, LKML,
> > 
> > I've noticed the patch series by Steven  Rostedt.  I am a bit of a lurker 
>here, 
>
> > but I noticed something  that I could perhaps contribute to.  Mr. Rostedt has 
>
> > done some  great work deducing exactly whether or not these clauses meet 
>their 
>
> >  stated presumptions of "likeliness".  However, I think there may be some  
>cases 
>
> > where accurately codifying branch biases based on literal  likeliness might 
> > produce worse performance overall.  An  example:
> > 
> > if(X)
> >      some_expensive_code();   //takes 500 ms
> 
> Nothing in the kernel proper  should ever take 500ms.

Agreed.  I was just trying to make the example extreme enough to try and 
illustrate the point.

> 
> > else
> >      some_very_cheap_code();  //takes 100 us
> > 
> > Now, let's say X  is true 90% of the time.  The literal encoding of that 
>would be 
>
> >  "if(likely(X))".  However, it may make much more sense to encode it  
>*wrongly* 
>
> > for the sake of cheapening the already cheap code, as the  delay of the 
>branch 
>
> > misprediction may be readily "absorbed" into the  more expensive code.  In 
>which 
>
> > case, even with X being likely, we  may want to encode it as 
>"if(unlikely(X))".  
>
> > (Also, to avoid  obscuring things, please keep in mind that the bodies of the 
>two 
>
> > halves  of the branch above need not actually be function calls.)
> 
> Doesn't matter  if they are function calls or not.

Right, that's what I was trying to say.

> 
> > 
> > I think that this type  of thing may be most noticeable around any branches 
>where 
>
> > there is a  fastpath that may be run if ideal conditions are met, but which 
>are 
>
> > met  less than 50% of the time.
> 
> Then that's not a fastpath. A definition of a  fastpath has nothing to do
> with the amount of time that path takes. We call  something a fastpath
> when it is hit 90% of the time and hit often. We want  that to be as fast
> as possible, even if it takes 500ms compared to the 10% of  100us. If you
> look at the big picture (the entire running system) adding a  missed
> branch prediction(*) to 90% of a single branch is going to be  larger
> than having it hit the branch that is only 10% taken.

OK, perhaps I'm misusing "fastpath" here.  I just mean the path where latency is 
more of a concern.  Also, I agree with your last point here, but I have a couple 
of more concrete counter-examples below for which I don't think the last 
statement holds true.

> 
> Also  note, I honestly believe that most of the branch annotations should
> be  removed unless they are correct 90% of the time. But I do not remove
> them  blindly, so it takes a bit of work for each and every change.
> 
> >    In such cases, the likely()/unlikely() may be 
> > used "wrongly" to cause  the branch misprediction to occur in the 
> > already-high-latency  (some_expensive_function()) case, and lower latencies 
>in 
>
> > the  already-low-latency (some_very_cheap_function()) case.  This would lead 
>to 
>
> > lower attainable latencies overall (by at least the cost of a branch  miss 
>which 
>
> > would otherwise have been spent in the fast code), and  further encourage 
>coding 
>
> > to meet the ideal conditions of the  fastpath.
> 
> Which is not what we call a fast path.

Please let that be the "path-of-greatest-latency-concern", then.

> 
> > 
> > So,  several points:
> > 1)  Please let me know if any of the above is  outright wrong.
> 
> Already stated ;-)
> 
> > 2)  I don't know if  any such cases occur in the likely()/unlikely() patch 
> > series.  A  place where it obviously DOESN'T occur would be:
> > http://marc.info/?l=linux-kernel&m=129229014528892&w=2
> > A place  where I thought it MAY occur:
> > http://marc.info/?l=linux-kernel&m=129228728125413&w=2
> > 3)  If  there is overall agreement on the above, then I would also suggest 
>that 
>
> >  perhaps some additional macro names would be appropriate for the 
> >  __builtin_expect() use (for cases where we want __builtin_expect(!!(X),1), 
>but 
>
> > for which it isn't truly "likely", and for cases where we want 
> >  __builtin_expect((X), 0), but for which it isn't truly "unlikely").  These  
>would 
>
> > be parallel to likely()/unlikely() and have the same  implementations, but 
> > different titles, to better document the intent of  the code where they're 
>used.  
>
> > Names maybe slow_branch_path() and  fast_branch_path()? 
> > slow_branch()/fast_branch()?
> > 4) I'm very  sorry if this winds up ill-formatted.  I have a yahoo webmail 
> >  client.  Open to suggestions for different free email providers on this  
>front.
> 
> Lets look at a very short path that is done all over the  place:
> 
>     if (unlikely(mypointer ==  NULL))
>         return;
> 
> This is done all  over the place. And it fits your definition of a fast
> path. Because all it  does is end the function. Where if we were to
> continue, the path could be  much longer. But if this function is called
> 1000 times a second, we want all  branches to be as little of a hindrance
> as possible.

Yes, agreed, this isn't a case where I'd suggest an inversion at all.

> 
> --  Steve
> 
<clipped explanation of gcc's handling of likely()/unlikely()>
(This was informative, thank you.)


OK, so here are two examples that perhaps better illustrate my point:

1)  A spinlock.  This one is not one from the kernel, just one implemented in 
userspace:

#define CACHE_PAUSE() __asm__ __volatile__ ("pause" : :) 
#define SPIN_ACQUIRE_LOCK(x) do { while(unlikely(__sync_lock_test_and_set(&(x), 
1))) { CACHE_PAUSE(); } } while(0)

Let's assume, for sake of argument, that this lock is known to be highly 
contended.  (And let's ignore any better alternatives to spinlocks for this 
case, this is just illustrative.)  Due to the high contention, the 
__sync_lock_test_and_set() call will in the vast majority of cases return 1, 
indicating the lock was already taken.  However, even though the result is 
*likely 1*, we do not want to use likely() here, but instead unlikely().  The 
reason being is that the penalty of the incorrect unlikely() usage occurs on a 
path for which we have nothing better to do anyway, we're just going to pause 
for a moment waiting for the lock to become free.  However, in the smaller 
fraction of time in which the lock is available, we want to suffer as little 
penalty as possible.  It seems that it is correct here to invert/abuse 
unlikely() to cause the penalty to be paid in say 90% of cases (which are just 
going to wait anyway), in order to not pay the penalty at all in the 10% of 
cases where work can actually progress.

2) Suppose there is message processing system which has two classifications of 
messages:  LOWEST_LATENCY, NORMAL.  When a message is submitted into this 
system, it can be submitted with a flag/enum which indicates which type of 
message it is.  The logic then goes something like this:

if(message_type == LOWEST_LATENCY)
{
     do { sendmsg(msg); } while(errno == EAGAIN);
}
else
        enqueue_message_for_subsequent_send(msg);

Setting all messages to LOWEST_LATENCY would actually probably degrade 
performance, but let's say roughly 5-10% are set with this flag, and the rest of 
the messages are NORMAL.  I would argue that even though it is actually 
*unlikely* for message_type to be LOWEST_LATENCY, it would be appropriate to use 
likely(message_type == LOWEST_LATENCY) here.  The reason being that we want to 
optimize for latency for things requesting LOWEST_LATENCY, and permit the 
latency degradation which is thereby caused to messages which are indifferent to 
latency (NORMAL transmissions).  It doesn't even matter whether or not our 
average latency across all messages has increased, what matters is that for the 
messages marked as sensitive to latency, average latency has decreased.

Now, I am aware that as latency increases elsewhere in the system (the NORMAL 
handling), that this may bog down the processing loop and ultimately impact the 
LOWEST_LATENCY handling as well.  However, this is *not necessarily* the case.  
Nothing says that the processing loop must be handling so many messages that the 
likely()/unlikely() inversion costs so much that the loop must slow down.  In 
fact, the processing loop may have enough intervals where it has nothing to do 
that it can readily absorb the additional latency of the NORMAL handling in the 
time it would have otherwise spent waiting.  And indeed, for some applications, 
this is the case.


These are the only two cases which I've personally come across.  In these cases, 
I tested performance with and without the inversions, and was satisfied by the 
improvements that the inversions gave me.  I hadn't ever heard anyone discuss 
something like this, so I figured I should air it on LKML.  If there's yet a 
flaw in my reasoning, I'm sure you (or some other expert) will let me know.  :)  
Even if there isn't, I do not know enough to say if any situations like the 
above even occur in the kernel code to where an inversion would be appropriate.


Thanks for your time,

Daniel Kopko


      

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759552Ab0FPUUF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 16:20:05 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:28818 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759214Ab0FPUUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 16:20:00 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6015"; a="44504918"
Subject: Re: Overview of concurrency managed workqueue
From: Daniel Walker <dwalker@codeaurora.org>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
In-Reply-To: <4C192B94.9020601@kernel.org>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
	 <4C17C598.7070303@kernel.org>
	 <1276631037.6432.9.camel@c-dwalke-linux.qualcomm.com>
	 <4C18BF40.40607@kernel.org> <1276694825.9309.12.camel@m0nster>
	 <4C18D1FD.9060804@kernel.org> <1276695665.9309.17.camel@m0nster>
	 <4C18D574.1040903@kernel.org> <1276697146.9309.27.camel@m0nster>
	 <4C18DC69.10704@kernel.org> <1276698880.9309.44.camel@m0nster>
	 <4C18E4B7.5040702@kernel.org> <1276701074.9309.60.camel@m0nster>
	 <4C18F2B8.9060805@kernel.org> <1276705838.9309.94.camel@m0nster>
	 <4C1901E9.2080907@kernel.org> <1276712547.9309.172.camel@m0nster>
	 <4C191BE9.1060400@kernel.org> <1276716999.9309.208.camel@m0nster>
	 <4C192B94.9020601@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Jun 2010 13:19:59 -0700
Message-ID: <1276719599.9309.243.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-16 at 21:52 +0200, Tejun Heo wrote:
> On 06/16/2010 09:36 PM, Daniel Walker wrote:
> >> Yeah, and it would wait that by flushing the work, right?  If the
> >> waiting part is using completion or some other event notification,
> >> you'll just need to update the driver so that the kernel can determine
> >> who's waiting for what so that it can bump the waited one's priority.
> >> Otherwise, the problem can't be solved.
> > 
> > This has nothing to do with flushing .. You keep bringing this back into
> > the kernel for some reason, we're talking about entirely userspace
> > threads ..
> 
> Yeah, sure, how would tose userspace threads wait for the event?  And
> how would the kernel be able to honor latency requirements not knowing
> the dependency?

Let say a userspace thread calls into the kernel via some method syscall
for instance, and while executing the syscall there is a mutex,
semaphore, completion or any other blocking mechanism. Then the
userspace thread blocks.

> >> Well, it's somewhat related,
> >>
> >> * Don't depend on works or workqueues for RT stuff.  It's not designed
> >>   for that.
> > 
> > Too bad .. We have a posix OS, and posix has RT priorities .. You can't
> > control what priorities user give those threads.
> 
> So, you're not talking about the real RT w/ timing guarantees?  So no
> priority inheritance or whatever?  Gees, then any lock can give you
> unexpected latencies.

I'm talking about normal threads with RT priorities ..

> >> * If you really wanna solve the problem, please go ahead and _solve_
> >>   it yourself.  (read the rest of the mail)
> > 
> > Your causing the problem, why should I solve it? My solution would just
> > be to NAK your patches.
> 
> I don't have any problem with that.  I would be almost happy to get
> your NACK.

Oh yeah? why is that?

> >> Because the workqueue might just go away in the next release or other
> >> unrelated work which shouldn't get high priority might be scheduled
> >> there.  Maybe the name of the workqueue changes or it gets merged with
> >> another workqueue.  Maybe it gets split.  Maybe the system suspends
> >> and resumes and nobody knows that workers die and are created again
> >> over those events.  Maybe the backend implementaiton changes so that
> >> workers are pooled.
> > 
> > Changing the priorities is not fragile, your saying that ones ability to
> > adapt to changes in the kernel makes it hard to know what the workqueue
> > is actually doing.. Ok, that's fair.. This doesn't make it less useful
> > since people can discover thread dependencies without looking at the
> > kernel source.
> 
> Sigh, so, yeah, the whole thing is fragile.  When did I say nice(1) is
> fragile?

Like I said that type of "fragile" doesn't really matter that much,
since you can just discover any new thread dependencies on a new kernel.
Anyone running a RT thread would likely do that anyway, since even
syscall are "fragile" in this way.

> >> Gee, I don't know.  These are pretty evident problems to me.  Aren't
> >> they obvious?
> > 
> > Your just looking at the problem through your specific use case glasses
> > without imagining what else people could be doing with the kernel.
> > 
> > How often do you think workqueues change names anyway? It's not all that
> > often.
> 
> So does most symbols in kernel.  What you're saying applies almost
> word to word to grepping /proc/kallsyms.  Can't you see it?

No .. I don't follow your grepping thing .. Symbols in the kernel change
pretty often, and generally aren't exposed to userspace in a way that
one can readily see them, like say using "top" or "ps" for
example . /proc/kallsyms is unknown man, I vague knew what that was till
you mentioned it, yet _everyone_ has see "kblockd".

> >> And you're assuming grepping /proc/kallsyms is not useful?  It's
> >> useful in its adhoc unsupported hacky way.
> > 
> > Well lets say it's useful and 100k people use that method in it's
> > "hacky" way .. When does it become a feature then?
> 
> If 100k people actually want it, solve the damn problem instead of
> holding onto the bandaid which doesn't work anyway.

Again with the mass assumptions ..

> > So your totally unwilling to change your patches to correct this
> > problem? Is that what your getting at? Agree or disagree isn't relevant
> > it's a real problem or I wouldn't have brought it up.
> >
> > btw, I already gave you a relatively easy way to correct this.
> 
> I'm sorry but the problem you brought up seems bogus to me.  So does
> the solution.  In debugfs?  Is that debug feature or is it an API?  Do
> we keep the workqueues stable then?  Do we make announcements when
> moving one work from one workqueue to another?  If it's a debug
> feature, why are we talking like this any way?

I was suggesting it as a debug feature, but if people screamed loud
enough then you would have to make it an API .. You need to have feature
parity with current mainline, which you don't have..

I dont't know what you mean by "keep the workqueues stable" , you mean
the naming? No you don't .. You don't make announcements either..

I suggested it as a debug feature yes, and your the one arguing with
_me_ ..

Daniel


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932507Ab0FPQzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 12:55:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:53923 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755444Ab0FPQzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 12:55:46 -0400
Message-ID: <4C1901E9.2080907@kernel.org>
Date: Wed, 16 Jun 2010 18:55:05 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Daniel Walker <dwalker@codeaurora.org>
CC: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Subject: Re: Overview of concurrency managed workqueue
References: <1276551467-21246-1-git-send-email-tj@kernel.org>	 <4C17C598.7070303@kernel.org>	 <1276631037.6432.9.camel@c-dwalke-linux.qualcomm.com>	 <4C18BF40.40607@kernel.org> <1276694825.9309.12.camel@m0nster>	 <4C18D1FD.9060804@kernel.org> <1276695665.9309.17.camel@m0nster>	 <4C18D574.1040903@kernel.org> <1276697146.9309.27.camel@m0nster>	 <4C18DC69.10704@kernel.org> <1276698880.9309.44.camel@m0nster>	 <4C18E4B7.5040702@kernel.org> <1276701074.9309.60.camel@m0nster>	 <4C18F2B8.9060805@kernel.org> <1276705838.9309.94.camel@m0nster>
In-Reply-To: <1276705838.9309.94.camel@m0nster>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Jun 2010 16:55:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/16/2010 06:30 PM, Daniel Walker wrote:
>> I don't know.  I suppose a high priority thread is trying to flush a
>> work item or workqueue thus causing priority inversion, right?  Maybe
>> we can add high priority emergency worker which gets triggered through
>> priority inversion detection or maybe the code shouldn't be flushing
>> in the critical path anyway.
> 
> It's not a flushing situation .. The high priority thread is a userspace
> thread so it , AFAIK, can't flush any workqueues.

So, how is it stalling?  How would I be able to tell anything about
the situation when all you're saying is doing this and that voodoo
thing made it go away for me?

>>>> Peter brought up the work priority issue previously and Linus was
>>>> pretty clear on the issue.  They're in the discussiosn for the first
>>>> or second take.
>>>
>>> Send us a link to this discussion.
>>
>>   http://thread.gmane.org/gmane.linux.kernel/929641
> 
> I didn't see anything in there related to this discussion.

It was about using wq for cpu intensive / RT stuff.  Linus said,

  So stop arguing about irrelevancies. Nobody uses workqueues for RT
  or for CPU-intensive crap. It's not what they were designed for, or
  used for.

>> Maybe it's me not understanding something but I don't really think
>> exposing workqueue priorities to userland is a good solution at all.
> 
> Why not? They currently are to no known ill effects (none that I know
> of).

Because...

* fragile as hell

* depends heavily on unrelated implementation details

* has extremely limited test coverage

* doesn't help progressing mainline at all

>>> You have no idea how many people are doing this, or in what
>>> circumstances .. Please don't make mass speculation over things you
>>> clearly are not aware of.
>>
>> Well, then please stop insisting it to be a feature to keep.  It's not
>> a feature.
> 
> It may not have been a feature in the past, but it's used as a feature
> now.. So it is a feature even tho you don't want it to be.

That's exactly like grepping /proc/kallsyms to determine some feature
and claiming it's a feature whether the kernel intends it or not.
Sure, use it all you want.  Just don't expect it to be there on the
next release.

>> Oh yeah, if you're not insisting fixed mapping, then I don't have any
>> problem with that.  As for what to do for priority inversions
>> involving workqueues, I don't have any concrete idea (it was not in
>> the mainline, so I didn't have to solve it) but one way would be
>> reserving/creating temporary high priority workers and use them to
>> process work items which the high priority thread is blocked on.
> 
> But it is in the mainline, that's why we're talking right now.

The problem is in the mainline.  Solution is not.  It's not a solved
problem.  It's also a pretty niche problem.

> What I was thinking is that you could have a debugfs interface which
> would list off what workqueues you system is processing and give the
> user the ability to pull one or more of those workqueues into individual
> threads for processing, just like it currently is. That way I can
> prioritize the work items with out you having to give priorities through
> your entire system.

Why would the user want to bother with all that?  Shouldn't the kernel
just do the right thing?  IIRC, people are working on priority
inheriting userland mutexes.  If your problem case can't be solved by
that, please try to fix it in proper way not through some random knobs
that nobody really can understand.

> The alternative is that you would give each work item a settable
> priority and your whole system would have to honor that, which would be
> a little like re-creating the scheduler.
>
>> But, really, without knowing details of those inversion cases, it
>> would be pretty difficult to design something which fits.  All that I
>> can say is having shared worker pool isn't exclusive with solving the
>> problem.
> 
> The cases are all in the mainline kernel, you just have to look at the
> code in a different way to understand them ..

Yeah, sure, all the problems in the world which haven't been solved
yet are there.  The _solution_ isn't there and solutions are what
people conserve when trying to improve things.

> If I have a userspace thread at a high priority and I'm making calls
> into the kernel, some of those call inevitably will put work items
> onto workqueues, right? I'm sure you can think of 100's of ways in
> which this could happen .. At that point my thread depends on the
> workqueue thread, since the workqueue thread is doing processing for
> which I've , in some way, requested from userspace.

You're basically saying that "I don't know how those inheritance
inversions are happening but if I turn these magic knobs they seem to
go away so I want those magic knobs".  Maybe the RT part of the code
shouldn't be depending on that many random things to begin with?  And
if there are actually things which are necessary, it's better idea to
solve it properly through identifying problem points and properly
inheriting priority instead of turning knobs until it somehow works?

If you wanna work on such things, be my guest.  I'll be happy to work
with you but please stop talking about setting priorities of
workqueues from userland.  That's just nuts.

Thanks.

-- 
tejun

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596Ab0FPSqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 14:46:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:36020 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932119Ab0FPSql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 14:46:41 -0400
Message-ID: <4C191BE9.1060400@kernel.org>
Date: Wed, 16 Jun 2010 20:46:01 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Daniel Walker <dwalker@codeaurora.org>
CC: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Subject: Re: Overview of concurrency managed workqueue
References: <1276551467-21246-1-git-send-email-tj@kernel.org>	 <4C17C598.7070303@kernel.org>	 <1276631037.6432.9.camel@c-dwalke-linux.qualcomm.com>	 <4C18BF40.40607@kernel.org> <1276694825.9309.12.camel@m0nster>	 <4C18D1FD.9060804@kernel.org> <1276695665.9309.17.camel@m0nster>	 <4C18D574.1040903@kernel.org> <1276697146.9309.27.camel@m0nster>	 <4C18DC69.10704@kernel.org> <1276698880.9309.44.camel@m0nster>	 <4C18E4B7.5040702@kernel.org> <1276701074.9309.60.camel@m0nster>	 <4C18F2B8.9060805@kernel.org> <1276705838.9309.94.camel@m0nster>	 <4C1901E9.2080907@kernel.org> <1276712547.9309.172.camel@m0nster>
In-Reply-To: <1276712547.9309.172.camel@m0nster>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Jun 2010 18:46:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/16/2010 08:22 PM, Daniel Walker wrote:
> There's so many different ways that threads can interact .. Can you
> imagine a thread waiting in userspace for something to complete in the
> kernel, that does actually happen pretty often ;) .
> 
> I was just now randomly trolling through drivers and found this one,
> drivers/spi/amba-pl022.c ..
> 
> It processes some data in the interrupt, but sometimes it offloads the
> processing to a workqueue from the interrupt (or tasklet) .. If for
> example I'm a userspace thread waiting for that data then I would have
> to wait for that workqueue to complete (and it's priority plays a major
> roll in when it completes).

Yeah, and it would wait that by flushing the work, right?  If the
waiting part is using completion or some other event notification,
you'll just need to update the driver so that the kernel can determine
who's waiting for what so that it can bump the waited one's priority.
Otherwise, the problem can't be solved.

>> It was about using wq for cpu intensive / RT stuff.  Linus said,
>>
>>   So stop arguing about irrelevancies. Nobody uses workqueues for RT
>>   or for CPU-intensive crap. It's not what they were designed for, or
>>   used for.
> 
> Which is not relevant to this discussion .. We're talking about
> re-prioritizing the workqueue threads. We're _not_ talking about
> workqueues designed specifically for real time purposes.

Well, it's somewhat related,

* Don't depend on works or workqueues for RT stuff.  It's not designed
  for that.

* If you really wanna solve the problem, please go ahead and _solve_
  it yourself.  (read the rest of the mail)

>> * fragile as hell
> 
> Changing the thread priorities shouldn't be fragile , if it is right now
> then the threads are broken .. Can you exaplin in which cases you've
> seen it being fragile?

Because the workqueue might just go away in the next release or other
unrelated work which shouldn't get high priority might be scheduled
there.  Maybe the name of the workqueue changes or it gets merged with
another workqueue.  Maybe it gets split.  Maybe the system suspends
and resumes and nobody knows that workers die and are created again
over those events.  Maybe the backend implementaiton changes so that
workers are pooled.

>> * depends heavily on unrelated implementation details
> 
> I have no idea what this means.

(continued) because all those are implementation details which are NOT
PART OF THE INTERFACE in any way.

>> * has extremely limited test coverage
> 
> Simple, just write tests.

Yeah, and test your few configurations with those,

>> * doesn't help progressing mainline at all
> 
> progressing where?

(continued) and other people experiencing the same problem will have
to do about the same thing and won't know whether there nice + pidof
will work with the next kernel upgrade.

Gee, I don't know.  These are pretty evident problems to me.  Aren't
they obvious?

>> That's exactly like grepping /proc/kallsyms to determine some feature
>> and claiming it's a feature whether the kernel intends it or not.
>> Sure, use it all you want.  Just don't expect it to be there on the
>> next release.
> 
> Your assume there's no value in changing the priorities which is wrong.
> Your assuming way to much . Changing the priorities is useful.

And you're assuming grepping /proc/kallsyms is not useful?  It's
useful in its adhoc unsupported hacky way.

>> You're basically saying that "I don't know how those inheritance
>> inversions are happening but if I turn these magic knobs they seem to
>> go away so I want those magic knobs".  Maybe the RT part of the code
>> shouldn't be depending on that many random things to begin with?  And
>> if there are actually things which are necessary, it's better idea to
>> solve it properly through identifying problem points and properly
>> inheriting priority instead of turning knobs until it somehow works?
> 
> I think your mis-interpreting me .. If I write a thread (in userspace)
> which I put into RT priorities I don't have a lot of control over what
> dependencies the kernel may put on my thread. Think from a users
> perspective not from a kernel developers perspective.
>
> I'm not saying changing a workqueue priority would be a final solution,
> but it is a way to prioritize things immediately and has worked in prior
> kernels up till your patches.

* Make the kernel or driver or whatever you use in the RT path track
  priority is the right thing to do.

* I'm very sorry I'm breaking your hacky workaround but seriously
  that's another problem to solve.  Let's talk about the problem
  itself instead of your hacky workaround.  (I think for most cases
  not using workqueue in RT path would be the right thing to do.)

>> If you wanna work on such things, be my guest.  I'll be happy to work
>> with you but please stop talking about setting priorities of
>> workqueues from userland.  That's just nuts.
> 
> You just don't understand it.. How can you expect your patches to go
> into mainline with this attitude toward usages you just don't
> understand?

I'll keep your doubts on mind but I'm really understanding what you're
saying.  You just don't understand that I understand and disagree. :-)

Thanks.

-- 
tejun

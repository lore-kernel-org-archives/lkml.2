Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759505Ab0FPTyo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 15:54:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:43589 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759494Ab0FPTyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 15:54:36 -0400
Message-ID: <4C192B94.9020601@kernel.org>
Date: Wed, 16 Jun 2010 21:52:52 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Daniel Walker <dwalker@codeaurora.org>
CC: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Subject: Re: Overview of concurrency managed workqueue
References: <1276551467-21246-1-git-send-email-tj@kernel.org>	 <4C17C598.7070303@kernel.org>	 <1276631037.6432.9.camel@c-dwalke-linux.qualcomm.com>	 <4C18BF40.40607@kernel.org> <1276694825.9309.12.camel@m0nster>	 <4C18D1FD.9060804@kernel.org> <1276695665.9309.17.camel@m0nster>	 <4C18D574.1040903@kernel.org> <1276697146.9309.27.camel@m0nster>	 <4C18DC69.10704@kernel.org> <1276698880.9309.44.camel@m0nster>	 <4C18E4B7.5040702@kernel.org> <1276701074.9309.60.camel@m0nster>	 <4C18F2B8.9060805@kernel.org> <1276705838.9309.94.camel@m0nster>	 <4C1901E9.2080907@kernel.org> <1276712547.9309.172.camel@m0nster>	 <4C191BE9.1060400@kernel.org> <1276716999.9309.208.camel@m0nster>
In-Reply-To: <1276716999.9309.208.camel@m0nster>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Jun 2010 19:52:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2010 09:36 PM, Daniel Walker wrote:
>> Yeah, and it would wait that by flushing the work, right?  If the
>> waiting part is using completion or some other event notification,
>> you'll just need to update the driver so that the kernel can determine
>> who's waiting for what so that it can bump the waited one's priority.
>> Otherwise, the problem can't be solved.
> 
> This has nothing to do with flushing .. You keep bringing this back into
> the kernel for some reason, we're talking about entirely userspace
> threads ..

Yeah, sure, how would tose userspace threads wait for the event?  And
how would the kernel be able to honor latency requirements not knowing
the dependency?

>> Well, it's somewhat related,
>>
>> * Don't depend on works or workqueues for RT stuff.  It's not designed
>>   for that.
> 
> Too bad .. We have a posix OS, and posix has RT priorities .. You can't
> control what priorities user give those threads.

So, you're not talking about the real RT w/ timing guarantees?  So no
priority inheritance or whatever?  Gees, then any lock can give you
unexpected latencies.

>> * If you really wanna solve the problem, please go ahead and _solve_
>>   it yourself.  (read the rest of the mail)
> 
> Your causing the problem, why should I solve it? My solution would just
> be to NAK your patches.

I don't have any problem with that.  I would be almost happy to get
your NACK.

>> Because the workqueue might just go away in the next release or other
>> unrelated work which shouldn't get high priority might be scheduled
>> there.  Maybe the name of the workqueue changes or it gets merged with
>> another workqueue.  Maybe it gets split.  Maybe the system suspends
>> and resumes and nobody knows that workers die and are created again
>> over those events.  Maybe the backend implementaiton changes so that
>> workers are pooled.
> 
> Changing the priorities is not fragile, your saying that ones ability to
> adapt to changes in the kernel makes it hard to know what the workqueue
> is actually doing.. Ok, that's fair.. This doesn't make it less useful
> since people can discover thread dependencies without looking at the
> kernel source.

Sigh, so, yeah, the whole thing is fragile.  When did I say nice(1) is
fragile?

>>>> * depends heavily on unrelated implementation details
>>>
>>> I have no idea what this means.
>>
>> (continued) because all those are implementation details which are NOT
>> PART OF THE INTERFACE in any way.
> 
> yet they are part of the interface like it or not. How could you use
> threads and think thread priorities are not part of the interface.
> 
> In your new system how do you currently prevent thread priorities on
> your new workqueue threads from getting modified? Surely you must be
> doing that since you don't want those priorities to change right?

No, I don't.  If the root wanna shoot its feet, it can.  On the same
tune, you can lower the priority of the migration thread to your own
peril.

>> Gee, I don't know.  These are pretty evident problems to me.  Aren't
>> they obvious?
> 
> Your just looking at the problem through your specific use case glasses
> without imagining what else people could be doing with the kernel.
> 
> How often do you think workqueues change names anyway? It's not all that
> often.

So does most symbols in kernel.  What you're saying applies almost
word to word to grepping /proc/kallsyms.  Can't you see it?

>> And you're assuming grepping /proc/kallsyms is not useful?  It's
>> useful in its adhoc unsupported hacky way.
> 
> Well lets say it's useful and 100k people use that method in it's
> "hacky" way .. When does it become a feature then?

If 100k people actually want it, solve the damn problem instead of
holding onto the bandaid which doesn't work anyway.

> So your totally unwilling to change your patches to correct this
> problem? Is that what your getting at? Agree or disagree isn't relevant
> it's a real problem or I wouldn't have brought it up.
>
> btw, I already gave you a relatively easy way to correct this.

I'm sorry but the problem you brought up seems bogus to me.  So does
the solution.  In debugfs?  Is that debug feature or is it an API?  Do
we keep the workqueues stable then?  Do we make announcements when
moving one work from one workqueue to another?  If it's a debug
feature, why are we talking like this any way?

Thanks.

-- 
tejun

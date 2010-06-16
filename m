Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759124Ab0FPPvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 11:51:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:53281 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730Ab0FPPvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 11:51:52 -0400
Message-ID: <4C18F2B8.9060805@kernel.org>
Date: Wed, 16 Jun 2010 17:50:16 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Daniel Walker <dwalker@codeaurora.org>
CC: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Subject: Re: Overview of concurrency managed workqueue
References: <1276551467-21246-1-git-send-email-tj@kernel.org>	 <4C17C598.7070303@kernel.org>	 <1276631037.6432.9.camel@c-dwalke-linux.qualcomm.com>	 <4C18BF40.40607@kernel.org> <1276694825.9309.12.camel@m0nster>	 <4C18D1FD.9060804@kernel.org> <1276695665.9309.17.camel@m0nster>	 <4C18D574.1040903@kernel.org> <1276697146.9309.27.camel@m0nster>	 <4C18DC69.10704@kernel.org> <1276698880.9309.44.camel@m0nster>	 <4C18E4B7.5040702@kernel.org> <1276701074.9309.60.camel@m0nster>
In-Reply-To: <1276701074.9309.60.camel@m0nster>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Jun 2010 15:50:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/16/2010 05:11 PM, Daniel Walker wrote:
>> If you find that some work item is causing priority inversion, you
>> need to fix the problem instead of working around in adhoc way which
>> won't be useful to anyone else, so, no, it doesn't sound like a useful
>> use case.
> 
> How do I fix the problem then? Without doing what I've already
> suggested.

I don't know.  I suppose a high priority thread is trying to flush a
work item or workqueue thus causing priority inversion, right?  Maybe
we can add high priority emergency worker which gets triggered through
priority inversion detection or maybe the code shouldn't be flushing
in the critical path anyway.

>> Peter brought up the work priority issue previously and Linus was
>> pretty clear on the issue.  They're in the discussiosn for the first
>> or second take.
> 
> Send us a link to this discussion.

  http://thread.gmane.org/gmane.linux.kernel/929641

>>> Your completely wrong .. Look at the example I gave above .. Bottom line
>>> is that your removing currently useful functionality, which is bad.. You
>>> can say it's not useful, but again you also say you don't "have much
>>> idea" regarding the cases where this is actually important.
>>
>> I said that I didn't have much idea about RT work priority thing, not
>> setting priority on wq workers for adhoc workaround for whatever.
>> IIRC, the RT work priority thing Peter was talking about was a
>> different thing.  Sure, more complex workqueue implementation would
>> complicate implementing work priorities, but if necessary maybe we can
>> grow different classes of worker pools.
> 
> Ok .. So what would these different classes look like then ? Is that
> something I could prioritize from userspace perhaps ?

Maybe it's me not understanding something but I don't really think
exposing workqueue priorities to userland is a good solution at all.

>>> Could you please just entertain the idea that maybe someone somewhere
>>> might want to give priorities to the work items inside your system.
>>
>> If that's necessary, do it properly.  Give *work* priorities or at
>> least give explicit priorities to workqueues.  That's a completely
>> different thing from insisting fixed workqueue to kthread mapping so
>> that three people on the whole planet can set priority on those
>> kthreads not even knowing what the hell they do.
> 
> You have no idea how many people are doing this, or in what
> circumstances .. Please don't make mass speculation over things you
> clearly are not aware of.

Well, then please stop insisting it to be a feature to keep.  It's not
a feature.

> I'm not insisting any fixed mapping, you need to open you mind to
> _possibilities_ .. How can the work items be given priorities _inside
> your system_! Can you give an interface in which people can set a
> priority to a give type of work item, then maybe you system honors those
> priorities in _some way_ ..
> 
> In fact, I'm only asking that you consider it, ponder it..

Oh yeah, if you're not insisting fixed mapping, then I don't have any
problem with that.  As for what to do for priority inversions
involving workqueues, I don't have any concrete idea (it was not in
the mainline, so I didn't have to solve it) but one way would be
reserving/creating temporary high priority workers and use them to
process work items which the high priority thread is blocked on.

But, really, without knowing details of those inversion cases, it
would be pretty difficult to design something which fits.  All that I
can say is having shared worker pool isn't exclusive with solving the
problem.

>>> I mean consider the RT workqueue that you removed, why in the world
>>> would we even have that if giving workqueues special priorities was
>>> a bad thing (or not useful).
>>
>> Because stop_machine wnated to use wq as a frontend for threads which
>> I converted to cpu_stop and which actually proves my point not yours,
>> sorry.
> 
> I'm not sure your proving much here, other than you thought it was
> better to use another method.

Eh well, it depends on the view point I guess.  :-P

Thanks.

-- 
tejun

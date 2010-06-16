Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085Ab0FPMXm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 08:23:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:54239 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402Ab0FPMXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 08:23:40 -0400
Message-ID: <4C18C223.4060306@kernel.org>
Date: Wed, 16 Jun 2010 14:22:59 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Florian Mickler <florian@mickler.org>
CC: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Subject: Re: Overview of concurrency managed workqueue
References: <1276551467-21246-1-git-send-email-tj@kernel.org>	<4C17C598.7070303@kernel.org> <20100616085547.77f9169e@schatten.dmk.lab>
In-Reply-To: <20100616085547.77f9169e@schatten.dmk.lab>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Jun 2010 12:23:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/16/2010 08:55 AM, Florian Mickler wrote:
>> So, here's the overview I wrote up today.  If anything needs more
>> clarification, just ask.  Thanks.
> 
> Nice writeup! I think it is sufficient already and I probably wouldn't
> bother, but here are a little comments if you want to polish it up...
> 
> Also, feel free to ignore :)
> 
> As a genereal rule, every abbreviation should be written out at least
> once and if you are going to abbreviate it from then on, the
> abbreviation goes in parenthesis after that. That helps the reader a
> lot.

Ah... all the fond memories of technical writing class are coming back
to me. :-)

> here you can then already use "wq". That makes it shorter, and if you
> use it consistently the reader doesn't wonder if wq and worqueue are
> different things. 
> 
>>
>> There are two types of workqueues, single and multi threaded.  MT wq
> 
> ... multi threaded (MT). MT wq keeps a bound ...
> 
>> keeps a bound thread for each online CPU, while ST wq uses single
> 
> ... while single threaded (ST) wq uses single ...

Updated.

>> Frustratingly, although MT wqs end up spending a lot of resources, the
>> level of concurrency provided is unsatisfactory.  The concurrency
>> limitation is common to both ST and MT wqs although it's less severe
> 
> I don't know what the english rules for plural of abbreviated word. But
> I would probably just drop the plural s and let the reader add it when
> he decodes the abbreviation. (ie replace wqs with wq) Or introduce it
> properly: "... workqueues (wqs) ... ", Or don't abbreviate it in the
> plural.

Dropped all the 's'es after abbrs.

>> cmwq extends workqueue with focus on the following goals.
> 
> first mentioning of cmwq as an abbreviation is not nice for the reader. 
> Better: 
> 	Concurrency managed wq (cmwq) ... goals:
> 	Concurrency managed workqueue (cmwq) ... goals:

Updated.

>> * Workqueue is already very widely used.  Maintain compatibility with
>>   the current API while removing limitations of the current
>>   implementation.
> 
> * Because the current wq implementation is already very widely used we
>   maintain compatibility with the API while removing above
>   mentioned limitations.

Replaced.

>> * Provide single unified worker pool per cpu which can be shared by
>>   all users.  The worker pool and level of concurrency should be
>>   regulated automatically so that the API users don't need to worry
>>   about that.
>>
>> * Use what's necessary and allocate resources lazily on demand while
>>   still maintaining forward progress guarantee where necessary.
>>
>>
>> == Unified worklist
>>
>> There's a single global cwq, or gcwq, per each possible cpu which
> 
>  ... global cwq (gcwq) per each possible cpu
> 
>> actually serves out the execution contexts.  cpu_workqueues or cwqs of
> 	
> 	cpu_workqueues (cwqs) 

Hmmm.... how about cpu_workqueue's (cwq)?

>> cmwq provides three different ordering modes - reentrant (default),
> 
> ... (default mode)...
> 
>> non-reentrant and single-cpu, where single-cpu can be used to achieve
>> single-threadedness and full ordering combined with in-flight work
>> limit of 1.  The default mode is basically the same as the original
> 
> The default mode (reentrant) is basically...
> 
>> implementation.  The distinction between non-reentrancy and single-cpu
>> were made because some ST wq users didn't really need single
>> threadedness but just non-reentrancy.
> 
>> Another area where things get more involved is workqueue flushing as
>> for flushing to which wq a work is queued matters.  cmwq tracks this
>> using colors.  When a work is queued to a cwq, it's assigned a color
>> and each cwq maintains counters for each work color.  The color
>> assignment changes on each wq flush attempt.  A cwq can tell that all
>> works queued before a certain wq flush attempt have finished by
>> waiting for all the colors upto that point to drain.  This maintains
>> the original workqueue flush semantics without adding unscalable
>> overhead.
> 
> [nice solution, btw]

I just wish the implementation were simpler.  It's a bit too complex
than I would like.  If anyone can simplify it, please go ahead and
give it a shot.

> There is only one gcwq? 
> Then maybe better:
> 
> _The_ gcwq is notified...
...
> also: 
> ... The gcwq keeps the number of concurrent ...
...
> here too: ..., the gcwq immediately schedules ...

Okay.

> * improved latency for current schedule_work() users, i.e. the work
>   get's executed in a more timely fashion?

Yeah, added.

I've updated the doc but I'm not really sure what I'm gonna do with
it.  I suppose I can include part of it in the head comment or I can
beef it up with use cases and howtos and put it under Documentations/.
Eh... let's see.  Anyways, thanks a lot.

-- 
tejun

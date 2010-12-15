Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab0LOPrW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 10:47:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:50623 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945Ab0LOPrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 10:47:21 -0500
Message-ID: <4D08E2FF.5090605@kernel.org>
Date: Wed, 15 Dec 2010 16:47:11 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@suse.de>
CC: Linux SCSI List <linux-scsi@vger.kernel.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] scsi: don't use execute_in_process_context()
References: <4CBD95C0.6060302@kernel.org>  <4CBD95DC.8000001@kernel.org>	 <1292194113.2989.9.camel@mulgrave.site>  <4D073E9A.3000608@kernel.org>	 <1292335754.3058.2.camel@mulgrave.site>  <4D077CD9.6050907@kernel.org>	 <1292336798.3058.5.camel@mulgrave.site>  <4D078052.3040800@kernel.org> <1292382245.19511.56.camel@mulgrave.site>
In-Reply-To: <1292382245.19511.56.camel@mulgrave.site>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 15 Dec 2010 15:47:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello James,

On 12/15/2010 04:04 AM, James Bottomley wrote:
>> Hmmm, I'm confused.  How does it drop the reference then?
> 
> Um, the same way it does in your new code: inside the executed function.

Okay, it wouldn't work that way.  They both are broken then.  It's
basically like trying put the last module reference from inside the
module.

>> Something outside of the callback should wait for its completion
>> and drop the reference as otherwise nothing can guarantee that the
>> modules doesn't go away between the reference drop and the actual
>> completion of the callback.
> 
> Well, if that's an actual problem, your patch doesn't solve it.  In both
> cases the work structure is part of the object that will be released.
> The way it should happen is that workqueues dequeue the work (so now no
> refs) and execute the callback with the data, so the callback is OK to
> free the work structure.  As long as it still does that, there's no
> problem in either case.

The workqueue code doesn't know anything about the specific work.  It
can't do that.  The work should be flushed from outside.

>>>> Compelling reason for it to exist.  Why not just use work when you
>>>> need execution context and the caller might or might not have one?
>>>
>>> Because it's completely lame to have user context and not use it.
>>
>> It may be lame but I think it's better than having an optimization
>> interface which is incomplete and, more importantly, unnecessary.
> 
> But you're thinking of it as a workqueue issue ... it isn't, it's an API
> which says "just make sure I have user context".  The workqueue is just
> the implementation detail.

Sure, yes, I understand what you're saying, but like everything else
it is a matter of tradeoff.

* It currently is incomplete in that it doesn't have a proper
  synchronization interface, and it isn't true that it's a simple
  interface which doesn't require synchronization.  No, it's not any
  simpler than directly using a workqueue.  How could it be?  It
  conditionally uses workqueue.  It needs the same level of
  synchronization.

* Which is all fine and dandy if it's something which brings actual
  benefits other than the perceived conceptual difference or avoidance
  of the feeling of lameness, but it doesn't.  At least not in the
  current users.  Even if you simply schedule work for the current
  users, nobody would notice.

* It existed for quite some time but failed to grow any new user.  It
  may be conceptually different but apparently there aren't many
  people looking for it.

The logical conclusion is to remove it and conver to work items in the
current few users and use the provided synchronization constructs to
fix the unlikely but still existing race condition.

>>> I really don't think the open coding is a good idea.  It's complex and
>>> error prone; exactly the type of thing that should be in an API.
>>
>> Yeah, just schedule work like everyone else.
> 
> As I said: the required open coding then becomes error prone.

No, don't open code atomicity test.  That's an unnecessary
optimization.  Schedule work directly whether you have context or not.
It just doesn't matter and isn't more complex than the current code.

One way or the other, the current code is racy.  The module can go
away while the work is still running.  We'll have to add sync
interface for ew's, which conceptually is fine but is unnecessary with
the current code base.  Let's do it when it actually is necessary.

I can refresh the patchset so that the relevant works are properly
flushed before the release of the relevant data structures.  Would
that be agreeable?

Thanks.

-- 
tejun

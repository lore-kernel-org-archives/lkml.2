Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613Ab0IHOLG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 10:11:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:57530 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264Ab0IHOLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 10:11:05 -0400
Message-ID: <4C87996F.2040805@kernel.org>
Date: Wed, 08 Sep 2010 16:10:55 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100825 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
        linux-fsdevel@vger.kernel.org
Subject: Re: [2.6.36-rc3] Workqueues, XFS, dependencies and deadlocks
References: <20100907072954.GM705@dastard> <4C86003B.6090706@kernel.org> <20100907100108.GN705@dastard> <4C861582.6080102@kernel.org> <4C862F8E.7030507@kernel.org> <20100908082249.GT705@dastard> <4C874E90.5040405@kernel.org> <20100908100503.GX705@dastard>
In-Reply-To: <20100908100503.GX705@dastard>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 08 Sep 2010 14:10:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 09/08/2010 12:05 PM, Dave Chinner wrote:
>> * Do you think @max_active > 1 could be useful for xfs?  If most works
>>   queued on the wq are gonna contend for the same (blocking) set of
>>   resources, it would just make more threads sleeping on those
>>   resources but otherwise it would help reducing execution latency a
>>   lot.
> 
> It may indeed help, but I can't really say much more than that right
> now. I need a deeper understanding of the impact of increasing
> max_active (I have a basic understanding now) before I could say for
> certain.

Sure, things should be fine as they currently stand.  No need to hurry
anything.

>> * xfs_mru_cache is a singlethread workqueue.  Do you specifically need
>>   singlethreadedness (strict ordering of works) or is it just to avoid
>>   creating dedicated per-cpu workers?  If the latter, there's no need
>>   to use singlethread one anymore.
> 
> Didn't need per-cpu workers, so could probably drop it now.

I see.  I'll soon send out a patch to convert xfs to use
alloc_workqueue() instead and will drop singlethread restriction
there.

>>   Maybe some of those workqueues can drop WQ_RESCUER or merged or just
>>   use the system workqueue?
> 
> Maybe the mru wq can use the system wq, but I'm really opposed to
> merging XFS wqs with system work queues simply from a debugging POV.
> I've lost count of the number of times I've walked the IO completion
> queueѕ with a debugger or crash dump analyser to try to work out if
> missing IO that wedged the filesystem got stuck on the completion
> queue. If I want to be able to say "the IO was lost by a lower
> layer", then I have to be able to confirm it is not stuck in a
> completion queue. That much harder if I don't know what the work
> container objects on the queue are....

Hmm... that's gonna be a bit more difficult with cmwq as all the works
are now queued on the shared worklist but you should still be able to
tell.  Maybe crash can be taught how to tell the associated workqueue
from a pending work.

Thanks.

-- 
tejun

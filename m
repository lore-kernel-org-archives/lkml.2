Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700Ab2ARTFL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 14:05:11 -0500
Received: from casper.infradead.org ([85.118.1.10]:52611 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756195Ab2ARTFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 14:05:09 -0500
Message-ID: <4F1717DF.8060809@kernel.dk>
Date: Wed, 18 Jan 2012 20:05:03 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Tejun Heo <tj@kernel.org>, Shaohua Li <shaohua.li@intel.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Kernel crash in icq_free_icq_rcu
References: <20120118010323.GA32160@htj.dyndns.org> <CANejiEUopG3MgUsvGMbkdHKrgBT_c+bir1bApt8p86kQn42huQ@mail.gmail.com> <20120118011112.GB32160@htj.dyndns.org> <1326850253.22361.619.camel@sli10-conroe> <1326866602.22361.624.camel@sli10-conroe> <20120118135126.GB30204@redhat.com> <20120118142005.GC30204@redhat.com> <20120118160957.GB30664@google.com> <4F16F245.9000708@kernel.dk> <4F16F3CA.90904@kernel.dk> <20120118163638.GD30204@redhat.com>
In-Reply-To: <20120118163638.GD30204@redhat.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-01-18 17:36, Vivek Goyal wrote:
> On Wed, Jan 18, 2012 at 05:31:06PM +0100, Jens Axboe wrote:
>> On 2012-01-18 17:24, Jens Axboe wrote:
>>> On 2012-01-18 17:09, Tejun Heo wrote:
>>>> On Wed, Jan 18, 2012 at 09:20:05AM -0500, Vivek Goyal wrote:
>>>>>> Not allocating icq if request is never going to go to elevator as elevator
>>>>>> switch was happening makes sense to me.
>>>>>>
>>>>>> I tried this patch. It went little further and crashed at a different
>>>>>> place. I think this seems to be separate merging issue Tejun is trying
>>>>>> to track down.
>>>>>
>>>>> Applied Tejun's debug patch to return early and not call into elevator
>>>>> for checking whether merge is allowed or not. Things seems to be stable
>>>>> now for me.
>>>>
>>>> Yeah, plug merge is calling into elevator code without any
>>>> synchronization, so it's bound to be broken.  Given plugging is
>>>> per-task, I don't think we really need to query elevator about merging
>>>> bio's.  The request is not on elevator and plugging is part of issuing
>>>> mechanism, not scheduling, after all.  Jens, what do you think?
>>>
>>> Hmmm. We can bypass asking the elevator, as long as we query the
>>> restrictions. Does the below, by itself, resolve the crash? If yes, let
>>> me cook up a patch splitting the elv and blk rq merging logic.
>>
>> Something like the below, completely untested.
>>
>> But thinking about this a bit while doing it, why is the IO scheduler
>> going away while we have plugged requests that are elvpriv?
> 
> Not calling ioscheduler during plug merge will allow merging of sync/async
> requests together. I guess we wouldn't want that. The only check we can
> skip in case of plug merge, is whether bio and rq beong to same task/cfqq
> or not.

It's not a huge concern. Since the IO is coming from the same task, it's
definitely related. And for the related cases, we pretty much always
want merging anyway.

> May be separate elevator functions for plug merge (without lock) and
> elevator merge (with lock) will do?

I don't think that's a good idea, just the restriction checking should
be enough.

-- 
Jens Axboe


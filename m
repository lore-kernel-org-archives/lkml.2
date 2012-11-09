Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab2KITtq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 14:49:46 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56881 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079Ab2KITtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 14:49:45 -0500
Message-ID: <509D5E53.2090902@kernel.dk>
Date: Fri, 09 Nov 2012 20:49:39 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Philipp Reisner <philipp.reisner@linbit.com>
CC: drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] drbd-8.4.2 for the linux-3.8 merge window
References: <3042269.jrNem7z1LI@fat-tyre> <509D10A3.8040203@kernel.dk> <509D1830.8010103@kernel.dk> <15372058.EgEfohI4mf@fat-tyre>
In-Reply-To: <15372058.EgEfohI4mf@fat-tyre>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-11-09 16:19, Philipp Reisner wrote:
> Am Freitag, 9. November 2012, 15:50:24 schrieb Jens Axboe:
>> On 2012-11-09 15:18, Jens Axboe wrote:
>>> On 2012-11-09 14:33, Philipp Reisner wrote:
>>>> Jens, here it is without the sysfs stuff
>>>
>>> Thanks, pulled into for-3.8/drivers
>>
>> I didn't say anything, but I've been fuming a bit the last few series of
>> merge windows. You need to stop these insanely massive pull requests.
>> I've been large since this is "just a driver", but it can't continue. We
>> should have reached stability a long time ago. Your pull requests
>> contain a shit load of items, are you guys paying per commit? Look at
>> these:
>>
>>       drbd: Request lookup code cleanup (1)
>>       drbd: Request lookup code cleanup (2)
>>       drbd: Request lookup code cleanup (3)
>>       drbd: Request lookup code cleanup (4)
>>
> 
> We are living there in the belief that we should break up big
> changes in review able chunks....

Don't be silly. Of course things should be broken up. But they should be
broken up in logical steps needed to convert from state X to Y. What
does reqeust code cleanup (1) mean? Nothing. Lets take a look at the
commit message:

    Move _ar_id_to_req() to drbd_receiver.c and mark it non-inline.  Remove
    the leading underscores from _ar_id_to_req() and _ack_id_to_req().  Mark
    ar_hash_slot() inline.

which is exactly the wrong way as well. A commit message should explain
why a given change is done. The above describes how it's done. We can
all read the code and see that.

In other words, you need to school people on what a commit is, and what
a series of commits is.

>> or
>>
>>       drbd: conn_send_cmd2(): Return 0 upon success and an error code
>> otherwise drbd: _conn_send_cmd(): Return 0 upon success and an error code
>> otherwise drbd: _drbd_send_cmd(): Return 0 upon success and an error code
>> otherwise drbd: conn_send_cmd(): Return 0 upon success and an error code
>> otherwise
>>
> 
> Function by function gets converted to the "return 0 upon success" call
> semantics.
> Do you prefer that all of that should be done in a single commit?

For this case, yes indeed. Then it'd make more sense to describe why
that change was made. For this particular one, it's fairly easy to guess
why the change was needed.

>> along with FIFTY or so more of these. WTF is this?
>>
>>       drbd: Converted helper functions for drbd_send() to tconn
>>       drbd: Converted drbd_send() from mdev to tconn
>>       drbd: Converted drbd_send_fp() from mdev to tconn
>>
> 
> Should it instead be in a single commit?
> 
>>
>> I don't think I need to go on. So from now on, to get items into the
>> kernel, what you will do is:
>>
>> - Stop doing insane commits like the above. It just doesn't make sense.
>>
>> - Send pull requests in a timely fashion. No more of this "lets collect
>>   ALL the things" then send it off. Collect small bug fixes, send those
>>   off. Develop some feature or make some changes, send that off. Etc.
> 
> That works well for individual features, and we have been doing that
> for the last two Years.
> 
> But at this time we changed the object model. In the old code we had
> a single kind of DRBD-in-kernel-object: a resource
> Now we have two kinds: resources and volumes.
> 
> 8.3: a resource had a single implicit volume
> 
> 8.4: a resource might contain multiple volumes, each volume belongs to
>      a single resource.
> 
> In the next ~12 month you will get only small features/updates etc... for
> the 8.4 code base.

If you had just structured it a bit better, then 8.3 -> 8.4 transition
would look a lot less painful. As it stands right now, it's just a huge
mess of little changes.

But I'm happy that you think that the next 12 months will have only
gradual changes for bug fixes and features.

>> The fact that your initial pull request had to MASK all these commits
>> should have rung big bells in your head. It's a clear sign of a huge
>> problem in your development model. If you can't clean this up, then
>> it's not going in.
> 
> Fundamental changes in our object model require such huge change sets.
> Jens, we will not stop where we are today. We plan to introduce a new
> object: a connection. (The ability to mirror for one machine to *multiple*
> receivers.)

If you think I'm asking you to stop developing, then you are completely
missing the message. I'm asking you to CHANGE how you develop, or at
least present, these changes. Tons of little changes reak of "hey lets
do this in this function. then lets also do this in that function". A
bit more structure would go a long way. What I usually do is that I may
develop from the first model, then refactor and structure everything to
look a lot nicer. A big part of being able to review a patch series is
understanding where it's going. Step 1 does this, step 2 does that, etc.
If you have 500 changes of "change return code from void to err/0",
well... It may be that you have nice structure underneath it and it's
just hidden behind this mess. If so, it'll be easier for you to make it
better.

> Is it a better fit to introduce it then as a new driver? 
> E.g. called it "drbd9". 
> Should it use a new major number?

No, I definitely don't want another "here's drbd9" submission. We've
already done that for v8, and it's not been smooth sailing.
Incrementally move things over, make it a more open and logical
development model.

-- 
Jens Axboe


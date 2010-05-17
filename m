Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab0EQJbz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 05:31:55 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:59665 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab0EQJbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 05:31:53 -0400
Message-ID: <4BF10BF1.3040108@ct.jp.nec.com>
Date: Mon, 17 May 2010 18:27:13 +0900
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       Vivek Goyal <vgoyal@redhat.com>, Nikanth Karthikesan <knikanth@suse.de>,
       Alasdair Kergon <agk@redhat.com>
Subject: Re: [RFC PATCH 2/2] dm: only initialize full request_queue for request-based
 device
References: <1273532139-23043-1-git-send-email-snitzer@redhat.com> <1273532139-23043-2-git-send-email-snitzer@redhat.com> <4BE8DBB0.5060701@ct.jp.nec.com> <20100511131502.GA25211@redhat.com> <4BEA659F.9050206@ct.jp.nec.com> <20100513035750.GA25523@redhat.com> <4BED049C.5040409@ct.jp.nec.com> <20100514140852.GA10373@redhat.com>
In-Reply-To: <20100514140852.GA10373@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On 05/14/2010 11:08 PM +0900, Mike Snitzer wrote:
> On Fri, May 14 2010 at  4:06am -0400,
> Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
> 
>> Hi Mike,
>>
>> On 05/13/2010 12:57 PM +0900, Mike Snitzer wrote:
>>> On Wed, May 12 2010 at  4:23am -0400,
>>> Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
>>>
>>>> Hi Mike,
>>>>
>>>> On 05/11/2010 10:15 PM +0900, Mike Snitzer wrote:
>>>>> It is clear we need to resolve the current full request_queue
>>>>> initialization that occurs even for bio-based DM devices.
>>>>>
>>>>> I believe the 2 patches I posted accomplish this in a stright-forward
>>>>> way.  We can always improve on it (by looking at what you proposed
>>>>> below) but we need a minimlaist fix that doesn't depend on userspace
>>>>> LVM2 changes right now.
>>>>
>>>> Humm, OK.
>>>> Indeed, showing iosched directory in bio-based device's sysfs is
>>>> confusing users actually, and we need something to resolve that soon.
>>>> So I don't strongly object to your approach as the first step, as long
>>>> as we can accept the risk of the maintenance cost which I mentioned.
>>>
>>> OK, I understand your concern (especially after having gone through this
>>> further over the past couple days).  I'm hopeful maintenance will be
>>> minimal.
snip
>> I feel your patch-set is growing and becoming complex fix rather than
>> minimalist/simple fix.
>> 
>> I think touching mapped_device/queue at table loading time makes
>> things complex.  It is natural that table's arguments are reflected
>> to mapped_device/queue at table binding time instead.
>
> Seems the numerous patches I've posted over the past couple days have
> given a false impression.  But I do understand your concern.
> 
> The longer-term direction you want to take DM (known type during
> alloc_dev) illustrates that we share a common goal: only do the precise
> work that is needed to initialize the request_queue for a DM device
> (whether it is bio-based or request-based).
> 
> My changes do accomplish that in the near-term without requiring
> userspace change.  Many of my proposed changes are just refactoring
> existing code to clearly split out what is needed for request-based vs
> bio-based.

As far as I understand, the current model of device-mapper is:
  - a table (precisely, a target) has various attributes,
    bio-based/request-based is one of such attributes
  - a table and its attributes are bound to the block device on resume
If we want to fix a problem, I think we should either work based on
this model or change the model.

Your patch makes that loading table affects the block device, so you
are changing the model.

If you change the model, it should be done carefully.
For example, the current model allows most of the table loading code
to run without exclusive lock on the device because it doesn't affect
the device itself.  If you change this model, table loading needs to
be serialized with appropriate locking.

My suggestion was (and is) to change the current model by determining
bio-based/request-based at device creation time, not by a table.


> I'll post a single patch that contains my changes (no need to have 2
> patches any more).  With that patch I'm hopeful you'll see my changes
> aren't as complex as they might have seemed over the past few days.
 
The number of patches doesn't matter.
I still feel it's becoming complex, for example it now has to take
care of reverting md/queue changes by previous preload.

Also, you have to take care of race condition between concurrent table
loadings which was mentioned above, because the table which was used to
initialized the queue may not be set in hc->new_map.
Although such races may not happen in real usages, they could cause
some critical problems (maybe kernel panic, maybe memory leak).

Thanks,
Kiyoshi Ueda
